000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas MM Deal amendments validate and update')         *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Money Market Dealing Module                          *
000900200529      *                                                               *
001000200529      *  MMDEAMVU - Deal Amendments validate and update               *
001100200529      *                                                               *
001200200529      *  Function: This Program Validates MM Deal Amendments for input*
001300200529      *            into the Midas database and updates if required    *
001400200529      *            Processes executed controlled by input Action Code *
001500200529      *            - For I (=Insert)                                  *
001600200529      *              - If ALL of the settlement fields are blank, set *
001700200529      *                them up from standard settlement instructions  *
001800200529      *            - For I (=Insert) or A (=Amend)                    *
001900200529      *              - Validate the deal fields                       *
002000200529      *              - Validate the settlement fields                 *
002100200529      *            - For A (=Amend) if it is valid, call a separate   *
002200200529      *              function to check whether it is a valid amendment*
002300200529      *            - For X (=Authorise) call a separate function to   *
002400200529      *              process this deal and bypass remaining validation*
002500200529      *              bypass the field validation                      *
002600200529      *            - For D (=Delete) call a separate function to      *
002700200529      *              process this deal and bypass the rest of the     *
002800200529      *              validation                                       *
002900200529      *            For all action codes, the decision to as to        *
003000200529      *            whether to write to the Valid or Invalid file and  *
003100200529      *            the call to the Message Handler will take place    *
003200200529      *            in this module                                     *
003300200529      *                                                               *
003400200529      *  (c) Finastra International Limited 2003                      *
003500200529      *                                                               *
003600200604      *  Last Amend No. 260173             Date 22May20               *
003700200529      *  Prev Amend No. MD055318           Date 17Feb20               *
003800200529      *                 CSD102             Date 08Jan19               *
003900200529      *                 MD039547           Date 20Sep16               *
004000200529      *                 CDL051             Date 02May18               *
004100200529      *                 MD046248           Date 27Oct17               *
004200200529      *                 MD044400           Date 20Mar17               *
004300200529      *                 CGL165             Date 17Feb15               *
004400200529      *                 CDL096             Date 22Sep14               *
004500200529      *                 CDL094             Date 30May14               *
004600200529      *                 MD027598           Date 24Jun14               *
004700200529      *                 CSD095             Date 08Apr14               *
004800200529      *                 MD022624           Date 04Oct13               *
004900200529      *                 AR1096000          Date 14Mar13               *
005000200529      *                 AR1092035          Date 28Feb13               *
005100200529      *                 AR971184A          Date 22Jun12               *
005200200529      *                 AR971184           Date 28May12               *
005300200529      *                 CSC054             Date 23Feb12               *
005400200529      *                 AR736874           Date 06Apr11               *
005500200529      *                 CSF011A            Date 28Nov11               *
005600200529      *                 CRE073             Date 06Dec10               *
005700200529      *                 AR792037           Date 27Jun11               *
005800200529      *                 CER059             Date 19Jul10               *
005900200529      *                 CER043             Date 19May08               *
006000200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
006100200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
006200200529      *                 256564             Date 17Sep08               *
006300200529      *                 249910             Date 24Oct07               *
006400200529      *                 250357             Date 27Sep07               *
006500200529      *                 244537             Date 17Aug05               *
006600200529      *                 BUG13071           Date 18Jan07               *
006700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
006800200529      *                 239400             Date 26Jun06               *
006900200529      *                 CSD027             Date 09Dec05               *
007000200529      *                 BUG10727           Date 28Feb06               *
007100200529      *                 BUG8119            Date 20Oct05               *
007200200529      *                 CLE031             Date 26Apr05               *
007300200529      *                 CDL038             Date 10May05               *
007400200529      *                 CSC024             Date 07Feb05               *
007500200529      *                 BUG6534            Date 08Apr05               *
007600200529      *                 BUG4963            Date 25Jan05               *
007700200529      *                 BUG4907            Date 21Jan05               *
007800200529      *                 BUG4808            Date 16Nov04               *
007900200529      *                 BUG4728            Date 05Nov04               *
008000200529      *                 BUG4482            Date 29Sep04               *
008100200529      *                 BUG4146            Date 01Sep04               *
008200200529      *                 CLE025             Date 20Oct03               *
008300200529      *                 BUG2774            Date 25May04               *
008400200529      *                 CDL022             Date 03Feb04               *
008500200529      *                 CDL020             Date 03Feb04               *
008600200529      *                 CDL017             Date 03Feb04               *
008700200529      *                 NAD002             Date 26Mar04               *
008800200529      *                 CSC022             Date 24Feb04               *
008900200529      *                 CGL029             Date 01Sep03               *
009000200529      *                 CAP084  *CREATE    Date 14Jun02               *
009100200529      *                                                               *
009200200529      *---------------------------------------------------------------*
009300200529      *                                                               *
009400200529      *  260173 - Introduce new parameter to be used in the vali-     *
009500200529      *           dation of action code when authorising a reversal   *
009600200529      *           transaction. Apply fix 258724.                      *
009700200529      *  MD055318 - Customer may not be amended error                 *
009800200529      *  CSD102 - Password Length Extension (Recompile)               *
009900200529      *  MD039547 - Referred account is not properly validated.       *
010000200529      *  CDL051 - Incomplete Deals to Repair                          *
010100200529      *  MD046248 - Finastra Rebranding                               *
010200200529      *  MD044400 - Error in deal amendment input                     *
010300200529      *  CGL165 - Dual Withholding Tax (Recompile)                    *
010400200529      *  CDL096 - Business Day Conventions on MM Deals                *
010500200529      *           (Recompile)                                         *
010600200529      *  CDL094 - Enhance Receive Settlement Instructions             *
010700200529      *  MD027598 - DEAM Input (Type SI): Settlement Receipt Instr.   *
010800200529      *             not defaulted from the original deal for Deal     *
010900200529      *             Types IP, IT and CL.                              *
011000200529      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
011100200529      *  MD022624 - Data from EXSS were not defaulted to Settlements  *
011200200529      *             tab of DEAM                                       *
011300200529      *  AR1096000 - The following system error occurred: 45011352:   *
011400200529      *              A Serious Midas error has occurred               *
011500200529      *  AR1092035 - Customer may not be amended (Field:Customer      *
011600200529      *              Shortname or Number)                             *
011700200529      *  AR971184A- During Amend Front Ofc Id must be updated with the*
011800200529      *             new one                                           *
011900200529      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
012000200529      *             Office Id is no more updated in master database   *
012100200529      *             files which provokes some big problems in third   *
012200200529      *             party product such as TOF.(Child:AR971185)        *
012300200529      *  CSC054 - Period End Adjustments                              *
012400200529      *  AR736874 - Default deal customer number and currency.        *
012500200529      *             (Child: AR736875)                                 *
012600200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
012700200529      *  CRE073 - Interest Rate Rounding                              *
012800200529      *  AR792037 - Default settlement method for type 'BC' to zero   *
012900200529      *  CER059 - German Feature Upgrade to Delhi                     *
013000200529      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
013100200529      *  256564 - Recompile due to PF changes done by fix 256330      *
013200200529      *  249910 - Default both payment and receipt settlement details *
013300200529      *           for EM amendment type.                              *
013400200529      *  250357 - Check and default deal's settlement details first   *
013500200529      *           before using Extended Settlement defaults.          *
013600200529      *  244537 - To avoid overriding front office identifier.        *
013700200529      *  BUG13071 - Recompile only                                    *
013800200529      *  239400 - Add Front Office ID to be used by SOAP Interface    *
013900200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
014000200529      *  BUG10727 - Fiduciary Taking warning not displayed on Insert  *
014100200529      *             and Reverse                                       *
014200200529      *  BUG8119 - Fields returned incorrectly from API if update     *
014300200529      *            flag set to 'Y' but data is invalid.               *
014400200529      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
014500200529      *  CDL038 - Extended Deal Sub Type                              *
014600200529      *  CSC024 - Open Month End                                      *
014700200529      *  BUG6534 - Condition settlements on loan or deposit.          *
014800200529      *  BUG4963 - Cannot enter DEAM with Settlement Mode 04          *
014900200529      *  BUG4907 - Error when inserting transactions with Settlement  *
015000200529      *             method 04                                         *
015100200529      *  BUG4808 - Unable to authorise transaction because WIP do     *
015200200529      *            not have correct Timestamp.                        *
015300200529      *  BUG4728 - Serious Midas error with blank timestamp when      *
015400200529      *            authorising insert of transaction.                 *
015500200529      *  BUG4482- Authorise should call Validate to show all the      *
015600200529      *           warning errors.                                     *
015700200529      *  BUG4146 - Stopping two users to update the same record at the*
015800200529      *            same time.                                         *
015900200529      *  CLE025 - Credit Lines (Recompile)                            *
016000200529      *  BUG2774 - Error in Settlement Details.                       *
016100200529      *  CDL022 - Deal Amendment Changes                              *
016200200529      *  CDL020 - Apply Base Rate at Value Date                       *
016300200529      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
016400200529      *  NAD002 - 10-Digit Account Code Errors                        *
016500200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
016600200529      *  CGL029 - Increase Account Code to 10 digits                  *
016700200529      *  CAP084 - API Wrapper project                                 *
016800200529      *                                                               *
016900200529      *****************************************************************
017000200529     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                      BUG6534
017100200529     F                                     INFDS(INFDS)                                     AR736874
017200200529                                                                                              CSD095
017300200529     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
017400200529     F                                     INFSR(*PSSR)                                       CSD095
017500200529                                                                                              CSD095
017600200529      ** +--------------------------------------+
017700200529      ** ¦ F-specs                              ¦
017800200529      ** ¦ =======                              ¦
017900200529      ** +--------------------------------------+
018000200529      *****************************************************************
018100200529
018200200529
018300200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
018400200529
018500200529
018600200529      *****************************************************************
018700200529      ** +--------------------------------------+
018800200529      ** ¦ Automatically included D-specs       ¦
018900200529      ** ¦ ==============================       ¦
019000200529      ** +--------------------------------------+
019100200529      **
019200200529      ** Standard D-specs
019300200529      ** ================
019400200529      **
019500200529      ** The following /COPY line includes the LDA layout,
019600200529      ** the copyright array definition,
019700200529      ** and the following named constants:
019800200529      **    True       logical = *on (for indicator processing)
019900200529      **    False      logical = *off (for indicator processing)
020000200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
020100200529      **                                    handler)
020200200529      ** and the following variables:
020300200529      **    RunBefore  1A (for the PSSR)
020400200529
020500200529     D/COPY ZACPYSRC,STD_D_SPEC
020600200529
020700200529      ** Include the MM standard declares
020800200529     D/COPY ZACPYSRC,STDDECLARE
020900200529
021000200529      ** Program Status Data Structure
021100200529      ** =============================
021200200529      ** The following /COPY line includes all the defined fields in the
021300200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
021400200529
021500200529     D/COPY ZACPYSRC,PSDS
021600200529      ** The following /COPY line includes definitions for the above fields
021700200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
021800200529      ** corresponding fields in the PSDS /COPY member, so that member
021900200529      ** must be included where this one is used.
022000200529
022100200529     D/COPY ZACPYSRC,PROCPARMS
022200200529
022300200529      **--------------------------------------------------------------------------------------------
022400200529      ** The following /COPY line includes the definitions for error and
022500200529      ** warning message arrays.
022600200529     D/COPY ZACPYSRC,ERR_ARRAYS
022700200529      **--------------------------------------------------------------------------------------------
022800200529
022900200529      **--------------------------------------------------------------------------------------------
023000200529      ** The following /COPY line includes the definitions for arrays
023100200529      ** specific to API *CTL modules.
023200200529     D/COPY ZACPYSRC,APICTLARR
023300200529      **--------------------------------------------------------------------------------------------
023400200529
023500200529
023600200529
023700200529      *                                                                                       CER043
023800200529      ** External DS for Customer Details                                                     CER043
023900200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
024000200529      *                                                                                       CER043
024100200529      ** +--------------------------------------+
024200200529      ** ¦ End of automatically included D-specs¦
024300200529      ** ¦ =====================================¦
024400200529      ** +--------------------------------------+
024500200529
024600200529      *****************************************************************
024700200529      /EJECT
024800200529      *****************************************************************
024900200529
025000200529      ** +--------------------------------------+
025100200529      ** ¦ Manually included D-specs            ¦
025200200529      ** ¦ =========================            ¦
025300200529      ** +--------------------------------------+
025400200529
025500200529      ** +--------------------------------------+
025600200529      ** ¦ Named constants                      ¦
025700200529      ** ¦ ===============                      ¦
025800200529      ** +--------------------------------------+
025900200529
026000200529      **  Data structure for file status of MM deals file.                                  AR736874
026100200529                                                                                            AR736874
026200200529     D INFDS           DS                                                                   AR736874
026300200529     D  RECORD           *RECORD                                                            AR736874
026400200529                                                                                            AR736874
026500200529     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
026600200529     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
026700200529
026800200529      ** +--------------------------------------+
026900200529      ** ¦ Arrays and Data Structures           ¦
027000200529      ** ¦ ==========================           ¦
027100200529      ** +--------------------------------------+
027200200529
027300200529      ** Array of Fields in error.                                                           BUG4808
027400200529     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4808
027500200529                                                                                             BUG4808
027600200529      ** Array of error message IDs                                                          BUG4808
027700200529     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4808
027800200529     D                                     LIKE(#MsgID)                                      BUG4808
027900200529                                                                                             BUG4808
028000200529      ** Array of error message data.                                                        BUG4808
028100200529     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4808
028200200529     D                                     LIKE(#MsgData)                                    BUG4808
028300200529                                                                                             BUG4808
028400200529      ** Array of message files to check                                                     BUG4808
028500200529     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4808
028600200529                                                                                             BUG4808
028700200529      * Array to hold Commitment Job Names                                                    CSC022
028800200529     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
028900200529                                                                                              CSC022
029000200529      ** Commitment Control Data Area                                                         CSC022
029100200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
029200200529     D  wComitJob              4    103                                                       CSC022
029300200529                                                                                              CSC022
029400200529      * Incoming Header
029500200529     D HeadIn        E DS                  EXTNAME(APHEADPD)
029600200529
029700200529     D TranIn        E DS                  EXTNAME(MMDEAMPD)
029800200529      * Incoming Transaction
029900200529
030000200529     D ValidDeal     E DS                  EXTNAME(MMVDEAMPD)
030100200529      * Valid Deals layout
030200200529      **************
030300200529     D***MMVDRecIns            300    368                                                     CGL029
030400200529     D***MMVDPayIns            369    927                                                     CGL029
030500200529     D*MMVDRecIns***         314    368                                               CGL029 BUG2774
030600200529     D*MMVDPayIns***         383    927                                               CGL029 BUG2774
030700200529     D MMVDRecIns            314    382                                                      BUG2774
030800200529     D MMVDPayIns            383    941                                                      BUG2774
030900200529     D*MMVDRecInsEx*********1137   1154                                                CGL029 NAD002
031000200529     D*MMVDPayInsEx*********1155   1172                                                CGL029 NAD002
031100200529      * Large fields to include
031200200529      * - Receive instructions (xxRSTM to xxROCN)
031300200529      * - Pay     instructions (xxPSTM to xxBTB6)
031400200529
031500200529     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
031600200529     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
031700200529     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
031800200529     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
031900200529     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
032000200529     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
032100200529     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
032200200529      * (Current) Deal in File Format
032300200529     D***DEAMRecIns            300    368                                                     CGL029
032400200529     D***DEAMPayIns            369    927                                                     CGL029
032500200529     D DEAMRecIns            314    368                                                       CGL029
032600200529     D DEAMPayIns            383    927                                                       CGL029
032700200529     D*DEAMRecInsEx*********1137   1154                                                CGL029 NAD002
032800200529     D*DEAMPayInsEx*********1155   1172                                                CGL029 NAD002
032900200529      * Large fields to include
033000200529      * - Receive instructions (xxRSTM to xxROCN)
033100200529      * - Pay     instructions (xxPSTM to xxBTB6)
033200200529
033300200529     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
033400200529     D                                     PREFIX(@)
033500200529      * (Current) Deal in Screen Format
033600200529
033700200529     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
033800200529      * Pay Settlement Instructions - Input
033900200529
034000200529     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
034100200529      * Receive Settlement Instructions - Input
034200200529
034300200529     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
034400200529      * FRA/IRS Settlement Instructions - Input
034500200529
034600200529     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
034700200529      * Pay Settlement Instructions - Current
034800200529
034900200529     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
035000200529      * Receive Settlement Instructions - Current
035100200529
035200200529     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
035300200529      * FRA/IRS Settlement Instructions - Current
035400200529
035500200529     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
035600200529      * Pay Settlement Instructions - File (D/B) format
035700200529     D FLPAY2                 21    565                                                       NAD002
035800200529
035900200529     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
036000200529     D**FLREC*****************21     75                                                CGL029 NAD002
036100200529     D FLREC2                 21     75                                                       NAD002
036200200529      * Receive Settlement Instructions - File (D/B) format
036300200529
036400200529     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
036500200529     D**FLPAY*****************21    565                                                CGL029 NAD002
036600200529      * FRA/IRS Settlement Instructions - File (D/B) format
036700200529
036800200529     D InfData       E DS                  EXTNAME(MMDAIFPD)
036900200529      * MM Extra Data - Classe 1 Data - File (D/B) format
037000200529     D                                     PREFIX(IF_)
037100200529
037200200529     D ExtData       E DS                  EXTNAME(MMDAEXPD)
037300200529      * MM Extra Data - File (D/B) format
037400200529
037500200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
037600200529      ** External DS for SAR details
037700200529
037800200529     D DSFDY         E DS                  EXTNAME(DSFDY)
037900200529      * First DS for Access programs - short data structure
038000200529
038100200529     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
038200200529      * Second DS for Access programs - long data structure                                   CER043
038300200529                                                                                              CER043
038400200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
038500200529      ** External DS for Bank Details
038600200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
038700200529      ** External DS for API ICD
038800200529
038900200529     D                 DS
039000200529      **  Data Structure to parameter date passed to mm0085
039100200529     D  @PDAT                  1      8  0
039200200529     D  @PDYY                  1      4  0
039300200529     D  @PYEAR                 3      4  0
039400200529     D  @PDMM                  5      6  0
039500200529     D  @PDDD                  7      8  0
039600200529
039700200529     D                 DS
039800200529      **  Data Structure for screen value date
039900200529     D  @VDAT                  1      6
040000200529     D  @DSPD                  1      2
040100200529     D  @DSPM                  3      4
040200200529     D  @DSPY                  5      6
040300200529
040400200529
040500200529     D MMDEAMUPC       DS             1    DTAARA(MMDEAMUPC)
040600200529
040700200529      *                                                                                       CER043
040800200529      ** Customers Extension Screen Format based on SDCUCUPD                                  CER043
040900200529     D TranInCust    E DS                  EXTNAME(SDCUCUPD)                                  CER043
041000200529      *                                                                                       CER043
041100200529      ** +--------------------------------------+
041200200529      ** ¦ Declared variables                   ¦
041300200529      ** ¦ ==================                   ¦
041400200529      ** +--------------------------------------+
041500200529
041600200529      ** Error message field(s)
041700200529     D     Msg1        S                   LIKE(#MsgID)
041800200529
041900200529      ** Index for arrays of error message ids etc
042000200529     D Idx             S              3P 0
042100200529
042200200529      ** Index for arrays of warning message ids etc
042300200529     D WIdx            S              3P 0
042400200529
042500200529      ** Field (500A) to receive the incoming transaction
042600200529     D Trans500        S            500A
042700200529
042800200529      ** Field (500A) to receive the incoming Extra Data
042900200529     D InfData500      S            500A
043000200529
043100200529      ** Field (500A) to receive the incoming Extra Data
043200200529     D ExtData500      S            500A
043300200529      *                                                                                       CER043
043400200529      ** Field (500A) to receive the incoming Customer details                                CER043
043500200529     D Trans500C       S            500A                                                      CER043
043600200529
043700200529      ** Index for arrays of error message ids etc in Amend validation
043800200529     D AmIdx           S              3P 0
043900200529
044000200529      ** Indices for arrays used to set up corresponding sequence numbers
044100200529      **  for the fields that are in error
044200200529     D Ix              S              3P 0
044300200529     D Iy              S              3P 0
044400200529
044500200529      ** Flags to indicate whether transaction fields are valid
044600200529     D OKFlagsDS       DS
044700200529     D  DDActnOK                      1A   INZ('Y')
044800200529     D  DDDlnoOK                      1A   INZ('Y')
044900200529     D  DDVDatOK                      1A   INZ('Y')
045000200529     D  DDDS38OK                      1A   INZ('Y')
045100200529     D  DDCsnmOK                      1A   INZ('Y')
045200200529     D  DDMTypOK                      1A   INZ('Y')
045300200529     D  DDIntrOK                      1A   INZ('Y')
045400200529     D  DDCcyOK                       1A   INZ('Y')
045500200529     D  DDAmnpOK                      1A   INZ('Y')
045600200529     D  DDFsrpOK                      1A   INZ('Y')
045700200529     D  DDPenPOK                      1A   INZ('Y')                                           CDL017
045800200529     D  DDEmdtOK                      1A   INZ('Y')                                           CDL017
045900200529     D  DDBsrtOK                      1A   INZ('Y')                                           CDL022
046000200529     D  DDAirOK                       1A   INZ('Y')                                           CDL020
046100200529     D  DDCNSPOK                      1A   INZ('Y')                                           CRE073
046200200529     D  DDRDMTOK                      1A   INZ('Y')                                           CRE073
046300200529     D  DDRDFDOK                      1A   INZ('Y')                                           CRE073
046400200529
046500200529      ** Flags to indicate whether Pay Settlement instruction fields
046600200529      **  are valid
046700200529     D OKPayInsDS      DS
046800200529     D  DDPscyOK                      1A   INZ('Y')
046900200529     D  DDPstmOK                      1A   INZ('Y')
047000200529     D  DDPonxOK                      1A   INZ('Y')
047100200529     D  DDRvnoOK                      1A   INZ('Y')
047200200529     D  DDCvmrOK                      1A   INZ('Y')
047300200529     D  DDPocnOK                      1A   INZ('Y')
047400200529     D  DDPobnOK                      1A   INZ('Y')
047500200529     D  DDRcrnOK                      1A   INZ('Y')
047600200529     D  DDRcraOK                      1A   INZ('Y')
047700200529     D  DDPibnOK                      1A   INZ('Y')
047800200529     D  DDPibaOK                      1A   INZ('Y')
047900200529     D  DDAwbnOK                      1A   INZ('Y')
048000200529     D  DDAwbaOK                      1A   INZ('Y')
048100200529     D  DDBennOK                      1A   INZ('Y')
048200200529     D  DDBenaOK                      1A   INZ('Y')
048300200529     D  DDDtp1OK                      1A   INZ('Y')
048400200529     D  DDDtp2OK                      1A   INZ('Y')
048500200529     D  DDDtp3OK                      1A   INZ('Y')
048600200529     D  DDDtp4OK                      1A   INZ('Y')
048700200529     D  DDDchgOK                      1A   INZ('Y')
048800200529     D  DDIc72OK                      1A   INZ('Y')
048900200529     D  DDBtb1OK                      1A   INZ('Y')
049000200529     D  DDBtb2OK                      1A   INZ('Y')
049100200529     D  DDBtb3OK                      1A   INZ('Y')
049200200529     D  DDBtb4OK                      1A   INZ('Y')
049300200529     D  DDBtb5OK                      1A   INZ('Y')
049400200529     D  DDBtb6OK                      1A   INZ('Y')
049500200529
049600200529      ** Flags to indicate whether Receive Settlement instruction fields
049700200529      **  are valid
049800200529     D OKRecInsDS      DS
049900200529     D  DDRscyOK                      1A   INZ('Y')
050000200529     D  DDRstmOK                      1A   INZ('Y')
050100200529     D  DDRonxOK                      1A   INZ('Y')
050200200529     D  DDRocnOK                      1A   INZ('Y')
050300200529     D  DDRobnOK                      1A   INZ('Y')
050400200529     D  DDRibnOK                      1A   INZ('Y')
050500200529     D  DDRibaOK                      1A   INZ('Y')
050600200529     D  DDRmacOK                      1A   INZ('Y')                                           CDL094
050700200529     D  DDRexrOK                      1A   INZ('Y')                                           CDL094
050800200529     D  DDRexiOK                      1A   INZ('Y')                                           CDL094
050900200529     D  DDRbb1OK                      1A   INZ('Y')                                           CDL094
051000200529     D  DDRbb2OK                      1A   INZ('Y')                                           CDL094
051100200529     D  DDRbb3OK                      1A   INZ('Y')                                           CDL094
051200200529     D  DDRbb4OK                      1A   INZ('Y')                                           CDL094
051300200529     D  DDRbb5OK                      1A   INZ('Y')                                           CDL094
051400200529     D  DDRbb6OK                      1A   INZ('Y')                                           CDL094
051500200529
051600200529      ** Flags to indicate whether FRA/IRS instruction fields are valid
051700200529     D OKFRAInsDS      DS
051800200529     D  DDDsr1OK                      1A   INZ('Y')
051900200529     D  DDDsr2OK                      1A   INZ('Y')
052000200529     D  DDDsr3OK                      1A   INZ('Y')
052100200529     D  DDDsr4OK                      1A   INZ('Y')
052200200529     D  DDDsr5OK                      1A   INZ('Y')
052300200529     D  DDDsr6OK                      1A   INZ('Y')
052400200529     D  DDSsr1OK                      1A   INZ('Y')
052500200529     D  DDSsr2OK                      1A   INZ('Y')
052600200529     D  DDSsr3OK                      1A   INZ('Y')
052700200529     D  DDSsr4OK                      1A   INZ('Y')
052800200529     D  DDSsr5OK                      1A   INZ('Y')
052900200529     D  DDSsr6OK                      1A   INZ('Y')
053000200529     D  DDCnd1OK                      1A   INZ('Y')
053100200529     D  DDCnd2OK                      1A   INZ('Y')
053200200529     D  DDCnd3OK                      1A   INZ('Y')
053300200529     D  DDCnd4OK                      1A   INZ('Y')
053400200529     D  DDCnd5OK                      1A   INZ('Y')
053500200529     D  DDCnd6OK                      1A   INZ('Y')
053600200529     D  DDIsdaOK                      1A   INZ('Y')
053700200529     D  DDAgtyOK                      1A   INZ('Y')
053800200529     D  DDAgdtOK                      1A   INZ('Y')
053900200529     D  DDAgvvOK                      1A   INZ('Y')
054000200529
054100200529      ** Flag to indicate outcome of call to lower level module
054200200529     D AmendOK         S              1A   INZ('Y')
054300200529
054400200529      ** Overall Transaction status, to be passed to the Message Handler
054500200529     D TranStatus      S              1A
054600200529
054700200529      ** Module ID, to be passed to the Message Handler
054800200529     D ModuleID        S              2A
054900200529
055000200529      ** A code to indicate the calling function to the lower level modules
055100200529     D DEAM            S              4A   INZ('DEAM')
055200200529
055300200529      ** Payment & Receipt dates, passed to Settlements Validation routine.
055400200529      ** spaces in parameter list not used by this function
055500200529     D PayDat          S              5P 0 INZ(99999)
055600200529     D RecDat          S              5P 0 INZ(99999)
055700200529
055800200529      ** Value Date as a Midas Day Number to be placed in either Payment
055900200529      **  or Receipt Date
056000200529     D ValDateMDN      S              5P 0
056100200529                                                                                             BUG4963
056200200529      ** Booking Branch                                                                      BUG4963
056300200529     D PBokBr          S              3A                                                     BUG4963
056400200529
056500200529      ** Blank fields, passed to Settlements Defaulting routine, to fill
056600200529      ** spaces in parameter list not used by this function
056700200529     D Blank1          S              1A   INZ(*BLANKS)
056800200529     D Blank2          S              2A   INZ(*BLANKS)
056900200529     D*Blank3********* S              3A   INZ(*BLANKS)                                      BUG4963
057000200529     D Blank4          S              4A   INZ(*BLANKS)
057100200529     D Blank6          S              6A   INZ(*BLANKS)
057200200529
057300200529      ** Error Flag for call to Standard routines (equates to *IN99)
057400200529     D ErrorFlag       S              1A   INZ('N')
057500200529
057600200529     D Object          S             10A   INZ('MMDEAMUPC')
057700200529     D Lib             S             10A   INZ('*LIBL')
057800200529     D ObjType         S              7A
057900200529     D LockState       S              7A   INZ('*SHRRD')
058000200529     D Member          S             10A
058100200529     D WaitTime        S              6A   INZ('0     ')
058200200529     D Dlcobj          S              1A   INZ('Y')
058300200529     D Return          S              7A
058400200529
058500200529      ** Dummy message ID and message file fields for use on the calls to
058600200529      ** ZAMSGTOOPR
058700200529     D DummyMsgID      S                   LIKE(#MsgID)
058800200529     D DummyMsgF       S             10A
058900200529     D DEALNR          S              6  0                                                   BUG6534
059000200529
059100200529      ** Work variables for CSC022                                                            CSC022
059200200529     D CSC022          S              1A   INZ('N')                                           CSC022
059300200529     D wCommitSkip     S              1A   INZ('N')                                           CSC022
059400200529                                                                                              CSC022
059500200529     D PRetCode        S              7A                                                      CSC024
059600200529     D P@OP01          S             20A                                                      CSC024
059700200529     D P@VL01          S            200A                                                      CSC024
059800200529     D P@OP02          S             20A                                                      CSC024
059900200529     D P@VL02          S            200A                                                      CSC024
060000200529     D P@OP03          S             20A                                                      CSC024
060100200529     D P@VL03          S            200A                                                      CSC024
060200200529     D P@OP04          S             20A                                                      CSC024
060300200529     D P@VL04          S            200A                                                      CSC024
060400200529     D P@OP05          S             20A                                                      CSC024
060500200529     D P@VL05          S            200A                                                      CSC024
060600200529     D P@OP06          S             20A                                                      CSC024
060700200529     D P@VL06          S            200A                                                      CSC024
060800200529     D P@OP07          S             20A                                                      CSC024
060900200529     D P@VL07          S            200A                                                      CSC024
061000200529     D P@OP08          S             20A                                                      CSC024
061100200529     D P@VL08          S            200A                                                      CSC024
061200200529     D P@OP09          S             20A                                                      CSC024
061300200529     D P@VL09          S            200A                                                      CSC024
061400200529     D P@OP10          S             20A                                                      CSC024
061500200529     D P@VL10          S            200A                                                      CSC024
061600200529                                                                                              CSC024
061700200529     D*CSC024***       S              1A                                               CSC024 CSC054
061800200529     D*WOMEInd**       S              1A                                               CSC024 CSC054
061900200529     D CSC054          S              1A                                                      CSC054
062000200529     D WPEAInd         S              1A                                                      CSC054
062100200529                                                                                            BUG10727
062200200529     D PDEAL#          S              6  0                                                  BUG10727
062300200529     D CDL011          S              1A                                                    MD044400
062400200529                                                                                              CSC024
062500200529      ** +--------------------------------------+
062600200529      ** ¦ End of D-specs                       ¦
062700200529      ** ¦ ==============                       ¦
062800200529      ** +--------------------------------------+
062900200529
063000200529      ** +----------------------------------------+
063100200529      ** ¦ Hook for non-core D-specs (all types)  ¦
063200200529      ** ¦ also any I-specs (if necessary)        ¦
063300200529      ** ¦ =====================================  ¦
063400200529      ** +----------------------------------------+
063500200529     D CER043          S              1A                                                      CER043
063600200529      *                                                                                       CER043
063700200529      ** Parameters for Calling AOCUSTR0                                                      CER043
063800200529     D PRtcd           S              7A                                                      CER043
063900200529     D POptn           S              7A                                                      CER043
064000200529     D PCNum           S             10A                                                      CER043
064100200529     D PKey7           S              7A                                                      CER043
064200200529     D CRE073          S              1A                                                      CRE073
064300200529     D InRCCY          S              3A                                                     CSF011A
064400200529     D InPCCY          S              3A                                                     CSF011A
064500200529      /COPY WNCPYSRC,MMDEAMC020
064600200529      *****************************************************************
064700200529      /EJECT
064800200529      *****************************************************************
064900200529      ** +--- Start of Main processing -----------------------------------+
065000200529      ** ¦                                                                ¦
065100200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
065200200529      ** ¦ executed at program activation.                                ¦
065300200529      ** ¦                                                                ¦
065400200529      ** +----------------------------------------------------------------+
065500200529
065600200529      * Incoming transaction is in a 500A field, so that a common CLP
065700200529      * can be used between this module and the one that read the MQ queue.
065800200529      * This module needs to break that 500A by loading it into the
065900200529      * appropriate (externally described) data structure.
066000200529     C                   MOVEL     Trans500      TranIn
066100200529     C                   MOVEL     Trans500C     TranInCust                                   CER043
066200200529     C                   MOVEL     Infdata500    Infdata
066300200529     C                   MOVEL     Extdata500    Extdata
066400200529
066500200529     C                   IF        APFOTRANID <> *BLANKS                                   AR971184A
066600200529     C                   EVAL      DDFOID = APFOTRANID                                     AR971184A
066700200529     C                   ENDIF                                                             AR971184A
066800200529      * Reset variables gradually updated
066900200529
067000200529     C                   EXSR      RESETCYCLE
067100200529      *
067200200529      *  If valid deal does exist (even after delay), fail this input
067300200529      *
067400200529     C     Idx           IFNE      0
067500200529     C                   GOTO      INVALID
067600200529     C                   END
067700200529
067800200529
067900200529      *  Validate Action Code
068000200529
068100200529      *  Additional deal number validation in ValidateAc for initial input screen.           BUG6534
068200200529      *                                                                                      BUG6534
068300200529     C                   EXSR      ValidateAc
068400200529     C*                                                                                      BUG6534
068500200529     C**  Validate the deal amendment type here it to be picked up                           BUG6534
068600200529     C**  on the new DEAM initial input screen.                                              BUG6534
068700200529     C*                                                                                      BUG6534
068800200529     C     DDMTYP        IFEQ      *BLANKS                                                   BUG6534
068900200529     C                   ADD       1             Idx                                         BUG6534
069000200529     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'                                BUG6534
069100200529     C                   EVAL      MsgIDArr(Idx) = 'MMM0297'                                 BUG6534
069200200529     C                   END                                                                 BUG6534
069300200529
069400200529      /COPY WNCPYSRC,MMDEAMC004
069500200529      *
069600200529      *  If error in validation of action code, fail this input
069700200529      *
069800200529     C     Idx           IFNE      0
069900200529     C                   GOTO      INVALID
070000200529     C                   END
070100200529
070200200529      *  Processing depends upon Action Code
070300200529
070400200529     C                   SELECT
070500200529
070600200529     C                   WHEN      DDACTN = 'I'
070700200529      *  Processing for Inserts
070800200529     C                   EXSR      DftSettmts
070900200529     C                   EXSR      ValidateTr
071000200529     C                   EXSR      ValidateSt
071100200529
071200200529     C                   WHEN      DDACTN = 'A'
071300200529      *  Processing for Amends
071400200529     C     GHSUBS        ifne      *blank
071500200529     C     GHSUBS        scan      TranIn                                 99
071600200529     C     *in99         ifeq      *on
071700200529     C                   endif
071800200529     C                   endif
071900200529     C                   EXSR      SetupAmend
072000200529     C                   EXSR      ValdateAmd
072100200529     C                   EXSR      ValidateTr
072200200529     C                   EXSR      ValidateSt
072300200529                                                                                             BUG4482
072400200529     C                   WHEN      DDACTN = 'X'                                              BUG4482
072500200529      *  Processing for Authorises                                                           BUG4482
072600200529     C                   EXSR      ValidateTr                                                BUG4482
072700200529     C                   EXSR      ValidateSt                                                BUG4482
072800200529
072900200529     C                   ENDSL
073000200529
073100200529     C     INVALID       TAG
073200200529      *                                                                                       CER043
073300200529      ** Population of Customer Details                                                       CER043
073400200529     C                   IF        CER043 = 'Y'                                               CER043
073500200529     C                   EXSR      SrPopCust                                                  CER043
073600200529     C                   ENDIF                                                                CER043
073700200529
073800200529      *  Write to database
073900200529     C     UpdateYN      IFEQ      'Y'
074000200529     C     Idx           ANDEQ     0
074100200529     C                   EXSR      WriteToDB
074200200529     C                   ENDIF
074300200529
074400200529     C                   SETON                                        LR
074500200529
074600200529      ** If action is for Update, get the correct record information                         BUG4808
074700200529      ** from file                                                                           BUG4808
074800200529     C                   IF        UpdateYN = 'Y'                                            BUG4808
074900200529     C                             AND Idx = 0                                               BUG8119
075000200529     C                   MOVE      IGDA38        DDDLNO_In                                   BUG4808
075100200529     C                   MOVE      IGDS38        DDDS38_In                                   BUG4808
075200200529     C                   MOVE      IGVDYY        @DSPY                                       BUG4808
075300200529     C                   IF        BJDFIN = 'D'                                              BUG4808
075400200529     C                   MOVE      IGVDMM        @DSPM                                       BUG4808
075500200529     C                   MOVE      IGVDDD        @DSPD                                       BUG4808
075600200529     C                   ELSE                                                                BUG4808
075700200529     C                   MOVE      IGVDMM        @DSPD                                       BUG4808
075800200529     C                   MOVE      IGVDDD        @DSPM                                       BUG4808
075900200529     C                   ENDIF                                                               BUG4808
076000200529     C                   MOVE      @VDAT         DDVDAT_In                                   BUG4808
076100200529     C                   CALL      'MMDEAMR'                                                 BUG4808
076200200529     C                   PARM                    @AuthComp         1                         BUG4808
076300200529     C                   PARM                    @FwdBck           1                         BUG4808
076400200529     C                   PARM                    DDDLNO_In         6                         BUG4808
076500200529     C                   PARM                    DDVDAT_In         6                         BUG4808
076600200529     C                   PARM                    DDDS38_In         3                         BUG4808
076700200529     C                   PARM                    Buffer                                      BUG4808
076800200529     C                   PARM                    @FldNameArr                                 BUG4808
076900200529     C                   PARM                    @MsgIDArr                                   BUG4808
077000200529     C                   PARM                    @MsgDtaArr                                  BUG4808
077100200529     C                   PARM                    @MsgFArray                                  BUG4808
077200200529     C                   PARM                    @APIRetC          1                         BUG4808
077300200529     C                   PARM                    @ACTRV                                       260173
077400200529     C                   MOVEL     DDACTN        Buffer                                      BUG4808
077500200529     C                   ELSE                                                                BUG4808
077600200529      *                                                                                      BUG6534
077700200529      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
077800200529      *                                                                                      BUG6534
077900200529     C**********         MOVEL     ' '           LONDEP                             BUG6534 MD044400
078000200529     C**********         MOVEL     ' '           DDCSNM                            AR736874 MD044400
078100200529     C**********         MOVEL     ' '           DDCCY                             AR736874 MD044400
078200200529     C                   MOVEL     *BLANKS       LONDEP                                     MD044400
078300200529     C                   MOVEL     *BLANKS       DDCSNM                                     MD044400
078400200529     C                   MOVEL     *BLANKS       DDCCY                                      MD044400
078500200529     C                   IF        DDDLNO <> *BLANKS                                         BUG6534
078600200529     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
078700200529     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
078800200529      *                                                                                      BUG6534
078900200529     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
079000200529     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
079100200529     C                   MOVEL     'D'           LONDEP                                      BUG6534
079200200529     C                   ELSE                                                                BUG6534
079300200529     C                   MOVEL     'L'           LONDEP                                      BUG6534
079400200529     C                   ENDIF                                                               BUG6534
079500200529                                                                                            AR736874
079600200529     C                   IF        RECORD = 'MMDELDP0'                                      AR736874
079700200529      *                                                                                    AR1092035
079800200529     C                   IF        CDL005 = 'Y'                                            AR1092035
079900200529     C                             OR CDL011 = 'Y'                                          MD044400
080000200529     C                   MOVEL     HKCSNM        DDCSNM                                     AR736874
080100200529     C                   ELSE                                                              AR1092035
080200200529     C                   MOVEL     HKCNUM        DDCSNM                                    AR1092035
080300200529     C                   ENDIF                                                             AR1092035
080400200529      *                                                                                    AR1092035
080500200529     C                   MOVEL     HKCCY         DDCCY                                      AR736874
080600200529     C                   ENDIF                                                              AR736874
080700200529     C                   IF        RECORD = 'MMDENBP0'                                      AR736874
080800200529     C                   IF        CDL005 = 'Y'                                             MD055318
080900200529     C                             OR CDL011 = 'Y'                                          MD055318
081000200529     C                   MOVEL     HLCSNM        DDCSNM                                     AR736874
081100200529     C                   ELSE                                                               MD055318
081200200529     C                   MOVEL     HLCNUM        DDCSNM                                     MD055318
081300200529     C                   ENDIF                                                              MD055318
081400200529     C                   MOVEL     HLCCY         DDCCY                                      AR736874
081500200529     C                   ENDIF                                                              AR736874
081600200529     C                   IF        RECORD = 'MMDENSP0'                                      AR736874
081700200529     C                   IF        CDL005 = 'Y'                                             MD055318
081800200529     C                             OR CDL011 = 'Y'                                          MD055318
081900200529     C                   MOVEL     HMCSNM        DDCSNM                                     AR736874
082000200529     C                   ELSE                                                               MD055318
082100200529     C                   MOVEL     HMCNUM        DDCSNM                                     MD055318
082200200529     C                   ENDIF                                                              MD055318
082300200529     C                   MOVEL     HMCCY         DDCCY                                      AR736874
082400200529     C                   ENDIF                                                              AR736874
082500200529     C                   ENDIF                                                               BUG6534
082600200529      *                                                                                      BUG6534
082700200529     C                   EVAL                    Buffer = TranIN
082800200529     C**********                                          + @TimeStamp               BUG4146 BUG6534
082900200529     C**********                                 + @TimeStamp + LONDEP                BUG6534 CER043
083000200529     C                                           + @TimeStamp                                 CER043
083100200529     C                                           + TranInCust                                 CER043
083200200529     C                                           + LONDEP                                     CER043
083300200529     C                                           + DDFOID                                     239400
083400200529     C                                           + @ACTRV                                     260173
083500200529     C                                           + InRecSttmt + InPaySttmt
083600200529     C                                           + InfData  + ExtData
083700200529     C                   ENDIF                                                               BUG4808
083800200529
083900200529     C                   RETURN
084000200529
084100200529
084200200529      *****************************************************************
084300200529      /EJECT
084400200529      *****************************************************************
084500200529      *                                                               *
084600200529      * ValidateAc - Routine to validate action code versus the       *
084700200529      *    transaction IDs supplied                                   *
084800200529      *                                                               *
084900200529      *****************************************************************
085000200529
085100200529     C     ValidateAc    BEGSR
085200200529                                                                                            AR971184
085300200529     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
085400200529     C                             DDACTN = 'I'                                             AR971184
085500200529     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
085600200529     C                   ELSE                                                               AR971184
085700200529     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
085800200529     C                   ENDIF                                                              AR971184
085900200529      *
086000200529      * Validate action code versus transaction IDs supplied
086100200529      * This function will set the Midas deal number of the original deal
086200200529      * The deam in file format from the MM database is retrieved as well.
086300200529
086400200529     C                   RESET                   ReturnCode
086500200529     C                   CALLB     'MMDEAMRTV'
086600200529
086700200529      * INPUTS
086800200529
086900200529      * Return code
087000200529     C                   PARM                    ReturnCode
087100200529
087200200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
087300200529      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
087400200529     C                   PARM                    ModeofOp          6
087500200529      *
087600200529      * Response mode
087700200529     C                   PARM      'S'           APRESPMODE
087800200529
087900200529      * Action Code
088000200529     C                   PARM                    DDACTN
088100200529
088200200529      * Front Office Transaction ID
088300200529     C                   PARM                    APFOTranID
088400200529
088500200529      * Front Office Associated Transaction Id
088600200529     C                   PARM                    APFOAsocID
088700200529
088800200529      * (Midas) Deal Number
088900200529     C                   PARM                    DDDLNO
089000200529
089100200529      * Value Date
089200200529     C                   PARM                    DDVDAT
089300200529      *
089400200529      * Sequence Number
089500200529     C                   PARM                    DDDS38
089600200529      *
089700200529      * Deal Amendment Amount
089800200529     C                   PARM                    DDAMNP
089900200529      *
090000200529      * Deal Amendment Type
090100200529     C                   PARM                    DDMTYP
090200200529      * Action Code (Reversal transaction)                                                    260173
090300200529     C                   PARM                    @ACTRV                                       26017
090400200529
090500200529      * OUTPUTS
090600200529
090700200529      * (Current) deal in file format
090800200529     C                   PARM                    DealFilFmt
090900200529
091000200529      * OK - Action code
091100200529     C                   PARM                    DDActnOK
091200200529
091300200529      * OK - Deal Number
091400200529     C                   PARM                    DDDlnoOK
091500200529
091600200529      * OK - Value Date
091700200529     C                   PARM                    DDVDatOK
091800200529
091900200529      * OK - Sequence Number
092000200529     C                   PARM                    DDDS38OK
092100200529
092200200529      * Error fields/message IDs/message data (arrays) from/to caller
092300200529     C                   PARM                    FldNameArr
092400200529     C                   PARM                    MsgIDArr
092500200529     C                   PARM                    MsgDtaArr
092600200529
092700200529      * Array index (3P0) from/to caller
092800200529     C                   PARM                    Idx
092900200529                                                                                            BUG10727
093000200529      ** Retrieve warning message, if needed.                                               BUG10727
093100200529                                                                                            BUG10727
093200200529     C                   IF        DDACTN = 'I' OR DDACTN = 'D'                             BUG10727
093300200529                                                                                            BUG10727
093400200529     C                   MOVE      DDDLNO        PDEAL#                                     BUG10727
093500200529                                                                                            BUG10727
093600200529     C                   CALLB     'MMDEAMWRN'                                              BUG10727
093700200529     C                   PARM                    PDEAL#                                     BUG10727
093800200529     C                   PARM                    DDACTN                                     BUG10727
093900200529     C                   PARM                    DDMTYP                                     BUG10727
094000200529     C                   PARM                    WFldNamArr                                 BUG10727
094100200529     C                   PARM                    WMsgIdArr                                  BUG10727
094200200529     C                   PARM                    WMsgDtaArr                                 BUG10727
094300200529     C                   PARM                    WIdx                                       BUG10727
094400200529                                                                                            BUG10727
094500200529     C                   ENDIF                                                              BUG10727
094600200529                                                                                            BUG10727
094700200529
094800200529     C                   ENDSR
094900200529      *****************************************************************
095000200529      /EJECT
095100200529      *****************************************************************
095200200529      *                                                               *
095300200529      * DftSettmts - Routine to apply default settlement instructions *
095400200529      *    if none have been supplied                                 *
095500200529      *                                                               *
095600200529      *****************************************************************
095700200529
095800200529     C     DftSettmts    BEGSR
095900200529
096000200529      * If ANY of the Settlements fields have been entered, bypass this
096100200529      *  routine.
096200200529      * Otherwise, use modules which will use Standard Settlement
096300200529      *  Instructions to apply defaults.
096400200529
096500200529     C                   IF            (InRecSttmt = *blank)
096600200529     C                             AND (InPaySttmt = *blank)
096700200529
096800200529      * Deal Amendment types 'SC' and 'CI' should have no settlement
096900200529      * instructions; initialise pay and receive settlement methods.
097000200529
097100200529     C     DDMTYP        IFEQ      'SC'
097200200529     C     DDMTYP        OREQ      'CI'
097300200529     C     DDMTYP        OREQ      'BC'                                                     AR792037
097400200529     C                   MOVEL     '00'          DDPSTM
097500200529     C                   MOVEL     '00'          DDRSTM
097600200529     C                   GOTO      EDFTSETT
097700200529     C                   ENDIF
097800200529
097900200529     C                   IF        DDDLNO <> *BLANKS                                          250357
098000200529     C                   MOVEL     DDDLNO        DEALNR                                       250357
098100200529     C     DEALNR        CHAIN     MMDEALLL                           30                      250357
098200200529      *                                                                                       250357
098300200529     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                             250357
098400200529     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                          250357
098500200529     C                   MOVEL     'D'           LONDEP                                       250357
098600200529     C                   ELSE                                                                 250357
098700200529     C                   MOVEL     'L'           LONDEP                                       250357
098800200529     C                   ENDIF                                                                250357
098900200529     C                   ENDIF                                                                250357
099000200529                                                                                              250357
099100200529     C                   MOVE      ' '           DFTRST            1                          250357
099200200529     C                   MOVEL     ' '           DFTPST            1                          250357
099300200529      ** If Principal Decrease of Deposit Taken or Early Maturity of Deposit Taken            250357
099400200529      ** or Principal Increase of Deposit Placed or Base Rate or Capitalise Interest          250357
099500200529      ** or Spread Change.                                                                    250357
099600200529                                                                                              250357
099700200529     C     DDMTYP        IFEQ      'PD'                                                       250357
099800200529     C     LONDEP        ANDEQ     'D'                                                        250357
099900200529     C     DDMTYP        OREQ      'EM'                                                       250357
100000200529     C*****LONDEP        ANDEQ     'D'                                                 250357 249910
100100200529     C     DDMTYP        OREQ      'PI'                                                       250357
100200200529     C     LONDEP        ANDEQ     'L'                                                        250357
100300200529     C     DDMTYP        OREQ      'BC'                                                       250357
100400200529     C     DDMTYP        OREQ      'CI'                                                       250357
100500200529     C     DDMTYP        OREQ      'SC'                                                       250357
100600200529     C     DDMTYP        OREQ      'SI'                                                     MD022624
100700200529      *                                                                                       250357
100800200529     C                   EVAL      FLPSTM = HKPSTM                                            250357
100900200529     C                   EVAL      FLPONS = HKPONS                                            250357
101000200529     C                   EVAL      FLPIBN = HKPIBN                                            250357
101100200529     C                   EVAL      FLPIBA = HKPIBA                                            250357
101200200529     C                   EVAL      FLPOBN = HKPOBN                                            250357
101300200529     C                   EVAL      FLPOCN = HKPOCN                                            250357
101400200529     C                   EVAL      FLRCRN = HKRCRN                                            250357
101500200529     C                   EVAL      FLRCRA = HKRCRA                                            250357
101600200529     C                   EVAL      FLRVNO = HKRVNO                                            250357
101700200529     C                   EVAL      FLAWBN = HKAWBN                                            250357
101800200529     C                   EVAL      FLAWBA = HKAWBA                                            250357
101900200529     C                   EVAL      FLBENN = HKBENN                                            250357
102000200529     C                   EVAL      FLBENA = HKBENA                                            250357
102100200529     C                   EVAL      FLDTP1 = HKDTP1                                            250357
102200200529     C                   EVAL      FLDTP2 = HKDTP2                                            250357
102300200529     C                   EVAL      FLDTP3 = HKDTP3                                            250357
102400200529     C                   EVAL      FLDTP4 = HKDTP4                                            250357
102500200529     C                   EVAL      FLDCHG = HKDCHG                                            250357
102600200529     C                   EVAL      FLBTB1 = HKBTB1                                            250357
102700200529     C                   EVAL      FLBTB2 = HKBTB2                                            250357
102800200529     C                   EVAL      FLBTB3 = HKBTB3                                            250357
102900200529     C                   EVAL      FLBTB4 = HKBTB4                                            250357
103000200529     C                   EVAL      FLBTB5 = HKBTB5                                            250357
103100200529     C                   EVAL      FLBTB6 = HKBTB6                                            250357
103200200529     C                   EVAL      FLPOBR = HKPOBR                                            250357
103300200529     C                   EVAL      FLCVMR = HKCVMR                                            250357
103400200529     C                   EVAL      FLPSCY = HKSTCY                                            250357
103500200529     C                   EVAL      DFTPST = 'Y'                                               250357
103600200529     C                   ENDIF                                                                249910
103700200529      *                                                                                       250357
103800200529      *                                                                                       250357
103900200529      ** If Principal Decrease of Deposit Placed or Early Maturity of Deposit Placed          250357
104000200529      ** or Principal Increase of Deposit Taken or Base Rate or Capitalise Interest           250357
104100200529      ** or Spread Change.                                                                    250357
104200200529      **                                                                                      250357
104300200529     C*********          ELSE                                                          250357 249910
104400200529      *                                                                                       250357
104500200529     C     DDMTYP        IFEQ      'PD'                                                       250357
104600200529     C     LONDEP        ANDEQ     'L'                                                        250357
104700200529     C     DDMTYP        OREQ      'EM'                                                       250357
104800200529     C*****LONDEP        ANDEQ     'L'                                                        250357
104900200529     C     DDMTYP        OREQ      'PI'                                                       250357
105000200529     C     LONDEP        ANDEQ     'D'                                                        250357
105100200529     C     DDMTYP        OREQ      'BC'                                                       250357
105200200529     C     DDMTYP        OREQ      'CI'                                                       250357
105300200529     C     DDMTYP        OREQ      'SC'                                                       250357
105400200529     C     DDMTYP        OREQ      'SI'                                                     MD027598
105500200529      *                                                                                       250357
105600200529     C                   EVAL      FLRSTM = HKRSTM                                            250357
105700200529     C                   EVAL      FLRONS = HKRONS                                            250357
105800200529     C                   EVAL      FLRIBN = HKRIBN                                            250357
105900200529     C                   EVAL      FLRIBA = HKRIBA                                            250357
106000200529     C                   EVAL      FLROBN = HKROBN                                            250357
106100200529     C                   EVAL      FLROCN = HKROCN                                            250357
106200200529     C                   EVAL      FLROBR = HKROBR                                            250357
106300200529     C                   EVAL      FLRSCY = HKSTCY                                            250357
106400200529     C                   EVAL      FLRBB1 = HKRBB1                                            CDL094
106500200529     C                   EVAL      FLRBB2 = HKRBB2                                            CDL094
106600200529     C                   EVAL      FLRBB3 = HKRBB3                                            CDL094
106700200529     C                   EVAL      FLRBB4 = HKRBB4                                            CDL094
106800200529     C                   EVAL      FLRBB5 = HKRBB5                                            CDL094
106900200529     C                   EVAL      FLRBB6 = HKRBB6                                            CDL094
107000200529     C                   EVAL      DFTRST = 'Y'                                               250357
107100200529     C                   ENDIF                                                                250357
107200200529     C********           ENDIF                                                         250357 249910
107300200529      *                                                                                       250357
107400200529     C     DFTPST        IFEQ      'Y'                                                        250357
107500200529     C     FLPSTM        ANDEQ     0                                                          250357
107600200529     C     DFTRST        OREQ      'Y'                                                        250357
107700200529     C     FLRSTM        ANDEQ     0                                                          250357
107800200529                                                                                              CSD095
107900200529      ** Retrieve the subtype and branch associated with the deal                             CSD095
108000200529                                                                                              CSD095
108100200529     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
108200200529     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
108300200529     C                   MOVEL     HKCNUM        DDCSNM                                       CSD095
108400200529                                                                                              CSD095
108500200529     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
108600200529     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
108700200529     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
108800200529     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
108900200529     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
109000200529     C                   ENDIF                                                                CSD095
109100200529                                                                                              CSD095
109200200529     C                   CALLB     'ZASETINDFT'
109300200529
109400200529      ** Output
109500200529      ** Calling function type
109600200529     C                   PARM                    DEAM
109700200529      ** Payment currency (or deal cuurency if only one currency on deal)
109800200529     C**********         PARM                    DDCcy                                        CSD095
109900200529     C                   PARM      HKCCY         DDCcy                                        CSD095
110000200529      ** Receive currency (only if deal has two currencies)
110100200529     C                   PARM                    DDCcy
110200200529      ** Customer (shortname or number)
110300200529     C                   PARM                    DDCsnm
110400200529      ** Deal type
110500200529     C                   PARM                    DDMTyp
110600200529      ** Federal Funds Ind. (not applicable for DEAMS)
110700200529     C                   PARM                    Blank1
110800200529      ** ISDA Rules for FRA/IRS deals only
110900200529      ** Version of ISDA Rules govern
111000200529     C                   PARM                    Blank4
111100200529      ** Type of ISDA agreement
111200200529     C                   PARM                    Blank6
111300200529      ** Date of ISDA Agreement
111400200529     C                   PARM                    Blank6
111500200529      ** Version of ISDA Agreement
111600200529     C                   PARM                    Blank2
111700200529      ** Version of ISDA Agreement century
111800200529     C                   PARM                    Blank2
111900200529      ** Deal Subtype                                                                         CSD095
112000200529     C                   PARM                    DDSTYP            2                          CSD095
112100200529      ** Branch                                                                               CSD095
112200200529     C                   PARM                    DDBRCA            3                          CSD095
112300200529      *
112400200529      ** Return
112500200529      ** Defaulted Payment Settlement Instruction in file format
112600200529     C                   PARM                    DBPaySttmt
112700200529      ** Defaulted Receipt Settlement Instruction in file format
112800200529     C                   PARM                    DBRecSttmt
112900200529      ** Defaulted FRA/IRS Settlement Instruction in file format
113000200529     C                   PARM                    DBFRASttmt
113100200529
113200200529      *  The defaulted instructions are in file format, but the
113300200529      *   Settlements validation requires that they are in the input format.
113400200529      *  Therefore run them through a conversion module.
113500200529     C                   ENDIF                                                                250357
113600200529
113700200529     C                   CALLB     'ZASETINCVT'
113800200529      ** Defaulted Settlement Instructions in file format
113900200529     C                   PARM                    DBPaySttmt
114000200529     C                   PARM                    DBRecSttmt
114100200529     C                   PARM                    DBFRASttmt
114200200529
114300200529      ** Defaulted Settlement Instruction in input format
114400200529     C                   PARM                    InPaySttmt
114500200529     C                   PARM                    InRecSttmt
114600200529     C                   PARM                    InFRASttmt
114700200529     C                   PARM      DDCCY         InRCCY                                      CSF011A
114800200529     C                   PARM      DDCCY         InPCCY                                      CSF011A
114900200529      *
115000200529      * LOAN OR DEPOSIT TYPE DEAL?  (FROM RETRIEVE FUNCTION)
115100200529      *
115200200529     C     HNOMDT        IFEQ      'IT'
115300200529     C     HNOMDT        OREQ      'TD'
115400200529     C     HNOMDT        OREQ      'CI'
115500200529     C     HNOMDT        OREQ      'CD'
115600200529     C                   MOVEL     'D'           W#LOD             1
115700200529     C                   ELSE
115800200529     C                   MOVEL     'L'           W#LOD
115900200529     C                   END
116000200529
116100200529      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
116200200529      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
116300200529      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
116400200529
116500200529     C     DDMTYP        IFEQ      'PD'
116600200529     C     W#LOD         ANDEQ     'D'
116700200529     C     DDMTYP        OREQ      'PI'
116800200529     C     W#LOD         ANDEQ     'L'
116900200529     C     DDMTYP        OREQ      'SI'
117000200529     C     W#LOD         ANDEQ     'D'
117100200529      *
117200200529     C                   CLEAR                   InRecSttmt
117300200529     C                   MOVEL     '00'          DDRSTM
117400200529      *
117500200529      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
117600200529      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
117700200529      ** OR SETTLE INTEREST OF DEPOSIT PLACED
117800200529      **
117900200529     C                   ELSE
118000200529      *
118100200529     C     DDMTYP        IFEQ      'PD'
118200200529     C     W#LOD         ANDEQ     'L'
118300200529     C     DDMTYP        OREQ      'PI'
118400200529     C     W#LOD         ANDEQ     'D'
118500200529     C     DDMTYP        OREQ      'SI'
118600200529     C     W#LOD         ANDEQ     'L'
118700200529      *
118800200529     C                   CLEAR                   InPaySttmt
118900200529     C                   MOVEL     '00'          DDPSTM
119000200529
119100200529     C                   ENDIF
119200200529     C                   ENDIF
119300200529      *
119400200529     C                   ENDIF
119500200529
119600200529     C     EDFTSETT      ENDSR
119700200529      *****************************************************************
119800200529      /EJECT
119900200529      *****************************************************************
120000200529      *                                                               *
120100200529      * SETUPAMEND - Set up fields that are needed in the validation  *
120200200529      *    of Amendments.                                             *
120300200529      *                                                               *
120400200529      *****************************************************************
120500200529
120600200529     C     SetupAmend    BEGSR
120700200529
120800200529      * For Amends, put the complete (pre-existing) deam into the
120900200529      *  Valid file record - fields in this will be updated during
121000200529      *  processing
121100200529     C                   MOVE      DealFilFmt    ValidDeal
121200200529
121300200529
121400200529     C**********         EVAL      DBRecSttmt = DEAMRecIns + HNOSBR                           CGL029
121500200529     C*******************EVAL      FLREC      = DEAMRecIns                             CGL029 NAD002
121600200529     C*******************EVAL      FLRONS     = DEAMRecInsEx                           CGL029 NAD002
121700200529     C*******************EVAL      FLRSTM     = HNRSTM                                 CGL029 NAD002
121800200529     C*******************EVAL      FLROBR     = HNOSBR                                 CGL029 NAD002
121900200529     C                   EVAL      FLRSTM     = HNRSTM                                        NAD002
122000200529     C                   EVAL      FLRONS     = HNRONS                                        NAD002
122100200529     C                   EVAL      FLREC2     = DEAMRecIns                                    NAD002
122200200529     C                   EVAL      FLROBR     = HNOSBR                                        NAD002
122300200529     C                   EVAL      FLRSCY     = HNSTCY
122400200529     C**********         EVAL      DBPaySttmt = DEAMPayIns + HNOSBR + HNCVMR                  CGL029
122500200529     C*******************EVAL      FLPAY      = DEAMPayIns                             CGL029 NAD002
122600200529     C*******************EVAL      FLPONS     = DEAMPayInsEx                           CGL029 NAD002
122700200529     C                   EVAL      FLPSTM     = HNPSTM                                        CGL029
122800200529     C                   EVAL      FLPONS     = HNPONS                                        NAD002
122900200529     C                   EVAL      FLPAY2     = DEAMPayIns                                    NAD002
123000200529     C                   EVAL      FLPOBR     = HNOSBR                                        CGL029
123100200529     C                   EVAL      FLCVMR     = HNCVMR                                        CGL029
123200200529     C                   EVAL      FLPSCY     = HNSTCY
123300200529     C                   EVAL      FLIC72     = HNIC72
123400200529     C                   EVAL      FLRBB1     = HNRBB1                                        CDL094
123500200529     C                   EVAL      FLRBB2     = HNRBB2                                        CDL094
123600200529     C                   EVAL      FLRBB3     = HNRBB3                                        CDL094
123700200529     C                   EVAL      FLRBB4     = HNRBB4                                        CDL094
123800200529     C                   EVAL      FLRBB5     = HNRBB5                                        CDL094
123900200529     C                   EVAL      FLRBB6     = HNRBB6                                        CDL094
124000200529
124100200529      *  .... and then convert these to the screen format
124200200529     C                   CALLB     'ZASETINCVT'
124300200529
124400200529      ** Defaulted Settlement Instructions in file format
124500200529     C                   PARM                    DBPaySttmt
124600200529     C                   PARM                    DBRecSttmt
124700200529     C                   PARM                    DBFRASttmt
124800200529
124900200529      ** Current Settlement Instruction in input format
125000200529     C                   PARM                    CrPaySttmt
125100200529     C                   PARM                    CrRecSttmt
125200200529     C                   PARM                    CrFRASttmt
125300200529     C                   PARM      HNCCY         InRCCY                                      CSF011A
125400200529     C                   PARM      HNCCY         InPCCY                                      CSF011A
125500200529
125600200529      *  If no Payment or Receive instructions have been supplied
125700200529      *  Default them to those currently on the deal.
125800200529
125900200529     C                   IF            (InPaySttmt = *blank)
126000200529     C                   EVAL      InPaySttmt = CrPaySttmt
126100200529     C                   ENDIF
126200200529
126300200529     C                   IF            (InRecSttmt = *blank)
126400200529     C                   EVAL      InRecSttmt = CrRecSttmt
126500200529     C                   ENDIF
126600200529
126700200529
126800200529     C                   ENDSR
126900200529      *****************************************************************
127000200529      /EJECT
127100200529      *****************************************************************
127200200529      *                                                               *
127300200529      * ValidateTr - Routine to validate the main tranaction details  *
127400200529      *                                                               *
127500200529      *****************************************************************
127600200529
127700200529     C     ValidateTr    BEGSR
127800200529
127900200529     C                   CALLB     'MMDEAMVAL'
128000200529      * Response mode (1A), from source system common header
128100200529     C                   PARM      'S'           APRespMode
128200200529      * Transaction information (DS) from source system
128300200529     C                   PARM                    TranIn
128400200529     C                   PARM                    InfData
128500200529      * Extra Data
128600200529     C                   PARM                    ExtData
128700200529      * Field OK flags (DS) from/to caller
128800200529     C                   PARM                    OKFlagsDS
128900200529      * Error fields/message IDs/message data (arrays) from/to caller
129000200529     C                   PARM                    FldNameArr
129100200529     C                   PARM                    MsgIDArr
129200200529     C                   PARM                    MsgDtaArr
129300200529      * Array index (3P0) from/to caller
129400200529     C                   PARM                    Idx
129500200529      * Warning fields/message IDs/message data (arrays) from/to caller
129600200529     C                   PARM                    WFldNamArr
129700200529     C                   PARM                    WMsgIDArr
129800200529     C                   PARM                    WMsgDtaArr
129900200529      * Array index (3P0) from/to caller
130000200529     C                   PARM                    WIdx
130100200529      * Valid Deals layout (DS) from/to caller
130200200529     C                   PARM                    ValidDeal
130300200529
130400200529     C                   ENDSR
130500200529      *****************************************************************
130600200529      /EJECT
130700200529      *****************************************************************
130800200529      *                                                               *
130900200529      * ValidateSt - Routine to validate the settlemnt instructions   *
131000200529      *                                                               *
131100200529      *****************************************************************
131200200529
131300200529     C     ValidateSt    BEGSR
131400200529
131500200529      * The called module requires that the customer number/name is valid,
131600200529      *  if it is not, exit from this subroutine.
131700200529     C                   IF        NOT (DDCsnmOK = 'Y')
131800200529     C                   GOTO      ValSetExit
131900200529     C                   ENDIF
132000200529
132100200529      * The called module uses the value date in Midas Day Number format,
132200200529      *  which will not have been returned from the overall validation
132300200529      *  routine, so it needs to be converted here.
132400200529
132500200529     C                   IF        DDVDatOK <> 'N'
132600200529
132700200529     C                   CALLB     'ZDATE1'
132800200529     C                   PARM                    DDVDAT
132900200529     C                   PARM                    ValDateMDN
133000200529     C                   PARM                    BJDFIN
133100200529     C                   PARM                    ErrorFlag
133200200529
133300200529      * For Deal Amendments set the Pay Date and Receive Date = Value Date
133400200529     C                   EVAL      PayDat = ValDateMDN
133500200529     C                   EVAL      RecDat = ValDateMDN
133600200529
133700200529     C                   ENDIF
133800200529                                                                                             BUG4963
133900200529      ** Initialize Booking Branch                                                           BUG4963
134000200529                                                                                             BUG4963
134100200529     C                   IF        DDPSTM = '04' OR DDRSTM = '04'                            BUG4963
134200200529     C                   EVAL      PBokBr = IGBRCA                                           BUG4963
134300200529     C                   ELSE                                                                BUG4963
134400200529     C                   EVAL      PBokBr = *blanks                                          BUG4963
134500200529     C                   ENDIF                                                               BUG4963
134600200529
134700200529      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
134800200529      *                                                                                      BUG6534
134900200529     C                   MOVEL     ' '           LONDEP                                      BUG6534
135000200529     C                   IF        DDDLNO <> *BLANKS                                         BUG6534
135100200529     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
135200200529     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
135300200529      *                                                                                      BUG6534
135400200529     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
135500200529     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
135600200529     C                   MOVEL     'D'           LONDEP                                      BUG6534
135700200529     C                   ELSE                                                                BUG6534
135800200529     C                   MOVEL     'L'           LONDEP                                      BUG6534
135900200529     C                   ENDIF                                                               BUG6534
136000200529     C                   ENDIF                                                               BUG6534
136100200529                                                                                             BUG6534
136200200529      ** If Principal Decrease of Deposit Taken or Early Maturity of Deposit Taken           BUG6534
136300200529      ** or Principal Increase of Deposit Placed or Base Rate or Capitalise Interest         BUG6534
136400200529      ** or Spread Change.                                                                   BUG6534
136500200529                                                                                             BUG6534
136600200529     C     DDMTYP        IFEQ      'PD'                                                      BUG6534
136700200529     C     LONDEP        ANDEQ     'D'                                                       BUG6534
136800200529     C     DDMTYP        OREQ      'EM'                                                      BUG6534
136900200529     C*****LONDEP        ANDEQ     'D'                                               BUG6534  249910
137000200529     C     DDPENP        ANDEQ     'P'                                                        249910
137100200529     C     DDMTYP        OREQ      'PI'                                                      BUG6534
137200200529     C     LONDEP        ANDEQ     'L'                                                       BUG6534
137300200529     C     DDMTYP        OREQ      'BC'                                                      BUG6534
137400200529     C     DDMTYP        OREQ      'CI'                                                      BUG6534
137500200529     C     DDMTYP        OREQ      'SC'                                                      BUG6534
137600200529      *                                                                                      BUG6534
137700200529     C                   CLEAR                   InRecSttmt                                  BUG6534
137800200529     C                   MOVEL     '00'          DDRSTM                                      BUG6534
137900200529     C     CDL051        IFEQ      'Y'                                                        CDL051
138000200529     C                   EVAL      ##PREC = 'Y'                                               CDL051
138100200529     C                   ENDIF                                                                CDL051
138200200529      *                                                                                      BUG6534
138300200529      ** If Principal Decrease of Deposit Placed or Early Maturity of Deposit Placed         BUG6534
138400200529      ** or Principal Increase of Deposit Taken or Base Rate or Capitalise Interest          BUG6534
138500200529      ** or Spread Change.                                                                   BUG6534
138600200529      **                                                                                     BUG6534
138700200529     C                   ELSE                                                                BUG6534
138800200529      *                                                                                      BUG6534
138900200529     C     DDMTYP        IFEQ      'PD'                                                      BUG6534
139000200529     C     LONDEP        ANDEQ     'L'                                                       BUG6534
139100200529     C     DDMTYP        OREQ      'EM'                                                      BUG6534
139200200529     C*****LONDEP        ANDEQ     'L'                                               BUG6534  249910
139300200529     C     DDPENP        ANDEQ     'R'                                                        249910
139400200529     C     DDMTYP        OREQ      'PI'                                                      BUG6534
139500200529     C     LONDEP        ANDEQ     'D'                                                       BUG6534
139600200529     C     DDMTYP        OREQ      'BC'                                                      BUG6534
139700200529     C     DDMTYP        OREQ      'CI'                                                      BUG6534
139800200529     C     DDMTYP        OREQ      'SC'                                                      BUG6534
139900200529      *                                                                                      BUG6534
140000200529     C                   CLEAR                   InPaySttmt                                  BUG6534
140100200529     C                   MOVEL     '00'          DDPSTM                                      BUG6534
140200200529     C     CDL051        IFEQ      'Y'                                                        CDL051
140300200529     C                   EVAL      ##PPAY = 'Y'                                               CDL051
140400200529     C                   ENDIF                                                                CDL051
140500200529                                                                                             BUG6534
140600200529     C                   ENDIF                                                               BUG6534
140700200529     C                   ENDIF                                                               BUG6534
140800200529      *                                                                                      BUG6534
140900200529     C                   RESET                   ReturnCode
141000200529     C                   CALLB     'ZASETINVAL'
141100200529
141200200529      ** Return Code
141300200529     C                   PARM                    ReturnCode
141400200529      ** Following parameters are output to called module
141500200529      ** Calling function type
141600200529     C                   PARM                    DEAM
141700200529      ** Transaction Fields
141800200529      ** Payment currency (or deal currency if only one currency on deal)
141900200529     C                   PARM                    DDCCY
142000200529      ** Receive currency (or deal currency if only one currency on deal)
142100200529     C                   PARM                    DDCCY
142200200529      ** Customer (shortname or number)
142300200529     C                   PARM                    DDCsnm
142400200529      ** Deal type
142500200529     C                   PARM                    DDMtyp
142600200529      ** Federal Funds Ind.
142700200529     C                   PARM                    Blank1
142800200529      ** Booking Branch
142900200529     C*******************PARM                    Blank3                              BUG4907
143000200529     C*******************PARM      IGBRCA        PBRCA             3                 BUG4907 BUG4963
143100200529     C                   PARM                    PBokBr                                      BUG4963
143200200529      ** Receipt Date
143300200529     C                   PARM                    RecDat
143400200529      ** Payment Date
143500200529     C                   PARM                    Paydat
143600200529      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
143700200529     C                   PARM                    InPaySttmt
143800200529     C                   PARM                    InRecSttmt
143900200529     C                   PARM                    InFRASttmt
144000200529      * Action Code
144100200529     C                   PARM                    DDACTN
144200200529      * Protect Payment Field
144300200529     C                   PARM                    ##PPAY            1
144400200529      * Protect Receipt Field
144500200529     C                   PARM                    ##PREC            1
144600200529
144700200529      ** Following parameters are returned by called module
144800200529      ** Payment Instruction OK flag
144900200529     C                   PARM                    OKPayInsDS
145000200529      ** Receive Instruction OK flag
145100200529     C                   PARM                    OKRecInsDS
145200200529      ** FRA/IRS Instruction OK flag
145300200529     C                   PARM                    OKFRAInsDS
145400200529      * Error fields/message IDs (arrays) from/to caller
145500200529     C                   PARM                    FldNameArr
145600200529     C                   PARM                    MsgIDArr
145700200529      * Array index (3P0) from/to caller
145800200529     C                   PARM                    Idx
145900200529
146000200529      ** Warning Messages
146100200529     C                   PARM                    WFldNamArr
146200200529     C                   PARM                    WMsgIdArr
146300200529     C                   PARM                    WMsgDtaArr
146400200529     C                   PARM                    WIdx
146500200529      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
146600200529     C                   PARM                    DBPaySttmt
146700200529     C                   PARM                    DBRecSttmt
146800200529     C                   PARM                    DBFRASttmt
146900200529      ** Extra Input
147000200529      ** Action Code used
147100200529     C                   PARM      DDACTN        ##ACTN            1
147200200529      ** Validation Iteration
147300200529     C                   PARM      '1ST'         ##ValIter         3
147400200529      *                                                                                     MD039547
147500200529      ** Call account referred validation.                                                  MD039547
147600200529      *                                                                                     MD039547
147700200529     C                   CALL      'ZASETINVL2'                                             MD039547
147800200529     C                   PARM                    ReturnCode                                 MD039547
147900200529     C                   PARM                    DEAM                                       MD039547
148000200529     C                   PARM                    DDCCY                                      MD039547
148100200529     C                   PARM                    DDCCY                                      MD039547
148200200529     C                   PARM                    DDCsnm                                     MD039547
148300200529     C                   PARM                    PBokBr                                     MD039547
148400200529     C                   PARM                    InPaySttmt                                 MD039547
148500200529     C                   PARM                    InRecSttmt                                 MD039547
148600200529     C                   PARM                    DDACTN                                     MD039547
148700200529     C                   PARM                    ##PPAY                                     MD039547
148800200529     C                   PARM                    ##PREC                                     MD039547
148900200529     C                   PARM                    OKPayInsDS                                 MD039547
149000200529     C                   PARM                    OKRecInsDS                                 MD039547
149100200529     C                   PARM                    FldNameArr                                 MD039547
149200200529     C                   PARM                    MsgIDArr                                   MD039547
149300200529     C                   PARM                    Idx                                        MD039547
149400200529     C                   PARM                    WFldNamArr                                 MD039547
149500200529     C                   PARM                    WMsgIdArr                                  MD039547
149600200529     C                   PARM                    WMsgDtaArr                                 MD039547
149700200529     C                   PARM                    WIdx                                       MD039547
149800200529
149900200529     C     ValSetExit    TAG
150000200529
150100200529     C                   ENDSR
150200200529      *****************************************************************
150300200529      /EJECT
150400200529      *****************************************************************
150500200529      *                                                               *
150600200529      * ValdateAmd - Routine to check whether the fields amended      *
150700200529      *    are amendable.                                             *
150800200529      *                                                               *
150900200529      *****************************************************************
151000200529
151100200529     C     ValdateAmd    BEGSR
151200200529
151300200529      ** This subroutine calls a procedure which checks whether it
151400200529      ** was valid to amend any of the fields which have been
151500200529      ** changed.  Some are never amendable and some depend upon ICD
151600200529      ** settings as to whether they are amendable.
151700200529
151800200529      ** To determine what fields have changed, the current fields
151900200529      ** on file must be converted to a 'screen' format.
152000200529
152100200529      ** These fields are then compared with the fields on the input
152200200529      ** transaction.
152300200529
152400200529      ** Any errors detected by the called procedure take precedence
152500200529      ** over any errors found during the validation of the complete
152600200529      ** transaction.  The errors from the called procedure are kept
152700200529      ** separately and, if any are found, these errors will REPLACE
152800200529      ** the normal validation errors.
152900200529
153000200529      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
153100200529
153200200529     C                   RESET                   ReturnCode
153300200529     C                   CALLB     'MMDEAMCVT'
153400200529
153500200529      * INPUTS
153600200529      * Return Code
153700200529     C                   PARM                    ReturnCode
153800200529      * (Current) Deal in file format
153900200529     C                   PARM                    DealFilfmt
154000200529
154100200529      * OUTPUTS
154200200529      * (Current) Deal in screen format
154300200529     C                   PARM                    DealScnfmt
154400200529      * Deal Status
154500200529     C                   PARM                    DDSTS            24
154600200529
154700200529      ** AMEND CHECKING
154800200529     C                   RESET                   ReturnCode
154900200529     C                   CALLB     'MMDEAMAMD'
155000200529
155100200529      * INPUTS
155200200529      * Return Code
155300200529     C                   PARM                    ReturnCode
155400200529      * New Deal in Screen Format (Incoming Transaction)
155500200529     C                   PARM                    TranIn
155600200529      * (Current) Deal in Screen Format
155700200529     C                   PARM                    DealScnfmt
155800200529      * (Current) Deal in file format
155900200529     C                   PARM                    DealFilfmt
156000200529
156100200529      * OUTPUTS
156200200529      * Field OK flags (DS) from/to caller
156300200529     C                   PARM                    OKFlagsDS
156400200529      * Error fields/message IDs/message data (arrays) from/to caller
156500200529     C                   PARM                    AmFldNamAr
156600200529     C                   PARM                    AmMsgIdArr
156700200529     C                   PARM                    AmMsgDtaAr
156800200529      * Array index (3P0) from/to caller
156900200529     C                   PARM                    AmIdx
157000200529      * Amendments OK
157100200529     C                   PARM                    AmendOk           1
157200200529      * Reset of Fields in Error Required (Y/N)
157300200529     C                   PARM      'Y'           ResetErrs         1                          CDL038
157400200529     C*******************PARM      'N'           ResetErrs         1                          CDL038
157500200529
157600200529      ** If any errors overwrite previous error information
157700200529
157800200529     C                   IF        AmIdx <> 0
157900200529     C                   MOVEA     AmMsgIdArr    MsgidArr
158000200529     C                   MOVEA     AmFldNamAr    FldNameArr
158100200529     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
158200200529     C                   Z-ADD     AmIdx         Idx
158300200529     C                   ENDIF
158400200529
158500200529     C                   ENDSR
158600200529      *****************************************************************
158700200529      /EJECT
158800200529      *****************************************************************
158900200529     C     WriteToDB     BEGSR
159000200529
159100200529     C     Idx           IFEQ      0
159200200529     C                   EXSR      SETUPVALID
159300200529     C                   EXSR      UpdateDB
159400200529     C                   ENDIF
159500200529
159600200529     C                   ENDSR
159700200529      *****************************************************************
159800200529      /EJECT
159900200529      *****************************************************************
160000200529      *                                                               *
160100200529      * RESETCYCLE- Reset error information that is gradually         *
160200200529      *    updated during each run of this program                    *
160300200529      *                                                               *
160400200529      *****************************************************************
160500200529
160600200529     C     RESETCYCLE    BEGSR
160700200529
160800200529     C                   RESET                   FldNameArr
160900200529     C                   RESET                   MsgIDArr
161000200529     C                   RESET                   MsgDtaArr
161100200529     C                   RESET                   Idx
161200200529
161300200529     C                   RESET                   WFldNamArr
161400200529     C                   RESET                   WMsgIDArr
161500200529     C                   RESET                   WMsgDtaArr
161600200529     C                   RESET                   WIdx
161700200529
161800200529     C                   RESET                   AmFldNamAr
161900200529     C                   RESET                   AmMsgIDArr
162000200529     C                   RESET                   AmMsgDtaAr
162100200529     C                   RESET                   AmIdx
162200200529
162300200529     C                   RESET                   FldNoArr
162400200529
162500200529     C                   RESET                   OKFlagsDS
162600200529
162700200529     C                   RESET                   AmendOK
162800200529
162900200529     C                   RESET                   OKPayInsDS
163000200529     C                   RESET                   OKRecInsDS
163100200529     C                   RESET                   OKFRAInsDS
163200200529
163300200529     C                   RESET                   PayDat
163400200529     C                   RESET                   RecDat
163500200529
163600200529     C                   CLEAR                   ValidDeal
163700200529      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
163800200529      **  there are long alpha fileds overlapping these which cause the
163900200529      **  CLEAR to put blanks in the numeric fields
164000200529     C                   Z-ADD     *ZERO         IGRSTM
164100200529     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
164200200529     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
164300200529     C                   EVAL      IGROBN = *BLANKS                                           CSD027
164400200529     C                   EVAL      IGROCN = *BLANKS                                           CSD027
164500200529     C                   Z-ADD     *ZERO         IGPSTM
164600200529     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
164700200529     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
164800200529     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
164900200529     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
165000200529
165100200529      ** Have to clear the settlement data structure, or the packed numeric
165200200529      ** fields are not initialised correctly.
165300200529     C                   CLEAR                   DBPaySttmt
165400200529     C                   CLEAR                   DBRecSttmt
165500200529     C                   CLEAR                   DBFRASttmt
165600200529
165700200529     C                   ENDSR
165800200529      *****************************************************************
165900200529      /EJECT
166000200529      *****************************************************************
166100200529      *                                                               *
166200200529      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
166300200529      *              for Inserts.                                     *
166400200529      *                                                               *
166500200529      *****************************************************************
166600200529
166700200529     C     SETUPDASEQ    BEGSR
166800200529
166900200529      **  Load deal number into numeric field passed to MM0085
167000200529
167100200529     C                   MOVE      DDDLNO        DealNo            6 0
167200200529
167300200529      ** Format Value Date
167400200529
167500200529     C     DDVDAT        IFNE      *BLANKS                                      B1
167600200529      *
167700200529      ** Load value date to numeric keyfield,in YYYYMMDD format
167800200529      *
167900200529     C                   MOVE      DDVDAT        @VDAT
168000200529
168100200529     C                   Z-ADD     0             @PDAT                          **2
168200200529     C                   MOVE      @DSPY         @PYEAR                         **2
168300200529     C     BJDFIN        IFEQ      'D'
168400200529     C                   MOVE      @DSPD         @PDDD                          **2
168500200529     C                   ELSE
168600200529     C                   MOVE      @DSPD         @PDMM
168700200529     C                   END
168800200529     C     BJDFIN        IFEQ      'D'
168900200529     C                   MOVE      @DSPM         @PDMM                          **2
169000200529     C                   ELSE
169100200529     C                   MOVE      @DSPM         @PDDD
169200200529     C                   END
169300200529      *
169400200529      ** Century
169500200529     C     @PYEAR        IFGE      72                                           B**3
169600200529     C     @PDYY         ADD       1900          @PDYY                          ***3
169700200529     C                   ELSE                                                   ***3
169800200529     C     @PDYY         ADD       2000          @PDYY                          ***3
169900200529     C                   END                                                    E**3
170000200529     C                   ELSE                                                   X1
170100200529     C                   Z-ADD     0             @PDAT                          *1
170200200529     C                   END                                                    E1
170300200529
170400200529     C                   Z-ADD     @PDAT         ValueDate         8 0
170500200529
170600200529      ***Bypass*generation*of*Seq*number*for*Insert*if*CSC024*is                       CSC024 CSC054
170700200529      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
170800200529      ** Bypass generation of Seq number for Insert if CSC054 is                              CSC054
170900200529      ** switched on and running on PEA system.                                               CSC054
171000200529                                                                                              CSC024
171100200529     C**********         IF        CSC024 <> 'Y'  OR                                   CSC024 CSC054
171200200529     C**********                   WOMEInd <> 'Y' OR                                   CSC024 CSC054
171300200529     C                   IF        CSC054 <> 'Y'  OR                                          CSC054
171400200529     C                             WPEAInd <> 'Y' OR                                          CSC054
171500200529     C                             DDDS38 = *BLANKS                                           CSC024
171600200529                                                                                              CSC024
171700200529      ** Generate DEAM Sequence Number
171800200529     C                   CALLB     'MM0085'
171900200529     C                   PARM      *BLANK        Term              1
172000200529     C                   PARM                    DealNo
172100200529     C                   PARM                    ValueDate
172200200529     C                   PARM                    SeqNoPack         3 0
172300200529
172400200529     C     Term          IFNE      *BLANK
172500200529     C                   MOVE      'N'           DDDlnoOK
172600200529     C                   ADD       1             Idx
172700200529     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
172800200529     C                   EVAL      MsgIDArr(Idx) = 'MMM0146'
172900200529     C                   ELSE
173000200529     C                   Z-ADD     SeqNoPack     IGDS38
173100200529     C                   MOVE      SeqNoPack     DDDS38
173200200529     C                   ENDIF
173300200529                                                                                              CSC024
173400200529     C                   ELSE                                                                 CSC024
173500200529     C                   MOVEL     DDDS38        IGDS38                                       CSC024
173600200529     C                   ENDIF                                                                CSC024
173700200529
173800200529     C                   ENDSR
173900200529      *****************************************************************
174000200529      /EJECT
174100200529      *****************************************************************
174200200529      *                                                               *
174300200529      * SETUPVALID - Set up additional fields that are needed on the  *
174400200529      *    Valid file record.                                         *
174500200529      *                                                               *
174600200529      *****************************************************************
174700200529
174800200529     C     SETUPVALID    BEGSR
174900200529
175000200529
175100200529      * For Inserts and Amends, put the Settlement Instructions (input or
175200200529      *  defaulted) into the Valid file record.
175300200529      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
175400200529      *  in contiguous areas, which must be placed into the correct parts
175500200529      *  of the Valid file record
175600200529     C                   IF        DDACTN = 'I'
175700200529     C                             OR (DDACTN = 'A')
175800200529     C**********         MOVEL     DBPaySttmt    MMVDPayIns                                   CGL029
175900200529     C**********         MOVEL     DBRecSttmt    MMVDRecIns                                   CGL029
176000200529     C*******************MOVEL     FLREC         MMVDRecIns                            CGL029 NAD002
176100200529     C*******************MOVEL     FLRONS        MMVDRecInsEx                          CGL029 NAD002
176200200529     C                   MOVEL     FLRSTM        IGRSTM                                       CGL029
176300200529     C                   MOVEL     FLRONS        IGRONS                                       NAD002
176400200529     C                   MOVEL     FLREC2        MMVDRecIns                                   NAD002
176500200529     C*******************MOVEL     FLPAY         MMVDPayIns                            CGL029 NAD002
176600200529     C*******************MOVEL     FLPONS        MMVDPayInsEx                          CGL029 NAD002
176700200529     C                   MOVEL     FLPSTM        IGPSTM                                       CGL029
176800200529     C                   MOVEL     FLPONS        IGPONS                                       NAD002
176900200529     C                   MOVEL     FLPAY2        MMVDPayIns                                   NAD002
177000200529     C                   MOVEL     FLRBB1        IGRBB1                                       CDL094
177100200529     C                   MOVEL     FLRBB2        IGRBB2                                       CDL094
177200200529     C                   MOVEL     FLRBB3        IGRBB3                                       CDL094
177300200529     C                   MOVEL     FLRBB4        IGRBB4                                       CDL094
177400200529     C                   MOVEL     FLRBB5        IGRBB5                                       CDL094
177500200529     C                   MOVEL     FLRBB6        IGRBB6                                       CDL094
177600200529     C     FLPOBR        IFNE      *BLANKS
177700200529     C                   MOVE      FLPOBR        IGOSBR
177800200529     C                   ELSE
177900200529     C                   MOVE      FLROBR        IGOSBR
178000200529     C                   END
178100200529     C                   MOVE      FLCVMR        IGCVMR
178200200529     C                   MOVE      FLPSCY        IGSTCY
178300200529     C                   MOVE      FLIC72        IGIC72
178400200529     C                   ENDIF
178500200529
178600200529
178700200529      * For Deletes & Authorises, put the complete (pre-existing) deal
178800200529      *  into the Valid file record
178900200529     C                   IF           DDACTN = 'D'
179000200529     C                             OR DDACTN = 'X'
179100200529     C                   MOVE      DealFilFmt    ValidDeal
179200200529     C                   ENDIF
179300200529
179400200529      * Set Valid file field(s) that are needed for all Action Codes
179500200529     C                   EVAL      IGLACT = DDACTN
179600200529
179700200529      * Include Header fields that need to be o/p to the Valid file
179800200529
179900200529     C                   IF        DDACTN = 'I'
180000200529     C                   MOVE      DDDLNO        IGDA38
180100200529     C                   ENDIF
180200200529
180300200529      * Do not override header fields from existing transaction.                              244537
180400200529     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
180500200529     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
180600200529                                                                                              244537
180700200529     C                   EVAL      IGFRNT = APFOTranID
180800200529     C                   EVAL      IGAFRT = APFOAsocID
180900200529     C                   EVAL      IGREPA = APRprLocn
181000200529     C**********         IF        DDFOID <> *BLANKS                                239400 AR971184A
181100200529     C**********         EVAL      IGFRNT = DDFOID                                  239400 AR971184A
181200200529     C**********         END                                                        239400 AR971184A
181300200529     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
181400200529                                                                                              244537
181500200529     C                   ENDIF                                                                244537
181600200529
181700200529      * Automatic Authorisation flag
181800200529     C                   IF        CAP051 = 'Y'
181900200529     C                   EVAL      IGAUTH = IF_AUTH
182000200529     C                   ENDIF
182100200529
182200200529     C                   EVAL      TranStatus = 'S'
182300200529
182400200529      * Restore Timestamp from the original record                                           BUG4146
182500200529     C                   IF        DDACTN <> 'I'                                             BUG4146
182600200529     C**************               AND DDACTN <> 'X'                                 BUG4808 BUG4808
182700200529     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
182800200529     C                   MOVEL     @TimeStamp    IGTMESTMP                                   BUG4146
182900200529     C                   ENDIF                                                               BUG4146
183000200529                                                                                              CRE073
183100200529     C                   IF        CRE073 = 'Y'                                               CRE073
183200200529     C                   MOVEL     IGCNSP        HKCNSP                                       CRE073
183300200529     C                   MOVEL     IGRDMT        HKRDMT                                       CRE073
183400200529     C                   MOVEL     IGRDFD        HKRDFD                                       CRE073
183500200529     C                   ENDIF                                                                CRE073
183600200529
183700200529      /COPY WNCPYSRC,MMDEAMC018
183800200529
183900200529     C                   ENDSR
184000200529      *****************************************************************
184100200529      /EJECT
184200200529      *****************************************************************
184300200529      *                                                               *
184400200529      * UPDATEDB - Update Database                                    *
184500200529      *                                                               *
184600200529      *****************************************************************
184700200529
184800200529     C     UPDATEDB      BEGSR
184900200529
185000200529      * For inserts generate Deal Amendment Sequence Number
185100200529      *
185200200529     C                   IF        DDACTN = 'I'
185300200529     C                   EXSR      SETUPDASEQ
185400200529     C                   ENDIF
185500200529      *
185600200529      * UPDATE VALID DEAM: DEAL NUMBER
185700200529      *
185800200529      * UPDATE VALID DEAM: LAST ACTION CODE
185900200529      *
186000200529      * MONEY MARKET UPDATES
186100200529      *
186200200529     C                   CALLB     'MMDEAMUPM'
186300200529     C                   PARM      *BLANK        @RTCD             7
186400200529     C                   PARM                    ValidDeal
186500200529      *
186600200529      * DEAMS UPDATES
186700200529      *
186800200529     C     @RTCD         IFEQ      *BLANK
186900200529     C                   CALLB     'MMDEAMUPD'
187000200529     C                   PARM                    @RTCD
187100200529     C                   PARM                    ValidDeal
187200200529     C                   END
187300200529      *
187400200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
187500200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
187600200529      *
187700200529     C     @RTCD         IFNE      *BLANK
187800200529     C     @RTCD         ANDNE     '*RECUPD'
187900200529     C                   MOVEL     '0'           APIRetc
188000200529     C                   If        (CSC022 = 'N')                                             CSC022
188100200529     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
188200200529     C                   ROLBK
188300200529     C                   EndIf                                                                CSC022
188400200529     C                   EXSR      *PSSR
188500200529     C                   ELSE
188600200529     C                   If        (CSC022 = 'N')                                             CSC022
188700200529     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
188800200529     C                   COMMIT
188900200529     C                   EndIf                                                                CSC022
189000200529     C                   END
189100200529      *
189200200529      ** If update not done due to record being updated by another
189300200529      ** workstation send message to screen.
189400200529
189500200529     C     @RTCD         IFEQ      '*RECUPD'
189600200529
189700200529     C                   MOVEL     '*ANY'        FldNameArr(1)
189800200529     C                   MOVEL     'MMM1067'     MsgIdArr(1)
189900200529
190000200529     C                   END
190100200529
190200200529
190300200529     C                   ENDSR
190400200529      *****************************************************************
190500200529      /EJECT
190600200529     C/COPY ZACPYSRC,PSSR_ILE
190700200529      ********************************************************************
190800200529      /EJECT
190900200529      *****************************************************************
191000200529      *                                                               *                       CER043
191100200529      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
191200200529      *                                                               *                       CER043
191300200529      *  Called by: MAIN Processing                                   *                       CER043
191400200529      *                                                               *                       CER043
191500200529      *  Calls: SrRtvCust                                             *                       CER043
191600200529      *                                                               *                       CER043
191700200529      *****************************************************************                       CER043
191800200529      *                                                                                       CER043
191900200529     C     SrPopCust     BEGSR                                                                CER043
192000200529      *                                                                                       CER043
192100200529     C                   CLEAR                   TranInCust                                   CER043
192200200529      *                                                                                       CER043
192300200529      ** Retrieve Customer Details                                                            CER043
192400200529     C                   IF        DDCSNM <> *BLANKS AND                                      CER043
192500200529     C                             DDCsnmOK = 'Y'                                             CER043
192600200529     C                   EVAL      PCNum = DDCSNM                                             CER043
192700200529      *                                                                                       CER043
192800200529     C                   EXSR      SrRtvCust                                                  CER043
192900200529     C                   IF        PRtcd = *BLANKS                                            CER043
193000200529     C                   EVAL      DDCSSN = BBCSSN                                            CER043
193100200529     C                   EVAL      DDCRNM = BBCRNM                                            CER043
193200200529     C                   EVAL      DDCRTN = BBCRTN                                            CER043
193300200529     C                   ENDIF                                                                CER043
193400200529      *                                                                                       CER043
193500200529     C                   ENDIF                                                                CER043
193600200529      *                                                                                       CER043
193700200529     C                   ENDSR                                                                CER043
193800200529      *****************************************************************                       CER043
193900200529      /EJECT                                                                                  CER043
194000200529      *****************************************************************                       CER043
194100200529      *                                                               *                       CER043
194200200529      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
194300200529      *                                                               *                       CER043
194400200529      *  Called by: SrPopCust                                         *                       CER043
194500200529      *                                                               *                       CER043
194600200529      *  Calls: None                                                  *                       CER043
194700200529      *                                                               *                       CER043
194800200529      *****************************************************************                       CER043
194900200529     C     SrRtvCust     BEGSR                                                                CER043
195000200529      *                                                                                       CER043
195100200529      ** Call AOCUSTR0 to get Customer Details                                                CER043
195200200529     C                   CALLB     'AOCUSTR0'                                                 CER043
195300200529     C                   PARM      *BLANKS       PRtcd                                        CER043
195400200529     C                   PARM      '*KEY   '     POptn                                        CER043
195500200529     C                   PARM                    PCNum                                        CER043
195600200529     C                   PARM      *BLANKS       PKey7                                        CER043
195700200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
195800200529      *                                                                                       CER043
195900200529     C                   ENDSR                                                                CER043
196000200529      *****************************************************************                       CER043
196100200529      /EJECT                                                                                  CER043
196200200529      *****************************************************************                       CER043
196300200529      *                                                               *
196400200529      * *INZSR - Program Initialisation routine                       *
196500200529      *                                                               *
196600200529      *****************************************************************
196700200529
196800200529     C     *INZSR        BEGSR
196900200529
197000200529     C     *ENTRY        PLIST
197100200529      * Common header information (DS) from source system
197200200529     C                   PARM                    HeadIn
197300200529      * Transaction information in a single large field from source system
197400200529     C                   PARM                    Trans500
197500200529     C                   PARM                    Trans500C                                    CER043
197600200529      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
197700200529     C                   PARM                    InPaySttmt
197800200529     C                   PARM                    InRecSttmt
197900200529     C                   PARM                    InFRASttmt
198000200529     C                   PARM                    InfData500
198100200529     C                   PARM                    ExtData500
198200200529     C                   PARM                    FldNameArr
198300200529     C                   PARM                    MsgIDArr
198400200529     C                   PARM                    MsgDtaArr
198500200529     C                   PARM                    WFldNamArr
198600200529     C                   PARM                    WMsgIDArr
198700200529     C                   PARM                    WMsgDtaArr
198800200529     C                   PARM                    MsgFArray
198900200529     C                   PARM                    UpdateYN          1
199000200529     C                   PARM                    Buffer         6000
199100200529     C                   PARM                    APIRetc           1
199200200529     C                   PARM                    @TimeStamp       26                         BUG4146
199300200529     C                   PARM                    LONDEP            1                         BUG6534
199400200529     C                   PARM                    DDFOID           20                          239400
199500200529     C                   PARM                    @ACTRV            1                          260173
199600200529
199700200529      * Set up the name of the primary and secondary message files from
199800200529      * which the message handler will get the messages
199900200529     C                   EVAL      MsgFArray(1) = 'DRSMM'
200000200529     C                   EVAL      MsgFArray(2) = 'SDUSRMSG'                                  CRE073
200100200529
200200200529      *  Hook to enable non-core message files to be included
200300200529     C/COPY WNCPYSRC,MMDEAMM01
200400200529
200500200529      *  Set up the Module ID, used to make the Transaction number unique
200600200529     C                   EVAL      ModuleID = 'DL'
200700200529
200800200529      ** Access Bank details via access program
200900200529      *  (database error handling done in access program)
201000200529     C                   CALLB     'AOBANKR0'
201100200529     C                   PARM      '*DBERR '     @RTCD             7
201200200529     C                   PARM      '*FIRST '     @OPTN             7
201300200529     C     SDBANK        PARM      SDBANK        DSFDY
201400200529
201500200529      ** Access API ICD via access program
201600200529      *  (database error handling done in access program)
201700200529     C                   CALLB     'AOAPIR0'
201800200529     C                   PARM      '*DBERR '     @RTCD             7
201900200529     C                   PARM      '*FIRST '     @OPTN             7
202000200529     C     SDAPI         PARM      SDAPI         DSFDY
202100200529
202200200529     C                   CALLB     'MMFIDINIT'                                              BUG10727
202300200529     C                   PARM      *BLANKS       WRTCD             7                        BUG10727
202400200529
202500200529      *
202600200529      ** Access SAR details file to determine if
202700200529      ** Automatic Authorisation (MM Part) is installed
202800200529      *
202900200529     C                   MOVEL     'N'           CAP051            1
203000200529     C                   CALL      'AOSARDR0'
203100200529     C                   PARM      *BLANKS       @RTCD
203200200529     C                   PARM      '*VERIFY'     @OPTN
203300200529     C                   PARM      'CAP051'      @SARD
203400200529     C     SCSARD        PARM      SCSARD        DSFDY
203500200529      *
203600200529     C     @RTCD         IFEQ      *BLANK
203700200529     C                   MOVEL     'Y'           CAP051
203800200529     C                   ENDIF
203900200529
204000200529      ** Access SAR details file to determine if Commitment Control                           CSC022
204100200529      ** Changes is switched on.                                                              CSC022
204200200529     C                   CallB     'AOSARDR0'                                                 CSC022
204300200529     C                   Parm      *BLANKS       @RTCD                                        CSC022
204400200529     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
204500200529     C                   Parm      'CSC022'      @SARD                                        CSC022
204600200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
204700200529                                                                                              CSC022
204800200529     C                   If        @RTCD = *BLANKS                                            CSC022
204900200529      *                                                                                       CSC022
205000200529     C                   Eval      CSC022 = 'Y'                                               CSC022
205100200529     C                   In        SCCMTJOB                                                   CSC022
205200200529     C                   If        ComitNum > 0                                               CSC022
205300200529      ** Check if Current Job exists in the Commitment Job Names                              CSC022
205400200529      ** Data Area.                                                                           CSC022
205500200529     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
205600200529     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
205700200529     C                   If        *IN20                                                      CSC022
205800200529     C                   Eval      wCommitSkip = 'Y'                                          CSC022
205900200529     C                   EndIf                                                                CSC022
206000200529     C                   EndIf                                                                CSC022
206100200529      *                                                                                       CSC022
206200200529     C                   Else                                                                 CSC022
206300200529      ** Database error                                                                       CSC022
206400200529     C                   If        @RTCD <> '*NRF'                                            CSC022
206500200529     C     *LOCK         In        LDA                                                        CSC022
206600200529     C                   Eval      DBKey = 'CSC022'                                           CSC022
206700200529     C                   Eval      DBPgm = 'MMDEAMVU'                                         CSC022
206800200529     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
206900200529     C                   Eval      DBase = 900                                                CSC022
207000200529     C                   Out       LDA                                                        CSC022
207100200529     C                   ExSr      *PSSR                                                      CSC022
207200200529     C                   EndIf                                                                CSC022
207300200529      *                                                                                       CSC022
207400200529     C                   EndIf                                                                CSC022
207500200529                                                                                              CSC024
207600200529      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
207700200529                                                                                              CSC024
207800200529     C                   CALLB     'AOSARDR0'                                                 CSC024
207900200529     C                   PARM      *BLANKS       @RTCD                                        CSC024
208000200529     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
208100200529     C                   PARM      'CSC024'      @SARD                                        CSC024
208200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
208300200529                                                                                              CSC024
208400200529     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
208500200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
208600200529     C                   EVAL      DBKey  = 'CSC024'                                          CSC024
208700200529     C                   EVAL      DBase  = 3                                                 CSC024
208800200529     C                   EXSR      *PSSR                                                      CSC024
208900200529     C                   ENDIF                                                                CSC024
209000200529                                                                                              CSC024
209100200529     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
209200200529     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
209300200529     C                   EVAL      CSC054 = 'N'                                               CSC054
209400200529     C                   EVAL      WPEAInd = 'N'                                              CSC054
209500200529                                                                                              CSC024
209600200529     C                   IF        @RTCD = *BLANKS                                            CSC024
209700200529     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
209800200529     C                   EVAL      CSC054 = 'Y'                                               CSC054
209900200529                                                                                              CSC024
210000200529      ** Access System values                                                                 CSC024
210100200529                                                                                              CSC024
210200200529     C                   CALL      'AOSVALR0'                                                 CSC024
210300200529     C                   PARM      *BLANKS       PRetCode                                     CSC024
210400200529     C                   PARM      PSysVal1      P@OP01                                       CSC024
210500200529     C                   PARM      *BLANKS       P@VL01                                       CSC024
210600200529     C                   PARM      *BLANKS       P@OP02                                       CSC024
210700200529     C                   PARM      *BLANKS       P@VL02                                       CSC024
210800200529     C                   PARM      *BLANKS       P@OP03                                       CSC024
210900200529     C                   PARM      *BLANKS       P@VL03                                       CSC024
211000200529     C                   PARM      *BLANKS       P@OP04                                       CSC024
211100200529     C                   PARM      *BLANKS       P@VL04                                       CSC024
211200200529     C                   PARM      *BLANKS       P@OP05                                       CSC024
211300200529     C                   PARM      *BLANKS       P@VL05                                       CSC024
211400200529     C                   PARM      *BLANKS       P@OP06                                       CSC024
211500200529     C                   PARM      *BLANKS       P@VL06                                       CSC024
211600200529     C                   PARM      *BLANKS       P@OP07                                       CSC024
211700200529     C                   PARM      *BLANKS       P@VL07                                       CSC024
211800200529     C                   PARM      *BLANKS       P@OP08                                       CSC024
211900200529     C                   PARM      *BLANKS       P@VL08                                       CSC024
212000200529     C                   PARM      *BLANKS       P@OP09                                       CSC024
212100200529     C                   PARM      *BLANKS       P@VL09                                       CSC024
212200200529     C                   PARM      *BLANKS       P@OP10                                       CSC024
212300200529     C                   PARM      *BLANKS       P@VL10                                       CSC024
212400200529                                                                                              CSC024
212500200529     C                   IF        PRetCode  <> *BLANKS                                       CSC024
212600200529     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
212700200529     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
212800200529     C                   EVAL      DBase = 4                                                  CSC024
212900200529     C                   EXSR      *PSSR                                                      CSC024
213000200529     C                   ENDIF                                                                CSC024
213100200529     C                   IF        P@VL01 = 'Y'                                               CSC024
213200200529     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
213300200529     C                   EVAL      WPEAInd = 'Y'                                              CSC054
213400200529     C                   ENDIF                                                                CSC024
213500200529     C                   ENDIF                                                                CSC024
213600200529
213700200529      *                                                                                       CER043
213800200529      ** Check if CER043 is switched on                                                       CER043
213900200529                                                                                              CER043
214000200529     C                   CALL      'AOSARDR0'                                                 CER043
214100200529     C                   PARM      *BLANKS       @RTCD                                        CER043
214200200529     C                   PARM      '*VERIFY'     @OPTN                                        CER043
214300200529     C                   PARM      'CER043'      @SARD                                        CER043
214400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
214500200529                                                                                              CER043
214600200529     C                   IF        @RTCD = *BLANKS                                            CER043
214700200529     C                   EVAL      CER043 = 'Y'                                               CER043
214800200529     C                   ELSE                                                                 CER043
214900200529     C                   EVAL      CER043 = 'N'                                               CER043
215000200529                                                                                              CER043
215100200529     C                   IF        @RTCD <> '*NRF'                                            CER043
215200200529     C     *LOCK         IN        LDA                                                        CER043
215300200529     C                   EVAL      DBKEY = 'CER043'                                           CER043
215400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
215500200529     C                   EVAL      DBASE = 902                                                CER043
215600200529     C                   OUT       LDA                                                        CER043
215700200529     C                   EXSR      *PSSR                                                      CER043
215800200529     C                   ENDIF                                                                CER043
215900200529                                                                                              CER043
216000200529     C                   ENDIF                                                                CER043
216100200529                                                                                              CER043
216200200529      *                                                                                       CRE073
216300200529      ** Check if CRE073 is switched on                                                       CRE073
216400200529                                                                                              CRE073
216500200529     C                   CALL      'AOSARDR0'                                                 CRE073
216600200529     C                   PARM      *BLANKS       @RTCD                                        CRE073
216700200529     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
216800200529     C                   PARM      'CRE073'      @SARD                                        CRE073
216900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
217000200529                                                                                              CRE073
217100200529     C                   IF        @RTCD = *BLANKS                                            CRE073
217200200529     C                   EVAL      CRE073 = 'Y'                                               CRE073
217300200529     C                   ELSE                                                                 CRE073
217400200529     C                   EVAL      CRE073 = 'N'                                               CRE073
217500200529                                                                                              CRE073
217600200529     C                   IF        @RTCD <> '*NRF'                                            CRE073
217700200529     C     *LOCK         IN        LDA                                                        CRE073
217800200529     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
217900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
218000200529     C                   EVAL      DBASE = 903                                                CRE073
218100200529     C                   OUT       LDA                                                        CRE073
218200200529     C                   EXSR      *PSSR                                                      CRE073
218300200529     C                   ENDIF                                                                CRE073
218400200529                                                                                              CRE073
218500200529     C                   ENDIF                                                                CRE073
218600200529                                                                                              CRE073
218700200529      *                                                                                    AR1092035
218800200529      ** Check for CDL005 (Show Customer Shortname) is ON                                  AR1092035
218900200529      *                                                                                    AR1092035
219000200529     C                   CALL      'AOSARDR0'                                              AR1092035
219100200529     C                   PARM      *BLANKS       @RTCD                                     AR1092035
219200200529     C                   PARM      '*VERIFY'     @OPTN                                     AR1092035
219300200529     C                   PARM      'CDL005'      @SARD                                     AR1092035
219400200529     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1092035
219500200529      *                                                                                    AR1092035
219600200529     C     @RTCD         IFEQ      *BLANK                                                  AR1092035
219700200529     C                   MOVE      'Y'           CDL005            1                       AR1092035
219800200529     C                   ELSE                                                              AR1096000
219900200529     C                   EVAL      CDL005 = 'N'                                            AR1096000
220000200529     C**********         ENDIF                                                   AR1092035 AR1096000
220100200529      *                                                                                    AR1092035
220200200529     C                   IF        @RTCD <> '*NRF'                                         AR1092035
220300200529     C     *LOCK         IN        LDA                                                     AR1092035
220400200529     C                   EVAL      DBKEY = 'CDL005'                                        AR1092035
220500200529     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1092035
220600200529     C                   EVAL      DBASE = 903                                             AR1092035
220700200529     C                   OUT       LDA                                                     AR1092035
220800200529     C                   EXSR      *PSSR                                                   AR1092035
220900200529     C                   ENDIF                                                             AR1092035
221000200529                                                                                           AR1096000
221100200529     C                   ENDIF                                                             AR1096000
221200200529      *                                                                                     MD044400
221300200529      ** Check for CDL011 Expansion of Customer Number is ON                                MD044400
221400200529      *                                                                                     MD044400
221500200529     C                   CALL      'AOSARDR0'                                               MD044400
221600200529     C                   PARM      *BLANKS       @RTCD                                      MD044400
221700200529     C                   PARM      '*VERIFY'     @OPTN                                      MD044400
221800200529     C                   PARM      'CDL011'      @SARD                                      MD044400
221900200529     C     SCSARD        PARM      SCSARD        DSFDY                                      MD044400
222000200529      *                                                                                     MD044400
222100200529     C     @RTCD         IFEQ      *BLANK                                                   MD044400
222200200529     C                   MOVE      'Y'           CDL011                                     MD044400
222300200529     C                   ELSE                                                               MD044400
222400200529     C                   EVAL      CDL011 = 'N'                                             MD044400
222500200529      *                                                                                     MD044400
222600200529     C                   IF        @RTCD <> '*NRF'                                          MD044400
222700200529     C     *LOCK         IN        LDA                                                      MD044400
222800200529     C                   EVAL      DBKEY = 'CDL011'                                         MD044400
222900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD044400
223000200529     C                   EVAL      DBASE = 904                                              MD044400
223100200529     C                   OUT       LDA                                                      MD044400
223200200529     C                   EXSR      *PSSR                                                    MD044400
223300200529     C                   ENDIF                                                              MD044400
223400200529                                                                                            MD044400
223500200529     C                   ENDIF                                                              MD044400
223600200529      *                                                                                    AR1092035
223700200529      *                                                                                       CDL051
223800200529      ** Access SAR details file for CDL051                                                   CDL051
223900200529      *                                                                                       CDL051
224000200529     C                   CALL      'AOSARDR0'                                                 CDL051
224100200529     C                   PARM      *BLANKS       @RTCD                                        CDL051
224200200529     C                   PARM      '*VERIFY'     @OPTN                                        CDL051
224300200529     C                   PARM      'CDL051'      @SARD                                        CDL051
224400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL051
224500200529                                                                                              CDL051
224600200529     C                   IF        @RTCD = *BLANK                                             CDL051
224700200529     C                   MOVEL     'Y'           CDL051            1                          CDL051
224800200529     C                   ELSE                                                                 CDL051
224900200529     C                   MOVEL     'N'           CDL051                                       CDL051
225000200529      *                                                                                       CDL051
225100200529     C                   IF        @RTCD <> '*NRF'                                            CDL051
225200200529     C     *LOCK         IN        LDA                                                        CDL051
225300200529     C                   EVAL      DBKEY = 'CDL051'                                           CDL051
225400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL051
225500200529     C                   EVAL      DBASE = 905                                                CDL051
225600200529     C                   OUT       LDA                                                        CDL051
225700200529     C                   EXSR      *PSSR                                                      CDL051
225800200529     C                   ENDIF                                                                CDL051
225900200529      *                                                                                       CDL051
226000200529     C                   ENDIF                                                                CDL051
226100200529      *                                                                                       CDL051
226200200529     C                   ENDSR
226300200529      ********************************************************************
226400200529**  CPY@
226500200529(c) Finastra International Limited 2003
