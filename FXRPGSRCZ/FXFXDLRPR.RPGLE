000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Invalid FX deals repair')                     *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  FXFXDLRPR - INVALID FX DEALS REPAIR                          *
001100200528      *                                                               *
001200200528      *  Function:  This function allows invalid FX deals to be       *
001300200528      *             'repaired' and applied to the Midas database.     *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 251029             Date 22May20               *
001800200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200528      *                 MD047971           Date 16Oct17               *
002000200528      *                 CDL099             Date 06Oct17               *
002100200528      *                 MD036070           Date 19Oct15               *
002200200528      *                 CDL094             Date 11Jun14               *
002300200528      *                 CSD095             Date 08Apr14               *
002400200528      *                 AR990243           Date 14Jun12               *
002500200528      *                 CSW212             Date 03May12               *
002600200528      *                 CSF011A            Date 28Nov11               *
002700200528      *                 CER059             Date 19Jul10               *
002800200528      *                 CER043             Date 19May08               *
002900200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
003000200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003100200528      *                 256564             Date 17Sep08               *
003200200528      *                 247888             Date 18May07               *
003300200528      *                 246352             Date 13Mar07               *
003400200528      * Midas Plus 1.4 Base ------------------------------------------*
003500200528      *                 244036             Date 22Sep06               *
003600200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003700200528      *                 CDL049             Date 07Jul06               *
003800200528      *                 CSD027             Date 06May06               *
003900200528      *                 CLE031             Date 26Apr05               *
004000200528      *                 CDL038             Date 10May05               *
004100200528      *                 CFX114             Date 15Jun04               *
004200200528      *                 CPK018             Date 15Jun04               *
004300200528      *                 CDL018             Date 03Feb04               *
004400200528      *                 BG2562             Date 24Feb04               *
004500200528      *                 CSC022             Date 24Feb04               *
004600200528      *                 CGL029             Date 01Sep03               *
004700200528      *                 CDL010             Date 02Aug02               *
004800200528      *                 CAS004             Date 26Jun02               *
004900200528      * Midas Release 4.01.03 ----------------------------------------*
005000200528      * Midas Release 4.01.02 ----------------------------------------*
005100200528      *                 196952             Date 06May02               *
005200200528      *                 192916             Date 27Mar02               *
005300200528      * Midas Release 4.01 -------------------------------------------*
005400200528      *                 CAS001             Date 23Nov01               *
005500200528      *                 CSC011             Date 18Sep01               *
005600200528      *                 195763             Date 07Jan02               *
005700200528      * Midas Release 4 --------------- Base -------------------------*
005800200528      *                 200400             Date 20Nov01               *
005900200528      *                 185612             Date 22May01               *
006000200528      *                 192530             Date 16May01               *
006100200528      *                 192829             Date 08May01               *
006200200528      * Midas DBA 3.05 -----------------------------------------------*
006300200528      *                 CPB002             Date 08Aug00               *
006400200528      * Midas DBA 3.04 -----------------------------------------------*
006500200528      *                 179510             Date 06Nov00               *
006600200528      *                 CDL008             Date 02May00               *
006700200528      *                 181721             Date 10Aug00               *
006800200528      * Midas DBA 3.03 -----------------------------------------------*
006900200528      *                 166907             Date 27Dec99               *
007000200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
007100200528      *                 176883             Date 24Mar00               *
007200200528      * Midas DBA 3.02 -----------------------------------------------*
007300200528      *                 CAP051             DATE 10Nov99               *
007400200528      *                 CPB001             DATE 01Jun99               *
007500200528      *                 CAP014             Date 29Nov99               *
007600200528      *                 CAP013             Date 07Sep99               *
007700200528      *                 CAP011             Date 07Sep99               *
007800200528      *                 168345             Date 12Oct99               *
007900200528      *                 163820             Date 12Jul99               *
008000200528      * Midas DBA 3.00 -----------------------------------------------*
008100200528      *                 CAP006             Date 25Feb99               *
008200200528      *                 CAP004             Date 01Sep98               *
008300200528      *                 137015             Date 10Jun98               *
008400200528      *                 CAP002  *CREATE    Date 24Feb98               *
008500200528      *                                                               *
008600200528      *---------------------------------------------------------------*
008700200528      *                                                               *
008800200528      *  251029 - Handle file locking properly. Patterned after       *
008900200528      *           fix 231306.                                         *
009000200528      *  MD046248 - Finastra Rebranding                               *
009100200528      *  MD047971 - Do not allow amendment to settlement account if   *
009200200528      *             that side is already netted.                      *
009300200528      *  CDL099 - Split Value Date (Recompile)                        *
009400200528      *  MD036070 - No way to go back to main deal details screen     *
009500200528      *             after reaching settlement screen.  Introduce new  *
009600200528      *             function key F11.                                 *
009700200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
009800200528      *           (Recompile)                                         *
009900200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
010000200528      *  AR990243 - Additional deliveries for CSW212                  *
010100200528      *  CSW212 - SWIFT 2012 Changes                                  *
010200200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
010300200528      *  CER059 - German Feature Upgrade to Delhi                     *
010400200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
010500200528      *           (Recompile)                                         *
010600200528      *  256564 - Recompile due to PF changes done by fix 256330      *
010700200528      *  247888 - Missing record in CLE025 files.                     *
010800200528      *  246352 - Applied core fix 224231.                            *
010900200528      *  224231 - CLS Deal in RPR default incorrect Nostro Code       *
011000200528      *  244036 - Missing deals in extension file DLDLDBQD (done from *
011100200528      *           Java layer).                                        *
011200200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
011300200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
011400200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
011500200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
011600200528      *  CFX114 - Core changes for GBO014                             *
011700200528      *         - Perform Override when Exchange Rate Tolerance is    *
011800200528      *           exceeded.                                           *
011900200528      *         - Upgrade to Midasplus                                *
012000200528      *           Core hooks amended:FXFXDLP010,FXFXDLPC11,FXFXDLPC12,*
012100200528      *                              FXFXDLPC15                       *
012200200528      *  CPK018 - Midasplus Packaging                                 *
012300200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
012400200528      *           (Recompile)                                         *
012500200528      *  BG2562 - Commitment Control Changes for Midas Plus           *
012600200528      *           Parameter mismatch                                  *
012700200528      *  CSC022 - Commitment Control Changes for Midas Plus           *
012800200528      *  CGL029 - Increase Account Code to 10 digits                  *
012900200528      *  CDL010 - Prevent last user that actioned the trade from      *
013000200528      *           authorising it.Recompile due to changes in FXDEALPP *
013100200528      *  CAS004 - Hedge Accounting Phase A                            *
013200200528      *  196952 - Ensure Rate has 5 digits before decimal separator   *
013300200528      *           and 8 digits after.                                 *
013400200528      *           Recompiled due to changes in FXFXDLPD and FXIFXDLPD.*
013500200528      *  192916 - Rollback of window updates wrongly managed in Core  *
013600200528      *           API's modules RPR and SIN.                          *
013700200528      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
013800200528      *  CSC011 - 24x7 Midas Availability                             *
013900200528      *  195763 - Recompiled due to recompiled FXFXDLVAL.             *
014000200528      *  200400 - Reverse fix 179510                                  *
014100200528      *  185612 - Warning for FOREX Limit exceeded.                   *
014200200528      *  192530 - Pass the correct date to ZASETINSIN.                *
014300200528      *  192829 - Wrong module name passed to WN0010.                 *
014400200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
014500200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
014600200528      *           Midas our Receive/Pay instructions  respectively  not
014700200528      *           correctly  updated .  Introduced  new  Data Structure
014800200528      *           @MORPI  which is used  for that purpose .           *
014900200528      *  CDL008 - Continuous Linked Settlement (Recompiled).          *
015000200528      *  181721 - Allow amend to OP up to 'Option to Date'            *
015100200528      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
015200200528      *           in the correct screen.                              *
015300200528      *  176883 - Errors found as a result of creating DBAR3.02       *
015400200528      *           Meridian repository file.                           *
015500200528      *           Mismatch on parameters for call to ZASETINDFT       *
015600200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
015700200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
015800200528      *           Recompiled due to changes in FXDEALPP               *
015900200528      *  CAP014 - Repair function enhancements                        *
016000200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
016100200528      *  CAP011 - Substitution of Midas database flds for externl i/fs*
016200200528      *  168345 - Prevent two users from accessing same transaction   *
016300200528      *           in repair screen at the same cycle, and converting  *
016400200528      *           it into two different Midas Deal No.s  .            *
016500200528      *           Second user should not be allowed to repair the tran-
016600200528      *           saction and convert it into a another Midas Deal    *
016700200528      *  163820 - Transactions Repair Function performs SPF checking  *
016800200528      *           to find if user is authorised to the Branch , but   *
016900200528      *           does that against User's Default Branch code instead*
017000200528      *           of the selected transaction's Booking/Origin branch *
017100200528      *  CAP006 - Check for deal being updated by another workstation *
017200200528      *  CAP004 - API's Phase 3.                                      *
017300200528      *           - Add extra parm for Extra Data                     *
017400200528      *           - Change definition of MSGTYPE to be based on file  *
017500200528      *             field                                             *
017600200528      *  137015 - Repair function not using Midas deal number         *
017700200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
017800200528      *                                                               *
017900200528      *****************************************************************
018000200528      ** +--------------------------------------+
018100200528      ** ¦ F-specs                              ¦
018200200528      ** ¦ =======                              ¦
018300200528      ** +--------------------------------------+
018400200528     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
018500200528
018600200528     FFXIFXDLL0 IF   E           K DISK    INFSR(*PSSR)
018700200528     F                                     RENAME(FXIFXDLD0:FXIFXDLX0)
018800200528     FFXIFXDLL1 UF   E           K DISK    INFSR(*PSSR)
018900200528     F                                     COMMIT
019000200528
019100200528     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
019200200528     F                                     RENAME(APIDSETD0:APIDSETX0)
019300200528     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
019400200528     F                                     COMMIT
019500200528                                                                                              CSC011
019600200528      ** API Invalid Log File from Support Database                                           CSC011
019700200528     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
019800200528     F                                     COMMIT                                             CSC011
019900200528                                                                                              244036
020000200528      ** Midas DL Foreign Exchange Deals Extension Details.                                   244036
020100200528     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       244036
020200200528     F                                     IGNORE(DLDLDCD0)                                   244036
020300200528     F                                     IGNORE(DLDLDGD0)                                   244036
020400200528
020500200528      * Hook to enable non-core files to be included
020600200528      ***PY WNCPYSRC,FXFXDLR009*************************************************CPK018
020700200528      /COPY WNCPYSRC,FXFXDLP009                                                 CPK018
020800200528
020900200528      *****************************************************************
021000200528      ** +--------------------------------------+
021100200528      ** ¦ Automatically included D-specs       ¦
021200200528      ** ¦ ==============================       ¦
021300200528      ** +--------------------------------------+
021400200528      **
021500200528      ** Standard D-specs
021600200528      ** ================
021700200528      **
021800200528      ** The following /COPY line includes the LDA layout,
021900200528      ** the copyright array definition,
022000200528      ** and the following named constants:
022100200528      **    True       logical = *on (for indcator processing)
022200200528      **    False      logical = *off (for indcator processing)
022300200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
022400200528      **                                    handler)
022500200528      ** and the following variables:
022600200528      **    RunBefore  1A (for the PSSR)
022700200528
022800200528     D/COPY ZACPYSRC,STD_D_SPEC
022900200528
023000200528      ** Program Status Data Structure
023100200528      ** =============================
023200200528      ** The following /COPY line includes all the defined fields in the
023300200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
023400200528
023500200528     D/COPY ZACPYSRC,PSDS
023600200528
023700200528      **--------------------------------------------------------------------------------------------
023800200528      ** The following /COPY line includes the definitions for error and
023900200528      ** warning message arrays.
024000200528     D/COPY ZACPYSRC,ERR_ARRAYS
024100200528      **--------------------------------------------------------------------------------------------
024200200528
024300200528      ** +--------------------------------------+
024400200528      ** ¦ End of automatically included D-specs¦
024500200528      ** ¦ =====================================¦
024600200528      ** +--------------------------------------+
024700200528
024800200528      *****************************************************************
024900200528      /EJECT
025000200528      *****************************************************************
025100200528
025200200528      ** +--------------------------------------+
025300200528      ** ¦ Manually included D-specs            ¦
025400200528      ** ¦ =========================            ¦
025500200528      ** +--------------------------------------+
025600200528
025700200528      ** +--------------------------------------+
025800200528      ** ¦ Named constants                      ¦
025900200528      ** ¦ ===============                      ¦
026000200528      ** +--------------------------------------+
026100200528
026200200528      ** +--------------------------------------+
026300200528      ** ¦ Arrays and Data Structures           ¦
026400200528      ** ¦ ==========================           ¦
026500200528      ** +--------------------------------------+
026600200528
026700200528     D @EI             S              1    DIM(60)
026800200528
026900200528
027000200528     D CrDlFilFmt    E DS                  EXTNAME(FXDEALPP)
027100200528      * Current Deal in File Format
027200200528     D  FHREC                400    468                                         CAP011
027300200528     D  FHPAY                469   1027                                         CAP011
027400200528     D  FH@ISDA             1394   2043                                                       CSW212
027500200528
027600200528     D CrDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
027700200528      * (Current) Deal in Screen Format
027800200528     D                                     PREFIX(@)
027900200528
028000200528     D NwDlFilFmt    E DS                  EXTNAME(FXVFXDLPD)
028100200528     D FXFXDLDORI    E                     EXTFLD(QQDORI)                                     CGL029
028200200528     D FXFXDLMORI    E                     EXTFLD(QQMORI)                                     CGL029
028300200528     D FXFXDLDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
028400200528     D FXFXDLMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
028500200528     D FXFXDLRONS    E                     EXTFLD(QQRONS)                                     CGL029
028600200528     D FXFXDLPONS    E                     EXTFLD(QQPONS)                                     CGL029
028700200528      * New Deal in File Format
028800200528     D  F3REC                400    468
028900200528     D  F3PAY                469   1027
029000200528     D  F3@ISDA             1394   2043                                                       CSW212
029100200528
029200200528     D NwDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
029300200528      * New Deal in Screen Format
029400200528
029500200528     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)
029600200528      * Error indicators
029700200528
029800200528
029900200528     D ##RECF        E DS                  EXTNAME(SDESFRPD)
030000200528      ** FILE RECEIVE INSTRUCTIONS
030100200528     D***FLREC                  1     69                                                      CGL029
030200200528     D  FLREC                  1     75                                                       CGL029
030300200528
030400200528     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
030500200528      *** FILE PAYMENT INSTRUCTIONS
030600200528     D***FLPAY                  1    559                                                      CGL029
030700200528     D  FLPAY                  1    565                                                       CGL029
030800200528
030900200528     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
031000200528      ** FILE FRA/IRS INSTRUCTIONS
031100200528     D  FL@ISDA                1    650                                                       CSW212
031200200528
031300200528     D ##RECS        E DS                  EXTNAME(SDESSRPD)
031400200528      ** SCREEN RECEIVE INSTRUCTIONS
031500200528
031600200528     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
031700200528      ** SCREEN PAYMENT INSTRUCTIONS
031800200528
031900200528     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
032000200528      ** SCREEN FRA/IRS INSTRUCTIONS
032100200528
032200200528     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
032300200528      * Pay Settlement Instructions - Current                                   CAP011
032400200528                                                                                CAP011
032500200528     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
032600200528      * Receive Settlement Instructions - Current                               CAP011
032700200528                                                                                CAP011
032800200528     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
032900200528      * FRA/IRS Settlement Instructions - Current                               CAP011
033000200528                                                                                CAP011
033100200528     D @SETIN          DS
033200200528      ** Receive / Pay Settlement Currency, Method & Nostro
033300200528     D  @@RSCY                 1      3
033400200528     D  @@RSTM                 4      5  0
033500200528     D***@@RONS                 6     17                                                      CGL029
033600200528     D***@@PSCY                18     20                                                      CGL029
033700200528     D***@@PSTM                21     22  0                                                   CGL029
033800200528     D***@@PONS                23     34                                                      CGL029
033900200528     D  @@RONS                 6     23                                                       CGL029
034000200528     D  @@PSCY                24     26                                                       CGL029
034100200528     D  @@PSTM                27     28  0                                                    CGL029
034200200528     D  @@PONS                29     46                                                       CGL029
034300200528
034400200528     D                 DS
034500200528      **  Data structure for date in, to change format.
034600200528     D  DateIn                 1      8  0
034700200528     D  @@YY                   1      4  0
034800200528     D  @@MM                   5      6  0
034900200528     D  @@DD                   7      8  0
035000200528
035100200528
035200200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
035300200528      ** EXTERNAL DS FOR BANK DETAILS
035400200528
035500200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
035600200528      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
035700200528                                                                                CAP051
035800200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
035900200528      ** EXTERNAL DS FOR SAR DETAILS                                            CAP051
036000200528
036100200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
036200200528      ** EXTERNAL DS FOR API ICD                                                CAP011
036300200528                                                                                CAP011
036400200528     D DSFDY         E DS                  EXTNAME(DSFDY)
036500200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
036600200528                                                                                CAP051
036700200528     D*@MORPI*****     DS                                                              179510 200400
036800200528      ***Midas*Our*Receive*/*Pay**Instructions*(for*Settl*Meth*=*04*)*******           179510 200400
036900200528     D**@@MORI****             1     12                                                179510 200400
037000200528     D**@@MOPI****            13     24                                                179510 200400
037100200528
037200200528     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
037300200528     D                                     PREFIX(IF_)                          CAP051
037400200528      * FX (FXDL) Extra Data - File (D/B) format                                CAP051
037500200528                                                                                CAP004
037600200528     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
037700200528      * FX Extra Data - File (D/B) format                                       CAP004
037800200528     D/COPY WNCPYSRC,FXH00114
037900200528
038000200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
038100200528      ** 24X7 status data area                                                                CSC011
038200200528                                                                                              CSC011
038300200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
038400200528      ** SD data area                                                                         CSC011
038500200528                                                                                              CSC011
038600200528      ** Data structure for data area commitment control                                      CSC022
038700200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
038800200528     D  ComitJobs              4    103A                                                      CSC022
038900200528                                                                                              CSC022
039000200528     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
039100200528      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
039200200528                                                                                              CSC022
039300200528     D/COPY QWINDSRC,FXDLSINDTA
039400200528
039500200528      ** +--------------------------------------+
039600200528      ** ¦ Declared variables                   ¦
039700200528      ** ¦ ==================                   ¦
039800200528      ** +--------------------------------------+
039900200528
040000200528      **   Timestamp selected
040100200528     D @TMESTPSEL      S             26Z
040200200528
040300200528      ** Response Mode, passed as a constant parameter to the VAL module
040400200528      ** This is always 'S' for Synchronous
040500200528     D RespMode        S              1A   INZ('S')
040600200528                                                                                              185612
040700200528      ** Buy Amount                                                                           185612
040800200528     D BAMT            S             13  0                                                    185612
040900200528                                                                                              185612
041000200528      ** Sell Amount                                                                          185612
041100200528     D SAMT            S             13  0                                                    185612
041200200528
041300200528      ** -------------------------------------------------------------------
041400200528      ** Fields for getting the starting field number from file (parameters
041500200528      ** to ZAGETFLDNO, plus the offset to the requested field).
041600200528     D Format          S             10A   INZ('FXFXDLPD')
041700200528
041800200528     D Field           S             10A   INZ('DDACTN')
041900200528
042000200528     D FieldNo         S              5P 0
042100200528
042200200528     D FldOffset       S              5P 0
042300200528
042400200528      ** End of fields for getting starting field number
042500200528      ** -------------------------------------------------------------------
042600200528                                                                                CAP004
042700200528      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
042800200528      ** of the file field when the file field was changed.                     CAP004
042900200528     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
043000200528                                                                                              CSC011
043100200528      ** Fields defined for Enhancement CSC011                                                CSC011
043200200528     D CSC011          S              1A                                                      CSC011
043300200528     D PRtCd           S              7A                                                      CSC011
043400200528     D POptn           S              7A                                                      CSC011
043500200528     D PSard           S              6A                                                      CSC011
043600200528     D KMsgType        S              8A                                                      CSC011
043700200528     D KFrntOffID      S             20A                                                      CSC011
043800200528     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
043900200528      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
044000200528     D CSC022          S              1A                                                      CSC022
044100200528     D WSkpCom         S              1A                                                      CSC022
044200200528     D WPos            S              2S 0                                                    CSC022
044300200528     D CSW212          S              1A                                                      CSW212
044400200528     D DDRonxOK        S              1A   INZ('Y')                                         MD047971
044500200528     D DDPonxOK        S              1A   INZ('Y')                                         MD047971
044600200528     D/COPY WNCPYSRC,FXH00067
044700200528
044800200528      ** +--------------------------------------+
044900200528      ** ¦ End of D-specs                       ¦
045000200528      ** ¦ ==============                       ¦
045100200528      ** +--------------------------------------+
045200200528
045300200528      ** +----------------------------------------+
045400200528      ** ¦ Hook for non-core D-specs (all types)  ¦
045500200528      ** ¦ also any I-specs (if necessary)        ¦
045600200528      ** ¦ =====================================  ¦
045700200528      ** +----------------------------------------+
045800200528      ***PY WNCPYSRC,FXFXDLR010*************************************************CPK018
045900200528      /COPY WNCPYSRC,FXFXDLP010                                                 CPK018
046000200528
046100200528      *****************************************************************
046200200528      /EJECT
046300200528      *****************************************************************
046400200528     C
046500200528      ** +--- Start of Main processing -----------------------------------+
046600200528      ** ¦                                                                ¦
046700200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
046800200528      ** ¦ executed at program activation.                                ¦
046900200528      ** ¦                                                                ¦
047000200528      ** +----------------------------------------------------------------+
047100200528      *
047200200528      ***PY WNCPYSRC,FXFXDLR001*************************************************CPK018
047300200528      /COPY WNCPYSRC,FXFXDLP001                                                 CPK018
047400200528
047500200528      * DO SCREEN: BROWSE INVALID DEALS
047600200528      *
047700200528     C     @SCRN         IFEQ      'B'
047800200528     C                   EXSR      SCRN@B
047900200528     C                   END
048000200528      *
048100200528      ***PY WNCPYSRC,FXFXDLR002*************************************************CPK018
048200200528      /COPY WNCPYSRC,FXFXDLP002                                                 CPK018
048300200528
048400200528      * READ NEXT BROWSE SUBFILE RECORD
048500200528      *
048600200528     C     @SCRN         IFEQ      'R'
048700200528     C                   EXSR      RDNBRW
048800200528     C                   END
048900200528      *
049000200528      ***PY WNCPYSRC,FXFXDLR003*************************************************CPK018
049100200528      /COPY WNCPYSRC,FXFXDLP003                                                 CPK018
049200200528
049300200528      * DO WHILE SCREEN: MAIN DETAILS
049400200528      *
049500200528     C     @SCRN         DOWEQ     'M'
049600200528     C                   EXSR      SCRN@M
049700200528     C                   END
049800200528      *
049900200528      ***PY WNCPYSRC,FXFXDLR004*************************************************CPK018
050000200528      /COPY WNCPYSRC,FXFXDLP004                                                 CPK018
050100200528
050200200528      * SCREEN: WINDOW
050300200528      *
050400200528     C     @SCRN         IFEQ      'W'
050500200528     C                   EXSR      WINDOW
050600200528     C                   END
050700200528      *
050800200528      ***PY WNCPYSRC,FXFXDLR005*************************************************CPK018
050900200528      /COPY WNCPYSRC,FXFXDLP005                                                 CPK018
051000200528
051100200528      * DO WHILE SCREEN: SETTLEMENT DETAILS
051200200528      *
051300200528     C     @SCRN         DOWEQ     'S'
051400200528     C                   EXSR      SCRN@S
051500200528     C                   END
051600200528      *
051700200528      ***PY WNCPYSRC,FXFXDLR006*************************************************CPK018
051800200528      /COPY WNCPYSRC,FXFXDLP006                                                 CPK018
051900200528
052000200528      * SCREEN: CONFIRMATION OF INPUT
052100200528      *
052200200528     C     @SCRN         IFEQ      'C'
052300200528     C                   EXSR      SCRN@C
052400200528     C                   END
052500200528      *
052600200528      ***PY WNCPYSRC,FXFXDLR007*************************************************CPK018
052700200528      /COPY WNCPYSRC,FXFXDLP007                                                 CPK018
052800200528
052900200528      * DO FILE UPDATES
053000200528      *
053100200528     C     @SCRN         IFEQ      'U'
053200200528     C                   EXSR      UPDATS
053300200528     C                   END
053400200528      *
053500200528      ***PY WNCPYSRC,FXFXDLR008*************************************************CPK018
053600200528      /COPY WNCPYSRC,FXFXDLP008                                                 CPK018
053700200528
053800200528      * TERMINATE PROGRAM
053900200528      *
054000200528     C     @SCRN         IFEQ      'T'
054100200528     C                   If        CSC022 = 'N'                                               CSC022
054200200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
054300200528     C                   ROLBK                                                                192916
054400200528     C                   Else                                                                 CSC022
054500200528     C                   SETON                                        U7U8                    CSC022
054600200528     C                   Endif                                                                CSC022
054700200528     C                   MOVE      '1'           *INLR
054800200528     C                   END
054900200528      *****************************************************************
055000200528
055100200528      * Hook to enable non-core subroutines to be included
055200200528      ***PY WNCPYSRC,FXFXDLR011*************************************************CPK018
055300200528      /COPY WNCPYSRC,FXFXDLP011                                                 CPK018
055400200528
055500200528      /EJECT
055600200528      *****************************************************************
055700200528      * SCRN@B - BROWSE INVALID DEALS
055800200528      *****************************************************************
055900200528     C     SCRN@B        BEGSR
056000200528      *
056100200528      * RESET READ NEXT BROWSE SUBFILE RECORD
056200200528      *
056300200528     C                   MOVEL     *BLANK        @RDNB             1
056400200528      *
056500200528      * BUILD BROWSE SUBFILE
056600200528      *
056700200528     C                   CALLB     'FXFXDLRPB'
056800200528      *
056900200528      * INPUT PARAMETERS
057000200528      *
057100200528      * RETURN CODE
057200200528     C                   PARM      *BLANK        RetCodeOut
057300200528      *
057400200528      * BUILD SUB-FILE
057500200528     C                   PARM      'Y'           @BDSFL            1
057600200528      *
057700200528      * READ SUBFILE RECORD
057800200528     C                   PARM      *BLANK        @RDSFL            1
057900200528      *
058000200528      * Error in update of previous deal                                        CAP006
058100200528     C                   PARM                    @ERRUP            1            CAP006
058200200528      *                                                                         CAP006
058300200528      * OUTPUT PARAMETERS
058400200528      *
058500200528      * ERROR MESSAGE
058600200528     C                   PARM      *BLANK        @ERRMS            7
058700200528      *
058800200528      * OPTION SELECTED
058900200528     C                   PARM                    @OPSEL            1
059000200528      *
059100200528      * ACTION SELECTED
059200200528     C                   PARM                    @ACSEL            1
059300200528      *
059400200528      * FO TRANSACTION ID SELECTED
059500200528     C                   PARM                    @FOTRANSEL       20
059600200528      *
059700200528      * FO ASSOCIATED TRANSACTION ID SELECTED
059800200528     C                   PARM                    @FOASOCSEL       20
059900200528      *
060000200528      * TIMESTAMP OF TRANSACTION SELECTED
060100200528     C                   PARM                    @TMESTPSEL
060200200528      *
060300200528      * COMMAND KEYS
060400200528     C                   PARM      '0'           @INKC             1
060500200528     C                   PARM      '0'           @INKL             1
060600200528      *                                                                         166907
060700200528      ** Successfully Inserted Deal Number                                      166907
060800200528      *                                                                         166907
060900200528     C                   PARM                    @SIDN             6            166907
061000200528                                                                                              CSC011
061100200528      ** CSC011 enhancement                                                                   CSC011
061200200528                                                                                              CSC011
061300200528     C                   PARM                    CSC011                                       CSC011
061400200528      *                                                                                       BG2562
061500200528     C                   PARM                    CSC022                                       BG2562
061600200528      *
061700200528      * If error set on external switches
061800200528      *
061900200528     C     @ERRMS        IFNE      *BLANK
062000200528     C                   MOVE      '1'           *INU6
062100200528     C                   END
062200200528      *
062300200528      * If CK/3 or CK/12 taken in browse, or error message
062400200528      * End program
062500200528      *
062600200528     C     @INKC         IFEQ      '1'
062700200528     C     @INKL         OREQ      '1'
062800200528     C     @ERRMS        ORNE      *BLANK
062900200528     C                   EXSR      ENDP
063000200528     C                   GOTO      ESCRN@B
063100200528     C                   END
063200200528      *
063300200528      * Read next browse subfile record
063400200528      *
063500200528     C                   MOVE      'Y'           @RDNB
063600200528     C                   MOVE      'R'           @SCRN
063700200528      *
063800200528     C     ESCRN@B       ENDSR
063900200528      *****************************************************************
064000200528      /EJECT
064100200528      *****************************************************************
064200200528      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
064300200528      *****************************************************************
064400200528     C     RDNBRW        BEGSR
064500200528      *
064600200528      * READ NEXT SUBFILE RECORD
064700200528      *
064800200528     C                   CALLB     'FXFXDLRPB'
064900200528      *
065000200528      * INPUT PARAMETERS
065100200528      *
065200200528      * RETURN CODE
065300200528     C                   PARM      *BLANK        RetCodeOut
065400200528      *
065500200528      * BUILD SUB-FILE
065600200528     C                   PARM      *BLANK        @BDSFL            1
065700200528      *
065800200528      * READ SUBFILE RECORD
065900200528     C                   PARM      'Y'           @RDSFL            1
066000200528      *
066100200528      * Error in update of previous deal                                        CAP006
066200200528     C                   PARM                    @ERRUP            1            CAP006
066300200528      *                                                                         CAP006
066400200528      * OUTPUT PARAMETERS
066500200528      *
066600200528      * ERROR MESSAGE
066700200528     C                   PARM      *BLANK        @ERRMS            7
066800200528      *
066900200528      * OPTION SELECTED
067000200528     C                   PARM      *BLANK        @OPSEL            1
067100200528      *
067200200528      * ACTION SELECTED
067300200528     C                   PARM      *BLANK        @ACSEL            1
067400200528      *
067500200528      * FO TRANSACTION ID SELECTED
067600200528     C                   PARM      *BLANK        @FOTRANSEL       20
067700200528      *
067800200528      * FO ASSOCIATED TRANSACTION ID SELECTED
067900200528     C                   PARM      *BLANK        @FOASOCSEL       20
068000200528      *
068100200528      * TIMESTAMP OF TRANSACTION SELECTED
068200200528     C                   PARM                    @TMESTPSEL
068300200528      *
068400200528      * COMMAND KEYS
068500200528     C                   PARM      '0'           @INKC             1
068600200528     C                   PARM      '0'           @INKL             1
068700200528      *                                                                         166907
068800200528      ** Successfully Inserted Deal Number                                      166907
068900200528      *                                                                         166907
069000200528     C                   PARM                    @SIDN             6            166907
069100200528                                                                                              CSC011
069200200528      ** CSC011 enhancement                                                                   CSC011
069300200528                                                                                              CSC011
069400200528     C                   PARM                    CSC011                                       CSC011
069500200528      *                                                                         CAP004
069600200528      * If CK/3 taken within invalid transaction deletion function,             CAP004
069700200528      * End program                                                             CAP004
069800200528      *                                                                         CAP004
069900200528     C     @INKC         IFEQ      '1'                                          CAP004
070000200528     C                   EXSR      ENDP                                         CAP004
070100200528     C                   GOTO      ERDNBRW                                      CAP004
070200200528     C                   END                                                    CAP004
070300200528      *
070400200528      * IF INVALID DEAL READ FROM SUBFILE
070500200528      *
070600200528     C     @OPSEL        IFNE      *BLANK
070700200528      *
070800200528      * BLANK THE MAIN DETAILS SCREEN
070900200528      *
071000200528     C                   MOVEL     *BLANK        NwDlScnFmt
071100200528     C                   MOVEL     *BLANK        DDSTS
071200200528     C                   MOVEL     *BLANK        DDNBRF
071300200528     C                   MOVEL     *BLANK        DDNSRF
071400200528      *
071500200528      * RESET ERRORS
071600200528      *
071700200528     C                   MOVE      *ALL'Y'       FXEFXD
071800200528     C                   MOVEL     *BLANK        FldNameArr
071900200528     C                   MOVEL     *BLANK        MsgIdArr
072000200528     C                   MOVEL     *BLANK        MsgDtaArr
072100200528     C                   MOVEL     *BLANK        WFldNamArr
072200200528     C                   MOVEL     *BLANK        WMsgIdArr
072300200528     C                   MOVEL     *BLANK        WMsgDtaArr
072400200528     C/COPY WNCPYSRC,FXH00115
072500200528      *
072600200528      * Retrieve deal details
072700200528      *
072800200528     C                   MOVEL     @ACSEL        DDACTN
072900200528     C                   MOVEL     @FOTRANSEL    FOTRID
073000200528     C                   MOVEL     @FOASOCSEL    FOASID
073100200528     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
073200200528      *                                                                         163820
073300200528      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
073400200528      * module for SPF checking .                                               163820
073500200528      *                                                                         163820
073600200528     C     ZATRNKX0      CHAIN     FXIFXDLX0                          99        163820
073700200528      *                                                                         163820
073800200528      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
073900200528      *  if insert                                                              CAP013
074000200528      *  if not insert and Midas transaction ID is not present                  CAP013
074100200528      * Otherwise                                                               CAP013
074200200528      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
074300200528      *                                                                         CAP013
074400200528     C     DDACTN        IFEQ      'I'                                          CAP013
074500200528     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
074600200528     C                   ELSE                                                   CAP013
074700200528     C     DDDLNO        IFEQ      *BLANK                                       CAP013
074800200528     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
074900200528     C                   ELSE                                                   CAP013
075000200528     C                   MOVEL     '      '      @@MODE                         CAP013
075100200528     C                   ENDIF                                                  CAP013
075200200528     C                   ENDIF                                                  CAP013
075300200528      *                                                                         CAP013
075400200528     C                   EXSR      RTVDEL
075500200528      *
075600200528      * If deal details were retrieved
075700200528      * Put the deal on the main details screen
075800200528      *
075900200528     C     FHRCID        IFNE      *BLANK
076000200528     C     DDACTN        ANDNE     'I'
076100200528     C                   EXSR      PUTD@M
076200200528     C                   END
076300200528      *
076400200528      * Now overwite the fields on the main details screen with those
076500200528      * on the invalid deals file (except for the Midas deal number
076600200528      * and Midas swap/option deal number retrieved above using the
076700200528      * front office transaction and associated transaction IDs).
076800200528      * Access invalid deal with timestamp and front office transaction ID.
076900200528      *
077000200528     C                   MOVEL     DDDLNO        ##DDDLNO          6
077100200528     C                   MOVEL     DDSDNO        ##DDSDNO          6
077200200528     C     ZATRNKX0      CHAIN     FXIFXDLX0                          99
077300200528     C     FHRCID        IFNE      *BLANK                                       137015
077400200528     C     DDACTN        ANDNE     'I'                                          137015
077500200528     C                   MOVEL     ##DDDLNO      DDDLNO
077600200528     C                   MOVEL     ##DDSDNO      DDSDNO
077700200528     C                   END                                                    137015
077800200528     ****PY WNCPYSRC,FXFXDLRC01*************************************************CPK018
077900200528     C/COPY WNCPYSRC,FXFXDLPC01                                                 CPK018
078000200528      *
078100200528      * Access invalid deal settlement instructions
078200200528      *
078300200528     C                   CLEAR                   ##PAYS
078400200528     C                   CLEAR                   ##RECS
078500200528     C                   CLEAR                   ##FRIS                                     AR990243
078600200528     C     APDSETKX      CHAIN     APIDSETX0                          99
078700200528      *                                                                         CAP011
078800200528      * If deal details were retrieved and this is an amendment                 CAP011
078900200528      *                                                                         CAP011
079000200528     C     FHRCID        IFNE      *BLANK                                       CAP011
079100200528     C     DDACTN        ANDEQ     'A'                                          CAP011
079200200528                                                                                CAP011
079300200528      * Data Substitution - Transaction Details                                 CAP011
079400200528                                                                                CAP011
079500200528     C     GHSUBS        ifne      *blank                                       CAP011
079600200528     C     GHSUBS        SCAN      NwDlScnFmt                             99    CAP011
079700200528     C     *IN99         IFEQ      *ON                                          CAP011
079800200528     C                   EXSR      TDtDtaSubs                                   CAP011
079900200528     C                   END                                                    CAP011
080000200528     C                   END                                                    CAP011
080100200528                                                                                CAP011
080200200528      * Setup settlement instructions on amend                                  CAP011
080300200528                                                                                CAP011
080400200528     C                   EXSR      SetupAmend                                   CAP011
080500200528                                                                                CAP011
080600200528      * Data Substitution - Settlement Details                                  CAP011
080700200528                                                                                CAP011
080800200528     C     GHSUBS        ifne      *blank                                       CAP011
080900200528     C     GHSUBS        SCAN      ##PAYS                                 99    CAP011
081000200528     C  N99GHSUBS        SCAN      ##RECS                                 99    CAP011
081100200528     C  N99GHSUBS        SCAN      ##FRIS                                 99                AR990243
081200200528     C     *IN99         IFEQ      *ON                                          CAP011
081300200528     C                   EXSR      SDtDtaSubs                                   CAP011
081400200528     C                   END                                                    CAP011
081500200528     C                   END                                                    CAP011
081600200528                                                                                CAP011
081700200528     C                   END                                                    CAP011
081800200528      *
081900200528      * If action code, or deal number were NOT OK
082000200528      * blank out action code so that the input cannot proceed
082100200528      *
082200200528     C     OKACTN        IFEQ      'N'
082300200528     C     OKDLNO        OREQ      'N'
082400200528     C                   MOVEL     *BLANK        DDACTN
082500200528     C                   END
082600200528      *
082700200528      * Send the deals error messages to the main details screen
082800200528      *
082900200528     C                   EXSR      SNDM@M
083000200528      *
083100200528      * GO TO MAIN DETAILS SCREEN
083200200528      *
083300200528     C                   MOVE      'M'           @SCRN
083400200528      *
083500200528      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
083600200528      *
083700200528     C                   ELSE
083800200528      *
083900200528      * GO TO BROWSE SCREEN
084000200528      *
084100200528     C                   MOVE      'B'           @SCRN
084200200528     C                   END
084300200528      *
084400200528     C     ERDNBRW       ENDSR                                                  CAP004
084500200528     C*******************ENDSR                                                  CAP004
084600200528      *****************************************************************
084700200528      /EJECT
084800200528      *****************************************************************
084900200528      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
085000200528      *****************************************************************
085100200528     C     SNDM@M        BEGSR
085200200528
085300200528     C                   Z-ADD     Idx           E                 3 0
085400200528      *
085500200528      ** If there are fundamental errors in this transaction
085600200528      ** Identify this fact.
085700200528      *
085800200528     C     OKACTN        IFEQ      'N'
085900200528     C     OKDLNO        OREQ      'N'
086000200528     C                   ADD       1             E
086100200528     C                   MOVEL     '*ANY'        FldNameArr(E)
086200200528     C                   MOVEL     'APM0110'     MsgIdArr(E)
086300200528     C                   ENDIF
086400200528      *
086500200528      ** Initialize error indicators
086600200528      *
086700200528     C                   MOVEA     FXEFXD        @EI
086800200528      *
086900200528      ** Read error messages for deal
087000200528      *
087100200528     C     ZATRNKD0      SETLL     ZATRNERRD0
087200200528     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
087300200528      *
087400200528      ** Add error message to array passed to detail screen
087500200528      ** and set OK flag for field to 'N'
087600200528      *
087700200528     C     *IN99         DOWEQ     '0'
087800200528     ****PY WNCPYSRC,FXFXDLRC02*************************************************CPK018
087900200528     C/COPY WNCPYSRC,FXFXDLPC02                                                 CPK018
088000200528     C                   ADD       1             E
088100200528     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
088200200528     C                   MOVEL     ABMSGID       MsgIdArr(E)
088300200528     C                   Z-ADD     ABFIELDID     F                 3 0
088400200528     C                   SUB       FldOffset     F
088500200528     C     F             IFLT      1
088600200528     C     F             ORGT      60
088700200528     C                   Z-ADD     1             F
088800200528     C                   END
088900200528     C                   MOVE      'N'           @EI(F)
089000200528     ****PY WNCPYSRC,FXFXDLRC03*************************************************CPK018
089100200528     C/COPY WNCPYSRC,FXFXDLPC03                                                 CPK018
089200200528     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
089300200528     C                   END
089400200528      *
089500200528     C                   MOVEA     @EI           FXEFXD
089600200528      *
089700200528     C                   ENDSR
089800200528      *****************************************************************
089900200528      /EJECT
090000200528      *****************************************************************
090100200528      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
090200200528      *****************************************************************
090300200528     C     SCRN@M        BEGSR
090400200528      *
090500200528      * Issue rollback to clear any possible updates in window function
090600200528      *
090700200528     C     BGWDPR        IFEQ      'Y'
090800200528     C                   If        CSC022 = 'N'                                               CSC022
090900200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
091000200528     C                   ROLBK
091100200528     C                   Else                                                                 CSC022
091200200528     C                   SETON                                        U7U8                    CSC022
091300200528     C                   Endif                                                                CSC022
091400200528     C                   END
091500200528      *
091600200528      * Enable/disable detail fields on main details screen
091700200528      * if changes to the data are allowed                                      CAP014
091800200528      * (key fields = action code & deal number; detail fields = rest)
091900200528      * (Action code can only be 'I', 'A', 'D', or 'X')
092000200528      *
092100200528     C     DDACTN        IFEQ      'I'
092200200528     C     @OPSEL        ANDEQ     'U'                                          CAP014
092300200528     C     DDACTN        OREQ      'A'
092400200528     C     @OPSEL        ANDEQ     'U'                                          CAP014
092500200528     C                   MOVEL     'Y'           @EDTFD
092600200528     C                   ELSE
092700200528     C                   MOVEL     'N'           @EDTFD
092800200528     C                   END
092900200528      *
093000200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
093100200528      *
093200200528     C     DDACTN        IFEQ      'D'
093300200528     C                   MOVEL     'Y'           @EINKJ
093400200528     C                   ELSE
093500200528     C                   MOVEL     'N'           @EINKJ
093600200528     C                   END
093700200528      *
093800200528      * WRITE/READ DISPLAY SCREEN
093900200528      *
094000200528     C                   CALLB     'FXFXDLDSP'
094100200528      *
094200200528      * INPUT PARAMETERS
094300200528      *
094400200528      * RETURN CODE
094500200528     C                   PARM      *BLANK        RetCodeOut
094600200528      *
094700200528      * DEAL (IN SCREEN FORMAT)
094800200528     C                   PARM                    NwDlScnFmt
094900200528      *
095000200528      * NET BUY/SELL REFERENCE
095100200528     C                   PARM                    DDNBRF
095200200528     C                   PARM                    DDNSRF
095300200528      *
095400200528      * DEAL STATUS
095500200528     C                   PARM                    DDSTS            24
095600200528     C/COPY WNCPYSRC,FXH00033
095700200528      *
095800200528      * FIELDS IN ERROR
095900200528     C                   PARM                    FXEFXD
096000200528      *
096100200528      * ERRORS
096200200528     C                   PARM                    FldNameArr
096300200528     C                   PARM                    MsgIdArr
096400200528     C                   PARM                    MsgDtaArr
096500200528      *
096600200528      * WARNINGS
096700200528     C                   PARM                    WFldNamArr
096800200528     C                   PARM                    WMsgIdArr
096900200528     C                   PARM                    WMsgDtaArr
097000200528      *
097100200528      * ENABLED KEY & DETAIL FIELDS
097200200528      *
097300200528     C                   PARM      'N'           @EKYFD            1
097400200528     C                   PARM                    @EDTFD            1
097500200528      *
097600200528      * ENABLED FUNCTION KEYS
097700200528     C                   PARM      'N'           @EINKG            1
097800200528     C                   PARM      'N'           @EINKH            1
097900200528     C                   PARM                    @EINKJ            1
098000200528     C                   PARM      'N'           @EINKN            1
098100200528     C                   PARM      'N'           @EINKP            1
098200200528      *
098300200528      * SUCCESFUL INSERT DEAL
098400200528     C                   PARM                    @SIDN             6
098500200528      *
098600200528      * OUTPUT PARAMETERS
098700200528      *
098800200528      * FUNCTION KEYS
098900200528     C                   PARM      '0'           @INKC             1
099000200528     C                   PARM      '0'           @INKG             1
099100200528     C                   PARM      '0'           @INKH             1
099200200528     C                   PARM      '0'           @INKJ             1
099300200528     C                   PARM      '0'           @INKL             1
099400200528     C                   PARM      '0'           @INKN             1
099500200528     C                   PARM      '0'           @INKP             1
099600200528     C                   PARM      'N'           WriteOnly         1
099700200528      *                                                                                       185612
099800200528      ** Maximum Daily Delivery Risk fields:                                                  185612
099900200528      *                                                                                       185612
100000200528     C                   PARM                    DDMDDR           16                          185612
100100200528     C                   PARM                    DDEXP1           16                          185612
100200200528     C                   PARM                    DDEXP2           16                          185612
100300200528     C                   PARM                    DDLIM1            3                          185612
100400200528     C                   PARM                    DDLIM2            3                          185612
100500200528     C                   PARM                    DDLIM3            9                          185612
100600200528     ****PY WNCPYSRC,FXFXDLRC04*************************************************CPK018
100700200528     C/COPY WNCPYSRC,FXFXDLPC04                                                 CPK018
100800200528      *
100900200528      * RESET ERRORS
101000200528      *
101100200528     C                   MOVE      *ALL'Y'       FXEFXD
101200200528     C                   MOVEL     *BLANK        FldNameArr
101300200528     C                   MOVEL     *BLANK        MsgIdArr
101400200528     C                   MOVEL     *BLANK        MsgDtaArr
101500200528     C                   MOVEL     *BLANK        WFldNamArr
101600200528     C                   MOVEL     *BLANK        WMsgIdArr
101700200528     C                   MOVEL     *BLANK        WMsgDtaArr
101800200528      *
101900200528      * CK/3 - END PROGRAM
102000200528      *
102100200528     C     @INKC         CASEQ     '1'           ENDP
102200200528      *
102300200528      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
102400200528      *
102500200528     C     @INKL         CASEQ     '1'           CANC@M
102600200528      *
102700200528      * VALIDATE INPUT TO MAIN DETAILS SCREEN
102800200528      *
102900200528     C                   CAS                     VAL@M
103000200528     C                   END
103100200528      *
103200200528     C                   ENDSR
103300200528      *****************************************************************
103400200528      /EJECT
103500200528      *****************************************************************
103600200528      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
103700200528      *****************************************************************
103800200528     C     VAL@M         BEGSR
103900200528      *
104000200528      * Retrieve deal details
104100200528      *
104200200528     C                   MOVEL     '      '      @@MODE
104300200528     C                   EXSR      RTVDEL
104400200528      *
104500200528      * If action code, or deal number are NOT OK
104600200528      * Re-output screen with error messages on it
104700200528      *
104800200528     C     OKACTN        IFEQ      'N'
104900200528     C     OKDLNO        OREQ      'N'
105000200528     C                   GOTO      EVAL@M
105100200528     C                   END
105200200528      *
105300200528      *----------------------------------------------------------------
105400200528      * IF DELETE
105500200528      *
105600200528     C     DDACTN        IFEQ      'D'
105700200528      *
105800200528      * Update Deal in File Format
105900200528      *
106000200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
106100200528      *
106200200528      * IF CK/10 TAKEN, GO ONTO UPDATES
106300200528      *
106400200528     C     @INKJ         IFEQ      '1'
106500200528     C                   MOVEL     'U'           @SCRN
106600200528     C                   END
106700200528     C                   GOTO      EVAL@M
106800200528     C                   END
106900200528      *
107000200528      *----------------------------------------------------------------
107100200528      * IF AUTHORIZE
107200200528      *
107300200528     C     DDACTN        IFEQ      'X'
107400200528      *
107500200528      * Update Deal in File Format
107600200528      *
107700200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
107800200528      *
107900200528      * If windows processing on, call window routine
108000200528      * otherwise, continue to settlements screen
108100200528      *
108200200528     C     BGWDPR        IFEQ      'Y'
108300200528     C                   MOVEL     'W'           @SCRN
108400200528     C                   ELSE
108500200528     C                   MOVEL     'S'           @SCRN
108600200528     C                   END
108700200528      *
108800200528     C                   GOTO      EVAL@M
108900200528     C                   END
109000200528      *
109100200528      *----------------------------------------------------------------
109200200528      * IF INSERT OR AMEND
109300200528      *
109400200528     C     DDACTN        IFEQ      'I'
109500200528     C     DDACTN        OREQ      'A'
109600200528      *
109700200528      * Prior to validation, initialize error indicators as 'OK'
109800200528      * and clear Deal in File Format
109900200528      *
110000200528     C                   Z-ADD     *ZERO         Idx               3 0
110100200528     C                   Z-ADD     *ZERO         WIdx              3 0
110200200528     C                   MOVE      *ALL'Y'       FXEFXD
110300200528     C                   CLEAR                   NwDlFilFmt
110400200528     C                   Z-ADD     *ZERO         F3RSTM
110500200528     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
110600200528     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
110700200528     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
110800200528     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
110900200528     C                   Z-ADD     *ZERO         F3PSTM
111000200528     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
111100200528     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
111200200528     C                   EVAL      F3POBN = *BLANKS                                           CSD027
111300200528     C                   EVAL      F3POCN = *BLANKS                                           CSD027
111400200528     C/COPY WNCPYSRC,FXH00116
111500200528      *
111600200528      * IF AMEND
111700200528      *
111800200528     C     DDACTN        IFEQ      'A'
111900200528      *
112000200528      * Update Deal in File Format
112100200528      *
112200200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
112300200528      *
112400200528      * Validate whether non-amenable fields have been changed
112500200528      *
112600200528     C                   CALLB     'FXFXDLAMD'
112700200528      *
112800200528      * INPUTS
112900200528      *
113000200528      * Return Code
113100200528     C                   PARM      *BLANK        RetCodeOut
113200200528      *
113300200528      * New Deal in Screen Format
113400200528     C                   PARM                    NwDlScnFmt
113500200528      *
113600200528      * Current Deal in Screen Format
113700200528     C                   PARM                    CrDlScnFmt
113800200528      *
113900200528      * Current Deal in file format
114000200528     C                   PARM                    CrDlFilFmt
114100200528      *                                                                                     MD047971
114200200528      ** Pay/rcv settlement account                                                         MD047971
114300200528      *                                                                                     MD047971
114400200528     C                   PARM                    DDRONX                                     MD047971
114500200528     C                   PARM                    DDPONX                                     MD047971
114600200528     C                   PARM                    DDRONXOK                                   MD047971
114700200528     C                   PARM                    DDPONXOK                                   MD047971
114800200528      *
114900200528      * OUTPUTS
115000200528      *
115100200528      * Field OK flags (DS) from/to caller
115200200528     C                   PARM                    FXEFXD
115300200528      *
115400200528      * Error fields/message IDs/message data (arrays) from/to caller
115500200528     C                   PARM                    FldNameArr
115600200528     C                   PARM                    MsgIdArr
115700200528     C                   PARM                    MsgDtaArr
115800200528      *
115900200528      * Array index (3P0) from/to caller
116000200528     C                   PARM                    Idx
116100200528      *
116200200528      * Amendments OK
116300200528     C                   PARM                    @@AMOK            1
116400200528      *
116500200528      * Reset of Fields in Error Required (Y/N)
116600200528     C                   PARM      'Y'           @@RSTE            1
116700200528     C                   END
116800200528      *
116900200528      * Validate deal details
117000200528      *
117100200528     C                   CALLB     'FXFXDLVAL'
117200200528     C                   PARM                    RespMode
117300200528     C                   PARM                    NwDlScnFmt
117400200528     C                   PARM                    InfData                        CAP051
117500200528     C                   PARM      F3RSCY        @@RSCY
117600200528     C                   PARM      F3RSTM        @@RSTM
117700200528     C                   PARM      F3RONS        @@RONS
117800200528     C                   PARM      F3PSCY        @@PSCY
117900200528     C                   PARM      F3PSTM        @@PSTM
118000200528     C                   PARM      F3PONS        @@PONS
118100200528     C                   PARM      F3FRNT        @@FRNT           20            CPB002
118200200528     C                   PARM                    ExtData                        CAP004
118300200528     C/COPY WNCPYSRC,FXH00198
118400200528     C                   PARM                    DDNBRF
118500200528     C                   PARM                    DDNSRF
118600200528     C                   PARM                    FXEFXD
118700200528     C/COPY WNCPYSRC,FXH00117
118800200528     C                   PARM                    FldNameArr
118900200528     C                   PARM                    MsgIdArr
119000200528     C                   PARM                    MsgDtaArr
119100200528     C                   PARM                    Idx
119200200528     C                   PARM                    WFldNamArr
119300200528     C                   PARM                    WMsgIdArr
119400200528     C                   PARM                    WMsgDtaArr
119500200528     C                   PARM                    WIdx
119600200528     C                   PARM                    NwDlFilFmt
119700200528     ****PY WNCPYSRC,FXFXDLRC11*************************************************CPK018
119800200528     C/COPY WNCPYSRC,FXFXDLPC11                                                 CPK018
119900200528      *
120000200528      * If errors returned
120100200528      *
120200200528     C     Idx           IFNE      0
120300200528     C                   GOTO      EVAL@M
120400200528     C                   END
120500200528      *                                                                         CAP051
120600200528      * Setup Automatic Authorisation flag on the Valid file                    CAP051
120700200528     C     CAP051        IFEQ      'Y'                                          CAP051
120800200528     C                   EVAL      F3AUTH = DDAUTH                              CAP051
120900200528     C                   ENDIF                                                  CAP051
121000200528      *
121100200528      * If windows processing on, call window routine
121200200528      * otherwise, continue to settlements screen
121300200528      *
121400200528     C     BGWDPR        IFEQ      'Y'
121500200528     C                   MOVEL     'W'           @SCRN
121600200528     C                   ELSE
121700200528     C                   MOVEL     'S'           @SCRN
121800200528     C                   END
121900200528      *
122000200528     C                   END
122100200528      *----------------------------------------------------------------
122200200528     C     EVAL@M        ENDSR
122300200528      *****************************************************************
122400200528      /EJECT
122500200528      *****************************************************************
122600200528      * WINDOW - CALL WINDOW MANAGER
122700200528      *****************************************************************
122800200528     C     WINDOW        BEGSR
122900200528      *
123000200528      * Reset erros
123100200528      *
123200200528     C                   MOVE      *ALL'Y'       FXEFXD
123300200528     C                   MOVEL     *BLANK        FldNameArr
123400200528     C                   MOVEL     *BLANK        MsgIdArr
123500200528     C                   MOVEL     *BLANK        MsgDtaArr
123600200528     C                   MOVEL     *BLANK        WFldNamArr
123700200528     C                   MOVEL     *BLANK        WMsgIdArr
123800200528     C                   MOVEL     *BLANK        WMsgDtaArr
123900200528     C/COPY WNCPYSRC,FXH00118
124000200528      *
124100200528      * Write out screen to remove error messages
124200200528      *
124300200528     C                   CALLB     'FXFXDLDSP'
124400200528      *
124500200528      * INPUT PARAMETERS
124600200528      *
124700200528      * RETURN CODE
124800200528     C                   PARM      *BLANK        RetCodeOut
124900200528      *
125000200528      * DEAL (IN SCREEN FORMAT)
125100200528     C                   PARM                    NwDlScnFmt
125200200528      *
125300200528      * NET BUY/SELL REFERENCE
125400200528     C                   PARM                    DDNBRF
125500200528     C                   PARM                    DDNSRF
125600200528      *
125700200528      * DEAL STATUS
125800200528     C                   PARM                    DDSTS
125900200528     C/COPY WNCPYSRC,FXH00034
126000200528      *
126100200528      * FIELDS IN ERROR
126200200528     C                   PARM                    FXEFXD
126300200528      *
126400200528      * ERRORS
126500200528     C                   PARM                    FldNameArr
126600200528     C                   PARM                    MsgIdArr
126700200528     C                   PARM                    MsgDtaArr
126800200528      *
126900200528      * WARNINGS
127000200528     C                   PARM                    WFldNamArr
127100200528     C                   PARM                    WMsgIdArr
127200200528     C                   PARM                    WMsgDtaArr
127300200528      *
127400200528      * ENABLED KEY & DETAIL FIELDS
127500200528      *
127600200528     C                   PARM                    @EKYFD
127700200528     C                   PARM                    @EDTFD
127800200528      *
127900200528      * ENABLED FUNCTION KEYS
128000200528     C                   PARM                    @EINKG
128100200528     C                   PARM                    @EINKH
128200200528     C                   PARM                    @EINKJ
128300200528     C                   PARM                    @EINKN
128400200528     C                   PARM                    @EINKP
128500200528      *
128600200528      * SUCCESFUL INSERT DEAL
128700200528     C                   PARM                    @SIDN             6
128800200528      *
128900200528      * OUTPUT PARAMETERS
129000200528      *
129100200528      * FUNCTION KEYS
129200200528     C                   PARM      '0'           @INKC             1
129300200528     C                   PARM      '0'           @INKG             1
129400200528     C                   PARM      '0'           @INKH             1
129500200528     C                   PARM      '0'           @INKJ             1
129600200528     C                   PARM      '0'           @INKL             1
129700200528     C                   PARM      '0'           @INKN             1
129800200528     C                   PARM      '0'           @INKP             1
129900200528     C                   PARM      'Y'           WriteOnly         1
130000200528      *                                                                                       185612
130100200528      ** Maximum Daily Delivery Risk fields:                                                  185612
130200200528      *                                                                                       185612
130300200528     C                   PARM                    DDMDDR           16                          185612
130400200528     C                   PARM                    DDEXP1           16                          185612
130500200528     C                   PARM                    DDEXP2           16                          185612
130600200528     C                   PARM                    DDLIM1            3                          185612
130700200528     C                   PARM                    DDLIM2            3                          185612
130800200528     C                   PARM                    DDLIM3            9                          185612
130900200528     ****PY WNCPYSRC,FXFXDLRC05*************************************************CPK018
131000200528     C/COPY WNCPYSRC,FXFXDLPC05                                                 CPK018
131100200528      *
131200200528      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
131300200528      * GET NEXT AVAILABLE DEAL NUMBER
131400200528      *
131500200528     C     DDDLNO        IFEQ      *BLANK
131600200528     C                   CALLB     'CAGETNXTDL'
131700200528     C                   PARM      *BLANKS       RetCodeOut
131800200528     C                   PARM      *BLANKS       @@MSG1            7
131900200528     C                   PARM                    I#DDDLNO          6
132000200528     C                   PARM      *ZERO         F3DN38
132100200528      *
132200200528      * DATABASE ERROR
132300200528      *
132400200528     C     @@MSG1        IFNE      *BLANK
132500200528     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
132600200528     C                   MOVEL     '001'         DBASE                          * DBERR 001*
132700200528     C                   MOVEL     DDDLNO        DBKEY                          ************
132800200528     C                   EXSR      *PSSR
132900200528     C                   END
133000200528     C                   END
133100200528      *
133200200528     C/COPY WNCPYSRC,FXDLSINMV1
133300200528      *
133400200528     C                   CALL      'WN0010'
133500200528     C**********         PARM      'FXFXDLSIN'   #PGM             10                          192829
133600200528     C                   PARM      'FXFXDLRPR'   #PGM             10                          192829
133700200528     C                   PARM                    FKEY              2
133800200528     C                   PARM      DDACTN        ACTION            1
133900200528     C                   PARM                    DATA
134000200528     C                   PARM      *BLANKS       #RTRN             7
134100200528     C                   PARM                    SPAREW          256
134200200528      *
134300200528      * Process returned command keys
134400200528      *
134500200528     C     #RTRN         IFEQ      'Y2U9999'
134600200528     C                   EXSR      ENDP
134700200528     C                   ELSE
134800200528      *
134900200528      *  If Cmd12 pressed, or in enquiry, return to main details screen;
135000200528      *  otherwise, go to settlements screen
135100200528      *
135200200528     C     #RTRN         IFEQ      'USR0790'
135300200528     C     DDACTN        OREQ      'E'
135400200528     C     @RDNB         IFEQ      'Y'
135500200528     C                   EVAL      @SCRN = 'R'
135600200528     C                   ELSE
135700200528     C                   EVAL      @SCRN = 'M'
135800200528     C                   END
135900200528     C                   If        CSC022 = 'N'                                               CSC022
136000200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
136100200528     C                   ROLBK                                                                192916
136200200528     C                   Else                                                                 CSC022
136300200528     C                   SETON                                        U7U8                    CSC022
136400200528     C                   Endif                                                                CSC022
136500200528     C                   ELSE
136600200528     C                   EVAL      @SCRN = 'S'
136700200528     C                   ENDIF
136800200528     C                   ENDIF
136900200528      *
137000200528     C     WIND          ENDSR
137100200528      *****************************************************************
137200200528      /EJECT
137300200528      *****************************************************************
137400200528      * RTVDEL - RETRIEVE DEAL
137500200528      *****************************************************************
137600200528     C     RTVDEL        BEGSR
137700200528      *
137800200528      * RETRIEVE DEAL
137900200528      *
138000200528     C                   CALLB     'FXFXDLRTV'
138100200528      *
138200200528      * INPUTS
138300200528      *
138400200528      * Return code
138500200528     C                   PARM      *BLANK        RetCodeOut
138600200528      *
138700200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
138800200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
138900200528      *
139000200528     C                   PARM                    @@MODE            6
139100200528      *
139200200528      * Response mode
139300200528     C                   PARM      'S'           @@RSMD            1
139400200528      *
139500200528      * Action Code
139600200528     C                   PARM                    DDACTN
139700200528      *
139800200528      * Front Office Transaction ID
139900200528     C                   PARM                    FOTRID           20
140000200528      *
140100200528      * Front Office Associated Transaction Id
140200200528     C                   PARM                    FOASID           20
140300200528      *
140400200528      * (Midas) Deal Number
140500200528     C                   PARM                    DDDLNO
140600200528      *
140700200528      * (Midas) Swap/Option Deal Number
140800200528     C                   PARM                    DDSDNO
140900200528      *
141000200528      * Booking branch
141100200528     C                   PARM                    DDBRSN
141200200528      *
141300200528      * Originating branch
141400200528     C                   PARM                    DDORBR
141500200528      *
141600200528      * OUTPUTS
141700200528      *
141800200528      * (Current) deal in file format
141900200528     C                   PARM                    CrDlFilFmt
142000200528      *
142100200528      * OK - Action code
142200200528     C                   PARM      *BLANK        OKACTN
142300200528      *
142400200528      * OK - Deal Number
142500200528     C                   PARM      *BLANK        OKDLNO
142600200528      *
142700200528      * OK - Booking branch
142800200528     C                   PARM      *BLANK        OKBRSN
142900200528      *
143000200528      * OK - Originating branch
143100200528     C                   PARM      *BLANK        OKORBR
143200200528      *
143300200528      * Error fields/message IDs/message data (arrays) from/to caller
143400200528     C                   PARM                    FldNameArr
143500200528     C                   PARM                    MsgIdArr
143600200528     C                   PARM                    MsgDtaArr
143700200528      *
143800200528      * Array index (3P0) from/to caller
143900200528     C                   PARM      *ZERO         Idx
144000200528                                                                                              CAS004
144100200528      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
144200200528                                                                                              CAS004
144300200528     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
144400200528     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
144500200528     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
144600200528                                                                                              CAS004
144700200528      ** Warning array index (3P0) from/to caller                                             CAS004
144800200528                                                                                              CAS004
144900200528     C                   PARM      *ZEROS        WIdx                                         CAS004
145000200528                                                                                              CAS004
145100200528     ****PY WNCPYSRC,FXFXDLRC06*************************************************CPK018
145200200528     C/COPY WNCPYSRC,FXFXDLPC06                                                 CPK018
145300200528      *
145400200528     C                   ENDSR
145500200528      *****************************************************************
145600200528      /EJECT
145700200528      *****************************************************************
145800200528      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
145900200528      *****************************************************************
146000200528     C     PUTD@M        BEGSR
146100200528      *
146200200528      * Call program to fill screen fields with data from FXDEALPP
146300200528      *
146400200528     C                   CALLB     'FXFXDLCVT'
146500200528      *
146600200528      * INPUTS
146700200528      *
146800200528      * Return Code
146900200528     C                   PARM      *BLANK        RetCodeOut
147000200528      *
147100200528      * Deal in file format
147200200528     C                   PARM                    CrDlFilFmt
147300200528      *
147400200528      * OUTPUTS
147500200528      *
147600200528      * Deal in screen format
147700200528     C                   PARM                    NwDlScnFmt
147800200528      *
147900200528      * NET BUY/SELL REFERENCE
148000200528     C                   PARM                    DDNBRF           19
148100200528     C                   PARM                    DDNSRF           19
148200200528      *
148300200528      * Deal Status
148400200528     C                   PARM                    DDSTS            24
148500200528      *
148600200528      * Update 'Current' Deal with Deal in Screen Format
148700200528      *
148800200528     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
148900200528      *
149000200528     C                   ENDSR
149100200528      *****************************************************************
149200200528      /EJECT
149300200528      *****************************************************************
149400200528      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
149500200528      *****************************************************************
149600200528     C     CANC@M        BEGSR
149700200528      *
149800200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
149900200528      *
150000200528     C     @RDNB         IFEQ      'Y'
150100200528     C                   MOVEL     'R'           @SCRN
150200200528     C                   ELSE
150300200528      *
150400200528      * ELSE, RETURN TO THE BROWSE SCREEN
150500200528      *
150600200528     C                   MOVEL     'B'           @SCRN
150700200528     C                   END
150800200528      *
150900200528     C                   ENDSR
151000200528      *****************************************************************
151100200528      /EJECT
151200200528      *****************************************************************
151300200528      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
151400200528      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
151500200528      *****************************************************************
151600200528     C     SCRN@S        BEGSR
151700200528      *                                                                                       192530
151800200528      * PAYMENT DATE = VALUE DATE                                                             192530
151900200528      *                                                                                       192530
152000200528      * For OP can amend Pay Side Settl Ins up to Option to Date                              192530
152100200528     C     DDACTN        IFEQ      'A'                                                        192530
152200200528     C     DDDLTP        ANDEQ     'OP'                                                       192530
152300200528     C                   Z-ADD     F3OTDN        ##DATP                                       192530
152400200528     C                   Z-ADD     F3OTDN        ##DATR                                       192530
152500200528     C                   ELSE                                                                 192530
152600200528     C                                                                                        192530
152700200528     C                   Z-ADD     F3VDDN        ##DATP                                       192530
152800200528      *                                                                                       192530
152900200528      * RECEIVE DATE = VALUE DATE                                                             192530
153000200528      *                                                                                       192530
153100200528     C                   Z-ADD     F3VDDN        ##DATR                                       192530
153200200528     C                   ENDIF                                                                192530
153300200528      *
153400200528      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
153500200528      *
153600200528     C     DDACTN        IFNE      ##ACTN
153700200528     C     DDDLNO        ORNE      ##DLNO
153800200528     C     DDSCCY        ORNE      ##PCCY
153900200528     C     DDBCCY        ORNE      ##RCCY
154000200528     C     DDCUST        ORNE      ##CSNM
154100200528     C     CDL008        OREQ      'Y'                                                        224231
154200200528      *                                                                                       224231
154300200528      ** If feature CDL008 is installed                                                       224231
154400200528      *                                                                                       224231
154500200528     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                              224231
154600200528     C                   EVAL      ##TTYP = 'CL'                                              224231
154700200528     C                   ELSE                                                                 224231
154800200528     C                   EVAL      ##TTYP = DDDLTP                                            224231
154900200528     C                   ENDIF                                                                224231
155000200528      *
155100200528      *                                                                                       251029
155200200528      ** And if the program does not enter this routine as a result                           251029
155300200528      ** of locking files (@RTCD = *RECLCK).  Settlement details should                       251029
155400200528      ** remain as how it was previously input unless otherwise changed                       251029
155500200528      ** again by the user.                                                                   251029
155600200528      *                                                                                       251029
155700200528     C     ##PAYF        IFEQ      *BLANKS                                                    251029
155800200528     C     ##RECF        ANDEQ     *BLANKS                                                    251029
155900200528     C*
156000200528      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
156100200528      *
156200200528     C                   EXSR      DETP@S
156300200528      *                                                                                       251029
156400200528     C                   ENDIF                                                                251029
156500200528      *                                                                                       251029
156600200528     C                   END
156700200528      *                                                                         CAP014
156800200528      * If no changes are allowed, protect (but still validate)                 CAP014
156900200528      * all instructions by passing action code 'X' to ZASETINSIN               CAP014
157000200528      *                                                                         CAP014
157100200528     C     @OPSEL        IFEQ      'N'                                          CAP014
157200200528     C                   MOVEL     'X'           ##ACTN                         CAP014
157300200528     C                   ELSE                                                   CAP014
157400200528     C                   MOVEL     DDACTN        ##ACTN                         CAP014
157500200528     C                   ENDIF                                                  CAP014
157600200528      *
157700200528      * SETTLEMENT INSTRUCTIONS INPUT
157800200528      *
157900200528     C                   CALLB     'ZASETINSIN'
158000200528      *
158100200528      * INPUTS
158200200528      *
158300200528      * Return Code
158400200528     C                   PARM      *BLANK        ##RTCD           10
158500200528      *
158600200528      * Action code
158700200528     C                   PARM                    ##ACTN            1            CAP014
158800200528     C*******************PARM      DDACTN        ##ACTN            1            CAP014
158900200528      *
159000200528      * Deal number
159100200528     C                   PARM      DDDLNO        ##DLNO            6
159200200528      *
159300200528      * Protect Payment
159400200528     C                   PARM                    ##PPAY            1
159500200528      *
159600200528      * Protect Receive
159700200528     C                   PARM                    ##PREC            1
159800200528      *
159900200528      * Calling program
160000200528     C                   PARM      'FXDL'        ##CALP            4
160100200528      *
160200200528      * Payment currency
160300200528     C                   PARM      DDSCCY        ##PCCY            3
160400200528      *
160500200528      * Receive currency
160600200528     C                   PARM      DDBCCY        ##RCCY            3
160700200528      *
160800200528      * Customer shortname
160900200528     C                   PARM      DDCUST        ##CSNM           10
161000200528      *
161100200528      * Transaction Type
161200200528     C**********         PARM      DDDLTP        ##TTYP            2                          224231
161300200528     C                   PARM                    ##TTYP            2                          224231
161400200528      *
161500200528      * Federal Funds Ind.
161600200528     C                   PARM      DDFEDF        ##FFND            1
161700200528      *
161800200528      * Booking branch
161900200528     C                   PARM      DDBRSN        ##BRCA            3
162000200528      *
162100200528      * Receipt Date
162200200528     C                   PARM                    ##DATR            5 0
162300200528      *
162400200528      * Payment Date
162500200528     C                   PARM                    ##DATP            5 0
162600200528      *
162700200528      * Payment instructions
162800200528     C                   PARM                    ##PAYS
162900200528      *
163000200528      * Receive instructions
163100200528     C                   PARM                    ##RECS
163200200528      *
163300200528      * FRA/IRS instructions
163400200528     C                   PARM                    ##FRIS
163500200528      *
163600200528      * OUTPUTS
163700200528      *
163800200528      * Payment instructions
163900200528     C                   PARM                    ##PAYF
164000200528      *
164100200528      * Receive instructions
164200200528     C                   PARM                    ##RECF
164300200528      *
164400200528      * FRA/IRS instructions
164500200528     C                   PARM                    ##FRIF
164600200528      *
164700200528      * FUNCTION KEYS
164800200528     C                   PARM      '0'           @INKC             1
164900200528     C                   PARM      '0'           @INKK             1                        MD036070
165000200528     C                   PARM      '0'           @INKL             1
165100200528      ************                                                                     179510 200400
165200200528      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
165300200528     C************       PARM                    @MORPI           24                   179510 200400
165400200528      ************                                                                     179510 200400
165500200528      *
165600200528      * CK/3 - END PROGRAM
165700200528      *
165800200528     C     @INKC         CASEQ     '1'           ENDP
165900200528      *
166000200528      * CK/12 - CANCEL ON SETTLEMENT DETAILS
166100200528      *
166200200528     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
166300200528     C     @INKL         CASEQ     '1'           CANC@S
166400200528      *
166500200528      * EXIT FROM SETTLEMENT DETAILS
166600200528      *
166700200528     C                   CAS                     EXIT@S
166800200528     C                   END
166900200528      *
167000200528     C                   ENDSR
167100200528      *****************************************************************
167200200528      /EJECT
167300200528      *****************************************************************
167400200528      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
167500200528      *****************************************************************
167600200528     C     DETP@S        BEGSR
167700200528      *
167800200528      * PAYMENT DATE = VALUE DATE
167900200528      *
168000200528      * For OP can amend Pay Side Settl Ins up to Option to Date                    181721
168100200528     C     DDACTN        IFEQ      'A'                                              181721
168200200528     C     DDDLTP        ANDEQ     'OP'                                             181721
168300200528     C                   Z-ADD     F3OTDN        ##DATP                             181721
168400200528     C                   Z-ADD     F3OTDN        ##DATR                             181721
168500200528     C                   ELSE                                                       181721
168600200528     C                                                                              181721
168700200528     C                   Z-ADD     F3VDDN        ##DATP
168800200528      *
168900200528      * RECEIVE DATE = VALUE DATE
169000200528      *
169100200528     C                   Z-ADD     F3VDDN        ##DATR
169200200528     C                   ENDIF                                                      181721
169300200528      *
169400200528      * Convert Transaction Date to a Midas Day Number
169500200528      *
169600200528     C                   Z-ADD     F3DTYY        @@YY
169700200528     C                   Z-ADD     F3DTMM        @@MM
169800200528     C                   Z-ADD     F3DTDD        @@DD
169900200528     C     DateIn        IFEQ      0
170000200528     C                   Z-ADD     BJRDNB        TransDate
170100200528     C                   ELSE
170200200528     C                   CALLB     'ZDATE10'
170300200528     C                   PARM                    DateIn
170400200528     C                   PARM                    ZZMDNO            5 0
170500200528     C                   MOVE      ZZMDNO        TransDate         5 0
170600200528     C                   END
170700200528      *
170800200528      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
170900200528      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
171000200528      *
171100200528     C     ##DATP        IFLT      BJRDNB
171200200528     C     TransDate     ANDNE     BJRDNB
171300200528     C                   MOVEL     'Y'           ##PPAY
171400200528     C                   ELSE
171500200528     C                   MOVEL     'N'           ##PPAY
171600200528     C                   END
171700200528     C     ##DATR        IFLT      BJRDNB
171800200528     C     TransDate     ANDNE     BJRDNB
171900200528     C                   MOVEL     'Y'           ##PREC
172000200528     C                   ELSE
172100200528     C                   MOVEL     'N'           ##PREC
172200200528     C                   END
172300200528      *
172400200528      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
172500200528      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
172600200528      *
172700200528     C     ##PAYS        IFNE      *blank
172800200528     C     ##RECS        ORNE      *blank
172900200528     C                   GOTO      EDETP@S
173000200528     C                   END
173100200528      *
173200200528      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
173300200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
173400200528      *
173500200528     C                   MOVEL     F3PAY         FLPAY
173600200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(F3PAY:1:2)                      CGL029
173700200528     C                   EVAL      %SUBST(FLPAY:3:18) = F3PONS                                CGL029
173800200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(F3PAY:15:545)                CGL029
173900200528     C                   MOVEL     F3POBR        FLPOBR
174000200528     C                   MOVEL     F3CVMR        FLCVMR
174100200528     C                   MOVEL     F3PSCY        FLPSCY
174200200528     C                   MOVEL     F3IC72        FLIC72
174300200528      *
174400200528      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
174500200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
174600200528      *
174700200528     C                   MOVEL     F3REC         FLREC
174800200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(F3REC:1:2)                      CGL029
174900200528     C                   EVAL      %SUBST(FLREC:3:18) = F3RONS                                CGL029
175000200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(F3REC:15:55)                  CGL029
175100200528     C                   MOVEL     F3ROBR        FLROBR
175200200528     C                   MOVEL     F3RSCY        FLRSCY
175300200528                                                                                              CSW212
175400200528     C                   IF        CSW212 = 'Y'                                               CSW212
175500200528     C                   MOVEL     F3@ISDA       FL@ISDA                                      CSW212
175600200528     C                   ENDIF                                                                CSW212
175700200528      *
175800200528      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
175900200528      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
176000200528      *
176100200528     C     FLPSTM        IFEQ      *ZERO
176200200528     C     ##PPAY        ANDNE     'Y'
176300200528     C     FLRSTM        ANDEQ     *ZERO
176400200528     C     ##PREC        ANDNE     'Y'
176500200528      *
176600200528     C/COPY WNCPYSRC,FXH00023
176700200528     C                   CALLB     'ZASETINDFT'
176800200528      *
176900200528      * INPUTS
177000200528      *
177100200528      * Calling program
177200200528     C                   PARM      'FXDL'        ##CALP            4
177300200528      *
177400200528      * Payment currency
177500200528     C                   PARM      DDSCCY        ##PCCY            3
177600200528      *
177700200528      * Receive currency
177800200528     C                   PARM      DDBCCY        ##RCCY            3
177900200528     ****PY WNCPYSRC,FXFXDLRC16*************************************************CPK018
178000200528     C/COPY WNCPYSRC,FXFXDLPC16                                                 CPK018
178100200528      *
178200200528      * Customer shortname
178300200528     C                   PARM      DDCUST        ##CSNM           10
178400200528      *
178500200528      * Transaction Type
178600200528     C**********         PARM      DDDLTP        ##TTYP            2                          224231
178700200528     C                   PARM                    ##TTYP            2                          224231
178800200528      *
178900200528      * Federal Funds Ind.
179000200528     C                   PARM      DDFEDF        ##FFND            1
179100200528      *
179200200528      ** Version of ISDA Rules govern
179300200528     C                   PARM                    BQISDA            4
179400200528      *
179500200528      ** Type of ISDA agreement
179600200528     C                   PARM                    BQAGTY            6
179700200528      *
179800200528      ** Date of ISDA Agreement
179900200528     C                   PARM                    BQAGDT            6
180000200528      *
180100200528      ** Version of ISDA Agreement
180200200528     C                   PARM                    BQAGVV            2
180300200528      ** Version of ISDA Agreement century                                                    176883
180400200528     C                   PARM                    Blank2            2                          176883
180500200528      ** Deal Subtype                                                                         CSD095
180600200528     C                   PARM      DDDLST        ##DLST            2                          CSD095
180700200528      ** Branch                                                                               CSD095
180800200528     C                   PARM      DDBRSN        ##BRSN            3                          CSD095
180900200528      *
181000200528      ** OUTPUTS
181100200528      *
181200200528      * Payment instructions
181300200528     C                   PARM                    ##PAYF
181400200528      *
181500200528      * Receive instructions
181600200528     C                   PARM                    ##RECF
181700200528      *
181800200528      * FRA/IRS instructions
181900200528     C                   PARM                    ##FRIF
182000200528      *
182100200528     C/COPY WNCPYSRC,FXH00024
182200200528     C                   END
182300200528      *
182400200528      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
182500200528      *
182600200528     C                   CALLB     'ZASETINCVT'
182700200528      *
182800200528      ** INPUTS
182900200528      *
183000200528      ** File Payment Settlement Instruction
183100200528     C                   PARM                    ##PAYF
183200200528      *
183300200528      ** File Receipt Settlement Instruction
183400200528     C                   PARM                    ##RECF
183500200528      *
183600200528      ** File FRA/IRS Settlement Instruction
183700200528     C**********         PARM      *BLANK        ##FRIF                                     AR990243
183800200528     C                   PARM                    ##FRIF                                     AR990243
183900200528      *
184000200528      ** OUTPUTS
184100200528      ** Screen Payment Settlement Instruction
184200200528     C                   PARM      *BLANK        ##PAYS
184300200528      *
184400200528      ** Screen Receipt Settlement Instruction
184500200528     C                   PARM      *BLANK        ##RECS
184600200528      *
184700200528      ** Screen FRA/IRS Settlement Instruction
184800200528     C                   PARM      *BLANK        ##FRIS
184900200528     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
185000200528     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A
185100200528      *
185200200528     C     EDETP@S       ENDSR
185300200528      *****************************************************************
185400200528      /EJECT
185500200528      *****************************************************************
185600200528      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
185700200528      *****************************************************************
185800200528     C     CANC@S        BEGSR
185900200528     ****PY WNCPYSRC,FXFXDLRC07*************************************************CPK018
186000200528     C/COPY WNCPYSRC,FXFXDLPC07                                                 CPK018
186100200528      *
186200200528      * Return to Main Details Screen
186300200528      *
186400200528     C                   MOVEL     'M'           @SCRN
186500200528     ****PY WNCPYSRC,FXFXDLRC08*************************************************CPK018
186600200528     C/COPY WNCPYSRC,FXFXDLPC08                                                 CPK018
186700200528      *
186800200528     C                   ENDSR
186900200528      *****************************************************************
187000200528      /EJECT
187100200528      *****************************************************************
187200200528      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
187300200528      *****************************************************************
187400200528     C     EXIT@S        BEGSR
187500200528      *
187600200528      * IF SETTLEMENT DETAILS INVALID
187700200528      *
187800200528     C     ##RTCD        IFEQ      '*ERRORS'
187900200528      *
188000200528      * RETURN TO MAIN DETAILS SCREEN
188100200528      *
188200200528     C                   MOVEL     'M'           @SCRN
188300200528     C                   ELSE
188400200528      *
188500200528      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
188600200528      *
188700200528     C                   MOVEL     'C'           @SCRN
188800200528      *
188900200528      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
189000200528      *
189100200528     C                   MOVEL     FLPAY         F3PAY
189200200528     C                   EVAL      %SUBST(F3PAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
189300200528     C                   EVAL      F3PONS = %SUBST(FLPAY:3:18)                                CGL029
189400200528     C                   EVAL      %SUBST(F3PAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
189500200528     C                   MOVEL     FLPOBR        F3POBR
189600200528     C                   MOVEL     FLCVMR        F3CVMR
189700200528      *
189800200528      ************                                                                     179510 200400
189900200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
190000200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
190100200528      ************                                                                     179510 200400
190200200528     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
190300200528     C************       MOVE      @@MOPI        F3MOPI                                179510 200400
190400200528     C************       ENDIF                                                         179510 200400
190500200528      ************                                                                     179510 200400
190600200528      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
190700200528      *
190800200528     C                   MOVEL     FLREC         F3REC
190900200528     C                   EVAL      %SUBST(F3REC:1:2) = %SUBST(FLREC:1:2)                      CGL029
191000200528     C                   EVAL      F3RONS = %SUBST(FLREC:3:18)                                CGL029
191100200528     C                   EVAL      %SUBST(F3REC:15:55) = %SUBST(FLREC:21:55)                  CGL029
191200200528     C                   MOVEL     FLROBR        F3ROBR
191300200528      *
191400200528      ************                                                                     179510 200400
191500200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
191600200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
191700200528      ************                                                                     179510 200400
191800200528     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
191900200528     C************       MOVE      @@MORI        F3MORI                                179510 200400
192000200528     C************       ENDIF                                                         179510 200400
192100200528      ************                                                                     179510 200400
192200200528      * UPDATE VALID DEAL: SETTLEMENT CURRENCIES & 'IN' CCY IN FIELD 72
192300200528      *
192400200528     C                   MOVEL     FLRSCY        F3RSCY
192500200528     C                   MOVEL     FLPSCY        F3PSCY
192600200528     C                   MOVEL     FLIC72        F3IC72
192700200528                                                                                              CSW212
192800200528     C                   IF        CSW212 = 'Y'                                               CSW212
192900200528     C                   MOVEL     FL@ISDA       F3@ISDA                                      CSW212
193000200528                                                                                            AR990243
193100200528     C                   IF        FLISDA = *BLANKS                                         AR990243
193200200528     C                   Z-ADD     *ZERO         F3ISDA                                     AR990243
193300200528     C                   ENDIF                                                              AR990243
193400200528                                                                                            AR990243
193500200528     C                   IF        FLAGDT = *BLANKS                                         AR990243
193600200528     C                   Z-ADD     *ZERO         F3AGDT                                     AR990243
193700200528     C                   ENDIF                                                              AR990243
193800200528                                                                                            AR990243
193900200528     C                   IF        FLAGVV = *BLANKS                                         AR990243
194000200528     C                   Z-ADD     *ZERO         F3AGVV                                     AR990243
194100200528     C                   ENDIF                                                              AR990243
194200200528                                                                                            AR990243
194300200528     C                   IF        FLAGVC = *BLANKS                                         AR990243
194400200528     C                   Z-ADD     *ZERO         F3AGVC                                     AR990243
194500200528     C                   ENDIF                                                              AR990243
194600200528                                                                                            AR990243
194700200528     C                   ENDIF                                                                CSW212
194800200528     C                   END
194900200528      *
195000200528     C                   ENDSR
195100200528      *****************************************************************
195200200528      /EJECT
195300200528      *****************************************************************
195400200528      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
195500200528      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
195600200528      *****************************************************************
195700200528     C     SCRN@C        BEGSR
195800200528      *
195900200528      * Prior to validation, initialize error indicators as 'OK'
196000200528      *
196100200528     C                   MOVE      *ALL'Y'       FXEFXD
196200200528     C/COPY WNCPYSRC,FXH00119
196300200528      *
196400200528      * Validate deal details
196500200528      *
196600200528     C                   CALLB     'FXFXDLVAL'
196700200528     C                   PARM                    RespMode
196800200528     C                   PARM                    NwDlScnFmt
196900200528     C                   PARM                    InfData                        CAP051
197000200528     C                   PARM      F3RSCY        @@RSCY
197100200528     C                   PARM      F3RSTM        @@RSTM
197200200528     C                   PARM      F3RONS        @@RONS
197300200528     C                   PARM      F3PSCY        @@PSCY
197400200528     C                   PARM      F3PSTM        @@PSTM
197500200528     C                   PARM      F3PONS        @@PONS
197600200528     C                   PARM      F3FRNT        @@FRNT           20            CPB002
197700200528     C                   PARM                    ExtData                        CAP004
197800200528     C/COPY WNCPYSRC,FXH00199
197900200528     C                   PARM                    DDNBRF
198000200528     C                   PARM                    DDNSRF
198100200528     C                   PARM                    FXEFXD
198200200528     C/COPY WNCPYSRC,FXH00120
198300200528     C                   PARM                    FldNameArr
198400200528     C                   PARM                    MsgIdArr
198500200528     C                   PARM                    MsgDtaArr
198600200528     C                   PARM      *ZERO         Idx               3 0
198700200528     C                   PARM                    WFldNamArr
198800200528     C                   PARM                    WMsgIdArr
198900200528     C                   PARM                    WMsgDtaArr
199000200528     C                   PARM      *ZERO         WIdx              3 0
199100200528     C                   PARM                    NwDlFilFmt
199200200528     ****PY WNCPYSRC,FXFXDLRC12*************************************************CPK018
199300200528     C/COPY WNCPYSRC,FXFXDLPC12                                                 CPK018
199400200528      *
199500200528      * If transaction is valid output message 'Press enter to accept'
199600200528      *
199700200528     C     Idx           IFEQ      *ZERO
199800200528     C                   MOVEL     '*ANY'        FldNameArr(1)
199900200528     C                   MOVEL     'MMM1030'     MsgIdArr(1)
200000200528     C                   END
200100200528      *                                                                                       185612
200200200528      ** Call routine to output MDDR data                                                     185612
200300200528      *                                                                                       185612
200400200528     C     DDACTN        IFEQ      'I'                                                        185612
200500200528     C     DDACTN        OREQ      'X'                                                        185612
200600200528      *                                                                                       185612
200700200528      ** Set up buy and sell amounts                                                          185612
200800200528      *                                                                                       185612
200900200528     C     F3DAM1        IFLT      0                                                          185612
201000200528     C                   Z-SUB     F3DAM1        BAMT                                         185612
201100200528     C                   ELSE                                                                 185612
201200200528     C                   Z-ADD     F3DAM1        BAMT                                         185612
201300200528     C                   ENDIF                                                                185612
201400200528     C     F3DAM2        IFLT      0                                                          185612
201500200528     C                   Z-SUB     F3DAM2        SAMT                                         185612
201600200528     C                   ELSE                                                                 185612
201700200528     C                   Z-ADD     F3DAM2        SAMT                                         185612
201800200528     C                   ENDIF                                                                185612
201900200528                                                                                              185612
202000200528     C/COPY WNCPYSRC,FXH00068
202100200528     C                   CALLB     'FXMDDRAMT'                                                185612
202200200528                                                                                              185612
202300200528      ** Outputs from this procedure                                                          185612
202400200528      ** ---------------------------                                                          185612
202500200528      ** Return code (10A, returned to caller)                                                185612
202600200528     C                   PARM                    ReturnCode                                   185612
202700200528      ** Maximum Daily Delivery Risk fields:                                                  185612
202800200528     C                   PARM                    DDMDDR           16                          185612
202900200528     C                   PARM                    DDEXP1           16                          185612
203000200528     C                   PARM                    DDEXP2           16                          185612
203100200528     C                   PARM                    DDLIMT            6                          185612
203200200528     C                   PARM                    DDLIM1            3                          185612
203300200528     C                   PARM                    DDLIM2            3                          185612
203400200528     C                   PARM                    DDLIM3            9                          185612
203500200528                                                                                              185612
203600200528      ** Inputs to this procedure                                                             185612
203700200528      ** ------------------------                                                             185612
203800200528                                                                                              185612
203900200528     C** Action code                                                                          185612
204000200528     C                   PARM                    DDACTN                                       185612
204100200528     C** Customer                                                                             185612
204200200528     C                   PARM                    DDCUST                                       185612
204300200528     C** Buy Currency                                                                         185612
204400200528     C                   PARM                    DDBCCY                                       185612
204500200528     C** Sell Currency                                                                        185612
204600200528     C                   PARM                    DDSCCY                                       185612
204700200528     C** Run Day Number from SDBANKPD                                                         185612
204800200528     C                   PARM                    BJRDNB                                       185612
204900200528      ** System Location Code from SDBANKPD                                                   185612
205000200528     C                   PARM                    BJSLCD                                       185612
205100200528      ** Buy Amount                                                                           185612
205200200528     C                   PARM                    BAMT                                         185612
205300200528      ** Sell Amount                                                                          185612
205400200528     C                   PARM                    SAMT                                         185612
205500200528      ** Exposure Management indicator                                                        185612
205600200528     C                   PARM                    BGEXMG                                       185612
205700200528      ** Value Date in day number format                                                      185612
205800200528     C                   PARM                    F3VDDN                                       185612
205900200528      *                                                                                       185612
206000200528      ** Error fields/message IDs/message data (arrays) from/to caller                        185612
206100200528      *                                                                                       185612
206200200528     C                   PARM                    WFldNamArr                                   185612
206300200528     C                   PARM                    WMsgIdArr                                    185612
206400200528     C                   PARM                    WMsgDtaArr                                   185612
206500200528     C                   PARM                    WIdx                                         185612
206600200528      ** Booking Branch                                                                       185612
206700200528     C                   PARM                    DDBRSN                                       185612
206800200528     C/COPY WNCPYSRC,FXH00069
206900200528     C                   ENDIF                                                                185612
207000200528      *
207100200528      * WRITE/READ DISPLAY SCREEN
207200200528      *
207300200528     C                   CALLB     'FXFXDLDSP'
207400200528      *
207500200528      * INPUT PARAMETERS
207600200528      *
207700200528      * RETURN CODE
207800200528     C                   PARM      *BLANK        RetCodeOut
207900200528      *
208000200528      * DEAL (IN SCREEN FORMAT)
208100200528     C                   PARM                    NwDlScnFmt
208200200528      *
208300200528      * NET BUY/SELL REFERENCE
208400200528     C                   PARM                    DDNBRF
208500200528     C                   PARM                    DDNSRF
208600200528      *
208700200528      * DEAL STATUS
208800200528     C                   PARM                    DDSTS            24
208900200528     C/COPY WNCPYSRC,FXH00035
209000200528      *
209100200528      * FIELDS IN ERROR
209200200528     C                   PARM                    FXEFXD
209300200528      *
209400200528      * ERRORS
209500200528     C                   PARM                    FldNameArr
209600200528     C                   PARM                    MsgIdArr
209700200528     C                   PARM                    MsgDtaArr
209800200528      *
209900200528      * WARNINGS
210000200528     C                   PARM                    WFldNamArr
210100200528     C                   PARM                    WMsgIdArr
210200200528     C                   PARM                    WMsgDtaArr
210300200528      *
210400200528      * ENABLED KEY & DETAIL FIELDS
210500200528      *
210600200528     C                   PARM      'N'           @EKYFD
210700200528     C                   PARM      'N'           @EDTFD
210800200528      *
210900200528      * ENABLED FUNCTION KEYS
211000200528     C                   PARM      'N'           @EINKG
211100200528     C                   PARM      'N'           @EINKH
211200200528     C                   PARM      'N'           @EINKJ
211300200528     C                   PARM      'N'           @EINKN
211400200528     C                   PARM      'N'           @EINKP
211500200528      *
211600200528      * SUCCESFUL INSERT DEAL
211700200528     C                   PARM                    @SIDN             6
211800200528      *
211900200528      * OUTPUT PARAMETERS
212000200528      *
212100200528      * FUNCTION KEYS
212200200528     C                   PARM      '0'           @INKC             1
212300200528     C                   PARM      '0'           @INKG             1
212400200528     C                   PARM      '0'           @INKH             1
212500200528     C                   PARM      '0'           @INKJ             1
212600200528     C                   PARM      '0'           @INKL             1
212700200528     C                   PARM      '0'           @INKN             1
212800200528     C                   PARM      '0'           @INKP             1
212900200528     C                   PARM      'N'           WriteOnly         1
213000200528      *                                                                                       185612
213100200528      ** Maximum Daily Delivery Risk fields:                                                  185612
213200200528      *                                                                                       185612
213300200528     C                   PARM                    DDMDDR           16                          185612
213400200528     C                   PARM                    DDEXP1           16                          185612
213500200528     C                   PARM                    DDEXP2           16                          185612
213600200528     C                   PARM                    DDLIM1            3                          185612
213700200528     C                   PARM                    DDLIM2            3                          185612
213800200528     C                   PARM                    DDLIM3            9                          185612
213900200528     ****PY WNCPYSRC,FXFXDLRC09*************************************************CPK018
214000200528     C/COPY WNCPYSRC,FXFXDLPC09                                                 CPK018
214100200528      *
214200200528      * RESET ERRORS
214300200528      *
214400200528     C                   MOVE      *ALL'Y'       FXEFXD
214500200528     C                   MOVEL     *BLANK        FldNameArr
214600200528     C                   MOVEL     *BLANK        MsgIdArr
214700200528     C                   MOVEL     *BLANK        MsgDtaArr
214800200528     C                   MOVEL     *BLANK        WFldNamArr
214900200528     C                   MOVEL     *BLANK        WMsgIdArr
215000200528     C                   MOVEL     *BLANK        WMsgDtaArr
215100200528      *
215200200528      * CK/3 - END PROGRAM
215300200528      *
215400200528     C     @INKC         CASEQ     '1'           ENDP
215500200528      *
215600200528      * CK/12 - CANCEL ON CONFIRMATION SCREEN
215700200528      *
215800200528     C     @INKL         CASEQ     '1'           CANC@C
215900200528      *
216000200528      * EXIT CONFIRMATION SCREEN
216100200528      *
216200200528     C                   CAS                     EXIT@C
216300200528     C                   END
216400200528      *
216500200528     C                   ENDSR
216600200528      *****************************************************************
216700200528      /EJECT
216800200528      *****************************************************************
216900200528      * CANC@C - CANCEL ON CONFIRMATION SCREEN
217000200528      *****************************************************************
217100200528     C     CANC@C        BEGSR
217200200528      *
217300200528      * RETURN TO MAIN DETAILS SCREEN
217400200528      *
217500200528     C                   MOVEL     'M'           @SCRN
217600200528      *
217700200528     C                   ENDSR
217800200528      *****************************************************************
217900200528      /EJECT
218000200528      *****************************************************************
218100200528      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
218200200528      *****************************************************************
218300200528     C     EXIT@C        BEGSR
218400200528      *
218500200528      * IF NO ERRORS IN VALIDATION
218600200528      *
218700200528     C     Idx           IFEQ      *ZERO
218800200528      *
218900200528      * CONTINUE WITH UPDATES
219000200528      *
219100200528     C                   MOVEL     'U'           @SCRN
219200200528      *
219300200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
219400200528      *
219500200528     C                   ELSE
219600200528     C                   MOVEL     'M'           @SCRN
219700200528     C                   END
219800200528      *
219900200528     C                   ENDSR
220000200528      *****************************************************************
220100200528      /EJECT
220200200528      *****************************************************************
220300200528      * UPDATS - UPDATES
220400200528      *****************************************************************
220500200528     C     UPDATS        BEGSR
220600200528      *
220700200528      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
220800200528      * GET NEXT AVAILABLE DEAL NUMBER
220900200528     ****PY WNCPYSRC,FXFXDLRC18*************************************************CPK018
221000200528     C/COPY WNCPYSRC,FXFXDLPC18                                                 CPK018
221100200528      *
221200200528     C     DDDLNO        IFEQ      *BLANK
221300200528      *
221400200528     C     I#DDDLNO      IFNE      *BLANK
221500200528     C                   MOVEL     I#DDDLNO      DDDLNO
221600200528     C                   ELSE
221700200528     C                   CALLB     'CAGETNXTDL'
221800200528     C                   PARM      *BLANKS       RetCodeOut
221900200528     C                   PARM      *BLANKS       @@MSG1            7
222000200528     C                   PARM                    DDDLNO
222100200528     C                   PARM      *ZERO         F3DN38
222200200528      *
222300200528      * DATABASE ERROR
222400200528      *
222500200528     C     @@MSG1        IFNE      *BLANK
222600200528     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
222700200528     C                   MOVEL     '002'         DBASE                          * DBERR 002*
222800200528     C                   MOVEL     DDDLNO        DBKEY                          ************
222900200528     C                   EXSR      *PSSR
223000200528     C                   END
223100200528     C                   END
223200200528     C                   MOVEL     DDDLNO        @SIDN
223300200528     C                   END
223400200528      *
223500200528      * UPDATE VALID DEAL: DEAL NUMBER
223600200528      *
223700200528     C                   MOVEL     DDDLNO        F3DN38
223800200528      *
223900200528      * UPDATE VALID DEAL: LAST ACTION CODE
224000200528      *
224100200528     C                   MOVEL     DDACTN        F3LACT
224200200528      *
224300200528      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
224400200528      *
224500200528     C                   MOVEL     @FOTRANSEL    F3FRNT
224600200528      *
224700200528      * UPDATE VALID DEAL: FRONT OFFICE ASSOCIATED TRANSACTION ID
224800200528      *
224900200528     C                   MOVEL     @FOASOCSEL    F3AFRT
225000200528      *
225100200528      * FOREIGN EXCHANGE DATABASE UPDATES
225200200528      *
225300200528     C                   CALLB     'FXFXDLUPF'
225400200528     C                   PARM      *BLANK        @RTCD             7
225500200528     C                   PARM                    NwDlFilFmt
225600200528     ****PY WNCPYSRC,FXFXDLRC15*************************************************CPK018
225700200528     C/COPY WNCPYSRC,FXFXDLPC15                                                 CPK018
225800200528      *
225900200528      * DEALS UPDATES
226000200528      *
226100200528     C     @RTCD         IFEQ      *BLANK
226200200528     C                   CALLB     'FXFXDLUPD'
226300200528     C                   PARM                    @RTCD
226400200528     C                   PARM                    NwDlFilFmt
226500200528     C/COPY WNCPYSRC,FXH00249
226600200528     C                   END
226700200528     ****PY WNCPYSRC,FXFXDLRC17*************************************************CPK018
226800200528     C/COPY WNCPYSRC,FXFXDLPC17                                                 CPK018
226900200528      *
227000200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
227100200528      * UPDATES AND END THIS PROGRAM.
227200200528      * OTHERWISE DELETE THE INVALID FX DEAL ACTIONED & COMMIT THE UPDATES
227300200528      *
227400200528     C     @RTCD         IFNE      *BLANK
227500200528     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
227600200528     C     @RTCD         IFEQ      '*RECUPD'                                                  251029
227700200528     C     @RTCD         OREQ      '*RECLCK'                                                  251029
227800200528     C                   ROLBK                                                                251029
227900200528     C                   ELSE                                                                 251029
228000200528     C                   If        CSC022 = 'N'                                               CSC022
228100200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
228200200528     C*
228300200528     C                   ROLBK
228400200528     C                   Else                                                                 CSC022
228500200528     C                   SETON                                        U7U8                    CSC022
228600200528     C                   Endif                                                                CSC022
228700200528     C                   ENDIF                                                                251029
228800200528     C     @RTCD         IFNE      '*RECUPD'                                    168345
228900200528     C     @RTCD         ORNE      '*RECLCK'                                                  251029
229000200528     C                   EXSR      *PSSR
229100200528     C                   ENDIF                                                  168345
229200200528     C                                                                          CAP006
229300200528     C                   ELSE
229400200528                                                                                              244036
229500200528      ** Add record within Deals Master Extension File (done from Java layer).                244036
229600200528     C**********         IF        DDACTN = 'I'                                         244036247888
229700200528     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
229800200528     C                   EXSR      WriteDLDLDB                                                244036
229900200528     C                   END                                                                  244036
230000200528                                                                                              244036
230100200528     C     ZATRNKD0      CHAIN     FXIFXDLD0                          99
230200200528     C  N99              DELETE    FXIFXDLD0
230300200528     C     APDSETK0      CHAIN     APIDSETD0                          99
230400200528     C  N99              DELETE    APIDSETD0
230500200528     C/COPY WNCPYSRC,FXH00121
230600200528                                                                                              CSC011
230700200528      ** Delete invalid record from the log file.                                             CSC011
230800200528                                                                                              CSC011
230900200528     C                   IF        (CSC011 = 'Y') and (S1SUPP = LIBR)                         CSC011
231000200528                                                                                              CSC011
231100200528     C                   EVAL      KMsgType = 'FXFXDL'                                        CSC011
231200200528     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
231300200528     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
231400200528                                                                                              CSC011
231500200528     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
231600200528     C                   IF        *IN99 = *OFF                                               CSC011
231700200528     C                   DELETE    APILOGL0                                                   CSC011
231800200528     C                   ENDIF                                                                CSC011
231900200528     C                   ENDIF                                                                CSC011
232000200528                                                                                              CSC011
232100200528     C                   If        CSC022 = 'N'                                               CSC022
232200200528     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
232300200528     C                   COMMIT
232400200528     C                   Endif                                                                CSC022
232500200528     ****PY WNCPYSRC,FXFXDLRC14*************************************************CPK018
232600200528     C/COPY WNCPYSRC,FXFXDLPC14                                                 CPK018
232700200528     C                   END
232800200528      *
232900200528      * If error occurred in updating last transaction set on flag to           CAP006
233000200528      * display message on 'browse' screen.                                     CAP006
233100200528     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
233200200528     C                   MOVE      'Y'           @ERRUP                         CAP006
233300200528     C                   ELSE                                                                 251029
233400200528      *                                                                                       251029
233500200528      ** If error was due to locking display message on main screen to                        251029
233600200528      ** retain values already inserted/amended by the user on repair.                        251029
233700200528      *                                                                                       251029
233800200528     C     @RTCD         IFEQ      '*RECLCK'                                                  251029
233900200528      *                                                                                       251029
234000200528     C     DDACTN        IFEQ      'I'                                                        251029
234100200528     C                   MOVE      *BLANKS       DDDLNO                                       251029
234200200528     C                   MOVE      *BLANKS       @SIDN                                        251029
234300200528     C                   ENDIF                                                                251029
234400200528      *                                                                                       251029
234500200528     C                   MOVEL     '*ANY'        FldNameArr(1)                                251029
234600200528     C                   MOVEL     'MMM1068'     MsgIdArr(1)                                  251029
234700200528     C                   MOVE      *BLANKS       SAVRDNB           1                          251029
234800200528     C                   MOVE      @RDNB         SAVRDNB                                      251029
234900200528     C                   MOVE      *BLANKS       @RDNB                                        251029
235000200528      *                                                                                       251029
235100200528     C                   ELSE                                                   CAP006
235200200528     C                   MOVE      'N'           @ERRUP                         CAP006
235300200528      *                                                                                       251029
235400200528     C     SAVRDNB       IFNE      *BLANKS                                                    251029
235500200528     C                   MOVE      SAVRDNB       @RDNB                                        251029
235600200528     C                   ENDIF                                                                251029
235700200528      *                                                                                       251029
235800200528     C                   END                                                    CAP006
235900200528     C                                                                          CAP006
236000200528      *                                                                                       251029
236100200528     C                   END                                                                  251029
236200200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
236300200528      *
236400200528     C     @RDNB         IFEQ      'Y'
236500200528     C                   MOVEL     'R'           @SCRN
236600200528     C                   ELSE
236700200528      *
236800200528      * ELSE, RETURN TO THE BROWSE SCREEN
236900200528      *
237000200528     C     @RTCD         IFEQ      '*RECLCK'                                                  251029
237100200528     C                   MOVEL     'M'           @SCRN                                        251029
237200200528     C                   ELSE                                                                 251029
237300200528     C                   MOVEL     'B'           @SCRN
237400200528      *                                                                                       251029
237500200528     C                   ENDIF                                                                251029
237600200528      *                                                                                       251029
237700200528     C                   END
237800200528      *
237900200528     C                   ENDSR
238000200528      *****************************************************************
238100200528      /EJECT
238200200528      *****************************************************************
238300200528      * ENDP - END PROGRAM
238400200528      *****************************************************************
238500200528     C     ENDP          BEGSR
238600200528     C                   MOVEL     'T'           @SCRN
238700200528     C                   ENDSR
238800200528      *****************************************************************
238900200528      /EJECT                                                                    CAP011
239000200528      *****************************************************************         CAP011
239100200528      *                                                               *         CAP011
239200200528      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
239300200528      *                                                               *         CAP011
239400200528      *****************************************************************         CAP011
239500200528                                                                                CAP011
239600200528     C     TDtDtaSubs    BEGSR                                                  CAP011
239700200528                                                                                CAP011
239800200528     C                   RESET                   ReturnCode                     CAP011
239900200528     C                   CALLB     'APDTASUBS'                                  CAP011
240000200528                                                                                CAP011
240100200528      * Return Code                                                             CAP011
240200200528     C                   PARM                    ReturnCode       10            CAP011
240300200528      * Substitution character                                                  CAP011
240400200528     C                   PARM      GHSUBS        SubsChar          1            CAP011
240500200528      * Incoming Data                                                           CAP011
240600200528     C                   PARM      NwDlScnFmt    IncDATA        2000            CAP011
240700200528      * Current Data                                                            CAP011
240800200528     C                   PARM      CrDlScnfmt    CurDATA        2000            CAP011
240900200528                                                                                CAP011
241000200528     C                   MOVEL     IncDATA       NwDlScnFmt                     CAP011
241100200528                                                                                CAP011
241200200528     C                   ENDSR                                                  CAP011
241300200528      *****************************************************************         CAP011
241400200528      /EJECT                                                                    CAP011
241500200528      *****************************************************************         CAP011
241600200528      *                                                               *         CAP011
241700200528      * SetupAmend - Setup Settlement Instructions on Amendment       *         CAP011
241800200528      *                                                               *         CAP011
241900200528      *****************************************************************         CAP011
242000200528                                                                                CAP011
242100200528     C     SetupAmend    BEGSR                                                  CAP011
242200200528                                                                                CAP011
242300200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
242400200528     C                   MOVEL     FHREC         FLREC                          CAP011
242500200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(FHREC:1:2)                      CGL029
242600200528     C                   EVAL      %SUBST(FLREC:3:18) = FHRONS                                CGL029
242700200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(FHREC:15:55)                  CGL029
242800200528     C                   MOVEL     FHROBR        FLROBR                         CAP011
242900200528     C                   MOVEL     FHRSCY        FLRSCY                         CAP011
243000200528     C                   MOVEL     FHPAY         FLPAY                          CAP011
243100200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(FHPAY:1:2)                      CGL029
243200200528     C                   EVAL      %SUBST(FLPAY:3:18) = FHPONS                                CGL029
243300200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(FHPAY:15:545)                CGL029
243400200528     C                   MOVEL     FHPOBR        FLPOBR                         CAP011
243500200528     C                   MOVEL     FHCVMR        FLCVMR                         CAP011
243600200528     C                   MOVEL     FHPSCY        FLPSCY                         CAP011
243700200528     C                   MOVEL     FHIC72        FLIC72                         CAP011
243800200528                                                                                CAP011
243900200528     C                   IF        CSW212 = 'Y'                                               CSW212
244000200528     C                   MOVEL     FH@ISDA       FL@ISDA                                      CSW212
244100200528     C                   ENDIF                                                                CSW212
244200200528                                                                                              CSW212
244300200528     C                   CALLB     'ZASETINCVT'                                 CAP011
244400200528                                                                                CAP011
244500200528      ** Deal Settlement Instructions in file format                            CAP011
244600200528     C                   PARM                    ##PAYF                         CAP011
244700200528     C                   PARM                    ##RECF                         CAP011
244800200528     C**********         PARM      *BLANK        ##FRIF                              CAP011 AR990243
244900200528     C                   PARM                    ##FRIF                                     AR990243
245000200528                                                                                CAP011
245100200528      ** Current Settlement Instruction in input format                         CAP011
245200200528     C                   PARM      *BLANK        CrPaySttmt                     CAP011
245300200528     C                   PARM      *BLANK        CrRecSttmt                     CAP011
245400200528     C                   PARM      *BLANK        CrFRASttmt                     CAP011
245500200528     C                   PARM      FHCCY1        #TRCCY                                      CSF011A
245600200528     C                   PARM      FHCCY2        #TPCCY                                      CSF011A
245700200528                                                                                CAP011
245800200528      *  If no Payment or Receive instructions have been supplied               CAP011
245900200528      *  Default them to those currently on the deal.                           CAP011
246000200528                                                                                CAP011
246100200528     C                   IF            (##PAYS = *blank)                        CAP011
246200200528     C                   EVAL      ##PAYS = CrPaySttmt                          CAP011
246300200528     C                   ENDIF                                                  CAP011
246400200528                                                                                CAP011
246500200528     C                   IF            (##RECS = *blank)                        CAP011
246600200528     C                   EVAL      ##RECS = CrRecSttmt                          CAP011
246700200528     C                   ENDIF                                                  CAP011
246800200528                                                                                CAP011
246900200528     C                   IF            (##FRIS = *blank)                                    AR990243
247000200528     C                   EVAL      ##FRIS = CrFRASttmt                                      AR990243
247100200528     C                   ENDIF                                                              AR990243
247200200528                                                                                            AR990243
247300200528     C                   ENDSR                                                  CAP011
247400200528      *****************************************************************         CAP011
247500200528      /EJECT                                                                    CAP011
247600200528      *****************************************************************         CAP011
247700200528      *                                                               *         CAP011
247800200528      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
247900200528      *                                                               *         CAP011
248000200528      *****************************************************************         CAP011
248100200528                                                                                CAP011
248200200528     C     SDtDtaSubs    BEGSR                                                  CAP011
248300200528                                                                                CAP011
248400200528      ** PAYMENT INSTRUCTIONS                                                   CAP011
248500200528     C                   RESET                   ReturnCode                     CAP011
248600200528     C                   CALLB     'APDTASUBS'                                  CAP011
248700200528                                                                                CAP011
248800200528      * Return Code                                                             CAP011
248900200528     C                   PARM                    ReturnCode                     CAP011
249000200528      * Substitution character                                                  CAP011
249100200528     C                   PARM      GHSUBS        SubsChar                       CAP011
249200200528      * Incoming Data                                                           CAP011
249300200528     C                   PARM      ##PAYS        IncDATA                        CAP011
249400200528      * Current Data                                                            CAP011
249500200528     C                   PARM      CrPaySttmt    CurDATA                        CAP011
249600200528                                                                                CAP011
249700200528     C                   MOVEL     IncDATA       ##PAYS                         CAP011
249800200528                                                                                CAP011
249900200528      ** RECEIPT INSTRUCTIONS                                                   CAP011
250000200528     C                   RESET                   ReturnCode                     CAP011
250100200528     C                   CALLB     'APDTASUBS'                                  CAP011
250200200528                                                                                CAP011
250300200528      * Return Code                                                             CAP011
250400200528     C                   PARM                    ReturnCode                     CAP011
250500200528      * Substitution character                                                  CAP011
250600200528     C                   PARM      GHSUBS        SubsChar                       CAP011
250700200528      * Incoming Data                                                           CAP011
250800200528     C                   PARM      ##RECS        IncDATA                        CAP011
250900200528      * Current Data                                                            CAP011
251000200528     C                   PARM      CrRecSttmt    CurDATA                        CAP011
251100200528                                                                                CAP011
251200200528     C                   MOVEL     IncDATA       ##RECS                         CAP011
251300200528                                                                                CAP011
251400200528      ** Extended Settlement Addtional Details                                              AR990243
251500200528                                                                                            AR990243
251600200528     C                   RESET                   ReturnCode                                 AR990243
251700200528     C                   CALLB     'APDTASUBS'                                              AR990243
251800200528     C                   PARM                    ReturnCode                                 AR990243
251900200528     C                   PARM      GHSUBS        SubsChar                                   AR990243
252000200528     C                   PARM      ##FRIS        IncDATA                                    AR990243
252100200528     C                   PARM      CrFRASttmt    CurDATA                                    AR990243
252200200528     C                   MOVEL     IncDATA       ##FRIS                                     AR990243
252300200528                                                                                            AR990243
252400200528     C                   ENDSR                                                  CAP011
252500200528      *****************************************************************         CAP011
252600200528      /EJECT                                                                                  244036
252700200528      *****************************************************************                       244036
252800200528      *                                                               *                       244036
252900200528      * WriteDLDLDB - WRITE Foreign Exchange Extension record (done   *                       244036
253000200528      *               from Java layer).                               *                       244036
253100200528      *                                                               *                       244036
253200200528      *****************************************************************                       244036
253300200528     C     WriteDLDLDB   BEGSR                                                                244036
253400200528      *                                                                                       244036
253500200528      ** When opening new deals within DEALSDB, write a corresponding                         244036
253600200528      ** record in the Deals details extension file DLDLDBQD.                                 244036
253700200528      *                                                                                       244036
253800200528     C     @KeyDealL5    KLIST                                                                244036
253900200528     C                   KFLD                    F1DLNO                                       244036
254000200528      *                                                                                       244036
254100200528     C                   MOVE      DDDLNO        F1DLNO                                       244036
254200200528     C     @KeyDealL5    CHAIN     DLDLDBD0                           82                      244036
254300200528      *                                                                                       244036
254400200528     C     *IN82         IFEQ      *ON                                                        244036
254500200528     C                   EVAL      F1BRCA = DDBRSN                                            244036
254600200528     C                   WRITE     DLDLDBD0                                                   244036
254700200528                                                                                              244036
254800200528     C                   ENDIF                                                                244036
254900200528                                                                                              244036
255000200528     C                   ENDSR                                                                244036
255100200528      *****************************************************************                       244036
255200200528      /EJECT
255300200528      *****************************************************************
255400200528      * *INZSR - INITIAL PROCESSING
255500200528      *****************************************************************
255600200528     C     *INZSR        BEGSR
255700200528      *
255800200528      ** Initialize program name
255900200528      *
256000200528     C                   MOVEL     'FXIFXDLMNT'  DBPGM
256100200528      *
256200200528      ** ACCESS BANK DETAILS
256300200528      *
256400200528     C                   CALL      'AOBANKR0'
256500200528     C                   PARM      *BLANKS       @RTCD             7
256600200528     C                   PARM      '*FIRST '     @OPTN             7
256700200528     C     SDBANK        PARM      SDBANK        DSFDY
256800200528      *
256900200528      * DATABASE ERROR
257000200528      *
257100200528     C     @RTCD         IFNE      *BLANKS
257200200528     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
257300200528     C                   MOVEL     '901'         DBASE                          * DBERR 901*
257400200528     C                   MOVEL     @OPTN         DBKEY                          ************
257500200528     C                   EXSR      *PSSR
257600200528     C                   END
257700200528      *
257800200528      ** Access Module Details
257900200528      *
258000200528     C                   CALL      'AOMMODR0'
258100200528     C                   PARM      *BLANKS       @RTCD
258200200528     C                   PARM      '*FIRST '     @OPTN
258300200528     C     SDMMOD        PARM      SDMMOD        DSFDY
258400200528      *
258500200528      * DATABASE ERROR
258600200528      *
258700200528     C     @RTCD         IFNE      *BLANKS
258800200528     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
258900200528     C                   MOVEL     '902'         DBASE                          * DBERR 901*
259000200528     C                   MOVEL     @OPTN         DBKEY                          ************
259100200528     C                   EXSR      *PSSR
259200200528     C                   END
259300200528      *                                                                         CAP011
259400200528      ** Access API ICD Details                                                 CAP011
259500200528      *                                                                         CAP011
259600200528     C                   CALLB     'AOAPIR0'                                    CAP011
259700200528     C                   PARM      *BLANKS       @RTCD                          CAP011
259800200528     C                   PARM      '*FIRST '     @OPTN                          CAP011
259900200528     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
260000200528      *                                                                         CAP011
260100200528      * DATABASE ERROR                                                          CAP011
260200200528      *                                                                         CAP011
260300200528     C     @RTCD         IFNE      *BLANKS                                      CAP011
260400200528     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
260500200528     C                   MOVEL     '903'         DBASE                          CAP011
260600200528     C                   MOVEL     @OPTN         DBKEY                          CAP011
260700200528     C                   EXSR      *PSSR                                        CAP011
260800200528     C                   END                                                    CAP011
260900200528      *                                                                                       224231
261000200528      ** Access SAR details file to determine if CDL008 is on.                                224231
261100200528      ** (Continuous Linked Settlement)                                                       224231
261200200528      *                                                                                       224231
261300200528     C                   CALLB     'AOSARDR0'                                                 224231
261400200528     C                   PARM      *BLANKS       @RTCD                                        224231
261500200528     C                   PARM      '*VERIFY'     @OPTN                                        224231
261600200528     C                   PARM      'CDL008'      @SARD                                        224231
261700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        224231
261800200528     C     @RTCD         IFNE      *BLANKS                                                    224231
261900200528     C     @RTCD         ANDNE     '*NRF   '                                                  224231
262000200528     C                   MOVEL     'SCSARDPD'    DBFILE                                       224231
262100200528     C                   MOVEL     '905'         DBASE                                        224231
262200200528     C                   MOVEL     'CDL008'      DBKEY                                        224231
262300200528     C                   EXSR      *PSSR                                                      224231
262400200528     C                   ENDIF                                                                224231
262500200528     C     @RTCD         IFEQ      *BLANKS                                                    224231
262600200528     C                   MOVEL     'Y'           CDL008            1                          224231
262700200528     C                   ELSE                                                                 224231
262800200528     C                   MOVEL     'N'           CDL008                                       224231
262900200528     C                   ENDIF                                                                224231
263000200528      *
263100200528      * Key Lists
263200200528      *
263300200528     C     ZATRNKD0      KLIST
263400200528     C                   KFLD                    @FOTRANSEL
263500200528     C                   KFLD                    @TMESTPSEL
263600200528     C     ZATRNKX0      KLIST
263700200528     C                   KFLD                    @TMESTPSEL
263800200528     C                   KFLD                    @FOTRANSEL
263900200528     C     APDSETK0      KLIST
264000200528     C                   KFLD                    @MSGTYPE
264100200528     C                   KFLD                    @FOTRANSEL
264200200528     C                   KFLD                    @TMESTPSEL
264300200528     C     APDSETKX      KLIST
264400200528     C                   KFLD                    @MSGTYPE
264500200528     C                   KFLD                    @TMESTPSEL
264600200528     C                   KFLD                    @FOTRANSEL
264700200528                                                                                              CSC011
264800200528     C     KAPILOGL0     KLIST                                                                CSC011
264900200528     C                   KFLD                    KMsgType                                     CSC011
265000200528     C                   KFLD                    KFrntOffID                                   CSC011
265100200528     C                   KFLD                    KTimeStamp                                   CSC011
265200200528
265300200528      ** Message Type
265400200528
265500200528     C*******************MOVEL     'FXFXDL'      @MSGTYPE          8            CAP004
265600200528     C                   MOVEL     'FXFXDL'      @MSGTYPE                       CAP004
265700200528
265800200528      ** Get the field number for the action code field; the screen fields
265900200528      ** start from that number.  Subtract one from it to give the value
266000200528      ** to subtract from each field's number.
266100200528     C                   CALLB     'ZACGTFLDNO'
266200200528     C                   PARM                    ReturnCode
266300200528     C                   PARM                    Format
266400200528     C                   PARM                    Field
266500200528     C                   PARM                    FieldNo
266600200528
266700200528     C                   IF        ReturnCode = *blank
266800200528     C                   EVAL      FldOffset = FieldNo - 1
266900200528
267000200528      ** If there was an error default the offset to 13
267100200528     C                   ELSE
267200200528     C                   EVAL      FldOffset = 13
267300200528     C                   ENDIF
267400200528      *
267500200528      * Start on Browse Screen
267600200528      *
267700200528     C                   MOVEL     'B'           @SCRN             1
267800200528      *                                                                         CAP051
267900200528      ** Access SAR details file to determine if CAP051 is on.                  CAP051
268000200528      ** (Automatic Authorisation (MM Part))                                    CAP051
268100200528      *                                                                         CAP051
268200200528     C                   MOVEL     'N'           CAP051                         CAP051
268300200528     C                   CALLB     'AOSARDR0'                                   CAP051
268400200528     C                   PARM      *BLANKS       @RTCD                          CAP051
268500200528     C                   PARM      '*VERIFY'     @OPTN                          CAP051
268600200528     C                   PARM      'CAP051'      @SARD             6            CAP051
268700200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
268800200528      *                                                                         CAP051
268900200528     C     @RTCD         IFEQ      *BLANKS                                      CAP051
269000200528     C                   MOVEL     'Y'           CAP051            1            CAP051
269100200528     C                   ENDIF                                                  CAP051
269200200528      *
269300200528      ** Check if CSC011 is installed                                                         CSC011
269400200528                                                                                              CSC011
269500200528     C                   CALLB     'AOSARDR0'                                                 CSC011
269600200528     C                   PARM      *BLANKS       PRtCd                                        CSC011
269700200528     C                   PARM      '*VERIFY'     POptn                                        CSC011
269800200528     C                   PARM      'CSC011'      PSard                                        CSC011
269900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
270000200528                                                                                              CSC011
270100200528     C                   IF        PRtCd = *Blanks                                            CSC011
270200200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
270300200528     C                   OPEN      APILOGL0                                                   CSC011
270400200528     C                   IN        SDSTAT                                                     CSC011
270500200528     C                   IN        SC24X7                                                     CSC011
270600200528     C                   ELSE                                                                 CSC011
270700200528     C                   EVAL      CSC011 = 'N'                                               CSC011
270800200528     C                   ENDIF                                                                CSC011
270900200528                                                                                              CSC011
271000200528     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
271100200528     C                             (PRtCd <> *Blanks)                                         CSC011
271200200528     C     *LOCK         IN        LDA                                                        CSC011
271300200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
271400200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
271500200528     C                   EVAL      DBASE = 904                                                CSC011
271600200528     C                   OUT       LDA                                                        CSC011
271700200528     C                   EXSR      *PSSR                                                      CSC011
271800200528     C                   ENDIF                                                                CSC011
271900200528                                                                                              CSC022
272000200528      ** Determine if enhancement CSC022 is switched on                                       CSC022
272100200528                                                                                              CSC022
272200200528     C                   CALLB     'AOSARDR0'                                                 CSC022
272300200528     C                   PARM      *BLANKS       PRTCD                                        CSC022
272400200528     C                   PARM      '*VERIFY'     POPTN                                        CSC022
272500200528     C                   PARM      'CSC012'      PSARD                                        CSC022
272600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
272700200528      * Initialize work fields                                                                CSC022
272800200528     C                   Eval      CSC022 = 'N'                                               CSC022
272900200528     C                   Eval      WSkpCom = 'N'                                              CSC022
273000200528      *                                                                                       CSC022
273100200528     C                   If        PRTCD = *Blanks                                            CSC022
273200200528     C                   Eval      CSC022 = 'Y'                                               CSC022
273300200528      *                                                                                       CSC022
273400200528     C                   IN        SCCMTJOB                                                   CSC022
273500200528      *                                                                                       CSC022
273600200528     C                   If        COMITNUM <> 0                                              CSC022
273700200528     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
273800200528     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
273900200528     C                   If        WPos > 0                                                   CSC022
274000200528     C                   Eval      WSkpCom = 'Y'                                              CSC022
274100200528     C                   Endif                                                                CSC022
274200200528     C                   Endif                                                                CSC022
274300200528     C                   Else                                                                 CSC022
274400200528      ** An NRF (No Record Found) return code is valid.                                       CSC022
274500200528      ** Issue database error only for error return codes.                                    CSC022
274600200528     C                   If        PRTCD <> '*NRF'                                            CSC022
274700200528     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
274800200528     C                   Eval      DBKEY = 'CSC022'                                           CSC022
274900200528     C                   Eval      DBASE = 905                                                CSC022
275000200528     C                   EXSR      *PSSR                                                      CSC022
275100200528     C                   EndIf                                                                CSC022
275200200528     C                   EndIf                                                                CSC022
275300200528                                                                                              247888
275400200528     C/COPY WNCPYSRC,FXH00025
275500200528      ** Check if CLE025 is installed                                                         247888
275600200528                                                                                              247888
275700200528     C                   CALL      'AOSARDR0'                                                 247888
275800200528     C                   PARM      *BLANKS       @RTCD                                        247888
275900200528     C                   PARM      '*VERIFY'     @OPTN                                        247888
276000200528     C                   PARM      'CLE025'      @SARD                                        247888
276100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
276200200528                                                                                              247888
276300200528     C     @RTCD         IFEQ      *BLANK                                                     247888
276400200528     C                   MOVEL     'Y'           CLE025            1                          247888
276500200528     C                   ELSE                                                                 247888
276600200528     C                   MOVEL     'N'           CLE025                                       247888
276700200528     C                   ENDIF                                                                247888
276800200528     C/COPY WNCPYSRC,FXH00070
276900200528                                                                                              247888
277000200528                                                                                              CSW212
277100200528      ** Check if SWIFT Changes 2012 (CSW212) is installed                                    CSW212
277200200528                                                                                              CSW212
277300200528     C                   CALL      'SWIF2012'                                                 CSW212
277400200528     C                   PARM      *BLANKS       PRTCD                                        CSW212
277500200528                                                                                              CSW212
277600200528     C                   IF        PRTCD = 'CSW2012'                                          CSW212
277700200528     C                   EVAL      CSW212 = 'Y'                                               CSW212
277800200528     C                   ELSE                                                                 CSW212
277900200528     C                   EVAL      CSW212 = 'N'                                               CSW212
278000200528     C                   ENDIF                                                                CSW212
278100200528
278200200528      *  Hook to enable non-core initial processing to be included
278300200528      ***PY WNCPYSRC,FXFXDLR012*************************************************CPK018
278400200528      /COPY WNCPYSRC,FXFXDLP012                                                 CPK018
278500200528
278600200528     C                   ENDSR
278700200528      *****************************************************************
278800200528      /EJECT
278900200528      *****************************************************************
279000200528      ** Program, module and procedure names for database error processing.
279100200528      ** =================================================================
279200200528      ** The following /COPY sets these values, and also defines LDA as
279300200528      ** an external data area
279400200528      ********************************************************************
279500200528     C/COPY ZACPYSRC,PSSR_ILE
279600200528      ********************************************************************
279700200528**  CPY@
279800200528(c) Finastra International Limited 2001
