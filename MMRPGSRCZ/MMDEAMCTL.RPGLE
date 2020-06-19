000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal amendments interface controller')        *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  MMDEAMCTL - Deal Amendments Interface Controller             *
001100200528      *                                                               *
001200200528      *  Function: This Program Validates MM Deal Amendments for input*
001300200528      *            into the Midas database.
001400200528      *            Processes executed controlled by input Action Code *
001500200528      *            - For I (=Insert)                                  *
001600200528      *              - If ALL of the settlement fields are blank, set *
001700200528      *                them up from standard settlement instructions  *
001800200528      *            - For I (=Insert) or A (=Amend)                    *
001900200528      *              - Validate the deal fields                       *
002000200528      *              - Validate the settlement fields                 *
002100200528      *            - For A (=Amend) if it is valid, call a separate   *
002200200528      *              function to check whether it is a valid amendment*
002300200528      *            - For X (=Authorise) call a separate function to   *
002400200528      *              process this deal and bypass remaining validation*
002500200528      *              bypass the field validation                      *
002600200528      *            - For D (=Delete) call a separate function to      *
002700200528      *              process this deal and bypass the rest of the     *
002800200528      *              validation                                       *
002900200528      *            For all action codes, the decision to as to        *
003000200528      *            whether to write to the Valid or Invalid file and  *
003100200528      *            the call to the Message Handler will take place    *
003200200528      *            in this module                                     *
003300200528      *                                                               *
003400200528      *  (c) Finastra International Limited 2001                      *
003500200528      *                                                               *
003600200604      *  Last Amend No. 260173             Date 22May20               *
003700200528      *  Prev Amend No. CSD102             Date 08Jan19               *
003800200528      *                 MD046248           Date 27Oct17               *
003900200528      *                 CGL165             Date 17Feb15               *
004000200528      *                 CDL096             Date 22Sep14               *
004100200528      *                 CDL094             Date 11Jun14               *
004200200528      *                 CSD095             Date 08Apr14               *
004300200528      *                 CSC054             Date 23Feb12               *
004400200528      *                 CSF011A            Date 28Nov11               *
004500200528      *                 CRE073             Date 06Dec10               *
004600200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004700200528      *                 260028             Date 29Apr09               *
004800200528      *                 250430             Date 13Nov07               *
004900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
005000200528      * Midas Plus 1.4 Base ------------------------------------------*
005100200528      * Midas Plus 1.3 ----------- Base ------------------------------*
005200200528      *                 CSD027             Date 09Dec05               *
005300200528      *                 CLE031             Date 26Apr05               *
005400200528      *                 CDL038             Date 10May05               *
005500200528      *                 CSC024             Date 07Feb05               *
005600200528      *                 CDL022             Date 03Feb04               *
005700200528      *                 CDL020             Date 03Feb04               *
005800200528      *                 CDL017             Date 03Feb04               *
005900200528      *                 CSC022             Date 24Feb04               *
006000200528      *                 CGL029             Date 01Sep03               *
006100200528      *                 222373             Date 24Oct03               *
006200200528      *                 CRE008             Date 19Feb02               *
006300200528      *                 CDL010             Date 02Aug02               *
006400200528      * Midas Release 4.01.03 ----------------------------------------*
006500200528      * Midas Release 4.01.02 ----------------------------------------*
006600200528      *                 204887             Date 10Jul02               *
006700200528      *                 196461             Date 22Apr02               *
006800200528      * Midas Release 4.01 -------------------------------------------*
006900200528      *                 CSC011             Date 18Sep01               *
007000200528      * Midas Release 4 --------------- Base -------------------------*
007100200528      *                 200400             Date 20Nov01               *
007200200528      *                 194994             Date 27Jun01               *
007300200528      *                 165903             Date 18Apr01               *
007400200528      * Midas DBA 3.05 -----------------------------------------------*
007500200528      *                 CPB002             Date 30Nov00               *
007600200528      *                 185751             Date 17Nov00               *
007700200528      * Midas DBA 3.04 -----------------------------------------------*
007800200528      *                 179510             Date 07Nov00               *
007900200528      *                 166888             Date 08Sep99               *
008000200528      * Midas DBA 3.03 -----------------------------------------------*
008100200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
008200200528      *                 176883             Date 24Mar00               *
008300200528      * Midas DBA 3.02 -----------------------------------------------*
008400200528      *                 CAP033             Date 26Apr99               *
008500200528      *                 CAP051             Date 12Nov99               *
008600200528      *                 CPB001             Date 01Jun99               *
008700200528      *                 CAP013             Date 07Sep99               *
008800200528      *                 CAP011             Date 07Sep99               *
008900200528      *                 170909             Date 07Sep99               *
009000200528      * Midas DBA 3.00 ---------------- Base -------------------------*
009100200528      *                 148855             Date 26Nov98               *
009200200528      *                 CAP004             Date 07Sep98               *
009300200528      *                 CAP003             Date 30Jul98               *
009400200528      *                 CAP002  *CREATE    Date 06OCT97               *
009500200528      *                                                               *
009600200528      *---------------------------------------------------------------*
009700200528      *                                                               *
009800200528      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
009900200528      *           parameter mismatch. Apply fix 258724.               *
010000200528      *  CSD102 - Password Length Extension (Recompile)               *
010100200528      *  MD046248 - Finastra Rebranding                               *
010200200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
010300200528      *  CDL096 - Business Day Conventions on MM Deals                *
010400200528      *           (Recompile)                                         *
010500200528      *  CDL094 - Enhance Receive Settlement Instructions             *
010600200528      *           (Recompile)                                         *
010700200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
010800200528      *  CSC054 - Period End Adjusetments                             *
010900200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
011000200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
011100200528      *  260028 - Pass sequence number and value date  on replyQ      *
011200200528      *  250430 - Include sequence number and value date on reply.    *
011300200528      *           PTranID now contains DEALNO, SEQNO & VALUEDATE prior*
011400200528      *           to calling ZAMSGHNDLE.                              *
011500200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
011600200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
011700200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
011800200528      *  CSC024 - Open Month End                                      *
011900200528      *  CDL022 - Deal Amendment Changes                              *
012000200528      *  CDL020 - Apply Base Rate at Value Date                       *
012100200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
012200200528      *                                                               *
012300200528      *  CSC022 - Commitment Control Changes for MidasPlus            *
012400200528      *  CGL029 - Increase Account Code to 10 digits                  *
012500200528      *  222373 - Parameter Mismatch                                  *
012600200528      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
012700200528      *  CDL010 - Prevent last user that actioned the trade from      *
012800200528      *           authorising it.Recompile due to changes in MMVDEAMPD*
012900200528      *  204887 - Module ID and transaction numbers are incorrectly   *
013000200528      *           passed to ZAMSGHNDLE.                               *
013100200528      *  196461 - Additional parameter ##PREC and ##PPAY to ZASETINVAL*
013200200528      *  CSC011 - 24x7 Midas Availability                             *
013300200528      *  200400 - Reverse fix 179510                                  *
013400200528      *  194994 - Extra data layout file should be MMDAEXPD not       *
013500200528      *           MMLDEXPD.                                           *
013600200528      *  165903 -  Receive ccy should also allow default (just like   *
013700200528      *            the back office input MMDEAMSIN).                  *
013800200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
013900200528      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
014000200528      *           to be used in the validation.                       *
014100200528      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
014200200528      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
014300200528      *           to defaulted value all the time. Apply GEMS 163745  *
014400200528      *           However, 163745 only fixes the problem for 'A' and  *
014500200528      *           'X' processing. Problem still exists for insert.    *
014600200528      *           Need to default only the 1st time validation is     *
014700200528      *           done. Do not re-default for subsequent validations. *
014800200528      *           Due to this 163745 in its original form is no       *
014900200528      *           longer required, now default required only for      *
015000200528      *           'first time insert'.                                *
015100200528      *  176883 - Errors found as a result of creating DBAR3.02       *
015200200528      *           Meridian repository file.                           *
015300200528      *           Recompiled due to mismatch between parameter calls  *
015400200528      *           to ZASETINDFT.                                      *
015500200528      *  CAP033 - Conversion of PM inputs into modular structure to   *
015600200528      *           use as APIs. Increased length of Transaction        *
015700200528      *           Reference ID from 6A to 20A.                        *
015800200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
015900200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
016000200528      *           Recompiled due to changes in MMDEAMPP               *
016100200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
016200200528      *  CAP011 - Substitution of Midas database flds for externl i/fs*
016300200528      *  170909 - Settlement instructions not updated on amendment    *
016400200528      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
016500200528      *           it through the ZACHNDQMS module, which is included  *
016600200528      *           in the DTAQCHK* /COPYs.                             *
016700200528      *  CAP004 - API's Phase 3.                                      *
016800200528      *           Add extra parm for Extra Data                       *
016900200528      *  CAP003 - Conversion of Midas inputs to modular API structure *
017000200528      *           Phase 2.                                            *
017100200528      *           Replacement by /COPYs of arrays that was not done   *
017200200528      *           before original collection.  This has been done     *
017300200528      *           without annotation to keep this module concistent   *
017400200528      *           with all of the others.                             *
017500200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
017600200528      *                                                               *
017700200528      *****************************************************************
017800200528      ** +--------------------------------------+
017900200528      ** ¦ F-specs                              ¦
018000200528      ** ¦ =======                              ¦
018100200528      ** +--------------------------------------+
018200200528      *****************************************************************
018300200528
018400200528     FMMVDEAMPD UF A E             DISK    INFSR(*pssr)
018500200528     F                                     COMMIT
018600200528
018700200528     FMMIDEAMPD UF A E             DISK    INFSR(*pssr)
018800200528     F                                     COMMIT
018900200528
019000200528     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
019100200528     F                                     COMMIT
019200200528
019300200528     FMMVDEAML0 IF   E           K DISK    RENAME(MMVDEAMD0:MMVDEAMCHK)
019400200528     F                                     INFSR(*pssr)                         CAP013
019500200528     FMMVDEAML1 IF   E           K DISK    RENAME(MMVDEAMD0:MMVDEAMCK1)         CAP013
019600200528     F                                     INFSR(*pssr)                         CAP013
019700200528
019800200528     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
019900200528                                                                                              CSD095
020000200528     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
020100200528     F                                     INFSR(*PSSR)                                       CSD095
020200200528
020300200528      * Hook to enable non-core files to be included
020400200528      /COPY WNCPYSRC,MMDEAMC019
020500200528
020600200528      *****************************************************************
020700200528      ** +--------------------------------------+
020800200528      ** ¦ Automatically included D-specs       ¦
020900200528      ** ¦ ==============================       ¦
021000200528      ** +--------------------------------------+
021100200528      **
021200200528      ** Standard D-specs
021300200528      ** ================
021400200528      **
021500200528      ** The following /COPY line includes the LDA layout,
021600200528      ** the copyright array definition,
021700200528      ** and the following named constants:
021800200528      **    True       logical = *on (for indcator processing)
021900200528      **    False      logical = *off (for indcator processing)
022000200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
022100200528      **                                    handler)
022200200528      ** and the following variables:
022300200528      **    RunBefore  1A (for the PSSR)
022400200528
022500200528     D/COPY ZACPYSRC,STD_D_SPEC
022600200528
022700200528      ** Include the MM standard declares
022800200528     D/COPY ZACPYSRC,STDDECLARE
022900200528
023000200528      ** Program Status Data Structure
023100200528      ** =============================
023200200528      ** The following /COPY line includes all the defined fields in the
023300200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
023400200528
023500200528     D/COPY ZACPYSRC,PSDS
023600200528      ** The following /COPY line includes definitions for the above fields
023700200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
023800200528      ** corresponding fields in the PSDS /COPY member, so that member
023900200528      ** must be included where this one is used.
024000200528
024100200528     D/COPY ZACPYSRC,PROCPARMS
024200200528
024300200528      **--------------------------------------------------------------------------------------------
024400200528      ** The following /COPY line includes the definitions for error and
024500200528      ** warning message arrays.
024600200528     D/COPY ZACPYSRC,ERR_ARRAYS
024700200528      **--------------------------------------------------------------------------------------------
024800200528
024900200528      **--------------------------------------------------------------------------------------------
025000200528      ** The following /COPY line includes the definitions for arrays
025100200528      ** specific to API *CTL modules.
025200200528     D/COPY ZACPYSRC,APICTLARR
025300200528      **--------------------------------------------------------------------------------------------
025400200528
025500200528      **--------------------------------------------------------------------------------------------
025600200528      ** The following /COPY line includes the definitions for fields           148855
025700200528      ** used in checking whether there are messages on the data queue.         148855
025800200528     D/COPY ZACPYSRC,DTAQCHKDCL                                                 148855
025900200528      **--------------------------------------------------------------------------------------------
026000200528
026100200528
026200200528      ** +--------------------------------------+
026300200528      ** ¦ End of automatically included D-specs¦
026400200528      ** ¦ =====================================¦
026500200528      ** +--------------------------------------+
026600200528
026700200528      *****************************************************************
026800200528      /EJECT
026900200528      *****************************************************************
027000200528
027100200528      ** +--------------------------------------+
027200200528      ** ¦ Manually included D-specs            ¦
027300200528      ** ¦ =========================            ¦
027400200528      ** +--------------------------------------+
027500200528
027600200528      ** +--------------------------------------+
027700200528      ** ¦ Named constants                      ¦
027800200528      ** ¦ ===============                      ¦
027900200528      ** +--------------------------------------+
028000200528
028100200528      ** String for error messages to the operator
028200200528     D ProcErr         C                   CONST('Error in module')
028300200528
028400200528     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
028500200528     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
028600200528      ** +--------------------------------------+
028700200528      ** ¦ Arrays and Data Structures           ¦
028800200528      ** ¦ ==========================           ¦
028900200528      ** +--------------------------------------+
029000200528
029100200528      * Array to hold Commitment Job Names                                                    CSC022
029200200528     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
029300200528                                                                                              CSC022
029400200528      ** Commitment Control Data Area                                                         CSC022
029500200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
029600200528     D  wComitJob              4    103                                                       CSC022
029700200528                                                                                              CSC022
029800200528      * Incoming Header
029900200528     D HeadIn        E DS                  EXTNAME(APHEADPD)
030000200528
030100200528     D TranIn        E DS                  EXTNAME(MMDEAMPD)
030200200528      * Incoming Transaction
030300200528
030400200528     D ValidDeal     E DS                  EXTNAME(MMVDEAMPD)
030500200528      * Valid Deals layout
030600200528     D*MMVDRecIns            300    368                                                       CGL029
030700200528     D*MMVDPayIns            369    927                                                       CGL029
030800200528     D MMVDRecIns            314    368                                                       CGL029
030900200528     D MMVDPayIns            383    927                                                       CGL029
031000200528      * Large fields to include
031100200528      * - Receive instructions (xxRSTM to xxROCN)
031200200528      * - Pay     instructions (xxPSTM to xxBTB6)
031300200528
031400200528     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
031500200528     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
031600200528     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
031700200528     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
031800200528     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
031900200528     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
032000200528     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
032100200528      * (Current) Deal in File Format
032200200528     D*DEAMRecIns            300    368                                                       CGL029
032300200528     D DEAMRecIns1           300    301                                                       CGL029
032400200528     D DEAMRecIns2           314    368                                                       CGL029
032500200528     D*DEAMPayIns            369    927                                                       CGL029
032600200528     D DEAMPayIns1           369    370                                                       CGL029
032700200528     D DEAMPayIns2           383    927                                                       CGL029
032800200528      * Large fields to include
032900200528      * - Receive instructions (xxRSTM to xxROCN)
033000200528      * - Pay     instructions (xxPSTM to xxBTB6)
033100200528
033200200528     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
033300200528     D                                     PREFIX(@)
033400200528      * (Current) Deal in Screen Format
033500200528
033600200528     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
033700200528      * Pay Settlement Instructions - Input
033800200528
033900200528     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
034000200528      * Receive Settlement Instructions - Input
034100200528
034200200528     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
034300200528      * FRA/IRS Settlement Instructions - Input
034400200528
034500200528     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
034600200528      * Pay Settlement Instructions - Current                                   CAP011
034700200528                                                                                CAP011
034800200528     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
034900200528      * Receive Settlement Instructions - Current                               CAP011
035000200528                                                                                CAP011
035100200528     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
035200200528      * FRA/IRS Settlement Instructions - Current                               CAP011
035300200528                                                                                CAP011
035400200528     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
035500200528      * Pay Settlement Instructions - File (D/B) format
035600200528     D FLPAY2                 21    565                                                       CGL029
035700200528
035800200528     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
035900200528      * Receive Settlement Instructions - File (D/B) format
036000200528     D FLREC2                 21     75                                                       CGL029
036100200528
036200200528     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
036300200528      * FRA/IRS Settlement Instructions - File (D/B) format
036400200528                                                                                CAP051
036500200528     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
036600200528      * MM Extra Data - Classe 1 Data - File (D/B) format                       CAP051
036700200528     D                                     PREFIX(IF_)                          CAP051
036800200528                                                                                CAP004
036900200528     D*ExtData****   E DS                  EXTNAME(MMLDEXPD)             CAP004 194994
037000200528     D ExtData       E DS                  EXTNAME(MMDAEXPD)                    194994
037100200528      * MM Extra Data - File (D/B) format                                       CAP004
037200200528                                                                                CAP051
037300200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
037400200528      ** External DS for SAR details                                            CAP051
037500200528
037600200528     D DSFDY         E DS                  EXTNAME(DSFDY)
037700200528      * First DS for Access programs - short data structure
037800200528
037900200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
038000200528      ** External DS for Bank Details
038100200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
038200200528      ** External DS for API ICD                                                CAP011
038300200528
038400200528     D                 DS
038500200528     D**  Data Structure to parameter date passed to mm0085
038600200528     D  @PDAT                  1      8  0
038700200528     D  @PDYY                  1      4  0
038800200528     D  @PYEAR                 3      4  0
038900200528     D  @PDMM                  5      6  0
039000200528     D  @PDDD                  7      8  0
039100200528
039200200528     D                 DS
039300200528     D**  Data Structure for screen value date
039400200528     D  @VDAT                  1      6
039500200528     D  @DSPD                  1      2
039600200528     D  @DSPM                  3      4
039700200528     D  @DSPY                  5      6
039800200528
039900200528     D*DtqRec**********DS            54                                         148855
040000200528     ******DS*for*Data*Queue****************************************************148855
040100200528     D**MsgNumber******        8     11B 0                                      148855
040200200528     D*DtqMsgSel*******DS             7                                         148855
040300200528     D**MsgType********        1      1    INZ('F')                             148855
040400200528     D**MsgBytes*******        4      7B 0                                      148855
040500200528
040600200528     D MMDEAMUPC       DS             1    DTAARA(MMDEAMUPC)
040700200528                                                                                              CSC011
040800200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
040900200528      ** 24X7 status dataarea                                                                 CSC011
041000200528                                                                                              CSC011
041100200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
041200200528      ** SD data area                                                                         CSC011
041300200528
041400200528      ** +--------------------------------------+
041500200528      ** ¦ Declared variables                   ¦
041600200528      ** ¦ ==================                   ¦
041700200528      ** +--------------------------------------+
041800200528
041900200528      ** Error message field(s)
042000200528     D     Msg1        S                   LIKE(#MsgID)
042100200528
042200200528      ** Index for arrays of error message ids etc
042300200528     D Idx             S              3P 0
042400200528
042500200528      ** Index for arrays of warning message ids etc
042600200528     D WIdx            S              3P 0
042700200528
042800200528      ** Field (500A) to receive the incoming transaction
042900200528     D Trans500        S            500A
043000200528                                                                                CAP051
043100200528      ** Field (500A) to receive the incoming Extra Data                        CAP051
043200200528     D InfData500      S            500A                                        CAP051
043300200528                                                                                CAP004
043400200528      ** Field (500A) to receive the incoming Extra Data                        CAP004
043500200528     D ExtData500      S            500A                                        CAP004
043600200528
043700200528      ** Index for arrays of error message ids etc in Amend validation
043800200528     D AmIdx           S              3P 0
043900200528
044000200528      ** Indicies for arrays used to set up corresponding sequence numbers
044100200528      **  for the fields that are in error
044200200528     D Ix              S              3P 0
044300200528     D Iy              S              3P 0
044400200528
044500200528      ** Flags to indicate whether transaction fields are valid
044600200528     D OKFlagsDS       DS
044700200528     D  DDActnOK                      1A   INZ('Y')
044800200528     D  DDDlnoOK                      1A   INZ('Y')
044900200528     D  DDVDatOK                      1A   INZ('Y')
045000200528     D  DDDS38OK                      1A   INZ('Y')
045100200528     D  DDCsnmOK                      1A   INZ('Y')
045200200528     D  DDMTypOK                      1A   INZ('Y')
045300200528     D  DDIntrOK                      1A   INZ('Y')
045400200528     D  DDCcyOK                       1A   INZ('Y')
045500200528     D  DDAmnpOK                      1A   INZ('Y')
045600200528     D  DDFsrpOK                      1A   INZ('Y')
045700200528     D  DDPenPOK                      1A   INZ('Y')                                           CDL017
045800200528     D  DDEmdtOK                      1A   INZ('Y')                                           CDL017
045900200528     D  DDBsrtOK                      1A   INZ('Y')                                           CDL022
046000200528     D  DDAirOK                       1A   INZ('Y')                                           CDL020
046100200528
046200200528      ** Flags to indicate whether Pay Settlement instruction fields
046300200528      **  are valid
046400200528     D OKPayInsDS      DS
046500200528     D  DDPscyOK                      1A   INZ('Y')
046600200528     D  DDPstmOK                      1A   INZ('Y')
046700200528     D  DDPonxOK                      1A   INZ('Y')
046800200528     D  DDRvnoOK                      1A   INZ('Y')
046900200528     D  DDCvmrOK                      1A   INZ('Y')
047000200528     D  DDPocnOK                      1A   INZ('Y')
047100200528     D  DDPobnOK                      1A   INZ('Y')
047200200528     D  DDRcrnOK                      1A   INZ('Y')
047300200528     D  DDRcraOK                      1A   INZ('Y')
047400200528     D  DDPibnOK                      1A   INZ('Y')
047500200528     D  DDPibaOK                      1A   INZ('Y')
047600200528     D  DDAwbnOK                      1A   INZ('Y')
047700200528     D  DDAwbaOK                      1A   INZ('Y')
047800200528     D  DDBennOK                      1A   INZ('Y')
047900200528     D  DDBenaOK                      1A   INZ('Y')
048000200528     D  DDDtp1OK                      1A   INZ('Y')
048100200528     D  DDDtp2OK                      1A   INZ('Y')
048200200528     D  DDDtp3OK                      1A   INZ('Y')
048300200528     D  DDDtp4OK                      1A   INZ('Y')
048400200528     D  DDDchgOK                      1A   INZ('Y')
048500200528     D  DDIc72OK                      1A   INZ('Y')
048600200528     D  DDBtb1OK                      1A   INZ('Y')
048700200528     D  DDBtb2OK                      1A   INZ('Y')
048800200528     D  DDBtb3OK                      1A   INZ('Y')
048900200528     D  DDBtb4OK                      1A   INZ('Y')
049000200528     D  DDBtb5OK                      1A   INZ('Y')
049100200528     D  DDBtb6OK                      1A   INZ('Y')
049200200528
049300200528      ** Flags to indicate whether Receive Settlement instruction fields
049400200528      **  are valid
049500200528     D OKRecInsDS      DS
049600200528     D  DDRscyOK                      1A   INZ('Y')
049700200528     D  DDRstmOK                      1A   INZ('Y')
049800200528     D  DDRonxOK                      1A   INZ('Y')
049900200528     D  DDRocnOK                      1A   INZ('Y')
050000200528     D  DDRobnOK                      1A   INZ('Y')
050100200528     D  DDRibnOK                      1A   INZ('Y')
050200200528     D  DDRibaOK                      1A   INZ('Y')
050300200528
050400200528      ** Flags to indicate whether FRA/IRS instruction fields are valid
050500200528     D OKFRAInsDS      DS
050600200528     D  DDDsr1OK                      1A   INZ('Y')
050700200528     D  DDDsr2OK                      1A   INZ('Y')
050800200528     D  DDDsr3OK                      1A   INZ('Y')
050900200528     D  DDDsr4OK                      1A   INZ('Y')
051000200528     D  DDDsr5OK                      1A   INZ('Y')
051100200528     D  DDDsr6OK                      1A   INZ('Y')
051200200528     D  DDSsr1OK                      1A   INZ('Y')
051300200528     D  DDSsr2OK                      1A   INZ('Y')
051400200528     D  DDSsr3OK                      1A   INZ('Y')
051500200528     D  DDSsr4OK                      1A   INZ('Y')
051600200528     D  DDSsr5OK                      1A   INZ('Y')
051700200528     D  DDSsr6OK                      1A   INZ('Y')
051800200528     D  DDCnd1OK                      1A   INZ('Y')
051900200528     D  DDCnd2OK                      1A   INZ('Y')
052000200528     D  DDCnd3OK                      1A   INZ('Y')
052100200528     D  DDCnd4OK                      1A   INZ('Y')
052200200528     D  DDCnd5OK                      1A   INZ('Y')
052300200528     D  DDCnd6OK                      1A   INZ('Y')
052400200528     D  DDIsdaOK                      1A   INZ('Y')
052500200528     D  DDAgtyOK                      1A   INZ('Y')
052600200528     D  DDAgdtOK                      1A   INZ('Y')
052700200528     D  DDAgvvOK                      1A   INZ('Y')
052800200528
052900200528      ** Flag to indicate outcome of call to lower level module
053000200528     D AmendOK         S              1A   INZ('Y')
053100200528
053200200528      ** Overall Transaction status, to be passed to the Message Handler
053300200528     D TranStatus      S              1A
053400200528
053500200528      ** Module ID, to be passed to the Message Handler
053600200528     D ModuleID        S              2A
053700200528
053800200528      ** A code to indicate the calling function to the lower level modules
053900200528     D DEAM            S              4A   INZ('DEAM')
054000200528
054100200528      ** Payment & Receipt dates, passed to Settlements Validation routine.
054200200528      ** spaces in parameter list not used by this function
054300200528     D PayDat          S              5P 0 INZ(99999)
054400200528     D RecDat          S              5P 0 INZ(99999)
054500200528
054600200528      ** Value Date as a Midas Day Number to be placed in either Payment
054700200528      **  or Receipt Date
054800200528     D ValDateMDN      S              5P 0
054900200528
055000200528      ** Blank fields, passed to Settlements Defaulting routine, to fill
055100200528      ** spaces in parameter list not used by this function
055200200528     D Blank1          S              1A   INZ(*BLANKS)
055300200528     D Blank2          S              2A   INZ(*BLANKS)
055400200528     D Blank3          S              3A   INZ(*BLANKS)
055500200528     D Blank4          S              4A   INZ(*BLANKS)
055600200528     D Blank6          S              6A   INZ(*BLANKS)
055700200528
055800200528      ** Error Flag for call to Standard routines (equates to *IN99)
055900200528     D ErrorFlag       S              1A   INZ('N')
056000200528
056100200528      ** Timestamp for the transaction
056200200528     D TimeStamp       S               Z
056300200528
056400200528     ****Data*queue*parms*******************************************************148855
056500200528     D*DtqLenB*********S              9B 0                                      148855
056600200528     D*DtqFmt**********S              8A                                        148855
056700200528     D*DtqNamLib*******S             20A                                        148855
056800200528     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
056900200528     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
057000200528     D*DtqMsgFmt*******S              8A                                        148855
057100200528     D*DtqErr**********S             50A                                        148855
057200200528
057300200528     D Object          S             10A   INZ('MMDEAMUPC')
057400200528     D Lib             S             10A   INZ('*LIBL')
057500200528     D ObjType         S              7A
057600200528     D LockState       S              7A   INZ('*SHRRD')
057700200528     D Member          S             10A
057800200528     D WaitTime        S              6A   INZ('0     ')
057900200528     D Dlcobj          S              1A   INZ('Y')
058000200528     D Return          S              7A
058100200528
058200200528      ** Dummy message ID and message file fields for use on the calls to
058300200528      ** ZAMSGTOOPR
058400200528     D DummyMsgID      S                   LIKE(#MsgID)
058500200528     D DummyMsgF       S             10A
058600200528                                                                                              CSC011
058700200528     D CSC011          S              1A   INZ('N')                                           CSC011
058800200528     D TRANSDTL        S           5800A                                                      CSC011
058900200528     D*PDealNo         S             18A                                               CSC011 CGL029
059000200528     D*PADealNo        S             18A                                               CSC011 CGL029
059100200528     D PDealNo         S             24A                                                      CGL029
059200200528     D PADealNo        S             24A                                                      CGL029
059300200528     D PRTCD           S              7A                                                      CSC011
059400200528     D POPTN           S              7A                                                      CSC011
059500200528     D PSARD           S              6A                                                      CSC011
059600200528
059700200528      ** Work variables for CSC022                                                            CSC022
059800200528     D CSC022          S              1A   INZ('N')                                           CSC022
059900200528     D wCommitSkip     S              1A   INZ('N')                                           CSC022
060000200528                                                                                              CSC022
060100200528     D PRetCode        S              7A                                                      CSC024
060200200528     D P@OP01          S             20A                                                      CSC024
060300200528     D P@VL01          S            200A                                                      CSC024
060400200528     D P@OP02          S             20A                                                      CSC024
060500200528     D P@VL02          S            200A                                                      CSC024
060600200528     D P@OP03          S             20A                                                      CSC024
060700200528     D P@VL03          S            200A                                                      CSC024
060800200528     D P@OP04          S             20A                                                      CSC024
060900200528     D P@VL04          S            200A                                                      CSC024
061000200528     D P@OP05          S             20A                                                      CSC024
061100200528     D P@VL05          S            200A                                                      CSC024
061200200528     D P@OP06          S             20A                                                      CSC024
061300200528     D P@VL06          S            200A                                                      CSC024
061400200528     D P@OP07          S             20A                                                      CSC024
061500200528     D P@VL07          S            200A                                                      CSC024
061600200528     D P@OP08          S             20A                                                      CSC024
061700200528     D P@VL08          S            200A                                                      CSC024
061800200528     D P@OP09          S             20A                                                      CSC024
061900200528     D P@VL09          S            200A                                                      CSC024
062000200528     D P@OP10          S             20A                                                      CSC024
062100200528     D P@VL10          S            200A                                                      CSC024
062200200528                                                                                              CSC024
062300200528     D*CSC024***       S              1A                                               CSC024 CSC054
062400200528     D*WOMEInd**       S              1A                                               CSC024 CSC054
062500200528     D CSC054          S              1A                                                      CSC054
062600200528     D WPEAInd         S              1A                                                      CSC054
062700200528                                                                                              CSC024
062800200528     D InRCCY          S              3A                                                     CSF011A
062900200528     D InPCCY          S              3A                                                     CSF011A
063000200528      ** +--------------------------------------+
063100200528      ** ¦ End of D-specs                       ¦
063200200528      ** ¦ ==============                       ¦
063300200528      ** +--------------------------------------+
063400200528
063500200528      ** +----------------------------------------+
063600200528      ** ¦ Hook for non-core D-specs (all types)  ¦
063700200528      ** ¦ also any I-specs (if necessary)        ¦
063800200528      ** ¦ =====================================  ¦
063900200528      ** +----------------------------------------+
064000200528      /COPY WNCPYSRC,MMDEAMC020
064100200528
064200200528      *****************************************************************
064300200528      /EJECT
064400200528      *****************************************************************
064500200528      ** +--- Start of Main processing -----------------------------------+
064600200528      ** ¦                                                                ¦
064700200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
064800200528      ** ¦ executed at program activation.                                ¦
064900200528      ** ¦                                                                ¦
065000200528      ** +----------------------------------------------------------------+
065100200528
065200200528      /COPY WNCPYSRC,MMDEAMC001
065300200528
065400200528      * Incoming transaction is in a 500A field, so that a common CLP
065500200528      * can be used between this module and the one that read the MQ queue.
065600200528      * This module needs to break that 500A by loading it into the
065700200528      * appropriate (externally described) data structure.
065800200528     C                   MOVEL     Trans500      TranIn
065900200528     C                   MOVEL     Infdata500    Infdata                        CAP051
066000200528     C                   MOVEL     Extdata500    Extdata                        CAP004
066100200528
066200200528      ** Generate a timestamp for this transaction
066300200528
066400200528     C                   CALLB     'ZAGENTMSTM'
066500200528     C                   PARM                    TimeStamp
066600200528
066700200528      /COPY WNCPYSRC,MMDEAMC002
066800200528
066900200528      * Reset variables gradually updated
067000200528
067100200528     C                   EXSR      RESETCYCLE
067200200528
067300200528      *  Check if valid deal exists for Front Office ID
067400200528
067500200528     C                   EXSR      ChkValDeal
067600200528      *
067700200528      *  If valid deal does exist (even after delay), fail this input
067800200528      *
067900200528     C     Idx           IFNE      0
068000200528     C                   GOTO      INVALID
068100200528     C                   END
068200200528                                                                                CAP013
068300200528      *  Check if valid deal exists for Midas Deal Number                       CAP013
068400200528                                                                                CAP013
068500200528     C                   EXSR      ChkValMiDl                                   CAP013
068600200528      *                                                                         CAP013
068700200528      *  If valid deal does exist (even after delay), fail this input           CAP013
068800200528      *                                                                         CAP013
068900200528     C     Idx           IFNE      0                                            CAP013
069000200528     C                   GOTO      INVALID                                      CAP013
069100200528     C                   END                                                    CAP013
069200200528
069300200528      * Reset variables again in case the details have been corrupted
069400200528      * by previous chain to valid deams file.
069500200528
069600200528     C                   EXSR      RESETCYCLE
069700200528
069800200528      /COPY WNCPYSRC,MMDEAMC003
069900200528
070000200528      *  Validate Action Code
070100200528
070200200528     C                   EXSR      ValidateAc
070300200528
070400200528      /COPY WNCPYSRC,MMDEAMC004
070500200528
070600200528      *
070700200528      *  If error in validation of action code, fail this input
070800200528      *
070900200528     C     Idx           IFNE      0
071000200528     C                   GOTO      INVALID
071100200528     C                   END
071200200528
071300200528      *  Processing depends upon Action Code
071400200528
071500200528     C                   SELECT
071600200528
071700200528     C                   WHEN      DDACTN = 'I'
071800200528      *  Processing for Inserts
071900200528      /COPY WNCPYSRC,MMDEAMC005
072000200528     C                   EXSR      DftSettmts
072100200528      /COPY WNCPYSRC,MMDEAMC006
072200200528     C                   EXSR      ValidateTr
072300200528      /COPY WNCPYSRC,MMDEAMC007
072400200528     C                   EXSR      ValidateSt
072500200528      /COPY WNCPYSRC,MMDEAMC008
072600200528
072700200528     C                   WHEN      DDACTN = 'A'
072800200528      *  Processing for Amends
072900200528      /COPY WNCPYSRC,MMDEAMC009
073000200528     C     GHSUBS        ifne      *blank                                       CAP011
073100200528     C     GHSUBS        scan      TranIn                                 99    CAP011
073200200528     C     *in99         ifeq      *on                                          CAP011
073300200528     C                   EXSR      TDtDtaSubs                                   CAP011
073400200528     C                   endif                                                  CAP011
073500200528     C                   endif                                                  CAP011
073600200528     C                   EXSR      SetupAmend
073700200528      /COPY WNCPYSRC,MMDEAMC010
073800200528     C                   EXSR      ValidateTr
073900200528      /COPY WNCPYSRC,MMDEAMC011
074000200528     C                   EXSR      ValidateSt
074100200528      /COPY WNCPYSRC,MMDEAMC012
074200200528     C                   EXSR      ValdateAmd
074300200528      /COPY WNCPYSRC,MMDEAMC013
074400200528
074500200528     C                   ENDSL
074600200528
074700200528     C     INVALID       TAG
074800200528
074900200528
075000200528      *  Check for exception error from any program lower in the stack
075100200528      *  If error detected, send message to system operator and
075200200528      *  return to calling program without updating database or
075300200528      *  prompting the database update program
075400200528     C                   IN        APDUMP
075500200528
075600200528      /COPY WNCPYSRC,MMDEAMC014
075700200528
075800200528     C     ARERRMOD      IFNE      *BLANK
075900200528     C                   EVAL      MQErrlong  = *blank
076000200528     C                   MOVEL     ProcErr       MQError
076100200528     C                   MOVE      ARERRMOD      MQError          28
076200200528     C                   MOVEL     MQError       MQErrlong
076300200528
076400200528     C                   CALLB     'ZAMSGTOOPR'
076500200528     C                   PARM                    MQReturn         10
076600200528     C                   PARM                    MQErrlong       132
076700200528     C                   PARM                    DummyMsgID
076800200528     C                   PARM                    DummyMsgF
076900200528
077000200528     C                   MOVEL     ARERRMOD      APRETCODE
077100200528     C     *LOCK         IN        APDUMP
077200200528     C                   EVAL      ARERRMOD = *BLANK
077300200528     C                   OUT       APDUMP
077400200528     C                   RETURN
077500200528
077600200528     C                   ELSE
077700200528
077800200528      *  Processing for Error checking/write to database
077900200528      /COPY WNCPYSRC,MMDEAMC015
078000200528     C                   EXSR      CheckWrite
078100200528      /COPY WNCPYSRC,MMDEAMC016
078200200528
078300200528      *  If valid, send data queue entry to prompt DB update program
078400200528     C     Idx           IFEQ      0
078500200528     C                   EVAL      ObjType = '*DTAARA'
078600200528
078700200528      *  Check if update program active using Allocate Object API
078800200528      *  No prompting necessary if program is running
078900200528     C                   CALLB     'APCALCOBJ'
079000200528     C                   PARM                    Object
079100200528     C                   PARM                    Lib
079200200528     C                   PARM                    ObjType
079300200528     C                   PARM                    LockState
079400200528     C                   PARM                    Member
079500200528     C                   PARM                    WaitTime
079600200528     C                   PARM                    Dlcobj
079700200528     C                   PARM      *BLANK        Return
079800200528     C     Return        IFEQ      *BLANK
079900200528      *  Check if any messages are already on the data queue
080000200528      *  No need to send duplicate prompt messages
080100200528
080200200528      **--------------------------------------------------------------------------------------------
080300200528      ** The following /COPY line includes a check for whether there            148855
080400200528      ** are messages on the server/updater data queue, and sends a 'GO'.       148855
080500200528      ** message to the data queue if there are not.                            148855
080600200528     D/COPY ZACPYSRC,DTAQCHK                                                    148855
080700200528      **--------------------------------------------------------------------------------------------
080800200528
080900200528     C*******************EVAL      DtqLenB = 54                                 148855
081000200528     C*******************EVAL      DtqNamLib = 'APDEAMDTQ *LIBL'                148855
081100200528     C*******************EVAL      MsgBytes = 8                                 148855
081200200528     C*******************CALL      'QMHRDQM'                                    148855
081300200528     C*******************PARM                    DtqRec                         148855
081400200528     C*******************PARM                    DtqLenB                        148855
081500200528     C*******************PARM      'RDQM0100'    DtqFmt                         148855
081600200528     C*******************PARM                    DtqNamLib                      148855
081700200528     C*******************PARM                    DtqMsgSel                      148855
081800200528     C*******************PARM                    DtqMsgLen                      148855
081900200528     C*******************PARM      'RDQS0100'    DtqMsgFmt                      148855
082000200528     C*******************PARM                    DtqErr                         148855
082100200528      *******************                                                       148855
082200200528     C*****MsgNumber*****IFEQ      DtqComp                                      148855
082300200528     C*******************CALL      'QSNDDTAQ'                                   148855
082400200528     C*******************PARM      'APDEAMDTQ'   DtqNam           10            148855
082500200528     C*******************PARM      '*LIBL'       DtqLib           10            148855
082600200528     C*******************PARM                    DtqLen            5 0          148855
082700200528     C*******************PARM      'GO'          DtqDta           10            148855
082800200528     C*******************ENDIF                                                  148855
082900200528     C                   ENDIF
083000200528     C                   ENDIF
083100200528     C                   ENDIF
083200200528
083300200528     C                   RETURN
083400200528
083500200528      * Hook to enable non-core subroutines to be included
083600200528      /COPY WNCPYSRC,MMDEAMC021
083700200528
083800200528      *****************************************************************
083900200528      /EJECT
084000200528      *****************************************************************
084100200528      *                                                               *
084200200528      * ChkValDeal - Routine to check if valid deal exists for        *
084300200528      *    Front Office ID                                            *
084400200528      *                                                               *
084500200528      *****************************************************************
084600200528
084700200528     C     ChkValDeal    BEGSR
084800200528
084900200528      * Check for deal on Valid file
085000200528     C                   MOVE      APFOASOCID    OrigDealNo       20
085100200528     C                   MOVE      APFOTRANID    UniqDeamID       20
085200200528
085300200528     C     OrigDealNo    CHAIN     MMVDEAML0                          99
085400200528
085500200528      * If record found...
085600200528     C     *IN99         IFEQ      '0'
085700200528
085800200528      * ..delay, then repeat check
085900200528     C                   CALLB     'ZACDELAY'
086000200528
086100200528     C     OrigDealNo    CHAIN     MMVDEAML0                          99
086200200528
086300200528      * Error if still present
086400200528     C     *IN99         IFEQ      '0'
086500200528     C                   ADD       1             Idx
086600200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
086700200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
086800200528     C                   ENDIF
086900200528
087000200528     C                   ENDIF
087100200528      *
087200200528     C                   ENDSR
087300200528      *****************************************************************
087400200528      /EJECT                                                                    CAP013
087500200528      *****************************************************************         CAP013
087600200528      *                                                               *         CAP013
087700200528      * ChkValMiDl - Routine to check if valid deal exists for        *         CAP013
087800200528      *    Midas Deal Number                                          *         CAP013
087900200528      *                                                               *         CAP013
088000200528      *****************************************************************         CAP013
088100200528                                                                                CAP013
088200200528     C     ChkValMiDl    BEGSR                                                  CAP013
088300200528                                                                                CAP013
088400200528      * If (numeric) Midas deal number supplied                                 CAP013
088500200528                                                                                CAP013
088600200528     C                   TESTN                   DDDLNO               9898      CAP013
088700200528                                                                                CAP013
088800200528     C     DDDLNO        IFNE      *BLANKS                                      CAP013
088900200528     C     *IN98         ANDEQ     '1'                                          CAP013
089000200528                                                                                CAP013
089100200528      * Check for deal on Valid file                                            CAP013
089200200528     C                   MOVEL     DDDLNO        IGDA38                         CAP013
089300200528     C     IGDA38        CHAIN     MMVDEAML1                          99        CAP013
089400200528                                                                                CAP013
089500200528      * If record found...                                                      CAP013
089600200528     C     *IN99         IFEQ      '0'                                          CAP013
089700200528                                                                                CAP013
089800200528      * ..delay, then repeat check                                              CAP013
089900200528     C                   CALLB     'ZACDELAY'                                   CAP013
090000200528                                                                                CAP013
090100200528     C     IGDA38        CHAIN     MMVDEAML1                          99        CAP013
090200200528                                                                                CAP013
090300200528      * Error if still present                                                  CAP013
090400200528     C     *IN99         IFEQ      '0'                                          CAP013
090500200528     C                   ADD       1             Idx                            CAP013
090600200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
090700200528     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
090800200528     C                   ENDIF                                                  CAP013
090900200528     C                   ENDIF                                                  CAP013
091000200528     C                   ENDIF                                                  CAP013
091100200528      *                                                                         CAP013
091200200528     C                   ENDSR                                                  CAP013
091300200528      *****************************************************************         CAP013
091400200528      /EJECT
091500200528      *****************************************************************
091600200528      *                                                               *
091700200528      * ValidateAc - Routine to validate action code versus the       *
091800200528      *    transaction IDs supplied                                   *
091900200528      *                                                               *
092000200528      *****************************************************************
092100200528
092200200528     C     ValidateAc    BEGSR
092300200528      *                                                                         CAP013
092400200528      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
092500200528      *  if insert                                                              CAP013
092600200528      *  if not insert and Midas transaction ID is not present                  CAP013
092700200528      * Otherwise                                                               CAP013
092800200528      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
092900200528      *                                                                         CAP013
093000200528     C                   MOVEL     APFOTranID    WFrontId          2            CPB002
093100200528      *                                                                         CPB002
093200200528     C     DDACTN        IFEQ      'I'                                          CAP013
093300200528     C     WFrontId      ANDNE     'TO'                                         CPB002
093400200528     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
093500200528     C                   ELSE                                                   CAP013
093600200528     C     DDDLNO        IFEQ      *BLANK                                       CAP013
093700200528     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
093800200528     C                   ELSE                                                   CAP013
093900200528     C                   MOVEL     '      '      ModeofOp                       CAP013
094000200528     C                   ENDIF                                                  CAP013
094100200528     C                   ENDIF                                                  CAP013
094200200528
094300200528      * Validate action code versus transaction IDs supplied
094400200528      * This function will set the Midas deal number of the original deal
094500200528      * The deam in file format from the MM database is retrieved as well.
094600200528
094700200528     C                   RESET                   ReturnCode
094800200528     C                   CALLB     'MMDEAMRTV'
094900200528
095000200528      * INPUTS
095100200528
095200200528      * Return code
095300200528     C                   PARM                    ReturnCode
095400200528
095500200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
095600200528      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
095700200528     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
095800200528     C                   PARM                    ModeofOp          6            CAP013
095900200528      *
096000200528      * Response mode
096100200528     C                   PARM                    APRESPMODE
096200200528
096300200528      * Action Code
096400200528     C                   PARM                    DDACTN
096500200528
096600200528      * Front Office Transaction ID
096700200528     C                   PARM                    APFOTranID
096800200528
096900200528      * Front Office Associated Transaction Id
097000200528     C                   PARM                    APFOAsocID
097100200528
097200200528      * (Midas) Deal Number
097300200528     C                   PARM                    DDDLNO
097400200528
097500200528      * Value Date
097600200528     C                   PARM                    DDVDAT
097700200528      *
097800200528      * Sequence Number
097900200528     C                   PARM                    DDDS38
098000200528      *
098100200528      * Deal Amendment Amount
098200200528     C                   PARM                    DDAMNP
098300200528      *
098400200528      * Deal Amendment Type
098500200528     C                   PARM                    DDMTYP
098600200528      * Action Code (Reversal transaction)                                                    260173
098700200528     C                   PARM      *BLANK        @ACTRV            1                          260173
098800200528
098900200528      * OUTPUTS
099000200528
099100200528      * (Current) deal in file format
099200200528     C                   PARM                    DealFilFmt
099300200528
099400200528      * OK - Action code
099500200528     C                   PARM                    DDActnOK
099600200528
099700200528      * OK - Deal Number
099800200528     C                   PARM                    DDDlnoOK
099900200528
100000200528      * OK - Value Date
100100200528     C                   PARM                    DDVDatOK
100200200528
100300200528      * OK - Sequence Number
100400200528     C                   PARM                    DDDS38OK
100500200528
100600200528      * Error fields/message IDs/message data (arrays) from/to caller
100700200528     C                   PARM                    FldNameArr
100800200528     C                   PARM                    MsgIDArr
100900200528     C                   PARM                    MsgDtaArr
101000200528
101100200528      * Array index (3P0) from/to caller
101200200528     C                   PARM                    Idx
101300200528
101400200528     C                   ENDSR
101500200528      *****************************************************************
101600200528      /EJECT
101700200528      *****************************************************************
101800200528      *                                                               *
101900200528      * DftSettmts - Routine to apply default settlement instructions *
102000200528      *    if none have been supplied                                 *
102100200528      *                                                               *
102200200528      *****************************************************************
102300200528
102400200528     C     DftSettmts    BEGSR
102500200528
102600200528      * If ANY of the Settlements fields have been entered, bypass this
102700200528      *  routine.
102800200528      * Otherwise, use modules which will use Standard Settlement
102900200528      *  Instructions to apply defaults.
103000200528
103100200528     C                   IF            (InRecSttmt = *blank)
103200200528     C                             AND (InPaySttmt = *blank)
103300200528
103400200528      * Deal Amendment types 'SC' and 'CI' should have no settlement
103500200528      * instructions; initialise pay and receive settlement methods.
103600200528
103700200528     C     DDMTYP        IFEQ      'SC'
103800200528     C     DDMTYP        OREQ      'CI'
103900200528     C                   MOVEL     '00'          DDPSTM
104000200528     C                   MOVEL     '00'          DDRSTM
104100200528     C                   GOTO      EDFTSETT
104200200528     C                   ENDIF
104300200528
104400200528      ** Retrieve the subtype and branch associated with the deal                             CSD095
104500200528                                                                                              CSD095
104600200528     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
104700200528     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
104800200528                                                                                              CSD095
104900200528     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
105000200528     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
105100200528     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
105200200528     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
105300200528     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
105400200528     C                   ENDIF                                                                CSD095
105500200528                                                                                              CSD095
105600200528     C                   CALLB     'ZASETINDFT'
105700200528
105800200528      ** Output
105900200528      ** Calling function type
106000200528     C                   PARM                    DEAM
106100200528      ** Payment currency (or deal cuurency if only one currency on deal)
106200200528     C                   PARM                    DDCcy
106300200528      ** Receive currency (only if deal has two currencies)
106400200528     C**********         PARM                    Blank3                                       165903
106500200528     C                   PARM                    DDCcy                                        165903
106600200528     C/COPY WNCPYSRC,MMDEAMCC02
106700200528      ** Customer (shortname or number)
106800200528     C                   PARM                    DDCsnm
106900200528      ** Deal type
107000200528     C                   PARM                    DDMTyp
107100200528      ** Federal Funds Ind. (not applicable for DEAMS)
107200200528     C                   PARM                    Blank1
107300200528      ** ISDA Rules for FRA/IRS deals only
107400200528      ** Version of ISDA Rules govern
107500200528     C                   PARM                    Blank4
107600200528      ** Type of ISDA agreement
107700200528     C                   PARM                    Blank6
107800200528      ** Date of ISDA Agreement
107900200528     C                   PARM                    Blank6
108000200528      ** Version of ISDA Agreement
108100200528     C                   PARM                    Blank2
108200200528      ** Version of ISDA Agreement century                                                    176883
108300200528     C                   PARM                    Blank2                                       176883
108400200528      ** Deal Subtype                                                                         CSD095
108500200528     C                   PARM                    DDSTYP            2                          CSD095
108600200528      ** Branch                                                                               CSD095
108700200528     C                   PARM                    DDBRCA            3                          CSD095
108800200528      *
108900200528      ** Return
109000200528      ** Defaulted Payment Settlement Instruction in file format
109100200528     C                   PARM                    DBPaySttmt
109200200528      ** Defaulted Receipt Settlement Instruction in file format
109300200528     C                   PARM                    DBRecSttmt
109400200528      ** Defaulted FRA/IRS Settlement Instruction in file format
109500200528     C                   PARM                    DBFRASttmt
109600200528
109700200528      *  The defaulted instructions are in file format, but the
109800200528      *   Settlements validation requires that they are in the input format.
109900200528      *  Therefore run them through a conversion module.
110000200528
110100200528     C                   CALLB     'ZASETINCVT'
110200200528      ** Defaulted Settlement Instructions in file format
110300200528     C                   PARM                    DBPaySttmt
110400200528     C                   PARM                    DBRecSttmt
110500200528     C                   PARM                    DBFRASttmt
110600200528
110700200528      ** Defaulted Settlement Instruction in input format
110800200528     C                   PARM                    InPaySttmt
110900200528     C                   PARM                    InRecSttmt
111000200528     C                   PARM                    InFRASttmt
111100200528     C                   PARM      DDCCY         InRCCY                                      CSF011A
111200200528     C                   PARM      DDCCY         InPCCY                                      CSF011A
111300200528      *
111400200528      * LOAN OR DEPOSIT TYPE DEAL?  (FROM RETRIEVE FUNCTION)
111500200528      *
111600200528     C     HNOMDT        IFEQ      'IT'
111700200528     C     HNOMDT        OREQ      'TD'
111800200528     C     HNOMDT        OREQ      'CI'
111900200528     C     HNOMDT        OREQ      'CD'
112000200528     C                   MOVEL     'D'           W#LOD             1
112100200528     C                   ELSE
112200200528     C                   MOVEL     'L'           W#LOD
112300200528     C                   END
112400200528
112500200528      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
112600200528      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
112700200528      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
112800200528
112900200528     C     DDMTYP        IFEQ      'PD'
113000200528     C     W#LOD         ANDEQ     'D'
113100200528     C     DDMTYP        OREQ      'PI'
113200200528     C     W#LOD         ANDEQ     'L'
113300200528     C     DDMTYP        OREQ      'SI'
113400200528     C     W#LOD         ANDEQ     'D'
113500200528      *
113600200528     C                   CLEAR                   InRecSttmt
113700200528     C                   MOVEL     '00'          DDRSTM
113800200528      *
113900200528      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
114000200528      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
114100200528      ** OR SETTLE INTEREST OF DEPOSIT PLACED
114200200528      **
114300200528     C                   ELSE
114400200528      *
114500200528     C     DDMTYP        IFEQ      'PD'
114600200528     C     W#LOD         ANDEQ     'L'
114700200528     C     DDMTYP        OREQ      'PI'
114800200528     C     W#LOD         ANDEQ     'D'
114900200528     C     DDMTYP        OREQ      'SI'
115000200528     C     W#LOD         ANDEQ     'L'
115100200528      *
115200200528     C                   CLEAR                   InPaySttmt
115300200528     C                   MOVEL     '00'          DDPSTM
115400200528
115500200528     C                   ENDIF
115600200528     C                   ENDIF
115700200528      *
115800200528     C                   ENDIF
115900200528
116000200528     C     EDFTSETT      ENDSR
116100200528      *****************************************************************
116200200528      /EJECT
116300200528      *****************************************************************
116400200528      *                                                               *
116500200528      * SETUPAMEND - Set up fields that are needed in the validation  *
116600200528      *    of Amendments.                                             *
116700200528      *                                                               *
116800200528      *****************************************************************
116900200528
117000200528     C     SetupAmend    BEGSR
117100200528
117200200528      * For Amends, put the complete (pre-existing) deam into the
117300200528      *  Valid file record - fields in this will be updated during
117400200528      *  processing
117500200528     C                   MOVE      DealFilFmt    ValidDeal
117600200528
117700200528      ***The*Settlement*Instructions*fields*may*not*be*supplied*for*an*****     CAP011
117800200528      ***amendment.*If*none*of*the*pay/receive*instructions*were***********     CAP011
117900200528      ***supplied*(i.e.*all*are*blank),*default*the*existing*database******     CAP011
118000200528      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
118100200528      *********************************************************************     CAP011
118200200528     C*******************IF************(InRecSttmt*=**blank)***************     CAP011
118300200528     C*****************************AND*(InPaySttmt*=**blank)***************     CAP011
118400200528
118500200528     C**********         EVAL      DBRecSttmt = DEAMRecIns + HNOSBR                           CGL029
118600200528     C                   EVAL      DBRecSttmt = DEAMRecIns1 + HNRONS +                        CGL029
118700200528     C                                          DEAMRecIns2 + HNOSBR                          CGL029
118800200528     C                   EVAL      FLRSCY     = HNSTCY
118900200528     C**********         EVAL      DBPaySttmt = DEAMPayIns + HNOSBR + HNCVMR                  CGL029
119000200528     C                   EVAL      DBPaySttmt = DEAMPayIns1 + HNPONS +                        CGL029
119100200528     C                                          DEAMPayIns2 + HNOSBR + HNCVMR                 CGL029
119200200528     C                   EVAL      FLPSCY     = HNSTCY
119300200528     C                   EVAL      FLIC72     = HNIC72
119400200528
119500200528      *  .... and then convert these to the screen format
119600200528     C                   CALLB     'ZASETINCVT'
119700200528
119800200528      ** Defaulted Settlement Instructions in file format
119900200528     C                   PARM                    DBPaySttmt
120000200528     C                   PARM                    DBRecSttmt
120100200528     C                   PARM                    DBFRASttmt
120200200528                                                                                CAP011
120300200528      ** Current Settlement Instruction in input format                         CAP011
120400200528     C                   PARM                    CrPaySttmt                     CAP011
120500200528     C                   PARM                    CrRecSttmt                     CAP011
120600200528     C                   PARM                    CrFRASttmt                     CAP011
120700200528     C                   PARM      HNCCY         InRCCY                                      CSF011A
120800200528     C                   PARM      HNCCY         InPCCY                                      CSF011A
120900200528                                                                                CAP011
121000200528      *  If no Payment or Receive instructions have been supplied               CAP011
121100200528      *  Default them to those currently on the deal.                           CAP011
121200200528                                                                                CAP011
121300200528     C                   IF            (InPaySttmt = *blank)                    CAP011
121400200528     C                   EVAL      InPaySttmt = CrPaySttmt                      CAP011
121500200528     C                   ENDIF                                                  CAP011
121600200528                                                                                CAP011
121700200528     C                   IF            (InRecSttmt = *blank)                    CAP011
121800200528     C                   EVAL      InRecSttmt = CrRecSttmt                      CAP011
121900200528     C                   ENDIF                                                  CAP011
122000200528                                                                                CAP011
122100200528      * Do data substitution for Settlement Instructions                        CAP011
122200200528                                                                                CAP011
122300200528     C     GHSUBS        ifne      *blank                                       CAP011
122400200528     C     GHSUBS        scan      InPaySttmt                             99    CAP011
122500200528     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
122600200528     C     *in99         ifeq      *on                                          CAP011
122700200528     C                   EXSR      SDtDtaSubs                                   CAP011
122800200528     C                   endif                                                  CAP011
122900200528     C                   endif                                                  CAP011
123000200528
123100200528      ***Defaulted*Settlement*Instruction*in*input*format**                     CAP011
123200200528     C*******************PARM********************InPaySttmt                     CAP011
123300200528     C*******************PARM********************InRecSttmt                     CAP011
123400200528     C*******************PARM********************InFRASttmt                     CAP011
123500200528      *****************************************************                     CAP011
123600200528     C*******************ENDIF*****************************                     CAP011
123700200528
123800200528     C                   ENDSR
123900200528      *****************************************************************
124000200528      /EJECT
124100200528      *****************************************************************
124200200528      *                                                               *
124300200528      * ValidateTr - Routine to validate the main tranaction details  *
124400200528      *                                                               *
124500200528      *****************************************************************
124600200528
124700200528     C     ValidateTr    BEGSR
124800200528
124900200528     C                   CALLB     'MMDEAMVAL'
125000200528      * Response mode (1A), from source system common header
125100200528     C                   PARM                    APRespMode
125200200528      * Transaction information (DS) from source system
125300200528     C                   PARM                    TranIn
125400200528     C                   PARM                    InfData                        CAP051
125500200528      * Extra Data                                                              CAP004
125600200528     C                   PARM                    ExtData                        CAP004
125700200528      * Field OK flags (DS) from/to caller
125800200528     C                   PARM                    OKFlagsDS
125900200528      * Error fields/message IDs/message data (arrays) from/to caller
126000200528     C                   PARM                    FldNameArr
126100200528     C                   PARM                    MsgIDArr
126200200528     C                   PARM                    MsgDtaArr
126300200528      * Array index (3P0) from/to caller
126400200528     C                   PARM                    Idx
126500200528      * Warning fields/message IDs/message data (arrays) from/to caller
126600200528     C                   PARM                    WFldNamArr
126700200528     C                   PARM                    WMsgIDArr
126800200528     C                   PARM                    WMsgDtaArr
126900200528      * Array index (3P0) from/to caller
127000200528     C                   PARM                    WIdx
127100200528      * Valid Deals layout (DS) from/to caller
127200200528     C                   PARM                    ValidDeal
127300200528
127400200528     C                   ENDSR
127500200528      *****************************************************************
127600200528      /EJECT
127700200528      *****************************************************************
127800200528      *                                                               *
127900200528      * ValidateSt - Routine to validate the settlemnt instructions   *
128000200528      *                                                               *
128100200528      *****************************************************************
128200200528
128300200528     C     ValidateSt    BEGSR
128400200528
128500200528      * The called module requires that the customer number/name is valid,
128600200528      *  if it is not, exit from this subroutine.
128700200528     C                   IF        NOT (DDCsnmOK = 'Y')
128800200528     C                   GOTO      ValSetExit
128900200528     C                   ENDIF
129000200528
129100200528      * The called module uses the value date in Midas Day Number format,
129200200528      *  which will not have been returned from the overall validation
129300200528      *  routine, so it needs to be converted here.
129400200528
129500200528     C                   IF        DDVDatOK <> 'N'
129600200528
129700200528     C                   CALLB     'ZDATE1'
129800200528     C                   PARM                    DDVDAT
129900200528     C                   PARM                    ValDateMDN
130000200528     C                   PARM                    BJDFIN
130100200528     C                   PARM                    ErrorFlag
130200200528
130300200528      * For Deal Amendments set the Pay Date and Receive Date = Value Date
130400200528     C                   EVAL      PayDat = ValDateMDN
130500200528     C                   EVAL      RecDat = ValDateMDN
130600200528
130700200528     C                   ENDIF
130800200528
130900200528     C                   RESET                   ReturnCode
131000200528     C                   CALLB     'ZASETINVAL'
131100200528
131200200528      ** Return Code
131300200528     C                   PARM                    ReturnCode
131400200528      ** Following parameters are output to called module
131500200528      ** Calling function type
131600200528     C                   PARM                    DEAM
131700200528      ** Transaction Fields
131800200528      ** Payment currency (or deal currency if only one currency on deal)
131900200528     C                   PARM                    DDCCY
132000200528      ** Receive currency (or deal currency if only one currency on deal)
132100200528     C                   PARM                    DDCCY
132200200528      ** Customer (shortname or number)
132300200528     C                   PARM                    DDCsnm
132400200528      ** Deal type
132500200528     C                   PARM                    DDMtyp
132600200528      ** Federal Funds Ind.
132700200528     C                   PARM                    Blank1
132800200528      ** Booking Branch
132900200528     C                   PARM                    Blank3
133000200528      ** Receipt Date
133100200528     C                   PARM                    RecDat
133200200528      ** Payment Date
133300200528     C                   PARM                    Paydat
133400200528      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
133500200528     C                   PARM                    InPaySttmt
133600200528     C                   PARM                    InRecSttmt
133700200528     C                   PARM                    InFRASttmt
133800200528      * Action Code                                                                           185751
133900200528     C                   PARM                    DDACTN                                       185751
134000200528      * Protect Payment Field                                                                 196461
134100200528     C                   PARM                    ##PPAY            1                          196461
134200200528      * Protect Receipt Field                                                                 196461
134300200528     C                   PARM                    ##PREC            1                          196461
134400200528
134500200528      ** Following parameters are returned by called module
134600200528      ** Payment Instruction OK flag
134700200528     C                   PARM                    OKPayInsDS
134800200528      ** Receive Instruction OK flag
134900200528     C                   PARM                    OKRecInsDS
135000200528      ** FRA/IRS Instruction OK flag
135100200528     C                   PARM                    OKFRAInsDS
135200200528      * Error fields/message IDs (arrays) from/to caller
135300200528     C                   PARM                    FldNameArr
135400200528     C                   PARM                    MsgIDArr
135500200528      * Array index (3P0) from/to caller
135600200528     C                   PARM                    Idx
135700200528      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
135800200528     C                   PARM                    WFldNamArr                                   CRE008
135900200528     C                   PARM                    WMsgIDArr                                    CRE008
136000200528     C                   PARM                    WMsgDtaArr                                   CRE008
136100200528      ** Array index (3P0) from/to caller                                                     CRE008
136200200528     C                   PARM                    WIdx                                         CRE008
136300200528      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
136400200528     C                   PARM                    DBPaySttmt
136500200528     C                   PARM                    DBRecSttmt
136600200528     C                   PARM                    DBFRASttmt
136700200528      ** Extra Input                                                                          166888
136800200528      ** Action Code used                                                                     166888
136900200528     C                   PARM      DDACTN        ##ACTN            1                          166888
137000200528      ** Validation Iteration                                                                 166888
137100200528     C                   PARM      '1ST'         ##ValIter         3                          166888
137200200528
137300200528      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
137400200528     C************       PARM                    @MORPI           24                   179510 200400
137500200528      ************                                                                     179510 200400
137600200528     C     ValSetExit    TAG
137700200528
137800200528     C                   ENDSR
137900200528      *****************************************************************
138000200528      /EJECT                                                                    CAP011
138100200528      *****************************************************************         CAP011
138200200528      *                                                               *         CAP011
138300200528      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
138400200528      *                                                               *         CAP011
138500200528      *****************************************************************         CAP011
138600200528                                                                                CAP011
138700200528     C     TDtDtaSubs    BEGSR                                                  CAP011
138800200528                                                                                CAP011
138900200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
139000200528                                                                                CAP011
139100200528     C                   RESET                   ReturnCode                     CAP011
139200200528     C                   CALLB     'MMDEAMCVT'                                  CAP011
139300200528                                                                                CAP011
139400200528      * INPUTS                                                                  CAP011
139500200528      * Return Code                                                             CAP011
139600200528     C                   PARM                    ReturnCode                     CAP011
139700200528      * (Current) Deal in file format                                           CAP011
139800200528     C                   PARM                    DealFilfmt                     CAP011
139900200528                                                                                CAP011
140000200528      * OUTPUTS                                                                 CAP011
140100200528      * (Current) Deal in screen format                                         CAP011
140200200528     C                   PARM                    DealScnfmt                     CAP011
140300200528      * Deal Status                                                             CAP011
140400200528     C                   PARM                    DDSTS                          CAP011
140500200528                                                                                CAP011
140600200528      ** DATA SUBSTITUTION                                                      CAP011
140700200528                                                                                CAP011
140800200528     C                   RESET                   ReturnCode                     CAP011
140900200528     C                   CALLB     'APDTASUBS'                                  CAP011
141000200528                                                                                CAP011
141100200528      * Return Code                                                             CAP011
141200200528     C                   PARM                    ReturnCode       10            CAP011
141300200528      * Substitution character                                                  CAP011
141400200528     C                   PARM      GHSUBS        SubsChar          1            CAP011
141500200528      * Incoming Data                                                           CAP011
141600200528     C                   PARM      TranIn        IncDATA        2000            CAP011
141700200528      * Current Data                                                            CAP011
141800200528     C                   PARM      DealScnfmt    CurDATA        2000            CAP011
141900200528                                                                                CAP011
142000200528     C                   MOVEL     IncDATA       TranIn                         CAP011
142100200528                                                                                CAP011
142200200528     C                   ENDSR                                                  CAP011
142300200528      *****************************************************************         CAP011
142400200528      /EJECT                                                                    CAP011
142500200528      *****************************************************************         CAP011
142600200528      *                                                               *         CAP011
142700200528      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
142800200528      *                                                               *         CAP011
142900200528      *****************************************************************         CAP011
143000200528                                                                                CAP011
143100200528     C     SDtDtaSubs    BEGSR                                                  CAP011
143200200528                                                                                CAP011
143300200528      ** PAYMENT INSTRUCTIONS                                                   CAP011
143400200528     C                   RESET                   ReturnCode                     CAP011
143500200528     C                   CALLB     'APDTASUBS'                                  CAP011
143600200528                                                                                CAP011
143700200528      * Return Code                                                             CAP011
143800200528     C                   PARM                    ReturnCode                     CAP011
143900200528      * Substitution character                                                  CAP011
144000200528     C                   PARM      GHSUBS        SubsChar                       CAP011
144100200528      * Incoming Data                                                           CAP011
144200200528     C                   PARM      InPaySttmt    IncDATA                        CAP011
144300200528      * Current Data                                                            CAP011
144400200528     C                   PARM      CrPaySttmt    CurDATA                        CAP011
144500200528                                                                                CAP011
144600200528     C                   MOVEL     IncDATA       InPaySttmt                     CAP011
144700200528                                                                                CAP011
144800200528      ** RECEIPT INSTRUCTIONS                                                   CAP011
144900200528     C                   RESET                   ReturnCode                     CAP011
145000200528     C                   CALLB     'APDTASUBS'                                  CAP011
145100200528                                                                                CAP011
145200200528      * Return Code                                                             CAP011
145300200528     C                   PARM                    ReturnCode                     CAP011
145400200528      * Substitution character                                                  CAP011
145500200528     C                   PARM      GHSUBS        SubsChar                       CAP011
145600200528      * Incoming Data                                                           CAP011
145700200528     C                   PARM      InRecSttmt    IncDATA                        CAP011
145800200528      * Current Data                                                            CAP011
145900200528     C                   PARM      CrRecSttmt    CurDATA                        CAP011
146000200528                                                                                CAP011
146100200528     C                   MOVEL     IncDATA       InRecSttmt                     CAP011
146200200528                                                                                CAP011
146300200528     C                   ENDSR                                                  CAP011
146400200528      *****************************************************************         CAP011
146500200528      /EJECT
146600200528      *****************************************************************
146700200528      *                                                               *
146800200528      * ValdateAmd - Routine to check whether the fields amended      *
146900200528      *    are amendable.                                             *
147000200528      *                                                               *
147100200528      *****************************************************************
147200200528
147300200528     C     ValdateAmd    BEGSR
147400200528
147500200528      ** This subroutine calls a procedure which checks whether it
147600200528      ** was valid to amend any of the fields which have been
147700200528      ** changed.  Some are never amendable and some depend upon ICD
147800200528      ** settings as to whether they are amendable.
147900200528
148000200528      ** To determine what fields have changed, the current fields
148100200528      ** on file must be converted to a 'screen' format.
148200200528
148300200528      ** These fields are then compared with the fields on the input
148400200528      ** transaction.
148500200528
148600200528      ** Any errors detected by the called procedure take precedence
148700200528      ** over any errors found during the validation of the complete
148800200528      ** transaction.  The errors from the called procedure are kept
148900200528      ** separately and, if any are found, these errors will REPLACE
149000200528      ** the normal validation errors.
149100200528
149200200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
149300200528
149400200528     C                   RESET                   ReturnCode
149500200528     C                   CALLB     'MMDEAMCVT'
149600200528
149700200528      * INPUTS
149800200528      * Return Code
149900200528     C                   PARM                    ReturnCode
150000200528      * (Current) Deal in file format
150100200528     C                   PARM                    DealFilfmt
150200200528
150300200528      * OUTPUTS
150400200528      * (Current) Deal in screen format
150500200528     C                   PARM                    DealScnfmt
150600200528      * Deal Status
150700200528     C                   PARM                    DDSTS            24
150800200528
150900200528      ** AMEND CHECKING
151000200528     C                   RESET                   ReturnCode
151100200528     C                   CALLB     'MMDEAMAMD'
151200200528
151300200528      * INPUTS
151400200528      * Return Code
151500200528     C                   PARM                    ReturnCode
151600200528      * New Deal in Screen Format (Incoming Transaction)
151700200528     C                   PARM                    TranIn
151800200528      * (Current) Deal in Screen Format
151900200528     C                   PARM                    DealScnfmt
152000200528      * (Current) Deal in file format
152100200528     C                   PARM                    DealFilfmt
152200200528
152300200528      * OUTPUTS
152400200528      * Field OK flags (DS) from/to caller
152500200528     C                   PARM                    OKFlagsDS
152600200528      * Error fields/message IDs/message data (arrays) from/to caller
152700200528     C                   PARM                    AmFldNamAr
152800200528     C                   PARM                    AmMsgIdArr
152900200528     C                   PARM                    AmMsgDtaAr
153000200528      * Array index (3P0) from/to caller
153100200528     C                   PARM                    AmIdx
153200200528      * Amendments OK
153300200528     C                   PARM                    AmendOk           1
153400200528      * Reset of Fields in Error Required (Y/N)
153500200528     C                   PARM      'N'           ResetErrs         1
153600200528
153700200528      ** If any errors overwrite previous error information
153800200528
153900200528     C                   IF        AmIdx <> 0
154000200528     C                   MOVEA     AmMsgIdArr    MsgidArr
154100200528     C                   MOVEA     AmFldNamAr    FldNameArr
154200200528     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
154300200528     C                   Z-ADD     AmIdx         Idx
154400200528     C                   ENDIF
154500200528
154600200528     C                   ENDSR
154700200528      *****************************************************************
154800200528      /EJECT
154900200528      *****************************************************************
155000200528      *                                                               *
155100200528      * Check/Write - Routine to control checking of error status and *
155200200528      *    sending of messages/writing to the database                *
155300200528      *                                                               *
155400200528      *****************************************************************
155500200528
155600200528     C     CheckWrite    BEGSR
155700200528
155800200528      *  If no errors were found:
155900200528      *  - If Action Code is Insert
156000200528      *     - set up the deal amendment sequence number
156100200528      *  - If there are still no errors
156200200528      *     - set up additional data
156300200528      *     - write a record to the Valid file
156400200528      *     - use std message handler to report deal status
156500200528      *  If any errors were found:
156600200528      *  - write a record to the Invalid file
156700200528      *  - call the message handler to pass the errors back
156800200528      *  - use std message handler to report deal status
156900200528      *  The index to the error arrays is checked for presence/absence of
157000200528      *   errors
157100200528     
157200200528      ** +--- Note for a later release -------------------------------+
157300200528      ** |                                                            |
157400200528      ** | At a later date this routine will have to cater for        |
157500200528      ** | warning messages.  The following logic will have to be     |
157600200528      ** | inserted before "If no errors were found", in the          |
157700200528      ** | above comments (and the code):                             |
157800200528      ** |                                                            |
157900200528      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
158000200528      ** | any warning messages were returned (WIdx <> 0)             |
158100200528      ** |                                                            |
158200200528      ** | -   If errors exist                                        |
158300200528      ** |     -     Add the warning array index to the error array   |
158400200528      ** |           index                                            |
158500200528      ** |     -     Append the contents of the warning arrays to the |
158600200528      ** |           end of the error arrays                          |
158700200528      ** | -   Else                                                   |
158800200528      ** |     -     Set the error array index equal to the warning   |
158900200528      ** |           array index                                      |
159000200528      ** |     -     Copy the contents of the warning arrays to the   |
159100200528      ** |           error arrays                                     |
159200200528      ** | -   Endif                                                  |
159300200528      ** |                                                            |
159400200528      ** | Endif                                                      |
159500200528      ** |                                                            |
159600200528      ** | Note that the "If errors exist ... Else ... " block above  |
159700200528      ** | can probably be implemented unconditionally (ie the same   |
159800200528      ** | logic will apply whether errors exist as well as warnings  |
159900200528      ** | or not).  It is shown in the above form for clarity.       |
160000200528      ** |                                                            |
160100200528      ** +------------------------------------------------------------+
160200200528
160300200528     C     Idx           IFEQ      0
160400200528
160500200528     C                   IF        DDACTN = 'I'
160600200528     C                   EXSR      SETUPDASEQ
160700200528     C                   ENDIF
160800200528
160900200528     C     Idx           IFEQ      0
161000200528     C                   EXSR      SETUPVALID
161100200528     C                   WRITE     MMVDEAMD0
161200200528     C                   EXSR      CallMsgHdl
161300200528     C                   ENDIF
161400200528
161500200528     C                   ENDIF
161600200528
161700200528     C     Idx           IFGT      0
161800200528     C                   EXSR      SETUPINVAL
161900200528      *                                                                         CAP004
162000200528      * Only write to invalid files if repair in back office                    CAP004
162100200528      *                                                                         CAP004
162200200528     C     APRprLocn     IFEQ      'B'                                          CAP004
162300200528     C                   WRITE     MMIDEAMD0
162400200528     C                   WRITE     APIDSETD0
162500200528                                                                                              CSC011
162600200528      ** Write all invalid records to the support log file                                    CSC011
162700200528                                                                                              CSC011
162800200528     C                   IF        CSC011 = 'Y' AND                                           CSC011
162900200528     C                             S1SUPP = LIBR                                              CSC011
163000200528                                                                                              CSC011
163100200528     C                   EVAL      TRANSDTL = TranIn +                                        CSC011
163200200528     C                                        InRecSttmt +                                    CSC011
163300200528     C                                        InPaySttmt +                                    CSC011
163400200528     C                                        InfData +                                       CSC011
163500200528     C                                        ExtData                                         CSC011
163600200528                                                                                              CSC011
163700200528     C                   EVAL      APTGTTYPE  = 'MMDEAM'                                      CSC011
163800200528     C                   EVAL      PDealNo  = DDDLNO                                          CSC011
163900200528                                                                                              CSC011
164000200528     C                   CALLB     'APLOGTRAN'                                                CSC011
164100200528     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
164200200528     C                   PARM                    HeadIn                                       CSC011
164300200528     C                   PARM                    TRANSDTL                                     CSC011
164400200528     C                   PARM                    Timestamp                                    CSC011
164500200528     C                   PARM                    PDealNo                                      CSC011
164600200528     C                   PARM      *BLANKS       PADealNo                                     CSC011
164700200528                                                                                              CSC011
164800200528      ** Database error                                                                       CSC011
164900200528                                                                                              CSC011
165000200528     C                   IF        RetCodeOut <> *BLanks                                      CSC011
165100200528     C     *LOCK         IN        LDA                                                        CSC011
165200200528     C                   EVAL      DBKEY = DDDLNO                                             CSC011
165300200528     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
165400200528     C                   EVAL      DBASE = 901                                                CSC011
165500200528     C                   OUT       LDA                                                        CSC011
165600200528     C                   EXSR      *PSSR                                                      CSC011
165700200528     C                   ENDIF                                                                CSC011
165800200528                                                                                              CSC011
165900200528     C                   ENDIF                                                                CSC011
166000200528                                                                                              CSC011
166100200528     C                   ENDIF                                                  CAP004
166200200528     C                   EXSR      CallMsgHdl
166300200528     C                   ENDIF
166400200528
166500200528     C/COPY WNCPYSRC,MMDEAMCC01
166600200528     C                   If        (CSC022 = 'N')                                             CSC022
166700200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
166800200528     C                   COMMIT
166900200528     C                   EndIf                                                                CSC022
167000200528
167100200528     C                   ENDSR
167200200528      *****************************************************************
167300200528      /EJECT
167400200528      *****************************************************************
167500200528      *                                                               *
167600200528      * RESETCYCLE- Reset error information that is gradually         *
167700200528      *    updated during each run of this program                    *
167800200528      *                                                               *
167900200528      *****************************************************************
168000200528
168100200528     C     RESETCYCLE    BEGSR
168200200528
168300200528     C                   RESET                   FldNameArr
168400200528     C                   RESET                   MsgIDArr
168500200528     C                   RESET                   MsgDtaArr
168600200528     C                   RESET                   Idx
168700200528
168800200528     C                   RESET                   WFldNamArr
168900200528     C                   RESET                   WMsgIDArr
169000200528     C                   RESET                   WMsgDtaArr
169100200528     C                   RESET                   WIdx
169200200528
169300200528     C                   RESET                   AmFldNamAr
169400200528     C                   RESET                   AmMsgIDArr
169500200528     C                   RESET                   AmMsgDtaAr
169600200528     C                   RESET                   AmIdx
169700200528
169800200528     C                   RESET                   FldNoArr
169900200528
170000200528     C                   RESET                   OKFlagsDS
170100200528
170200200528     C                   RESET                   AmendOK
170300200528
170400200528     C                   RESET                   OKPayInsDS
170500200528     C                   RESET                   OKRecInsDS
170600200528     C                   RESET                   OKFRAInsDS
170700200528
170800200528     C                   RESET                   PayDat
170900200528     C                   RESET                   RecDat
171000200528
171100200528     C                   CLEAR                   ValidDeal
171200200528      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
171300200528      **  there are long alpha fileds overlapping these which cause the
171400200528      **  CLEAR to put blanks in the numeric fields
171500200528     C                   Z-ADD     *ZERO         IGRSTM
171600200528     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
171700200528     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
171800200528     C                   EVAL      IGROBN = *BLANKS                                           CSD027
171900200528     C                   EVAL      IGROCN = *BLANKS                                           CSD027
172000200528     C                   Z-ADD     *ZERO         IGPSTM
172100200528     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
172200200528     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
172300200528     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
172400200528     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
172500200528
172600200528      ** Have to clear the settlement data structure, or the packed numeric
172700200528      ** fields are not initialised correctly.
172800200528     C                   CLEAR                   DBPaySttmt
172900200528     C                   CLEAR                   DBRecSttmt
173000200528     C                   CLEAR                   DBFRASttmt
173100200528
173200200528     C                   ENDSR
173300200528      *****************************************************************
173400200528      /EJECT
173500200528      *****************************************************************
173600200528      *                                                               *
173700200528      * SETUPINVAL - Set up additional fields that are needed on the  *
173800200528      *        Valid file record.                                     *
173900200528      *                                                               *
174000200528      *****************************************************************
174100200528
174200200528     C     SETUPINVAL    BEGSR
174300200528
174400200528      * Include Header fields that need to be o/p to the Invalid files
174500200528     C                   EVAL      DDMsgType  = 'MMDEAM'
174600200528     C                   EVAL      DDFOTRANID = APFOTRANID
174700200528     C                   EVAL      DDFOASOCID = APFOASOCID
174800200528     C                   EVAL      DDRPRLOCN  = APRPRLOCN
174900200528     C                   EVAL      DDTMESTMP = TimeStamp
175000200528                                                                                CAP051
175100200528      * Setup the Automatic Autorisation Flag                                   CAP051
175200200528     C                   IF        CAP051 = 'Y'                                 CAP051
175300200528     C                   EVAL      DDAUTH     = IF_AUTH                         CAP051
175400200528     C                   ENDIF                                                  CAP051
175500200528
175600200528     C                   EVAL      TranStatus = 'F'
175700200528
175800200528      /COPY WNCPYSRC,MMDEAMC017
175900200528
176000200528     C                   ENDSR
176100200528      *****************************************************************
176200200528      /EJECT
176300200528      *****************************************************************
176400200528      *                                                               *
176500200528      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
176600200528      *              for Inserts.                                     *
176700200528      *                                                               *
176800200528      *****************************************************************
176900200528
177000200528     C     SETUPDASEQ    BEGSR
177100200528
177200200528      **  Load deal number into numeric field passed to MM0085
177300200528
177400200528     C                   MOVE      DDDLNO        DealNo            6 0
177500200528
177600200528      ** Format Value Date
177700200528
177800200528     C     DDVDAT        IFNE      *BLANKS                                      B1
177900200528      *
178000200528      ** Load value date to numeric keyfield,in YYYYMMDD format
178100200528      *
178200200528     C                   MOVE      DDVDAT        @VDAT
178300200528
178400200528     C                   Z-ADD     0             @PDAT                          **2
178500200528     C                   MOVE      @DSPY         @PYEAR                         **2
178600200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
178700200528     C                   MOVE      @DSPD         @PDDD                          **2
178800200528     C                   ELSE                                                                  BHF18
178900200528     C                   MOVE      @DSPD         @PDMM                                         BHF18
179000200528     C                   END                                                                   BHF18
179100200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
179200200528     C                   MOVE      @DSPM         @PDMM                          **2
179300200528     C                   ELSE                                                                  BHF18
179400200528     C                   MOVE      @DSPM         @PDDD                                         BHF18
179500200528     C                   END                                                                   BHF18
179600200528      *
179700200528      ** Century
179800200528     C     @PYEAR        IFGE      72                                           B**3
179900200528     C     @PDYY         ADD       1900          @PDYY                          ***3
180000200528     C                   ELSE                                                   ***3
180100200528     C     @PDYY         ADD       2000          @PDYY                          ***3
180200200528     C                   END                                                    E**3
180300200528     C                   ELSE                                                   X1
180400200528     C                   Z-ADD     0             @PDAT                          *1
180500200528     C                   END                                                    E1
180600200528
180700200528     C                   Z-ADD     @PDAT         ValueDate         8 0
180800200528
180900200528      ***Bypass*generation*of*Seq*number*for*Insert*if*CSC024*is                       CSC024 CSC054
181000200528      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
181100200528      ** Bypass generation of Seq number for Insert if CSC054 is                              CSC054
181200200528      ** switched on and running on PEA system.                                               CSC054
181300200528                                                                                              CSC024
181400200528     C**********         IF        CSC024 <> 'Y'  OR                                   CSC024 CSC054
181500200528     C**********                   WOMEInd <> 'Y' OR                                   CSC024 CSC054
181600200528     C                   IF        CSC054 <> 'Y'  OR                                          CSC054
181700200528     C                             WPEAInd <> 'Y' OR                                          CSC054
181800200528     C                             DDDS38 = *BLANKS                                           CSC024
181900200528                                                                                              CSC024
182000200528      ** Generate DEAM Sequence Number
182100200528     C                   CALLB     'MM0085'
182200200528     C                   PARM      *BLANK        Term              1
182300200528     C                   PARM                    DealNo
182400200528     C                   PARM                    ValueDate
182500200528     C                   PARM                    SeqNoPack         3 0
182600200528
182700200528     C     Term          IFNE      *BLANK
182800200528     C                   MOVE      'N'           DDDlnoOK
182900200528     C                   ADD       1             Idx
183000200528     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
183100200528     C                   EVAL      MsgIDArr(Idx) = 'MMM0146'
183200200528     C                   ELSE
183300200528     C                   Z-ADD     SeqNoPack     IGDS38
183400200528     C                   ENDIF
183500200528                                                                                              CSC024
183600200528     C                   ELSE                                                                 CSC024
183700200528     C                   MOVEL     DDDS38        IGDS38                                       CSC024
183800200528     C                   ENDIF                                                                CSC024
183900200528
184000200528     C                   ENDSR
184100200528      *****************************************************************
184200200528      /EJECT
184300200528      *****************************************************************
184400200528      *                                                               *
184500200528      * SETUPVALID - Set up additional fields that are needed on the  *
184600200528      *    Valid file record.                                         *
184700200528      *                                                               *
184800200528      *****************************************************************
184900200528
185000200528     C     SETUPVALID    BEGSR
185100200528
185200200528      **For*Inserts,*put*the*Settlement*Instructions*(input*or*defaulted)***    170909
185300200528      ***into*the*Valid*file*record*****************************************    170909
185400200528                                                                                170909
185500200528      * For Inserts and Amends, put the Settlement Instructions (input or       170909
185600200528      *  defaulted) into the Valid file record.                                 170909
185700200528      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
185800200528      *  in contiguous areas, which must be placed into the correct parts
185900200528      *  of the Valid file record
186000200528     C                   IF        DDACTN = 'I'
186100200528     C                             OR (DDACTN = 'A')                            170909
186200200528     C**********         MOVEL     DBPaySttmt    MMVDPayIns                                   CGL029
186300200528     C                   MOVE      FLPSTM        IGPSTM                                       CGL029
186400200528     C                   MOVEL     FLPONS        IGPONS                                       CGL029
186500200528     C                   MOVE      FLPAY2        MMVDPayIns                                   CGL029
186600200528     C**********         MOVEL     DBRecSttmt    MMVDRecIns                                   CGL029
186700200528     C                   MOVE      FLRSTM        IGRSTM                                       CGL029
186800200528     C                   MOVEL     FLRONS        IGRONS                                       CGL029
186900200528     C                   MOVE      FLREC2        MMVDRecIns                                   CGL029
187000200528     C     FLPOBR        IFNE      *BLANKS
187100200528     C                   MOVE      FLPOBR        IGOSBR
187200200528     C                   ELSE
187300200528     C                   MOVE      FLROBR        IGOSBR
187400200528     C                   END
187500200528     C                   MOVE      FLCVMR        IGCVMR
187600200528     C                   MOVE      FLPSCY        IGSTCY
187700200528     C                   MOVE      FLIC72        IGIC72
187800200528     C                   ENDIF
187900200528
188000200528      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into******     170909
188100200528      ***the*Valid*file*record*********************************************     170909
188200200528      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few**     170909
188300200528      ***(physically*separate)*fields*also*need*to*be*done*****************     170909
188400200528     C*******************IF********DDACTN*=*'A'*************                    170909
188500200528     C*******************MOVE******DEAMRecIns****MMVDRecIns*                    170909
188600200528     C*******************MOVE******DEAMPayIns****MMVDPayIns*                    170909
188700200528     C*******************MOVE******HNOSBR********IGOSBR*****                    170909
188800200528     C*******************MOVE******HNCVMR********IGCVMR*****                    170909
188900200528     C*******************MOVE******HNSTCY********IGSTCY*****                    170909
189000200528     C*******************MOVE******HNIC72********IGIC72*****                    170909
189100200528     C*******************ENDIF******************************                    170909
189200200528
189300200528      * For Deletes & Authorises, put the complete (pre-existing) deal
189400200528      *  into the Valid file record
189500200528     C                   IF           DDACTN = 'D'
189600200528     C                             OR DDACTN = 'X'
189700200528     C                   MOVE      DealFilFmt    ValidDeal
189800200528     C                   ENDIF
189900200528
190000200528      * Set Valid file field(s) that are needed for all Action Codes
190100200528     C                   EVAL      IGLACT = DDACTN
190200200528
190300200528      * Include Header fields that need to be o/p to the Valid file
190400200528
190500200528     C                   MOVE      DDDLNO        IGDA38
190600200528
190700200528     C                   EVAL      IGFRNT = APFOTranID
190800200528     C                   EVAL      IGAFRT = APFOAsocID
190900200528     C                   EVAL      IGREPA = APRprLocn
191000200528     C                   EVAL      IGTMESTMP = TimeStamp
191100200528                                                                                CAP051
191200200528      * Automatic Authorisation flag                                            CAP051
191300200528     C                   IF        CAP051 = 'Y'                                 CAP051
191400200528     C                   EVAL      IGAUTH = IF_AUTH                             CAP051
191500200528     C                   ENDIF                                                  CAP051
191600200528
191700200528     C                   EVAL      TranStatus = 'S'
191800200528
191900200528      /COPY WNCPYSRC,MMDEAMC018
192000200528
192100200528     C                   ENDSR
192200200528      *****************************************************************
192300200528      /EJECT
192400200528      *****************************************************************
192500200528      *                                                               *
192600200528      * CallMsgHdl - Call the Message Handling module                 *
192700200528      *                                                               *
192800200528      *****************************************************************
192900200528
193000200528     C     CallMsgHdl    BEGSR
193100200528
193200200528      ** Set up an array of sequence numbers that correspond to the fields
193300200528      **  with errors
193400200528
193500200528     C                   Z-ADD     1             Ix
193600200528     C                   DO        ArrayMax
193700200528
193800200528     C     FldNameArr(Ix)IFNE      *BLANKS
193900200528
194000200528     C                   Z-ADD     1             Iy
194100200528     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
194200200528     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
194300200528
194400200528     C                   ELSE
194500200528
194600200528     C                   LEAVE
194700200528
194800200528     C                   ENDIF
194900200528
195000200528     C                   ADD       1             Ix
195100200528     C                   ENDDO
195200200528
195300200528     C                   RESET                   ReturnCode
195400200528                                                                                              260028
195500200528     C                   MOVE      *BLANKS       WDEALSEQ          9                          260028
195600200528     C                   MOVE      *BLANKS       PTranID          20                          260028
195700200528     C                   MOVEL     DDDLNO        WDEALSEQ                                     260028
195800200528     C                   MOVE      IGDS38        WDEALSEQ                                     260028
195900200528     C                   EVAL      PTranID = WDEALSEQ + DDVDAT                                260028
196000200528
196100200528     C                   MOVE      *BLANKS       WDEALSEQ          9                          250430
196200200528     C                   MOVE      *BLANKS       PTranID          20                          250430
196300200528     C                   MOVEL     DDDLNO        WDEALSEQ                                     250430
196400200528     C                   MOVE      IGDS38        WDEALSEQ                                     250430
196500200528     C                   EVAL      PTranID = WDEALSEQ + DDVDAT                                250430
196600200528     C**********         MOVEL     DDDLNO        PTranID          20                   CAP033 250430
196700200528                                                                                              CAP033
196800200528     C                   CALLB     'ZAMSGHNDLE'
196900200528      ** Return code (10A, returned to this procedure)
197000200528     C                   PARM                    ReturnCode
197100200528      ** Deal repair location (1A, from caller)
197200200528     C                   PARM                    APRPRLOCN
197300200528      ** Confirm validity to front office (1A, from caller)
197400200528     C                   PARM                    APCnfValFO
197500200528      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
197600200528     C                   PARM                    MsgIDArr
197700200528      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
197800200528     C                   PARM                    FldNoArr
197900200528      ** List of field names (Array of <ArrayMax>x10A names - from caller)
198000200528     C                   PARM                    FldNameArr
198100200528      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
198200200528     C                   PARM                    MsgDtaArr
198300200528      ** Front office transaction identifier (20A, from caller)
198400200528     C                   PARM                    APFOTRANID
198500200528      ***Midas*module*ID*(2A)**************************************************************** CAP033
198600200528     C*******************Parm********************ModuleID************************************ CAP033
198700200528      ** Midas Module ID (2A)                                                                 204887
198800200528      *                                                                                       204887
198900200528     C                   PARM                    ModuleID                                     204887
199000200528      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
199100200528      ** Midas transaction ID (20A, from caller)                                              CAP033
199200200528     C***********        PARM                    DDDLNO                                       CAP033
199300200528     C                   PARM                    PTranID                                      CAP033
199400200528      ***Midas*transaction ID (6A, from caller)                                               204887
199500200528     C**********         PARM                    DDDLNO                                       204887
199600200528      ** Message file (10A, from caller)
199700200528     C                   PARM                    #MsgFile
199800200528      ** Action code of transaction (1A, from transaction)
199900200528     C                   PARM                    DDACTN
200000200528      ** Status of transaction (1A, F=Failure, S=Success)
200100200528     C                   PARM                    TranStatus
200200200528      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
200300200528     C                   PARM                    APRespMode
200400200528      ** The following three parameters are needed when messages are to
200500200528      ** be displayed on a screen
200600200528      ** Screen-handling program (10A, from caller)
200700200528     C                   PARM                    #ProcPgm
200800200528      ** Screen-handling module (10A, from caller)
200900200528     C                   PARM                    #ProcMod
201000200528      ** Screen-handling procedure (10A, from caller)
201100200528     C                   PARM                    #ProcName
201200200528      ** The MQSeries queue to send replies to
201300200528     C                   PARM                    APRpyQueue
201400200528      ** The transaction's timestamp
201500200528     C                   PARM                    TimeStamp
201600200528      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
201700200528     C                   PARM                    MsgFArray                                    222373
201800200528      ** Whether or not to clear the program message queue (1A)                               222373
201900200528     C                   PARM                    ClearPgmQ         1                          222373
202000200528
202100200528     C                   ENDSR
202200200528      *****************************************************************
202300200528      /EJECT
202400200528     C/COPY ZACPYSRC,PSSR_ILE
202500200528      ********************************************************************
202600200528      /EJECT
202700200528      *****************************************************************
202800200528      *                                                               *
202900200528      * *INZSR - Program Initialisation routine                       *
203000200528      *                                                               *
203100200528      *****************************************************************
203200200528
203300200528     C     *INZSR        BEGSR
203400200528
203500200528     C     *ENTRY        PLIST
203600200528      * Common header information (DS) from source system
203700200528     C                   PARM                    HeadIn
203800200528      * Transaction information in a single large field from source system
203900200528     C                   PARM                    Trans500
204000200528     C                   PARM                    InfData500                     CAP051
204100200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
204200200528     C                   PARM                    InPaySttmt
204300200528     C                   PARM                    InRecSttmt
204400200528     C                   PARM                    InFRASttmt
204500200528     C                   PARM                    ExtData500                     CAP004
204600200528      ** Ultimate calling Program/Module/Procedure
204700200528     C                   PARM                    #ProcPgm
204800200528     C                   PARM                    #ProcMod
204900200528     C                   PARM                    #ProcName
205000200528
205100200528      *  Set up the name of the MSGF from which the message handler will
205200200528      *   get the messages
205300200528     C                   EVAL      #MsgFile = 'DRSMM'
205400200528
205500200528      *  Set up the Module ID, used to make the Transaction number unique
205600200528     C                   EVAL      ModuleID = 'DL'
205700200528
205800200528      ** Access Bank details via access program
205900200528      *  (database error handling done in access program)
206000200528     C                   CALLB     'AOBANKR0'
206100200528     C                   PARM      '*DBERR '     @RTCD             7
206200200528     C                   PARM      '*FIRST '     @OPTN             7
206300200528     C     SDBANK        PARM      SDBANK        DSFDY
206400200528                                                                                CAP011
206500200528      ** Access API ICD via access program                                      CAP011
206600200528      *  (database error handling done in access program)                       CAP011
206700200528     C                   CALLB     'AOAPIR0'                                    CAP011
206800200528     C                   PARM      '*DBERR '     @RTCD             7            CAP011
206900200528     C                   PARM      '*FIRST '     @OPTN             7            CAP011
207000200528     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
207100200528
207200200528      ** Key List for MMVDEAML0
207300200528
207400200528     C     FrntOfKey     KLIST
207500200528     C                   KFLD                    UniqDeamID       20
207600200528     C                   KFLD                    OrigDealNo       20
207700200528
207800200528     ****Initialise*Data*queue*parms********************************************148855
207900200528     C*******************EVAL      DtqLen = 10                                  148855
208000200528                                                                                148855
208100200528      ** Set up the name of the server/database updater data queue.             148855
208200200528     C                   EVAL      DtaQName = 'APDEAMDTQ'                       148855
208300200528      *                                                                         CAP051
208400200528      ** Access SAR details file to determine if                                CAP051
208500200528      ** Automatic Authorisation (MM Part) is installed                         CAP051
208600200528      *                                                                         CAP051
208700200528     C                   MOVEL     'N'           CAP051            1            CAP051
208800200528     C                   CALL      'AOSARDR0'                                   CAP051
208900200528     C                   PARM      *BLANKS       @RTCD                          CAP051
209000200528     C                   PARM      '*VERIFY'     @OPTN                          CAP051
209100200528     C                   PARM      'CAP051'      @SARD                          CAP051
209200200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
209300200528      *                                                                         CAP051
209400200528     C     @RTCD         IFEQ      *BLANK                                       CAP051
209500200528     C                   MOVEL     'Y'           CAP051                         CAP051
209600200528     C                   ENDIF                                                  CAP051
209700200528                                                                                              CSC011
209800200528      ** Check if CSC011 is installed                                                         CSC011
209900200528                                                                                              CSC011
210000200528     C                   CALL      'AOSARDR0'                                                 CSC011
210100200528     C                   PARM      *BLANKS       PRTCD                                        CSC011
210200200528     C                   PARM      '*VERIFY'     POPTN                                        CSC011
210300200528     C                   PARM      'CSC011'      PSARD                                        CSC011
210400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
210500200528                                                                                              CSC011
210600200528     C                   IF        PRTCD = *Blanks                                            CSC011
210700200528                                                                                              CSC011
210800200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
210900200528                                                                                              CSC011
211000200528     C                   IN        SC24X7                                                     CSC011
211100200528     C                   IN        SDSTAT                                                     CSC011
211200200528                                                                                              CSC011
211300200528     C                   ELSE                                                                 CSC011
211400200528                                                                                              CSC011
211500200528      ** Database error                                                                       CSC011
211600200528                                                                                              CSC011
211700200528     C                   IF        PRTCD <> '*NRF'                                            CSC011
211800200528     C     *LOCK         IN        LDA                                                        CSC011
211900200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
212000200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
212100200528     C                   EVAL      DBASE = 900                                                CSC011
212200200528     C                   OUT       LDA                                                        CSC011
212300200528     C                   EXSR      *PSSR                                                      CSC011
212400200528     C                   ENDIF                                                                CSC011
212500200528                                                                                              CSC011
212600200528     C                   ENDIF                                                                CSC011
212700200528
212800200528      *  Hook to enable non-core initial processing to be included
212900200528      /COPY WNCPYSRC,MMDEAMC022
213000200528
213100200528      ** Access SAR details file to determine if Commitment Control                           CSC022
213200200528      ** Changes is switched on.                                                              CSC022
213300200528     C                   CallB     'AOSARDR0'                                                 CSC022
213400200528     C                   Parm      *BLANKS       @RTCD                                        CSC022
213500200528     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
213600200528     C                   Parm      'CSC022'      @SARD                                        CSC022
213700200528     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
213800200528                                                                                              CSC022
213900200528     C                   If        @RTCD = *BLANKS                                            CSC022
214000200528      *                                                                                       CSC022
214100200528     C                   Eval      CSC022 = 'Y'                                               CSC022
214200200528     C                   In        SCCMTJOB                                                   CSC022
214300200528     C                   If        ComitNum > 0                                               CSC022
214400200528      ** Check if Current Job exists in the Commitment Job Names                              CSC022
214500200528      ** Data Area.                                                                           CSC022
214600200528     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
214700200528     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
214800200528     C                   If        *IN20                                                      CSC022
214900200528     C                   Eval      wCommitSkip = 'Y'                                          CSC022
215000200528     C                   EndIf                                                                CSC022
215100200528     C                   EndIf                                                                CSC022
215200200528      *                                                                                       CSC022
215300200528     C                   Else                                                                 CSC022
215400200528      ** Database error                                                                       CSC022
215500200528     C                   If        @RTCD <> '*NRF'                                            CSC022
215600200528     C     *LOCK         In        LDA                                                        CSC022
215700200528     C                   Eval      DBKey = 'CSC022'                                           CSC022
215800200528     C                   Eval      DBPgm = 'MMDEAMCTL'                                        CSC022
215900200528     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
216000200528     C                   Eval      DBase = 902                                                CSC022
216100200528     C                   Out       LDA                                                        CSC022
216200200528     C                   ExSr      *PSSR                                                      CSC022
216300200528     C                   EndIf                                                                CSC022
216400200528      *                                                                                       CSC022
216500200528     C                   EndIf                                                                CSC022
216600200528      *                                                                                       CSC022
216700200528      ***Check if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
216800200528      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
216900200528                                                                                              CSC024
217000200528     C                   CALLB     'AOSARDR0'                                                 CSC024
217100200528     C                   PARM      *BLANKS       @RTCD                                        CSC024
217200200528     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
217300200528     C***********        PARM      'CSC024'      @SARD                                 CSC024 CSC054
217400200528     C                   PARM      'CSC054'      @SARD                                        CSC054
217500200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
217600200528                                                                                              CSC024
217700200528     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
217800200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
217900200528     C***********        EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
218000200528     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
218100200528     C                   EVAL      DBase  = 3                                                 CSC024
218200200528     C                   EXSR      *PSSR                                                      CSC024
218300200528     C                   ENDIF                                                                CSC024
218400200528                                                                                              CSC024
218500200528     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
218600200528     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
218700200528     C                   EVAL      CSC054 = 'N'                                               CSC054
218800200528     C                   EVAL      WPEAInd = 'N'                                              CSC054
218900200528                                                                                              CSC024
219000200528     C                   IF        @RTCD = *BLANKS                                            CSC024
219100200528     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
219200200528     C                   EVAL      CSC054 = 'Y'                                               CSC054
219300200528                                                                                              CSC024
219400200528      ** Access System values                                                                 CSC024
219500200528                                                                                              CSC024
219600200528     C                   CALL      'AOSVALR0'                                                 CSC024
219700200528     C                   PARM      *BLANKS       PRetCode                                     CSC024
219800200528     C                   PARM      PSysVal1      P@OP01                                       CSC024
219900200528     C                   PARM      *BLANKS       P@VL01                                       CSC024
220000200528     C                   PARM      *BLANKS       P@OP02                                       CSC024
220100200528     C                   PARM      *BLANKS       P@VL02                                       CSC024
220200200528     C                   PARM      *BLANKS       P@OP03                                       CSC024
220300200528     C                   PARM      *BLANKS       P@VL03                                       CSC024
220400200528     C                   PARM      *BLANKS       P@OP04                                       CSC024
220500200528     C                   PARM      *BLANKS       P@VL04                                       CSC024
220600200528     C                   PARM      *BLANKS       P@OP05                                       CSC024
220700200528     C                   PARM      *BLANKS       P@VL05                                       CSC024
220800200528     C                   PARM      *BLANKS       P@OP06                                       CSC024
220900200528     C                   PARM      *BLANKS       P@VL06                                       CSC024
221000200528     C                   PARM      *BLANKS       P@OP07                                       CSC024
221100200528     C                   PARM      *BLANKS       P@VL07                                       CSC024
221200200528     C                   PARM      *BLANKS       P@OP08                                       CSC024
221300200528     C                   PARM      *BLANKS       P@VL08                                       CSC024
221400200528     C                   PARM      *BLANKS       P@OP09                                       CSC024
221500200528     C                   PARM      *BLANKS       P@VL09                                       CSC024
221600200528     C                   PARM      *BLANKS       P@OP10                                       CSC024
221700200528     C                   PARM      *BLANKS       P@VL10                                       CSC024
221800200528                                                                                              CSC024
221900200528     C                   IF        PRetCode  <> *BLANKS                                       CSC024
222000200528     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
222100200528     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
222200200528     C                   EVAL      DBase = 4                                                  CSC024
222300200528     C                   EXSR      *PSSR                                                      CSC024
222400200528     C                   ENDIF                                                                CSC024
222500200528     C                   IF        P@VL01 = 'Y'                                               CSC024
222600200528     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
222700200528     C                   EVAL      WPEAInd = 'Y'                                              CSC054
222800200528     C                   ENDIF                                                                CSC024
222900200528     C                   ENDIF                                                                CSC024
223000200528                                                                                              CSC024
223100200528     C                   ENDSR
223200200528      ********************************************************************
223300200528**  CPY@
223400200528(c) Finastra International Limited 2001
