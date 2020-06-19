000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Invalid deal amendments repair')              *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  MMDEAMRPR - INVALID DEAL AMENDMENTS REPAIR                   *
001100200528      *                                                               *
001200200528      *  Function:  This function allows invalid deal amendments to be*
001300200528      *             'repaired' and applied to the Midas database.     *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 260173             Date 22May20               *
001800200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200528      *                 MD036070           Date 19Oct15               *
002000200528      *                 CGL165             Date 17Feb15               *
002100200528      *                 CDL096             Date 22Sep14               *
002200200528      *                 CDL094             Date 11Jun14               *
002300200528      *                 CSD095             Date 08Apr14               *
002400200528      *                 CSF011A            Date 28Nov11               *
002500200528      *                 CRE073             Date 06Dec10               *
002600200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002800200528      * Midas Plus 1.4 Base ------------------------------------------*
002900200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003000200528      *                 CSD027             Date 09Dec05               *
003100200528      *                 CLE031             Date 26Apr05               *
003200200528      *                 CDL038             Date 10May05               *
003300200528      *                 CDL022             Date 03Feb04               *
003400200528      *                 CDL020             Date 03Feb04               *
003500200528      *                 CDL017             Date 03Feb04               *
003600200528      *                 CSC022             Date 24Feb04               *
003700200528      *                 CGL029             Date 01Sep03               *
003800200528      *                 CDL010             Date 02Aug02               *
003900200528      * Midas Release 4.01 -------------------------------------------*
004000200528      *                 CSC011             Date 18Sep01               *
004100200528      * Midas Release 4 --------------- Base -------------------------*
004200200528      *                 200400             Date 20Nov01               *
004300200528      *                 192829             Date 04May01               *
004400200528      * Midas DBA 3.05 -----------------------------------------------*
004500200528      *                 CPB002             Date 30Nov00               *
004600200528      * Midas DBA 3.04 -----------------------------------------------*
004700200528      *                 179510             Date 07Nov00               *
004800200528      * Midas DBA 3.03 -----------------------------------------------*
004900200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
005000200528      *                 176883             Date 24Mar00               *
005100200528      * Midas DBA 3.02 -----------------------------------------------*
005200200528      *                 CAP051             Date 12Nov99               *
005300200528      *                 CPB001             Date 01Jun99               *
005400200528      *                 CAP014             Date 10Dec99               *
005500200528      *                 CAP013             Date 07Sep99               *
005600200528      *                 CAP011             Date 07Sep99               *
005700200528      *                 168345             Date 13Oct99               *
005800200528      * Midas DBA 3.00 ---------------- Base -------------------------*
005900200528      *                 CAP006             Date 09Mar99               *
006000200528      *                 144815             Date 06Oct98               *
006100200528      *                 CAP004             Date 01Sep98               *
006200200528      *                 137015             Date 10Jun98               *
006300200528      *                 CAP002  *CREATE    Date 22Sep97               *
006400200528      *                                                               *
006500200528      *---------------------------------------------------------------*
006600200528      *                                                               *
006700200528      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
006800200528      *           parameter mismatch. Apply fix 258724.               *
006900200528      *  MD046248 - Finastra Rebranding                               *
007000200528      *  MD036070 - No way to go back to main deal details screen     *
007100200528      *             after reaching settlement screen.  Introduce new  *
007200200528      *             function key F11.                                 *
007300200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
007400200528      *  CDL096 - Business Day Conventions on MM Deals                *
007500200528      *           (Recompile)                                         *
007600200528      *  CDL094 - Enhance Receive Settlement Instructions             *
007700200528      *           (Recompile)                                         *
007800200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
007900200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
008000200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
008100200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
008200200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
008300200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
008400200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
008500200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
008600200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
008700200528      *           (Recompile)                                         *
008800200528      *  CSC022 - Commitment Control Changes for MidasPlus            *
008900200528      *  CGL029 - Increase Account Code to 10 digits                  *
009000200528      *  CDL010 - Prevent last user that actioned the trade from      *
009100200528      *           authorising it.Recompile due to changes in MMDEAMPP *
009200200528      *  CSC011 - 24x7 Midas Availability                             *
009300200528      *  200400 - Reverse fix 179510                                  *
009400200528      *  192829 - The wrong module name passed to WN0010.             *
009500200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
009600200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
009700200528      *           Midas  Our  Receive/ Pay  Instructions  respectively*
009800200528      *           are not  correctly  updated .  Introduced  new  Data
009900200528      *           Structure  @MORPI  which is used  for that purpose .*
010000200528      *  176883 - Errors found as a result of creating DBAR3.02       *
010100200528      *           Meridian repository file.                           *
010200200528      *           Recompiled due to mismatch between parameter calls  *
010300200528      *           to ZASETINDFT.                                      *
010400200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
010500200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
010600200528      *           Recompiled due to changes in MMDEAMPP               *
010700200528      *  CAP014 - Repair function enhancements                        *
010800200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
010900200528      *  CAP011 - Substitution of Midas database flds for externl i/fs*
011000200528      *  168345 - Prevent two users from accessing same transaction   *
011100200528      *           in repair screen at the same cycle, and converting  *
011200200528      *           it into two different Midas Deal No.s  .            *
011300200528      *           Second user should not be allowed to repair the     *
011400200528      *           transaction and convert it into a another           *
011500200528      *           Midas Deal.                                         *
011600200528      *  CAP006 - Check for deal being updated by another workstation *
011700200528      *  144815 - Blank out not necessary settlement instructions     *
011800200528      *  CAP004 - APIs Phase 3.                                       *
011900200528      *           - Add extra parm for Extra Data                     *
012000200528      *           - Change definition of MSGTYPE to be based on file  *
012100200528      *             field                                             *
012200200528      *  137015 - Repair function not using Midas deal number         *
012300200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
012400200528      *                                                               *
012500200528      *****************************************************************
012600200528      ** +--------------------------------------+
012700200528      ** ¦ F-specs                              ¦
012800200528      ** ¦ =======                              ¦
012900200528      ** +--------------------------------------+
013000200528     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
013100200528
013200200528     FMMIDEAML0 IF   E           K DISK    INFSR(*PSSR)
013300200528     F                                     RENAME(MMIDEAMD0:MMIDEAMX0)
013400200528     FMMIDEAML1 UF   E           K DISK    INFSR(*PSSR)
013500200528     F                                     COMMIT
013600200528
013700200528     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
013800200528     F                                     RENAME(APIDSETD0:APIDSETX0)
013900200528     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
014000200528     F                                     COMMIT
014100200528
014200200528      ** API Invalid log file by Type/FO Id/Time                                              CSC011
014300200528     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
014400200528     F                                     COMMIT                                             CSC011
014500200528                                                                                              CSC011
014600200528     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
014700200528     F                                     INFSR(*PSSR)                                       CSD095
014800200528                                                                                              CSD095
014900200528      * Hook to enable non-core files to be included
015000200528      /COPY WNCPYSRC,MMDEAMR009
015100200528
015200200528      *****************************************************************
015300200528      ** +--------------------------------------+
015400200528      ** ¦ Automatically included D-specs       ¦
015500200528      ** ¦ ==============================       ¦
015600200528      ** +--------------------------------------+
015700200528      **
015800200528      ** Standard D-specs
015900200528      ** ================
016000200528      **
016100200528      ** The following /COPY line includes the LDA layout,
016200200528      ** the copyright array definition,
016300200528      ** and the following named constants:
016400200528      **    True       logical = *on (for indcator processing)
016500200528      **    False      logical = *off (for indcator processing)
016600200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016700200528      **                                    handler)
016800200528      ** and the following variables:
016900200528      **    RunBefore  1A (for the PSSR)
017000200528
017100200528     D/COPY ZACPYSRC,STD_D_SPEC
017200200528
017300200528      ** Include the MM standard declares
017400200528     D/COPY ZACPYSRC,STDDECLARE
017500200528
017600200528      ** Program Status Data Structure
017700200528      ** =============================
017800200528      ** The following /COPY line includes all the defined fields in the
017900200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
018000200528
018100200528     D/COPY ZACPYSRC,PSDS
018200200528
018300200528      **--------------------------------------------------------------------------------------------
018400200528      ** The following /COPY line includes the definitions for error and
018500200528      ** warning message arrays.
018600200528     D/COPY ZACPYSRC,ERR_ARRAYS
018700200528      **--------------------------------------------------------------------------------------------
018800200528
018900200528      ** +--------------------------------------+
019000200528      ** ¦ End of automatically included D-specs¦
019100200528      ** ¦ =====================================¦
019200200528      ** +--------------------------------------+
019300200528
019400200528      *****************************************************************
019500200528      /EJECT
019600200528      *****************************************************************
019700200528
019800200528      ** +--------------------------------------+
019900200528      ** ¦ Manually included D-specs            ¦
020000200528      ** ¦ =========================            ¦
020100200528      ** +--------------------------------------+
020200200528
020300200528      ** +--------------------------------------+
020400200528      ** ¦ Named constants                      ¦
020500200528      ** ¦ ===============                      ¦
020600200528      ** +--------------------------------------+
020700200528
020800200528
020900200528      ** +--------------------------------------+
021000200528      ** ¦ Arrays and Data Structures           ¦
021100200528      ** ¦ ==========================           ¦
021200200528      ** +--------------------------------------+
021300200528
021400200528     D @EI             S              1    DIM(60)
021500200528
021600200528      * Array to hold Commitment Job Names                                                    CSC022
021700200528     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
021800200528                                                                                              CSC022
021900200528      ** Commitment Control Data Area                                                         CSC022
022000200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
022100200528     D  wComitJob              4    103                                                       CSC022
022200200528                                                                                              CSC022
022300200528     D CrDlFilFmt    E DS                  EXTNAME(MMDEAMPP)
022400200528      * Current Deal in File Format
022500200528     D  HNREC                300    368                                         CAP011
022600200528     D  HNPAY                369    927                                         CAP011
022700200528
022800200528     D CrDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
022900200528      * (Current) Deal in Screen Format
023000200528     D                                     PREFIX(@)
023100200528
023200200528     D NwDlFilFmt    E DS                  EXTNAME(MMVDEAMPD)
023300200528     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
023400200528     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
023500200528     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
023600200528     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
023700200528     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
023800200528     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
023900200528      * New Deal in File Format
024000200528     D  IGREC                300    368
024100200528     D  IGPAY                369    927
024200200528
024300200528     D NwDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
024400200528      * New Deal in Screen Format
024500200528
024600200528     D MMEDEAM       E DS                  EXTNAME(MMEDEAMPD)
024700200528      * Error indicators
024800200528
024900200528
025000200528     D ##RECF        E DS                  EXTNAME(SDESFRPD)
025100200528      ** FILE RECEIVE INSTRUCTIONS
025200200528     D***FLREC                  1     69                                                      CGL029
025300200528     D  FLREC                  1     75                                                       CGL029
025400200528
025500200528     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
025600200528      *** FILE PAYMENT INSTRUCTIONS
025700200528     D***FLPAY                  1    559                                                      CGL029
025800200528     D  FLPAY                  1    565                                                       CGL029
025900200528
026000200528     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
026100200528      ** FILE FRA/IRS INSTRUCTIONS
026200200528
026300200528     D ##RECS        E DS                  EXTNAME(SDESSRPD)
026400200528      ** SCREEN RECEIVE INSTRUCTIONS
026500200528
026600200528     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
026700200528      ** SCREEN PAYMENT INSTRUCTIONS
026800200528
026900200528     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
027000200528      ** SCREEN FRA/IRS INSTRUCTIONS
027100200528
027200200528     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
027300200528      * Pay Settlement Instructions - Current                                   CAP011
027400200528                                                                                CAP011
027500200528     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
027600200528      * Receive Settlement Instructions - Current                               CAP011
027700200528                                                                                CAP011
027800200528     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
027900200528      * FRA/IRS Settlement Instructions - Current                               CAP011
028000200528                                                                                CAP011
028100200528     D @SETIN          DS
028200200528      ** Receive / Pay Settlement Currency, Method & Nostro
028300200528     D  @@RSCY                 1      3
028400200528     D  @@RSTM                 4      5  0
028500200528     D***@@RONS                 6     17                                                      CGL029
028600200528     D***@@PSCY                18     20                                                      CGL029
028700200528     D***@@PSTM                21     22  0                                                   CGL029
028800200528     D***@@PONS                23     34                                                      CGL029
028900200528     D  @@RONS                 6     23                                                       CGL029
029000200528     D  @@PSCY                24     26                                                       CGL029
029100200528     D  @@PSTM                27     28  0                                                    CGL029
029200200528     D  @@PONS                29     46                                                       CGL029
029300200528
029400200528     D                 DS
029500200528      **  Data structure for date in, to change format.
029600200528     D  DateIn                 1      8  0
029700200528     D  @@YY                   1      4  0
029800200528     D  @@MM                   5      6  0
029900200528     D  @@DD                   7      8  0
030000200528
030100200528     D                 DS
030200200528     D**  Data Structure to format date parameter passed to mm0085
030300200528     D  @PDAT                  1      8  0
030400200528     D  @PDYY                  1      4  0
030500200528     D  @PYEAR                 3      4  0
030600200528     D  @PDMM                  5      6  0
030700200528     D  @PDDD                  7      8  0
030800200528     D*
030900200528     D                 DS
031000200528     D**  Data Structure for screen value date
031100200528     D  @VDAT                  1      6
031200200528     D  @DSPD                  1      2
031300200528     D  @DSPM                  3      4
031400200528     D  @DSPY                  5      6
031500200528
031600200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
031700200528      ** EXTERNAL DS FOR BANK DETAILS
031800200528
031900200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
032000200528      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
032100200528                                                                                CAP051
032200200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
032300200528      ** EXTERNAL DS FOR SAR DETAILS                                            CAP051
032400200528
032500200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
032600200528      ** EXTERNAL DS FOR API ICD                                                CAP011
032700200528                                                                                CAP011
032800200528     D DSFDY         E DS                  EXTNAME(DSFDY)
032900200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
033000200528                                                                                CAP051
033100200528     D*@MORPI*****     DS                                                              179510 200400
033200200528      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
033300200528     D**@@MORI****             1     12                                                179510 200400
033400200528     D**@@MOPI****            13     24                                                179510 200400
033500200528      ************                                                                     179510 200400
033600200528     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
033700200528     D                                     PREFIX(IF_)                          CAP051
033800200528      * MM (LDNI) Extra Data - File (D/B) format                                CAP051
033900200528                                                                                CAP004
034000200528     D ExtData       E DS                  EXTNAME(MMDAEXPD)                    CAP004
034100200528      * MM DEAM Extra Data - File (D/B) format                                  CAP004
034200200528
034300200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
034400200528      ** 24X7 status data area                                                                CSC011
034500200528                                                                                              CSC011
034600200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
034700200528      ** SD data area                                                                         CSC011
034800200528                                                                                              CSC011
034900200528     D/COPY QWINDSRC,MMDEAMSDTA
035000200528
035100200528      ** +--------------------------------------+
035200200528      ** ¦ Declared variables                   ¦
035300200528      ** ¦ ==================                   ¦
035400200528      ** +--------------------------------------+
035500200528
035600200528      **   Timestamp selected
035700200528     D @TMESTPSEL      S             26Z
035800200528
035900200528      ** Response Mode, passed as a constant parameter to the VAL module
036000200528      ** This is always 'S' for Synchronous
036100200528     D RespMode        S              1A   INZ('S')
036200200528
036300200528      ** -------------------------------------------------------------------
036400200528      ** Fields for getting the starting field number from file (parameters
036500200528      ** to ZAGETFLDNO, plus the offset to the requested field).
036600200528     D Format          S             10A   INZ('MMDEAMPD')
036700200528
036800200528     D Field           S             10A   INZ('DDACTN')
036900200528
037000200528     D FieldNo         S              5P 0
037100200528
037200200528     D FldOffset       S              5P 0
037300200528
037400200528      ** End of fields for getting starting field number
037500200528      ** -------------------------------------------------------------------
037600200528
037700200528      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
037800200528      ** of the file field when the file field was changed.                     CAP004
037900200528     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
038000200528                                                                                              CSC011
038100200528     D CSC011          S              1A   INZ('N')                                           CSC011
038200200528     D KMsgType        S              8A                                                      CSC011
038300200528     D KFrntOffID      S             20A                                                      CSC011
038400200528     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
038500200528     D PRTCD           S              7A                                                      CSC011
038600200528     D POPTN           S              7A                                                      CSC011
038700200528     D PSARD           S              6A                                                      CSC011
038800200528
038900200528      ** Work variables for CSC022                                                            CSC022
039000200528     D CSC022          S              1A   INZ('N')                                           CSC022
039100200528     D wCommitSkip     S              1A   INZ('N')                                           CSC022
039200200528                                                                                              CSC022
039300200528     D InRCCY          S              3A                                                     CSF011A
039400200528     D InPCCY          S              3A                                                     CSF011A
039500200528
039600200528      ** +--------------------------------------+
039700200528      ** ¦ End of D-specs                       ¦
039800200528      ** ¦ ==============                       ¦
039900200528      ** +--------------------------------------+
040000200528
040100200528      ** +----------------------------------------+
040200200528      ** ¦ Hook for non-core D-specs (all types)  ¦
040300200528      ** ¦ also any I-specs (if necessary)        ¦
040400200528      ** ¦ =====================================  ¦
040500200528      ** +----------------------------------------+
040600200528      /COPY WNCPYSRC,MMDEAMR010
040700200528
040800200528      *****************************************************************
040900200528      /EJECT
041000200528      *****************************************************************
041100200528     C
041200200528      ** +--- Start of Main processing -----------------------------------+
041300200528      ** ¦                                                                ¦
041400200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
041500200528      ** ¦ executed at program activation.                                ¦
041600200528      ** ¦                                                                ¦
041700200528      ** +----------------------------------------------------------------+
041800200528
041900200528      /COPY WNCPYSRC,MMDEAMR001
042000200528      *
042100200528      * DO SCREEN: BROWSE INVALID DEALS
042200200528      *
042300200528     C     @SCRN         IFEQ      'B'
042400200528     C                   EXSR      SCRN@B
042500200528     C                   END
042600200528
042700200528      /COPY WNCPYSRC,MMDEAMR002
042800200528
042900200528      *
043000200528      * READ NEXT BROWSE SUBFILE RECORD
043100200528      *
043200200528     C     @SCRN         IFEQ      'R'
043300200528     C                   EXSR      RDNBRW
043400200528     C                   END
043500200528
043600200528      /COPY WNCPYSRC,MMDEAMR003
043700200528
043800200528      *
043900200528      * DO WHILE SCREEN: MAIN DETAILS
044000200528      *
044100200528     C     @SCRN         DOWEQ     'M'
044200200528     C                   EXSR      SCRN@M
044300200528     C                   END
044400200528
044500200528      /COPY WNCPYSRC,MMDEAMR004
044600200528
044700200528      *
044800200528      * SCREEN: WINDOW
044900200528      *
045000200528     C     @SCRN         IFEQ      'W'
045100200528     C                   EXSR      WINDOW
045200200528     C                   END
045300200528
045400200528      /COPY WNCPYSRC,MMDEAMR005
045500200528
045600200528      *
045700200528      * DO WHILE SCREEN: SETTLEMENT DETAILS
045800200528      *
045900200528     C     @SCRN         DOWEQ     'S'
046000200528     C                   EXSR      SCRN@S
046100200528     C                   END
046200200528
046300200528      /COPY WNCPYSRC,MMDEAMR006
046400200528
046500200528      *
046600200528      * SCREEN: CONFIRMATION OF INPUT
046700200528      *
046800200528     C     @SCRN         IFEQ      'C'
046900200528     C                   EXSR      SCRN@C
047000200528     C                   END
047100200528
047200200528      /COPY WNCPYSRC,MMDEAMR007
047300200528
047400200528      *
047500200528      * DO FILE UPDATES
047600200528      *
047700200528     C     @SCRN         IFEQ      'U'
047800200528     C                   EXSR      UPDATS
047900200528     C                   END
048000200528
048100200528      /COPY WNCPYSRC,MMDEAMR008
048200200528
048300200528      *
048400200528      * TERMINATE PROGRAM
048500200528      *
048600200528     C     @SCRN         IFEQ      'T'
048700200528     C                   MOVE      '1'           *INLR
048800200528     C                   END
048900200528      *****************************************************************
049000200528
049100200528      * Hook to enable non-core subroutines to be included
049200200528      /COPY WNCPYSRC,MMDEAMR011
049300200528
049400200528      /EJECT
049500200528      *****************************************************************
049600200528      * SCRN@B - BROWSE INVALID DEALS
049700200528      *****************************************************************
049800200528     C     SCRN@B        BEGSR
049900200528      *
050000200528      * RESET READ NEXT BROWSE SUBFILE RECORD
050100200528      *
050200200528     C                   MOVEL     *BLANK        @RDNB             1
050300200528      *
050400200528      * BUILD BROWSE SUBFILE
050500200528      *
050600200528     C                   CALLB     'MMDEAMRPB'
050700200528      *
050800200528      * INPUT PARAMETERS
050900200528      *
051000200528      * RETURN CODE
051100200528     C                   PARM      *BLANK        RetCodeOut
051200200528      *
051300200528      * BUILD SUB-FILE
051400200528     C                   PARM      'Y'           @BDSFL            1
051500200528      *
051600200528      * READ SUBFILE RECORD
051700200528     C                   PARM      *BLANK        @RDSFL            1
051800200528      *
051900200528      * Error in update of previous deal                                        CAP006
052000200528     C                   PARM                    @ERRUP            1            CAP006
052100200528      *                                                                         CAP006
052200200528      * OUTPUT PARAMETERS
052300200528      *
052400200528      * ERROR MESSAGE
052500200528     C                   PARM      *BLANK        @ERRMS            7
052600200528      *
052700200528      * OPTION SELECTED
052800200528     C                   PARM                    @OPSEL            1
052900200528      *
053000200528      * ACTION SELECTED
053100200528     C                   PARM                    @ACSEL            1
053200200528      *
053300200528      * FO TRANSACTION ID SELECTED
053400200528     C                   PARM                    @FOTRANSEL       20
053500200528      *
053600200528      * FO ASSOCIATED TRANSACTION ID SELECTED
053700200528     C                   PARM                    @FOASOCSEL       20
053800200528      *
053900200528      * DEAM NO SELECTED
054000200528     C                   PARM      *BLANK        @DLNOSEL          6
054100200528      *
054200200528      * VALUE DATE SELECTED
054300200528     C                   PARM      *BLANK        @VDATSEL          6
054400200528      *
054500200528      * SEQUENCE NO SELECTED
054600200528     C                   PARM      *BLANK        @DS38SEL          3
054700200528      *
054800200528      * TIMESTAMP OF TRANSACTION SELECTED
054900200528     C                   PARM                    @TMESTPSEL
055000200528      *
055100200528      * COMMAND KEYS
055200200528     C                   PARM      '0'           @INKC             1
055300200528     C                   PARM      '0'           @INKL             1
055400200528      *                                                                                       CSC011
055500200528     C                   PARM                    CSC011                                       CSC011
055600200528      *
055700200528      * If error set on extenal switches
055800200528      *
055900200528     C     @ERRMS        IFNE      *BLANK
056000200528     C                   MOVE      '1'           *INU6
056100200528     C                   END
056200200528      *
056300200528      * If CK/3 or CK/12 taken in browse, or error message
056400200528      * End program
056500200528      *
056600200528     C     @INKC         IFEQ      '1'
056700200528     C     @INKL         OREQ      '1'
056800200528     C     @ERRMS        ORNE      *BLANK
056900200528     C                   EXSR      ENDP
057000200528     C                   GOTO      ESCRN@B
057100200528     C                   END
057200200528      *
057300200528      * Read next browse subfile record
057400200528      *
057500200528     C                   MOVE      'Y'           @RDNB
057600200528     C                   MOVE      'R'           @SCRN
057700200528      *
057800200528     C     ESCRN@B       ENDSR
057900200528      *****************************************************************
058000200528      /EJECT
058100200528      *****************************************************************
058200200528      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
058300200528      *****************************************************************
058400200528     C     RDNBRW        BEGSR
058500200528      *
058600200528      * READ NEXT SUBFILE RECORD
058700200528      *
058800200528     C                   CALLB     'MMDEAMRPB'
058900200528      *
059000200528      * INPUT PARAMETERS
059100200528      *
059200200528      * RETURN CODE
059300200528     C                   PARM      *BLANK        RetCodeOut
059400200528      *
059500200528      * BUILD SUB-FILE
059600200528     C                   PARM      *BLANK        @BDSFL            1
059700200528      *
059800200528      * READ SUBFILE RECORD
059900200528     C                   PARM      'Y'           @RDSFL            1
060000200528      *
060100200528      * Error in update of previous deal                                        CAP006
060200200528     C                   PARM                    @ERRUP            1            CAP006
060300200528      *                                                                         CAP006
060400200528      * OUTPUT PARAMETERS
060500200528      *
060600200528      * ERROR MESSAGE
060700200528     C                   PARM      *BLANK        @ERRMS            7
060800200528      *
060900200528      * OPTION SELECTED
061000200528     C                   PARM      *BLANK        @OPSEL            1
061100200528      *
061200200528      * ACTION SELECTED
061300200528     C                   PARM      *BLANK        @ACSEL            1
061400200528      *
061500200528      * FO TRANSACTION ID SELECTED
061600200528     C                   PARM      *BLANK        @FOTRANSEL       20
061700200528      *
061800200528      * FO ASSOCIATED TRANSACTION ID SELECTED
061900200528     C                   PARM      *BLANK        @FOASOCSEL       20
062000200528      *
062100200528      * DEAM NO SELECTED
062200200528     C                   PARM                    @DLNOSEL
062300200528      *
062400200528      * VALUE DATE SELECTED
062500200528     C                   PARM                    @VDATSEL
062600200528      *
062700200528      * SEQUENCE NO SELECTED
062800200528     C                   PARM                    @DS38SEL
062900200528      *
063000200528      * TIMESTAMP OF TRANSACTION SELECTED
063100200528     C                   PARM                    @TMESTPSEL
063200200528      *
063300200528      * COMMAND KEYS
063400200528     C                   PARM      '0'           @INKC             1
063500200528     C                   PARM      '0'           @INKL             1
063600200528      *                                                                                       CSC011
063700200528     C                   PARM                    CSC011                                       CSC011
063800200528      *                                                                         CAP004
063900200528      * If CK/3 taken within invalid transaction deletion function,             CAP004
064000200528      * End program                                                             CAP004
064100200528      *                                                                         CAP004
064200200528     C     @INKC         IFEQ      '1'                                          CAP004
064300200528     C                   EXSR      ENDP                                         CAP004
064400200528     C                   GOTO      ERDNBRW                                      CAP004
064500200528     C                   END                                                    CAP004
064600200528      *
064700200528      * IF INVALID DEAL READ FROM SUBFILE
064800200528      *
064900200528     C     @OPSEL        IFNE      *BLANK
065000200528      *
065100200528      * BLANK THE MAIN DETAILS SCREEN
065200200528      *
065300200528     C                   MOVEL     *BLANK        NwDlScnFmt
065400200528     C                   MOVEL     *BLANK        DDSTS
065500200528      *
065600200528      * RESET ERRORS
065700200528      *
065800200528     C                   MOVE      *ALL'Y'       MMEDEAM
065900200528     C                   MOVEL     *BLANK        FldNameArr
066000200528     C                   MOVEL     *BLANK        MsgIdArr
066100200528     C                   MOVEL     *BLANK        MsgDtaArr
066200200528     C                   MOVEL     *BLANK        WFldNamArr
066300200528     C                   MOVEL     *BLANK        WMsgIdArr
066400200528     C                   MOVEL     *BLANK        WMsgDtaArr
066500200528      *
066600200528      * Retrieve deal details
066700200528      *
066800200528     C                   MOVEL     @ACSEL        DDACTN
066900200528     C                   MOVEL     @FOTRANSEL    FOTRID
067000200528     C                   MOVEL     @FOASOCSEL    FOASID
067100200528     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
067200200528     C*******************MOVEL     @DLNOSEL      DDDLNO                         CAP013
067300200528     C*******************MOVEL     @VDATSEL      DDVDAT                         CAP013
067400200528     C*******************MOVEL     @DS38SEL      DDDS38                         CAP013
067500200528      *                                                                         CAP013
067600200528      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
067700200528      * module for SPF checking .                                               CAP013
067800200528      *                                                                         CAP013
067900200528     C     ZATRNKX0      CHAIN     MMIDEAMX0                          99        CAP013
068000200528      *                                                                         CAP013
068100200528      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
068200200528      *  if insert                                                              CAP013
068300200528      *  if not insert and Midas transaction ID is not present                  CAP013
068400200528      * Otherwise                                                               CAP013
068500200528      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
068600200528      *                                                                         CAP013
068700200528     C                   MOVEL     FOTRID        WFrontId          2            CPB002
068800200528      *                                                                         CPB002
068900200528     C     DDACTN        IFEQ      'I'                                          CAP013
069000200528     C     WFrontId      ANDNE     'TO'                                         CPB002
069100200528     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
069200200528     C                   ELSE                                                   CAP013
069300200528     C     DDDLNO        IFEQ      *BLANK                                       CAP013
069400200528     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
069500200528     C                   ELSE                                                   CAP013
069600200528     C                   MOVEL     '      '      @@MODE                         CAP013
069700200528     C                   ENDIF                                                  CAP013
069800200528     C                   ENDIF                                                  CAP013
069900200528      *                                                                         CAP013
070000200528     C                   EXSR      RTVDEL
070100200528      *
070200200528      * If deam details were retrieved
070300200528      * Put the deam on the main details screen
070400200528      *
070500200528     C     HNRCID        IFNE      *BLANK
070600200528     C     DDACTN        ANDNE     'I'
070700200528     C                   EXSR      PUTD@M
070800200528     C                   END
070900200528      *
071000200528      * Now overwite the fields on the main details screen with those
071100200528      * on the invalid deals file (except for the Midas deal number,
071200200528      * Value date and sequence number retrieved above using the
071300200528      * front office transaction and associated transaction IDs).
071400200528      * Access invalid deal with timestamp and front office transaction ID.
071500200528      *
071600200528     C                   MOVEL     DDDLNO        ##DDDLNO          6
071700200528     C                   MOVEL     DDVDAT        ##DDVDAT          6            137015
071800200528     C                   MOVEL     DDDS38        ##DDDS38          3            137015
071900200528     C     ZATRNKX0      CHAIN     MMIDEAMX0                          99
072000200528     C     HNRCID        IFNE      *BLANK
072100200528     C     DDACTN        ANDNE     'I'
072200200528     C                   MOVEL     ##DDDLNO      DDDLNO
072300200528     C                   MOVEL     ##DDVDAT      DDVDAT                         137015
072400200528     C                   MOVEL     ##DDDS38      DDDS38                         137015
072500200528     C                   END
072600200528      *
072700200528      * Access invalid deal settlement instructions
072800200528      *
072900200528     C                   CLEAR                   ##PAYS
073000200528     C                   CLEAR                   ##RECS
073100200528     C     APDSETKX      CHAIN     APIDSETX0                          99
073200200528      *                                                                         CAP011
073300200528      * If deal amendment details were retrieved and this is an amendment       CAP011
073400200528      *                                                                         CAP011
073500200528     C     HNRCID        IFNE      *BLANK                                       CAP011
073600200528     C     DDACTN        ANDEQ     'A'                                          CAP011
073700200528                                                                                CAP011
073800200528      * Data Substitution - Transaction Details                                 CAP011
073900200528                                                                                CAP011
074000200528     C     GHSUBS        ifne      *blank                                       CAP011
074100200528     C     GHSUBS        SCAN      NwDlScnFmt                             99    CAP011
074200200528     C     *IN99         IFEQ      *ON                                          CAP011
074300200528     C                   EXSR      TDtDtaSubs                                   CAP011
074400200528     C                   END                                                    CAP011
074500200528     C                   END                                                    CAP011
074600200528                                                                                CAP011
074700200528      * Setup settlement instructions on amend                                  CAP011
074800200528                                                                                CAP011
074900200528     C                   EXSR      SetupAmend                                   CAP011
075000200528                                                                                CAP011
075100200528      * Data Substitution - Settlement Details                                  CAP011
075200200528                                                                                CAP011
075300200528     C     GHSUBS        ifne      *blank                                       CAP011
075400200528     C     GHSUBS        SCAN      ##PAYS                                 99    CAP011
075500200528     C  N99GHSUBS        SCAN      ##RECS                                 99    CAP011
075600200528     C     *IN99         IFEQ      *ON                                          CAP011
075700200528     C                   EXSR      SDtDtaSubs                                   CAP011
075800200528     C                   END                                                    CAP011
075900200528     C                   END                                                    CAP011
076000200528                                                                                CAP011
076100200528     C                   END                                                    CAP011
076200200528      *
076300200528      * If action code, deal number, value date or sequence no were NOT OK
076400200528      * blank out action code so that the input cannot proceed
076500200528      *
076600200528     C     OKACTN        IFEQ      'N'
076700200528     C     OKDLNO        OREQ      'N'
076800200528     C     OKVDAT        OREQ      'N'
076900200528     C     OKDS38        OREQ      'N'
077000200528     C                   MOVEL     *BLANK        DDACTN
077100200528     C                   END
077200200528      *
077300200528      * Send the deals error messages to the main details screen
077400200528      *
077500200528     C                   EXSR      SNDM@M
077600200528      *
077700200528      * GO TO MAIN DETAILS SCREEN
077800200528      *
077900200528     C                   MOVE      'M'           @SCRN
078000200528      *
078100200528      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
078200200528      *
078300200528     C                   ELSE
078400200528      *
078500200528      * GO TO BROWSE SCREEN
078600200528      *
078700200528     C                   MOVE      'B'           @SCRN
078800200528     C                   END
078900200528      *
079000200528     C*******************ENDSR                                                  CAP004
079100200528     C     ERDNBRW       ENDSR                                                  CAP004
079200200528      *****************************************************************
079300200528      /EJECT
079400200528      *****************************************************************
079500200528      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
079600200528      *****************************************************************
079700200528     C     SNDM@M        BEGSR
079800200528
079900200528     C                   Z-ADD     Idx           E                 3 0
080000200528      *
080100200528      ** If there are fundamental errors in this transaction
080200200528      ** Identify this fact.
080300200528      *
080400200528     C     OKACTN        IFEQ      'N'
080500200528     C     OKDLNO        OREQ      'N'
080600200528     C     OKVDAT        OREQ      'N'
080700200528     C     OKDS38        OREQ      'N'
080800200528     C                   ADD       1             E
080900200528     C                   MOVEL     '*ANY'        FldNameArr(E)
081000200528     C                   MOVEL     'APM0110'     MsgIdArr(E)
081100200528     C                   ENDIF
081200200528      *
081300200528      ** Initialize error indicators
081400200528      *
081500200528     C                   MOVEA     MMEDEAM       @EI
081600200528      *
081700200528      ** Read error messages for deal
081800200528      *
081900200528     C     ZATRNKD0      SETLL     ZATRNERRD0
082000200528     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
082100200528      *
082200200528      ** Add error message to array passed to detail screen
082300200528      ** and set OK flag for field to 'N'
082400200528      *
082500200528     C     *IN99         DOWEQ     '0'
082600200528     C/COPY WNCPYSRC,MMDEAMRC01
082700200528     C                   ADD       1             E
082800200528     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
082900200528     C                   MOVEL     ABMSGID       MsgIdArr(E)
083000200528     C                   Z-ADD     ABFIELDID     F                 3 0
083100200528     C                   SUB       FldOffset     F
083200200528     C     F             IFLT      1
083300200528     C     F             ORGT      60
083400200528     C                   Z-ADD     1             F
083500200528     C                   END
083600200528     C                   MOVE      'N'           @EI(F)
083700200528     C/COPY WNCPYSRC,MMDEAMRC02
083800200528     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
083900200528     C                   END
084000200528      *
084100200528     C                   MOVEA     @EI           MMEDEAM
084200200528      *
084300200528     C                   ENDSR
084400200528      *****************************************************************
084500200528      /EJECT
084600200528      *****************************************************************
084700200528      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
084800200528      *****************************************************************
084900200528     C     SCRN@M        BEGSR
085000200528      *
085100200528      * Issue rollback to clear any possible updates in window function
085200200528      *
085300200528     C     BGWDPR        IFEQ      'Y'
085400200528     C                   If        (CSC022 = 'N')                                             CSC022
085500200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
085600200528     C                   ROLBK
085700200528     C                   Else                                                                 CSC022
085800200528     C                   SetOn                                        U7U8                    CSC022
085900200528     C                   EndIf                                                                CSC022
086000200528     C                   END
086100200528      *
086200200528      * Enable/disable detail fields on main details screen
086300200528      * if changes to the data are allowed                                      CAP014
086400200528      * (key fields = action code & deal number; detail fields = rest)
086500200528      * (Action code can only be 'I', 'A', 'D', or 'X')
086600200528      *
086700200528     C     DDACTN        IFEQ      'I'
086800200528     C     @OPSEL        ANDEQ     'U'                                          CAP014
086900200528     C     DDACTN        OREQ      'A'
087000200528     C     @OPSEL        ANDEQ     'U'                                          CAP014
087100200528     C                   MOVEL     'Y'           @EDTFD
087200200528     C                   ELSE
087300200528     C                   MOVEL     'N'           @EDTFD
087400200528     C                   END
087500200528      *
087600200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
087700200528      *
087800200528     C     DDACTN        IFEQ      'D'
087900200528     C                   MOVEL     'Y'           @EINKJ
088000200528     C                   ELSE
088100200528     C                   MOVEL     'N'           @EINKJ
088200200528     C                   END
088300200528      *
088400200528      * WRITE/READ DISPLAY SCREEN
088500200528      *
088600200528     C                   CALLB     'MMDEAMDSP'
088700200528      *
088800200528      * INPUT PARAMETERS
088900200528      *
089000200528      * RETURN CODE
089100200528     C                   PARM      *BLANK        RetCodeOut
089200200528      *
089300200528      * DEAL (IN SCREEN FORMAT)
089400200528     C                   PARM                    NwDlScnFmt
089500200528      *
089600200528      * DEAL STATUS
089700200528     C                   PARM                    DDSTS            24
089800200528      *
089900200528      * FIELDS IN ERROR
090000200528     C                   PARM                    MMEDEAM
090100200528      *
090200200528      * ERRORS
090300200528     C                   PARM                    FldNameArr
090400200528     C                   PARM                    MsgIdArr
090500200528     C                   PARM                    MsgDtaArr
090600200528      *
090700200528      * WARNINGS
090800200528     C                   PARM                    WFldNamArr
090900200528     C                   PARM                    WMsgIdArr
091000200528     C                   PARM                    WMsgDtaArr
091100200528      *
091200200528      * ENABLED KEY & DETAIL FIELDS
091300200528      *
091400200528     C                   PARM      'N'           @EKYFD            1
091500200528     C                   PARM                    @EDTFD            1
091600200528      *
091700200528      * ENABLED FUNCTION KEYS
091800200528     C                   PARM      'N'           @EINKG            1
091900200528     C                   PARM      'N'           @EINKH            1
092000200528     C                   PARM                    @EINKJ            1
092100200528     C                   PARM      'N'           @EINKN            1
092200200528     C                   PARM      'N'           @EINKP            1
092300200528      *
092400200528      * SUCCESFUL INSERT DEAL AMENDMENT (Sequence Number Generated)
092500200528     C                   PARM                    @LSQN             3
092600200528      *
092700200528      * OUTPUT PARAMETERS
092800200528      *
092900200528      * FUNCTION KEYS
093000200528     C                   PARM      '0'           @INKC             1
093100200528     C                   PARM      '0'           @INKG             1
093200200528     C                   PARM      '0'           @INKH             1
093300200528     C                   PARM      '0'           @INKJ             1
093400200528     C                   PARM      '0'           @INKL             1
093500200528     C                   PARM      '0'           @INKN             1
093600200528     C                   PARM      '0'           @INKP             1
093700200528     C                   PARM      'N'           WriteOnly         1
093800200528     C/COPY WNCPYSRC,MMDEAMRC03
093900200528      *
094000200528      * RESET ERRORS
094100200528      *
094200200528     C                   MOVE      *ALL'Y'       MMEDEAM
094300200528     C                   MOVEL     *BLANK        FldNameArr
094400200528     C                   MOVEL     *BLANK        MsgIdArr
094500200528     C                   MOVEL     *BLANK        MsgDtaArr
094600200528     C                   MOVEL     *BLANK        WFldNamArr
094700200528     C                   MOVEL     *BLANK        WMsgIdArr
094800200528     C                   MOVEL     *BLANK        WMsgDtaArr
094900200528      *
095000200528      * CK/3 - END PROGRAM
095100200528      *
095200200528     C     @INKC         CASEQ     '1'           ENDP
095300200528      *
095400200528      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
095500200528      *
095600200528     C     @INKL         CASEQ     '1'           CANC@M
095700200528      *
095800200528      * VALIDATE INPUT TO MAIN DETAILS SCREEN
095900200528      *
096000200528     C                   CAS                     VAL@M
096100200528     C                   END
096200200528      *
096300200528     C                   ENDSR
096400200528      *****************************************************************
096500200528      /EJECT
096600200528      *****************************************************************
096700200528      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
096800200528      *****************************************************************
096900200528     C     VAL@M         BEGSR
097000200528      *
097100200528      * Retrieve deal details
097200200528      *
097300200528     C                   MOVEL     '      '      @@MODE
097400200528     C                   EXSR      RTVDEL
097500200528      *
097600200528      * If action code, deal number, value date or sequence no. are NOT OK
097700200528      * Re-output screen with error messages on it
097800200528      *
097900200528     C     OKACTN        IFEQ      'N'
098000200528     C     OKDLNO        OREQ      'N'
098100200528     C     OKVDAT        OREQ      'N'
098200200528     C     OKDS38        OREQ      'N'
098300200528     C                   GOTO      EVAL@M
098400200528     C                   END
098500200528      *
098600200528      *----------------------------------------------------------------
098700200528      * IF DELETE
098800200528      *
098900200528     C     DDACTN        IFEQ      'D'
099000200528      *
099100200528      * Update Deam in File Format
099200200528      *
099300200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
099400200528      *
099500200528      * IF CK/10 TAKEN, GO ONTO UPDATES
099600200528      *
099700200528     C     @INKJ         IFEQ      '1'
099800200528     C                   MOVEL     'U'           @SCRN
099900200528     C/COPY WNCPYSRC,MMDEAMRC04
100000200528     C                   END
100100200528     C                   GOTO      EVAL@M
100200200528     C                   END
100300200528      *
100400200528      *----------------------------------------------------------------
100500200528      * IF AUTHORIZE
100600200528      *
100700200528     C     DDACTN        IFEQ      'X'
100800200528      *
100900200528      * Update Deal in File Format
101000200528      *
101100200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
101200200528      *
101300200528      * CONTINUE TO SETTLEMENTS SCREEN
101400200528      ** (Do not display settlement screen if Deal Amendment type
101500200528      ** is 'Rate Change' or 'Capitalise Interest')
101600200528      *
101700200528     C     DDMTYP        IFNE      'SC'
101800200528     C     DDMTYP        ANDNE     'CI'
101900200528     C                   MOVEL     'S'           @SCRN
102000200528     C                   ELSE
102100200528     C                   MOVEL     'C'           @SCRN
102200200528     C                   END
102300200528      *
102400200528      * If windows processing on, call window routine
102500200528      * prior to either settlements or confirm screen
102600200528      *
102700200528     C     BGWDPR        IFEQ      'Y'
102800200528     C                   MOVEL     'W'           @SCRN
102900200528     C                   END
103000200528      *
103100200528     C                   GOTO      EVAL@M
103200200528     C                   END
103300200528      *
103400200528      *----------------------------------------------------------------
103500200528      * IF INSERT OR AMEND
103600200528      *
103700200528     C     DDACTN        IFEQ      'I'
103800200528     C     DDACTN        OREQ      'A'
103900200528      *
104000200528      * Prior to validation, initialize error indicators as 'OK'
104100200528      * and clear Deal in File Format
104200200528      *
104300200528     C                   Z-ADD     *ZERO         Idx               3 0
104400200528     C                   Z-ADD     *ZERO         WIdx              3 0
104500200528     C                   MOVE      *ALL'Y'       MMEDEAM
104600200528     C                   CLEAR                   NwDlFilFmt
104700200528     C                   Z-ADD     *ZERO         IGRSTM
104800200528     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
104900200528     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
105000200528     C                   EVAL      IGROBN = *BLANKS                                           CSD027
105100200528     C                   EVAL      IGROCN = *BLANKS                                           CSD027
105200200528     C                   Z-ADD     *ZERO         IGPSTM
105300200528     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
105400200528     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
105500200528     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
105600200528     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
105700200528      *
105800200528      * IF AMEND
105900200528      *
106000200528     C     DDACTN        IFEQ      'A'
106100200528      *
106200200528      * Update Deal in File Format
106300200528      *
106400200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
106500200528      *
106600200528      * Validate whether non-amenable fields have been changed
106700200528      *
106800200528     C                   CALLB     'MMDEAMAMD'
106900200528      *
107000200528      * INPUTS
107100200528      *
107200200528      * Return Code
107300200528     C                   PARM      *BLANK        RetCodeOut
107400200528      *
107500200528      * New Deal in Screen Format
107600200528     C                   PARM                    NwDlScnFmt
107700200528      *
107800200528      * Current Deal in Screen Format
107900200528     C                   PARM                    CrDlScnFmt
108000200528      *
108100200528      * Current Deal in file format
108200200528     C                   PARM                    CrDlFilFmt
108300200528      *
108400200528      * OUTPUTS
108500200528      *
108600200528      * Field OK flags (DS) from/to caller
108700200528     C                   PARM                    MMEDEAM
108800200528      *
108900200528      * Error fields/message IDs/message data (arrays) from/to caller
109000200528     C                   PARM                    FldNameArr
109100200528     C                   PARM                    MsgIdArr
109200200528     C                   PARM                    MsgDtaArr
109300200528      *
109400200528      * Array index (3P0) from/to caller
109500200528     C                   PARM                    Idx
109600200528      *
109700200528      * Amendments OK
109800200528     C                   PARM                    @@AMOK            1
109900200528      *
110000200528      * Reset of Fields in Error Required (Y/N)
110100200528     C                   PARM      'Y'           @@RSTE            1
110200200528     C                   END
110300200528      *
110400200528      * Validate deal details
110500200528      *
110600200528     C                   CALLB     'MMDEAMVAL'
110700200528     C                   PARM                    RespMode
110800200528     C                   PARM                    NwDlScnFmt
110900200528     C                   PARM                    InfData                        CAP051
111000200528     C                   PARM                    ExtData                        CAP004
111100200528     C                   PARM                    MMEDEAM
111200200528     C                   PARM                    FldNameArr
111300200528     C                   PARM                    MsgIdArr
111400200528     C                   PARM                    MsgDtaArr
111500200528     C                   PARM                    Idx
111600200528     C                   PARM                    WFldNamArr
111700200528     C                   PARM                    WMsgIdArr
111800200528     C                   PARM                    WMsgDtaArr
111900200528     C                   PARM                    WIdx
112000200528     C                   PARM                    NwDlFilFmt
112100200528      *
112200200528      * If errors returned
112300200528      *
112400200528     C     Idx           IFNE      0
112500200528     C                   GOTO      EVAL@M
112600200528     C                   END
112700200528      *                                                                         CAP051
112800200528      * Setup Automatic Authorisation flag on the Valid file                    CAP051
112900200528     C     CAP051        IFEQ      'Y'                                          CAP051
113000200528     C                   EVAL      IGAUTH = DDAUTH                              CAP051
113100200528     C                   ENDIF                                                  CAP051
113200200528      *
113300200528      * CONTINUE TO SETTLEMENTS SCREEN
113400200528      ** (Do not display settlement screen if Deal Amendment type
113500200528      ** is 'Rate Change' or 'Capitalise Interest')
113600200528      *
113700200528     C     DDMTYP        IFNE      'SC'
113800200528     C     DDMTYP        ANDNE     'CI'
113900200528     C                   MOVEL     'S'           @SCRN
114000200528     C                   ELSE
114100200528     C                   MOVEL     'C'           @SCRN
114200200528     C                   END
114300200528      *
114400200528      * If windows processing on, call window routine
114500200528      * prior to either settlements or confirmation screen
114600200528      *
114700200528     C     BGWDPR        IFEQ      'Y'
114800200528     C                   MOVEL     'W'           @SCRN
114900200528     C                   END
115000200528      *
115100200528     C                   END
115200200528      *----------------------------------------------------------------
115300200528     C     EVAL@M        ENDSR
115400200528      *****************************************************************
115500200528      /EJECT
115600200528      *****************************************************************
115700200528      * WINDOW - CALL WINDOW MANAGER
115800200528      *****************************************************************
115900200528     C     WINDOW        BEGSR
116000200528      *
116100200528      * Reset erros
116200200528      *
116300200528     C                   MOVE      *ALL'Y'       MMEDEAM
116400200528     C                   MOVEL     *BLANK        FldNameArr
116500200528     C                   MOVEL     *BLANK        MsgIdArr
116600200528     C                   MOVEL     *BLANK        MsgDtaArr
116700200528     C                   MOVEL     *BLANK        WFldNamArr
116800200528     C                   MOVEL     *BLANK        WMsgIdArr
116900200528     C                   MOVEL     *BLANK        WMsgDtaArr
117000200528      *
117100200528      * Write out screen to remove error messages
117200200528      *
117300200528     C                   CALLB     'MMDEAMDSP'
117400200528      *
117500200528      * INPUT PARAMETERS
117600200528      *
117700200528      * RETURN CODE
117800200528     C                   PARM      *BLANK        RetCodeOut
117900200528      *
118000200528      * DEAL (IN SCREEN FORMAT)
118100200528     C                   PARM                    NwDlScnFmt
118200200528      *
118300200528      * DEAL STATUS
118400200528     C                   PARM                    DDSTS            24
118500200528      *
118600200528      * FIELDS IN ERROR
118700200528     C                   PARM                    MMEDEAM
118800200528      *
118900200528      * ERRORS
119000200528     C                   PARM                    FldNameArr
119100200528     C                   PARM                    MsgIdArr
119200200528     C                   PARM                    MsgDtaArr
119300200528      *
119400200528      * WARNINGS
119500200528     C                   PARM                    WFldNamArr
119600200528     C                   PARM                    WMsgIdArr
119700200528     C                   PARM                    WMsgDtaArr
119800200528      *
119900200528      * ENABLED KEY & DETAIL FIELDS
120000200528      *
120100200528     C                   PARM                    @EKYFD
120200200528     C                   PARM                    @EDTFD
120300200528      *
120400200528      * ENABLED FUNCTION KEYS
120500200528     C                   PARM                    @EINKG
120600200528     C                   PARM                    @EINKH
120700200528     C                   PARM                    @EINKJ
120800200528     C                   PARM                    @EINKN
120900200528     C                   PARM                    @EINKP
121000200528      *
121100200528      * SUCCESFUL INSERT DEAM
121200200528     C                   PARM                    @LSQN
121300200528      *
121400200528      * OUTPUT PARAMETERS
121500200528      *
121600200528      * FUNCTION KEYS
121700200528     C                   PARM      '0'           @INKC
121800200528     C                   PARM      '0'           @INKG
121900200528     C                   PARM      '0'           @INKH
122000200528     C                   PARM      '0'           @INKJ
122100200528     C                   PARM      '0'           @INKL
122200200528     C                   PARM      '0'           @INKN
122300200528     C                   PARM      '0'           @INKP
122400200528     C                   PARM      'Y'           WriteOnly         1
122500200528     C/COPY WNCPYSRC,MMDEAMRC05
122600200528      *
122700200528      * For inserts generate Deal Amendment Sequence Number
122800200528      *
122900200528     C                   IF        DDACTN = 'I'
123000200528     C                   EXSR      SETUPDASEQ
123100200528     C                   ENDIF
123200200528      *
123300200528     C/COPY WNCPYSRC,MMDEAMSMV1
123400200528      *
123500200528     C                   CALL      'WN0010'
123600200528     C**********         PARM      'MMDEAMSIN'   #PGM             10                          192829
123700200528     C                   PARM      'MMDEAMRPR'   #PGM             10                          192829
123800200528     C                   PARM                    FKEY              2
123900200528     C                   PARM      DDACTN        ACTION            1
124000200528     C                   PARM                    DATA
124100200528     C                   PARM      *BLANKS       #RTRN             7
124200200528     C                   PARM                    SPAREW          256
124300200528      *
124400200528      * Process returned command keys
124500200528      *
124600200528     C     #RTRN         IFEQ      'Y2U9999'
124700200528     C                   EXSR      ENDP
124800200528     C                   ELSE
124900200528      *
125000200528      *  If Cmd12 pressed, or in enquiry, return to main details screen;
125100200528      *  otherwise, go to settlements screen
125200200528      *
125300200528     C     #RTRN         IFEQ      'USR0790'
125400200528     C     DDACTN        OREQ      'E'
125500200528     C     @RDNB         IFEQ      'Y'
125600200528     C                   EVAL      @SCRN = 'R'
125700200528     C                   ELSE
125800200528     C                   EVAL      @SCRN = 'M'
125900200528     C                   END
126000200528     C                   ELSE
126100200528      ** (Do not display settlement screen if Deal Amendment type
126200200528      ** is 'Rate Change' or 'Capitalise Interest')
126300200528      *
126400200528     C     DDMTYP        IFNE      'SC'
126500200528     C     DDMTYP        ANDNE     'CI'
126600200528     C                   EVAL      @SCRN = 'S'
126700200528     C                   ELSE
126800200528     C                   EVAL      @SCRN = 'C'
126900200528     C                   ENDIF
127000200528     C/COPY WNCPYSRC,MMDEAMRC06
127100200528     C                   ENDIF
127200200528     C                   ENDIF
127300200528      *
127400200528     C     WIND          ENDSR
127500200528      *****************************************************************
127600200528      /EJECT
127700200528      *****************************************************************
127800200528      * RTVDEL - RETRIEVE DEAM
127900200528      *****************************************************************
128000200528     C     RTVDEL        BEGSR
128100200528      *
128200200528      * RETRIEVE DEAM
128300200528      *
128400200528     C                   CALLB     'MMDEAMRTV'
128500200528      *
128600200528      * INPUTS
128700200528      *
128800200528      * Return code
128900200528     C                   PARM      *BLANK        RetCodeOut
129000200528      *
129100200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
129200200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
129300200528      *
129400200528     C                   PARM                    @@MODE            6
129500200528      *
129600200528      * Response mode
129700200528     C                   PARM      'S'           @@RSMD            1
129800200528      *
129900200528      * Action Code
130000200528     C                   PARM                    DDACTN
130100200528      *
130200200528      * Front Office Transaction ID
130300200528     C                   PARM                    FOTRID           20
130400200528      *
130500200528      * Front Office Associated Transaction Id
130600200528     C                   PARM                    FOASID           20
130700200528      *
130800200528      * (Midas) Deal Number
130900200528     C                   PARM                    DDDLNO
131000200528      *
131100200528      * Value Date
131200200528     C                   PARM                    DDVDAT
131300200528      *
131400200528      * Sequence Number
131500200528     C                   PARM                    DDDS38
131600200528      *
131700200528      * Deal Amendment Amount
131800200528     C                   PARM                    DDAMNP           15
131900200528      *
132000200528      * Deal Amendment Type
132100200528     C                   PARM                    DDMTYP            2
132200200528      * Action Code (Reversal transaction)                                                    260173
132300200528     C                   PARM      *BLANK        @ACTRV            1                          260173
132400200528      *
132500200528      * OUTPUTS
132600200528      *
132700200528      * (Current) deam in file format
132800200528     C                   PARM                    CrDlFilFmt
132900200528      *
133000200528      * OK - Action code
133100200528     C                   PARM      *BLANK        OKACTN
133200200528      *
133300200528      * OK - Deal Number
133400200528     C                   PARM      *BLANK        OKDLNO
133500200528      *
133600200528      * OK - Value Date
133700200528     C                   PARM      *BLANK        OKVDAT
133800200528      *
133900200528      * OK - Sequence Number
134000200528     C                   PARM      *BLANK        OKDS38
134100200528      *
134200200528      * Error fields/message IDs/message data (arrays) from/to caller
134300200528     C                   PARM                    FldNameArr
134400200528     C                   PARM                    MsgIdArr
134500200528     C                   PARM                    MsgDtaArr
134600200528      *
134700200528      * Array index (3P0) from/to caller
134800200528     C                   PARM      *ZERO         Idx
134900200528      *
135000200528     C                   ENDSR
135100200528      *****************************************************************
135200200528      /EJECT
135300200528      *****************************************************************
135400200528      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
135500200528      *****************************************************************
135600200528     C     PUTD@M        BEGSR
135700200528      *
135800200528      * Call program to fill screen fields with data from MMDEAMPP
135900200528      *
136000200528     C                   CALLB     'MMDEAMCVT'
136100200528      *
136200200528      * INPUTS
136300200528      *
136400200528      * Return Code
136500200528     C                   PARM      *BLANK        RetCodeOut
136600200528      *
136700200528      * Deal in file format
136800200528     C                   PARM                    CrDlFilFmt
136900200528      *
137000200528      * OUTPUTS
137100200528      *
137200200528      * Deal in screen format
137300200528     C                   PARM                    NwDlScnFmt
137400200528      *
137500200528      * Deal Status
137600200528     C                   PARM                    DDSTS            24
137700200528      *
137800200528      * Update 'Current' Deal with Deal in Screen Format
137900200528      *
138000200528     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
138100200528      *
138200200528     C                   ENDSR
138300200528      *****************************************************************
138400200528      /EJECT
138500200528      *****************************************************************
138600200528      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
138700200528      *****************************************************************
138800200528     C     CANC@M        BEGSR
138900200528      *
139000200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
139100200528      *
139200200528     C     @RDNB         IFEQ      'Y'
139300200528     C                   MOVEL     'R'           @SCRN
139400200528     C                   ELSE
139500200528      *
139600200528      * ELSE, RETURN TO THE BROWSE SCREEN
139700200528      *
139800200528     C                   MOVEL     'B'           @SCRN
139900200528     C                   END
140000200528      *
140100200528     C                   ENDSR
140200200528      *****************************************************************
140300200528      /EJECT
140400200528      *****************************************************************
140500200528      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
140600200528      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
140700200528      *****************************************************************
140800200528     C     SCRN@S        BEGSR
140900200528      *
141000200528      * IF FIRST TIME FOR ACTION CODE OR DEAL AMENDMENT
141100200528      *
141200200528     C     DDACTN        IFNE      ##ACTN
141300200528     C     DDDLNO        ORNE      ##DLNO
141400200528     C     DDVDAT        ORNE      ##VDAT
141500200528     C     DDDS38        ORNE      ##DS38
141600200528     C     DDMTYP        ORNE      ##TTYP
141700200528      *
141800200528      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
141900200528      *
142000200528     C                   EXSR      DETP@S
142100200528     C                   END
142200200528      *                                                                         CAP014
142300200528      * If no changes are allowed, protect (but still validate)                 CAP014
142400200528      * all instructions by passing action code 'X' to ZASETINSIN               CAP014
142500200528      *                                                                         CAP014
142600200528     C     @OPSEL        IFEQ      'N'                                          CAP014
142700200528     C                   MOVEL     'X'           ##ACTN                         CAP014
142800200528     C                   ELSE                                                   CAP014
142900200528     C                   MOVEL     DDACTN        ##ACTN                         CAP014
143000200528     C                   ENDIF                                                  CAP014
143100200528      *
143200200528      * SETTLEMENT INSTRUCTIONS INPUT
143300200528      *
143400200528     C                   CALLB     'ZASETINSIN'
143500200528      *
143600200528      * INPUTS
143700200528      *
143800200528      * Return Code
143900200528     C                   PARM      *BLANK        ##RTCD           10
144000200528      *
144100200528      * Action code
144200200528     C                   PARM                    ##ACTN            1            CAP014
144300200528     C*******************PARM      DDACTN        ##ACTN            1            CAP014
144400200528      *
144500200528      * Deal number
144600200528     C                   PARM      DDDLNO        ##DLNO            6
144700200528      *
144800200528      * Protect Payment
144900200528     C                   PARM                    ##PPAY            1
145000200528      *
145100200528      * Protect Receive
145200200528     C                   PARM                    ##PREC            1
145300200528      *
145400200528      * Calling program
145500200528     C                   PARM      'DEAM'        ##CALP            4
145600200528      *
145700200528      * Payment currency
145800200528     C                   PARM      DDCCY         ##PCCY            3
145900200528      *
146000200528      * Receive currency
146100200528     C                   PARM      DDCCY         ##RCCY            3
146200200528      *
146300200528      * Customer shortname
146400200528     C                   PARM      DDCSNM        ##CSNM           10
146500200528      *
146600200528      * Transaction Type
146700200528     C                   PARM      DDMTYP        ##TTYP            2
146800200528      *
146900200528      * Federal Funds Ind.
147000200528     C                   PARM                    ##FFND            1
147100200528      *
147200200528      * Booking branch
147300200528     C                   PARM                    ##BRCA            3
147400200528      *
147500200528      * Receipt Date
147600200528     C                   PARM                    ##DATR            5 0
147700200528      *
147800200528      * Payment Date
147900200528     C                   PARM                    ##DATP            5 0
148000200528      *
148100200528      * Payment instructions
148200200528     C                   PARM                    ##PAYS
148300200528      *
148400200528      * Receive instructions
148500200528     C                   PARM                    ##RECS
148600200528      *
148700200528      * FRA/IRS instructions
148800200528     C                   PARM                    ##FRIS
148900200528      *
149000200528      * OUTPUTS
149100200528      *
149200200528      * Payment instructions
149300200528     C                   PARM                    ##PAYF
149400200528      *
149500200528      * Receive instructions
149600200528     C                   PARM                    ##RECF
149700200528      *
149800200528      * FRA/IRS instructions
149900200528     C                   PARM                    ##FRIF
150000200528      *
150100200528      * FUNCTION KEYS
150200200528     C                   PARM      '0'           @INKC             1
150300200528     C                   PARM      '0'           @INKK             1                        MD036070
150400200528     C                   PARM      '0'           @INKL             1
150500200528      *
150600200528      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
150700200528     C************       PARM                    @MORPI                                179510 200400
150800200528      ************                                                                     179510 200400
150900200528     C                   MOVE      DDVDAT        ##VDAT            6
151000200528     C                   MOVE      DDDS38        ##DS38            3
151100200528      *
151200200528      * CK/3 - END PROGRAM
151300200528      *
151400200528     C     @INKC         CASEQ     '1'           ENDP
151500200528      *
151600200528      * CK/12 - CANCEL ON SETTLEMENT DETAILS
151700200528      *
151800200528     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
151900200528     C     @INKL         CASEQ     '1'           CANC@S
152000200528      *
152100200528      * EXIT FROM SETTLEMENT DETAILS
152200200528      *
152300200528     C                   CAS                     EXIT@S
152400200528     C                   END
152500200528      *
152600200528     C                   ENDSR
152700200528      *****************************************************************
152800200528      /EJECT
152900200528      *****************************************************************
153000200528      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
153100200528      *****************************************************************
153200200528     C     DETP@S        BEGSR
153300200528      *
153400200528      ** SET PAYMENT AND RECEIVE DATES TO VALUE DATE OF DEAL AMENDMENT
153500200528     C                   Z-ADD     IGDVSD        ##DATR
153600200528     C                   Z-ADD     IGDVSD        ##DATP
153700200528      *
153800200528      * LOAN OR DEPOSIT TYPE DEAL?
153900200528      *
154000200528     C     HNOMDT        IFEQ      'IT'
154100200528     C     HNOMDT        OREQ      'TD'
154200200528     C     HNOMDT        OREQ      'CI'
154300200528     C     HNOMDT        OREQ      'CD'
154400200528     C                   MOVEL     'D'           W#LOD             1
154500200528     C                   ELSE
154600200528     C                   MOVEL     'L'           W#LOD
154700200528     C                   END
154800200528      *
154900200528     C                   MOVEL     'N'           ##PPAY
155000200528     C                   MOVEL     'N'           ##PREC
155100200528      *
155200200528      ** Protect both Pay and Receive instructions if Deal Amendment type
155300200528      ** is 'Rate Change' or 'Capitalise Interest'
155400200528      *
155500200528     C     DDMTYP        IFEQ      'SC'
155600200528     C     DDMTYP        OREQ      'CI'
155700200528     C                   MOVEL     'Y'           ##PPAY
155800200528     C                   MOVEL     'Y'           ##PREC
155900200528     C                   END
156000200528      *
156100200528      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
156200200528      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
156300200528      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
156400200528      **
156500200528     C     DDMTYP        IFEQ      'PD'
156600200528     C     W#LOD         ANDEQ     'D'
156700200528     C     DDMTYP        OREQ      'PI'
156800200528     C     W#LOD         ANDEQ     'L'
156900200528     C     DDMTYP        OREQ      'SI'
157000200528     C     W#LOD         ANDEQ     'D'
157100200528      *
157200200528     C                   MOVEL     'Y'           ##PREC
157300200528     C                   MOVEL     *BLANK        ##RECS                         144815
157400200528     C                   MOVEL     '00'          DDRSTM                         144815
157500200528      *
157600200528      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
157700200528      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
157800200528      ** OR SETTLE INTEREST OF DEPOSIT PLACED
157900200528      **
158000200528     C                   ELSE
158100200528      *
158200200528     C     DDMTYP        IFEQ      'PD'
158300200528     C     W#LOD         ANDEQ     'L'
158400200528     C     DDMTYP        OREQ      'PI'
158500200528     C     W#LOD         ANDEQ     'D'
158600200528     C     DDMTYP        OREQ      'SI'
158700200528     C     W#LOD         ANDEQ     'L'
158800200528      *
158900200528     C                   MOVEL     'Y'           ##PPAY
159000200528     C                   MOVEL     *BLANK        ##PAYS                         144815
159100200528     C                   MOVEL     '00'          DDPSTM                         144815
159200200528      *
159300200528     C                   END
159400200528     C                   END
159500200528      *
159600200528      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
159700200528      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
159800200528      *
159900200528     C     ##PAYS        IFNE      *blank
160000200528     C     DDPSTM        ANDNE     '00'                                         144815
160100200528     C     ##RECS        ORNE      *blank
160200200528     C     DDRSTM        ANDNE     '00'                                         144815
160300200528     C                   GOTO      EDETP@S
160400200528     C                   END
160500200528      *
160600200528      * SET UP PAYMENT INSTRUCTIONS FROM DEAM
160700200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
160800200528      *
160900200528     C**********         MOVEL     IGPAY         FLPAY                                        CGL029
161000200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(IGPAY:1:2)                      CGL029
161100200528     C                   EVAL      %SUBST(FLPAY:3:18) = IGPONS                                CGL029
161200200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(IGPAY:15:545)                CGL029
161300200528     C                   MOVEL     IGOSBR        FLPOBR
161400200528     C                   MOVEL     IGCVMR        FLCVMR
161500200528     C                   MOVEL     IGSTCY        FLPSCY
161600200528     C                   MOVEL     IGIC72        FLIC72
161700200528      *
161800200528      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
161900200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
162000200528      *
162100200528     C**********         MOVEL     IGREC         FLREC                                        CGL029
162200200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(IGREC:1:2)                      CGL029
162300200528     C                   EVAL      %SUBST(FLREC:3:18) = IGRONS                                CGL029
162400200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(IGREC:15:55)                  CGL029
162500200528     C                   MOVEL     IGOSBR        FLROBR
162600200528     C                   MOVEL     IGSTCY        FLRSCY
162700200528      *
162800200528      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
162900200528      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
163000200528      *
163100200528     C     FLPSTM        IFEQ      *ZERO
163200200528     C     ##PPAY        ANDNE     'Y'
163300200528     C     FLRSTM        ANDEQ     *ZERO
163400200528     C     ##PREC        ANDNE     'Y'
163500200528                                                                                              CSD095
163600200528      ** Retrieve the subtype and branch associated with the deal                             CSD095
163700200528                                                                                              CSD095
163800200528     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
163900200528     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
164000200528                                                                                              CSD095
164100200528     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
164200200528     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
164300200528     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
164400200528     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
164500200528     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
164600200528     C                   ENDIF                                                                CSD095
164700200528      *
164800200528     C                   CALLB     'ZASETINDFT'
164900200528      *
165000200528      * INPUTS
165100200528      *
165200200528      * Calling program
165300200528     C                   PARM      'DEAM'        ##CALP            4
165400200528      *
165500200528      * Payment currency
165600200528     C                   PARM      DDCCY         ##PCCY            3
165700200528      *
165800200528      * Receive currency
165900200528     C                   PARM      DDCCY         ##RCCY            3
166000200528     C/COPY WNCPYSRC,MMDEAMRC10
166100200528      *
166200200528      * Customer shortname
166300200528     C                   PARM      DDCSNM        ##CSNM           10
166400200528      *
166500200528      * Transaction Type
166600200528     C                   PARM      DDMTYP        ##TTYP            2
166700200528      *
166800200528      * Federal Funds Ind.
166900200528     C                   PARM                    ##FFND            1
167000200528      *
167100200528      ** Version of ISDA Rules govern
167200200528     C                   PARM                    BQISDA            4
167300200528      *
167400200528      ** Type of ISDA agreement
167500200528     C                   PARM                    BQAGTY            6
167600200528      *
167700200528      ** Date of ISDA Agreement
167800200528     C                   PARM                    BQAGDT            6
167900200528      *
168000200528      ** Version of ISDA Agreement
168100200528     C                   PARM                    BQAGVV            2
168200200528      ** Version of ISDA Agreement century                                                    176883
168300200528     C                   PARM                    Blank2            2                          176883
168400200528      ** Deal Subtype                                                                         CSD095
168500200528     C                   PARM                    DDSTYP            2                          CSD095
168600200528      ** Branch                                                                               CSD095
168700200528     C                   PARM                    DDBRCA            3                          CSD095
168800200528      *
168900200528      ** OUTPUTS
169000200528      *
169100200528      * Payment instructions
169200200528     C                   PARM                    ##PAYF
169300200528      *
169400200528      * Receive instructions
169500200528     C                   PARM                    ##RECF
169600200528      *
169700200528      * FRA/IRS instructions
169800200528     C                   PARM                    ##FRIF
169900200528      *
170000200528     C                   END
170100200528      *
170200200528      * Clear payment instructions if protected
170300200528      *
170400200528     C     ##PPAY        IFEQ      'Y'
170500200528     C                   CLEAR                   ##PAYF
170600200528     C                   Z-ADD     *ZERO         FLPSTM
170700200528     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
170800200528     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
170900200528     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
171000200528     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
171100200528     C                   END
171200200528      *
171300200528      * Clear receipt instructions if protected
171400200528      *
171500200528     C     ##PREC        IFEQ      'Y'
171600200528     C                   CLEAR                   ##RECF
171700200528     C                   Z-ADD     *ZERO         FLRSTM
171800200528     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
171900200528     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
172000200528     C                   EVAL      FLROBN = *BLANKS                                           CSD027
172100200528     C                   EVAL      FLROCN = *BLANKS                                           CSD027
172200200528     C                   END
172300200528      *
172400200528      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
172500200528      *
172600200528     C                   CALLB     'ZASETINCVT'
172700200528      *
172800200528      ** INPUTS
172900200528      *
173000200528      ** File Payment Settlement Instruction
173100200528     C                   PARM                    ##PAYF
173200200528      *
173300200528      ** File Receipt Settlement Instruction
173400200528     C                   PARM                    ##RECF
173500200528      *
173600200528      ** File FRA/IRS Settlement Instruction
173700200528     C                   PARM      *BLANK        ##FRIF
173800200528      *
173900200528      ** OUTPUTS
174000200528      ** Screen Payment Settlement Instruction
174100200528     C                   PARM      *BLANK        ##PAYS
174200200528      *
174300200528      ** Screen Receipt Settlement Instruction
174400200528     C                   PARM      *BLANK        ##RECS
174500200528      *
174600200528      ** Screen FRA/IRS Settlement Instruction
174700200528     C                   PARM      *BLANK        ##FRIS
174800200528     C                   PARM      DDCCY         InRCCY                                      CSF011A
174900200528     C                   PARM      DDCCY         InPCCY                                      CSF011A
175000200528      *
175100200528     C     EDETP@S       ENDSR
175200200528      *****************************************************************
175300200528      /EJECT
175400200528      *****************************************************************
175500200528      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
175600200528      *****************************************************************
175700200528     C     CANC@S        BEGSR
175800200528     C/COPY WNCPYSRC,MMDEAMRC07
175900200528      *
176000200528      * Return to Main Details Screen
176100200528      *
176200200528     C                   MOVEL     'M'           @SCRN
176300200528     C/COPY WNCPYSRC,MMDEAMRC08
176400200528      *
176500200528     C                   ENDSR
176600200528      *****************************************************************
176700200528      /EJECT
176800200528      *****************************************************************
176900200528      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
177000200528      *****************************************************************
177100200528     C     EXIT@S        BEGSR
177200200528      *
177300200528      * IF SETTLEMENT DETAILS INVALID
177400200528      *
177500200528     C     ##RTCD        IFEQ      '*ERRORS'
177600200528      *
177700200528      * RETURN TO MAIN DETAILS SCREEN
177800200528      *
177900200528     C                   MOVEL     'M'           @SCRN
178000200528     C                   ELSE
178100200528      *
178200200528      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
178300200528      *
178400200528     C                   MOVEL     'C'           @SCRN
178500200528      *
178600200528      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
178700200528      *
178800200528     C**********         MOVEL     FLPAY         IGPAY                                        CGL029
178900200528     C                   EVAL      %SUBST(IGPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
179000200528     C                   EVAL      IGPONS = %SUBST(FLPAY:3:18)                                CGL029
179100200528     C                   EVAL      %SUBST(IGPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
179200200528     C                   MOVEL     FLPOBR        IGOSBR
179300200528     C                   MOVEL     FLCVMR        IGCVMR
179400200528      ************                                                                     179510 200400
179500200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
179600200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
179700200528      ************                                                                     179510 200400
179800200528     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
179900200528     C************       MOVE      @@MOPI        IGMOPI                                179510 200400
180000200528     C************       ENDIF                                                         179510 200400
180100200528      *
180200200528      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
180300200528      *
180400200528     C**********         MOVEL     FLREC         IGREC                                        CGL029
180500200528     C                   EVAL      %SUBST(IGREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
180600200528     C                   EVAL      IGRONS = %SUBST(FLREC:3:18)                                CGL029
180700200528     C                   EVAL      %SUBST(IGREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
180800200528     C                   MOVEL     FLROBR        IGOSBR
180900200528      *
181000200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
181100200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
181200200528      ************                                                                     179510 200400
181300200528     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
181400200528     C************       MOVE      @@MORI        IGMORI                                179510 200400
181500200528     C************       ENDIF                                                         179510 200400
181600200528      ************                                                                     179510 200400
181700200528      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
181800200528      *
181900200528     C                   MOVEL     FLPSCY        IGSTCY
182000200528     C                   MOVEL     FLIC72        IGIC72
182100200528     C                   END
182200200528      *
182300200528     C                   ENDSR
182400200528      *****************************************************************
182500200528      /EJECT
182600200528      *****************************************************************
182700200528      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
182800200528      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
182900200528      *****************************************************************
183000200528     C     SCRN@C        BEGSR
183100200528      *
183200200528      * Prior to validation, initialize error indicators as 'OK'
183300200528      *
183400200528     C                   MOVE      *ALL'Y'       MMEDEAM
183500200528      *
183600200528      * Validate deam details
183700200528      *
183800200528     C                   CALLB     'MMDEAMVAL'
183900200528     C                   PARM                    RespMode
184000200528     C                   PARM                    NwDlScnFmt
184100200528     C                   PARM                    InfData                        CAP051
184200200528     C                   PARM                    ExtData                        CAP004
184300200528     C                   PARM                    MMEDEAM
184400200528     C                   PARM                    FldNameArr
184500200528     C                   PARM                    MsgIdArr
184600200528     C                   PARM                    MsgDtaArr
184700200528     C                   PARM      *ZERO         Idx               3 0
184800200528     C                   PARM                    WFldNamArr
184900200528     C                   PARM                    WMsgIdArr
185000200528     C                   PARM                    WMsgDtaArr
185100200528     C                   PARM      *ZERO         WIdx              3 0
185200200528     C                   PARM                    NwDlFilFmt
185300200528      *
185400200528      * If transaction is valid output message 'Press enter to accept'
185500200528      *
185600200528     C     Idx           IFEQ      *ZERO
185700200528     C                   MOVEL     '*ANY'        FldNameArr(1)
185800200528     C                   MOVEL     'MMM1030'     MsgIdArr(1)
185900200528     C                   END
186000200528      *
186100200528      * WRITE/READ DISPLAY SCREEN
186200200528      *
186300200528     C                   CALLB     'MMDEAMDSP'
186400200528      *
186500200528      * INPUT PARAMETERS
186600200528      *
186700200528      * RETURN CODE
186800200528     C                   PARM      *BLANK        RetCodeOut
186900200528      *
187000200528      * DEAM (IN SCREEN FORMAT)
187100200528     C                   PARM                    NwDlScnFmt
187200200528      *
187300200528      * DEAM STATUS
187400200528     C                   PARM                    DDSTS            24
187500200528      *
187600200528      * FIELDS IN ERROR
187700200528     C                   PARM                    MMEDEAM
187800200528      *
187900200528      * ERRORS
188000200528     C                   PARM                    FldNameArr
188100200528     C                   PARM                    MsgIdArr
188200200528     C                   PARM                    MsgDtaArr
188300200528      *
188400200528      * WARNINGS
188500200528     C                   PARM                    WFldNamArr
188600200528     C                   PARM                    WMsgIdArr
188700200528     C                   PARM                    WMsgDtaArr
188800200528      *
188900200528      * ENABLED KEY & DETAIL FIELDS
189000200528      *
189100200528     C                   PARM      'N'           @EKYFD
189200200528     C                   PARM      'N'           @EDTFD
189300200528      *
189400200528      * ENABLED FUNCTION KEYS
189500200528     C                   PARM      'N'           @EINKG
189600200528     C                   PARM      'N'           @EINKH
189700200528     C                   PARM      'N'           @EINKJ
189800200528     C                   PARM      'N'           @EINKN
189900200528     C                   PARM      'N'           @EINKP
190000200528      *
190100200528      * SUCCESFUL INSERT DEAM
190200200528     C                   PARM                    @LSQN             3
190300200528      *
190400200528      * OUTPUT PARAMETERS
190500200528      *
190600200528      * FUNCTION KEYS
190700200528     C                   PARM      '0'           @INKC             1
190800200528     C                   PARM      '0'           @INKG             1
190900200528     C                   PARM      '0'           @INKH             1
191000200528     C                   PARM      '0'           @INKJ             1
191100200528     C                   PARM      '0'           @INKL             1
191200200528     C                   PARM      '0'           @INKN             1
191300200528     C                   PARM      '0'           @INKP             1
191400200528     C                   PARM      'N'           WriteOnly         1
191500200528     C/COPY WNCPYSRC,MMDEAMRC09
191600200528      *
191700200528      * RESET ERRORS
191800200528      *
191900200528     C                   MOVE      *ALL'Y'       MMEDEAM
192000200528     C                   MOVEL     *BLANK        FldNameArr
192100200528     C                   MOVEL     *BLANK        MsgIdArr
192200200528     C                   MOVEL     *BLANK        MsgDtaArr
192300200528     C                   MOVEL     *BLANK        WFldNamArr
192400200528     C                   MOVEL     *BLANK        WMsgIdArr
192500200528     C                   MOVEL     *BLANK        WMsgDtaArr
192600200528      *
192700200528      * CK/3 - END PROGRAM
192800200528      *
192900200528     C     @INKC         CASEQ     '1'           ENDP
193000200528      *
193100200528      * CK/12 - CANCEL ON CONFIRMATION SCREEN
193200200528      *
193300200528     C     @INKL         CASEQ     '1'           CANC@C
193400200528      *
193500200528      * EXIT CONFIRMATION SCREEN
193600200528      *
193700200528     C                   CAS                     EXIT@C
193800200528     C                   END
193900200528      *
194000200528     C                   ENDSR
194100200528      *****************************************************************
194200200528      /EJECT
194300200528      *****************************************************************
194400200528      * CANC@C - CANCEL ON CONFIRMATION SCREEN
194500200528      *****************************************************************
194600200528     C     CANC@C        BEGSR
194700200528      *
194800200528      * RETURN TO MAIN DETAILS SCREEN
194900200528      *
195000200528     C                   MOVEL     'M'           @SCRN
195100200528      *
195200200528     C                   ENDSR
195300200528      *****************************************************************
195400200528      /EJECT
195500200528      *****************************************************************
195600200528      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
195700200528      *****************************************************************
195800200528     C     EXIT@C        BEGSR
195900200528      *
196000200528      * IF NO ERRORS IN VALIDATION
196100200528      *
196200200528     C     Idx           IFEQ      *ZERO
196300200528      *
196400200528      * CONTINUE WITH UPDATES
196500200528      *
196600200528     C                   MOVEL     'U'           @SCRN
196700200528      *
196800200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
196900200528      *
197000200528     C                   ELSE
197100200528     C                   MOVEL     'M'           @SCRN
197200200528     C                   END
197300200528      *
197400200528     C                   ENDSR
197500200528      *****************************************************************
197600200528      /EJECT
197700200528      *****************************************************************
197800200528      *                                                               *
197900200528      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
198000200528      *              for Inserts.                                     *
198100200528      *                                                               *
198200200528      *****************************************************************
198300200528     C     SETUPDASEQ    BEGSR
198400200528     C*
198500200528     C**  Load deal number into numeric field passed to MM0085
198600200528     C                   MOVE      DDDLNO        DealNo            6 0
198700200528     C*
198800200528     C** Format Value Date
198900200528     C     DDVDAT        IFNE      *BLANKS                                      B1
199000200528     C*
199100200528     C** Load value date to numeric keyfield,in YYYYMMDD format
199200200528     C                   MOVE      DDVDAT        @VDAT
199300200528
199400200528     C                   Z-ADD     0             @PDAT                          **2
199500200528     C                   MOVE      @DSPY         @PYEAR                         **2
199600200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
199700200528     C                   MOVE      @DSPD         @PDDD                          **2
199800200528     C                   ELSE                                                                  BHF18
199900200528     C                   MOVE      @DSPD         @PDMM                                         BHF18
200000200528     C                   END                                                                   BHF18
200100200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
200200200528     C                   MOVE      @DSPM         @PDMM                          **2
200300200528     C                   ELSE                                                                  BHF18
200400200528     C                   MOVE      @DSPM         @PDDD                                         BHF18
200500200528     C                   END                                                                   BHF18
200600200528     C*
200700200528     C** Century
200800200528     C     @PYEAR        IFGE      72                                           B**3
200900200528     C     @PDYY         ADD       1900          @PDYY                          ***3
201000200528     C                   ELSE                                                   ***3
201100200528     C     @PDYY         ADD       2000          @PDYY                          ***3
201200200528     C                   END                                                    E**3
201300200528     C                   ELSE                                                   X1
201400200528     C                   Z-ADD     0             @PDAT                          *1
201500200528     C                   END                                                    E1
201600200528     C                   Z-ADD     @PDAT         ValueDate         8 0
201700200528
201800200528      ** Generate DEAM Sequence Number
201900200528     C                   CALLB     'MM0085'
202000200528     C                   PARM                    Term              1
202100200528     C                   PARM                    DealNo
202200200528     C                   PARM                    ValueDate
202300200528     C                   PARM                    SeqNoPack         3 0
202400200528      *
202500200528      ** If error returned from MM0085
202600200528     C     Term          IFNE      *BLANK
202700200528     C                   EXSR      *PSSR
202800200528     C                   ELSE
202900200528     C                   Z-ADD     SeqNoPack     IGDS38
203000200528     C                   MOVEL     IGDS38        @LSQN
203100200528     C                   ENDIF
203200200528
203300200528     C                   ENDSR
203400200528      *****************************************************************
203500200528      /EJECT
203600200528      *****************************************************************
203700200528      * UPDATS - UPDATES
203800200528      *****************************************************************
203900200528     C     UPDATS        BEGSR
204000200528      *
204100200528      * For inserts generate Deal Amendment Sequence Number
204200200528      * if not already generated in window process
204300200528      *
204400200528     C     DDACTN        IFEQ      'I'
204500200528     C     BGWDPR        ANDNE     'Y'
204600200528     C                   EXSR      SETUPDASEQ
204700200528     C                   ENDIF
204800200528      *
204900200528      * UPDATE VALID DEAM: DEAL NUMBER
205000200528      *
205100200528     C                   MOVEL     DDDLNO        IGDA38
205200200528      *
205300200528      * UPDATE VALID DEAM: LAST ACTION CODE
205400200528      *
205500200528     C                   MOVEL     DDACTN        IGLACT
205600200528      *
205700200528      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
205800200528      *
205900200528     C                   MOVEL     @FOTRANSEL    IGFRNT
206000200528      *
206100200528      * UPDATE VALID DEAL: FRONT OFFICE ASSOCIATED TRANSACTION ID
206200200528      *
206300200528     C                   MOVEL     @FOASOCSEL    IGAFRT
206400200528      *
206500200528      * MONEY MARKET DATABASE UPDATES
206600200528      *
206700200528     C                   CALLB     'MMDEAMUPM'
206800200528     C                   PARM      *BLANK        @RTCD             7
206900200528     C                   PARM                    NwDlFilFmt
207000200528      *
207100200528      * DEAMS UPDATES
207200200528      *
207300200528     C     @RTCD         IFEQ      *BLANK
207400200528     C                   CALLB     'MMDEAMUPD'
207500200528     C                   PARM                    @RTCD
207600200528     C                   PARM                    NwDlFilFmt
207700200528     C                   END
207800200528      *
207900200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
208000200528      * UPDATES AND END THIS PROGRAM.
208100200528      * OTHERWISE DELETE THE INVALID  DEAM ACTIONED & COMMIT THE UPDATES
208200200528      *
208300200528     C     @RTCD         IFNE      *BLANK
208400200528     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
208500200528     C                   If        (CSC022 = 'N')                                             CSC022
208600200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
208700200528     C                   ROLBK
208800200528     C                   Else                                                                 CSC022
208900200528     C                   SetOn                                        U7U8                    CSC022
209000200528     C                   EndIf                                                                CSC022
209100200528     C     @RTCD         IFNE      '*RECUPD'                                    168345
209200200528     C                   EXSR      *PSSR
209300200528     C                   ENDIF                                                  168345
209400200528     C                                                                          CAP006
209500200528     C                   ELSE
209600200528     C     ZATRNKD0      CHAIN     MMIDEAMD0                          99
209700200528     C  N99              DELETE    MMIDEAMD0
209800200528     C     APDSETK0      CHAIN     APIDSETD0                          99
209900200528     C  N99              DELETE    APIDSETD0
210000200528                                                                                              CSC011
210100200528      ** Delete invalid record from the log file                                              CSC011
210200200528                                                                                              CSC011
210300200528     C                   IF        CSC011 = 'Y' AND                                           CSC011
210400200528     C                             S1SUPP = LIBR                                              CSC011
210500200528                                                                                              CSC011
210600200528     C                   EVAL      KMsgType = @MSGTYPE                                        CSC011
210700200528     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
210800200528     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
210900200528                                                                                              CSC011
211000200528     C     KAPLOG        CHAIN     APILOGL0                           99                      CSC011
211100200528                                                                                              CSC011
211200200528     C                   IF        *IN99 = *OFF                                               CSC011
211300200528     C                   DELETE    APILOGL0                                                   CSC011
211400200528     C                   ENDIF                                                                CSC011
211500200528                                                                                              CSC011
211600200528     C                   ENDIF                                                                CSC011
211700200528                                                                                              CSC011
211800200528     C                   If        (CSC022 = 'N')                                             CSC022
211900200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
212000200528     C                   COMMIT
212100200528     C                   EndIf                                                                CSC022
212200200528     C                   END
212300200528      *
212400200528      * If error occurred in updating last transaction set on flag to           CAP006
212500200528      * display message on 'browse' screen.                                     CAP006
212600200528     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
212700200528     C                   MOVE      'Y'           @ERRUP                         CAP006
212800200528     C                   ELSE                                                   CAP006
212900200528     C                   MOVE      'N'           @ERRUP                         CAP006
213000200528     C                   END                                                    CAP006
213100200528     C                                                                          CAP006
213200200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
213300200528      *
213400200528     C     @RDNB         IFEQ      'Y'
213500200528     C                   MOVEL     'R'           @SCRN
213600200528     C                   ELSE
213700200528      *
213800200528      * ELSE, RETURN TO THE BROWSE SCREEN
213900200528      *
214000200528     C                   MOVEL     'B'           @SCRN
214100200528     C                   END
214200200528      *
214300200528     C                   ENDSR
214400200528      *****************************************************************
214500200528      /EJECT
214600200528      *****************************************************************
214700200528      * ENDP - END PROGRAM
214800200528      *****************************************************************
214900200528     C     ENDP          BEGSR
215000200528     C                   MOVEL     'T'           @SCRN
215100200528     C                   ENDSR
215200200528      *****************************************************************
215300200528      /EJECT                                                                    CAP011
215400200528      *****************************************************************         CAP011
215500200528      *                                                               *         CAP011
215600200528      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
215700200528      *                                                               *         CAP011
215800200528      *****************************************************************         CAP011
215900200528                                                                                CAP011
216000200528     C     TDtDtaSubs    BEGSR                                                  CAP011
216100200528                                                                                CAP011
216200200528     C                   RESET                   ReturnCode                     CAP011
216300200528     C                   CALLB     'APDTASUBS'                                  CAP011
216400200528                                                                                CAP011
216500200528      * Return Code                                                             CAP011
216600200528     C                   PARM                    ReturnCode       10            CAP011
216700200528      * Substitution character                                                  CAP011
216800200528     C                   PARM      GHSUBS        SubsChar          1            CAP011
216900200528      * Incoming Data                                                           CAP011
217000200528     C                   PARM      NwDlScnFmt    IncDATA        2000            CAP011
217100200528      * Current Data                                                            CAP011
217200200528     C                   PARM      CrDlScnfmt    CurDATA        2000            CAP011
217300200528                                                                                CAP011
217400200528     C                   MOVEL     IncDATA       NwDlScnFmt                     CAP011
217500200528                                                                                CAP011
217600200528     C                   ENDSR                                                  CAP011
217700200528      *****************************************************************         CAP011
217800200528      /EJECT                                                                    CAP011
217900200528      *****************************************************************         CAP011
218000200528      *                                                               *         CAP011
218100200528      * SetupAmend - Setup Settlement Instructions on Amendment       *         CAP011
218200200528      *                                                               *         CAP011
218300200528      *****************************************************************         CAP011
218400200528                                                                                CAP011
218500200528     C     SetupAmend    BEGSR                                                  CAP011
218600200528                                                                                CAP011
218700200528      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
218800200528     C**********         MOVEL     HNREC         FLREC                                 CAP011 CGL029
218900200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(HNREC:1:2)                      CGL029
219000200528     C                   EVAL      %SUBST(FLREC:3:18) = HNRONS                                CGL029
219100200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(HNREC:15:55)                  CGL029
219200200528     C                   MOVEL     HNOSBR        FLROBR                         CAP011
219300200528     C                   MOVEL     HNSTCY        FLRSCY                         CAP011
219400200528     C**********         MOVEL     HNPAY         FLPAY                                 CAP011 CGL029
219500200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(HNPAY:1:2)                      CGL029
219600200528     C                   EVAL      %SUBST(FLPAY:3:18) = HNPONS                                CGL029
219700200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(HNPAY:15:545)                CGL029
219800200528     C                   MOVEL     HNOSBR        FLPOBR                         CAP011
219900200528     C                   MOVEL     HNCVMR        FLCVMR                         CAP011
220000200528     C                   MOVEL     HNSTCY        FLPSCY                         CAP011
220100200528     C                   MOVEL     HNIC72        FLIC72                         CAP011
220200200528                                                                                CAP011
220300200528     C                   CALLB     'ZASETINCVT'                                 CAP011
220400200528                                                                                CAP011
220500200528      ** Deal Settlement Instructions in file format                            CAP011
220600200528     C                   PARM                    ##PAYF                         CAP011
220700200528     C                   PARM                    ##RECF                         CAP011
220800200528     C                   PARM      *BLANK        ##FRIF                         CAP011
220900200528                                                                                CAP011
221000200528      ** Current Settlement Instruction in input format                         CAP011
221100200528     C                   PARM      *BLANK        CrPaySttmt                     CAP011
221200200528     C                   PARM      *BLANK        CrRecSttmt                     CAP011
221300200528     C                   PARM      *BLANK        CrFRASttmt                     CAP011
221400200528     C                   PARM      HNCCY         InRCCY                                      CSF011A
221500200528     C                   PARM      HNCCY         InPCCY                                      CSF011A
221600200528                                                                                CAP011
221700200528      *  If no Payment or Receive instructions have been supplied               CAP011
221800200528      *  Default them to those currently on the deal.                           CAP011
221900200528                                                                                CAP011
222000200528     C                   IF            (##PAYS = *blank)                        CAP011
222100200528     C                   EVAL      ##PAYS = CrPaySttmt                          CAP011
222200200528     C                   ENDIF                                                  CAP011
222300200528                                                                                CAP011
222400200528     C                   IF            (##RECS = *blank)                        CAP011
222500200528     C                   EVAL      ##RECS = CrRecSttmt                          CAP011
222600200528     C                   ENDIF                                                  CAP011
222700200528                                                                                CAP011
222800200528     C                   ENDSR                                                  CAP011
222900200528      *****************************************************************         CAP011
223000200528      /EJECT                                                                    CAP011
223100200528      *****************************************************************         CAP011
223200200528      *                                                               *         CAP011
223300200528      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
223400200528      *                                                               *         CAP011
223500200528      *****************************************************************         CAP011
223600200528                                                                                CAP011
223700200528     C     SDtDtaSubs    BEGSR                                                  CAP011
223800200528                                                                                CAP011
223900200528      ** PAYMENT INSTRUCTIONS                                                   CAP011
224000200528     C                   RESET                   ReturnCode                     CAP011
224100200528     C                   CALLB     'APDTASUBS'                                  CAP011
224200200528                                                                                CAP011
224300200528      * Return Code                                                             CAP011
224400200528     C                   PARM                    ReturnCode                     CAP011
224500200528      * Substitution character                                                  CAP011
224600200528     C                   PARM      GHSUBS        SubsChar                       CAP011
224700200528      * Incoming Data                                                           CAP011
224800200528     C                   PARM      ##PAYS        IncDATA                        CAP011
224900200528      * Current Data                                                            CAP011
225000200528     C                   PARM      CrPaySttmt    CurDATA                        CAP011
225100200528                                                                                CAP011
225200200528     C                   MOVEL     IncDATA       ##PAYS                         CAP011
225300200528                                                                                CAP011
225400200528      ** RECEIPT INSTRUCTIONS                                                   CAP011
225500200528     C                   RESET                   ReturnCode                     CAP011
225600200528     C                   CALLB     'APDTASUBS'                                  CAP011
225700200528                                                                                CAP011
225800200528      * Return Code                                                             CAP011
225900200528     C                   PARM                    ReturnCode                     CAP011
226000200528      * Substitution character                                                  CAP011
226100200528     C                   PARM      GHSUBS        SubsChar                       CAP011
226200200528      * Incoming Data                                                           CAP011
226300200528     C                   PARM      ##RECS        IncDATA                        CAP011
226400200528      * Current Data                                                            CAP011
226500200528     C                   PARM      CrRecSttmt    CurDATA                        CAP011
226600200528                                                                                CAP011
226700200528     C                   MOVEL     IncDATA       ##RECS                         CAP011
226800200528                                                                                CAP011
226900200528     C                   ENDSR                                                  CAP011
227000200528      *****************************************************************         CAP011
227100200528      /EJECT
227200200528      *****************************************************************
227300200528      * *INZSR - INITIAL PROCESSING
227400200528      *****************************************************************
227500200528     C     *INZSR        BEGSR
227600200528      *
227700200528      ** Initialize program name
227800200528      *
227900200528     C                   MOVEL     'MMIDEAMMNT'  DBPGM
228000200528      *
228100200528      ** ACCESS BANK DETAILS
228200200528      *
228300200528     C                   CALL      'AOBANKR0'
228400200528     C                   PARM      *BLANKS       @RTCD             7
228500200528     C                   PARM      '*FIRST '     @OPTN             7
228600200528     C     SDBANK        PARM      SDBANK        DSFDY
228700200528      *
228800200528      * DATABASE ERROR
228900200528      *
229000200528     C     @RTCD         IFNE      *BLANKS
229100200528     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
229200200528     C                   MOVEL     '901'         DBASE                          * DBERR 901*
229300200528     C                   MOVEL     @OPTN         DBKEY                          ************
229400200528     C                   EXSR      *PSSR
229500200528     C                   END
229600200528      *                                                                         CAP051
229700200528      ** Access SAR details file to determine if CAP051 is on.                  CAP051
229800200528      ** (Automatic Authorisation (MM Part))                                    CAP051
229900200528      *                                                                         CAP051
230000200528     C                   MOVEL     'N'           CAP051                         CAP051
230100200528     C                   CALLB     'AOSARDR0'                                   CAP051
230200200528     C                   PARM      *BLANKS       @RTCD                          CAP051
230300200528     C                   PARM      '*VERIFY'     @OPTN                          CAP051
230400200528     C                   PARM      'CAP051'      @SARD             6            CAP051
230500200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
230600200528      *                                                                         CAP051
230700200528     C     @RTCD         IFEQ      *BLANKS                                      CAP051
230800200528     C                   MOVEL     'Y'           CAP051            1            CAP051
230900200528     C                   ENDIF                                                  CAP051
231000200528                                                                                              CSC011
231100200528      ** Check if CSC011 is installed                                                         CSC011
231200200528                                                                                              CSC011
231300200528     C                   CALLB     'AOSARDR0'                                                 CSC011
231400200528     C                   PARM      *BLANKS       PRTCD                                        CSC011
231500200528     C                   PARM      '*VERIFY'     POPTN                                        CSC011
231600200528     C                   PARM      'CSC011'      PSARD                                        CSC011
231700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
231800200528                                                                                              CSC011
231900200528     C                   IF        PRTCD = *Blanks                                            CSC011
232000200528                                                                                              CSC011
232100200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
232200200528                                                                                              CSC011
232300200528     C                   OPEN      APILOGL0                                                   CSC011
232400200528                                                                                              CSC011
232500200528     C                   IN        SC24X7                                                     CSC011
232600200528     C                   IN        SDSTAT                                                     CSC011
232700200528                                                                                              CSC011
232800200528     C                   ELSE                                                                 CSC011
232900200528                                                                                              CSC011
233000200528      ** Database error                                                                       CSC011
233100200528                                                                                              CSC011
233200200528     C                   IF        PRTCD <> '*NRF'                                            CSC011
233300200528     C     *LOCK         IN        LDA                                                        CSC011
233400200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
233500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
233600200528     C                   EVAL      DBASE = 904                                                CSC011
233700200528     C                   OUT       LDA                                                        CSC011
233800200528     C                   EXSR      *PSSR                                                      CSC011
233900200528     C                   ENDIF                                                                CSC011
234000200528                                                                                              CSC011
234100200528     C                   ENDIF                                                                CSC011
234200200528      *
234300200528      ** Access Module Details
234400200528      *
234500200528     C                   CALL      'AOMMODR0'
234600200528     C                   PARM      *BLANKS       @RTCD
234700200528     C                   PARM      '*FIRST '     @OPTN
234800200528     C     SDMMOD        PARM      SDMMOD        DSFDY
234900200528      *
235000200528      * DATABASE ERROR
235100200528      *
235200200528     C     @RTCD         IFNE      *BLANKS
235300200528     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
235400200528     C                   MOVEL     '902'         DBASE                          * DBERR 902*
235500200528     C                   MOVEL     @OPTN         DBKEY                          ************
235600200528     C                   EXSR      *PSSR
235700200528     C                   END
235800200528      *                                                                         CAP011
235900200528      ** Access API ICD Details                                                 CAP011
236000200528      *                                                                         CAP011
236100200528     C                   CALLB     'AOAPIR0'                                    CAP011
236200200528     C                   PARM      *BLANKS       @RTCD                          CAP011
236300200528     C                   PARM      '*FIRST '     @OPTN                          CAP011
236400200528     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
236500200528      *                                                                         CAP011
236600200528      * DATABASE ERROR                                                          CAP011
236700200528      *                                                                         CAP011
236800200528     C     @RTCD         IFNE      *BLANKS                                      CAP011
236900200528     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
237000200528     C                   MOVEL     '903'         DBASE                          CAP011
237100200528     C                   MOVEL     @OPTN         DBKEY                          CAP011
237200200528     C                   EXSR      *PSSR                                        CAP011
237300200528     C                   END                                                    CAP011
237400200528      *
237500200528      * Key Lists
237600200528      *
237700200528     C     ZATRNKD0      KLIST
237800200528     C                   KFLD                    @FOTRANSEL
237900200528     C                   KFLD                    @TMESTPSEL
238000200528     C     ZATRNKX0      KLIST
238100200528     C                   KFLD                    @TMESTPSEL
238200200528     C                   KFLD                    @FOTRANSEL
238300200528     C     APDSETK0      KLIST
238400200528     C                   KFLD                    @MSGTYPE
238500200528     C                   KFLD                    @FOTRANSEL
238600200528     C                   KFLD                    @TMESTPSEL
238700200528     C     APDSETKX      KLIST
238800200528     C                   KFLD                    @MSGTYPE
238900200528     C                   KFLD                    @TMESTPSEL
239000200528     C                   KFLD                    @FOTRANSEL
239100200528                                                                                              CSC011
239200200528     C     KAPLOG        KLIST                                                                CSC011
239300200528     C                   KFLD                    KMsgType                                     CSC011
239400200528     C                   KFLD                    KFrntOffID                                   CSC011
239500200528     C                   KFLD                    KTimeStamp                                   CSC011
239600200528
239700200528      ** Message Type
239800200528     C*******************MOVEL     'MMDEAM'      @MSGTYPE          8            CAP004
239900200528     C                   MOVEL     'MMDEAM'      @MSGTYPE                       CAP004
240000200528
240100200528      ** Get the field number for the action code field; the screen fields
240200200528      ** start from that number.  Subtract one from it to give the value
240300200528      ** to subtract from each field's number.
240400200528     C                   CALLB     'ZACGTFLDNO'
240500200528     C                   PARM                    ReturnCode
240600200528     C                   PARM                    Format
240700200528     C                   PARM                    Field
240800200528     C                   PARM                    FieldNo
240900200528
241000200528     C                   IF        ReturnCode = *blank
241100200528     C                   EVAL      FldOffset = FieldNo - 1
241200200528
241300200528      ** If there was an error default the offset to 13
241400200528     C                   ELSE
241500200528     C                   EVAL      FldOffset = 13
241600200528     C                   ENDIF
241700200528      *
241800200528      * Start on Browse Screen
241900200528      *
242000200528     C                   MOVEL     'B'           @SCRN             1
242100200528      *
242200200528
242300200528      *  Hook to enable non-core initial processing to be included
242400200528      /COPY WNCPYSRC,MMDEAMR012
242500200528
242600200528      ** Access SAR details file to determine if Commitment Control                           CSC022
242700200528      ** Changes is switched on.                                                              CSC022
242800200528     C                   CallB     'AOSARDR0'                                                 CSC022
242900200528     C                   Parm      *BLANKS       @RTCD                                        CSC022
243000200528     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
243100200528     C                   Parm      'CSC022'      @SARD                                        CSC022
243200200528     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
243300200528                                                                                              CSC022
243400200528     C                   If        @RTCD = *BLANKS                                            CSC022
243500200528      *                                                                                       CSC022
243600200528     C                   Eval      CSC022 = 'Y'                                               CSC022
243700200528     C                   In        SCCMTJOB                                                   CSC022
243800200528     C                   If        ComitNum > 0                                               CSC022
243900200528      ** Check if Current Job exists in the Commitment Job Names                              CSC022
244000200528      ** Data Area.                                                                           CSC022
244100200528     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
244200200528     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
244300200528     C                   If        *IN20                                                      CSC022
244400200528     C                   Eval      wCommitSkip = 'Y'                                          CSC022
244500200528     C                   EndIf                                                                CSC022
244600200528     C                   EndIf                                                                CSC022
244700200528      *                                                                                       CSC022
244800200528     C                   Else                                                                 CSC022
244900200528      ** Database error                                                                       CSC022
245000200528     C                   If        @RTCD <> '*NRF'                                            CSC022
245100200528     C     *LOCK         In        LDA                                                        CSC022
245200200528     C                   Eval      DBKey = 'CSC022'                                           CSC022
245300200528     C                   Eval      DBPgm = 'MMDEAMRPR'                                        CSC022
245400200528     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
245500200528     C                   Eval      DBase = 905                                                CSC022
245600200528     C                   Out       LDA                                                        CSC022
245700200528     C                   ExSr      *PSSR                                                      CSC022
245800200528     C                   EndIf                                                                CSC022
245900200528      *                                                                                       CSC022
246000200528     C                   EndIf                                                                CSC022
246100200528     C                   ENDSR
246200200528      *****************************************************************
246300200528      /EJECT
246400200528      *****************************************************************
246500200528      ** Program, module and procedure names for database error processing.
246600200528      ** =================================================================
246700200528      ** The following /COPY sets these values, and also defines LDA as
246800200528      ** an external data area
246900200528      ********************************************************************
247000200528      /COPY ZACPYSRC,PSSR_ILE
247100200528      ********************************************************************
247200200528**  CPY@
247300200528(c) Finastra International Limited 2001
