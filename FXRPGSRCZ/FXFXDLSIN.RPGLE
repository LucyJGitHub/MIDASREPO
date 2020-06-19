000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Input')                                       *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  FXFXDLSIN - FX DEALS SCREEN INPUT                            *
001100200528      *                                                               *
001200200528      *  Function:  This is the main screen input function            *
001300200528      *             for FX deals.                                     *
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
002400200528      *                 CSF011A            Date 28Nov11               *
002500200528      *                 CER059             Date 19Jul10               *
002600200528      *                 CER043             Date 19May08               *
002700200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002800200528      *                 258601             Date 17Feb09               *
002900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000200528      * Midas Plus 1.4 Base ------------------------------------------*
003100200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003200200528      *                 CDL049             Date 07Jul06               *
003300200528      *                 CSD027             Date 09Dec05               *
003400200528      *                 CLE031             Date 26Apr05               *
003500200528      *                 CDL038             Date 10May05               *
003600200528      *                 CFX114             Date 15Jun04               *
003700200528      *                 CDL018             Date 03Feb04               *
003800200528      *                 CSC022             Date 24Feb04               *
003900200528      *                 CGL029             Date 01Sep03               *
004000200528      *                 CDL010             Date 02Aug02               *
004100200528      *                 CAS004             Date 26Jun02               *
004200200528      * Midas Release 4.01.02 ----------------------------------------*
004300200528      *                 196952             Date 06May02               *
004400200528      *                 192916             Date 26Mar02               *
004500200528      * Midas Release 4.01 -------------------------------------------*
004600200528      *                 CAS001             Date 23Nov01               *
004700200528      *                 195763             Date 07Jan02               *
004800200528      * Midas Release 4 --------------- Base -------------------------*
004900200528      *                 200400             Date 20Nov01               *
005000200528      *                 185612             Date 04Jul01               *
005100200528      *                 192530             Date 16May01               *
005200200528      * Midas DBA 3.05 -----------------------------------------------*
005300200528      *                 CPB002             Date 08Aug00               *
005400200528      * Midas DBA 3.04 -----------------------------------------------*
005500200528      *                 179510             Date 06Nov00               *
005600200528      *                 CDL008             Date 02May00               *
005700200528      *                 183225             Date 02May00               *
005800200528      *                 182224             Date 24Aug00               *
005900200528      *                 181721             Date 10Aug00               *
006000200528      * Midas DBA 3.03 -----------------------------------------------*
006100200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
006200200528      *                 176883             Date 24Mar00               *
006300200528      * Midas DBA 3.02 -----------------------------------------------*
006400200528      *                 CAP052             DATE 11Nov99               *
006500200528      *                 CAP051             DATE 11Nov99               *
006600200528      *                 CPB001             Date 01Jun99               *
006700200528      *                 165402             Date 04Aug99               *
006800200528      * Midas DBA 3.00 ---------------- Base -------------------------*
006900200528      *                 CAP006             DATE 24Feb99               *
007000200528      *                 CAP004             Date 07Sep98               *
007100200528      *                 136433             Date 10Jun98               *
007200200528      *                 CAP002  *CREATE    Date 22Sep97               *
007300200528      *                                                               *
007400200528      *---------------------------------------------------------------*
007500200528      *                                                               *
007600200528      *  251029 - Applied fix 231306.                                 *
007700200528      *  231306 - Handle file locking properly.                       *
007800200528      *  MD046248 - Finastra Rebranding                               *
007900200528      *  MD047971 - Do not allow amendment to settlement account if   *
008000200528      *             that side is already netted.                      *
008100200528      *  CDL099 - Split Value Date (Recompile)                        *
008200200528      *  MD036070 - No way to go back to main deal details screen     *
008300200528      *             after reaching settlement screen.  Introduce new  *
008400200528      *             function key F11.                                 *
008500200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
008600200528      *           (Recompile)                                         *
008700200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
008800200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
008900200528      *  CER059 - German Feature Upgrade to Delhi                     *
009000200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
009100200528      *           (Recompile)                                         *
009200200528      *  258601 - Validate value date against the back value period   *
009300200528      *           defined in PF/SDBANKPD.                             *
009400200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
009500200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
009600200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
009700200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
009800200528      *  CFX114 - Core changes for GBO014                             *
009900200528      *         - Perform Override when Exchange Rate Tolerance is    *
010000200528      *           exceeded.                                           *
010100200528      *         - Upgrade to Midasplus                                *
010200200528      *           Core hooks amended:FXFXDLS008,FXFXDLSC35,FXFXDLSC37,*
010300200528      *                              FXFXDLSC48                       *
010400200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
010500200528      *           (Recompile)                                         *
010600200528      *  CSC022 - Commitment Control Changes for MidasPlus            *
010700200528      *  CGL029 - Increase Account Code to 10 digits                  *
010800200528      *  CDL010 - Prevent last user that actioned the trade from      *
010900200528      *           authorising it.Recompile due to changes in FXDEALPP *
011000200528      *  CAS004 - Hedge Accounting Phase A                            *
011100200528      *  196952 - Ensure Rate has 5 digits before decimal separator   *
011200200528      *           and 8 digits after.                                 *
011300200528      *           Recompiled due to changes in FXFXDLPD.              *
011400200528      *  192916 - Rollback of window updates wrongly managed in Core  *
011500200528      *           API's modules RPR and SIN.                          *
011600200528      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
011700200528      *  195763 - Recompiled due to recompiled FXFXDLVAL.             *
011800200528      *  200400 - Reverse fix 179510                                  *
011900200528      *  185612 - Warning for FOREX Limit exceeded.                   *
012000200528      *  192530 - Pass the correct date to ZASETINSIN.                *
012100200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
012200200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
012300200528      *           Midas our Receive/Pay instructions  respectively  not
012400200528      *           correctly  updated .  Introduced  new  Data Structure
012500200528      *           @MORPI  which is used  for that purpose .           *
012600200528      *  CDL008 - Continuous Linked Settlement                        *
012700200528      *  183225 - SSI not defaulting properly in FX deals input       *
012800200528      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
012900200528      *           in   FX &  MM  input options .  When  F12  is pressed
013000200528      *           from  the last confirmation  screen ,  the  ROLBK   *
013100200528      *           is not performed  every time .                      *
013200200528      *  181721 - Allow amend to OP up to 'Option to Date'            *
013300200528      *  176883 - Errors found as a result of creating DBAR3.02       *
013400200528      *           Meridian repository file.                           *
013500200528      *           Mismatch on parameters for call to ZASETINDFT       *
013600200528      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
013700200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
013800200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
013900200528      *           Recompiled due to changes in FXDEALPP               *
014000200528      *  165402 - Fields on deals are being corrupted on amendment    *
014100200528      *  CAP006 - Check for deal being updated by another workstation *
014200200528      *  CAP004 - API's Phase 3.                                      *
014300200528      *           Add extra parm for Extra Data                       *
014400200528      *  136433 - Deals enquiry should not default settle instructions*
014500200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
014600200528      *                                                               *
014700200528      *****************************************************************
014800200528
014900200528     F/COPY WNCPYSRC,FXFXDLSF01
015000200528      *****************************************************************
015100200528      ** +--------------------------------------+
015200200528      ** ¦ Automatically included D-specs       ¦
015300200528      ** ¦ ==============================       ¦
015400200528      ** +--------------------------------------+
015500200528      **
015600200528      ** Standard D-specs
015700200528      ** ================
015800200528      **
015900200528      ** The following /COPY line includes the LDA layout,
016000200528      ** the copyright array definition,
016100200528      ** and the following named constants:
016200200528      **    True       logical = *on (for indcator processing)
016300200528      **    False      logical = *off (for indcator processing)
016400200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016500200528      **                                    handler)
016600200528      ** and the following variables:
016700200528      **    RunBefore  1A (for the PSSR)
016800200528
016900200528     D/COPY ZACPYSRC,STD_D_SPEC
017000200528
017100200528      ** Program Status Data Structure
017200200528      ** =============================
017300200528      ** The following /COPY line includes all the defined fields in the
017400200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
017500200528
017600200528     D/COPY ZACPYSRC,PSDS
017700200528
017800200528      **--------------------------------------------------------------------------------------------
017900200528      ** The following /COPY line includes the definitions for error and
018000200528      ** warning message arrays.
018100200528     D/COPY ZACPYSRC,ERR_ARRAYS
018200200528      **--------------------------------------------------------------------------------------------
018300200528
018400200528      ** +--------------------------------------+
018500200528      ** ¦ End of automatically included D-specs¦
018600200528      ** ¦ =====================================¦
018700200528      ** +--------------------------------------+
018800200528
018900200528      *****************************************************************
019000200528      /EJECT
019100200528      *****************************************************************
019200200528
019300200528      ** +--------------------------------------+
019400200528      ** ¦ Manually included D-specs            ¦
019500200528      ** ¦ =========================            ¦
019600200528      ** +--------------------------------------+
019700200528
019800200528      ** +--------------------------------------+
019900200528      ** ¦ Named constants                      ¦
020000200528      ** ¦ ===============                      ¦
020100200528      ** +--------------------------------------+
020200200528
020300200528      ** +--------------------------------------+
020400200528      ** ¦ Arrays and Data Structures           ¦
020500200528      ** ¦ ==========================           ¦
020600200528      ** +--------------------------------------+
020700200528
020800200528      * Array to hold Commitment Job Names                                                    CSC022
020900200528     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
021000200528                                                                                              CSC022
021100200528      ** Commitment Control Data Area                                                         CSC022
021200200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
021300200528     D  wComitJob              4    103                                                       CSC022
021400200528                                                                                              CSC022
021500200528     D CrDlFilFmt    E DS                  EXTNAME(FXDEALPP)
021600200528      * Current Deal in File Format
021700200528
021800200528     D CrDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
021900200528      * (Current) Deal in Screen Format
022000200528     D                                     PREFIX(@)
022100200528
022200200528     D NwDlFilFmt    E DS                  EXTNAME(FXVFXDLPD)
022300200528     D FXFXDLDORI    E                     EXTFLD(QQDORI)                                     CGL029
022400200528     D FXFXDLMORI    E                     EXTFLD(QQMORI)                                     CGL029
022500200528     D FXFXDLDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
022600200528     D FXFXDLMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
022700200528     D FXFXDLRONS    E                     EXTFLD(QQRONS)                                     CGL029
022800200528     D FXFXDLPONS    E                     EXTFLD(QQPONS)                                     CGL029
022900200528      * New Deal in File Format
023000200528     D  F3REC                400    468
023100200528     D  F3PAY                469   1027
023200200528
023300200528     D NwDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
023400200528      * New Deal in Screen Format
023500200528
023600200528     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)
023700200528      * Error indicators
023800200528
023900200528
024000200528     D ##RECF        E DS                  EXTNAME(SDESFRPD)
024100200528      ** FILE RECEIVE INSTRUCTIONS
024200200528     D***FLREC                  1     69                                                      CGL029
024300200528     D  FLREC                  1     75                                                       CGL029
024400200528
024500200528     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
024600200528      *** FILE PAYMENT INSTRUCTIONS
024700200528     D***FLPAY                  1    559                                                      CGL029
024800200528     D  FLPAY                  1    565                                                       CGL029
024900200528
025000200528     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
025100200528      ** FILE FRA/IRS INSTRUCTIONS
025200200528
025300200528     D ##RECS        E DS                  EXTNAME(SDESSRPD)
025400200528      ** SCREEN RECEIVE INSTRUCTIONS
025500200528
025600200528     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
025700200528      ** SCREEN PAYMENT INSTRUCTIONS
025800200528
025900200528     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
026000200528      ** SCREEN FRA/IRS INSTRUCTIONS
026100200528
026200200528     D/COPY WNCPYSRC,FXFXDLSD01
026300200528     D @SETIN          DS
026400200528      ** Receive / Pay Settlement Currency, Method & Nostro
026500200528     D  @@RSCY                 1      3
026600200528     D  @@RSTM                 4      5  0
026700200528     D***@@RONS                 6     17                                                      CGL029
026800200528     D***@@PSCY                18     20                                                      CGL029
026900200528     D***@@PSTM                21     22  0                                                   CGL029
027000200528     D***@@PONS                23     34                                                      CGL029
027100200528     D  @@RONS                 6     23                                                       CGL029
027200200528     D  @@PSCY                24     26                                                       CGL029
027300200528     D  @@PSTM                27     28  0                                                    CGL029
027400200528     D  @@PONS                29     46                                                       CGL029
027500200528
027600200528     D @CCI@M          DS
027700200528      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
027800200528     D  @EKYFD                 1      1
027900200528     D  @EDTFD                 2      2
028000200528     D  @EINKG                 3      3
028100200528     D  @EINKH                 4      4
028200200528     D  @EINKJ                 5      5
028300200528     D  @EINKN                 6      6
028400200528     D  @EINKP                 7      7
028500200528
028600200528     D @PCI@M          DS             7
028700200528      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN
028800200528
028900200528     D                 DS
029000200528      **  Data structure for date in, to change format.
029100200528     D  DateIn                 1      8  0
029200200528     D  @@YY                   1      4  0
029300200528     D  @@MM                   5      6  0
029400200528     D  @@DD                   7      8  0
029500200528
029600200528      ************                                                                     179510 200400
029700200528     D*@MORPI*****     DS                                                              179510 200400
029800200528      ***Midas*Our*Receive*/*Pay**Instructions*(for*Settl*Meth*=*04*)*******           179510 200400
029900200528     D**@@MORI****             1     12                                                179510 200400
030000200528     D**@@MOPI****            13     24                                                179510 200400
030100200528
030200200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
030300200528      ** EXTERNAL DS FOR BANK DETAILS
030400200528
030500200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
030600200528      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
030700200528                                                                                CDL008
030800200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
030900200528      ** Externally described DS for switchable feature details                 CDL008
031000200528
031100200528     D DSFDY         E DS                  EXTNAME(DSFDY)
031200200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
031300200528                                                                                CAP051
031400200528     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
031500200528     D                                     PREFIX(IF_)                          CAP051
031600200528      * FX (FXDL) Extra Data - File (D/B) format                                CAP051
031700200528                                                                                CAP004
031800200528     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
031900200528      * FX Extra Data - File (D/B) format                                       CAP004
032000200528     D/COPY WNCPYSRC,FXH00122
032100200528
032200200528     D/COPY QWINDSRC,FXDLSINDTA
032300200528
032400200528      ** +--------------------------------------+
032500200528      ** ¦ Declared variables                   ¦
032600200528      ** ¦ ==================                   ¦
032700200528      ** +--------------------------------------+
032800200528
032900200528      ** Response Mode, passed as a constant parameter to the VAL module
033000200528      ** This is always 'S' for Synchronous
033100200528     D RespMode        S              1A   INZ('S')
033200200528                                                                                              185612
033300200528      ** Buy Amount                                                                           185612
033400200528     D BAMT            S             13  0                                                    185612
033500200528                                                                                              185612
033600200528      ** Sell Amount                                                                          185612
033700200528     D SAMT            S             13  0                                                    185612
033800200528
033900200528      ** Work variables for CSC022                                                            CSC022
034000200528     D CSC022          S              1A   INZ('N')                                           CSC022
034100200528     D wCommitSkip     S              1A   INZ('N')                                           CSC022
034200200528     D DDRonxOK        S              1A   INZ('Y')                                         MD047971
034300200528     D DDPonxOK        S              1A   INZ('Y')                                         MD047971
034400200528     D/COPY WNCPYSRC,FXH00071
034500200528                                                                                              CSC022
034600200528      ** +--------------------------------------+
034700200528      ** ¦ End of D-specs                       ¦
034800200528      ** ¦ ==============                       ¦
034900200528      ** +--------------------------------------+
035000200528
035100200528      ** +----------------------------------------+
035200200528      ** ¦ Hook for non-core D-specs (all types)  ¦
035300200528      ** ¦ also any I-specs (if necessary)        ¦
035400200528      ** ¦ =====================================  ¦
035500200528      ** +----------------------------------------+
035600200528      /COPY WNCPYSRC,FXFXDLS008
035700200528
035800200528      *****************************************************************
035900200528      /EJECT
036000200528      *****************************************************************
036100200528     C
036200200528      ** +--- Start of Main processing -----------------------------------+
036300200528      ** ¦                                                                ¦
036400200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
036500200528      ** ¦ executed at program activation.                                ¦
036600200528      ** ¦                                                                ¦
036700200528      ** +----------------------------------------------------------------+
036800200528      *
036900200528      /COPY WNCPYSRC,FXFXDLS001
037000200528
037100200528      * READ NEXT BROWSE SUBFILE RECORD
037200200528      *
037300200528     C     @SCRN         IFEQ      'R'
037400200528     C                   EXSR      RDNBRW
037500200528     C                   END
037600200528      *
037700200528      /COPY WNCPYSRC,FXFXDLS002
037800200528
037900200528      * DO WHILE SCREEN: MAIN DETAILS
038000200528      *
038100200528     C     @SCRN         DOWEQ     'M'
038200200528     C                   EXSR      SCRN@M
038300200528     C                   END
038400200528      *
038500200528      /COPY WNCPYSRC,FXFXDLS003
038600200528
038700200528      * SCREEN: WINDOW
038800200528      *
038900200528     C     @SCRN         IFEQ      'W'
039000200528     C                   EXSR      WINDOW
039100200528     C                   END
039200200528      *
039300200528      /COPY WNCPYSRC,FXFXDLS004
039400200528
039500200528      * DO WHILE SCREEN: SETTLEMENT DETAILS
039600200528      *
039700200528     C     @SCRN         DOWEQ     'S'
039800200528     C                   EXSR      SCRN@S
039900200528     C                   END
040000200528      *
040100200528      /COPY WNCPYSRC,FXFXDLS005
040200200528
040300200528      * SCREEN: CONFIRMATION OF INPUT
040400200528      *
040500200528     C     @SCRN         IFEQ      'C'
040600200528     C                   EXSR      SCRN@C
040700200528     C                   END
040800200528      *
040900200528      /COPY WNCPYSRC,FXFXDLS006
041000200528
041100200528      * DO FILE UPDATES
041200200528      *
041300200528     C     @SCRN         IFEQ      'U'
041400200528     C                   EXSR      UPDATS
041500200528     C                   END
041600200528      *
041700200528      /COPY WNCPYSRC,FXFXDLS007
041800200528
041900200528      * TERMINATE PROGRAM
042000200528      *
042100200528     C     @SCRN         IFEQ      'T'
042200200528     C                   If        (CSC022 = 'N')                                             CSC022
042300200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
042400200528     C                   ROLBK                                                                192916
042500200528     C                   Else                                                                 CSC022
042600200528     C                   SetOn                                        U7U8                    CSC022
042700200528     C                   EndIf                                                                CSC022
042800200528     C                   MOVE      '1'           *INLR
042900200528     C                   END
043000200528      *****************************************************************
043100200528
043200200528      * Hook to enable non-core subroutines to be included
043300200528      /COPY WNCPYSRC,FXFXDLS009
043400200528
043500200528      /EJECT
043600200528      *****************************************************************
043700200528      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
043800200528      *****************************************************************
043900200528     C     SCRN@M        BEGSR
044000200528      *
044100200528      * Issue rollback to clear any possible updates in window function
044200200528      * Only required if deal number or action code has been changed
044300200528      * (this check will also cater for F12 taken from main screen)
044400200528      *
044500200528     C     BGWDPR        IFEQ      'Y'
044600200528     C*****DDDLNO        IFNE      DDDLNO                                       CAP004
044700200528     C     DDDLNO        IFNE      @PDLNO                                       CAP004
044800200528     C     DDACTN        ORNE      @PACTN                                       165402
044900200528     C     @CCI@M        ORNE      @PCI@M
045000200528                                                                                              182224
045100200528      * Check for the work field indicating Deal No. allocation has run                       182224
045200200528     C     @WFRUN        OREQ      'Y'                                                        182224
045300200528                                                                                              182224
045400200528     C                   If        (CSC022 = 'N')                                             CSC022
045500200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
045600200528     C                   ROLBK
045700200528     C                   Else                                                                 CSC022
045800200528     C                   SetOn                                        U7U8                    CSC022
045900200528     C                   EndIf                                                                CSC022
046000200528                                                                                              182224
046100200528     C                   EVAL      @WFRUN = *BLANKS                                           182224
046200200528     C                   END
046300200528     C                   END
046400200528      *
046500200528      * Update 'previous' deal number & screen control indicator
046600200528      *
046700200528     C                   MOVEL     DDDLNO        @PDLNO            6
046800200528     C                   MOVEL     DDACTN        @PACTN            1            165402
046900200528     C                   MOVEL     @CCI@M        @PCI@M
047000200528      *
047100200528      * WRITE/READ DISPLAY SCREEN
047200200528      *
047300200528     C                   CALLB     'FXFXDLDSP'
047400200528      *
047500200528      * INPUT PARAMETERS
047600200528      *
047700200528      * RETURN CODE
047800200528     C                   PARM      *BLANK        RetCodeOut
047900200528      *
048000200528      * DEAL (IN SCREEN FORMAT)
048100200528     C                   PARM                    NwDlScnFmt
048200200528      *
048300200528      * NET BUY/SELL REFERENCE
048400200528     C                   PARM                    DDNBRF
048500200528     C                   PARM                    DDNSRF
048600200528      *
048700200528      * DEAL STATUS
048800200528     C                   PARM                    DDSTS            24
048900200528     C/COPY WNCPYSRC,FXH00123
049000200528      *
049100200528      * FIELDS IN ERROR
049200200528     C                   PARM                    FXEFXD
049300200528     C/COPY WNCPYSRC,FXH00050
049400200528      *
049500200528      * ERRORS
049600200528     C                   PARM                    FldNameArr
049700200528     C                   PARM                    MsgIdArr
049800200528     C                   PARM                    MsgDtaArr
049900200528      *
050000200528      * WARNINGS
050100200528     C                   PARM                    WFldNamArr
050200200528     C                   PARM                    WMsgIdArr
050300200528     C                   PARM                    WMsgDtaArr
050400200528      *
050500200528      * ENABLED KEY & DETAIL FIELDS
050600200528      *
050700200528     C                   PARM                    @EKYFD
050800200528     C                   PARM                    @EDTFD
050900200528      *
051000200528      * ENABLED FUNCTION KEYS
051100200528     C                   PARM                    @EINKG
051200200528     C                   PARM                    @EINKH
051300200528     C                   PARM                    @EINKJ
051400200528     C                   PARM                    @EINKN
051500200528     C                   PARM                    @EINKP
051600200528      *
051700200528      * SUCCESFUL INSERT DEAL
051800200528     C                   PARM                    @SIDN             6
051900200528      *
052000200528      * OUTPUT PARAMETERS
052100200528      *
052200200528      * FUNCTION KEYS
052300200528     C                   PARM      '0'           @INKC             1
052400200528     C                   PARM      '0'           @INKG             1
052500200528     C                   PARM      '0'           @INKH             1
052600200528     C                   PARM      '0'           @INKJ             1
052700200528     C                   PARM      '0'           @INKL             1
052800200528     C                   PARM      '0'           @INKN             1
052900200528     C                   PARM      '0'           @INKP             1
053000200528     C                   PARM      'N'           WriteOnly         1
053100200528     C/COPY WNCPYSRC,FXFXDLSC02
053200200528      *                                                                                       185612
053300200528      ** Maximum Daily Delivery Risk fields:                                                  185612
053400200528      *                                                                                       185612
053500200528     C                   PARM                    DDMDDR           16                          185612
053600200528     C                   PARM                    DDEXP1           16                          185612
053700200528     C                   PARM                    DDEXP2           16                          185612
053800200528     C                   PARM                    DDLIM1            3                          185612
053900200528     C                   PARM                    DDLIM2            3                          185612
054000200528     C                   PARM                    DDLIM3            9                          185612
054100200528      *
054200200528      * RESET ERRORS
054300200528      *
054400200528     C/COPY WNCPYSRC,FXH00124
054500200528     C                   MOVE      *ALL'Y'       FXEFXD
054600200528     C                   MOVEL     *BLANK        FldNameArr
054700200528     C                   MOVEL     *BLANK        MsgIdArr
054800200528     C                   MOVEL     *BLANK        MsgDtaArr
054900200528     C                   MOVEL     *BLANK        WFldNamArr
055000200528     C                   MOVEL     *BLANK        WMsgIdArr
055100200528     C                   MOVEL     *BLANK        WMsgDtaArr
055200200528      *
055300200528      * CK/3 - END PROGRAM
055400200528      *
055500200528     C     @INKC         CASEQ     '1'           ENDP
055600200528      *
055700200528      * CK/7 - ROLL BACKWARDS
055800200528      *
055900200528     C     @INKG         CASEQ     '1'           ROLL
056000200528      *
056100200528      * CK/8 - ROLL FORWARDS
056200200528      *
056300200528     C     @INKH         CASEQ     '1'           ROLL
056400200528      *
056500200528      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
056600200528      *
056700200528     C     @INKL         CASEQ     '1'           CANC@M
056800200528      *
056900200528      * CK/15 - BUILD BROWSE
057000200528      *
057100200528     C     @INKP         CASEQ     '1'           BLDBRW
057200200528      *
057300200528      * VALIDATE INPUT TO MAIN DETAILS SCREEN
057400200528      *
057500200528     C                   CAS                     VAL@M
057600200528     C                   END
057700200528      *
057800200528     C                   ENDSR
057900200528      *****************************************************************
058000200528      /EJECT
058100200528      *****************************************************************
058200200528      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
058300200528      *****************************************************************
058400200528     C     VAL@M         BEGSR
058500200528      *
058600200528      * Retrieve deal details
058700200528      *
058800200528     C/COPY WNCPYSRC,FXH00056
058900200528     C                   EXSR      RTVDEL
059000200528      *
059100200528     C/COPY WNCPYSRC,FXFXDLSC32
059200200528      * If action code, deal number or booking branch are NOT OK
059300200528      * Re-output screen with error messages on it
059400200528      *
059500200528     C     OKACTN        IFEQ      'N'
059600200528     C     OKDLNO        OREQ      'N'
059700200528     C     OKBRSN        OREQ      'N'
059800200528     C                   GOTO      EVAL@M
059900200528     C                   END
060000200528      *
060100200528      * Set field and function key status on main details screen
060200200528      * (according to action code)
060300200528      *
060400200528     C                   EXSR      SFDS@M
060500200528     C                   EXSR      SFKS@M
060600200528      *
060700200528      * If action code is delete, enquire or authorize
060800200528      * or action code is amend and deal number has changed
060900200528      *   Put the deal on the main details screen
061000200528      *
061100200528     C     DDACTN        IFEQ      'D'
061200200528     C     DDACTN        OREQ      'E'
061300200528     C     DDACTN        OREQ      'X'
061400200528     C     DDACTN        OREQ      'A'
061500200528     C     DDDLNO        ANDNE     @PDLNO
061600200528     C     DDACTN        OREQ      'A'                                          165402
061700200528     C     DDACTN        ANDNE     @PACTN                                       165402
061800200528     C                   EXSR      PUTD@M
061900200528     C                   END
062000200528      *
062100200528      * If deal number or screen control indicators have changed
062200200528      *   Re-output screen
062300200528      *
062400200528     C     DDDLNO        IFNE      @PDLNO
062500200528     C     DDACTN        ANDNE     'I'
062600200528     C     DDACTN        ORNE      @PACTN                                       165402
062700200528     C     @CCI@M        ORNE      @PCI@M
062800200528     C                   GOTO      EVAL@M
062900200528     C                   END
063000200528      *
063100200528      *----------------------------------------------------------------
063200200528      * IF DELETE
063300200528      *
063400200528     C     DDACTN        IFEQ      'D'
063500200528      *
063600200528      * Update Deal in File Format
063700200528      *
063800200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
063900200528      *
064000200528      * IF CK/10 TAKEN, GO ONTO UPDATES
064100200528      *
064200200528     C     @INKJ         IFEQ      '1'
064300200528     C                   MOVEL     'U'           @SCRN
064400200528     C/COPY WNCPYSRC,FXFXDLSC34
064500200528     C                   END
064600200528     C                   GOTO      EVAL@M
064700200528     C                   END
064800200528      *
064900200528      *----------------------------------------------------------------
065000200528      * IF ENQUIRE
065100200528      *
065200200528     C     DDACTN        IFEQ      'E'
065300200528      *
065400200528      * Update Deal in File Format
065500200528      *
065600200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
065700200528      *
065800200528      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
065900200528      * If windows processing on, call window routine
066000200528      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
066100200528      *
066200200528     C     @INKN         IFEQ      '1'
066300200528     C                   MOVEL     'S'           @SCRN
066400200528     C                   ELSE
066500200528     C     BGWDPR        IFEQ      'Y'
066600200528     C                   MOVEL     'W'           @SCRN
066700200528     C                   ELSE
066800200528     C     @RDNB         IFEQ      'Y'
066900200528     C                   MOVEL     'R'           @SCRN
067000200528     C                   END
067100200528     C                   END
067200200528     C                   END
067300200528      *
067400200528     C                   GOTO      EVAL@M
067500200528     C                   END
067600200528      *
067700200528      *----------------------------------------------------------------
067800200528      * IF AUTHORIZE
067900200528      *
068000200528     C     DDACTN        IFEQ      'X'
068100200528      *
068200200528      * Update Deal in File Format
068300200528      *
068400200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
068500200528      *
068600200528      * If windows processing on, call window routine
068700200528      * otherwise, continue to settlements screen
068800200528      *
068900200528     C     BGWDPR        IFEQ      'Y'
069000200528     C                   MOVEL     'W'           @SCRN
069100200528     C                   ELSE
069200200528     C                   MOVEL     'S'           @SCRN
069300200528     C                   END
069400200528      *
069500200528     C                   GOTO      EVAL@M
069600200528     C                   END
069700200528      *
069800200528      *----------------------------------------------------------------
069900200528      * IF INSERT OR AMEND
070000200528      *
070100200528     C     DDACTN        IFEQ      'I'
070200200528     C     DDACTN        OREQ      'A'
070300200528      *
070400200528      * Prior to validation, initialize error indicators as 'OK'
070500200528      * and clear Deal in File Format
070600200528      *
070700200528     C                   Z-ADD     *ZERO         Idx               3 0
070800200528     C                   Z-ADD     *ZERO         WIdx              3 0
070900200528     C                   MOVE      *ALL'Y'       FXEFXD
071000200528     C     ERRFSR        IFNE      'Y'                                                        258601
071100200528     C                   CLEAR                   NwDlFilFmt
071200200528     C                   Z-ADD     *ZERO         F3RSTM
071300200528     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
071400200528     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
071500200528     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
071600200528     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
071700200528     C                   Z-ADD     *ZERO         F3PSTM
071800200528     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
071900200528     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
072000200528     C                   EVAL      F3POBN = *BLANKS                                           CSD027
072100200528     C                   EVAL      F3POCN = *BLANKS                                           CSD027
072200200528     C                   ENDIF                                                                258601
072300200528     C/COPY WNCPYSRC,FXH00212
072400200528      *
072500200528      * IF AMEND
072600200528      *
072700200528     C     DDACTN        IFEQ      'A'
072800200528      *
072900200528      * Update Deal in File Format
073000200528      *
073100200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
073200200528     C/COPY WNCPYSRC,FXH00057
073300200528      *
073400200528      * Validate whether non-amenable fields have been changed
073500200528      *
073600200528     C                   CALLB     'FXFXDLAMD'
073700200528      *
073800200528      * INPUTS
073900200528      *
074000200528      * Return Code
074100200528     C                   PARM      *BLANK        RetCodeOut
074200200528      *
074300200528      * New Deal in Screen Format
074400200528     C                   PARM                    NwDlScnFmt
074500200528      *
074600200528      * Current Deal in Screen Format
074700200528     C                   PARM                    CrDlScnFmt
074800200528      *
074900200528      * Current Deal in file format
075000200528     C                   PARM                    CrDlFilFmt
075100200528      *                                                                                     MD047971
075200200528      ** Pay/rcv settlement account                                                         MD047971
075300200528      *                                                                                     MD047971
075400200528     C                   PARM                    DDRONX                                     MD047971
075500200528     C                   PARM                    DDPONX                                     MD047971
075600200528     C                   PARM                    DDRONXOK                                   MD047971
075700200528     C                   PARM                    DDPONXOK                                   MD047971
075800200528      *
075900200528      * OUTPUTS
076000200528      *
076100200528      * Field OK flags (DS) from/to caller
076200200528     C                   PARM                    FXEFXD
076300200528      *
076400200528      * Error fields/message IDs/message data (arrays) from/to caller
076500200528     C                   PARM                    FldNameArr
076600200528     C                   PARM                    MsgIdArr
076700200528     C                   PARM                    MsgDtaArr
076800200528      *
076900200528      * Array index (3P0) from/to caller
077000200528     C                   PARM                    Idx
077100200528      *
077200200528      * Amendments OK
077300200528     C                   PARM                    @@AMOK            1
077400200528      *
077500200528      * Reset of Fields in Error Required (Y/N)
077600200528     C                   PARM      'Y'           @@RSTE            1
077700200528     C                   END
077800200528      *
077900200528      * Validate deal details
078000200528      *
078100200528     C                   CALLB     'FXFXDLVAL'
078200200528     C                   PARM                    RespMode
078300200528     C                   PARM                    NwDlScnFmt
078400200528     C                   PARM                    InfData                        CAP051
078500200528     C                   PARM      F3RSCY        @@RSCY
078600200528     C                   PARM      F3RSTM        @@RSTM
078700200528     C                   PARM      F3RONS        @@RONS
078800200528     C                   PARM      F3PSCY        @@PSCY
078900200528     C                   PARM      F3PSTM        @@PSTM
079000200528     C                   PARM      F3PONS        @@PONS
079100200528     C                   PARM      F3FRNT        @@FRNT                         CPB002
079200200528     C                   PARM                    ExtData                        CAP004
079300200528     C/COPY WNCPYSRC,FXFXDLSC06
079400200528     C                   PARM                    DDNBRF
079500200528     C                   PARM                    DDNSRF
079600200528     C                   PARM                    FXEFXD
079700200528     C                   PARM                    FldNameArr
079800200528     C                   PARM                    MsgIdArr
079900200528     C                   PARM                    MsgDtaArr
080000200528     C                   PARM                    Idx
080100200528     C                   PARM                    WFldNamArr
080200200528     C                   PARM                    WMsgIdArr
080300200528     C                   PARM                    WMsgDtaArr
080400200528     C                   PARM                    WIdx
080500200528     C                   PARM                    NwDlFilFmt
080600200528     C/COPY WNCPYSRC,FXFXDLSC35
080700200528      *
080800200528      * If errors returned
080900200528      *
081000200528     C     Idx           IFNE      0
081100200528     C                   GOTO      EVAL@M
081200200528     C                   END
081300200528      *
081400200528      * If windows processing on, call window routine
081500200528      * otherwise, continue to settlements screen
081600200528      *
081700200528     C     BGWDPR        IFEQ      'Y'
081800200528     C                   MOVEL     'W'           @SCRN
081900200528     C                   ELSE
082000200528     C                   MOVEL     'S'           @SCRN
082100200528     C                   END
082200200528      *
082300200528     C                   END
082400200528      *----------------------------------------------------------------
082500200528     C     EVAL@M        ENDSR
082600200528      *****************************************************************
082700200528      /EJECT
082800200528      *****************************************************************
082900200528      * WINDOW - CALL WINDOW MANAGER
083000200528      *****************************************************************
083100200528     C     WINDOW        BEGSR
083200200528      *
083300200528      * Reset erros
083400200528      *
083500200528     C/COPY WNCPYSRC,FXH00195
083600200528     C                   MOVE      *ALL'Y'       FXEFXD
083700200528     C                   MOVEL     *BLANK        FldNameArr
083800200528     C                   MOVEL     *BLANK        MsgIdArr
083900200528     C                   MOVEL     *BLANK        MsgDtaArr
084000200528     C                   MOVEL     *BLANK        WFldNamArr
084100200528     C                   MOVEL     *BLANK        WMsgIdArr
084200200528     C                   MOVEL     *BLANK        WMsgDtaArr
084300200528      *
084400200528      * Write out screen to remove error messages
084500200528      *
084600200528     C                   CALLB     'FXFXDLDSP'
084700200528      *
084800200528      * INPUT PARAMETERS
084900200528      *
085000200528      * RETURN CODE
085100200528     C                   PARM      *BLANK        RetCodeOut
085200200528      *
085300200528      * DEAL (IN SCREEN FORMAT)
085400200528     C                   PARM                    NwDlScnFmt
085500200528      *
085600200528      * NET BUY/SELL REFERENCE
085700200528     C                   PARM                    DDNBRF
085800200528     C                   PARM                    DDNSRF
085900200528      *
086000200528      * DEAL STATUS
086100200528     C                   PARM                    DDSTS
086200200528     C/COPY WNCPYSRC,FXH00125
086300200528      *
086400200528      * FIELDS IN ERROR
086500200528     C                   PARM                    FXEFXD
086600200528     C/COPY WNCPYSRC,FXH00051
086700200528      *
086800200528      * ERRORS
086900200528     C                   PARM                    FldNameArr
087000200528     C                   PARM                    MsgIdArr
087100200528     C                   PARM                    MsgDtaArr
087200200528      *
087300200528      * WARNINGS
087400200528     C                   PARM                    WFldNamArr
087500200528     C                   PARM                    WMsgIdArr
087600200528     C                   PARM                    WMsgDtaArr
087700200528      *
087800200528      * ENABLED KEY & DETAIL FIELDS
087900200528      *
088000200528     C                   PARM                    @EKYFD
088100200528     C                   PARM                    @EDTFD
088200200528      *
088300200528      * ENABLED FUNCTION KEYS
088400200528     C                   PARM                    @EINKG
088500200528     C                   PARM                    @EINKH
088600200528     C                   PARM                    @EINKJ
088700200528     C                   PARM                    @EINKN
088800200528     C                   PARM                    @EINKP
088900200528      *
089000200528      * SUCCESFUL INSERT DEAL
089100200528     C                   PARM                    @SIDN             6
089200200528      *
089300200528      * OUTPUT PARAMETERS
089400200528      *
089500200528      * FUNCTION KEYS
089600200528     C                   PARM      '0'           @INKC             1
089700200528     C                   PARM      '0'           @INKG             1
089800200528     C                   PARM      '0'           @INKH             1
089900200528     C                   PARM      '0'           @INKJ             1
090000200528     C                   PARM      '0'           @INKL             1
090100200528     C                   PARM      '0'           @INKN             1
090200200528     C                   PARM      '0'           @INKP             1
090300200528     C                   PARM      'Y'           WriteOnly         1
090400200528     C/COPY WNCPYSRC,FXFXDLSC10
090500200528      *                                                                                       185612
090600200528      ** Maximum Daily Delivery Risk fields:                                                  185612
090700200528      *                                                                                       185612
090800200528     C                   PARM                    DDMDDR           16                          185612
090900200528     C                   PARM                    DDEXP1           16                          185612
091000200528     C                   PARM                    DDEXP2           16                          185612
091100200528     C                   PARM                    DDLIM1            3                          185612
091200200528     C                   PARM                    DDLIM2            3                          185612
091300200528     C                   PARM                    DDLIM3            9                          185612
091400200528      *
091500200528      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
091600200528      * GET NEXT AVAILABLE DEAL NUMBER
091700200528      *
091800200528     C     DDDLNO        IFEQ      *BLANK
091900200528     C                   CALLB     'CAGETNXTDL'
092000200528     C                   PARM      *BLANKS       RetCodeOut
092100200528     C                   PARM      *BLANKS       @@MSG1            7
092200200528     C                   PARM                    I#DDDLNO          6
092300200528     C                   PARM      *ZERO         F3DN38
092400200528      *
092500200528      * DATABASE ERROR
092600200528      *
092700200528     C     @@MSG1        IFNE      *BLANK
092800200528     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
092900200528     C                   MOVEL     '001'         DBASE                          * DBERR 001*
093000200528     C                   MOVEL     DDDLNO        DBKEY                          ************
093100200528     C                   EXSR      *PSSR
093200200528     C                   END
093300200528                                                                                              182224
093400200528      * Set up the work field indicating the Deal No. allocation has run                      182224
093500200528     C                   MOVE      'Y'           @WFRUN            1                          182224
093600200528     C/COPY WNCPYSRC,FXFXDLSC39
093700200528                                                                                              182224
093800200528     C                   END
093900200528      *
094000200528     C/COPY WNCPYSRC,FXDLSINMV1
094100200528      *
094200200528     C                   CALL      'WN0010'
094300200528     C                   PARM      'FXFXDLSIN'   #PGM             10
094400200528     C                   PARM                    FKEY              2
094500200528     C                   PARM      DDACTN        ACTION            1
094600200528     C                   PARM                    DATA
094700200528     C                   PARM      *BLANKS       #RTRN             7
094800200528     C                   PARM                    SPAREW          256
094900200528      *
095000200528      * Process returned command keys
095100200528      *
095200200528     C     #RTRN         IFEQ      'Y2U9999'
095300200528     C                   EXSR      ENDP
095400200528     C                   ELSE
095500200528      *
095600200528      *  If Cmd12 pressed, or in enquiry, return to main details screen;
095700200528      *  otherwise, go to settlements screen
095800200528      *
095900200528     C     #RTRN         IFEQ      'USR0790'
096000200528     C     DDACTN        OREQ      'E'
096100200528     C     @RDNB         IFEQ      'Y'
096200200528     C/COPY WNCPYSRC,FXFXDLSC11
096300200528     C                   EVAL      @SCRN = 'R'
096400200528     C                   ELSE
096500200528     C                   EVAL      @SCRN = 'M'
096600200528     C                   END
096700200528     C                   If        (CSC022 = 'N')                                             CSC022
096800200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
096900200528     C                   ROLBK                                                                192916
097000200528     C                   Else                                                                 CSC022
097100200528     C                   SetOn                                        U7U8                    CSC022
097200200528     C                   EndIf                                                                CSC022
097300200528     C                   ELSE
097400200528     C                   EVAL      @SCRN = 'S'
097500200528     C/COPY WNCPYSRC,FXFXDLSC36
097600200528     C                   ENDIF
097700200528     C                   ENDIF
097800200528      *
097900200528     C     WIND          ENDSR
098000200528      *****************************************************************
098100200528      /EJECT
098200200528      *****************************************************************
098300200528      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
098400200528      *****************************************************************
098500200528     C     ROLL          BEGSR
098600200528      *
098700200528      * Default action code to enquiry if not valid
098800200528      *
098900200528     C     DDACTN        IFNE      'A'
099000200528     C     DDACTN        ANDNE     'D'
099100200528     C     DDACTN        ANDNE     'X'
099200200528     C                   MOVE      'E'           DDACTN
099300200528     C                   END
099400200528      *
099500200528      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
099600200528      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
099700200528      *
099800200528     C     @INKG         IFEQ      '1'
099900200528     C                   MOVEL     *BLANK        @RDFWD
100000200528     C                   MOVEL     'Y'           @RDBCK
100100200528     C                   ELSE
100200200528     C                   MOVEL     'Y'           @RDFWD
100300200528     C                   MOVEL     *BLANK        @RDBCK
100400200528     C                   END
100500200528      *
100600200528     C                   CALLB     'FXFXDLRED'
100700200528      *
100800200528      * INPUT PARAMETERS
100900200528      *
101000200528      * RETURN CODE
101100200528     C                   PARM      *BLANK        RetCodeOut
101200200528      *                                                                         CAP052
101300200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
101400200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
101500200528      *                                                                         CAP052
101600200528     C                   PARM      '      '      @@MODE            6            CAP052
101700200528      *
101800200528      * ACTION CODE
101900200528     C                   PARM                    DDACTN            1
102000200528      *
102100200528      * DEAL NUMBER POINTER
102200200528     C                   PARM                    DDDLNO            6
102300200528      *                                                                         CAP052
102400200528      * Front Office ID                                                         CAP052
102500200528     C                   PARM                    DDFRTN           20            CAP052
102600200528      *
102700200528      * READ FORWARDS
102800200528     C                   PARM                    @RDFWD            1
102900200528      *
103000200528      * READ BACKWARDS
103100200528     C                   PARM                    @RDBCK            1
103200200528      *
103300200528      * OUTPUT PARAMETERS
103400200528      *
103500200528      * ERROR MESSAGE
103600200528     C                   PARM      *BLANK        @ERRMS            7
103700200528      *
103800200528      * DEAL NUMBER READ
103900200528     C                   PARM      *BLANK        @DLRED            6
104000200528      *                                                                         CAP052
104100200528      * Front Office ID READ                                                    CAP052
104200200528     C                   PARM      *BLANK        @FTRED           20            CAP052
104300200528      *
104400200528      * If error message returned from read, send it to detail screen
104500200528      *
104600200528     C     @ERRMS        IFNE      *BLANK
104700200528     C                   EXSR      SNDM@M
104800200528     C                   GOTO      EROLL
104900200528     C                   END
105000200528      *
105100200528      * If deal read
105200200528      *
105300200528     C     @DLRED        IFNE      *BLANK
105400200528      *
105500200528      * Retrieve deal details
105600200528      *
105700200528     C                   MOVEL     @DLRED        DDDLNO
105800200528     C                   EXSR      RTVDEL
105900200528      *
106000200528      * Set field and function key status on main details screen
106100200528      * (according to action code)
106200200528      *
106300200528     C                   EXSR      SFDS@M
106400200528     C                   EXSR      SFKS@M
106500200528      *
106600200528      * Put the deal on the main details screen
106700200528      *
106800200528     C                   EXSR      PUTD@M
106900200528     C                   END
107000200528      *
107100200528     C     EROLL         ENDSR
107200200528      *****************************************************************
107300200528      /EJECT
107400200528      *****************************************************************
107500200528      * BLDBRW - BUILD BROWSE SUBFILE
107600200528      *****************************************************************
107700200528     C     BLDBRW        BEGSR
107800200528      *
107900200528      * RESET READ NEXT BROWSE SUBFILE RECORD
108000200528      *
108100200528     C                   MOVEL     *BLANK        @RDNB             1
108200200528     C/COPY WNCPYSRC,FXFXDLSC12
108300200528      *
108400200528      * BUILD BROWSE SUBFILE
108500200528      *
108600200528     C                   CALLB     'FXFXDLBRW'
108700200528      *
108800200528      * INPUT PARAMETERS
108900200528      *
109000200528      * RETURN CODE
109100200528     C                   PARM      *BLANK        RetCodeOut
109200200528      *
109300200528      * ACTION CODE
109400200528     C                   PARM                    DDACTN            1
109500200528      *
109600200528      * DEAL NUMBER POINTER
109700200528     C                   PARM                    DDDLNO            6
109800200528      *
109900200528      * BUILD SUB-FILE
110000200528     C                   PARM      'Y'           @BDSFL            1
110100200528      *
110200200528      * READ SUBFILE RECORD
110300200528     C                   PARM      *BLANK        @RDSFL            1
110400200528      *
110500200528      * OUTPUT PARAMETERS
110600200528      *
110700200528      * ERROR MESSAGE
110800200528     C                   PARM      *BLANK        @ERRMS            7
110900200528      *
111000200528      * OPTION SELECTED
111100200528     C                   PARM      *BLANK        @OPSEL            1
111200200528      *
111300200528      * DEAL NUMBER SELECTED
111400200528     C                   PARM      *BLANK        @DLSEL            6
111500200528      *
111600200528      * COMMAND KEYS
111700200528     C                   PARM      '0'           @INKC             1
111800200528     C                   PARM      '0'           @INKL             1
111900200528     C/COPY WNCPYSRC,FXFXDLSC13
112000200528      *
112100200528      * If CK/3 taken in browse, end program
112200200528      *
112300200528     C     @INKC         IFEQ      '1'
112400200528     C                   EXSR      ENDP
112500200528     C                   GOTO      EBLDBR
112600200528     C                   END
112700200528      *
112800200528      * If error message returned from browse, send it to detail screen
112900200528      *
113000200528     C     @ERRMS        IFNE      *BLANK
113100200528     C                   EXSR      SNDM@M
113200200528     C                   GOTO      EBLDBR
113300200528     C                   END
113400200528      *
113500200528      * If CK/12 not taken in browse
113600200528      * Read next browse subfile record
113700200528      *
113800200528     C     @INKL         IFNE      '1'
113900200528     C                   MOVE      'Y'           @RDNB
114000200528     C                   MOVEL     'R'           @SCRN
114100200528     C/COPY WNCPYSRC,FXFXDLSC14
114200200528     C                   GOTO      EBLDBR
114300200528     C                   END
114400200528      *
114500200528     C     EBLDBR        ENDSR
114600200528      *****************************************************************
114700200528      /EJECT
114800200528      *****************************************************************
114900200528      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
115000200528      *****************************************************************
115100200528     C     RDNBRW        BEGSR
115200200528     C/COPY WNCPYSRC,FXFXDLSC15
115300200528      *
115400200528      * READ NEXT SUBFILE RECORD
115500200528      *
115600200528     C                   CALLB     'FXFXDLBRW'
115700200528      *
115800200528      * INPUT PARAMETERS
115900200528      *
116000200528      * RETURN CODE
116100200528     C                   PARM      *BLANK        RetCodeOut
116200200528      *
116300200528      * ACTION CODE
116400200528     C                   PARM                    DDACTN            1
116500200528      *
116600200528      * DEAL NUMBER POINTER
116700200528     C                   PARM                    DDDLNO            6
116800200528      *
116900200528      * BUILD SUB-FILE
117000200528     C                   PARM      *BLANK        @BDSFL            1
117100200528      *
117200200528      * READ SUBFILE RECORD
117300200528     C                   PARM      'Y'           @RDSFL            1
117400200528      *
117500200528      * OUTPUT PARAMETERS
117600200528      *
117700200528      * ERROR MESSAGE
117800200528     C                   PARM      *BLANK        @ERRMS            7
117900200528      *
118000200528      * OPTION SELECTED
118100200528     C                   PARM      *BLANK        @OPSEL            1
118200200528      *
118300200528      * DEAL NUMBER SELECTED
118400200528     C                   PARM      *BLANK        @DLSEL            6
118500200528      *
118600200528      * COMMAND KEYS
118700200528     C                   PARM      '0'           @INKC             1
118800200528     C                   PARM      '0'           @INKL             1
118900200528     C/COPY WNCPYSRC,FXFXDLSC16
119000200528      *
119100200528      * IF DEAL READ FROM SUBFILE
119200200528      *
119300200528     C     @DLSEL        IFNE      *BLANK
119400200528      *
119500200528      * Retrieve deal details
119600200528      *
119700200528     C                   MOVEL     @OPSEL        DDACTN
119800200528     C/COPY WNCPYSRC,FXFXDLSC17
119900200528     C                   MOVEL     @DLSEL        DDDLNO
120000200528     C                   EXSR      RTVDEL
120100200528     C/COPY WNCPYSRC,FXFXDLSC18
120200200528      *
120300200528      * Set field and function key status on main details screen
120400200528      * (according to action code)
120500200528      *
120600200528     C                   EXSR      SFDS@M
120700200528     C                   EXSR      SFKS@M
120800200528      *
120900200528      * Put the deal on the main details screen
121000200528      *
121100200528     C                   EXSR      PUTD@M
121200200528     C/COPY WNCPYSRC,FXFXDLSC19
121300200528      *
121400200528      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
121500200528      *
121600200528     C                   ELSE
121700200528     C/COPY WNCPYSRC,FXFXDLSC20
121800200528     C                   MOVEL     *BLANK        @RDNB
121900200528     C/COPY WNCPYSRC,FXFXDLSC21
122000200528     C                   END
122100200528      *
122200200528      * GO TO MAIN DETAILS SCREEN
122300200528      *
122400200528     C                   MOVE      'M'           @SCRN
122500200528     C/COPY WNCPYSRC,FXFXDLSC22
122600200528      *
122700200528     C                   ENDSR
122800200528      *****************************************************************
122900200528      /EJECT
123000200528      *****************************************************************
123100200528      * RTVDEL - RETRIEVE DEAL
123200200528      *****************************************************************
123300200528     C     RTVDEL        BEGSR
123400200528      *
123500200528      * RETRIEVE DEAL
123600200528      *
123700200528     C                   CALLB     'FXFXDLRTV'
123800200528      *
123900200528      * INPUTS
124000200528      *
124100200528      * Return code
124200200528     C                   PARM      *BLANK        RetCodeOut
124300200528      *
124400200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
124500200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
124600200528      *
124700200528     C                   PARM      '      '      @@MODE            6
124800200528      *
124900200528      * Response mode
125000200528     C                   PARM      'S'           @@RSMD            1
125100200528      *
125200200528      * Action Code
125300200528     C                   PARM                    DDACTN
125400200528      *
125500200528      * Front Office Transaction ID
125600200528     C                   PARM                    FOTRID           20
125700200528      *
125800200528      * Front Office Associated Transaction Id
125900200528     C                   PARM                    FOASID           20
126000200528      *
126100200528      * (Midas) Deal Number
126200200528     C                   PARM                    DDDLNO
126300200528      *
126400200528      * (Midas) Swap/Option Deal Number
126500200528     C                   PARM                    DDSDNO
126600200528      *
126700200528      * Booking branch
126800200528     C                   PARM                    DDBRSN
126900200528      *
127000200528      * Originating branch
127100200528     C                   PARM                    DDORBR
127200200528      *
127300200528      * OUTPUTS
127400200528      *
127500200528      * (Current) deal in file format
127600200528     C                   PARM                    CrDlFilFmt
127700200528      *
127800200528      * OK - Action code
127900200528     C                   PARM      *BLANK        OKACTN
128000200528      *
128100200528      * OK - Deal Number
128200200528     C                   PARM      *BLANK        OKDLNO
128300200528      *
128400200528      * OK - Booking branch
128500200528     C                   PARM      *BLANK        OKBRSN
128600200528      *
128700200528      * OK - Originating branch
128800200528     C                   PARM                    OKORBR
128900200528      *
129000200528      * Error fields/message IDs/message data (arrays) from/to caller
129100200528     C                   PARM                    FldNameArr
129200200528     C                   PARM                    MsgIdArr
129300200528     C                   PARM                    MsgDtaArr
129400200528      *
129500200528      * Array index (3P0) from/to caller
129600200528     C                   PARM      *ZERO         Idx
129700200528                                                                                              CAS004
129800200528      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
129900200528                                                                                              CAS004
130000200528     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
130100200528     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
130200200528     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
130300200528                                                                                              CAS004
130400200528      ** Warning array index (3P0) from/to caller                                             CAS004
130500200528                                                                                              CAS004
130600200528     C                   PARM      *ZEROS        WIdx                                         CAS004
130700200528                                                                                              CAS004
130800200528     C/COPY WNCPYSRC,FXFXDLSC03
130900200528      *
131000200528     C                   ENDSR
131100200528      *****************************************************************
131200200528      /EJECT
131300200528      *****************************************************************
131400200528      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
131500200528      *****************************************************************
131600200528     C     PUTD@M        BEGSR
131700200528      *
131800200528      * Call program to fill screen fields with data from FXDEALPP
131900200528      *
132000200528     C                   CALLB     'FXFXDLCVT'
132100200528      *
132200200528      * INPUTS
132300200528      *
132400200528      * Return Code
132500200528     C                   PARM      *BLANK        RetCodeOut
132600200528      *
132700200528      * Deal in file format
132800200528     C                   PARM                    CrDlFilFmt
132900200528      *
133000200528      * OUTPUTS
133100200528      *
133200200528      * Deal in screen format
133300200528     C                   PARM                    NwDlScnFmt
133400200528      *
133500200528      * NET BUY/SELL REFERENCE
133600200528     C                   PARM                    DDNBRF           19
133700200528     C                   PARM                    DDNSRF           19
133800200528      *
133900200528      * Deal Status
134000200528     C                   PARM                    DDSTS            24
134100200528      *
134200200528      * Update 'Current' Deal with Deal in Screen Format
134300200528      *
134400200528     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
134500200528     C/COPY WNCPYSRC,FXH00213
134600200528      *
134700200528     C                   ENDSR
134800200528      *****************************************************************
134900200528      /EJECT
135000200528      *****************************************************************
135100200528      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
135200200528      *          ACCORDING TO ACTION CODE
135300200528      *****************************************************************
135400200528     C     SFDS@M        BEGSR
135500200528      *
135600200528      * Enable/disable key & detail fields on main details screen
135700200528      * (key fields = action code & deal number; detail fields = rest)
135800200528      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
135900200528      *
136000200528     C     DDACTN        IFEQ      'I'
136100200528     C     DDACTN        OREQ      'A'
136200200528     C                   MOVEL     'Y'           @EKYFD
136300200528     C                   MOVEL     'Y'           @EDTFD
136400200528     C                   ELSE
136500200528     C                   MOVEL     'N'           @EKYFD
136600200528     C                   MOVEL     'N'           @EDTFD
136700200528     C                   END
136800200528     C/COPY WNCPYSRC,FXFXDLSC23
136900200528      *
137000200528     C                   ENDSR
137100200528      *****************************************************************
137200200528      /EJECT
137300200528      *****************************************************************
137400200528      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
137500200528      *          ACCORDING TO ACTION CODE
137600200528      *****************************************************************
137700200528     C     SFKS@M        BEGSR
137800200528      *
137900200528      * Enable/disable function keys on main details screen
138000200528      *
138100200528      * KG = COMMAND KEY 07 = READ PREVIOUS
138200200528      * KH = COMMAND KEY 08 = READ NEXT
138300200528      *
138400200528     C                   MOVEL     'Y'           @EINKG
138500200528     C                   MOVEL     'Y'           @EINKH
138600200528      *
138700200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
138800200528      *
138900200528     C     DDACTN        IFEQ      'D'
139000200528     C                   MOVEL     'Y'           @EINKJ
139100200528     C                   ELSE
139200200528     C                   MOVEL     'N'           @EINKJ
139300200528     C                   END
139400200528      *
139500200528      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
139600200528      * (Action codes I, A, X display settlement details automatically)
139700200528      * (No futher screens are available from action code D)
139800200528      *
139900200528     C     DDACTN        IFEQ      'E'
140000200528     C                   MOVEL     'Y'           @EINKN
140100200528     C                   ELSE
140200200528     C                   MOVEL     'N'           @EINKN
140300200528     C                   END
140400200528      *
140500200528      * KP = COMMAND KEY 15 = BROWSE
140600200528      *
140700200528     C                   MOVEL     'Y'           @EINKP
140800200528     C/COPY WNCPYSRC,FXFXDLSC24
140900200528      *
141000200528     C                   ENDSR
141100200528      *****************************************************************
141200200528      /EJECT
141300200528      *****************************************************************
141400200528      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
141500200528      *****************************************************************
141600200528     C     IFDS@M        BEGSR
141700200528      *
141800200528      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
141900200528      *
142000200528     C                   MOVEL     'Y'           @EKYFD
142100200528     C                   MOVEL     'Y'           @EDTFD
142200200528     C/COPY WNCPYSRC,FXFXDLSC25
142300200528      *
142400200528     C                   ENDSR
142500200528      *****************************************************************
142600200528      /EJECT
142700200528      *****************************************************************
142800200528      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
142900200528      *****************************************************************
143000200528     C     IFKS@M        BEGSR
143100200528      *
143200200528      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
143300200528      * KG = COMMAND KEY 07 = READ PREVIOUS
143400200528      * KH = COMMAND KEY 08 = READ NEXT
143500200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
143600200528      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
143700200528      * KP = COMMAND KEY 15 = BROWSE
143800200528      *
143900200528     C                   MOVEL     'Y'           @EINKG
144000200528     C                   MOVEL     'Y'           @EINKH
144100200528     C                   MOVEL     'N'           @EINKJ
144200200528     C                   MOVEL     'N'           @EINKN
144300200528     C                   MOVEL     'Y'           @EINKP
144400200528     C/COPY WNCPYSRC,FXFXDLSC26
144500200528      *
144600200528     C                   ENDSR
144700200528      *****************************************************************
144800200528      /EJECT
144900200528      *****************************************************************
145000200528      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
145100200528      *****************************************************************
145200200528     C     CANC@M        BEGSR
145300200528     C/COPY WNCPYSRC,FXFXDLSC27
145400200528      *
145500200528      * Reset Read Next Browse Subfile Record (if active)
145600200528      *
145700200528     C                   MOVEL     *BLANK        @RDNB
145800200528     C/COPY WNCPYSRC,FXFXDLSC28
145900200528      *
146000200528      * If input fields are enabled
146100200528      * Blank the main details screen
146200200528      * and settlement screen                                                   183225
146300200528      *
146400200528     C     @EKYFD        IFEQ      'Y'
146500200528     C     @EDTFD        OREQ      'Y'
146600200528     C                   MOVEL     *BLANK        NwDlScnFmt
146700200528     C                   MOVEL     *BLANK        DDSTS
146800200528     C                   MOVEL     *BLANK        DDNBRF
146900200528     C                   MOVEL     *BLANK        DDNSRF
147000200528     C                   CLEAR                   ##PAYF                         183225
147100200528     C                   CLEAR                   ##RECF                         183225
147200200528     C                   MOVEL     *BLANK        ##ACTN                         183225
147300200528     C                   MOVEL     *BLANK        ##DLNO                         183225
147400200528     C                   MOVEL     *BLANK        ##PCCY                         183225
147500200528     C                   MOVEL     *BLANK        ##RCCY                         183225
147600200528     C                   MOVEL     *BLANK        ##CSNM                         183225
147700200528     C                   MOVEL     *BLANK        ##CLSS                         CDL008
147800200528     C/COPY WNCPYSRC,FXFXDLSC05
147900200528     C                   END
148000200528      *
148100200528      * Initialize field and function key status on main details screen
148200200528      *
148300200528     C                   EXSR      IFDS@M
148400200528     C                   EXSR      IFKS@M
148500200528      *
148600200528     C                   ENDSR
148700200528      *****************************************************************
148800200528      /EJECT
148900200528      *****************************************************************
149000200528      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
149100200528      *****************************************************************
149200200528     C     SNDM@M        BEGSR
149300200528      *
149400200528      * If single branching, user can't browse file
149500200528      *
149600200528     C     @ERRMS        IFEQ      'FXM0292'
149700200528     C                   MOVE      'N'           OKACTN
149800200528     C                   END
149900200528      *
150000200528      ** Deal number on screen must be blank or numeric for pointer
150100200528      *
150200200528     C     @ERRMS        IFEQ      'MMM0162'
150300200528     C                   MOVE      'N'           OKDLNO
150400200528     C                   END
150500200528      *
150600200528      ** Add error message to array passed to detail screen
150700200528      *
150800200528     C                   Z-ADD     1             E                 3 0
150900200528     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
151000200528     C                   MOVEL     '*ANY'        FldNameArr(E)
151100200528     C                   MOVEL     @ERRMS        MsgIdArr(E)
151200200528      *
151300200528     C                   ENDSR
151400200528      *****************************************************************
151500200528      /EJECT
151600200528      *****************************************************************
151700200528      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
151800200528      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
151900200528      *****************************************************************
152000200528     C     SCRN@S        BEGSR
152100200528      *                                                                                       192530
152200200528      * PAYMENT DATE = VALUE DATE                                                             192530
152300200528      *                                                                                       192530
152400200528      * For OP can amend Pay Side Settl Ins up to Option to Date                              192530
152500200528     C     DDACTN        IFEQ      'A'                                                        192530
152600200528     C     DDDLTP        ANDEQ     'OP'                                                       192530
152700200528     C                   Z-ADD     F3OTDN        ##DATP                                       192530
152800200528     C                   Z-ADD     F3OTDN        ##DATR                                       192530
152900200528     C                   ELSE                                                                 192530
153000200528     C                                                                                        192530
153100200528     C                   Z-ADD     F3VDDN        ##DATP                                       192530
153200200528      *                                                                                       192530
153300200528      * RECEIVE DATE = VALUE DATE                                                             192530
153400200528      *                                                                                       192530
153500200528     C                   Z-ADD     F3VDDN        ##DATR                                       192530
153600200528     C                   ENDIF                                                                192530
153700200528      *
153800200528      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
153900200528      *
154000200528     C     DDACTN        IFNE      ##ACTN
154100200528     C     DDDLNO        ORNE      ##DLNO
154200200528     C     DDSCCY        ORNE      ##PCCY
154300200528     C     DDBCCY        ORNE      ##RCCY
154400200528     C     DDCUST        ORNE      ##CSNM
154500200528     C     CDL008        OREQ      'Y'                                          CDL008
154600200528     C     DDCLSS        ANDNE     ##CLSS                                       CDL008
154700200528      *                                                                         CDL008
154800200528      ** If feature CDL008 is installed                                         CDL008
154900200528      *                                                                         CDL008
155000200528     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                CDL008
155100200528     C                   EVAL      ##TTYP = 'CL'                                CDL008
155200200528     C                   ELSE                                                   CDL008
155300200528     C                   EVAL      ##TTYP = DDDLTP                              CDL008
155400200528     C                   ENDIF                                                  CDL008
155500200528      *                                                                         CDL008
155600200528     C                   MOVE      DDCLSS        ##CLSS            1            CDL008
155700200528      *
155800200528      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
155900200528      *
156000200528     C                   EXSR      DETP@S
156100200528     C                   END
156200200528      *
156300200528      * SETTLEMENT INSTRUCTIONS INPUT
156400200528     C/COPY WNCPYSRC,FXFXDLSC41
156500200528      *
156600200528     C                   CALLB     'ZASETINSIN'
156700200528      *
156800200528      * INPUTS
156900200528      *
157000200528      * Return Code
157100200528     C                   PARM      *BLANK        ##RTCD           10
157200200528      *
157300200528      * Action code
157400200528     C                   PARM      DDACTN        ##ACTN            1
157500200528      *
157600200528      * Deal number
157700200528     C                   PARM      DDDLNO        ##DLNO            6
157800200528      *
157900200528      * Protect Payment
158000200528     C                   PARM                    ##PPAY            1
158100200528      *
158200200528      * Protect Receive
158300200528     C                   PARM                    ##PREC            1
158400200528      *
158500200528      * Calling program
158600200528     C                   PARM      'FXDL'        ##CALP            4
158700200528      *
158800200528      * Payment currency
158900200528     C                   PARM      DDSCCY        ##PCCY            3
159000200528      *
159100200528      * Receive currency
159200200528     C                   PARM      DDBCCY        ##RCCY            3
159300200528      *
159400200528      * Customer shortname
159500200528     C                   PARM      DDCUST        ##CSNM           10
159600200528      *
159700200528      * Transaction Type
159800200528     C***********        PARM      DDDLTP        ##TTYP            2            CDL008
159900200528     C                   PARM                    ##TTYP            2            CDL008
160000200528      *
160100200528      * Federal Funds Ind.
160200200528     C                   PARM      DDFEDF        ##FFND            1
160300200528      *
160400200528      * Booking branch
160500200528     C                   PARM      DDBRSN        ##BRCA            3
160600200528      *
160700200528      * Receipt Date
160800200528     C                   PARM                    ##DATR            5 0
160900200528      *
161000200528      * Payment Date
161100200528     C                   PARM                    ##DATP            5 0
161200200528      *
161300200528      * Payment instructions
161400200528     C                   PARM                    ##PAYS
161500200528      *
161600200528      * Receive instructions
161700200528     C                   PARM                    ##RECS
161800200528      *
161900200528      * FRA/IRS instructions
162000200528     C                   PARM                    ##FRIS
162100200528      *
162200200528      * OUTPUTS
162300200528      *
162400200528      * Payment instructions
162500200528     C                   PARM                    ##PAYF
162600200528      *
162700200528      * Receive instructions
162800200528     C                   PARM                    ##RECF
162900200528      *
163000200528      * FRA/IRS instructions
163100200528     C                   PARM                    ##FRIF
163200200528      *
163300200528      * FUNCTION KEYS
163400200528     C                   PARM      '0'           @INKC             1
163500200528     C                   PARM      '0'           @INKK             1                        MD036070
163600200528     C                   PARM      '0'           @INKL             1
163700200528      *
163800200528      ************                                                                     179510 200400
163900200528      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
164000200528     C************       PARM                    @MORPI                                179510 200400
164100200528      ************                                                                     179510 200400
164200200528      ************                                                                     179510 200400
164300200528     C/COPY WNCPYSRC,FXFXDLSC42
164400200528      * CK/3 - END PROGRAM
164500200528      *
164600200528     C     @INKC         CASEQ     '1'           ENDP
164700200528      *
164800200528      * CK/12 - CANCEL ON SETTLEMENT DETAILS
164900200528      *
165000200528     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
165100200528     C     @INKL         CASEQ     '1'           CANC@S
165200200528      *
165300200528      * EXIT FROM SETTLEMENT DETAILS
165400200528      *
165500200528     C                   CAS                     EXIT@S
165600200528     C                   END
165700200528      *
165800200528     C                   ENDSR
165900200528      *****************************************************************
166000200528      /EJECT
166100200528      *****************************************************************
166200200528      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
166300200528      *****************************************************************
166400200528     C     DETP@S        BEGSR
166500200528      *
166600200528      * PAYMENT DATE = VALUE DATE
166700200528      *
166800200528      * For OP can amend Pay Side Settl Ins up to Option to Date                    181721
166900200528     C     DDACTN        IFEQ      'A'                                              181721
167000200528     C     DDDLTP        ANDEQ     'OP'                                             181721
167100200528     C                   Z-ADD     F3OTDN        ##DATP                             181721
167200200528     C                   Z-ADD     F3OTDN        ##DATR                             181721
167300200528     C                   ELSE                                                       181721
167400200528     C                                                                              181721
167500200528     C                   Z-ADD     F3VDDN        ##DATP
167600200528      *
167700200528      * RECEIVE DATE = VALUE DATE
167800200528      *
167900200528     C                   Z-ADD     F3VDDN        ##DATR
168000200528     C                   ENDIF                                                      181721
168100200528      *
168200200528      * Convert Transaction Date to a Midas Day Number
168300200528      *
168400200528     C                   Z-ADD     F3DTYY        @@YY
168500200528     C                   Z-ADD     F3DTMM        @@MM
168600200528     C                   Z-ADD     F3DTDD        @@DD
168700200528     C     DateIn        IFEQ      0
168800200528     C                   Z-ADD     BJRDNB        TransDate
168900200528     C                   ELSE
169000200528     C                   CALLB     'ZDATE10'
169100200528     C                   PARM                    DateIn
169200200528     C                   PARM                    ZZMDNO            5 0
169300200528     C                   MOVE      ZZMDNO        TransDate         5 0
169400200528     C                   END
169500200528      *
169600200528      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
169700200528      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
169800200528      *
169900200528     C     ##DATP        IFLT      BJRDNB
170000200528     C     TransDate     ANDNE     BJRDNB
170100200528     C                   MOVEL     'Y'           ##PPAY
170200200528     C                   ELSE
170300200528     C                   MOVEL     'N'           ##PPAY
170400200528     C                   END
170500200528     C     ##DATR        IFLT      BJRDNB
170600200528     C     TransDate     ANDNE     BJRDNB
170700200528     C                   MOVEL     'Y'           ##PREC
170800200528     C                   ELSE
170900200528     C                   MOVEL     'N'           ##PREC
171000200528     C                   END
171100200528      *
171200200528      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
171300200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
171400200528      *
171500200528     C                   MOVEL     F3PAY         FLPAY
171600200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(F3PAY:1:2)                      CGL029
171700200528     C                   EVAL      %SUBST(FLPAY:3:18) = F3PONS                                CGL029
171800200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(F3PAY:15:545)                CGL029
171900200528     C                   MOVEL     F3POBR        FLPOBR
172000200528     C                   MOVEL     F3CVMR        FLCVMR
172100200528     C                   MOVEL     F3PSCY        FLPSCY
172200200528     C                   MOVEL     F3IC72        FLIC72
172300200528      *
172400200528      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
172500200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
172600200528      *
172700200528     C                   MOVEL     F3REC         FLREC
172800200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(F3REC:1:2)                      CGL029
172900200528     C                   EVAL      %SUBST(FLREC:3:18) = F3RONS                                CGL029
173000200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(F3REC:15:55)                  CGL029
173100200528     C                   MOVEL     F3ROBR        FLROBR
173200200528     C                   MOVEL     F3RSCY        FLRSCY
173300200528      *
173400200528      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
173500200528      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
173600200528      * or if CLS Settlement field was amended, default them                    CDL008
173700200528      *
173800200528     C     FLPSTM        IFEQ      *ZERO
173900200528     C     ##PPAY        ANDNE     'Y'
174000200528     C     FLRSTM        ANDEQ     *ZERO
174100200528     C     ##PREC        ANDNE     'Y'
174200200528     C     DDACTN        ANDNE     'E'                                          136433
174300200528     C     CDL008        OREQ      'Y'                                          CDL008
174400200528     C     DDACTN        ANDEQ     'A'                                          CDL008
174500200528     C     ##PPAY        ANDNE     'Y'                                          CDL008
174600200528     C     ##PREC        ANDNE     'Y'                                          CDL008
174700200528     C     FHCLSS        ANDEQ     'Y'                                          CDL008
174800200528     C     DDCLSS        ANDEQ     'N'                                          CDL008
174900200528     C     CDL008        OREQ      'Y'                                          CDL008
175000200528     C     DDACTN        ANDEQ     'A'                                          CDL008
175100200528     C     ##PPAY        ANDNE     'Y'                                          CDL008
175200200528     C     ##PREC        ANDNE     'Y'                                          CDL008
175300200528     C     FHCLSS        ANDEQ     'N'                                          CDL008
175400200528     C     DDCLSS        ANDEQ     'Y'                                          CDL008
175500200528      *
175600200528     C/COPY WNCPYSRC,FXH00026
175700200528     C                   CALLB     'ZASETINDFT'
175800200528      *
175900200528      * INPUTS
176000200528      *
176100200528      * Calling program
176200200528     C                   PARM      'FXDL'        ##CALP            4
176300200528      *
176400200528      * Payment currency
176500200528     C                   PARM      DDSCCY        ##PCCY            3
176600200528      *
176700200528      * Receive currency
176800200528     C                   PARM      DDBCCY        ##RCCY            3
176900200528     C/COPY WNCPYSRC,FXFXDLSC43
177000200528      *
177100200528      * Customer shortname
177200200528     C                   PARM      DDCUST        ##CSNM           10
177300200528      *
177400200528      * Transaction Type
177500200528     C***********        PARM      DDDLTP        ##TTYP            2            CDL008
177600200528     C                   PARM                    ##TTYP            2            CDL008
177700200528      *
177800200528      * Federal Funds Ind.
177900200528     C                   PARM      DDFEDF        ##FFND            1
178000200528      *
178100200528      ** Version of ISDA Rules govern
178200200528     C                   PARM                    BQISDA            4
178300200528      *
178400200528      ** Type of ISDA agreement
178500200528     C                   PARM                    BQAGTY            6
178600200528      *
178700200528      ** Date of ISDA Agreement
178800200528     C                   PARM                    BQAGDT            6
178900200528      *
179000200528      ** Version of ISDA Agreement
179100200528     C                   PARM                    BQAGVV            2
179200200528      ** Version of ISDA Agreement century                                                    176883
179300200528     C                   PARM                    Blank2            2                          176883
179400200528      ** Deal Subtype                                                                         CSD095
179500200528     C                   PARM      DDDLST        ##DLST            2                          CSD095
179600200528      ** Branch                                                                               CSD095
179700200528     C                   PARM      DDBRSN        ##BRSN            3                          CSD095
179800200528      *
179900200528      ** OUTPUTS
180000200528      *
180100200528      * Payment instructions
180200200528     C                   PARM                    ##PAYF
180300200528      *
180400200528      * Receive instructions
180500200528     C                   PARM                    ##RECF
180600200528      *
180700200528      * FRA/IRS instructions
180800200528     C                   PARM                    ##FRIF
180900200528      *
181000200528     C/COPY WNCPYSRC,FXH00027
181100200528     C                   END
181200200528      *
181300200528      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
181400200528      *
181500200528     C                   CALLB     'ZASETINCVT'
181600200528      *
181700200528      ** INPUTS
181800200528      *
181900200528      ** File Payment Settlement Instruction
182000200528     C                   PARM                    ##PAYF
182100200528      *
182200200528      ** File Receipt Settlement Instruction
182300200528     C                   PARM                    ##RECF
182400200528      *
182500200528      ** File FRA/IRS Settlement Instruction
182600200528     C                   PARM      *BLANK        ##FRIF
182700200528      *
182800200528      ** OUTPUTS
182900200528      ** Screen Payment Settlement Instruction
183000200528     C                   PARM      *BLANK        ##PAYS
183100200528      *
183200200528      ** Screen Receipt Settlement Instruction
183300200528     C                   PARM      *BLANK        ##RECS
183400200528      *
183500200528      ** Screen FRA/IRS Settlement Instruction
183600200528     C                   PARM      *BLANK        ##FRIS
183700200528     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
183800200528     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A
183900200528      *
184000200528     C/COPY WNCPYSRC,FXFXDLSIC1
184100200528     C                   ENDSR
184200200528      *****************************************************************
184300200528      /EJECT
184400200528      *****************************************************************
184500200528      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
184600200528      *****************************************************************
184700200528     C     CANC@S        BEGSR
184800200528      *
184900200528     C/COPY WNCPYSRC,FXFXDLSC08
185000200528      * Return to Main Details Screen
185100200528      *
185200200528     C                   MOVEL     'M'           @SCRN
185300200528     C/COPY WNCPYSRC,FXFXDLSC09
185400200528      *
185500200528     C                   ENDSR
185600200528      *****************************************************************
185700200528      /EJECT
185800200528      *****************************************************************
185900200528      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
186000200528      *****************************************************************
186100200528     C     EXIT@S        BEGSR
186200200528      *
186300200528      * IF SETTLEMENT DETAILS INVALID
186400200528      *
186500200528     C     ##RTCD        IFEQ      '*ERRORS'
186600200528      *
186700200528      * RETURN TO MAIN DETAILS SCREEN
186800200528      *
186900200528     C                   MOVEL     'M'           @SCRN
187000200528     C                   ELSE
187100200528      *
187200200528      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
187300200528      *
187400200528     C                   MOVEL     'C'           @SCRN
187500200528      *
187600200528      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
187700200528      *
187800200528     C                   MOVEL     FLPAY         F3PAY
187900200528     C                   EVAL      %SUBST(F3PAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
188000200528     C                   EVAL      F3PONS = %SUBST(FLPAY:3:18)                                CGL029
188100200528     C                   EVAL      %SUBST(F3PAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
188200200528     C                   MOVEL     FLPOBR        F3POBR
188300200528     C                   MOVEL     FLCVMR        F3CVMR
188400200528      ************                                                                     179510 200400
188500200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
188600200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
188700200528      ************                                                                     179510 200400
188800200528     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
188900200528     C************       MOVE      @@MOPI        F3MOPI                                179510 200400
189000200528     C************       ENDIF                                                         179510 200400
189100200528      ************                                                                     179510 200400
189200200528      *
189300200528      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
189400200528      *
189500200528     C                   MOVEL     FLREC         F3REC
189600200528     C                   EVAL      %SUBST(F3REC:1:2) = %SUBST(FLREC:1:2)                      CGL029
189700200528     C                   EVAL      F3RONS = %SUBST(FLREC:3:18)                                CGL029
189800200528     C                   EVAL      %SUBST(F3REC:15:55) = %SUBST(FLREC:21:55)                  CGL029
189900200528     C                   MOVEL     FLROBR        F3ROBR
190000200528      *
190100200528      ************                                                                     179510 200400
190200200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
190300200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
190400200528      ************                                                                     179510 200400
190500200528     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
190600200528     C************       MOVE      @@MORI        F3MORI                                179510 200400
190700200528     C************       ENDIF                                                         179510 200400
190800200528      ************                                                                     179510 200400
190900200528      * UPDATE VALID DEAL: SETTLEMENT CURRENCIES & 'IN' CCY IN FIELD 72
191000200528      *
191100200528     C                   MOVEL     FLRSCY        F3RSCY
191200200528     C                   MOVEL     FLPSCY        F3PSCY
191300200528     C                   MOVEL     FLIC72        F3IC72
191400200528     C                   END
191500200528      *
191600200528     C                   ENDSR
191700200528      *****************************************************************
191800200528      /EJECT
191900200528      *****************************************************************
192000200528      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
192100200528      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
192200200528      *****************************************************************
192300200528     C     SCRN@C        BEGSR
192400200528      *
192500200528      * Prior to validation, initialize error indicators as 'OK'
192600200528      *
192700200528     C                   MOVE      *ALL'Y'       FXEFXD
192800200528     C/COPY WNCPYSRC,FXH00196
192900200528      *
193000200528      * Validate deal details
193100200528      *
193200200528     C                   CALLB     'FXFXDLVAL'
193300200528     C                   PARM                    RespMode
193400200528     C                   PARM                    NwDlScnFmt
193500200528     C                   PARM                    InfData                        CAP051
193600200528     C                   PARM      F3RSCY        @@RSCY
193700200528     C                   PARM      F3RSTM        @@RSTM
193800200528     C                   PARM      F3RONS        @@RONS
193900200528     C                   PARM      F3PSCY        @@PSCY
194000200528     C                   PARM      F3PSTM        @@PSTM
194100200528     C                   PARM      F3PONS        @@PONS
194200200528     C                   PARM      F3FRNT        @@FRNT           20            CPB002
194300200528     C                   PARM                    ExtData                        CAP004
194400200528     C/COPY WNCPYSRC,FXFXDLSC07
194500200528     C                   PARM                    DDNBRF
194600200528     C                   PARM                    DDNSRF
194700200528     C                   PARM                    FXEFXD
194800200528     C                   PARM                    FldNameArr
194900200528     C                   PARM                    MsgIdArr
195000200528     C                   PARM                    MsgDtaArr
195100200528     C                   PARM      *ZERO         Idx               3 0
195200200528     C                   PARM                    WFldNamArr
195300200528     C                   PARM                    WMsgIdArr
195400200528     C                   PARM                    WMsgDtaArr
195500200528     C                   PARM      *ZERO         WIdx              3 0
195600200528     C                   PARM                    NwDlFilFmt
195700200528     C/COPY WNCPYSRC,FXFXDLSC37
195800200528      *
195900200528      * If transaction is valid output message 'Press enter to accept'
196000200528      *
196100200528     C     Idx           IFEQ      *ZERO
196200200528     C                   MOVEL     '*ANY'        FldNameArr(1)
196300200528     C                   MOVEL     'MMM1030'     MsgIdArr(1)
196400200528     C                   END
196500200528      *                                                                                       258601
196600200528     C     Idx           IFNE      *ZERO                                                      258601
196700200528     C                   EXSR      SFDS@M                                                     258601
196800200528     C                   EXSR      SFKS@M                                                     258601
196900200528     C                   MOVEL     'Y'           ERRFSR            1                          258601
197000200528     C                   ELSE                                                                 258601
197100200528     C                   MOVEL     'N'           @EKYFD                                       258601
197200200528     C                   MOVEL     'N'           @EDTFD                                       258601
197300200528     C                   MOVEL     'N'           @EINKG                                       258601
197400200528     C                   MOVEL     'N'           @EINKH                                       258601
197500200528     C                   MOVEL     'N'           @EINKJ                                       258601
197600200528     C                   MOVEL     'N'           @EINKN                                       258601
197700200528     C                   MOVEL     'N'           @EINKP                                       258601
197800200528     C                   MOVEL     'N'           ERRFSR                                       258601
197900200528     C                   END                                                                  258601
198000200528      *                                                                                       185612
198100200528      ** Call routine to output MDDR data                                                     185612
198200200528      *                                                                                       185612
198300200528     C     DDACTN        IFEQ      'I'                                                        185612
198400200528     C     DDACTN        OREQ      'X'                                                        185612
198500200528      *                                                                                       185612
198600200528      ** Set up buy and sell amounts                                                          185612
198700200528      *                                                                                       185612
198800200528     C     F3DAM1        IFLT      0                                                          185612
198900200528     C                   Z-SUB     F3DAM1        BAMT                                         185612
199000200528     C                   ELSE                                                                 185612
199100200528     C                   Z-ADD     F3DAM1        BAMT                                         185612
199200200528     C                   ENDIF                                                                185612
199300200528     C     F3DAM2        IFLT      0                                                          185612
199400200528     C                   Z-SUB     F3DAM2        SAMT                                         185612
199500200528     C                   ELSE                                                                 185612
199600200528     C                   Z-ADD     F3DAM2        SAMT                                         185612
199700200528     C                   ENDIF                                                                185612
199800200528                                                                                              185612
199900200528     C/COPY WNCPYSRC,FXH00072
200000200528     C                   CALLB     'FXMDDRAMT'                                                185612
200100200528                                                                                              185612
200200200528      ** Outputs from this procedure                                                          185612
200300200528      ** ---------------------------                                                          185612
200400200528      ** Return code (10A, returned to caller)                                                185612
200500200528     C                   PARM                    ReturnCode                                   185612
200600200528      ** Maximum Daily Delivery Risk fields:                                                  185612
200700200528     C                   PARM                    DDMDDR           16                          185612
200800200528     C                   PARM                    DDEXP1           16                          185612
200900200528     C                   PARM                    DDEXP2           16                          185612
201000200528     C                   PARM                    DDLIMT            6                          185612
201100200528     C                   PARM                    DDLIM1            3                          185612
201200200528     C                   PARM                    DDLIM2            3                          185612
201300200528     C                   PARM                    DDLIM3            9                          185612
201400200528                                                                                              185612
201500200528      ** Inputs to this procedure                                                             185612
201600200528      ** ------------------------                                                             185612
201700200528                                                                                              185612
201800200528     C** Action code                                                                          185612
201900200528     C                   PARM                    DDACTN                                       185612
202000200528     C** Customer                                                                             185612
202100200528     C                   PARM                    DDCUST                                       185612
202200200528     C** Buy Currency                                                                         185612
202300200528     C                   PARM                    DDBCCY                                       185612
202400200528     C** Sell Currency                                                                        185612
202500200528     C                   PARM                    DDSCCY                                       185612
202600200528     C** Run Day Number from SDBANKPD                                                         185612
202700200528     C                   PARM                    BJRDNB                                       185612
202800200528      ** System Location Code from SDBANKPD                                                   185612
202900200528     C                   PARM                    BJSLCD                                       185612
203000200528      ** Buy Amount                                                                           185612
203100200528     C                   PARM                    BAMT                                         185612
203200200528      ** Sell Amount                                                                          185612
203300200528     C                   PARM                    SAMT                                         185612
203400200528      ** Exposure Management indicator                                                        185612
203500200528     C                   PARM                    BGEXMG                                       185612
203600200528      ** Value Date in day number format                                                      185612
203700200528     C                   PARM                    F3VDDN                                       185612
203800200528      *                                                                                       185612
203900200528      ** Error fields/message IDs/message data (arrays) from/to caller                        185612
204000200528      *                                                                                       185612
204100200528     C                   PARM                    WFldNamArr                                   185612
204200200528     C                   PARM                    WMsgIdArr                                    185612
204300200528     C                   PARM                    WMsgDtaArr                                   185612
204400200528     C                   PARM                    WIdx                                         185612
204500200528      ** Booking Branch                                                                       185612
204600200528     C                   PARM                    DDBRSN                                       185612
204700200528     C/COPY WNCPYSRC,FXH00073
204800200528     C                   ENDIF                                                                185612
204900200528      *
205000200528      * WRITE/READ DISPLAY SCREEN
205100200528      *
205200200528     C                   CALLB     'FXFXDLDSP'
205300200528      *
205400200528      * INPUT PARAMETERS
205500200528      *
205600200528      * RETURN CODE
205700200528     C                   PARM      *BLANK        RetCodeOut
205800200528      *
205900200528      * DEAL (IN SCREEN FORMAT)
206000200528     C                   PARM                    NwDlScnFmt
206100200528      *
206200200528      * NET BUY/SELL REFERENCE
206300200528     C                   PARM                    DDNBRF
206400200528     C                   PARM                    DDNSRF
206500200528      *
206600200528      * DEAL STATUS
206700200528     C                   PARM                    DDSTS
206800200528     C/COPY WNCPYSRC,FXH00126
206900200528      *
207000200528      * FIELDS IN ERROR
207100200528     C                   PARM                    FXEFXD
207200200528     C/COPY WNCPYSRC,FXH00052
207300200528      *
207400200528      * ERRORS
207500200528     C                   PARM                    FldNameArr
207600200528     C                   PARM                    MsgIdArr
207700200528     C                   PARM                    MsgDtaArr
207800200528      *
207900200528      * WARNINGS
208000200528     C                   PARM                    WFldNamArr
208100200528     C                   PARM                    WMsgIdArr
208200200528     C                   PARM                    WMsgDtaArr
208300200528      *
208400200528      * ENABLED KEY & DETAIL FIELDS
208500200528      *
208600200528     C**********         PARM      'N'           @EKYFD                                       258601
208700200528     C                   PARM                    @EKYFD                                       258601
208800200528     C**********         PARM      'N'           @EDTFD                                       258601
208900200528     C                   PARM                    @EDTFD                                       258601
209000200528      *
209100200528      * ENABLED FUNCTION KEYS
209200200528     C**********         PARM      'N'           @EINKG                                       258601
209300200528     C                   PARM                    @EINKG                                       258601
209400200528     C**********         PARM      'N'           @EINKH                                       258601
209500200528     C                   PARM                    @EINKH                                       258601
209600200528     C**********         PARM      'N'           @EINKJ                                       258601
209700200528     C                   PARM                    @EINKJ                                       258601
209800200528     C**********         PARM      'N'           @EINKN                                       258601
209900200528     C                   PARM                    @EINKN                                       258601
210000200528     C**********         PARM      'N'           @EINKP                                       258601
210100200528     C                   PARM                    @EINKP                                       258601
210200200528      *
210300200528      * SUCCESFUL INSERT DEAL
210400200528     C                   PARM                    @SIDN             6
210500200528      *
210600200528      * OUTPUT PARAMETERS
210700200528      *
210800200528      * FUNCTION KEYS
210900200528     C                   PARM      '0'           @INKC             1
211000200528     C                   PARM      '0'           @INKG             1
211100200528     C                   PARM      '0'           @INKH             1
211200200528     C                   PARM      '0'           @INKJ             1
211300200528     C                   PARM      '0'           @INKL             1
211400200528     C                   PARM      '0'           @INKN             1
211500200528     C                   PARM      '0'           @INKP             1
211600200528     C                   PARM      'N'           WriteOnly         1
211700200528     C/COPY WNCPYSRC,FXFXDLSC29
211800200528      *                                                                                       185612
211900200528      ** Maximum Daily Delivery Risk fields:                                                  185612
212000200528      *                                                                                       185612
212100200528     C                   PARM                    DDMDDR           16                          185612
212200200528     C                   PARM                    DDEXP1           16                          185612
212300200528     C                   PARM                    DDEXP2           16                          185612
212400200528     C                   PARM                    DDLIM1            3                          185612
212500200528     C                   PARM                    DDLIM2            3                          185612
212600200528     C                   PARM                    DDLIM3            9                          185612
212700200528      *
212800200528      * RESET ERRORS
212900200528      *
213000200528     C/COPY WNCPYSRC,FXH00127
213100200528     C                   MOVE      *ALL'Y'       FXEFXD
213200200528     C                   MOVEL     *BLANK        FldNameArr
213300200528     C                   MOVEL     *BLANK        MsgIdArr
213400200528     C                   MOVEL     *BLANK        MsgDtaArr
213500200528     C                   MOVEL     *BLANK        WFldNamArr
213600200528     C                   MOVEL     *BLANK        WMsgIdArr
213700200528     C                   MOVEL     *BLANK        WMsgDtaArr
213800200528      *
213900200528      * CK/3 - END PROGRAM
214000200528      *
214100200528     C     @INKC         CASEQ     '1'           ENDP
214200200528      *
214300200528      * CK/12 - CANCEL ON CONFIRMATION SCREEN
214400200528      *
214500200528     C     @INKL         CASEQ     '1'           CANC@C
214600200528      *
214700200528      * EXIT CONFIRMATION SCREEN
214800200528      *
214900200528     C     ERRFSR        CASEQ     'Y'           VAL@M                                        258601
215000200528     C                   CAS                     EXIT@C
215100200528     C                   END
215200200528      *
215300200528     C                   ENDSR
215400200528      *****************************************************************
215500200528      /EJECT
215600200528      *****************************************************************
215700200528      * CANC@C - CANCEL ON CONFIRMATION SCREEN
215800200528      *****************************************************************
215900200528     C     CANC@C        BEGSR
216000200528      *
216100200528      * RETURN TO MAIN DETAILS SCREEN
216200200528      *
216300200528     C                   MOVEL     'M'           @SCRN
216400200528      *
216500200528      * Initialize field status on main details screen
216600200528      *
216700200528     C                   EXSR      IFDS@M
216800200528      *
216900200528      * Set function key status on main details screen
217000200528      * (according to action code)
217100200528      *
217200200528     C                   EXSR      SFKS@M
217300200528      *
217400200528     C                   ENDSR
217500200528      *****************************************************************
217600200528      /EJECT
217700200528      *****************************************************************
217800200528      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
217900200528      *****************************************************************
218000200528     C     EXIT@C        BEGSR
218100200528      *
218200200528      * IF NO ERRORS IN VALIDATION
218300200528      *
218400200528     C     Idx           IFEQ      *ZERO
218500200528      *
218600200528      * CONTINUE WITH UPDATES
218700200528      *
218800200528     C                   MOVEL     'U'           @SCRN
218900200528      *
219000200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
219100200528      *
219200200528     C                   ELSE
219300200528     C                   MOVEL     'M'           @SCRN
219400200528      *
219500200528      * Initialize field status on main details screen
219600200528      *
219700200528     C                   EXSR      IFDS@M
219800200528      *
219900200528      * Set function key status on main details screen
220000200528      * (according to action code)
220100200528      *
220200200528     C                   EXSR      SFKS@M
220300200528     C                   END
220400200528      *
220500200528     C                   ENDSR
220600200528      *****************************************************************
220700200528      /EJECT
220800200528      *****************************************************************
220900200528      * UPDATS - UPDATES
221000200528      *****************************************************************
221100200528     C     UPDATS        BEGSR
221200200528      *
221300200528     C/COPY WNCPYSRC,FXFXDLSC45
221400200528      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
221500200528      * GET NEXT AVAILABLE DEAL NUMBER
221600200528      *
221700200528     C     DDDLNO        IFEQ      *BLANK
221800200528      *
221900200528     C     I#DDDLNO      IFNE      *BLANK
222000200528     C                   MOVEL     I#DDDLNO      DDDLNO
222100200528     C                   ELSE
222200200528     C                   CALLB     'CAGETNXTDL'
222300200528     C                   PARM      *BLANKS       RetCodeOut
222400200528     C                   PARM      *BLANKS       @@MSG1            7
222500200528     C                   PARM                    DDDLNO
222600200528     C                   PARM      *ZERO         F3DN38
222700200528      *
222800200528      * DATABASE ERROR
222900200528      *
223000200528     C     @@MSG1        IFNE      *BLANK
223100200528     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
223200200528     C                   MOVEL     '002'         DBASE                          * DBERR 002*
223300200528     C                   MOVEL     DDDLNO        DBKEY                          ************
223400200528     C                   EXSR      *PSSR
223500200528     C                   END
223600200528     C                   END
223700200528     C                   MOVEL     DDDLNO        @SIDN
223800200528     C                   END
223900200528      *
224000200528      * UPDATE VALID DEAL: DEAL NUMBER
224100200528      *
224200200528     C                   MOVEL     DDDLNO        F3DN38
224300200528      *
224400200528      * UPDATE VALID DEAL: LAST ACTION CODE
224500200528      *
224600200528     C                   MOVEL     DDACTN        F3LACT
224700200528     C/COPY WNCPYSRC,FXH00053
224800200528      *
224900200528      * FOREIGN EXCHANGE DATABASE UPDATES
225000200528      *
225100200528     C                   CALLB     'FXFXDLUPF'
225200200528     C                   PARM      *BLANK        @RTCD             7
225300200528     C                   PARM                    NwDlFilFmt
225400200528     C/COPY WNCPYSRC,FXFXDLSC48
225500200528      *
225600200528      * DEALS UPDATES
225700200528      *
225800200528     C     @RTCD         IFEQ      *BLANK
225900200528     C                   CALLB     'FXFXDLUPD'
226000200528     C                   PARM                    @RTCD
226100200528     C                   PARM                    NwDlFilFmt
226200200528     C                   END
226300200528     C/COPY WNCPYSRC,FXFXDLSC44
226400200528      *
226500200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
226600200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
226700200528      *
226800200528     C     @RTCD         IFNE      *BLANK
226900200528     C*****@RTCD         ANDNE     '*RECUPD'                                           CAP006 251029
227000200528      *                                                                                       231306
227100200528     C     @RTCD         IFEQ      '*RECUPD'                                                  231306
227200200528     C     @RTCD         OREQ      '*RECLCK'                                                  231306
227300200528     C                   ROLBK                                                                231306
227400200528      *                                                                                       231306
227500200528     C                   ELSE                                                                 231306
227600200528     C                   If        (CSC022 = 'N')                                             CSC022
227700200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
227800200528     C                   ROLBK
227900200528     C                   EndIf                                                                CSC022
228000200528     C                   EXSR      *PSSR
228100200528     C                   ENDIF                                                                231306
228200200528     C                   ELSE
228300200528     C                   If        (CSC022 = 'N')                                             CSC022
228400200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
228500200528     C                   COMMIT
228600200528     C                   EndIf                                                                CSC022
228700200528     C                   MOVEL     *BLANKS       WFldNamArr                                   CAS004
228800200528     C                   MOVEL     *BLANKS       WMsgIdArr                                    CAS004
228900200528     C                   MOVEL     *BLANKS       WMsgDtaArr                                   CAS004
229000200528     C                   MOVE      *ALL'Y'       FXEFXD                                       CAS004
229100200528     C/COPY WNCPYSRC,FXFXDLSC40
229200200528     C                   END
229300200528      *
229400200528     C** If update not done due to record being updated by another              CAP006
229500200528     C** workstation send message to screen.                                    CAP006
229600200528     C                                                                          CAP006
229700200528     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
229800200528     C     @RTCD         OREQ      '*RECLCK'                                                  231306
229900200528      *                                                                                       231306
230000200528      ** Blank deal number variables if return code is an error due to                        231306
230100200528      ** object lock (Recupd).  Deal number generation needs to be                            231306
230200200528      ** reset until database update is successful.                                           231306
230300200528      *                                                                                       231306
230400200528     C     DDACTN        IFEQ      'I'                                                        231306
230500200528     C                   MOVE      *BLANKS       DDDLNO                                       231306
230600200528     C                   MOVE      *BLANKS       @SIDN                                        231306
230700200528     C                   ENDIF                                                                231306
230800200528      *                                                                                       231306
230900200528     C                                                                          CAP006
231000200528     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
231100200528      *                                                                                       231306
231200200528     C     @RTCD         IFEQ      '*RECUPD'                                                  231306
231300200528     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
231400200528     C                   ELSE                                                                 231306
231500200528     C                   MOVEL     'MMM1068'     MsgIdArr(1)                                  231306
231600200528      *                                                                                       231306
231700200528      ** Even if action "I"nsert was done thru F15, message needs to be                       231306
231800200528      ** displayed on main screen to prevent lost of inserted values.                         231306
231900200528      *                                                                                       231306
232000200528     C                   MOVE      *BLANKS       SAVRDNB           1                          231306
232100200528     C                   MOVE      @RDNB         SAVRDNB                                      231306
232200200528     C                   MOVE      *BLANKS       @RDNB                                        231306
232300200528      *                                                                                       231306
232400200528     C                   ENDIF                                                                231306
232500200528      *                                                                                       231306
232600200528     C                                                                          CAP006
232700200528     C**********         END                                                           CAP006 231306
232800200528     C                   ELSE                                                                 231306
232900200528     C                                                                          CAP006
233000200528      * BLANK THE MAIN DETAILS SCREEN
233100200528      *
233200200528     C                   MOVEL     *BLANK        NwDlScnFmt
233300200528     C                   MOVEL     *BLANK        DDSTS
233400200528     C                   MOVEL     *BLANK        DDNBRF
233500200528     C                   MOVEL     *BLANK        DDNSRF
233600200528     C/COPY WNCPYSRC,FXFXDLSC04
233700200528      *                                                                         183225
233800200528      ** Blank the settlement screen, reset temporary fields                    183225
233900200528      *                                                                         183225
234000200528     C                   CLEAR                   ##PAYF                         183225
234100200528     C                   CLEAR                   ##RECF                         183225
234200200528     C                   MOVEL     *BLANK        ##ACTN                         183225
234300200528     C                   MOVEL     *BLANK        ##DLNO                         183225
234400200528     C                   MOVEL     *BLANK        ##PCCY                         183225
234500200528     C                   MOVEL     *BLANK        ##RCCY                         183225
234600200528     C                   MOVEL     *BLANK        ##CSNM                         183225
234700200528     C                   MOVEL     *BLANK        ##CLSS                         CDL008
234800200528      *
234900200528      * Initialize field and function key status on main details screen
235000200528      *
235100200528     C                   EXSR      IFDS@M
235200200528     C                   EXSR      IFKS@M
235300200528      *                                                                                       231306
235400200528     C     SAVRDNB       IFNE      *BLANKS                                                    231306
235500200528     C                   MOVE      SAVRDNB       @RDNB                                        231306
235600200528     C                   ENDIF                                                                231306
235700200528      *                                                                                       231306
235800200528     C                   ENDIF                                                                231306
235900200528      *
236000200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
236100200528      *
236200200528     C     @RDNB         IFEQ      'Y'
236300200528     C                   MOVEL     'R'           @SCRN
236400200528     C/COPY WNCPYSRC,FXFXDLSC30
236500200528     C                   ELSE
236600200528      *
236700200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
236800200528      *
236900200528     C                   MOVEL     'M'           @SCRN
237000200528     C                   END
237100200528      *
237200200528     C                   ENDSR
237300200528      *****************************************************************
237400200528      /EJECT
237500200528      *****************************************************************
237600200528      * ENDP - END PROGRAM
237700200528      *****************************************************************
237800200528     C     ENDP          BEGSR
237900200528      *
238000200528      * Issue rollback to clear any possible updates in window function
238100200528      *
238200200528     C     BGWDPR        IFEQ      'Y'
238300200528     C                   If        (CSC022 = 'N')                                             CSC022
238400200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
238500200528     C                   ROLBK
238600200528     C                   Else                                                                 CSC022
238700200528     C                   SetOn                                        U7U8                    CSC022
238800200528     C                   EndIf                                                                CSC022
238900200528     C                   END
239000200528      *
239100200528     C                   MOVEL     'T'           @SCRN
239200200528     C/COPY WNCPYSRC,FXFXDLSC01
239300200528     C                   ENDSR
239400200528      *****************************************************************
239500200528      /EJECT
239600200528      *****************************************************************
239700200528      * *INZSR - INITIAL PROCESSING
239800200528      *****************************************************************
239900200528     C     *INZSR        BEGSR
240000200528      *
240100200528      ** Initialize program name
240200200528      *
240300200528     C                   MOVEL     'FXFXDLSIN'   DBPGM
240400200528      *
240500200528      ** ACCESS BANK DETAILS
240600200528      *
240700200528     C                   CALL      'AOBANKR0'
240800200528     C                   PARM      *BLANKS       @RTCD             7
240900200528     C                   PARM      '*FIRST '     @OPTN             7
241000200528     C     SDBANK        PARM      SDBANK        DSFDY
241100200528      *
241200200528      * DATABASE ERROR
241300200528      *
241400200528     C     @RTCD         IFNE      *BLANKS
241500200528     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
241600200528     C                   MOVEL     '901'         DBASE                          * DBERR 901*
241700200528     C                   MOVEL     @OPTN         DBKEY                          ************
241800200528     C                   EXSR      *PSSR
241900200528     C                   END
242000200528      *                                                                         CDL008
242100200528      ** Access SAR details file to determine if CDL008 is on.                  CDL008
242200200528      ** (Continuous Linked Settlement)                                         CDL008
242300200528      *                                                                         CDL008
242400200528     C                   CALLB     'AOSARDR0'                                   CDL008
242500200528     C                   PARM      *BLANKS       @RTCD                          CDL008
242600200528     C                   PARM      '*VERIFY'     @OPTN                          CDL008
242700200528     C                   PARM      'CDL008'      @SARD                          CDL008
242800200528     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
242900200528     C     @RTCD         IFNE      *BLANKS                                      CDL008
243000200528     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
243100200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
243200200528     C                   MOVEL     '903'         DBASE                          CDL008
243300200528     C                   MOVEL     'CDL008'      DBKEY                          CDL008
243400200528     C                   EXSR      *PSSR                                        CDL008
243500200528     C                   ENDIF                                                  CDL008
243600200528     C     @RTCD         IFEQ      *BLANKS                                      CDL008
243700200528     C                   MOVEL     'Y'           CDL008            1            CDL008
243800200528     C                   ELSE                                                   CDL008
243900200528     C                   MOVEL     'N'           CDL008                         CDL008
244000200528     C                   ENDIF                                                  CDL008
244100200528     C/COPY WNCPYSRC,FXFXDLSC31
244200200528      *
244300200528      ** Access Module Details
244400200528      *
244500200528     C                   CALL      'AOMMODR0'
244600200528     C                   PARM      *BLANKS       @RTCD
244700200528     C                   PARM      '*FIRST '     @OPTN
244800200528     C     SDMMOD        PARM      SDMMOD        DSFDY
244900200528      *
245000200528      * DATABASE ERROR
245100200528      *
245200200528     C     @RTCD         IFNE      *BLANKS
245300200528     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
245400200528     C                   MOVEL     '902'         DBASE                          * DBERR 901*
245500200528     C                   MOVEL     @OPTN         DBKEY                          ************
245600200528     C                   EXSR      *PSSR
245700200528     C                   END
245800200528      *
245900200528      * Start on Main Details Screen
246000200528      *
246100200528     C                   MOVEL     'M'           @SCRN             1
246200200528      *
246300200528      * Initialize field and function key status on main details screen
246400200528      *
246500200528     C                   EXSR      IFDS@M
246600200528     C                   EXSR      IFKS@M
246700200528     C/COPY WNCPYSRC,FXH00074
246800200528      *
246900200528
247000200528      ** Access SAR details file to determine if Commitment Control                           CSC022
247100200528      ** Changes is switched on.                                                              CSC022
247200200528     C                   CallB     'AOSARDR0'                                                 CSC022
247300200528     C                   Parm      *BLANKS       @RTCD                                        CSC022
247400200528     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
247500200528     C                   Parm      'CSC022'      @SARD                                        CSC022
247600200528     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
247700200528                                                                                              CSC022
247800200528     C/COPY WNCPYSRC,FXH00028
247900200528     C                   If        @RTCD = *BLANKS                                            CSC022
248000200528      *                                                                                       CSC022
248100200528     C                   Eval      CSC022 = 'Y'                                               CSC022
248200200528     C                   In        SCCMTJOB                                                   CSC022
248300200528     C                   If        ComitNum > 0                                               CSC022
248400200528      ** Check if Current Job exists in the Commitment Job Names                              CSC022
248500200528      ** Data Area.                                                                           CSC022
248600200528     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
248700200528     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
248800200528     C                   If        *IN20                                                      CSC022
248900200528     C                   Eval      wCommitSkip = 'Y'                                          CSC022
249000200528     C                   EndIf                                                                CSC022
249100200528     C                   EndIf                                                                CSC022
249200200528      *                                                                                       CSC022
249300200528     C                   Else                                                                 CSC022
249400200528      ** Database error                                                                       CSC022
249500200528     C                   If        @RTCD <> '*NRF'                                            CSC022
249600200528     C     *LOCK         In        LDA                                                        CSC022
249700200528     C                   Eval      DBKey = 'CSC022'                                           CSC022
249800200528     C                   Eval      DBPgm = 'FXFXDLSIN'                                        CSC022
249900200528     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
250000200528     C                   Eval      DBase = 904                                                CSC022
250100200528     C                   Out       LDA                                                        CSC022
250200200528     C                   ExSr      *PSSR                                                      CSC022
250300200528     C                   EndIf                                                                CSC022
250400200528      *                                                                                       CSC022
250500200528     C                   EndIf                                                                CSC022
250600200528      *                                                                                       CSC022
250700200528      *  Hook to enable non-core initial processing to be included
250800200528      /COPY WNCPYSRC,FXFXDLS010
250900200528
251000200528     C                   ENDSR
251100200528      *****************************************************************
251200200528      /EJECT
251300200528     C/COPY WNCPYSRC,FXFXDLSIC2
251400200528      *****************************************************************
251500200528      ** Program, module and procedure names for database error processing.
251600200528      ** =================================================================
251700200528      ** The following /COPY sets these values, and also defines LDA as
251800200528      ** an external data area
251900200528      ********************************************************************
252000200528     C/COPY ZACPYSRC,PSSR_ILE
252100200528      ********************************************************************
252200200528**  CPY@
252300200528(c) Finastra International Limited 2001
