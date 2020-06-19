000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Deal interface controller')                   *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  FXFXDLCTL - FX Deals Interface Controller                    *
001100200528      *                                                               *
001200200528      *  Function: This Program Validates FX Deals for Input into     *
001300200528      *            the Midas database.                                *
001400200528      *            Processes executed controlled by input Action Code *
001500200528      *            - For I (=Insert)                                  *
001600200528      *              - If ALL of the settlement fields are blank, set *
001700200528      *                them up from standard settlement instructions  *
001800200528      *            - For I (=Insert) or A (=Amend)                    *
001900200528      *              - Validate the settlement fields                 *
002000200528      *            - For A (=Amend) if it is valid, call a separate   *
002100200528      *              function to check whether it is a valid amendment*
002200200528      *            - For X (=Authorise) call a separate function to   *
002300200528      *              process this deal and bypass the rest of the     *
002400200528      *              validation                                       *
002500200528      *            - For D (=Delete) call a separate function to      *
002600200528      *              process this deal and bypass the rest of the     *
002700200528      *              validation                                       *
002800200528      *            For all action codes, the decision to as to        *
002900200528      *            whether to write to the Valid or Invalid file and  *
003000200528      *            the call to the Message Handler will take place    *
003100200528      *            in this module                                     *
003200200528      *                                                               *
003300200528      *  (c) Finastra International Limited 2001                      *
003400200528      *                                                               *
003500200604      *  Last Amend No. 251029             Date 22May20               *
003600200528      *  Prev Amend No. CSD102             Date 08Jan19               *
003700200528      *                 MD046248           Date 27Oct17               *
003800200528      *                 MD047971           Date 16Oct17               *
003900200528      *                 CDL099             Date 06Oct17               *
004000200528      *                 CDL094             Date 11Jun14               *
004100200528      *                 CSD095             Date 08Apr14               *
004200200528      *                 AR990243           Date 14Jun12               *
004300200528      *                 CSW212             Date 03May12               *
004400200528      *                 CSF011A            Date 28Nov11               *
004500200528      *                 CER059             Date 19Jul10               *
004600200528      *                 CER043             Date 19May08               *
004700200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004800200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
004900200528      *                 256564             Date 17Sep08               *
005000200528      *                 247888             Date 18May07               *
005100200528      *                 246352             Date 13Mar07               *
005200200528      * Midas Plus 1.4 Base ------------------------------------------*
005300200528      *                 245158             Date 19Jan07               *
005400200528      * Midas Plus 1.3 ----------- Base ------------------------------*
005500200528      *                 CDL049             Date 07Jul06               *
005600200528      *                 CSD027             Date 09Dec05               *
005700200528      *                 CLE031             Date 26Apr05               *
005800200528      *                 CDL038             Date 10May05               *
005900200528      *                 CFX114             Date 15Jun04               *
006000200528      *                 CDL018             Date 03Feb04               *
006100200528      *                 CSC022             Date 24Feb04               *
006200200528      *                 CGL029             Date 01Sep03               *
006300200528      *                 222373             Date 27Oct03               *
006400200528      *                 CAS006             Date 21Jan03               *
006500200528      *                 CAS005             Date 16Dec02               *
006600200528      *                 CRE008             Date 19Feb02               *
006700200528      *                 CDL010             Date 02Aug02               *
006800200528      *                 CAS004             Date 26Jun02               *
006900200528      * Midas Release 4.01.02 ----------------------------------------*
007000200528      *                 201083             Date 15May02               *
007100200528      *                 196952             Date 06May02               *
007200200528      *                 196461             Date 22Apr02               *
007300200528      * Midas Release 4.01 -------------------------------------------*
007400200528      *                 CAS001             Date 23Nov01               *
007500200528      *                 CSC011             Date 18Sep01               *
007600200528      *                 195763             Date 07Jan02               *
007700200528      * Midas Release 4 --------------- Base -------------------------*
007800200528      *                 200400             Date 20Nov01               *
007900200528      * Midas DBA 3.05 -----------------------------------------------*
008000200528      *                 190876             Date 08Mar01               *
008100200528      *                 CPB002             Date 08Aug00               *
008200200528      *                 185751             Date 17Nov00               *
008300200528      * Midas DBA 3.04 -----------------------------------------------*
008400200528      *                 179510             Date 06Nov00               *
008500200528      *                 CDL008             Date 02May00               *
008600200528      *                 166888             Date 08Sep99               *
008700200528      * Midas DBA 3.03 -----------------------------------------------*
008800200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
008900200528      *                 176883             Date 24Mar00               *
009000200528      * Midas DBA 3.02 -----------------------------------------------*
009100200528      *                 CAP051             Date 11Nov99               *
009200200528      *                 CPB001             Date 01Jun99               *
009300200528      *                 CAP013             Date 07Sep99               *
009400200528      *                 CAP011             Date 07Sep99               *
009500200528      *                 170909             Date 07Sep99               *
009600200528      *                 CAP033             Date 26Apr99               *
009700200528      * Midas DBA 3.00 -----------------Base--------------------------*
009800200528      *                 148855             Date 26Nov98               *
009900200528      *                 CAP004             Date 07Sep98               *
010000200528      *                 CAP003             Date 30Jul98               *
010100200528      *                 CAP002  *CREATE    Date 06OCT97               *
010200200528      *                                                               *
010300200528      *---------------------------------------------------------------*
010400200528      *                                                               *
010500200528      *  251029 - Handle file locking properly. Patterned after fix   *
010600200528      *           231306.                                             *
010700200528      *  CSD102 - Password Length Extension (Recompile)               *
010800200528      *  MD046248 - Finastra Rebranding                               *
010900200528      *  MD047971 - Do not allow amendment to settlement account if   *
011000200528      *             that side is already netted.                      *
011100200528      *  CDL099 - Split Value Date (Recompile)                        *
011200200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
011300200528      *           (Recompile)                                         *
011400200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
011500200528      *  AR990243 - Additional deliveries for CSW212                  *
011600200528      *  CSW212 - SWIFT 2012 Changes                                  *
011700200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
011800200528      *  CER059 - German Feature Upgrade to Delhi                     *
011900200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
012000200528      *           (Recompile)                                         *
012100200528      *  256564 - Recompile due to PF changes done by fix 256330      *
012200200528      *  247888 - Missing record in CLE025 files.                     *
012300200528      *  246352 - Applied core fix 224231.                            *
012400200528      *  224231 - CLS Deal in RPR default incorrect Nostro Code.      *
012500200528      *           Validate Trade details before defaulting settlements*
012600200528      *         - Bank to Bank Info. 6' field strangely defaulted to  *
012700200528      *           'N'. It should be blank when 'Bank to Bank Info. 1  *
012800200528      *           to 5' are blanks.                                   *
012900200528      *  245158 - APISERVER generates dumps for module FXVSODLNO.     *
013000200528      *           Pointer not set for location referenced.            *
013100200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
013200200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
013300200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
013400200528      *  CDL038 - Extended Deal Sub Type                              *
013500200528      *  CFX114 - Core changes for GBO014                             *
013600200528      *         - Perform Override when Exchange Rate Tolerance is    *
013700200528      *           exceeded.                                           *
013800200528      *         - Upgrade to Midasplus                                *
013900200528      *           Core hooks amended:FXFXDLCC03,FXFXDLC020            *
014000200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
014100200528      *           (Recompile)                                         *
014200200528      *  CSC022 - Commitment Control Changes for Midas Plus           *
014300200528      *  CGL029 - Increase Account Code to 10 digits                  *
014400200528      *  222373 - Correct parameters on program calls                 *
014500200528      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
014600200528      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
014700200528      *           (Recompile)                                         *
014800200528      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
014900200528      *  CDL010 - Prevent last user that actioned the trade from      *
015000200528      *           authorising it.Recompile due to changes in FXVFXDLPD*
015100200528      *  CAS004 - Hedge Accounting Phase A                            *
015200200528      *  201083 - Recompiled due to changes in PF/FXIFXDLPD.          *
015300200528      *  196952 - Ensure Rate has 5 digits before decimal separator   *
015400200528      *           and 8 digits after.                                 *
015500200528      *           Recompiled due to changes in FXFXDLPD and FXIFXDLPD.*
015600200528      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
015700200528      *  CAS001 - Net Present Value (NPV) Accounting                  *
015800200528      *  CSC011 - 24x7 Midas Availability                             *
015900200528      *  195763 - Recompiled due to recompiled FXFXDLVAL.             *
016000200528      *  200400 - Reverse fix 179510                                  *
016100200528      *  190876 - Reject Meridian interface deals with warnings.      *
016200200528      *           New warning if Counterparty is not a CLS Customer.  *
016300200528      *           Fix extended standard settlement instruction        *
016400200528      *           defaulting for CLS.                                 *
016500200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
016600200528      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
016700200528      *           to be used in the validation.                       *
016800200528      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
016900200528      *  CDL008 - Continuous Linked Settlement                        *
017000200528      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
017100200528      *           to defaulted value all the time. Apply GEMS 163745  *
017200200528      *           However, 163745 only fixes the problem for 'A' and  *
017300200528      *           'X' processing. Problem still exists for insert.    *
017400200528      *           Need to default only the 1st time validation is     *
017500200528      *           done. Do not re-default for subsequent validations. *
017600200528      *           Due to this 163745 in its original form is no       *
017700200528      *           longer required, now default required only for      *
017800200528      *           'first time insert'.                                *
017900200528      *  176883 - Errors found as a result of creating DBAR3.02       *
018000200528      *           Meridian repository file.                           *
018100200528      *           Mismatch on parameters for call to ZASETINDFT       *
018200200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
018300200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
018400200528      *           Recompiled due to changes in FXDEALPP               *
018500200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
018600200528      *  CAP011 - Substitution of Midas database flds for externl i/fs*
018700200528      *  170909 - Settlement instructions not updated on amendment    *
018800200528      *  CAP033 - Conversion of PM inputs into modular structure to   *
018900200528      *           use as APIs. Increased length of Transaction        *
019000200528      *           Reference ID from 6A to 20A.                        *
019100200528      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
019200200528      *           it through the ZACHNDQMS module, which is included  *
019300200528      *           in the DTAQCHK* /COPYs.                             *
019400200528      *  CAP004 - API's Phase 3.                                      *
019500200528      *           Add extra parm for Extra Data                       *
019600200528      *  CAP003 - Conversion of Midas inputs to modular API structure *
019700200528      *           Phase 2.  Module recompiled over changed /COPY      *
019800200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
019900200528      *                                                               *
020000200528      *****************************************************************
020100200528      ** +--------------------------------------+
020200200528      ** ¦ F-specs                              ¦
020300200528      ** ¦ =======                              ¦
020400200528      ** +--------------------------------------+
020500200528      *****************************************************************
020600200528
020700200528     FFXVFXDLPD UF A E             DISK    INFSR(*pssr)
020800200528     F                                     COMMIT
020900200528
021000200528     FFXIFXDLPD UF A E             DISK    INFSR(*pssr)
021100200528     F                                     COMMIT
021200200528
021300200528     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
021400200528     F                                     COMMIT
021500200528
021600200528     FFXVFXDLL0 IF   E           K DISK    RENAME(FXVFXDLD0:FXVFXDLCHK)
021700200528     F                                     INFSR(*pssr)                         CAP013
021800200528     FFXVFXDLL1 IF   E           K DISK    RENAME(FXVFXDLD0:FXVFXDLCK1)         CAP013
021900200528     F                                     INFSR(*pssr)                         CAP013
022000200528      ** FX/MM/FRA/IRS Extension files                                                        247888
022100200528     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
022200200528     F                                     INFSR(*pssr)                                       247888
022300200528     F                                     COMMIT                                             247888
022400200528                                                                                              190876
022500200528      ** SD Warning messages considered as errors                                             190876
022600200528     FSDWARNL1  IF   E           K DISK    INFSR(*PSSR)                                       190876
022700200528
022800200528     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
022900200528
023000200528      * Hook to enable non-core files to be included
023100200528      /COPY WNCPYSRC,FXFXDLC019
023200200528
023300200528      *****************************************************************
023400200528      ** +--------------------------------------+
023500200528      ** ¦ Automatically included D-specs       ¦
023600200528      ** ¦ ==============================       ¦
023700200528      ** +--------------------------------------+
023800200528      **
023900200528      ** Standard D-specs
024000200528      ** ================
024100200528      **
024200200528      ** The following /COPY line includes the LDA layout,
024300200528      ** the copyright array definition,
024400200528      ** and the following named constants:
024500200528      **    True       logical = *on (for indcator processing)
024600200528      **    False      logical = *off (for indcator processing)
024700200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
024800200528      **                                    handler)
024900200528      ** and the following variables:
025000200528      **    RunBefore  1A (for the PSSR)
025100200528
025200200528     D/COPY ZACPYSRC,STD_D_SPEC
025300200528
025400200528      ** Program Status Data Structure
025500200528      ** =============================
025600200528      ** The following /COPY line includes all the defined fields in the
025700200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
025800200528
025900200528     D/COPY ZACPYSRC,PSDS
026000200528      ** The following /COPY line includes definitions for the above fields
026100200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
026200200528      ** corresponding fields in the PSDS /COPY member, so that member
026300200528      ** must be included where this one is used.
026400200528
026500200528     D/COPY ZACPYSRC,PROCPARMS
026600200528
026700200528      **--------------------------------------------------------------------------------------------
026800200528      ** The following /COPY line includes the definitions for error and
026900200528      ** warning message arrays.
027000200528     D/COPY ZACPYSRC,ERR_ARRAYS
027100200528      **--------------------------------------------------------------------------------------------
027200200528
027300200528      **--------------------------------------------------------------------------------------------
027400200528      ** The following /COPY line includes the definitions for arrays
027500200528      ** specific to API *CTL modules.
027600200528     D/COPY ZACPYSRC,APICTLARR
027700200528      **--------------------------------------------------------------------------------------------
027800200528
027900200528      **--------------------------------------------------------------------------------------------
028000200528      ** The following /COPY line includes the definitions for fields           148855
028100200528      ** used in checking whether there are messages on the data queue.         148855
028200200528     D/COPY ZACPYSRC,DTAQCHKDCL                                                 148855
028300200528      **--------------------------------------------------------------------------------------------
028400200528
028500200528      ** +--------------------------------------+
028600200528      ** ¦ End of automatically included D-specs¦
028700200528      ** ¦ =====================================¦
028800200528      ** +--------------------------------------+
028900200528
029000200528      *****************************************************************
029100200528      /EJECT
029200200528      *****************************************************************
029300200528
029400200528      ** +--------------------------------------+
029500200528      ** ¦ Manually included D-specs            ¦
029600200528      ** ¦ =========================            ¦
029700200528      ** +--------------------------------------+
029800200528
029900200528      ** +--------------------------------------+
030000200528      ** ¦ Named constants                      ¦
030100200528      ** ¦ ===============                      ¦
030200200528      ** +--------------------------------------+
030300200528
030400200528      ** String for error messages to the operator
030500200528     D ProcErr         C                   CONST('Error in module')
030600200528
030700200528      ** +--------------------------------------+
030800200528      ** ¦ Arrays and Data Structures           ¦
030900200528      ** ¦ ==========================           ¦
031000200528      ** +--------------------------------------+
031100200528
031200200528      * Incoming Header
031300200528     D HeadIn        E DS                  EXTNAME(APHEADPD)
031400200528
031500200528     D TranIn        E DS                  EXTNAME(FXFXDLPD)
031600200528      * Incoming Transaction
031700200528
031800200528     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
031900200528      * Valid Deals layout
032000200528     D FXDLRecIns            400    468
032100200528     D FXDLPayIns            469   1027
032200200528     D FXDLPayISDA          1394   2043                                                       CSW212
032300200528      * Large fields to include
032400200528      * - Receive instructions (xxRSTM to xxROCN)
032500200528      * - Pay     instructions (xxPSTM to xxBTB6)
032600200528
032700200528     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)
032800200528     D FXDEALDORI    E                     EXTFLD(QQDORI)                                     CGL029
032900200528     D FXDEALMORI    E                     EXTFLD(QQMORI)                                     CGL029
033000200528     D FXDEALDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
033100200528     D FXDEALMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
033200200528     D FXDEALRONS    E                     EXTFLD(QQRONS)                                     CGL029
033300200528     D FXDEALPONS    E                     EXTFLD(QQPONS)                                     CGL029
033400200528      * (Current) Deal in File Format
033500200528     D*DEALRecIns            400    468                                                       CGL029
033600200528     D DEALRecIns1           400    401                                                       CGL029
033700200528     D DEALRecIns2           414    468                                                       CGL029
033800200528     D*DEALPayIns            469   1027                                                       CGL029
033900200528     D DEALPayIns1           469    470                                                       CGL029
034000200528     D DEALPayIns2           483   1027                                                       CGL029
034100200528     D DEALPayISDA          1394   2043                                                       CSW212
034200200528      * Large fields to include
034300200528      * - Receive instructions (xxRSTM to xxROCN)
034400200528      * - Pay     instructions (xxPSTM to xxBTB6)
034500200528
034600200528     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)
034700200528     D                                     PREFIX(@)
034800200528      * (Current) Deal in Screen Format
034900200528
035000200528     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
035100200528      * Pay Settlement Instructions - Input
035200200528
035300200528     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
035400200528      * Receive Settlement Instructions - Input
035500200528
035600200528     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
035700200528      * FRA/IRS Settlement Instructions - Input
035800200528
035900200528     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
036000200528      * Pay Settlement Instructions - Current                                   CAP011
036100200528                                                                                CAP011
036200200528     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
036300200528      * Receive Settlement Instructions - Current                               CAP011
036400200528                                                                                CAP011
036500200528     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
036600200528      * FRA/IRS Settlement Instructions - Current                               CAP011
036700200528                                                                                CAP011
036800200528     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
036900200528      * Pay Settlement Instructions - File (D/B) format
037000200528     D FLPAY2                 21    565                                                       CGL029
037100200528
037200200528     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
037300200528      * Receive Settlement Instructions - File (D/B) format
037400200528     D FLREC2                 21     75                                                       CGL029
037500200528
037600200528     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
037700200528      * FRA/IRS Settlement Instructions - File (D/B) format
037800200528     D FLISDA2                 1    650                                                       CSW212
037900200528                                                                                CAP051
038000200528     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
038100200528      * FX Extra Data - Classe 1 Data - File (D/B) format                       CAP051
038200200528     D                                     PREFIX(IF_)                          CAP051
038300200528                                                                                CAP004
038400200528     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
038500200528      * FX Extra Data - File (D/B) format                                       CAP004
038600200528                                                                                CAP051
038700200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
038800200528      ** External DS for SAR details                                            CAP051
038900200528
039000200528     D DSFDY         E DS                  EXTNAME(DSFDY)
039100200528      * First DS for Access programs - short data structure
039200200528
039300200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
039400200528      ** External DS for Bank Details
039500200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
039600200528      ** External DS for API ICD                                                CAP011
039700200528
039800200528     D*DtqRec**********DS            54                                         148855
039900200528     ******DS*for*Data*Queue****************************************************148855
040000200528     D**MsgNumber******        8     11B 0                                      148855
040100200528     D*DtqMsgSel*******DS             7                                         148855
040200200528     D**MsgType********        1      1    INZ('F')                             148855
040300200528     D**MsgBytes*******        4      7B 0                                      148855
040400200528                                                                                148855
040500200528     D FXFXDLUPC       DS             1    DTAARA(FXFXDLUPC)
040600200528
040700200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
040800200528      ** 24X7 status data area                                                                CSC011
040900200528                                                                                              CSC011
041000200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
041100200528      ** SD data area                                                                         CSC011
041200200528      ** Data structure for data area commitment control                                      CSC022
041300200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
041400200528     D  ComitJobs              4    103A                                                      CSC022
041500200528                                                                                              CSC022
041600200528     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
041700200528      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
041800200528                                                                                              CSC011
041900200528      ** +--------------------------------------+
042000200528      ** ¦ Declared variables                   ¦
042100200528      ** ¦ ==================                   ¦
042200200528      ** +--------------------------------------+
042300200528
042400200528      ** Error message field(s)
042500200528     D     Msg1        S                   LIKE(#MsgID)
042600200528
042700200528      ** Index for arrays of error message ids etc
042800200528     D Idx             S              3P 0
042900200528
043000200528      ** Index for arrays of warning message ids etc
043100200528     D WIdx            S              3P 0
043200200528
043300200528      ** Field (500A) to receive the incoming transaction
043400200528     D Trans500        S            500A
043500200528                                                                                CAP051
043600200528      ** Field (500A) to receive the incoming Extra Data                        CAP051
043700200528     D InfData500      S            500A                                        CAP051
043800200528                                                                                CAP004
043900200528      ** Field (500A) to receive the incoming Extra Data                        CAP004
044000200528     D ExtData500      S            500A                                        CAP004
044100200528
044200200528      ** Index for arrays of error message ids etc in Amend validation
044300200528     D AmIdx           S              3P 0
044400200528
044500200528      ** Indicies for arrays used to set up corresponding sequence numbers
044600200528      **  for the fields that are in error
044700200528     D Ix              S              3P 0
044800200528     D Iy              S              3P 0
044900200528
045000200528      ** Flags to indicate whether transaction fields are valid
045100200528     D OKFlagsDS       DS
045200200528     D  DDActnOK                      1A   INZ('Y')
045300200528     D  DDDlnoOK                      1A   INZ('Y')
045400200528     D  DDDltpOK                      1A   INZ('Y')
045500200528     D  DDDlstOK                      1A   INZ('Y')
045600200528     D  DDFedfOK                      1A   INZ('Y')
045700200528     D  DDDldtOK                      1A   INZ('Y')
045800200528     D  DDBrsnOK                      1A   INZ('Y')
045900200528     D  DDBrkrOK                      1A   INZ('Y')
046000200528     D  DDBkrgOK                      1A   INZ('Y')
046100200528     D  DDSdnoOK                      1A   INZ('Y')
046200200528     D  DDCustOK                      1A   INZ('Y')
046300200528     D  DDVdatOK                      1A   INZ('Y')
046400200528     D  DDOdatOK                      1A   INZ('Y')
046500200528     D  DDBokcOK                      1A   INZ('Y')
046600200528     D  DDLnknOK                      1A   INZ('Y')
046700200528     D  DDPtfrOK                      1A   INZ('Y')
046800200528     D  DDBccyOK                      1A   INZ('Y')
046900200528     D  DDBamtOK                      1A   INZ('Y')
047000200528     D  DDNbuyOK                      1A   INZ('Y')
047100200528     D  DDRateOK                      1A   INZ('Y')
047200200528     D  DDFpntOK                      1A   INZ('Y')
047300200528     D  DDSignOK                      1A   INZ('Y')
047400200528     D  DDMginOK                      1A   INZ('Y')
047500200528     D  DDMbsiOK                      1A   INZ('Y')
047600200528     D  DDSccyOK                      1A   INZ('Y')
047700200528     D  DDSamtOK                      1A   INZ('Y')
047800200528     D  DDPrfcOK                      1A   INZ('Y')
047900200528     D  DDNselOK                      1A   INZ('Y')
048000200528     D  DDBceOK                       1A   INZ('Y')
048100200528     D  DDOrbrOK                      1A   INZ('Y')
048200200528     D  DDDbsrOK                      1A   INZ('Y')
048300200528     D  DDBbfpOK                      1A   INZ('Y')
048400200528     D  DDBbfsOK                      1A   INZ('Y')
048500200528     D  DDSbfpOK                      1A   INZ('Y')
048600200528     D  DDSbfsOK                      1A   INZ('Y')
048700200528     D  DDMtchOK                      1A   INZ('Y')
048800200528     D  DDCLSSOK                      1A   INZ('Y')                             CDL008
048900200528     D  DDOYLCOK                      1A   INZ('Y')                                           CAS001
049000200528     D  DDTYLCOK                      1A   INZ('Y')                                           CAS001
049100200528     D  DDCLASOK                      1A   INZ('Y')                                           CDL038
049200200528     D/COPY WNCPYSRC,FXH00059
049300200528
049400200528      ** Flags to indicate whether Pay Settlement instruction fields
049500200528      **  are valid
049600200528     D OKPayInsDS      DS
049700200528     D  DDPscyOK                      1A   INZ('Y')
049800200528     D  DDPstmOK                      1A   INZ('Y')
049900200528     D  DDPonxOK                      1A   INZ('Y')
050000200528     D  DDRvnoOK                      1A   INZ('Y')
050100200528     D  DDCvmrOK                      1A   INZ('Y')
050200200528     D  DDPocnOK                      1A   INZ('Y')
050300200528     D  DDPobnOK                      1A   INZ('Y')
050400200528     D  DDRcrnOK                      1A   INZ('Y')
050500200528     D  DDRcraOK                      1A   INZ('Y')
050600200528     D  DDPibnOK                      1A   INZ('Y')
050700200528     D  DDPibaOK                      1A   INZ('Y')
050800200528     D  DDAwbnOK                      1A   INZ('Y')
050900200528     D  DDAwbaOK                      1A   INZ('Y')
051000200528     D  DDBennOK                      1A   INZ('Y')
051100200528     D  DDBenaOK                      1A   INZ('Y')
051200200528     D  DDDtp1OK                      1A   INZ('Y')
051300200528     D  DDDtp2OK                      1A   INZ('Y')
051400200528     D  DDDtp3OK                      1A   INZ('Y')
051500200528     D  DDDtp4OK                      1A   INZ('Y')
051600200528     D  DDDchgOK                      1A   INZ('Y')
051700200528     D  DDIc72OK                      1A   INZ('Y')
051800200528     D  DDBtb1OK                      1A   INZ('Y')
051900200528     D  DDBtb2OK                      1A   INZ('Y')
052000200528     D  DDBtb3OK                      1A   INZ('Y')
052100200528     D  DDBtb4OK                      1A   INZ('Y')
052200200528     D  DDBtb5OK                      1A   INZ('Y')
052300200528     D  DDBtb6OK                      1A   INZ('Y')
052400200528
052500200528      ** Flags to indicate whether Receive Settlement instruction fields
052600200528      **  are valid
052700200528     D OKRecInsDS      DS
052800200528     D  DDRscyOK                      1A   INZ('Y')
052900200528     D  DDRstmOK                      1A   INZ('Y')
053000200528     D  DDRonxOK                      1A   INZ('Y')
053100200528     D  DDRocnOK                      1A   INZ('Y')
053200200528     D  DDRobnOK                      1A   INZ('Y')
053300200528     D  DDRibnOK                      1A   INZ('Y')
053400200528     D  DDRibaOK                      1A   INZ('Y')
053500200528
053600200528      ** Flags to indicate whether FRA/IRS instruction fields are valid
053700200528     D OKFRAInsDS      DS
053800200528     D  DDDsr1OK                      1A   INZ('Y')
053900200528     D  DDDsr2OK                      1A   INZ('Y')
054000200528     D  DDDsr3OK                      1A   INZ('Y')
054100200528     D  DDDsr4OK                      1A   INZ('Y')
054200200528     D  DDDsr5OK                      1A   INZ('Y')
054300200528     D  DDDsr6OK                      1A   INZ('Y')
054400200528     D  DDSsr1OK                      1A   INZ('Y')
054500200528     D  DDSsr2OK                      1A   INZ('Y')
054600200528     D  DDSsr3OK                      1A   INZ('Y')
054700200528     D  DDSsr4OK                      1A   INZ('Y')
054800200528     D  DDSsr5OK                      1A   INZ('Y')
054900200528     D  DDSsr6OK                      1A   INZ('Y')
055000200528     D  DDCnd1OK                      1A   INZ('Y')
055100200528     D  DDCnd2OK                      1A   INZ('Y')
055200200528     D  DDCnd3OK                      1A   INZ('Y')
055300200528     D  DDCnd4OK                      1A   INZ('Y')
055400200528     D  DDCnd5OK                      1A   INZ('Y')
055500200528     D  DDCnd6OK                      1A   INZ('Y')
055600200528     D  DDIsdaOK                      1A   INZ('Y')
055700200528     D  DDAgtyOK                      1A   INZ('Y')
055800200528     D  DDAgdtOK                      1A   INZ('Y')
055900200528     D  DDAgvvOK                      1A   INZ('Y')
056000200528
056100200528
056200200528      ** Overall Transaction status, to be passed to the Message Handler
056300200528     D TranStatus      S              1A
056400200528
056500200528      ** Module ID, to be passed to the Message Handler
056600200528     D ModuleID        S              2A
056700200528
056800200528      ** A code to indicate the calling function to the lower level modules
056900200528     D FXDL            S              4A   INZ('FXDL')
057000200528
057100200528      ** Payment & Receipt dates, passed to Settlements Validation routine.
057200200528      ** spaces in parameter list not used by this function
057300200528     D PayDat          S              5P 0 INZ(99999)
057400200528     D RecDat          S              5P 0 INZ(99999)
057500200528
057600200528      ** Value Date as a Midas Day Number to be placed in either Payment
057700200528      **  or Receipt Date
057800200528     D ValDateMDN      S              5P 0
057900200528
058000200528      ** Blank fields, passed to Settlements Defaulting routine, to fill
058100200528      ** spaces in parameter list not used by this function
058200200528     D Blank2          S              2A   INZ(*BLANKS)
058300200528     D Blank4          S              4A   INZ(*BLANKS)
058400200528     D Blank6          S              6A   INZ(*BLANKS)
058500200528
058600200528      ** Error Flag for call to Standard routines (equates to *IN99)
058700200528     D ErrorFlag       S              1A   INZ('N')
058800200528
058900200528      ** Timestamp for the transaction
059000200528     D TimeStamp       S               Z
059100200528
059200200528      ** Receive / Pay Settlement Currency, Method & Nostro
059300200528     D RecSetCcy       S              3A
059400200528     D RecSetMeth      S              2S 0
059500200528     D RecNostro       S             18A                                                      CDL038
059600200528     D*RecNostro*******S             12A                                                      CDL038
059700200528     D PaySetCcy       S              3A
059800200528     D PaySetMeth      S              2S 0
059900200528     D PayNostro       S             18A                                                      CDL038
060000200528     D*PayNostro*******S             12A                                                      CDL038
060100200528
060200200528     ****Data*queue*parms*******************************************************148855
060300200528
060400200528     D*DtqLenB*********S              9B 0                                      148855
060500200528     D*DtqFmt**********S              8A                                        148855
060600200528     D*DtqNamLib*******S             20A                                        148855
060700200528     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
060800200528     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
060900200528     D*DtqMsgFmt*******S              8A                                        148855
061000200528     D*DtqErr**********S             50A                                        148855
061100200528
061200200528     D Object          S             10A   INZ('FXFXDLUPC')
061300200528     D Lib             S             10A   INZ('*LIBL')
061400200528     D ObjType         S              7A
061500200528     D LockState       S              7A   INZ('*SHRRD')
061600200528     D Member          S             10A
061700200528     D WaitTime        S              6A   INZ('0     ')
061800200528     D Dlcobj          S              1A   INZ('Y')
061900200528     D Return          S              7A
062000200528
062100200528      ** Dummy message ID and message file fields for use on the calls to
062200200528      ** ZAMSGTOOPR
062300200528     D DummyMsgID      S                   LIKE(#MsgID)
062400200528     D DummyMsgF       S             10A
062500200528
062600200528      ** Fields defined for enhancement CSC011                                                CSC011
062700200528                                                                                              CSC011
062800200528     D CSC011          S              1A                                                      CSC011
062900200528     D TRANSDTL        S           5800A                                                      CSC011
063000200528     D*PDealNum        S             18A                                               CSC011 CGL029
063100200528     D*PADealNum       S             18A                                               CSC011 CGL029
063200200528     D PDealNum        S             24A                                                      CGL029
063300200528     D PADealNum       S             24A                                                      CGL029
063400200528     D PRtCd           S              7A                                                      CSC011
063500200528     D POptn           S              7A                                                      CSC011
063600200528     D PSard           S              6A                                                      CSC011
063700200528                                                                                              CSC011
063800200528      ** Whether or not to clear the program message queue                                    222373
063900200528     D ClearPgmQ       S              1A                                                      222373
064000200528      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
064100200528     D CSC022          S              1A                                                      CSC022
064200200528     D WSkpCom         S              1A                                                      CSC022
064300200528     D WPos            S              2S 0                                                    CSC022
064400200528
064500200528      ** +--------------------------------------+
064600200528      ** ¦ End of D-specs                       ¦
064700200528      ** ¦ ==============                       ¦
064800200528      ** +--------------------------------------+
064900200528
065000200528      ** +----------------------------------------+
065100200528      ** ¦ Hook for non-core D-specs (all types)  ¦
065200200528      ** ¦ also any I-specs (if necessary)        ¦
065300200528      ** ¦ =====================================  ¦
065400200528      ** +----------------------------------------+
065500200528      /COPY WNCPYSRC,FXFXDLC020
065600200528
065700200528      *****************************************************************
065800200528      /EJECT
065900200528      *****************************************************************
066000200528      ** +--- Start of Main processing -----------------------------------+
066100200528      ** ¦                                                                ¦
066200200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
066300200528      ** ¦ executed at program activation.                                ¦
066400200528      ** ¦                                                                ¦
066500200528      ** +----------------------------------------------------------------+
066600200528
066700200528      /COPY WNCPYSRC,FXFXDLC001
066800200528
066900200528      * Incoming transaction is in a 500A field, so that a common CLP
067000200528      * can be used between this module and the one that read the MQ queue.
067100200528      * This module needs to break that 500A by loading it into the
067200200528      * appropriate (externally described) data structure.
067300200528     C                   MOVEL     Trans500      TranIn
067400200528     C                   MOVEL     Infdata500    Infdata                        CAP051
067500200528     C                   MOVEL     Extdata500    Extdata                        CAP004
067600200528
067700200528      ** Generate a timestamp for this transaction
067800200528
067900200528     C                   CALLB     'ZAGENTMSTM'
068000200528     C                   PARM                    TimeStamp
068100200528
068200200528      * Reset variables gradually updated
068300200528
068400200528     C                   EXSR      RESETCYCLE
068500200528
068600200528      /COPY WNCPYSRC,FXFXDLC002
068700200528
068800200528      *  Check if valid deal exists for Front Office ID
068900200528
069000200528     C                   EXSR      ChkValDeal
069100200528      *
069200200528      *  If valid deal does exist (even after delay), fail this input
069300200528      *
069400200528     C     Idx           IFNE      0
069500200528     C                   GOTO      INVALID
069600200528     C                   END
069700200528                                                                                CAP013
069800200528      *  Check if valid deal exists for Midas Deal Number                       CAP013
069900200528                                                                                CAP013
070000200528     C                   EXSR      ChkValMiDl                                   CAP013
070100200528      *                                                                         CAP013
070200200528      *  If valid deal does exist (even after delay), fail this input           CAP013
070300200528      *                                                                         CAP013
070400200528     C     Idx           IFNE      0                                            CAP013
070500200528     C                   GOTO      INVALID                                      CAP013
070600200528     C                   END                                                    CAP013
070700200528
070800200528      * Reset variables again in case the details have been corrupted
070900200528      * by previous chain to valid deals file.
071000200528
071100200528     C                   EXSR      RESETCYCLE
071200200528
071300200528      /COPY WNCPYSRC,FXFXDLC003
071400200528
071500200528      *  Validate Action Code
071600200528
071700200528     C                   EXSR      ValidateAc
071800200528      *
071900200528      /COPY WNCPYSRC,FXFXDLC004
072000200528
072100200528      *  If error in validation of action code, fail this input
072200200528      *
072300200528     C     Idx           IFNE      0
072400200528     C                   GOTO      INVALID
072500200528     C                   END
072600200528
072700200528      *  Processing depends upon Action Code
072800200528
072900200528     C                   SELECT
073000200528
073100200528     C                   WHEN      DDACTN = 'I'
073200200528      *  Processing for Inserts
073300200528      /COPY WNCPYSRC,FXFXDLC005
073400200528     C**********         EXSR      DftSettmts                                                 224231
073500200528      /COPY WNCPYSRC,FXFXDLC006
073600200528     C                   EXSR      ValidateTr
073700200528     C                   EXSR      DftSettmts                                                 224231
073800200528      /COPY WNCPYSRC,FXFXDLC007
073900200528     C                   EXSR      ValidateSt
074000200528      /COPY WNCPYSRC,FXFXDLC008
074100200528
074200200528     C                   WHEN      DDACTN = 'A'
074300200528      *  Processing for Amends
074400200528      /COPY WNCPYSRC,FXFXDLC009
074500200528     C     GHSUBS        ifne      *blank                                       CAP011
074600200528     C     GHSUBS        scan      TranIn                                 99    CAP011
074700200528     C     *in99         ifeq      *on                                          CAP011
074800200528     C                   EXSR      TDtDtaSubs                                   CAP011
074900200528     C                   endif                                                  CAP011
075000200528     C                   endif                                                  CAP011
075100200528     C                   EXSR      SetupAmend
075200200528      /COPY WNCPYSRC,FXFXDLC010
075300200528     C                   EXSR      ValidateTr
075400200528      /COPY WNCPYSRC,FXFXDLC011
075500200528     C                   EXSR      ValidateSt
075600200528      /COPY WNCPYSRC,FXFXDLC012
075700200528     C                   EXSR      ValdateAmd
075800200528      /COPY WNCPYSRC,FXFXDLC013
075900200528
076000200528     C                   ENDSL
076100200528      *
076200200528     C     INVALID       TAG
076300200528
076400200528      *  Check for exception error from any program lower in the stack
076500200528      *  If error detected, send message to system operator and
076600200528      *  return to calling program without updating database or
076700200528      *  prompting the database update program
076800200528     C                   IN        APDUMP
076900200528
077000200528      /COPY WNCPYSRC,FXFXDLC014
077100200528
077200200528     C     ARERRMOD      IFNE      *BLANK
077300200528     C                   EVAL      MQErrlong  = *blank
077400200528     C                   MOVEL     ProcErr       MQError
077500200528     C                   MOVE      ARERRMOD      MQError          28
077600200528     C                   MOVEL     MQError       MQErrlong
077700200528
077800200528     C                   CALLB     'ZAMSGTOOPR'
077900200528     C                   PARM                    MQReturn         10
078000200528     C                   PARM                    MQErrlong       132
078100200528     C                   PARM                    DummyMsgID
078200200528     C                   PARM                    DummyMsgF
078300200528
078400200528     C                   MOVEL     ARERRMOD      APRETCODE
078500200528     C     *LOCK         IN        APDUMP
078600200528     C                   EVAL      ARERRMOD = *BLANK
078700200528     C                   OUT       APDUMP
078800200528     C                   RETURN
078900200528
079000200528     C                   ELSE
079100200528
079200200528      *  Processing for Error checking/write to database
079300200528      /COPY WNCPYSRC,FXFXDLC015
079400200528     C                   EXSR      CheckWrite
079500200528      /COPY WNCPYSRC,FXFXDLC016
079600200528
079700200528      *  If valid, send data queue entry to prompt DB update program
079800200528     C     Idx           IFEQ      0
079900200528     C                   EVAL      ObjType = '*DTAARA'
080000200528      *  Check if update program active using Allocate Object API
080100200528      *  No prompting necessary if program is running
080200200528     C                   CALLB     'APCALCOBJ'
080300200528     C                   PARM                    Object
080400200528     C                   PARM                    Lib
080500200528     C                   PARM                    ObjType
080600200528     C                   PARM                    LockState
080700200528     C                   PARM                    Member
080800200528     C                   PARM                    WaitTime
080900200528     C                   PARM                    Dlcobj
081000200528     C                   PARM      *BLANK        Return
081100200528     C     Return        IFEQ      *BLANK
081200200528      *  Check if any messages are already on the data queue
081300200528      *  No need to send duplicate prompt messages
081400200528
081500200528      **--------------------------------------------------------------------------------------------
081600200528      ** The following /COPY line includes a check for whether there            148855
081700200528      ** are messages on the server/updater data queue, and sends a 'GO'.       148855
081800200528      ** message to the data queue if there are not.                            148855
081900200528     D/COPY ZACPYSRC,DTAQCHK                                                    148855
082000200528      **--------------------------------------------------------------------------------------------
082100200528
082200200528     C*******************EVAL      DtqLenB = 54                                 148855
082300200528     C*******************EVAL      DtqNamLib = 'APFXDLDTQ *LIBL'                148855
082400200528     C*******************EVAL      MsgBytes = 8                                 148855
082500200528     C*******************CALL      'QMHRDQM'                                    148855
082600200528     C*******************PARM                    DtqRec                         148855
082700200528     C*******************PARM                    DtqLenB                        148855
082800200528     C*******************PARM      'RDQM0100'    DtqFmt                         148855
082900200528     C*******************PARM                    DtqNamLib                      148855
083000200528     C*******************PARM                    DtqMsgSel                      148855
083100200528     C*******************PARM                    DtqMsgLen                      148855
083200200528     C*******************PARM      'RDQS0100'    DtqMsgFmt                      148855
083300200528     C*******************PARM                    DtqErr                         148855
083400200528      *******************                                                       148855
083500200528     C*****MsgNumber*****IFEQ      DtqComp                                      148855
083600200528     C*******************CALL      'QSNDDTAQ'                                   148855
083700200528     C*******************PARM      'APFXDLDTQ'   DtqNam           10            148855
083800200528     C*******************PARM      '*LIBL'       DtqLib           10            148855
083900200528     C*******************PARM                    DtqLen            5 0          148855
084000200528     C*******************PARM      'GO'          DtqDta           10            148855
084100200528     C*******************END                                                    148855
084200200528     C                   END
084300200528     C                   END
084400200528     C                   END
084500200528
084600200528     C                   RETURN
084700200528      *****************************************************************
084800200528
084900200528      * Hook to enable non-core subroutines to be included
085000200528      /COPY WNCPYSRC,FXFXDLC021
085100200528
085200200528      *****************************************************************
085300200528      /EJECT
085400200528      *****************************************************************
085500200528      *                                                               *
085600200528      * ChkValDeal - Routine to check if valid deal exists for        *
085700200528      *    Front Office ID and Front Office Associated ID             *
085800200528      *                                                               *
085900200528      *****************************************************************
086000200528
086100200528     C     ChkValDeal    BEGSR
086200200528
086300200528      * Check for deal on Valid file
086400200528     C     APFOTranID    CHAIN     FXVFXDLL0                          99
086500200528
086600200528      * If record found...
086700200528     C     *IN99         IFEQ      '0'
086800200528
086900200528      * ..delay, then repeat check
087000200528     C                   CALLB     'ZACDELAY'
087100200528
087200200528     C     APFOTranID    CHAIN     FXVFXDLL0                          99
087300200528
087400200528      * Error if still present
087500200528     C     *IN99         IFEQ      '0'
087600200528     C                   ADD       1             Idx
087700200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
087800200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
087900200528     C                   ENDIF
088000200528     C                   ENDIF
088100200528
088200200528
088300200528      * Check for associated deal on Valid file
088400200528     C     APFOAsocID    IFNE      *BLANK
088500200528
088600200528     C     APFOAsocID    CHAIN     FXVFXDLL0                          99
088700200528
088800200528      * If record found...
088900200528     C     *IN99         IFEQ      '0'
089000200528
089100200528      * ..delay, then repeat check
089200200528     C                   CALLB     'ZACDELAY'
089300200528
089400200528     C     APFOAsocID    CHAIN     FXVFXDLL0                          99
089500200528
089600200528      * Error if still present
089700200528     C     *IN99         IFEQ      '0'
089800200528     C                   ADD       1             Idx
089900200528     C*******************EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
090000200528     C                   EVAL      FldNameArr(Idx) = 'DDSDNO'                   CAP013
090100200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
090200200528     C                   ENDIF
090300200528
090400200528     C                   ENDIF
090500200528     C                   ENDIF
090600200528      *
090700200528     C                   ENDSR
090800200528      *****************************************************************
090900200528      /EJECT                                                                    CAP013
091000200528      *****************************************************************         CAP013
091100200528      *                                                               *         CAP013
091200200528      * ChkValMiDl - Routine to check if valid deal exists for        *         CAP013
091300200528      *    Midas Deal Number                                          *         CAP013
091400200528      *                                                               *         CAP013
091500200528      *****************************************************************         CAP013
091600200528                                                                                CAP013
091700200528     C     ChkValMiDl    BEGSR                                                  CAP013
091800200528                                                                                CAP013
091900200528      * If (numeric) Midas deal number supplied                                 CAP013
092000200528                                                                                CAP013
092100200528     C                   TESTN                   DDDLNO               9898      CAP013
092200200528                                                                                CAP013
092300200528     C     DDDLNO        IFNE      *BLANKS                                      CAP013
092400200528     C     *IN98         ANDEQ     '1'                                          CAP013
092500200528                                                                                CAP013
092600200528      * Check for deal on Valid file                                            CAP013
092700200528     C                   MOVEL     DDDLNO        F3DN38                         CAP013
092800200528     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
092900200528                                                                                CAP013
093000200528      * If record found...                                                      CAP013
093100200528     C     *IN99         IFEQ      '0'                                          CAP013
093200200528                                                                                CAP013
093300200528      * ..delay, then repeat check                                              CAP013
093400200528     C                   CALLB     'ZACDELAY'                                   CAP013
093500200528                                                                                CAP013
093600200528     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
093700200528                                                                                CAP013
093800200528      * Error if still present                                                  CAP013
093900200528     C     *IN99         IFEQ      '0'                                          CAP013
094000200528     C                   ADD       1             Idx                            CAP013
094100200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
094200200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
094300200528     C                   ENDIF                                                  CAP013
094400200528     C                   ENDIF                                                  CAP013
094500200528                                                                                CAP013
094600200528     C                   ENDIF                                                  CAP013
094700200528                                                                                CAP013
094800200528      * If (numeric) Midas associated deal number supplied                      CAP013
094900200528                                                                                CAP013
095000200528     C                   TESTN                   DDSDNO               9898      CAP013
095100200528                                                                                CAP013
095200200528     C     DDSDNO        IFNE      *BLANK                                       CAP013
095300200528     C     *IN98         ANDEQ     '1'                                          CAP013
095400200528                                                                                CAP013
095500200528      * Check for associated deal on Valid file                                 CAP013
095600200528     C                   MOVEL     DDSDNO        F3DN38                         CAP013
095700200528     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
095800200528                                                                                CAP013
095900200528      * If record found...                                                      CAP013
096000200528     C     *IN99         IFEQ      '0'                                          CAP013
096100200528                                                                                CAP013
096200200528      * ..delay, then repeat check                                              CAP013
096300200528     C                   CALLB     'ZACDELAY'                                   CAP013
096400200528                                                                                CAP013
096500200528     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
096600200528                                                                                CAP013
096700200528      * Error if still present                                                  CAP013
096800200528     C     *IN99         IFEQ      '0'                                          CAP013
096900200528     C                   ADD       1             Idx                            CAP013
097000200528     C                   EVAL      FldNameArr(Idx) = 'DDSDNO'                   CAP013
097100200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
097200200528     C                   ENDIF                                                  CAP013
097300200528                                                                                CAP013
097400200528     C                   ENDIF                                                  CAP013
097500200528     C                   ENDIF                                                  CAP013
097600200528      *                                                                         CAP013
097700200528     C                   ENDSR                                                  CAP013
097800200528      *****************************************************************         CAP013
097900200528      /EJECT
098000200528      *****************************************************************
098100200528      *                                                               *
098200200528      * ValidateAc - Routine to validate action code versus the       *
098300200528      *    transaction IDs supplied                                   *
098400200528      *                                                               *
098500200528      *****************************************************************
098600200528
098700200528     C     ValidateAc    BEGSR
098800200528      *                                                                         CAP013
098900200528      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
099000200528      *  if insert                                                              CAP013
099100200528      *  if not insert and Midas transaction ID is not present                  CAP013
099200200528      * Otherwise                                                               CAP013
099300200528      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
099400200528      *                                                                         CAP013
099500200528     C     DDACTN        IFEQ      'I'                                          CAP013
099600200528     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
099700200528     C                   ELSE                                                   CAP013
099800200528     C     DDDLNO        IFEQ      *BLANK                                       CAP013
099900200528     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
100000200528     C                   ELSE                                                   CAP013
100100200528     C                   MOVEL     '      '      ModeofOp                       CAP013
100200200528     C                   ENDIF                                                  CAP013
100300200528     C                   ENDIF                                                  CAP013
100400200528     C/COPY WNCPYSRC,FXFXDLCC04
100500200528
100600200528      * Validate action code versus transaction IDs supplied
100700200528      * This function will set the Midas deal number and the Midas
100800200528      * associated deal number.
100900200528      * The deal in file format from the FX database is retrieved as well.
101000200528
101100200528     C                   RESET                   ReturnCode
101200200528     C                   CALLB     'FXFXDLRTV'
101300200528
101400200528      * INPUTS
101500200528
101600200528      * Return code
101700200528     C                   PARM                    ReturnCode
101800200528
101900200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
102000200528      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
102100200528     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
102200200528     C                   PARM                    ModeofOp          6            CAP013
102300200528      *
102400200528      * Response mode
102500200528     C                   PARM                    APRESPMODE
102600200528
102700200528      * Action Code
102800200528     C                   PARM                    DDACTN
102900200528
103000200528      * Front Office Transaction ID
103100200528     C                   PARM                    APFOTranID
103200200528
103300200528      * Front Office Associated Transaction Id
103400200528     C                   PARM                    APFOAsocID
103500200528
103600200528      * (Midas) Deal Number
103700200528     C                   PARM                    DDDLNO
103800200528
103900200528      * (Midas) Swap/Option Deal Number
104000200528     C                   PARM                    DDSDNO
104100200528
104200200528      * Booking branch
104300200528     C                   PARM                    DDBRSN
104400200528
104500200528      * Originating branch
104600200528     C                   PARM                    DDORBR
104700200528
104800200528      * OUTPUTS
104900200528
105000200528      * (Current) deal in file format
105100200528     C                   PARM                    DealFilFmt
105200200528
105300200528      * OK - Action code
105400200528     C                   PARM                    DDActnOK
105500200528
105600200528      * OK - Deal Number
105700200528     C                   PARM                    DDDlnoOK
105800200528
105900200528      * OK - Booking branch
106000200528     C                   PARM                    DDBrsnOK
106100200528      *
106200200528      * OK - Originating branch
106300200528     C                   PARM                    DDOrbrOK
106400200528
106500200528      * Error fields/message IDs/message data (arrays) from/to caller
106600200528     C                   PARM                    FldNameArr
106700200528     C                   PARM                    MsgIDArr
106800200528     C                   PARM                    MsgDtaArr
106900200528
107000200528      * Array index (3P0) from/to caller
107100200528     C                   PARM                    Idx
107200200528                                                                                              CAS004
107300200528      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
107400200528                                                                                              CAS004
107500200528     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
107600200528     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
107700200528     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
107800200528                                                                                              CAS004
107900200528      ** Warning array index (3P0) from/to caller                                             CAS004
108000200528                                                                                              CAS004
108100200528     C                   PARM      *ZEROS        WIdx                                         CAS004
108200200528     C/COPY WNCPYSRC,FXFXDLCC02
108300200528
108400200528     C                   ENDSR
108500200528      *****************************************************************
108600200528      /EJECT
108700200528      *****************************************************************
108800200528      *                                                               *
108900200528      * DftSettmts - Routine to apply default settlement instructions *
109000200528      *    if none have been supplied                                 *
109100200528      *                                                               *
109200200528      *****************************************************************
109300200528
109400200528     C     DftSettmts    BEGSR
109500200528
109600200528      ** 'Bank to Bank Info. 6' field strangely defaulted to 'N'. It should be                224231
109700200528      ** blank when 'Bank to Bank Info. 1 to 5' are blanks.                                   224231
109800200528      *                                                                                       224231
109900200528     C     DDBTB1        IFEQ      *BLANKS                                                    224231
110000200528     C     DDBTB2        ANDEQ     *BLANKS                                                    224231
110100200528     C     DDBTB3        ANDEQ     *BLANKS                                                    224231
110200200528     C     DDBTB4        ANDEQ     *BLANKS                                                    224231
110300200528     C     DDBTB5        ANDEQ     *BLANKS                                                    224231
110400200528     C                   MOVE      *BLANKS       DDBTB6                                       224231
110500200528     C                   ENDIF                                                                224231
110600200528      *                                                                                       224231
110700200528      * If ANY of the Settlements fields have been entered, bypass this
110800200528      *  routine.
110900200528      * Otherwise, use modules which will use Standard Settlement
111000200528      *  Instructions to apply defaults.
111100200528
111200200528     C                   IF            (InRecSttmt = *blank)
111300200528     C                             AND (InPaySttmt = *blank)
111400200528
111500200528      ** CL Transaction type for CLS                                                          190876
111600200528                                                                                              190876
111700200528     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                              190876
111800200528     C                   EVAL      DealType = 'CL'                                            190876
111900200528     C                   ELSE                                                                 190876
112000200528     C                   EVAL      DealType = DDDLTP                                          190876
112100200528     C                   ENDIF                                                                190876
112200200528                                                                                              190876
112300200528     C/COPY WNCPYSRC,FXFXDLCC05
112400200528     C                   CALLB     'ZASETINDFT'
112500200528     C/COPY WNCPYSRC,FXFXDLCC06
112600200528
112700200528      ** Output
112800200528      ** Calling function type
112900200528     C                   PARM                    FXDL
113000200528      ** Payment currency
113100200528     C                   PARM                    DDSCCY
113200200528      ** Receive currency
113300200528     C                   PARM                    DDBCCY
113400200528     C/COPY WNCPYSRC,FXFXDLCC11
113500200528      ** Customer (shortname or number)
113600200528     C                   PARM                    DDCUST
113700200528      ** Deal type
113800200528     C***********        PARM                    DDDLTP                                       190876
113900200528     C                   PARM                    DealType          2                          190876
114000200528      ** Federal Funds Ind.
114100200528     C                   PARM                    DDFEDF
114200200528      ** ISDA Rules for FRA/IRS deals only
114300200528      ** Version of ISDA Rules govern
114400200528     C                   PARM                    Blank4
114500200528      ** Type of ISDA agreement
114600200528     C                   PARM                    Blank6
114700200528      ** Date of ISDA Agreement
114800200528     C                   PARM                    Blank6
114900200528      ** Version of ISDA Agreement
115000200528     C                   PARM                    Blank2
115100200528      ** Version of ISDA Agreement century                                                    176883
115200200528     C                   PARM                    Blank2                                       176883
115300200528      ** Deal Subtype                                                                         CSD095
115400200528     C                   PARM                    DDDLST                                       CSD095
115500200528      ** Branch                                                                               CSD095
115600200528     C                   PARM                    DDBRSN                                       CSD095
115700200528      *
115800200528      ** Return
115900200528      ** Defaulted Payment Settlement Instruction in file format
116000200528     C                   PARM                    DBPaySttmt
116100200528      ** Defaulted Receipt Settlement Instruction in file format
116200200528     C                   PARM                    DBRecSttmt
116300200528      ** Defaulted FRA/IRS Settlement Instruction in file format
116400200528     C                   PARM                    DBFRASttmt
116500200528     C/COPY WNCPYSRC,FXFXDLCC09
116600200528
116700200528      *  The defaulted instructions are in file format, but the
116800200528      *   Settlements validation requires that they are in the input format.
116900200528      *  Therefore run them through a conversion module.
117000200528
117100200528     C                   CALLB     'ZASETINCVT'
117200200528      ** Defaulted Settlement Instructions in file format
117300200528     C                   PARM                    DBPaySttmt
117400200528     C                   PARM                    DBRecSttmt
117500200528     C                   PARM                    DBFRASttmt
117600200528
117700200528      ** Defaulted Settlement Instruction in input format
117800200528     C                   PARM                    InPaySttmt
117900200528     C                   PARM                    InRecSttmt
118000200528     C                   PARM                    InFRASttmt
118100200528     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
118200200528     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A
118300200528
118400200528     C                   ENDIF
118500200528
118600200528     C                   ENDSR
118700200528      *****************************************************************
118800200528      /EJECT
118900200528      *****************************************************************
119000200528      *                                                               *
119100200528      * SETUPAMEND - Set up fields that are needed in the validation  *
119200200528      *    of Amendments.                                             *
119300200528      *                                                               *
119400200528      *****************************************************************
119500200528
119600200528     C     SetupAmend    BEGSR
119700200528
119800200528      * For Amends, put the complete (pre-existing) deal into the Valid
119900200528      *  file record - fields in this will be updated during  processing
120000200528     C                   MOVE      DealFilFmt    ValidDeal
120100200528
120200200528      ***The*Settlement*Instructions*fields*may*not*be*supplied*for*an*****     CAP011
120300200528      ***amendment.*If*none*of*the*pay/receive*instructions*were***********     CAP011
120400200528      ***supplied*(i.e.*all*are*blank),*default*the*existing*database******     CAP011
120500200528      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
120600200528      *********************************************************************     CAP011
120700200528     C*******************IF************(InRecSttmt*=**blank)***************     CAP011
120800200528     C*****************************AND*(InPaySttmt*=**blank)***************     CAP011
120900200528
121000200528     C**********         EVAL      DBRecSttmt = DEALRecIns + FHROBR                           CGL029
121100200528     C                   EVAL      DBRecSttmt = DEALRecIns1 + FHRONS +                        CGL029
121200200528     C                                          DEALRecIns2 + FHROBR                          CGL029
121300200528     C                   EVAL      FLRSCY     = FHRSCY
121400200528     C**********         EVAL      DBPaySttmt = DEALPayIns + FHPOBR + FHCVMR                  CGL029
121500200528     C                   EVAL      DBPaySttmt = DEALPayIns1 + FHPONS +                        CGL029
121600200528     C                                          DEALPayIns2 + FHPOBR + FHCVMR                 CGL029
121700200528     C                   EVAL      FLPSCY     = FHPSCY
121800200528     C                   EVAL      FLIC72     = FHIC72
121900200528     C     CSW212        IFEQ      'Y'                                                        CSW212
122000200528     C**********         MOVE      F3AGVC        FLAGVC                              CSW212 AR990243
122100200528     C                   EVAL      DBFRASttmt = DEALPayISDA                                 AR990243
122200200528     C                   ENDIF                                                                CSW212
122300200528
122400200528      *  .... and then convert these to the screen format
122500200528     C                   CALLB     'ZASETINCVT'
122600200528
122700200528      ** Defaulted Settlement Instructions in file format
122800200528     C                   PARM                    DBPaySttmt
122900200528     C                   PARM                    DBRecSttmt
123000200528     C                   PARM                    DBFRASttmt
123100200528                                                                                CAP011
123200200528      ** Current Settlement Instruction in input format                         CAP011
123300200528     C                   PARM                    CrPaySttmt                     CAP011
123400200528     C                   PARM                    CrRecSttmt                     CAP011
123500200528     C                   PARM                    CrFRASttmt                     CAP011
123600200528     C                   PARM      FHCCY1        #TRCCY                                      CSF011A
123700200528     C                   PARM      FHCCY2        #TPCCY                                      CSF011A
123800200528                                                                                CAP011
123900200528      *  If no Payment or Receive instructions have been supplied               CAP011
124000200528      *  Default them to those currently on the deal.                           CAP011
124100200528                                                                                CAP011
124200200528     C                   IF            (InPaySttmt = *blank)                    CAP011
124300200528     C                   EVAL      InPaySttmt = CrPaySttmt                      CAP011
124400200528     C                   ENDIF                                                  CAP011
124500200528                                                                                CAP011
124600200528     C                   IF            (InRecSttmt = *blank)                    CAP011
124700200528     C                   EVAL      InRecSttmt = CrRecSttmt                      CAP011
124800200528     C                   ENDIF                                                  CAP011
124900200528                                                                                CAP011
125000200528     C                   IF            (InFRASttmt = *blank)                                AR990243
125100200528     C                   EVAL      InFRASttmt = CrFRASttmt                                  AR990243
125200200528     C                   ENDIF                                                              AR990243
125300200528                                                                                            AR990243
125400200528      * Do data substitution for Settlement Instructions                        CAP011
125500200528                                                                                CAP011
125600200528     C     GHSUBS        ifne      *blank                                       CAP011
125700200528     C     GHSUBS        scan      InPaySttmt                             99    CAP011
125800200528     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
125900200528     C  N99GHSUBS        scan      InFRASttmt                             99                AR990243
126000200528     C     *in99         ifeq      *on                                          CAP011
126100200528     C                   EXSR      SDtDtaSubs                                   CAP011
126200200528     C                   endif                                                  CAP011
126300200528     C                   endif                                                  CAP011
126400200528
126500200528      ***Defaulted*Settlement*Instruction*in*input*format**                     CAP011
126600200528     C*******************PARM********************InPaySttmt                     CAP011
126700200528     C*******************PARM********************InRecSttmt                     CAP011
126800200528     C*******************PARM********************InFRASttmt                     CAP011
126900200528      *****************************************************                     CAP011
127000200528     C*******************ENDIF*****************************                     CAP011
127100200528
127200200528     C                   ENDSR
127300200528      *****************************************************************
127400200528      /EJECT
127500200528      *****************************************************************
127600200528      *                                                               *
127700200528      * ValidateTr - Routine to validate the main tranaction details  *
127800200528      *                                                               *
127900200528      *****************************************************************
128000200528
128100200528     C     ValidateTr    BEGSR
128200200528
128300200528     C                   CALLB     'FXFXDLVAL'
128400200528      * Response mode (1A), from source system common header
128500200528     C                   PARM                    APRespMode
128600200528      * Transaction information (DS) from source system
128700200528     C                   PARM                    TranIn
128800200528     C                   PARM                    InfData                        CAP051
128900200528      * Receive Settlement Currency, Method & Nostro and
129000200528      * Payment Settlement Currency, Method & Nostro
129100200528      * Extra Data                                                              CAP004
129200200528     C                   PARM      *BLANK        RecSetCcy
129300200528     C                   PARM      *ZERO         RecSetMeth
129400200528     C                   PARM                    RecNostro
129500200528     C                   PARM      *BLANK        PaySetCcy
129600200528     C                   PARM      *ZERO         PaySetMeth
129700200528     C                   PARM                    PayNostro
129800200528     C                   PARM      FHFRNT        @@FRNT           20            CPB002
129900200528     C                   PARM                    ExtData                        CAP004
130000200528     C/COPY WNCPYSRC,FXFXDLCC01
130100200528      *
130200200528      * NET BUY/SELL REFERENCE
130300200528     C                   PARM                    DDNBRF
130400200528     C                   PARM                    DDNSRF
130500200528      * Field OK flags (DS) from/to caller
130600200528     C                   PARM                    OKFlagsDS
130700200528      * Error fields/message IDs/message data (arrays) from/to caller
130800200528     C                   PARM                    FldNameArr
130900200528     C                   PARM                    MsgIDArr
131000200528     C                   PARM                    MsgDtaArr
131100200528      * Array index (3P0) from/to caller
131200200528     C                   PARM                    Idx
131300200528      * Warning fields/message IDs/message data (arrays) from/to caller
131400200528     C                   PARM                    WFldNamArr
131500200528     C                   PARM                    WMsgIDArr
131600200528     C                   PARM                    WMsgDtaArr
131700200528      * Array index (3P0) from/to caller
131800200528     C                   PARM                    WIdx
131900200528      * Valid Deals layout (DS) from/to caller
132000200528     C                   PARM                    ValidDeal
132100200528     C                   PARM                    F3DTYP                                       245158
132200200528     C/COPY WNCPYSRC,FXFXDLCC03
132300200528
132400200528     C                   ENDSR
132500200528      *****************************************************************
132600200528      /EJECT
132700200528      *****************************************************************
132800200528      *                                                               *
132900200528      * ValidateSt - Routine to validate the settlemnt instructions   *
133000200528      *                                                               *
133100200528      *****************************************************************
133200200528
133300200528     C     ValidateSt    BEGSR
133400200528
133500200528      * The called module requires that the customer number/name is valid,
133600200528      *  if it is not, exit from this subroutine.
133700200528     C                   IF        NOT (DDCustOK = 'Y')
133800200528     C                   GOTO      ValSetExit
133900200528     C                   ENDIF
134000200528
134100200528      * The called module uses the value date in Midas Day Number format,
134200200528      *  which will not have been returned from the overall validation
134300200528      *  routine, so it needs to be converetd here.
134400200528
134500200528     C                   IF        DDVDatOK <> 'N'
134600200528
134700200528     C                   CALLB     'ZDATE1'
134800200528     C                   PARM                    DDVDAT
134900200528     C                   PARM                    ValDateMDN
135000200528     C                   PARM                    BJDFIN
135100200528     C                   PARM                    ErrorFlag
135200200528
135300200528      * Set the Pay Date and Receive Date = Value Date
135400200528
135500200528     C                   EVAL      PayDat = ValDateMDN
135600200528     C                   EVAL      RecDat = ValDateMDN
135700200528
135800200528     C                   ENDIF
135900200528
136000200528      ** CL Transaction type for CLS                                                          190876
136100200528                                                                                              190876
136200200528     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                              190876
136300200528     C                   EVAL      DealType = 'CL'                                            190876
136400200528     C                   ELSE                                                                 190876
136500200528     C                   EVAL      DealType = DDDLTP                                          190876
136600200528     C                   ENDIF                                                                190876
136700200528                                                                                              190876
136800200528     C                   RESET                   ReturnCode
136900200528     C/COPY WNCPYSRC,FXFXDLCC07
137000200528     C                   CALLB     'ZASETINVAL'
137100200528     C/COPY WNCPYSRC,FXFXDLCC08
137200200528
137300200528      ** Return Code
137400200528     C                   PARM                    ReturnCode
137500200528      ** Following parameters are output to called module
137600200528      ** Calling function type
137700200528     C                   PARM                    FXDL
137800200528      ** Transaction Fields
137900200528      ** Payment currency
138000200528     C                   PARM                    DDSCCY
138100200528      ** Receive currency
138200200528     C                   PARM                    DDBCCY
138300200528      ** Customer (shortname or number)
138400200528     C                   PARM                    DDCUST
138500200528      ** Deal type
138600200528     C***********        PARM                    DDDLTP                                       190876
138700200528     C                   PARM                    DealType                                     190876
138800200528      ** Federal Funds Ind.
138900200528     C                   PARM                    DDFEDF
139000200528      ** Booking Branch
139100200528     C                   PARM                    DDBRSN
139200200528      ** Receipt Date
139300200528     C                   PARM                    RecDat
139400200528      ** Payment Date
139500200528     C                   PARM                    Paydat
139600200528      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
139700200528     C                   PARM                    InPaySttmt
139800200528     C                   PARM                    InRecSttmt
139900200528     C                   PARM                    InFRASttmt
140000200528      * Action Code                                                                           185751
140100200528     C                   PARM                    DDACTN                                       185751
140200200528      * Protect Payment Field                                                                 196461
140300200528     C                   PARM                    ##PPAY            1                          196461
140400200528      * Protect Receipt Field                                                                 196461
140500200528     C                   PARM                    ##PREC            1                          196461
140600200528
140700200528      ** Following parameters are returned by called module
140800200528      ** Payment Instruction OK flag
140900200528     C                   PARM                    OKPayInsDS
141000200528      ** Receive Instruction OK flag
141100200528     C                   PARM                    OKRecInsDS
141200200528      ** FRA/IRS Instruction OK flag
141300200528     C                   PARM                    OKFRAInsDS
141400200528      * Error fields/message IDs (arrays) from/to caller
141500200528     C                   PARM                    FldNameArr
141600200528     C                   PARM                    MsgIDArr
141700200528      * Array index (3P0) from/to caller
141800200528     C                   PARM                    Idx
141900200528      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
142000200528     C                   PARM                    WFldNamArr                                   CRE008
142100200528     C                   PARM                    WMsgIDArr                                    CRE008
142200200528     C                   PARM                    WMsgDtaArr                                   CRE008
142300200528      ** Array index (3P0) from/to caller                                                     CRE008
142400200528     C                   PARM                    WIdx                                         CRE008
142500200528      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
142600200528     C                   PARM                    DBPaySttmt
142700200528     C                   PARM                    DBRecSttmt
142800200528     C                   PARM                    DBFRASttmt
142900200528      ** Extra Input                                                                          166888
143000200528      ** Action Code used                                                                     166888
143100200528     C                   PARM      DDACTN        ##ACTN            1                          166888
143200200528      ** Validation Iteration                                                                 166888
143300200528     C                   PARM      '1ST'         ##ValIter         3                          166888
143400200528     C/COPY WNCPYSRC,FXFXDLCC10
143500200528      ************                                                                     179510 200400
143600200528      **MIDAS*Our*Receive/*Pay*Instructions*(for*Settlm*Meth*=*04*)******              179510 200400
143700200528     C************       PARM                    @MORPI           24                   179510 200400
143800200528      ************                                                                     179510 200400
143900200528
144000200528     C     ValSetExit    TAG
144100200528
144200200528     C                   ENDSR
144300200528      *****************************************************************
144400200528      /EJECT                                                                    CAP011
144500200528      *****************************************************************         CAP011
144600200528      *                                                               *         CAP011
144700200528      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
144800200528      *                                                               *         CAP011
144900200528      *****************************************************************         CAP011
145000200528                                                                                CAP011
145100200528     C     TDtDtaSubs    BEGSR                                                  CAP011
145200200528                                                                                CAP011
145300200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
145400200528                                                                                CAP011
145500200528     C                   RESET                   ReturnCode                     CAP011
145600200528     C                   CALLB     'FXFXDLCVT'                                  CAP011
145700200528                                                                                CAP011
145800200528      * INPUTS                                                                  CAP011
145900200528      * Return Code                                                             CAP011
146000200528     C                   PARM                    ReturnCode                     CAP011
146100200528      * (Current) Deal in file format                                           CAP011
146200200528     C                   PARM                    DealFilfmt                     CAP011
146300200528                                                                                CAP011
146400200528      * OUTPUTS                                                                 CAP011
146500200528      * (Current) Deal in screen format                                         CAP011
146600200528     C                   PARM                    DealScnfmt                     CAP011
146700200528      * NET BUY/SELL REFERENCE                                                  CAP011
146800200528     C                   PARM                    DDNBRF           19            CAP011
146900200528     C                   PARM                    DDNSRF           19            CAP011
147000200528      * Deal Status                                                             CAP011
147100200528     C                   PARM                    DDSTS            24            CAP011
147200200528                                                                                CAP011
147300200528      ** DATA SUBSTITUTION                                                      CAP011
147400200528                                                                                CAP011
147500200528     C                   RESET                   ReturnCode                     CAP011
147600200528     C                   CALLB     'APDTASUBS'                                  CAP011
147700200528                                                                                CAP011
147800200528      * Return Code                                                             CAP011
147900200528     C                   PARM                    ReturnCode       10            CAP011
148000200528      * Substitution character                                                  CAP011
148100200528     C                   PARM      GHSUBS        SubsChar          1            CAP011
148200200528      * Incoming Data                                                           CAP011
148300200528     C                   PARM      TranIn        IncDATA        2000            CAP011
148400200528      * Current Data                                                            CAP011
148500200528     C                   PARM      DealScnfmt    CurDATA        2000            CAP011
148600200528                                                                                CAP011
148700200528     C                   MOVEL     IncDATA       TranIn                         CAP011
148800200528                                                                                CAP011
148900200528     C                   ENDSR                                                  CAP011
149000200528      *****************************************************************         CAP011
149100200528      /EJECT                                                                    CAP011
149200200528      *****************************************************************         CAP011
149300200528      *                                                               *         CAP011
149400200528      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
149500200528      *                                                               *         CAP011
149600200528      *****************************************************************         CAP011
149700200528                                                                                CAP011
149800200528     C     SDtDtaSubs    BEGSR                                                  CAP011
149900200528                                                                                CAP011
150000200528      ** PAYMENT INSTRUCTIONS                                                   CAP011
150100200528     C                   RESET                   ReturnCode                     CAP011
150200200528     C                   CALLB     'APDTASUBS'                                  CAP011
150300200528                                                                                CAP011
150400200528      * Return Code                                                             CAP011
150500200528     C                   PARM                    ReturnCode                     CAP011
150600200528      * Substitution character                                                  CAP011
150700200528     C                   PARM      GHSUBS        SubsChar                       CAP011
150800200528      * Incoming Data                                                           CAP011
150900200528     C                   PARM      InPaySttmt    IncDATA                        CAP011
151000200528      * Current Data                                                            CAP011
151100200528     C                   PARM      CrPaySttmt    CurDATA                        CAP011
151200200528                                                                                CAP011
151300200528     C                   MOVEL     IncDATA       InPaySttmt                     CAP011
151400200528                                                                                CAP011
151500200528      ** RECEIPT INSTRUCTIONS                                                   CAP011
151600200528     C                   RESET                   ReturnCode                     CAP011
151700200528     C                   CALLB     'APDTASUBS'                                  CAP011
151800200528                                                                                CAP011
151900200528      * Return Code                                                             CAP011
152000200528     C                   PARM                    ReturnCode                     CAP011
152100200528      * Substitution character                                                  CAP011
152200200528     C                   PARM      GHSUBS        SubsChar                       CAP011
152300200528      * Incoming Data                                                           CAP011
152400200528     C                   PARM      InRecSttmt    IncDATA                        CAP011
152500200528      * Current Data                                                            CAP011
152600200528     C                   PARM      CrRecSttmt    CurDATA                        CAP011
152700200528                                                                                CAP011
152800200528     C                   MOVEL     IncDATA       InRecSttmt                     CAP011
152900200528      ** Extended Settlements                                                               AR990243
153000200528     C                   RESET                   ReturnCode                                 AR990243
153100200528     C                   CALLB     'APDTASUBS'                                              AR990243
153200200528                                                                                            AR990243
153300200528      * Return Code                                                                         AR990243
153400200528     C                   PARM                    ReturnCode                                 AR990243
153500200528      * Substitution character                                                              AR990243
153600200528     C                   PARM      GHSUBS        SubsChar                                   AR990243
153700200528      * Incoming Data                                                                       AR990243
153800200528     C                   PARM      InFRASttmt    IncDATA                                    AR990243
153900200528      * Current Data                                                                        AR990243
154000200528     C                   PARM      CrFRASttmt    CurDATA                                    AR990243
154100200528                                                                                            AR990243
154200200528     C                   MOVEL     IncDATA       InFRASttmt                                 AR990243
154300200528                                                                                CAP011
154400200528     C                   ENDSR                                                  CAP011
154500200528      *****************************************************************         CAP011
154600200528      /EJECT
154700200528      *****************************************************************
154800200528      *                                                               *
154900200528      * ValdateAmd - Routine to check whether the fields amended      *
155000200528      *    are amendable.                                             *
155100200528      *                                                               *
155200200528      *****************************************************************
155300200528
155400200528     C     ValdateAmd    BEGSR
155500200528
155600200528      ** This subroutine calls a procedure which checks whether it
155700200528      ** was valid to amend any of the fields which have been
155800200528      ** changed.  Some are never amendable and some depend upon ICD
155900200528      ** settings as to whether they are amendable.
156000200528
156100200528      ** To determine what fields have changed, the current fields
156200200528      ** on file must be converted to a 'screen' format.
156300200528
156400200528      ** These fields are then compared with the fields on the input
156500200528      ** transaction.
156600200528
156700200528      ** Any errors detected by the called procedure take precedence
156800200528      ** over any errors found during the validation of the complete
156900200528      ** transaction.  The errors from the called procedure are kept
157000200528      ** separately and, if any are found, these errors will REPLACE
157100200528      ** the normal validation errors.
157200200528
157300200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
157400200528
157500200528     C                   RESET                   ReturnCode
157600200528     C                   CALLB     'FXFXDLCVT'
157700200528
157800200528      * INPUTS
157900200528      * Return Code
158000200528     C                   PARM                    ReturnCode
158100200528      * (Current) Deal in file format
158200200528     C                   PARM                    DealFilfmt
158300200528
158400200528      * OUTPUTS
158500200528      * (Current) Deal in screen format
158600200528     C                   PARM                    DealScnfmt
158700200528      * NET BUY/SELL REFERENCE
158800200528     C                   PARM                    DDNBRF           19
158900200528     C                   PARM                    DDNSRF           19
159000200528      * Deal Status
159100200528     C                   PARM                    DDSTS            24
159200200528
159300200528      ** AMEND CHECKING
159400200528     C                   RESET                   ReturnCode
159500200528     C                   CALLB     'FXFXDLAMD'
159600200528
159700200528      * INPUTS
159800200528      * Return Code
159900200528     C                   PARM                    ReturnCode
160000200528      * New Deal in Screen Format (Incoming Transaction)
160100200528     C                   PARM                    TranIn
160200200528      * (Current) Deal in Screen Format
160300200528     C                   PARM                    DealScnfmt
160400200528      * (Current) Deal in file format
160500200528     C                   PARM                    DealFilfmt
160600200528      *                                                                                     MD047971
160700200528      ** Pay/rcv settlement account                                                         MD047971
160800200528      *                                                                                     MD047971
160900200528     C                   PARM                    DDRONX                                     MD047971
161000200528     C                   PARM                    DDPONX                                     MD047971
161100200528     C                   PARM                    DDRONXOK                                   MD047971
161200200528     C                   PARM                    DDPONXOK                                   MD047971
161300200528
161400200528      * OUTPUTS
161500200528      * Field OK flags (DS) from/to caller
161600200528     C                   PARM                    OKFlagsDS
161700200528      * Error fields/message IDs/message data (arrays) from/to caller
161800200528     C                   PARM                    AmFldNamAr
161900200528     C                   PARM                    AmMsgIdArr
162000200528     C                   PARM                    AmMsgDtaAr
162100200528      * Array index (3P0) from/to caller
162200200528     C                   PARM                    AmIdx
162300200528      * Amendments OK
162400200528     C                   PARM                    AmendOk           1
162500200528      * Reset of Fields in Error Required (Y/N)
162600200528     C                   PARM      'N'           ResetErrs         1
162700200528
162800200528      ** If any errors overwrite previous error information
162900200528
163000200528     C                   IF        AmIdx <> 0
163100200528     C                   MOVEA     AmMsgIdArr    MsgidArr
163200200528     C                   MOVEA     AmFldNamAr    FldNameArr
163300200528     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
163400200528     C                   Z-ADD     AmIdx         Idx
163500200528     C                   ENDIF
163600200528
163700200528     C                   ENDSR
163800200528      *****************************************************************
163900200528      /EJECT
164000200528      *****************************************************************
164100200528      *                                                               *
164200200528      * Check/Write - Routine to control checking of error status and *
164300200528      *    sending of messgaes/writing to the database                *
164400200528      *                                                               *
164500200528      *****************************************************************
164600200528
164700200528     C     CheckWrite    BEGSR
164800200528
164900200528      *  If no errors were found:
165000200528      *  - If Action Code is Insert and Deal Number is not supplied
165100200528      *     - set up the deal number
165200200528      *  - If there are still no errors
165300200528      *     - set up additional data
165400200528      *     - write a record to the Valid file
165500200528      *     - use std message handler to report deal status
165600200528      *  If any errors were found:
165700200528      *  - write a record to the Invalid file
165800200528      *  - call the message handler to pass the errors back
165900200528      *  - use std message handler to report deal status
166000200528      *  The index to the error arrays is checked for presence/absence of
166100200528      *   errors
166200200528     
166300200528      ** +--- Note for a later release -------------------------------+
166400200528      ** |                                                            |
166500200528      ** | At a later date this routine will have to cater for        |
166600200528      ** | warning messages.  The following logic will have to be     |
166700200528      ** | inserted before "If no errors were found", in the          |
166800200528      ** | above comments (and the code):                             |
166900200528      ** |                                                            |
167000200528      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
167100200528      ** | any warning messages were returned (WIdx <> 0)             |
167200200528      ** |                                                            |
167300200528      ** | -   If errors exist                                        |
167400200528      ** |     -     Add the warning array index to the error array   |
167500200528      ** |           index                                            |
167600200528      ** |     -     Append the contents of the warning arrays to the |
167700200528      ** |           end of the error arrays                          |
167800200528      ** | -   Else                                                   |
167900200528      ** |     -     Set the error array index equal to the warning   |
168000200528      ** |           array index                                      |
168100200528      ** |     -     Copy the contents of the warning arrays to the   |
168200200528      ** |           error arrays                                     |
168300200528      ** | -   Endif                                                  |
168400200528      ** |                                                            |
168500200528      ** | Endif                                                      |
168600200528      ** |                                                            |
168700200528      ** | Note that the "If errors exist ... Else ... " block above  |
168800200528      ** | can probably be implemented unconditionally (ie the same   |
168900200528      ** | logic will apply whether errors exist as well as warnings  |
169000200528      ** | or not).  It is shown in the above form for clarity.       |
169100200528      ** |                                                            |
169200200528      ** +------------------------------------------------------------+
169300200528                                                                                              190876
169400200528      ** Reject deals with warnings that exist in SDWARNPD (Warning                           190876
169500200528      ** messages considered as errors). Send the deal to the repair                          190876
169600200528      ** queue, in the same way as erroneous deals are dealt with.                            190876
169700200528                                                                                              190876
169800200528     C                   DO        WIdx          I                 3 0                        190876
169900200528                                                                                              190876
170000200528     C                   EVAL      KMsgID = WMsgIDArr(I)                                      190876
170100200528     C     *LOVAL        SETLL     SDWARNL1                                                   190876
170200200528     C     KeyWarn       CHAIN     SDWARNL1                           01                      190876
170300200528     C                   IF        *IN01 = *OFF                                               190876
170400200528     C                   ADD       1             Idx                                          190876
170500200528     C                   EVAL      MsgIDArr(Idx) = WMsgIDArr(I)                               190876
170600200528     C                   EVAL      FldNameArr(Idx) = WFldNamArr(I)                            190876
170700200528     C                   EVAL      MsgDtaArr(Idx) = WMsgDtaArr(I)                             190876
170800200528     C                   ENDIF                                                                190876
170900200528                                                                                              190876
171000200528     C                   ENDDO                                                                190876
171100200528
171200200528     C     Idx           IFEQ      0
171300200528
171400200528     C                   IF        DDACTN = 'I'
171500200528     C                   EXSR      SETUPDEALN
171600200528     C                   ENDIF
171700200528
171800200528     C     Idx           IFEQ      0
171900200528     C                   EXSR      SETUPVALID
172000200528     C                   WRITE     FXVFXDLD0
172100200528
172200200528      ** Insert DLDLDBQD record for CLE025 processing                                         247888
172300200528     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
172400200528     C     DDDLNO        CHAIN     DLDLDBD0                           12                      247888
172500200528     C     *IN12         IFEQ      *ON                                                        247888
172600200528     C                   EVAL      DX_F1DLNO = DDDLNO                                         247888
172700200528     C                   EVAL      DX_F1BRCA = DDBRSN                                         247888
172800200528     C                   WRITE     DLDLDBD0                                                   247888
172900200528     C                   ENDIF                                                                247888
173000200528     C                   ENDIF                                                                247888
173100200528                                                                                              247888
173200200528      /COPY WNCPYSRC,FXFXDLC023
173300200528
173400200528     C                   EXSR      CallMsgHdl
173500200528     C                   ENDIF
173600200528
173700200528     C                   ENDIF
173800200528
173900200528     C     Idx           IFGT      0
174000200528     C                   EXSR      SETUPINVAL
174100200528      *                                                                         CAP004
174200200528      * Only write to invalid files if repair in back office                    CAP004
174300200528      *                                                                         CAP004
174400200528     C     APRprLocn     IFEQ      'B'                                          CAP004
174500200528     C                   WRITE     FXIFXDLD0
174600200528     C                   WRITE     APIDSETD0
174700200528     C/COPY WNCPYSRC,FXH00005
174800200528                                                                                              CSC011
174900200528      ** If support system is active, write invalid transaction to                            CSC011
175000200528      ** log file via APLOGTRAN standard module.                                              CSC011
175100200528                                                                                              CSC011
175200200528     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
175300200528                                                                                              CSC011
175400200528     C                   EVAL      TRANSDTL = TranIn + InRecSttmt                             CSC011
175500200528     C                                        + InPaySttmt                                    CSC011
175600200528     C                                        + InFRASttmt                                  AR990243
175700200528     C                                        + InfData                                       CSC011
175800200528     C                                        + ExtData                                       CSC011
175900200528     C                   EVAL      APTGTTYPE = 'FXFXDL'                                       CSC011
176000200528     C                   EVAL      PDealNum = DDDLNO                                          CSC011
176100200528                                                                                              CSC011
176200200528     C                   CALLB     'APLOGTRAN'                                                CSC011
176300200528     C                   PARM      *Blanks       RetCodeOut                                   CSC011
176400200528     C                   PARM                    HeadIn                                       CSC011
176500200528     C                   PARM                    TRANSDTL                                     CSC011
176600200528     C                   PARM                    Timestamp                                    CSC011
176700200528     C                   PARM                    PDealNum                                     CSC011
176800200528     C                   PARM      *BLANKS       PADealNum                                    CSC011
176900200528                                                                                              CSC011
177000200528     C                   IF        RetCodeOut <> *Blanks                                      CSC011
177100200528     C     *LOCK         IN        LDA                                                        CSC011
177200200528     C                   EVAL      DBKey = PDealNum                                           CSC011
177300200528     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
177400200528     C                   EVAL      DBase = 2                                                  CSC011
177500200528     C                   OUT       LDA                                                        CSC011
177600200528     C                   EXSR      *PSSR                                                      CSC011
177700200528     C                   ENDIF                                                                CSC011
177800200528                                                                                              CSC011
177900200528     C                   ENDIF                                                                CSC011
178000200528                                                                                              CSC011
178100200528     C                   ENDIF                                                  CAP004
178200200528     C                   EXSR      CallMsgHdl
178300200528     C                   ENDIF
178400200528
178500200528      *  Check for exception error from any program lower in the stack                        251029
178600200528      *  If error detected, roll back any updates, send message to system                     251029
178700200528      *  operator and return error back to calling program                                    251029
178800200528     C                   IN        APDUMP                                                     251029
178900200528      *                                                                                       251029
179000200528     C     ARERRMOD      IFNE      *BLANK                                                     251029
179100200528     C                   ROLBK                                                                251029
179200200528      *                                                                                       251029
179300200528     C                   EVAL      MQErrlong  = *blank                                        251029
179400200528     C                   MOVEL     ProcErr       MQError                                      251029
179500200528     C                   MOVE      ARERRMOD      MQError          28                          251029
179600200528     C                   MOVEL     MQError       MQErrlong                                    251029
179700200528      *                                                                                       251029
179800200528     C                   CALLB     'ZAMSGTOOPR'                                               251029
179900200528     C                   PARM                    MQReturn         10                          251029
180000200528     C                   PARM                    MQErrlong       132                          251029
180100200528     C                   PARM                    DummyMsgID                                   251029
180200200528     C                   PARM                    DummyMsgF                                    251029
180300200528      *                                                                                       251029
180400200528     C                   MOVEL     ARERRMOD      APRETCODE                                    251029
180500200528     C     *LOCK         IN        APDUMP                                                     251029
180600200528     C                   EVAL      ARERRMOD = *BLANK                                          251029
180700200528     C                   OUT       APDUMP                                                     251029
180800200528     C                   RETURN                                                               251029
180900200528     C                   ELSE                                                                 251029
181000200528      *                                                                                       251029
181100200528     C                   If        CSC022 = 'N'                                               CSC022
181200200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
181300200528     C                   COMMIT
181400200528     C                   Endif                                                                CSC022
181500200528     C                   ENDIF                                                                251029
181600200528
181700200528     C                   ENDSR
181800200528      *****************************************************************
181900200528      /EJECT
182000200528      *****************************************************************
182100200528      *                                                               *
182200200528      * RESETCYCLE- Reset error information that is gradually         *
182300200528      *    updated during each run of this program                    *
182400200528      *                                                               *
182500200528      *****************************************************************
182600200528
182700200528     C     RESETCYCLE    BEGSR
182800200528
182900200528     C                   RESET                   FldNameArr
183000200528     C                   RESET                   MsgIDArr
183100200528     C                   RESET                   MsgDtaArr
183200200528     C                   RESET                   Idx
183300200528
183400200528     C                   RESET                   WFldNamArr
183500200528     C                   RESET                   WMsgIDArr
183600200528     C                   RESET                   WMsgDtaArr
183700200528     C                   RESET                   WIdx
183800200528
183900200528     C                   RESET                   AmFldNamAr
184000200528     C                   RESET                   AmMsgIDArr
184100200528     C                   RESET                   AmMsgDtaAr
184200200528     C                   RESET                   AmIdx
184300200528
184400200528     C                   RESET                   FldNoArr
184500200528
184600200528     C                   RESET                   OKFlagsDS
184700200528
184800200528     C                   RESET                   OKPayInsDS
184900200528     C                   RESET                   OKRecInsDS
185000200528     C                   RESET                   OKFRAInsDS
185100200528
185200200528     C                   RESET                   PayDat
185300200528     C                   RESET                   RecDat
185400200528
185500200528     C                   CLEAR                   ValidDeal
185600200528      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
185700200528      **  there are long alpha fileds overlapping these which cause the
185800200528      **  CLEAR to put blanks in the numeric fields
185900200528     C                   Z-ADD     *ZERO         F3RSTM
186000200528     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
186100200528     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
186200200528     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
186300200528     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
186400200528     C                   Z-ADD     *ZERO         F3PSTM
186500200528     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
186600200528     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
186700200528     C                   EVAL      F3POBN = *BLANKS                                           CSD027
186800200528     C                   EVAL      F3POCN = *BLANKS                                           CSD027
186900200528
187000200528      ** Have to clear the settlement data structure, or the packed numeric
187100200528      ** fields are not initialised correctly.
187200200528     C                   CLEAR                   DBPaySttmt
187300200528     C                   CLEAR                   DBRecSttmt
187400200528     C                   CLEAR                   DBFRASttmt
187500200528
187600200528      * Reset Net Buy/sell Reference
187700200528
187800200528     C                   CLEAR                   DDNBRF
187900200528     C                   CLEAR                   DDNSRF
188000200528     C/COPY WNCPYSRC,FXH00112
188100200528
188200200528     C                   ENDSR
188300200528      *****************************************************************
188400200528      /EJECT
188500200528      *****************************************************************
188600200528      *                                                               *
188700200528      * SETUPINVAL - Set up additional fields that are needed on the  *
188800200528      *        Valid file record.                                     *
188900200528      *                                                               *
189000200528      *****************************************************************
189100200528
189200200528     C     SETUPINVAL    BEGSR
189300200528
189400200528      * Include Header fields that need to be o/p to the Invalid files
189500200528     C                   EVAL      DDMsgType  = 'FXFXDL'
189600200528     C                   EVAL      DDFOtranID = APFOTranID
189700200528     C                   EVAL      DDFOAsocID = APFOAsocID
189800200528     C                   EVAL      DDRprLocn  = APRprLocn
189900200528     C                   EVAL      DDTMESTMP = TimeStamp
190000200528                                                                                CAP051
190100200528      * Setup the Automatic Autorisation Flag                                   CAP051
190200200528     C                   IF        CAP051 = 'Y'                                 CAP051
190300200528     C                   EVAL      DDAUTH     = IF_AUTH                         CAP051
190400200528     C                   ENDIF                                                  CAP051
190500200528
190600200528     C                   EVAL      TranStatus = 'F'
190700200528
190800200528      /COPY WNCPYSRC,FXFXDLC017
190900200528
191000200528     C                   ENDSR
191100200528      *****************************************************************
191200200528      /EJECT
191300200528      *****************************************************************
191400200528      *                                                               *
191500200528      * SETUPDEALN - Set up Deal Number for Inserts                   *
191600200528      *                                                               *
191700200528      *****************************************************************
191800200528
191900200528     C     SETUPDEALN    BEGSR
192000200528
192100200528     C                   IF           DDDLNO = *blanks
192200200528     C                             OR DDDLNO = *zeros
192300200528
192400200528     C                   RESET                   ReturnCode
192500200528     C                   CALLB     'CAGETNXTDL'
192600200528     C                   PARM                    ReturnCode
192700200528     C                   PARM                    MSG1
192800200528     C                   PARM                    DDDLNO
192900200528     C                   PARM      *ZEROS        F3DN38
193000200528
193100200528     C     MSG1          IFNE      *BLANK
193200200528     C                   ADD       1             Idx
193300200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
193400200528     C                   EVAL      MsgIDArr(Idx) = MSG1
193500200528     C                   ENDIF
193600200528
193700200528      ** Use the return code's value to set the field's OK flag
193800200528     C                   CALLB     'ZASETOKFLG'
193900200528     C                   PARM                    DDDlnoOK
194000200528     C                   PARM                    ReturnCode
194100200528     C                   PARM                    WarnGlobal
194200200528
194300200528      ** If deal number was entered, put it in the file field
194400200528     C                   ELSE
194500200528     C                   MOVE      DDDLNO        F3DN38
194600200528
194700200528     C                   ENDIF
194800200528
194900200528     C                   ENDSR
195000200528      *****************************************************************
195100200528      /EJECT
195200200528      *****************************************************************
195300200528      *                                                               *
195400200528      * SETUPVALID - Set up additional fields that are needed on the  *
195500200528      *    Valid file record.                                         *
195600200528      *                                                               *
195700200528      *****************************************************************
195800200528
195900200528     C     SETUPVALID    BEGSR
196000200528
196100200528      **For*Inserts,*put*the*Settlement*Instructions*(input*or*defaulted)***    170909
196200200528      ***into*the*Valid*file*record*****************************************    170909
196300200528                                                                                170909
196400200528      * For Inserts and Amends, put the Settlement Instructions (input or       170909
196500200528      *  defaulted) into the Valid file record.                                 170909
196600200528      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
196700200528      *  in contiguous areas, which must be placed into the correct parts
196800200528      *  of the Valid file record
196900200528     C                   IF        DDACTN = 'I'
197000200528     C                             OR (DDACTN = 'A')                            170909
197100200528     C                   MOVEL     DBPaySttmt    FXDLPayIns
197200200528     C                   MOVEL     FLPONS        F3PONS                                       CGL029
197300200528     C                   MOVE      FLPAY2        FXDLPayIns                                   CGL029
197400200528     C                   MOVEL     DBRecSttmt    FXDLRecIns
197500200528     C                   MOVEL     FLRONS        F3RONS                                       CGL029
197600200528     C                   MOVE      FLREC2        FXDLRecIns                                   CGL029
197700200528     C                   MOVE      FLPOBR        F3POBR
197800200528     C                   MOVE      FLROBR        F3ROBR
197900200528     C                   MOVE      FLCVMR        F3CVMR
198000200528     C                   MOVE      FLPSCY        F3PSCY
198100200528     C                   MOVE      FLRSCY        F3RSCY
198200200528     C                   MOVE      FLIC72        F3IC72
198300200528     C                   IF        CSW212 = 'Y'                                               CSW212
198400200528     C                   MOVEL     DBFRASttmt    FXDLPayIsda                                  CSW212
198500200528     C**********         MOVEL     FLAGVC        F3AGVC                              CSW212 AR990243
198600200528     C                   IF        FLISDA = *BLANKS                                           CSW212
198700200528     C                   EVAL      F3ISDA = *ZERO                                             CSW212
198800200528     C                   ENDIF                                                                CSW212
198900200528     C                   IF        FLAGDT = *BLANKS                                           CSW212
199000200528     C                   EVAL      F3AGDT = *ZERO                                             CSW212
199100200528     C                   ENDIF                                                                CSW212
199200200528     C                   IF        FLAGVV = *BLANKS                                           CSW212
199300200528     C                   EVAL      F3AGVV = *ZERO                                             CSW212
199400200528     C                   ENDIF                                                                CSW212
199500200528     C                   IF        FLAGVC = *BLANKS                                           CSW212
199600200528     C                   EVAL      F3AGVC = *ZERO                                             CSW212
199700200528     C                   ENDIF                                                                CSW212
199800200528     C                   ENDIF                                                                CSW212
199900200528     C                   ENDIF
200000200528
200100200528      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
200200200528      ***the*Valid*file*record**********************************************    170909
200300200528      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
200400200528      ***(physically*separate)*fields*also*need*to*be*done******************    170909
200500200528     C*******************IF********DDACTN*=*'A'*************                    170909
200600200528     C*******************MOVE******DEALRecIns****FXDLRecIns*                    170909
200700200528     C*******************MOVE******DEALPayIns****FXDLPayIns*                    170909
200800200528     C*******************MOVE******FHPOBR********F3POBR*****                    170909
200900200528     C*******************MOVE******FHROBR********F3ROBR*****                    170909
201000200528     C*******************MOVE******FHCVMR********F3CVMR*****                    170909
201100200528     C*******************MOVE******FHPSCY********F3PSCY*****                    170909
201200200528     C*******************MOVE******FHRSCY********F3RSCY*****                    170909
201300200528     C*******************MOVE******FHIC72********F3IC72*****                    170909
201400200528     C*******************ENDIF******************************                    170909
201500200528
201600200528      * For Deletes & Authorises, put the complete (pre-existing) deal
201700200528      *  into the Valid file record
201800200528     C                   IF           DDACTN = 'D'
201900200528     C                             OR DDACTN = 'X'
202000200528     C                   MOVE      DealFilFmt    ValidDeal
202100200528     C                   ENDIF
202200200528
202300200528      * Set Valid file field(s) that are needed for all Action Codes
202400200528     C                   EVAL      F3LACT = DDACTN
202500200528
202600200528      * Include Header fields that need to be o/p to the Valid file
202700200528     C                   EVAL      F3FRNT = APFOTranID
202800200528     C                   EVAL      F3AFRT = APFOAsocID
202900200528     C                   EVAL      F3REPA = APRprLocn
203000200528     C                   EVAL      F3TMESTMP = TimeStamp
203100200528                                                                                CAP051
203200200528      * Automatic Authorisation flag                                            CAP051
203300200528     C                   IF        CAP051 = 'Y'                                 CAP051
203400200528     C                   EVAL      F3AUTH = IF_AUTH                             CAP051
203500200528     C                   ENDIF                                                  CAP051
203600200528
203700200528     C                   EVAL      TranStatus = 'S'
203800200528
203900200528      /COPY WNCPYSRC,FXFXDLC018
204000200528
204100200528     C                   ENDSR
204200200528      *****************************************************************
204300200528      /EJECT
204400200528      *****************************************************************
204500200528      *                                                               *
204600200528      * CallMsgHdl - Call the Message Handling module                 *
204700200528      *                                                               *
204800200528      *****************************************************************
204900200528
205000200528     C     CallMsgHdl    BEGSR
205100200528
205200200528      ** Set up an array of sequence numbers that correspond to the fields
205300200528      **  with errors
205400200528
205500200528     C                   Z-ADD     1             Ix
205600200528     C                   DO        ArrayMax
205700200528
205800200528     C     FldNameArr(Ix)IFNE      *BLANKS
205900200528
206000200528     C                   Z-ADD     1             Iy
206100200528     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
206200200528     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
206300200528
206400200528     C                   ELSE
206500200528
206600200528     C                   LEAVE
206700200528
206800200528     C                   ENDIF
206900200528
207000200528     C                   ADD       1             Ix
207100200528     C                   ENDDO
207200200528
207300200528     C                   RESET                   ReturnCode
207400200528
207500200528     C                   MOVEL     DDDLNO        PTranID          20                          CAP033
207600200528                                                                                              CAP033
207700200528     C                   CALLB     'ZAMSGHNDLE'
207800200528      ** Return code (10A, returned to this procedure)
207900200528     C                   PARM                    ReturnCode
208000200528      ** Deal repair location (1A, from caller)
208100200528     C                   PARM                    APRprLocn
208200200528      ** Confirm validity to front office (1A, from caller)
208300200528     C                   PARM                    APCnfValFO
208400200528      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
208500200528     C                   PARM                    MsgIDArr
208600200528      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
208700200528     C                   PARM                    FldNoArr
208800200528      ** List of field names (Array of <ArrayMax>x10A names - from caller)
208900200528     C                   PARM                    FldNameArr
209000200528      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
209100200528     C                   PARM                    MsgDtaArr
209200200528      ** Front office transaction identifier (20A, from caller)
209300200528     C                   PARM                    APFOTranID
209400200528      ** Midas module ID (2A)
209500200528     C                   Parm                    ModuleID
209600200528      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
209700200528      ** Midas transaction ID (20A, from caller)                                              CAP033
209800200528     C***********        PARM                    DDDLNO                                       CAP033
209900200528     C                   PARM                    PTranID                                      CAP033
210000200528      ** Message file (10A, from caller)
210100200528     C                   PARM                    #MsgFile
210200200528      ** Action code of transaction (1A, from transaction)
210300200528     C                   PARM                    DDACTN
210400200528      ** Status of transaction (1A, F=Failure, S=Success)
210500200528     C                   PARM                    TranStatus
210600200528      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
210700200528     C                   PARM                    APRespMode
210800200528      ** The following three parameters are needed when messages are to
210900200528      ** be displayed on a screen
211000200528      ** Screen-handling program (10A, from caller)
211100200528     C                   PARM                    #ProcPgm
211200200528      ** Screen-handling module (10A, from caller)
211300200528     C                   PARM                    #ProcMod
211400200528      ** Screen-handling procedure (10A, from caller)
211500200528     C                   PARM                    #ProcName
211600200528      ** The MQSeries queue to send replies to
211700200528     C                   PARM                    APRpyQueue
211800200528      ** The transaction's timestamp
211900200528     C                   PARM                    TimeStamp
212000200528      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
212100200528     C                   PARM                    MsgFArray                                    222373
212200200528      ** Whether or not to clear the program message queue (1A)                               222373
212300200528     C                   PARM                    ClearPgmQ                                    222373
212400200528
212500200528     C                   ENDSR
212600200528      *****************************************************************
212700200528      /EJECT
212800200528     C/COPY ZACPYSRC,PSSR_ILE
212900200528      ********************************************************************
213000200528      /EJECT
213100200528      *****************************************************************
213200200528      *                                                               *
213300200528      * *INZSR - Program Initialisation routine                       *
213400200528      *                                                               *
213500200528      *****************************************************************
213600200528
213700200528     C     *INZSR        BEGSR
213800200528
213900200528     C     *ENTRY        PLIST
214000200528      * Common header information (DS) from source system
214100200528     C                   PARM                    HeadIn
214200200528      * Transaction information in a single large field from source system
214300200528     C                   PARM                    Trans500
214400200528     C                   PARM                    InfData500                     CAP051
214500200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
214600200528     C                   PARM                    InPaySttmt
214700200528     C                   PARM                    InRecSttmt
214800200528     C                   PARM                    InFRASttmt
214900200528     C                   PARM                    ExtData500                     CAP004
215000200528      ** Ultimate calling Program/Module/Procedure
215100200528     C                   PARM                    #ProcPgm
215200200528     C                   PARM                    #ProcMod
215300200528     C                   PARM                    #ProcName
215400200528
215500200528      *  Set up the name of the MSGF from which the message handler will
215600200528      *   get the messages
215700200528     C                   EVAL      #MsgFile = 'DRSMM'
215800200528
215900200528      *  Set up the Module ID, used to make the Transaction number unique
216000200528     C                   EVAL      ModuleID = 'DL'
216100200528
216200200528      ** Access Bank details via access program
216300200528      *  (database error handling done in access program)
216400200528     C                   CALLB     'AOBANKR0'
216500200528     C                   PARM      '*DBERR '     @RTCD             7
216600200528     C                   PARM      '*FIRST '     @OPTN             7
216700200528     C     SDBANK        PARM      SDBANK        DSFDY
216800200528                                                                                CAP011
216900200528      ** Access API ICD via access program                                      CAP011
217000200528      *  (database error handling done in access program)                       CAP011
217100200528     C                   CALLB     'AOAPIR0'                                    CAP011
217200200528     C                   PARM      '*DBERR '     @RTCD             7            CAP011
217300200528     C                   PARM      '*FIRST '     @OPTN             7            CAP011
217400200528     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
217500200528
217600200528     ****Initialise*Data*queue*parms********************************************148855
217700200528     C*******************EVAL      DtqLen = 10                                  148855
217800200528                                                                                148855
217900200528      ** Set up the name of the server/database updater data queue.             148855
218000200528     C                   EVAL      DtaQName = 'APFXDLDTQ'                       148855
218100200528      *                                                                         CAP051
218200200528      ** Access SAR details file to determine if                                CAP051
218300200528      ** Automatic Authorisation (FX Part) is installed                         CAP051
218400200528      *                                                                         CAP051
218500200528     C                   MOVEL     'N'           CAP051            1            CAP051
218600200528     C                   CALL      'AOSARDR0'                                   CAP051
218700200528     C                   PARM      *BLANKS       @RTCD                          CAP051
218800200528     C                   PARM      '*VERIFY'     @OPTN                          CAP051
218900200528     C                   PARM      'CAP051'      @SARD                          CAP051
219000200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
219100200528      *                                                                         CAP051
219200200528     C     @RTCD         IFEQ      *BLANK                                       CAP051
219300200528     C                   MOVEL     'Y'           CAP051                         CAP051
219400200528     C                   ENDIF                                                  CAP051
219500200528                                                                                              190876
219600200528      ** Check if CDL008 is installed                                                         190876
219700200528                                                                                              190876
219800200528     C                   CALL      'AOSARDR0'                                                 190876
219900200528     C                   PARM      *BLANKS       @RTCD                                        190876
220000200528     C                   PARM      '*VERIFY'     @OPTN                                        190876
220100200528     C                   PARM      'CDL008'      @SARD                                        190876
220200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        190876
220300200528                                                                                              190876
220400200528     C     @RTCD         IFEQ      *BLANK                                                     190876
220500200528     C                   MOVEL     'Y'           CDL008            1                          190876
220600200528     C                   ELSE                                                                 190876
220700200528     C                   MOVEL     'N'           CDL008                                       190876
220800200528     C                   ENDIF                                                                190876
220900200528                                                                                              190876
221000200528      ** Define key list for SDWARNL1                                                         190876
221100200528                                                                                              190876
221200200528     C     KeyWarn       KList                                                                190876
221300200528     C                   KFld                    KPgm             10                          190876
221400200528     C                   KFld                    KMsgID            7                          190876
221500200528                                                                                              190876
221600200528     C                   Eval      KPgm = 'FXFXDLCTL'                                         190876
221700200528
221800200528      ** Check if CSC011 is installed                                                         CSC011
221900200528                                                                                              CSC011
222000200528     C                   CALL      'AOSARDR0'                                                 CSC011
222100200528     C                   PARM      *BLANKS       PRtCd                                        CSC011
222200200528     C                   PARM      '*VERIFY'     POptn                                        CSC011
222300200528     C                   PARM      'CSC011'      PSard                                        CSC011
222400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
222500200528                                                                                              CSC011
222600200528     C                   IF        PRtCd = *Blanks                                            CSC011
222700200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
222800200528     C                   IN        SC24X7                                                     CSC011
222900200528     C                   IN        SDSTAT                                                     CSC011
223000200528     C                   ELSE                                                                 CSC011
223100200528     C                   EVAL      CSC011 = 'N'                                               CSC011
223200200528     C                   ENDIF                                                                CSC011
223300200528                                                                                              CSC011
223400200528     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
223500200528     C                             (PRtCd <> *Blanks)                                         CSC011
223600200528     C     *LOCK         IN        LDA                                                        CSC011
223700200528     C                   EVAL      DBKey = 'CSC011'                                           CSC011
223800200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
223900200528     C                   EVAL      DBase = 1                                                  CSC011
224000200528     C                   OUT       LDA                                                        CSC011
224100200528     C                   EXSR      *PSSR                                                      CSC011
224200200528     C                   ENDIF                                                                CSC011
224300200528      ** Determine if enhancement CSC022 is switched on                                       CSC022
224400200528                                                                                              CSC022
224500200528     C                   CALLB     'AOSARDR0'                                                 CSC022
224600200528     C                   PARM      *BLANKS       PRTCD                                        CSC022
224700200528     C                   PARM      '*VERIFY'     POPTN                                        CSC022
224800200528     C                   PARM      'CSC012'      PSARD                                        CSC022
224900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
225000200528      * Initialize work fields                                                                CSC022
225100200528     C                   Eval      CSC022 = 'N'                                               CSC022
225200200528     C                   Eval      WSkpCom = 'N'                                              CSC022
225300200528      *                                                                                       CSC022
225400200528     C                   If        PRTCD = *Blanks                                            CSC022
225500200528     C                   Eval      CSC022 = 'Y'                                               CSC022
225600200528      *                                                                                       CSC022
225700200528     C                   IN        SCCMTJOB                                                   CSC022
225800200528      *                                                                                       CSC022
225900200528     C                   If        COMITNUM <> 0                                              CSC022
226000200528     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
226100200528     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
226200200528     C                   If        WPos > 0                                                   CSC022
226300200528     C                   Eval      WSkpCom = 'Y'                                              CSC022
226400200528     C                   Endif                                                                CSC022
226500200528     C                   Endif                                                                CSC022
226600200528     C                   Else                                                                 CSC022
226700200528      ** An NRF (No Record Found) return code is valid.                                       CSC022
226800200528      ** Issue database error only for error return codes.                                    CSC022
226900200528     C                   If        PRTCD <> '*NRF'                                            CSC022
227000200528     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
227100200528     C                   Eval      DBKEY = 'CSC022'                                           CSC022
227200200528     C                   Eval      DBASE = 3                                                  CSC022
227300200528     C                   EXSR      *PSSR                                                      CSC022
227400200528     C                   EndIf                                                                CSC022
227500200528     C                   EndIf                                                                CSC022
227600200528                                                                                              CSC011
227700200528     C/COPY WNCPYSRC,FXH00032
227800200528                                                                                              247888
227900200528      ** Check if CLE025 is installed                                                         247888
228000200528                                                                                              247888
228100200528     C                   CALL      'AOSARDR0'                                                 247888
228200200528     C                   PARM      *BLANKS       @RTCD                                        247888
228300200528     C                   PARM      '*VERIFY'     @OPTN                                        247888
228400200528     C                   PARM      'CLE025'      @SARD                                        247888
228500200528     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
228600200528                                                                                              247888
228700200528     C     @RTCD         IFEQ      *BLANK                                                     247888
228800200528     C                   MOVEL     'Y'           CLE025            1                          247888
228900200528     C                   ELSE                                                                 247888
229000200528     C                   MOVEL     'N'           CLE025                                       247888
229100200528     C                   ENDIF                                                                247888
229200200528                                                                                              247888
229300200528      ** Check if CSW212 is installed                                                         CSW212
229400200528                                                                                              CSW212
229500200528     C                   CALL      'SWIF2012'                                                 CSW212
229600200528     C                   PARM      *BLANKS       @RTCD                                        CSW212
229700200528                                                                                              CSW212
229800200528     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
229900200528     C                   MOVEL     'Y'           CSW212            1                          CSW212
230000200528     C                   ELSE                                                                 CSW212
230100200528     C                   MOVEL     'N'           CSW212                                       CSW212
230200200528     C                   ENDIF                                                                CSW212
230300200528                                                                                              CSW212
230400200528      *  Hook to enable non-core initial processing to be included
230500200528      /COPY WNCPYSRC,FXFXDLC022
230600200528
230700200528     C                   ENDSR
230800200528      *****************************************************************
230900200528**  CPY@
231000200528(c) Finastra International Limited 2001
