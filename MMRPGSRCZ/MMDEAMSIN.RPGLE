000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal amendments input')                       *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  MMDEAMSIN - DEAL AMENDMENTS SCREEN INPUT                     *
001100200528      *                                                               *
001200200528      *  Function:  This is the main screen input function            *
001300200528      *             for Deal Amendments.                              *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 260173             Date 22May20               **
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
003000200528      *                 CDL049             Date 11Jul06               *
003100200528      *                 CSD027             Date 09Dec05               *
003200200528      *                 CLE031             Date 26Apr05               *
003300200528      *                 CDL038             Date 10May05               *
003400200528      *                 BUG3045            Date 02Jun02               *
003500200528      *                 CDL022             Date 03Feb04               *
003600200528      *                 CDL020             Date 03Feb04               *
003700200528      *                 CDL017             Date 03Feb04               *
003800200528      *                 CSC022             Date 24Feb04               *
003900200528      *                 CGL029             Date 01Sep03               *
004000200528      *                 222727             Date 05Nov03               *
004100200528      *                 CAS006             Date 21Jan03               *
004200200528      *                 CAS005             Date 16Dec02               *
004300200528      *                 CDL010             Date 02Aug02               *
004400200528      * Midas Release 4.01 -------------------------------------------*
004500200528      *                 196808             Date 25Oct01               *
004600200528      * Midas Release 4 --------------- Base -------------------------*
004700200528      *                 200400             Date 20Nov01               *
004800200528      * Midas DBA 3.04 -----------------------------------------------*
004900200528      *                 179510             Date 07Nov00               *
005000200528      * Midas DBA 3.03 -----------------------------------------------*
005100200528      *                 182558             Date 11Aug00               *
005200200528      *                 181274             Date 18Jul00               *
005300200528      * Midas DBA 3.02 Patch Z ---------------------------------------*
005400200528      *                 176883             Date 24Mar00               *
005500200528      * Midas DBA 3.02 -----------------------------------------------*
005600200528      *                 CAP052             Date 25Nov99               *
005700200528      *                 CAP051             Date 12Nov99               *
005800200528      *                 CPB001             Date 01Jun99               *
005900200528      *                 165402             DATE 04Aug99               *
006000200528      *                 CGL011             Date 20Sep99               *
006100200528      * Midas DBA 3.01 -----------------------------------------------*
006200200528      *                 CDL006             Date 26Apr99               *
006300200528      * Midas DBA 3.00 ---------------- Base -------------------------*
006400200528      *                 CAP006             Date 09Mar99               *
006500200528      *                 137552             Date 23Jun98               *
006600200528      *                 CAP004  *CREATE    Date 09Sep98               *
006700200528      *                 136433             Date 10Jun98               *
006800200528      *                 CAP002  *CREATE    Date 22Sep97               *
006900200528      *                                                               *
007000200528      *---------------------------------------------------------------*
007100200528      *                                                               *
007200200528      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
007300200528      *           parameter mismatch. Apply fix 258724.               *
007400200528      *  MD046248 - Finastra Rebranding                               *
007500200528      *  MD036070 - No way to go back to main deal details screen     *
007600200528      *             after reaching settlement screen.  Introduce new  *
007700200528      *             function key F11.                                 *
007800200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
007900200528      *  CDL096 - Business Day Conventions on MM Deals                *
008000200528      *           (Recompile)                                         *
008100200528      *  CDL094 - Enhance Receive Settlement Instructions             *
008200200528      *           (Recompile)                                         *
008300200528      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
008400200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
008500200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
008600200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
008700200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
008800200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
008900200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
009000200528      *  BUG3045- Protect pay/receive instructions for deal amendment *
009100200528      *           types EM and BC.                                    *
009200200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
009300200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
009400200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
009500200528      *           (Recompile)                                         *
009600200528      *  CSC022 - Commitment Control Changes for MidasPlus            *
009700200528      *  CGL029 - Increase Account Code to 10 digits                  *
009800200528      *  222727 - Release 5.0 errors  (Recompile)                     *
009900200528      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
010000200528      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
010100200528      *           (Recompile)                                         *
010200200528      *  CDL010 - Prevent last user that actioned the trade from      *
010300200528      *           authorising it.Recompile due to changes in MMDELDPP *
010400200528      *  196808 - IGSTCY should take the value of FLRSCY when FLPSCY  *
010500200528      *           is blank.                                           *
010600200528      *  200400 - Reverse fix 179510                                  *
010700200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
010800200528      *           Midas  Our  Receive/ Pay  Instructions  respectively*
010900200528      *           are not  correctly  updated .  Introduced  new  Data
011000200528      *           Structure  @MORPI  which is used  for that purpose .*
011100200528      *  182558 - Change the conditioning, as ZASETINDFT was not      *
011200200528      *           being called at all.                                *
011300200528      *  181274 - Branch code  BRCA  not correctly initialised  and   *
011400200528      *           is  stoping  the input  of  a  Deal Amendment  when *
011500200528      *           Settlement Method = 04  .   Error  msg   ESM0904 =  *
011600200528      *            'Must reference a Live Retail account '  issued  . *
011700200528      *  176883 - Errors found as a result of creating DBAR3.02       *
011800200528      *           Meridian repository file.                           *
011900200528      *           Recompiled due to mismatch between parameter calls  *
012000200528      *           to ZASETINDFT.                                      *
012100200528      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
012200200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
012300200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
012400200528      *           Recompiled due to changes in MMDEAMPP               *
012500200528      *  165402 - Fields on deals are being corrupted on amendment    *
012600200528      *  CGL011 - Collateral Processing for Midas DBA. Recompile.     *
012700200528      *  CDL006 - Dealing Fiduciary.                                  *
012800200528      *  CAP006 - Check for deal being updated by another workstation *
012900200528      *  137552 - Settlement branch not set on some deal amendments   *
013000200528      *  CAP004 - APIs phase 3.                                       *
013100200528      *           Add extra parm for Extra Data                       *
013200200528      *  136433 - Deals enquiry should not default settle instructions*
013300200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
013400200528      *                                                               *
013500200528      *****************************************************************
013600200528                                                                                              CDL006
013700200528      ** Loans/Deposit details file                                                           CDL006
013800200528     FMMDEALLL  IF   E           K DISK    USROPN                                             CDL006
013900200528     F                                     INFSR(*PSSR)                                       CDL006
014000200528     F                                     IGNORE(MMDENSP0:MMDENBP0)                          CDL006
014100200528                                                                                              CSD095
014200200528     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
014300200528     F                                     INFSR(*PSSR)                                       CSD095
014400200528
014500200528      *****************************************************************
014600200528      ** +--------------------------------------+
014700200528      ** ¦ Automatically included D-specs       ¦
014800200528      ** ¦ ==============================       ¦
014900200528      ** +--------------------------------------+
015000200528      **
015100200528      ** Standard D-specs
015200200528      ** ================
015300200528      **
015400200528      ** The following /COPY line includes the LDA layout,
015500200528      ** the copyright array definition,
015600200528      ** and the following named constants:
015700200528      **    True       logical = *on (for indcator processing)
015800200528      **    False      logical = *off (for indcator processing)
015900200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016000200528      **                                    handler)
016100200528      ** and the following variables:
016200200528      **    RunBefore  1A (for the PSSR)
016300200528
016400200528     D/COPY ZACPYSRC,STD_D_SPEC
016500200528
016600200528      ** Include the MM standard declares
016700200528     D/COPY ZACPYSRC,STDDECLARE
016800200528
016900200528      ** Program Status Data Structure
017000200528      ** =============================
017100200528      ** The following /COPY line includes all the defined fields in the
017200200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
017300200528
017400200528     D/COPY ZACPYSRC,PSDS
017500200528
017600200528      **--------------------------------------------------------------------------------------------
017700200528      ** The following /COPY line includes the definitions for error and
017800200528      ** warning message arrays.
017900200528     D/COPY ZACPYSRC,ERR_ARRAYS
018000200528      **--------------------------------------------------------------------------------------------
018100200528
018200200528      ** +--------------------------------------+
018300200528      ** ¦ End of automatically included D-specs¦
018400200528      ** ¦ =====================================¦
018500200528      ** +--------------------------------------+
018600200528
018700200528      *****************************************************************
018800200528      /EJECT
018900200528      *****************************************************************
019000200528
019100200528      ** +--------------------------------------+
019200200528      ** ¦ Manually included D-specs            ¦
019300200528      ** ¦ =========================            ¦
019400200528      ** +--------------------------------------+
019500200528
019600200528     D                 DS                                                                     CDL006
019700200528      ** Data structure for ZDATE10 date conversion module                                    CDL006
019800200528     D  WDate                  1      8  0                                                    CDL006
019900200528     D  WYear                  1      4  0                                                    CDL006
020000200528     D  WMonth                 5      6  0                                                    CDL006
020100200528     D  WDay                   7      8  0                                                    CDL006
020200200528                                                                                              CDL006
020300200528     D  WMidasDayNo    S              5  0                                                    CDL006
020400200528                                                                                              CDL006
020500200528      ** Dealing Fiduciary Switchable Feature                                                 CDL006
020600200528     D  CDL006         S              1A   IMPORT                                             CDL006
020700200528                                                                                              CDL006
020800200528      ** +--------------------------------------+
020900200528      ** ¦ Named constants                      ¦
021000200528      ** ¦ ===============                      ¦
021100200528      ** +--------------------------------------+
021200200528
021300200528
021400200528      ** +--------------------------------------+
021500200528      ** ¦ Arrays and Data Structures           ¦
021600200528      ** ¦ ==========================           ¦
021700200528      ** +--------------------------------------+
021800200528
021900200528      * Array to hold Commitment Job Names                                                    CSC022
022000200528     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
022100200528                                                                                              CSC022
022200200528      ** Commitment Control Data Area                                                         CSC022
022300200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
022400200528     D  wComitJob              4    103                                                       CSC022
022500200528                                                                                              CSC022
022600200528     D CrDlFilFmt    E DS                  EXTNAME(MMDEAMPP)
022700200528      * Current Deam in File Format
022800200528
022900200528     D CrDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
023000200528      * (Current) Deam in Screen Format
023100200528     D                                     PREFIX(@)
023200200528
023300200528     D NwDlFilFmt    E DS                  EXTNAME(MMVDEAMPD)
023400200528      * New Deam in File Format
023500200528     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
023600200528     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
023700200528     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
023800200528     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
023900200528     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
024000200528     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
024100200528     D  IGREC                300    368
024200200528     D  IGPAY                369    927
024300200528
024400200528     D NwDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
024500200528      * New Deam in Screen Format
024600200528
024700200528     D MMEDEM        E DS                  EXTNAME(MMEDEAMPD)
024800200528      * Error indicators
024900200528
025000200528
025100200528     D ##RECF        E DS                  EXTNAME(SDESFRPD)
025200200528      ** FILE RECEIVE INSTRUCTIONS
025300200528     D***FLREC**                1     69                                                      CGL029
025400200528     D  FLREC                  1     75                                                       CGL029
025500200528
025600200528     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
025700200528      *** FILE PAYMENT INSTRUCTIONS
025800200528     D***FLPAY**                1    559                                                      CGL029
025900200528     D  FLPAY                  1    565                                                       CGL029
026000200528
026100200528     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
026200200528      ** FILE FRA/IRS INSTRUCTIONS
026300200528
026400200528     D ##RECS        E DS                  EXTNAME(SDESSRPD)
026500200528      ** SCREEN RECEIVE INSTRUCTIONS
026600200528
026700200528     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
026800200528      ** SCREEN PAYMENT INSTRUCTIONS
026900200528
027000200528     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
027100200528      ** SCREEN FRA/IRS INSTRUCTIONS
027200200528
027300200528     D @SETIN          DS
027400200528      ** Receive / Pay Settlement Currency, Method & Nostro
027500200528     D  @@RSCY                 1      3
027600200528     D  @@RSTM                 4      5  0
027700200528     D***@@RONS*                6     17                                                      CGL029
027800200528     D***@@PSCY*               18     20                                                      CGL029
027900200528     D***@@PSTM*               21     22  0                                                   CGL029
028000200528     D***@@PONS*               23     34                                                      CGL029
028100200528     D  @@RONS                 6     23                                                       CGL029
028200200528     D  @@PSCY                24     26                                                       CGL029
028300200528     D  @@PSTM                27     28  0                                                    CGL029
028400200528     D  @@PONS                29     46                                                       CGL029
028500200528
028600200528     D @CCI@M          DS
028700200528      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
028800200528     D  @EKYFD                 1      1
028900200528     D  @EDTFD                 2      2
029000200528     D  @EINKG                 3      3
029100200528     D  @EINKH                 4      4
029200200528     D  @EINKJ                 5      5
029300200528     D  @EINKN                 6      6
029400200528     D  @EINKP                 7      7
029500200528
029600200528     D @PCI@M          DS             7
029700200528      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN
029800200528
029900200528     D                 DS
030000200528      **  Data structure for date in, to change format.
030100200528     D  DateIn                 1      8  0
030200200528     D  @@YY                   1      4  0
030300200528     D  @@MM                   5      6  0
030400200528     D  @@DD                   7      8  0
030500200528
030600200528     D                 DS
030700200528     D**  Data Structure to format date parameter passed to mm0085
030800200528     D  @PDAT                  1      8  0
030900200528     D  @PDYY                  1      4  0
031000200528     D  @PYEAR                 3      4  0
031100200528     D  @PDMM                  5      6  0
031200200528     D  @PDDD                  7      8  0
031300200528     D*
031400200528     D                 DS
031500200528     D**  Data Structure for screen value date
031600200528     D  @VDAT                  1      6
031700200528     D  @DSPD                  1      2
031800200528     D  @DSPM                  3      4
031900200528     D  @DSPY                  5      6
032000200528     D*
032100200528
032200200528     D*@MORPI*****     DS                                                              179510 200400
032300200528      ***Midas*Our Receive / Pay  Instructions (for Sett Meth = 04 )                   179510 200400
032400200528     D**@@MORI****             1     12                                                179510 200400
032500200528     D**@@MOPI****            13     24                                                179510 200400
032600200528      ************                                                                     179510 200400
032700200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
032800200528      ** EXTERNAL DS FOR BANK DETAILS
032900200528
033000200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
033100200528      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
033200200528
033300200528      ** External Data Structure for Access Program AOSARDR0                                  CDL006
033400200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
033500200528                                                                                              CDL006
033600200528     D DSFDY         E DS                  EXTNAME(DSFDY)
033700200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
033800200528                                                                                CAP051
033900200528     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
034000200528     D                                     PREFIX(IF_)                          CAP051
034100200528      * MM (DEAM) Extra Data - File (D/B) format                                CAP051
034200200528                                                                                              CAP004
034300200528     D ExtData       E DS                  EXTNAME(MMDAEXPD)                                  CAP004
034400200528      * MM DEAM Extra Data - File (D/B) format                                                CAP004
034500200528
034600200528     D/COPY QWINDSRC,MMDEAMSDTA
034700200528
034800200528      ** +--------------------------------------+
034900200528      ** ¦ Declared variables                   ¦
035000200528      ** ¦ ==================                   ¦
035100200528      ** +--------------------------------------+
035200200528
035300200528      ** Response Mode, passed as a constant parameter to the VAL module
035400200528      ** This is always 'S' for Synchronous
035500200528     D RespMode        S              1A   INZ('S')
035600200528
035700200528      ** Work variables for CSC022                                                            CSC022
035800200528     D CSC022          S              1A   INZ('N')                                           CSC022
035900200528     D wCommitSkip     S              1A   INZ('N')                                           CSC022
036000200528                                                                                              CSC022
036100200528     D InRCCY          S              3A                                                     CSF011A
036200200528     D InPCCY          S              3A                                                     CSF011A
036300200528      ** +--------------------------------------+
036400200528      ** ¦ End of D-specs                       ¦
036500200528      ** ¦ ==============                       ¦
036600200528      ** +--------------------------------------+
036700200528
036800200528      ** +----------------------------------------+
036900200528      ** ¦ Hook for non-core D-specs (all types)  ¦
037000200528      ** ¦ also any I-specs (if necessary)        ¦
037100200528      ** ¦ =====================================  ¦
037200200528      ** +----------------------------------------+
037300200528      /COPY WNCPYSRC,MMDEAMS008
037400200528
037500200528      *****************************************************************
037600200528      /EJECT
037700200528      *****************************************************************
037800200528     C
037900200528      ** +--- Start of Main processing -----------------------------------+
038000200528      ** ¦                                                                ¦
038100200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
038200200528      ** ¦ executed at program activation.                                ¦
038300200528      ** ¦                                                                ¦
038400200528      ** +----------------------------------------------------------------+
038500200528
038600200528      /COPY WNCPYSRC,MMDEAMS001
038700200528
038800200528      *
038900200528      * READ NEXT BROWSE SUBFILE RECORD
039000200528      *
039100200528     C     @SCRN         IFEQ      'R'
039200200528     C                   EXSR      RDNBRW
039300200528     C                   END
039400200528
039500200528      /COPY WNCPYSRC,MMDEAMS002
039600200528
039700200528      *
039800200528      * DO WHILE SCREEN: MAIN DETAILS
039900200528      *
040000200528     C     @SCRN         DOWEQ     'M'
040100200528     C                   EXSR      SCRN@M
040200200528     C     @SCRN         IfEq      'F'                                                        CDL006
040300200528     C                   ExSr      SCRN@F                                                     CDL006
040400200528     C                   EndIf                                                                CDL006
040500200528     C                   END
040600200528
040700200528      /COPY WNCPYSRC,MMDEAMS003
040800200528
040900200528      * SCREEN: WINDOW
041000200528      *
041100200528     C     @SCRN         IFEQ      'W'
041200200528     C                   EXSR      WINDOW
041300200528     C                   END
041400200528
041500200528      /COPY WNCPYSRC,MMDEAMS004
041600200528
041700200528      *
041800200528      *
041900200528      * DO WHILE SCREEN: SETTLEMENT DETAILS
042000200528      *
042100200528     C     @SCRN         DOWEQ     'S'
042200200528     C                   EXSR      SCRN@S
042300200528     C                   END
042400200528
042500200528      /COPY WNCPYSRC,MMDEAMS005
042600200528
042700200528      *
042800200528      * SCREEN: CONFIRMATION OF INPUT
042900200528      *
043000200528     C     @SCRN         IFEQ      'C'
043100200528     C                   EXSR      SCRN@C
043200200528     C                   END
043300200528
043400200528      /COPY WNCPYSRC,MMDEAMS006
043500200528
043600200528      *
043700200528      * DO FILE UPDATES
043800200528      *
043900200528     C     @SCRN         IFEQ      'U'
044000200528     C                   EXSR      UPDATS
044100200528     C                   END
044200200528
044300200528      /COPY WNCPYSRC,MMDEAMS007
044400200528
044500200528      *
044600200528      * TERMINATE PROGRAM
044700200528      *
044800200528     C     @SCRN         IFEQ      'T'
044900200528     C                   MOVE      '1'           *INLR
045000200528     C                   END
045100200528      *****************************************************************
045200200528
045300200528      * Hook to enable non-core subroutines to be included
045400200528      /COPY WNCPYSRC,MMDEAMS009
045500200528
045600200528      /EJECT
045700200528      *****************************************************************
045800200528      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
045900200528      *****************************************************************
046000200528     C     SCRN@M        BEGSR
046100200528      *
046200200528      * Issue rollback to clear any possible updates in window function
046300200528      * Only required if deal number or action code has been changed
046400200528      * (this check will also cater for F12 taken from main screen)
046500200528      *
046600200528     C     BGWDPR        IFEQ      'Y'
046700200528     C     DDDLNO        IFNE      @PDLNO
046800200528     C     DDVDAT        ORNE      @PVDAT                                       165402
046900200528     C     DDDS38        ORNE      @PDS38                                       165402
047000200528     C     DDACTN        ORNE      @PACTN                                       165402
047100200528     C     @CCI@M        ORNE      @PCI@M
047200200528     C                   If        (CSC022 = 'N')                                             CSC022
047300200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
047400200528     C                   ROLBK
047500200528     C                   Else                                                                 CSC022
047600200528     C                   SetOn                                        U7U8                    CSC022
047700200528     C                   EndIf                                                                CSC022
047800200528     C                   END
047900200528     C                   END
048000200528      *
048100200528      * Update 'previous' deal number & screen control indicator
048200200528      *
048300200528     C                   MOVEL     DDDLNO        @PDLNO            6
048400200528     C                   MOVEL     DDVDAT        @PVDAT            6
048500200528     C                   MOVEL     DDDS38        @PDS38            3
048600200528     C                   MOVEL     DDACTN        @PACTN            1            165402
048700200528     C                   MOVEL     @CCI@M        @PCI@M
048800200528      *
048900200528      * WRITE/READ DISPLAY SCREEN
049000200528      *
049100200528     C                   CALLB     'MMDEAMDSP'
049200200528      *
049300200528      * INPUT PARAMETERS
049400200528      *
049500200528      * RETURN CODE
049600200528     C                   PARM      *BLANK        RetCodeOut
049700200528      *
049800200528      * DEAM (IN SCREEN FORMAT)
049900200528     C                   PARM                    NwDlScnFmt
050000200528      *
050100200528      * DEAM STATUS
050200200528     C                   PARM                    DDSTS            24
050300200528      *
050400200528      * FIELDS IN ERROR
050500200528     C                   PARM                    MMEDEM
050600200528      *
050700200528      * ERRORS
050800200528     C                   PARM                    FldNameArr
050900200528     C                   PARM                    MsgIdArr
051000200528     C                   PARM                    MsgDtaArr
051100200528      *
051200200528      * WARNINGS
051300200528     C                   PARM                    WFldNamArr
051400200528     C                   PARM                    WMsgIdArr
051500200528     C                   PARM                    WMsgDtaArr
051600200528      *
051700200528      * ENABLED KEY & DETAIL FIELDS
051800200528      *
051900200528     C                   PARM                    @EKYFD
052000200528     C                   PARM                    @EDTFD
052100200528      *
052200200528      * ENABLED FUNCTION KEYS
052300200528     C                   PARM                    @EINKG
052400200528     C                   PARM                    @EINKH
052500200528     C                   PARM                    @EINKJ
052600200528     C                   PARM                    @EINKN
052700200528     C                   PARM                    @EINKP
052800200528      *
052900200528      * SUCCESFUL INSERT DEAL AMENDMENT (Sequence Number Generated)
053000200528     C                   PARM                    @LSQN             3
053100200528      *
053200200528      * OUTPUT PARAMETERS
053300200528      *
053400200528      * FUNCTION KEYS
053500200528     C                   PARM      '0'           @INKC             1
053600200528     C                   PARM      '0'           @INKG             1
053700200528     C                   PARM      '0'           @INKH             1
053800200528     C                   PARM      '0'           @INKJ             1
053900200528     C                   PARM      '0'           @INKL             1
054000200528     C                   PARM      '0'           @INKN             1
054100200528     C                   PARM      '0'           @INKP             1
054200200528     C                   PARM      'N'           WriteOnly         1
054300200528     C/COPY WNCPYSRC,MMDEAMSC06
054400200528      *
054500200528      * RESET ERRORS
054600200528      *
054700200528     C                   MOVE      *ALL'Y'       MMEDEM
054800200528     C                   MOVEL     *BLANK        FldNameArr
054900200528     C                   MOVEL     *BLANK        MsgIdArr
055000200528     C                   MOVEL     *BLANK        MsgDtaArr
055100200528     C                   MOVEL     *BLANK        WFldNamArr
055200200528     C                   MOVEL     *BLANK        WMsgIdArr
055300200528     C                   MOVEL     *BLANK        WMsgDtaArr
055400200528      *
055500200528      * CK/3 - END PROGRAM
055600200528      *
055700200528     C     @INKC         CASEQ     '1'           ENDP
055800200528      *
055900200528      * CK/7 - ROLL BACKWARDS
056000200528      *
056100200528     C     @INKG         CASEQ     '1'           ROLL
056200200528      *
056300200528      * CK/8 - ROLL FORWARDS
056400200528      *
056500200528     C     @INKH         CASEQ     '1'           ROLL
056600200528      *
056700200528      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
056800200528      *
056900200528     C     @INKL         CASEQ     '1'           CANC@M
057000200528      *
057100200528      * CK/15 - BUILD BROWSE
057200200528      *
057300200528     C     @INKP         CASEQ     '1'           BLDBRW
057400200528      *
057500200528      * VALIDATE INPUT TO MAIN DETAILS SCREEN
057600200528      *
057700200528     C                   CAS                     VAL@M
057800200528     C                   END
057900200528      *
058000200528     C                   ENDSR
058100200528      *****************************************************************
058200200528      /EJECT
058300200528      *****************************************************************
058400200528      *                                                               *                       CDL006
058500200528      *  SCRN@F - Calls Fiduciary Takings Enquiry Module              *                       CDL006
058600200528      *                                                               *                       CDL006
058700200528      *  Called By: Main Processing                                   *                       CDL006
058800200528      *                                                               *                       CDL006
058900200528      *  Calls:                                                       *                       CDL006
059000200528      * MMFIDTENQ - Fiduciary Takings Enquiry                         *                       CDL006
059100200528      * SRSETUP   - Sets up Deal details                              *                       CDL006
059200200528      *                                                               *                       CDL006
059300200528      *****************************************************************                       CDL006
059400200528                                                                                              CDL006
059500200528     C     SCRN@F        BEGSR                                                                CDL006
059600200528                                                                                              CDL006
059700200528      ** Set up Deal details                                                                  CDL006
059800200528                                                                                              CDL006
059900200528     C                   ExSr      SrSetup                                                    CDL006
060000200528                                                                                              CDL006
060100200528      ** Call Fiduciary Takings Enquiry                                                       CDL006
060200200528                                                                                              CDL006
060300200528     C                   CallB     'MMFIDTENQ'                                                CDL006
060400200528     C                   Parm                    #PGM             10                          CDL006
060500200528     C                   Parm                    ActionCode        1                          CDL006
060600200528     C                   Parm                    DealNo            6 0                        CDL006
060700200528     C                   Parm                    Dealtype          2                          CDL006
060800200528     C**********         Parm                    CustNo            6 0                 CDL006 CSD027
060900200528     C                   Parm                    CustNo            6                          CSD027
061000200528     C                   Parm                    Currency          3                          CDL006
061100200528     C                   Parm                    DealAmt          13 0                        CDL006
061200200528     C                   Parm                    IntRate          11 7                        CDL006
061300200528     C                   Parm                    DealDate          5 0                        CDL006
061400200528     C                   Parm                    ValDate           5 0                        CDL006
061500200528     C                   Parm                    MatDate           5 0                        CDL006
061600200528     C                   Parm                    NotDays           3 0                        CDL006
061700200528     C                   Parm                    ChCode            2                          CDL006
061800200528     C                   Parm                    ChDesc           20                          CDL006
061900200528     C                   Parm                    ChAmt            13 0                        CDL006
062000200528     C                   Parm                    TaxOnCharge       9 0                        CDL006
062100200528     C                   Parm                    ComCode           2                          CDL006
062200200528     C                   Parm                    ComDesc          20                          CDL006
062300200528     C                   Parm                    ComAmt           13 0                        CDL006
062400200528     C                   Parm                    TaxOnComm         9 0                        CDL006
062500200528     C                   Parm                    TrustSts          1                          CDL006
062600200528     C                   Parm                    RestNarr1        60                          CDL006
062700200528     C                   Parm                    RestNarr2        60                          CDL006
062800200528     C                   Parm                    RestNarr3        60                          CDL006
062900200528     C                   Parm                    RestNarr4        60                          CDL006
063000200528     C                   Parm                    ReturnCode                                   CDL006
063100200528                                                                                              CDL006
063200200528     C     ReturnCode    IfNe      *BLANK                                                     CDL006
063300200528     C     ReturnCode    IfEq      'Y2U9999'                                                  CDL006
063400200528     C                   ExSr      ENDP                                                       CDL006
063500200528     C                   Else                                                                 CDL006
063600200528                                                                                              CDL006
063700200528     C     ReturnCode    IfEq      'USR0790'                                                  CDL006
063800200528     C                   Eval      @SCRN = 'M'                                                CDL006
063900200528     C                   Else                                                                 CDL006
064000200528     C     *Lock         In        LDA                                                        CDL006
064100200528     C                   Z-Add     904           Dbase                                        CDL006
064200200528     C                   MoveL     'MMFIDTENQ'   DbFile                                       CDL006
064300200528     C                   MoveL     ReturnCode    DbKey                                        CDL006
064400200528     C                   MoveL     'MMDEAMSIN'   DbPgm                                        CDL006
064500200528     C                   Move      *On           *INU7                                        CDL006
064600200528     C                   Move      *On           *INU8                                        CDL006
064700200528     C                   Move      *On           *INLR                                        CDL006
064800200528     C                   Out       LDA                                                        CDL006
064900200528     C                   Exsr      *PSSR                                                      CDL006
065000200528     C                   Endif                                                                CDL006
065100200528     C                   Endif                                                                CDL006
065200200528                                                                                              CDL006
065300200528     C                   Else                                                                 CDL006
065400200528     C     BGWDPR        IfEq      'Y'                                                        CDL006
065500200528     C                   Eval      @SCRN = 'W'                                                CDL006
065600200528     C                   Else                                                                 CDL006
065700200528                                                                                              CDL006
065800200528     C     @RDNB         IfEq      'Y'                                                        CDL006
065900200528     C                   Eval      @SCRN = 'R'                                                CDL006
066000200528     C                   EndIf                                                                CDL006
066100200528                                                                                              CDL006
066200200528     C                   EndIf                                                                CDL006
066300200528                                                                                              CDL006
066400200528     C                   EndIf                                                                CDL006
066500200528                                                                                              CDL006
066600200528     C                   EndSr                                                                CDL006
066700200528      *****************************************************************                       CDL006
066800200528      /EJECT                                                                                  CDL006
066900200528      *****************************************************************                       CDL006
067000200528      *                                                               *                       CDL006
067100200528      *  SrSetup - Sets up Deal details                               *                       CDL006
067200200528      *                                                               *                       CDL006
067300200528      *  Called By: SCRN@F Subroutine                                 *                       CDL006
067400200528      *                                                               *                       CDL006
067500200528      *  Calls:                                                       *                       CDL006
067600200528      * ZDATE10   - Converts YYYY/MM/DD to Midas day no.              *                       CDL006
067700200528      *                                                               *                       CDL006
067800200528      *****************************************************************                       CDL006
067900200528                                                                                              CDL006
068000200528     C     SrSetup       BegSr                                                                CDL006
068100200528                                                                                              CDL006
068200200528      ** Deal details                                                                         CDL006
068300200528                                                                                              CDL006
068400200528     C                   Move      DDDLNO        DealNo                                       CDL006
068500200528                                                                                              CDL006
068600200528     C                   If        CDL006 = 'Y' and WOpen = ' '                               CDL006
068700200528     C                   Open      MMDEALLL                                                   CDL006
068800200528     C                   Move      'Y'           WOpen             1                          CDL006
068900200528     C                   EndIf                                                                CDL006
069000200528                                                                                              CDL006
069100200528     C     DealNo        Chain     MMDELDP0                           20                      CDL006
069200200528                                                                                              CDL006
069300200528      ** Convert Deal date to Midas day (Deal Amendment deal date)                            CDL006
069400200528                                                                                              CDL006
069500200528     C                   Z-Add     HNDMDY        WYear                                        CDL006
069600200528     C                   Z-Add     HNDMDM        WMonth                                       CDL006
069700200528     C                   Z-Add     HNDMDD        WDay                                         CDL006
069800200528     C                   CallB     'ZDATE10'                                                  CDL006
069900200528     C                   Parm                    WDate                                        CDL006
070000200528     C                   Parm                    WMidasDayNo                                  CDL006
070100200528                                                                                              CDL006
070200200528     C                   Z-Add     WMidasDayNo   DealDate                                     CDL006
070300200528                                                                                              CDL006
070400200528      ** Convert Value date to Midas day (Deal Amendment value date)                          CDL006
070500200528                                                                                              CDL006
070600200528     C                   Z-Add     HNVDYY        WYear                                        CDL006
070700200528     C                   Z-Add     HNVDMM        WMonth                                       CDL006
070800200528     C                   Z-Add     HNVDDD        WDay                                         CDL006
070900200528     C                   CallB     'ZDATE10'                                                  CDL006
071000200528     C                   Parm                    WDate                                        CDL006
071100200528     C                   Parm                    WMidasDayNo                                  CDL006
071200200528                                                                                              CDL006
071300200528     C                   Z-Add     WMidasDayNo   ValDate                                      CDL006
071400200528                                                                                              CDL006
071500200528      ** Convert Maturity date to Midas Day (Deal maturity date)                              CDL006
071600200528                                                                                              CDL006
071700200528     C                   Z-Add     HKMDYY        WYear                                        CDL006
071800200528     C                   Z-Add     HKMDMM        WMonth
071900200528     C                   Z-Add     HKMDDD        WDay                                         CDL006
072000200528     C                   CallB     'ZDATE10'                                                  CDL006
072100200528     C                   Parm                    WDate                                        CDL006
072200200528     C                   Parm                    WMidasDayNo                                  CDL006
072300200528                                                                                              CDL006
072400200528     C                   Z-Add     WMidasDayNo   MatDate                                      CDL006
072500200528                                                                                              CDL006
072600200528     C                   MoveL     'MMDEAMSIN'   #PGM                                         CDL006
072700200528     C                   Eval      ActionCode = DDACTN                                        CDL006
072800200528     C                   Eval      Dealtype = HKTYPE                                          CDL006
072900200528     C                   Eval      CustNo = HKCNUM                                            CDL006
073000200528     C                   Eval      Currency = HNCCY                                           CDL006
073100200528     C                   Eval      DealAmt = HNAMNP                                           CDL006
073200200528     C                   Eval      IntRate = HKINTR                                           CDL006
073300200528     C                   Eval      NotDays = HKNTCE                                           CDL006
073400200528     C                   Eval      ChCode =  FCGC                                             CDL006
073500200528     C                   Eval      ChDesc =  FCGD                                             CDL006
073600200528     C                   Eval      ChAmt = FXGA                                               CDL006
073700200528     C                   Eval      TaxOnCharge = FCGT                                         CDL006
073800200528     C                   Eval      ComCode = HKFCMC                                           CDL006
073900200528     C                   Eval      ComDesc = HKFCMD                                           CDL006
074000200528     C                   Eval      ComAmt = HKFCMA                                            CDL006
074100200528     C                   Eval      TaxOnComm = HKFCMT                                         CDL006
074200200528     C                   Eval      TrustSts = HKFTST                                          CDL006
074300200528     C                   Eval      RestNarr1 = HKFRN1                                         CDL006
074400200528     C                   Eval      RestNarr2 = HKFRN2                                         CDL006
074500200528     C                   Eval      RestNarr3 = HKFRN3                                         CDL006
074600200528     C                   Eval      RestNarr4 = HKFRN4                                         CDL006
074700200528     C                   Eval      ReturnCode = *BLANK                                        CDL006
074800200528                                                                                              CDL006
074900200528     C                   EndSr                                                                CDL006
075000200528      *****************************************************************                       CDL006
075100200528      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
075200200528      *****************************************************************
075300200528     C     VAL@M         BEGSR
075400200528      *
075500200528      * Retrieve deaM details
075600200528      *
075700200528     C                   EXSR      RTVDEL
075800200528      *
075900200528      * If action code, deal number, value date or sequence no. are NOT OK
076000200528      * Re-output screen with error messages on it
076100200528      *
076200200528     C     OKACTN        IFEQ      'N'
076300200528     C     OKDLNO        OREQ      'N'
076400200528     C     OKVDAT        OREQ      'N'
076500200528     C     OKDS38        OREQ      'N'
076600200528     C                   GOTO      EVAL@M
076700200528     C                   END
076800200528      *
076900200528      * Set field and function key status on main details screen
077000200528      * (according to action code)
077100200528      *
077200200528     C                   EXSR      SFDS@M
077300200528     C                   EXSR      SFKS@M
077400200528      *
077500200528      * If action code is delete, enquire or authorize
077600200528      * or action code is amend and deal number, value date or sequence
077700200528      * number has changed
077800200528      *   Put the deam on the main details screen
077900200528      *
078000200528     C     DDACTN        IFEQ      'D'
078100200528     C     DDACTN        OREQ      'E'
078200200528     C     DDACTN        OREQ      'X'
078300200528     C     DDACTN        OREQ      'A'
078400200528     C     DDDLNO        ANDNE     @PDLNO
078500200528     C     DDACTN        OREQ      'A'
078600200528     C     DDVDAT        ANDNE     @PVDAT
078700200528     C     DDACTN        OREQ      'A'
078800200528     C     DDDS38        ANDNE     @PDS38
078900200528     C     DDACTN        OREQ      'A'                                          165402
079000200528     C     DDACTN        ANDNE     @PACTN                                       165402
079100200528     C                   EXSR      PUTD@M
079200200528     C                   END
079300200528      *
079400200528      * If deal number, value date, sequence number or screen control
079500200528      * indicators have changed
079600200528      *   Re-output screen
079700200528      *
079800200528     C     DDDLNO        IFNE      @PDLNO
079900200528     C     DDACTN        ANDNE     'I'
080000200528     C     DDVDAT        ORNE      @PVDAT
080100200528     C     DDACTN        ANDNE     'I'
080200200528     C     DDDS38        ORNE      @PDS38
080300200528     C     DDACTN        ANDNE     'I'
080400200528     C     DDACTN        ORNE      @PACTN                                       165402
080500200528     C     @CCI@M        ORNE      @PCI@M
080600200528     C                   GOTO      EVAL@M
080700200528     C                   END
080800200528      *
080900200528      *----------------------------------------------------------------
081000200528      * IF DELETE
081100200528      *
081200200528     C     DDACTN        IFEQ      'D'
081300200528      *
081400200528      * Update DeaM in File Format
081500200528      *
081600200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
081700200528      *
081800200528      * IF CK/10 TAKEN, GO ONTO UPDATES
081900200528      *
082000200528     C     @INKJ         IFEQ      '1'
082100200528     C                   MOVEL     'U'           @SCRN
082200200528     C/COPY WNCPYSRC,MMDEAMSC04
082300200528     C                   END
082400200528     C                   GOTO      EVAL@M
082500200528     C                   END
082600200528      *
082700200528      *----------------------------------------------------------------
082800200528      * IF ENQUIRE
082900200528      *
083000200528     C     DDACTN        IFEQ      'E'
083100200528      *
083200200528      * Update DeaM in File Format
083300200528      *
083400200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
083500200528      *
083600200528      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
083700200528      * If windows processing on, call window routine
083800200528      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
083900200528      *
084000200528     C     @INKN         IFEQ      '1'
084100200528     C                   MOVEL     'S'           @SCRN
084200200528     C                   ELSE
084300200528                                                                                              CDL006
084400200528      ** If Dealing Fiduciary is installed, include additional proces -                       CDL006
084500200528      ** sing for fiduciary transactions.                                                     CDL006
084600200528                                                                                              CDL006
084700200528     C                   If        CDL006 = 'Y' and                                           CDL006
084800200528     C                             (HNOGDT = 'DT' or HNOGDT = 'LT') and                       CDL006
084900200528     C                             (DDMTYP = 'PI' or DDMTYP = 'PD')                           CDL006
085000200528     C                   Eval      @SCRN = 'F'                                                CDL006
085100200528     C                   Else                                                                 CDL006
085200200528     C     BGWDPR        IFEQ      'Y'
085300200528     C                   MOVEL     'W'           @SCRN
085400200528     C                   ELSE
085500200528     C     @RDNB         IFEQ      'Y'
085600200528     C                   MOVEL     'R'           @SCRN
085700200528     C                   END
085800200528     C                   END
085900200528     C                   EndIf                                                                CDL006
086000200528     C                   END
086100200528      *
086200200528     C                   GOTO      EVAL@M
086300200528     C                   END
086400200528      *
086500200528      *----------------------------------------------------------------
086600200528      * IF AUTHORIZE
086700200528      *
086800200528     C     DDACTN        IFEQ      'X'
086900200528      *
087000200528      * Update Deam in File Format
087100200528      *
087200200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
087300200528      *
087400200528      * If windows processing on, call window routine
087500200528      * otherwise, continue to settlements screen
087600200528      * CONTINUE TO SETTLEMENTS SCREEN
087700200528      ** (Do not display settlement screen if Deal Amendment type
087800200528      ** is 'Rate Change' or 'Capitalise Interest')
087900200528      *
088000200528     C     BGWDPR        IFEQ      'Y'
088100200528     C                   MOVEL     'W'           @SCRN
088200200528     C                   ELSE
088300200528     C     DDMTYP        IFNE      'SC'
088400200528     C     DDMTYP        ANDNE     'CI'
088500200528     C                   MOVEL     'S'           @SCRN
088600200528     C                   ELSE
088700200528     C                   MOVEL     'C'           @SCRN
088800200528     C                   END
088900200528     C                   END
089000200528      *
089100200528     C                   GOTO      EVAL@M
089200200528     C                   END
089300200528      *
089400200528      *----------------------------------------------------------------
089500200528      * IF INSERT OR AMEND
089600200528      *
089700200528     C     DDACTN        IFEQ      'I'
089800200528     C     DDACTN        OREQ      'A'
089900200528      *
090000200528      * Prior to validation, initialize error indicators as 'OK'
090100200528      * and clear Deam in File Format
090200200528      *
090300200528     C                   Z-ADD     *ZERO         Idx               3 0
090400200528     C                   Z-ADD     *ZERO         WIdx              3 0
090500200528     C                   MOVE      *ALL'Y'       MMEDEM
090600200528     C                   CLEAR                   NwDlFilFmt
090700200528     C                   Z-ADD     *ZERO         IGRSTM
090800200528     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
090900200528     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
091000200528     C                   EVAL      IGROBN = *BLANKS                                           CSD027
091100200528     C                   EVAL      IGROCN = *BLANKS                                           CSD027
091200200528     C                   Z-ADD     *ZERO         IGPSTM
091300200528     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
091400200528     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
091500200528     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
091600200528     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
091700200528      *
091800200528      * IF AMEND
091900200528      *
092000200528     C     DDACTN        IFEQ      'A'
092100200528      *
092200200528      * Update Deam in File Format
092300200528      *
092400200528     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
092500200528      *
092600200528      * Validate whether non-amenable fields have been changed
092700200528      *
092800200528     C                   CALLB     'MMDEAMAMD'
092900200528      *
093000200528      * INPUTS
093100200528      *
093200200528      * Return Code
093300200528     C                   PARM      *BLANK        RetCodeOut
093400200528      *
093500200528      * New Deam in Screen Format
093600200528     C                   PARM                    NwDlScnFmt
093700200528      *
093800200528      * Current Deam in Screen Format
093900200528     C                   PARM                    CrDlScnFmt
094000200528      *
094100200528      * Current Deam in file format
094200200528     C                   PARM                    CrDlFilFmt
094300200528      *
094400200528      * OUTPUTS
094500200528      *
094600200528      * Field OK flags (DS) from/to caller
094700200528     C                   PARM                    MMEDEM
094800200528      *
094900200528      * Error fields/message IDs/message data (arrays) from/to caller
095000200528     C                   PARM                    FldNameArr
095100200528     C                   PARM                    MsgIdArr
095200200528     C                   PARM                    MsgDtaArr
095300200528      *
095400200528      * Array index (3P0) from/to caller
095500200528     C                   PARM                    Idx
095600200528      *
095700200528      * Amendments OK
095800200528     C                   PARM                    @@AMOK            1
095900200528      *
096000200528      * Reset of Fields in Error Required (Y/N)
096100200528     C                   PARM      'Y'           @@RSTE            1
096200200528     C                   END
096300200528      *
096400200528      * Validate deam details
096500200528      *
096600200528     C                   CALLB     'MMDEAMVAL'
096700200528     C                   PARM                    RespMode
096800200528     C                   PARM                    NwDlScnFmt
096900200528     C                   PARM                    InfData                        CAP051
097000200528     C                   PARM                    ExtData                        CAP004
097100200528     C                   PARM                    MMEDEM
097200200528     C                   PARM                    FldNameArr
097300200528     C                   PARM                    MsgIdArr
097400200528     C                   PARM                    MsgDtaArr
097500200528     C                   PARM                    Idx
097600200528     C                   PARM                    WFldNamArr
097700200528     C                   PARM                    WMsgIdArr
097800200528     C                   PARM                    WMsgDtaArr
097900200528     C                   PARM                    WIdx
098000200528     C                   PARM                    NwDlFilFmt
098100200528      *
098200200528      * If errors returned
098300200528      *
098400200528     C     Idx           IFNE      0
098500200528     C                   GOTO      EVAL@M
098600200528     C                   END
098700200528      *
098800200528      * If windows processing on, call window routine
098900200528      * otherwise, continue to settlements screen
099000200528      ** (Do not display settlement screen if Deal Amendment type
099100200528      ** is 'Rate Change' or 'Capitalise Interest')
099200200528      *
099300200528     C     BGWDPR        IFEQ      'Y'
099400200528     C                   MOVEL     'W'           @SCRN
099500200528     C                   ELSE
099600200528     C     DDMTYP        IFNE      'SC'
099700200528     C     DDMTYP        ANDNE     'CI'
099800200528     C                   MOVEL     'S'           @SCRN
099900200528     C                   ELSE
100000200528     C                   MOVEL     'C'           @SCRN
100100200528     C                   END
100200200528     C                   END
100300200528      *
100400200528     C                   END
100500200528      *----------------------------------------------------------------
100600200528     C     EVAL@M        ENDSR
100700200528      *****************************************************************
100800200528      /EJECT
100900200528      *****************************************************************
101000200528      * WINDOW - CALL WINDOW MANAGER
101100200528      *****************************************************************
101200200528     C     WINDOW        BEGSR
101300200528      *
101400200528      * Reset erros
101500200528      *
101600200528     C                   MOVE      *ALL'Y'       MMEDEM
101700200528     C                   MOVEL     *BLANK        FldNameArr
101800200528     C                   MOVEL     *BLANK        MsgIdArr
101900200528     C                   MOVEL     *BLANK        MsgDtaArr
102000200528     C                   MOVEL     *BLANK        WFldNamArr
102100200528     C                   MOVEL     *BLANK        WMsgIdArr
102200200528     C                   MOVEL     *BLANK        WMsgDtaArr
102300200528      *
102400200528      * Write out screen to remove error messages
102500200528      *
102600200528     C                   CALLB     'MMDEAMDSP'
102700200528      *
102800200528      * INPUT PARAMETERS
102900200528      *
103000200528      * RETURN CODE
103100200528     C                   PARM      *BLANK        RetCodeOut
103200200528      *
103300200528      * DEAL (IN SCREEN FORMAT)
103400200528     C                   PARM                    NwDlScnFmt
103500200528      *
103600200528      * DEAL STATUS
103700200528     C                   PARM                    DDSTS            24
103800200528      *
103900200528      * FIELDS IN ERROR
104000200528     C                   PARM                    MMEDEM
104100200528      *
104200200528      * ERRORS
104300200528     C                   PARM                    FldNameArr
104400200528     C                   PARM                    MsgIdArr
104500200528     C                   PARM                    MsgDtaArr
104600200528      *
104700200528      * WARNINGS
104800200528     C                   PARM                    WFldNamArr
104900200528     C                   PARM                    WMsgIdArr
105000200528     C                   PARM                    WMsgDtaArr
105100200528      *
105200200528      * ENABLED KEY & DETAIL FIELDS
105300200528      *
105400200528     C                   PARM                    @EKYFD
105500200528     C                   PARM                    @EDTFD
105600200528      *
105700200528      * ENABLED FUNCTION KEYS
105800200528     C                   PARM                    @EINKG
105900200528     C                   PARM                    @EINKH
106000200528     C                   PARM                    @EINKJ
106100200528     C                   PARM                    @EINKN
106200200528     C                   PARM                    @EINKP
106300200528      *
106400200528      * SUCCESFUL INSERT DEAM
106500200528     C                   PARM                    @LSQN             3
106600200528      *
106700200528      * OUTPUT PARAMETERS
106800200528      *
106900200528      * FUNCTION KEYS
107000200528     C                   PARM      '0'           @INKC             1
107100200528     C                   PARM      '0'           @INKG             1
107200200528     C                   PARM      '0'           @INKH             1
107300200528     C                   PARM      '0'           @INKJ             1
107400200528     C                   PARM      '0'           @INKL             1
107500200528     C                   PARM      '0'           @INKN             1
107600200528     C                   PARM      '0'           @INKP             1
107700200528     C                   PARM      'Y'           WriteOnly         1
107800200528     C/COPY WNCPYSRC,MMDEAMSC07
107900200528      *
108000200528      * For inserts generate Deal Amendment Sequence Number
108100200528      *
108200200528     C                   IF        DDACTN = 'I'
108300200528     C                   EXSR      SETUPDASEQ
108400200528     C                   ENDIF
108500200528      *
108600200528     C/COPY WNCPYSRC,MMDEAMSMV1
108700200528      *
108800200528     C                   CALL      'WN0010'
108900200528     C                   PARM      'MMDEAMSIN'   #PGM             10
109000200528     C                   PARM                    FKEY              2
109100200528     C                   PARM      DDACTN        ACTION            1
109200200528     C                   PARM                    DATA
109300200528     C                   PARM      *BLANKS       #RTRN             7
109400200528     C                   PARM                    SPAREW          256
109500200528      *
109600200528      * Process returned command keys
109700200528      *
109800200528     C     #RTRN         IFEQ      'Y2U9999'
109900200528     C                   EXSR      ENDP
110000200528     C                   ELSE
110100200528      *
110200200528      *  If Cmd12 pressed, or in enquiry, return to main details screen;
110300200528      *  otherwise, go to settlements screen
110400200528      *
110500200528     C     #RTRN         IFEQ      'USR0790'
110600200528     C     DDACTN        OREQ      'E'
110700200528     C     @RDNB         IFEQ      'Y'
110800200528     C/COPY WNCPYSRC,MMDEAMSC08
110900200528     C                   EVAL      @SCRN = 'R'
111000200528     C                   ELSE
111100200528     C                   EVAL      @SCRN = 'M'
111200200528     C                   END
111300200528     C                   ELSE
111400200528      ** (Do not display settlement screen if Deal Amendment type
111500200528      ** is 'Rate Change' or 'Capitalise Interest')
111600200528      *
111700200528     C     DDMTYP        IFNE      'SC'
111800200528     C     DDMTYP        ANDNE     'CI'
111900200528     C                   EVAL      @SCRN = 'S'
112000200528     C                   ELSE
112100200528     C                   EVAL      @SCRN = 'C'
112200200528     C                   ENDIF
112300200528     C/COPY WNCPYSRC,MMDEAMSC05
112400200528     C                   ENDIF
112500200528     C                   ENDIF
112600200528      *
112700200528     C     WIND          ENDSR
112800200528      *****************************************************************
112900200528      /EJECT
113000200528      *****************************************************************
113100200528      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEAMS FILE
113200200528      *****************************************************************
113300200528     C     ROLL          BEGSR
113400200528      *
113500200528      * Default action code to enquiry if not valid
113600200528      *
113700200528     C     DDACTN        IFNE      'A'
113800200528     C     DDACTN        ANDNE     'D'
113900200528     C     DDACTN        ANDNE     'X'
114000200528     C                   MOVE      'E'           DDACTN
114100200528     C                   END
114200200528      *
114300200528      * READ NEXT OR PREVIOUS RECORD ON DEAMS FILE
114400200528      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
114500200528      *
114600200528     C     @INKG         IFEQ      '1'
114700200528     C                   MOVEL     *BLANK        @RDFWD
114800200528     C                   MOVEL     'Y'           @RDBCK
114900200528     C                   ELSE
115000200528     C                   MOVEL     'Y'           @RDFWD
115100200528     C                   MOVEL     *BLANK        @RDBCK
115200200528     C                   END
115300200528      *
115400200528     C                   CALLB     'MMDEAMRED'
115500200528      *
115600200528      * INPUT PARAMETERS
115700200528      *
115800200528      * RETURN CODE
115900200528     C                   PARM      *BLANK        RetCodeOut
116000200528      *                                                                         CAP052
116100200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
116200200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
116300200528      *                                                                         CAP052
116400200528     C                   PARM      '      '      @@MODE            6            CAP052
116500200528      *
116600200528      * ACTION CODE
116700200528     C                   PARM                    DDACTN            1
116800200528      *
116900200528      * DEAL NUMBER POINTER
117000200528     C                   PARM                    DDDLNO            6
117100200528      *                                                                         CAP052
117200200528      * Front Office ID                                                         CAP052
117300200528     C                   PARM                    DDFRTN           20            CAP052
117400200528     C                   PARM                    DDVDAT            6
117500200528     C                   PARM                    DDDS38            3
117600200528      *
117700200528      * READ FORWARDS
117800200528     C                   PARM                    @RDFWD            1
117900200528      *
118000200528      * READ BACKWARDS
118100200528     C                   PARM                    @RDBCK            1
118200200528      *
118300200528      * OUTPUT PARAMETERS
118400200528      *
118500200528      * ERROR MESSAGE
118600200528     C                   PARM      *BLANK        @ERRMS            7
118700200528      *
118800200528      * DEAL NUMBER READ
118900200528     C                   PARM      *BLANK        @DLRED            6
119000200528      *                                                                         CAP052
119100200528      * Front Office ID READ                                                    CAP052
119200200528     C                   PARM      *BLANK        @FTRED           20            CAP052
119300200528      *                                                                         CAP052
119400200528      * Front Office Associated ID READ                                         CAP052
119500200528     C                   PARM      *BLANK        @FARED           20            CAP052
119600200528      *
119700200528      * VALUE DATE READ
119800200528     C                   PARM      *BLANK        @VDRED            6
119900200528      *
120000200528      * SEQUENCE NUMBER READ
120100200528     C                   PARM      *BLANK        @SQRED            3
120200200528      *
120300200528      * If error message returned from read, send it to detail screen
120400200528      *
120500200528     C     @ERRMS        IFNE      *BLANK
120600200528     C                   EXSR      SNDM@M
120700200528     C                   GOTO      EROLL
120800200528     C                   END
120900200528      *
121000200528      * If deam read
121100200528      *
121200200528     C     @DLRED        IFNE      *BLANK
121300200528     C     @VDRED        ANDNE     *BLANK
121400200528     C     @SQRED        ANDNE     *BLANK
121500200528      *
121600200528      * Retrieve deam details
121700200528      *
121800200528     C                   MOVEL     @DLRED        DDDLNO
121900200528     C                   MOVEL     @VDRED        DDVDAT
122000200528     C                   MOVEL     @SQRED        DDDS38
122100200528     C                   EXSR      RTVDEL
122200200528      *
122300200528      * Set field and function key status on main details screen
122400200528      * (according to action code)
122500200528      *
122600200528     C                   EXSR      SFDS@M
122700200528     C                   EXSR      SFKS@M
122800200528      *
122900200528      * Put the deam on the main details screen
123000200528      *
123100200528     C                   EXSR      PUTD@M
123200200528     C                   END
123300200528      *
123400200528     C     EROLL         ENDSR
123500200528      *****************************************************************
123600200528      /EJECT
123700200528      *****************************************************************
123800200528      * BLDBRW - BUILD BROWSE SUBFILE
123900200528      *****************************************************************
124000200528     C     BLDBRW        BEGSR
124100200528      *
124200200528      * RESET READ NEXT BROWSE SUBFILE RECORD
124300200528      *
124400200528     C                   MOVEL     *BLANK        @RDNB             1
124500200528     C/COPY WNCPYSRC,MMDEAMSC09
124600200528      *
124700200528      * BUILD BROWSE SUBFILE
124800200528      *
124900200528     C                   CALLB     'MMDEAMBRW'
125000200528      *
125100200528      * INPUT PARAMETERS
125200200528      *
125300200528      * RETURN CODE
125400200528     C                   PARM      *BLANK        RetCodeOut
125500200528      *
125600200528      * ACTION CODE
125700200528     C                   PARM                    DDACTN            1
125800200528      *
125900200528      * DEAL NUMBER POINTER
126000200528     C                   PARM                    DDDLNO            6
126100200528      *
126200200528      * VALUE DATE POINTER
126300200528     C                   PARM                    DDVDAT            6
126400200528      *
126500200528      * SEQUENCE POINTER
126600200528     C                   PARM                    DDDS38            3
126700200528      *
126800200528      * BUILD SUB-FILE
126900200528     C                   PARM      'Y'           @BDSFL            1
127000200528      *
127100200528      * READ SUBFILE RECORD
127200200528     C                   PARM      *BLANK        @RDSFL            1
127300200528      *
127400200528      * OUTPUT PARAMETERS
127500200528      *
127600200528      * ERROR MESSAGE
127700200528     C                   PARM      *BLANK        @ERRMS            7
127800200528      *
127900200528      * OPTION SELECTED
128000200528     C                   PARM      *BLANK        @OPSEL            1
128100200528      *
128200200528      * DEAL NUMBER SELECTED
128300200528     C                   PARM      *BLANK        @DLSEL            6
128400200528      *
128500200528      * VALUE DATE SELECTED
128600200528     C                   PARM                    @VDSEL            6
128700200528      *
128800200528      * SEQWUENCE SELECTED
128900200528     C                   PARM                    @SQSEL            3
129000200528      *
129100200528      * COMMAND KEYS
129200200528     C                   PARM      '0'           @INKC             1
129300200528     C                   PARM      '0'           @INKL             1
129400200528     C/COPY WNCPYSRC,MMDEAMSC10
129500200528      *
129600200528      * If CK/3 taken in browse, end program
129700200528      *
129800200528     C     @INKC         IFEQ      '1'
129900200528     C                   EXSR      ENDP
130000200528     C                   GOTO      EBLDBR
130100200528     C                   END
130200200528      *
130300200528      * If error message returned from browse, send it to detail screen
130400200528      *
130500200528     C     @ERRMS        IFNE      *BLANK
130600200528     C                   EXSR      SNDM@M
130700200528     C                   GOTO      EBLDBR
130800200528     C                   END
130900200528      *
131000200528      * If CK/12 not taken in browse
131100200528      * Read next browse subfile record
131200200528      *
131300200528     C     @INKL         IFNE      '1'
131400200528     C                   MOVE      'Y'           @RDNB
131500200528     C                   MOVEL     'R'           @SCRN
131600200528     C/COPY WNCPYSRC,MMDEAMSC11
131700200528     C                   GOTO      EBLDBR
131800200528     C                   END
131900200528      *
132000200528     C     EBLDBR        ENDSR
132100200528      *****************************************************************
132200200528      /EJECT
132300200528      *****************************************************************
132400200528      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
132500200528      *****************************************************************
132600200528     C     RDNBRW        BEGSR
132700200528     C/COPY WNCPYSRC,MMDEAMSC12
132800200528      *
132900200528      * READ NEXT SUBFILE RECORD
133000200528      *
133100200528     C                   CALLB     'MMDEAMBRW'
133200200528      *
133300200528      * INPUT PARAMETERS
133400200528      *
133500200528      * RETURN CODE
133600200528     C                   PARM      *BLANK        RetCodeOut
133700200528      *
133800200528      * ACTION CODE
133900200528     C                   PARM                    DDACTN            1
134000200528      *
134100200528      * DEAL NUMBER POINTER
134200200528     C                   PARM                    DDDLNO            6
134300200528      *
134400200528      * VALUE DATE POINTER
134500200528     C                   PARM                    DDVDAT            6
134600200528      *
134700200528      * SEQUENCE POINTER
134800200528     C                   PARM                    DDDS38            3
134900200528      *
135000200528      * BUILD SUB-FILE
135100200528     C                   PARM      *BLANK        @BDSFL            1
135200200528      *
135300200528      * READ SUBFILE RECORD
135400200528     C                   PARM      'Y'           @RDSFL            1
135500200528      *
135600200528      * OUTPUT PARAMETERS
135700200528      *
135800200528      * ERROR MESSAGE
135900200528     C                   PARM      *BLANK        @ERRMS            7
136000200528      *
136100200528      * OPTION SELECTED
136200200528     C                   PARM      *BLANK        @OPSEL            1
136300200528      *
136400200528      * DEAL NUMBER SELECTED
136500200528     C                   PARM      *BLANK        @DLSEL            6
136600200528      *
136700200528      * VALUE DATE SELECTED
136800200528     C                   PARM                    @VDSEL            6
136900200528      *
137000200528      * SEQUENCE SELECTED
137100200528     C                   PARM                    @SQSEL            3
137200200528      *
137300200528      * COMMAND KEYS
137400200528     C                   PARM      '0'           @INKC             1
137500200528     C                   PARM      '0'           @INKL             1
137600200528     C/COPY WNCPYSRC,MMDEAMSC13
137700200528      *
137800200528      * IF DEAM READ FROM SUBFILE
137900200528      *
138000200528     C     @DLSEL        IFNE      *BLANK
138100200528      *
138200200528      * Retrieve deam details
138300200528      *
138400200528     C                   MOVEL     @OPSEL        DDACTN
138500200528     C/COPY WNCPYSRC,MMDEAMSC14
138600200528     C                   MOVEL     @DLSEL        DDDLNO
138700200528     C                   MOVEL     @VDSEL        DDVDAT
138800200528     C                   MOVEL     @SQSEL        DDDS38
138900200528     C                   EXSR      RTVDEL
139000200528     C/COPY WNCPYSRC,MMDEAMSC15
139100200528      *
139200200528      * Set field and function key status on main details screen
139300200528      * (according to action code)
139400200528      *
139500200528     C                   EXSR      SFDS@M
139600200528     C                   EXSR      SFKS@M
139700200528      *
139800200528      * Put the deam on the main details screen
139900200528      *
140000200528     C                   EXSR      PUTD@M
140100200528     C/COPY WNCPYSRC,MMDEAMSC16
140200200528      *
140300200528      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
140400200528      *
140500200528     C                   ELSE
140600200528     C/COPY WNCPYSRC,MMDEAMSC17
140700200528     C                   MOVEL     *BLANK        @RDNB
140800200528     C/COPY WNCPYSRC,MMDEAMSC18
140900200528     C                   END
141000200528      *
141100200528      * GO TO MAIN DETAILS SCREEN
141200200528      *
141300200528     C                   MOVE      'M'           @SCRN
141400200528     C/COPY WNCPYSRC,MMDEAMSC19
141500200528      *
141600200528     C                   ENDSR
141700200528      *****************************************************************
141800200528      /EJECT
141900200528      *****************************************************************
142000200528      * RTVDEL - RETRIEVE DEAM
142100200528      *****************************************************************
142200200528     C     RTVDEL        BEGSR
142300200528      *
142400200528      * RETRIEVE DEAM
142500200528      *
142600200528     C                   CALLB     'MMDEAMRTV'
142700200528      *
142800200528      * INPUTS
142900200528      *
143000200528      * Return code
143100200528     C                   PARM      *BLANK        RetCodeOut
143200200528      *
143300200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
143400200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
143500200528      *
143600200528     C                   PARM      '      '      @@MODE            6
143700200528      *
143800200528      * Response mode
143900200528     C                   PARM      'S'           @@RSMD            1
144000200528      *
144100200528      * Action Code
144200200528     C                   PARM                    DDACTN
144300200528      *
144400200528      * Front Office Transaction ID
144500200528     C                   PARM                    FOTRID           20
144600200528      *
144700200528      * Front Office Associated Transaction Id
144800200528     C                   PARM                    FOASID           20
144900200528      *
145000200528      * (Midas) Deal Number
145100200528     C                   PARM                    DDDLNO
145200200528      *
145300200528      * Value Date
145400200528     C                   PARM                    DDVDAT            6
145500200528      *
145600200528      * Sequence Number
145700200528     C                   PARM                    DDDS38            3
145800200528      *
145900200528      * Deal Amendment Amount
146000200528     C                   PARM                    DDAMNP           15
146100200528      *
146200200528      * Deal Amendment Type
146300200528     C                   PARM                    DDMTYP            2
146400200528      * Action Code (Reversal transaction)                                                    260173
146500200528     C                   PARM      *BLANK        @ACTRV            1                          260173
146600200528      *
146700200528      * OUTPUTS
146800200528      *
146900200528      * (Current) deam in file format
147000200528     C                   PARM                    CrDlFilFmt
147100200528      *
147200200528      * OK - Action code
147300200528     C                   PARM      *BLANK        OKACTN
147400200528      *
147500200528      * OK - Deal Number
147600200528     C                   PARM      *BLANK        OKDLNO
147700200528      *
147800200528      * OK - Value Date
147900200528     C                   PARM                    OKVDAT
148000200528      *
148100200528      * OK - Sequence Number
148200200528     C                   PARM                    OKDS38
148300200528      *
148400200528      * Error fields/message IDs/message data (arrays) from/to caller
148500200528     C                   PARM                    FldNameArr
148600200528     C                   PARM                    MsgIdArr
148700200528     C                   PARM                    MsgDtaArr
148800200528      *
148900200528      * Array index (3P0) from/to caller
149000200528     C                   PARM      *ZERO         Idx
149100200528                                                                                              CDL006
149200200528      ** Retrieve warning message, if needed.                                                 CDL006
149300200528                                                                                              CDL006
149400200528     C                   If        DDACTN = 'D' or DDACTN = 'I'                               CDL006
149500200528                                                                                              CDL006
149600200528     C                   Move      DDDLNO        DealNo                                       CDL006
149700200528                                                                                              CDL006
149800200528     C                   CallB     'MMDEAMWRN'                                                CDL006
149900200528     C                   Parm                    DealNo                                       CDL006
150000200528     C                   Parm                    DDACTN                                       CDL006
150100200528     C                   Parm                    HNMTYP                                       CDL006
150200200528     C                   Parm                    WFldNamArr                                   CDL006
150300200528     C                   Parm                    WMsgIdArr                                    CDL006
150400200528     C                   Parm                    WMsgDtaArr                                   CDL006
150500200528     C                   Parm                    WIdx                                         CDL006
150600200528                                                                                              CDL006
150700200528     C                   Endif                                                                CDL006
150800200528                                                                                              CDL006
150900200528      *
151000200528     C                   ENDSR
151100200528      *****************************************************************
151200200528      /EJECT
151300200528      *****************************************************************
151400200528      * PUTD@M - PUT A DEAM ON THE MAIN DETAILS SCREEN
151500200528      *****************************************************************
151600200528     C     PUTD@M        BEGSR
151700200528      *
151800200528      * Call program to fill screen fields with data from MMDEAMPP
151900200528      *
152000200528     C                   CALLB     'MMDEAMCVT'
152100200528      *
152200200528      * INPUTS
152300200528      *
152400200528      * Return Code
152500200528     C                   PARM      *BLANK        RetCodeOut
152600200528      *
152700200528      * Deam in file format
152800200528     C                   PARM                    CrDlFilFmt
152900200528      *
153000200528      * OUTPUTS
153100200528      *
153200200528      * Deam in screen format
153300200528     C                   PARM                    NwDlScnFmt
153400200528      *
153500200528      * Deam Status
153600200528     C                   PARM                    DDSTS            24
153700200528      *
153800200528      * Update 'Current' Deam with Deam in Screen Format
153900200528      *
154000200528     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
154100200528      *
154200200528     C                   ENDSR
154300200528      *****************************************************************
154400200528      /EJECT
154500200528      *****************************************************************
154600200528      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
154700200528      *          ACCORDING TO ACTION CODE
154800200528      *****************************************************************
154900200528     C     SFDS@M        BEGSR
155000200528      *
155100200528      * Enable/disable key & detail fields on main details screen
155200200528      * (key fields = action code & deal number / value date / sequence no.
155300200528      *  detail fields = rest)
155400200528      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
155500200528      *
155600200528     C     DDACTN        IFEQ      'I'
155700200528     C     DDACTN        OREQ      'A'
155800200528     C                   MOVEL     'Y'           @EKYFD
155900200528     C                   MOVEL     'Y'           @EDTFD
156000200528     C                   ELSE
156100200528     C                   MOVEL     'N'           @EKYFD
156200200528     C                   MOVEL     'N'           @EDTFD
156300200528     C                   END
156400200528     C/COPY WNCPYSRC,MMDEAMSC20
156500200528      *
156600200528     C                   ENDSR
156700200528      *****************************************************************
156800200528      /EJECT
156900200528      *****************************************************************
157000200528      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
157100200528      *          ACCORDING TO ACTION CODE
157200200528      *****************************************************************
157300200528     C     SFKS@M        BEGSR
157400200528      *
157500200528      * Enable/disable function keys on main details screen
157600200528      *
157700200528      * KG = COMMAND KEY 07 = READ PREVIOUS
157800200528      * KH = COMMAND KEY 08 = READ NEXT
157900200528      *
158000200528     C                   MOVEL     'Y'           @EINKG
158100200528     C                   MOVEL     'Y'           @EINKH
158200200528      *
158300200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
158400200528      *
158500200528     C     DDACTN        IFEQ      'D'
158600200528     C                   MOVEL     'Y'           @EINKJ
158700200528     C                   ELSE
158800200528     C                   MOVEL     'N'           @EINKJ
158900200528     C                   END
159000200528      *
159100200528      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
159200200528      * (Action codes I, A, X display settlement details automatically)
159300200528      * (No futher screens are available from action code D)
159400200528      *
159500200528     C     DDACTN        IFEQ      'E'
159600200528     C                   MOVEL     'Y'           @EINKN
159700200528     C                   ELSE
159800200528     C                   MOVEL     'N'           @EINKN
159900200528     C                   END
160000200528      *
160100200528      * KP = COMMAND KEY 15 = BROWSE
160200200528      *
160300200528     C                   MOVEL     'Y'           @EINKP
160400200528     C/COPY WNCPYSRC,MMDEAMSC21
160500200528      *
160600200528     C                   ENDSR
160700200528      *****************************************************************
160800200528      /EJECT
160900200528      *****************************************************************
161000200528      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
161100200528      *****************************************************************
161200200528     C     IFDS@M        BEGSR
161300200528      *
161400200528      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
161500200528      *
161600200528     C                   MOVEL     'Y'           @EKYFD
161700200528     C                   MOVEL     'Y'           @EDTFD
161800200528     C/COPY WNCPYSRC,MMDEAMSC22
161900200528      *
162000200528     C                   ENDSR
162100200528      *****************************************************************
162200200528      /EJECT
162300200528      *****************************************************************
162400200528      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
162500200528      *****************************************************************
162600200528     C     IFKS@M        BEGSR
162700200528      *
162800200528      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
162900200528      * KG = COMMAND KEY 07 = READ PREVIOUS
163000200528      * KH = COMMAND KEY 08 = READ NEXT
163100200528      * KJ = COMMAND KEY 10 = CONFIRM DELETE
163200200528      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
163300200528      * KP = COMMAND KEY 15 = BROWSE
163400200528      *
163500200528     C                   MOVEL     'Y'           @EINKG
163600200528     C                   MOVEL     'Y'           @EINKH
163700200528     C                   MOVEL     'N'           @EINKJ
163800200528     C                   MOVEL     'N'           @EINKN
163900200528     C                   MOVEL     'Y'           @EINKP
164000200528     C/COPY WNCPYSRC,MMDEAMSC23
164100200528      *
164200200528     C                   ENDSR
164300200528      *****************************************************************
164400200528      /EJECT
164500200528      *****************************************************************
164600200528      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
164700200528      *****************************************************************
164800200528     C     CANC@M        BEGSR
164900200528     C/COPY WNCPYSRC,MMDEAMSC24
165000200528      *
165100200528      * Reset Read Next Browse Subfile Record (if active)
165200200528      *
165300200528     C                   MOVEL     *BLANK        @RDNB
165400200528     C/COPY WNCPYSRC,MMDEAMSC25
165500200528      *
165600200528      * If input fields are enabled
165700200528      * Blank the main details screen
165800200528      *
165900200528     C     @EKYFD        IFEQ      'Y'
166000200528     C     @EDTFD        OREQ      'Y'
166100200528     C                   MOVEL     *BLANK        NwDlScnFmt
166200200528     C                   MOVEL     *BLANK        DDSTS
166300200528     C                   END
166400200528      *
166500200528      * Initialize field and function key status on main details screen
166600200528      *
166700200528     C                   EXSR      IFDS@M
166800200528     C                   EXSR      IFKS@M
166900200528      *
167000200528     C                   ENDSR
167100200528      *****************************************************************
167200200528      /EJECT
167300200528      *****************************************************************
167400200528      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
167500200528      *****************************************************************
167600200528     C     SNDM@M        BEGSR
167700200528      *
167800200528      * If single branching, user can't browse file
167900200528      *
168000200528     C     @ERRMS        IFEQ      'FXM0292'
168100200528     C                   MOVE      'N'           OKACTN
168200200528     C                   END
168300200528      *
168400200528      ** Deal number on screen must be blank or numeric for pointer
168500200528      *
168600200528     C     @ERRMS        IFEQ      'MMM0162'
168700200528     C                   MOVE      'N'           OKDLNO
168800200528     C                   END
168900200528      *
169000200528      ** Value Date on screen must be blank or valid date for pointer
169100200528      *
169200200528     C     @ERRMS        IFEQ      'MMM0125'
169300200528     C                   MOVE      'N'           OKVDAT
169400200528     C                   END
169500200528      *
169600200528      ** Sequence no. must be numeric if entered
169700200528      *
169800200528     C     @ERRMS        IFEQ      'MMM0196'
169900200528     C                   MOVE      'N'           OKDS38
170000200528     C                   END
170100200528      *
170200200528      ** Add error message to array passed to detail screen
170300200528      *
170400200528     C                   Z-ADD     1             E                 3 0
170500200528     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
170600200528     C                   MOVEL     '*ANY'        FldNameArr(E)
170700200528     C                   MOVEL     @ERRMS        MsgIdArr(E)
170800200528      *
170900200528     C                   ENDSR
171000200528      *****************************************************************
171100200528      /EJECT
171200200528      *****************************************************************
171300200528      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
171400200528      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
171500200528      *****************************************************************
171600200528     C     SCRN@S        BEGSR
171700200528      *
171800200528      * IF FIRST TIME FOR ACTION CODE OR DEAL AMENDMENT
171900200528      *
172000200528     C     DDACTN        IFNE      ##ACTN
172100200528     C     DDDLNO        ORNE      ##DLNO
172200200528     C     DDVDAT        ORNE      ##VDAT
172300200528     C     DDDS38        ORNE      ##DS38
172400200528     C     DDMTYP        ORNE      ##TTYP
172500200528     C     DDPENP        ORNE      ##PENP                                                    BUG3045
172600200528      *
172700200528      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
172800200528      *
172900200528     C                   EXSR      DETP@S
173000200528     C                   END
173100200528      *
173200200528      * SETTLEMENT INSTRUCTIONS INPUT
173300200528     C/COPY WNCPYSRC,MMDEAMSC29
173400200528      *
173500200528     C                   CALLB     'ZASETINSIN'
173600200528      *
173700200528      * INPUTS
173800200528      *
173900200528      * Return Code
174000200528     C                   PARM      *BLANK        ##RTCD           10
174100200528      *
174200200528      * Action code
174300200528     C                   PARM      DDACTN        ##ACTN            1
174400200528      *
174500200528      * Deal number
174600200528     C                   PARM      DDDLNO        ##DLNO            6
174700200528      *
174800200528      * Protect Payment
174900200528     C                   PARM                    ##PPAY            1
175000200528      *
175100200528      * Protect Receive
175200200528     C                   PARM                    ##PREC            1
175300200528      *
175400200528      * Calling program
175500200528     C                   PARM      'DEAM'        ##CALP            4
175600200528      *
175700200528      * Payment currency
175800200528     C                   PARM      DDCCY         ##PCCY            3
175900200528      *
176000200528      * Receive currency
176100200528     C                   PARM      DDCCY         ##RCCY            3
176200200528      *
176300200528      * Customer shortname
176400200528     C                   PARM      DDCSNM        ##CSNM           10
176500200528      *
176600200528      * Transaction Type
176700200528     C                   PARM      DDMTYP        ##TTYP            2
176800200528      *
176900200528      * Federal Funds Ind.
177000200528     C                   PARM                    ##FFND            1
177100200528      *
177200200528      * Booking branch
177300200528     C**********         PARM                    ##BRCA            3                          181274
177400200528     C                   PARM      IGBRCA        ##BRCA            3                          181274
177500200528      *
177600200528      * Receipt Date
177700200528     C                   PARM                    ##DATR            5 0
177800200528      *
177900200528      * Payment Date
178000200528     C                   PARM                    ##DATP            5 0
178100200528      *
178200200528      * Payment instructions
178300200528     C                   PARM                    ##PAYS
178400200528      *
178500200528      * Receive instructions
178600200528     C                   PARM                    ##RECS
178700200528      *
178800200528      * FRA/IRS instructions
178900200528     C                   PARM                    ##FRIS
179000200528      *
179100200528      * OUTPUTS
179200200528      *
179300200528      * Payment instructions
179400200528     C                   PARM                    ##PAYF
179500200528      *
179600200528      * Receive instructions
179700200528     C                   PARM                    ##RECF
179800200528      *
179900200528      * FRA/IRS instructions
180000200528     C                   PARM                    ##FRIF
180100200528      *
180200200528      * FUNCTION KEYS
180300200528     C                   PARM      '0'           @INKC             1
180400200528     C                   PARM      '0'           @INKK             1                        MD036070
180500200528     C                   PARM      '0'           @INKL             1
180600200528      *
180700200528      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
180800200528     C************       PARM                    @MORPI                                179510 200400
180900200528      ************                                                                     179510 200400
181000200528     C/COPY WNCPYSRC,MMDEAMSC30
181100200528     C                   MOVE      DDVDAT        ##VDAT            6
181200200528     C                   MOVE      DDDS38        ##DS38            3
181300200528      *
181400200528      * CK/3 - END PROGRAM
181500200528      *
181600200528     C     @INKC         CASEQ     '1'           ENDP
181700200528      *
181800200528      * CK/12 - CANCEL ON SETTLEMENT DETAILS
181900200528      *
182000200528     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
182100200528     C     @INKL         CASEQ     '1'           CANC@S
182200200528      *
182300200528      * EXIT FROM SETTLEMENT DETAILS
182400200528      *
182500200528     C                   CAS                     EXIT@S
182600200528     C                   END
182700200528      *
182800200528     C                   ENDSR
182900200528      *****************************************************************
183000200528      /EJECT
183100200528      *****************************************************************
183200200528      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
183300200528      *****************************************************************
183400200528     C     DETP@S        BEGSR
183500200528      *
183600200528      ** SET PAYMENT AND RECEIVE DATES TO VALUE DATE OF DEAL AMENDMENT
183700200528     C                   Z-ADD     IGDVSD        ##DATR
183800200528     C                   Z-ADD     IGDVSD        ##DATP
183900200528      *
184000200528      * LOAN OR DEPOSIT TYPE DEAL?
184100200528      *
184200200528     C     HNOMDT        IFEQ      'IT'
184300200528     C     HNOMDT        OREQ      'TD'
184400200528     C     HNOMDT        OREQ      'CI'
184500200528     C     HNOMDT        OREQ      'CD'
184600200528     C     HNOMDT        OREQ      'FT'                                                       CDL006
184700200528     C     CDL006        ANDEQ     'Y'                                                        CDL006
184800200528     C     HNOMDT        OREQ      'DT'                                                       CDL006
184900200528     C     CDL006        ANDEQ     'Y'                                                        CDL006
185000200528     C     HNOMDT        OREQ      'LT'                                                       CDL006
185100200528     C     CDL006        ANDEQ     'Y'                                                        CDL006
185200200528     C                   MOVEL     'D'           W#LOD             1
185300200528     C                   ELSE
185400200528     C                   MOVEL     'L'           W#LOD
185500200528     C                   END
185600200528      *
185700200528     C                   MOVEL     'N'           ##PPAY
185800200528     C                   MOVEL     'N'           ##PREC
185900200528      *
186000200528      ** Protect both Pay and Receive instructions if Deal Amendment type
186100200528      ** is 'Rate Change' or 'Capitalise Interest'
186200200528      *
186300200528     C     DDMTYP        IFEQ      'SC'
186400200528     C     DDMTYP        OREQ      'CI'
186500200528     C                   MOVEL     'Y'           ##PPAY
186600200528     C                   MOVEL     'Y'           ##PREC
186700200528     C                   END
186800200528      *
186900200528      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
187000200528      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
187100200528      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
187200200528      **
187300200528     C     DDMTYP        IFEQ      'PD'
187400200528     C     W#LOD         ANDEQ     'D'
187500200528     C     DDMTYP        OREQ      'PI'
187600200528     C     W#LOD         ANDEQ     'L'
187700200528     C     DDMTYP        OREQ      'SI'
187800200528     C     W#LOD         ANDEQ     'D'
187900200528      *
188000200528     C                   MOVEL     'Y'           ##PREC
188100200528      *
188200200528      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
188300200528      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
188400200528      ** OR SETTLE INTEREST OF DEPOSIT PLACED
188500200528      **
188600200528     C                   ELSE
188700200528      *
188800200528     C     DDMTYP        IFEQ      'PD'
188900200528     C     W#LOD         ANDEQ     'L'
189000200528     C     DDMTYP        OREQ      'PI'
189100200528     C     W#LOD         ANDEQ     'D'
189200200528     C     DDMTYP        OREQ      'SI'
189300200528     C     W#LOD         ANDEQ     'L'
189400200528      *
189500200528     C                   MOVEL     'Y'           ##PPAY
189600200528      *
189700200528     C                   END
189800200528     C                   END
189900200528      *                                                                                      BUG3045
190000200528      ** For deal amendment EM protect pay/receive instructions according                    BUG3045
190100200528      ** to whether a penalty is being paid and the pay/receive flag                         BUG3045
190200200528     C     DDMTYP        IFEQ      'EM'                                                      BUG3045
190300200528      *                                                                                      BUG3045
190400200528     C                   SELECT                                                              BUG3045
190500200528     C     DDAMNP        WHENNE    *BLANKS                                                   BUG3045
190600200528     C     DDPENP        ANDEQ     'P'                                                       BUG3045
190700200528     C                   MOVE      'Y'           ##PREC                                      BUG3045
190800200528     C     DDAMNP        WHENNE    *BLANKS                                                   BUG3045
190900200528     C     DDPENP        ANDEQ     'R'                                                       BUG3045
191000200528     C                   MOVE      'Y'           ##PPAY                                      BUG3045
191100200528     C                   OTHER                                                               BUG3045
191200200528     C                   MOVE      'Y'           ##PREC                                      BUG3045
191300200528     C                   MOVE      'Y'           ##PPAY                                      BUG3045
191400200528     C                   ENDSL                                                               BUG3045
191500200528      *                                                                                      BUG3045
191600200528     C                   ENDIF                                                               BUG3045
191700200528      *                                                                                      BUG3045
191800200528      ** Save penalty pay/receive indicator flag                                             BUG3045
191900200528     C                   MOVE      DDPENP        ##PENP            1                         BUG3045
192000200528      *                                                                                      BUG3045
192100200528      ** For deal amendment BC protect pay/receive instructions        ng                    BUG3045
192200200528     C     DDMTYP        IFEQ      'BC'                                                      BUG3045
192300200528     C                   MOVE      'Y'           ##PREC                                      BUG3045
192400200528     C                   MOVE      'Y'           ##PPAY                                      BUG3045
192500200528     C                   ENDIF                                                               BUG3045
192600200528      **                                                                                     BUG3045
192700200528      *
192800200528      * SET UP PAYMENT INSTRUCTIONS FROM DEAM
192900200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
193000200528      *
193100200528     C**********         MOVEL     IGPAY         FLPAY                                        CGL029
193200200528     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(IGPAY:1:2)                      CGL029
193300200528     C                   EVAL      %SUBST(FLPAY:3:18) = IGPONS                                CGL029
193400200528     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(IGPAY:15:545)                CGL029
193500200528     C                   MOVEL     IGOSBR        FLPOBR
193600200528     C                   MOVEL     IGCVMR        FLCVMR
193700200528     C                   MOVEL     IGSTCY        FLPSCY
193800200528     C                   MOVEL     IGIC72        FLIC72
193900200528      *
194000200528      * SET UP RECEIVE INSTRUCTIONS FROM DEAM
194100200528      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
194200200528      *
194300200528     C**********         MOVEL     IGREC         FLREC                                        CGL029
194400200528     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(IGREC:1:2)                      CGL029
194500200528     C                   EVAL      %SUBST(FLREC:3:18) = IGRONS                                CGL029
194600200528     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(IGREC:15:55)                  CGL029
194700200528     C                   MOVEL     IGOSBR        FLROBR
194800200528     C                   MOVEL     IGSTCY        FLRSCY
194900200528      *
195000200528      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
195100200528      * AND PAYMENT/RECEIPT INSTRUCTIONS ARE NOT PROTECTED
195200200528      *
195300200528     C     FLPSTM        IFEQ      *ZERO
195400200528     C     ##PPAY        ANDNE     'Y'
195500200528     C     DDACTN        ANDNE     'E'                                          182558
195600200528     C*****FLRSTM        OREQ      *ZERO                                        136433
195700200528     C*****FLRSTM        ANDEQ     *ZERO                                  136433182558
195800200528     C     FLRSTM        OREQ      *ZERO                                        182558
195900200528     C     ##PREC        ANDNE     'Y'
196000200528     C     DDACTN        ANDNE     'E'                                          136433
196100200528                                                                                              CSD095
196200200528      ** Retrieve the subtype and branch associated with the deal                             CSD095
196300200528                                                                                              CSD095
196400200528     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
196500200528     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
196600200528                                                                                              CSD095
196700200528     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
196800200528     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
196900200528     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
197000200528     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
197100200528     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
197200200528     C                   ENDIF                                                                CSD095
197300200528      *
197400200528     C                   CALLB     'ZASETINDFT'
197500200528      *
197600200528      * INPUTS
197700200528      *
197800200528      * Calling program
197900200528     C                   PARM      'DEAM'        ##CALP            4
198000200528      *
198100200528      * Payment currency
198200200528     C                   PARM      DDCCY         ##PCCY            3
198300200528      *
198400200528      * Receive currency
198500200528     C                   PARM      DDCCY         ##RCCY            3
198600200528     C/COPY WNCPYSRC,MMDEAMSC31
198700200528      *
198800200528      * Customer shortname
198900200528     C                   PARM      DDCSNM        ##CSNM           10
199000200528      *
199100200528      * Transaction Type
199200200528     C                   PARM      DDMTYP        ##TTYP            2
199300200528      *
199400200528      * Federal Funds Ind.
199500200528     C                   PARM                    ##FFND            1
199600200528      *
199700200528      ** Version of ISDA Rules govern
199800200528     C                   PARM                    BQISDA            4
199900200528      *
200000200528      ** Type of ISDA agreement
200100200528     C                   PARM                    BQAGTY            6
200200200528      *
200300200528      ** Date of ISDA Agreement
200400200528     C                   PARM                    BQAGDT            6
200500200528      *
200600200528      ** Version of ISDA Agreement
200700200528     C                   PARM                    BQAGVV            2
200800200528      ** Version of ISDA Agreement century                                                    176883
200900200528     C                   PARM                    Blank2            2                          176883
201000200528      ** Deal Subtype                                                                         CSD095
201100200528     C                   PARM                    DDSTYP            2                          CSD095
201200200528      ** Branch                                                                               CSD095
201300200528     C                   PARM                    DDBRCA            3                          CSD095
201400200528      *
201500200528      ** OUTPUTS
201600200528      *
201700200528      * Payment instructions
201800200528     C                   PARM                    ##PAYF
201900200528      *
202000200528      * Receive instructions
202100200528     C                   PARM                    ##RECF
202200200528      *
202300200528      * FRA/IRS instructions
202400200528     C                   PARM                    ##FRIF
202500200528      *
202600200528     C                   END
202700200528      *
202800200528      * Clear payment instructions if protected
202900200528      *
203000200528     C     ##PPAY        IFEQ      'Y'
203100200528     C                   CLEAR                   ##PAYF
203200200528     C                   Z-ADD     *ZERO         FLPSTM
203300200528     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
203400200528     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
203500200528     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
203600200528     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
203700200528     C                   END
203800200528      *
203900200528      * Clear receipt instructions if protected
204000200528      *
204100200528     C     ##PREC        IFEQ      'Y'
204200200528     C                   CLEAR                   ##RECF
204300200528     C                   Z-ADD     *ZERO         FLRSTM
204400200528     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
204500200528     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
204600200528     C                   EVAL      FLROBN = *BLANKS                                           CSD027
204700200528     C                   EVAL      FLROCN = *BLANKS                                           CSD027
204800200528     C                   END
204900200528      *
205000200528      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
205100200528      *
205200200528     C                   CALLB     'ZASETINCVT'
205300200528      *
205400200528      ** INPUTS
205500200528      *
205600200528      ** File Payment Settlement Instruction
205700200528     C                   PARM                    ##PAYF
205800200528      *
205900200528      ** File Receipt Settlement Instruction
206000200528     C                   PARM                    ##RECF
206100200528      *
206200200528      ** File FRA/IRS Settlement Instruction
206300200528     C                   PARM      *BLANK        ##FRIF
206400200528      *
206500200528      ** OUTPUTS
206600200528      ** Screen Payment Settlement Instruction
206700200528     C                   PARM      *BLANK        ##PAYS
206800200528      *
206900200528      ** Screen Receipt Settlement Instruction
207000200528     C                   PARM      *BLANK        ##RECS
207100200528      *
207200200528      ** Screen FRA/IRS Settlement Instruction
207300200528     C                   PARM      *BLANK        ##FRIS
207400200528     C                   PARM      DDCCY         InRCCY                                      CSF011A
207500200528     C                   PARM      DDCCY         InPCCY                                      CSF011A
207600200528      *
207700200528     C                   ENDSR
207800200528      *****************************************************************
207900200528      /EJECT
208000200528      *****************************************************************
208100200528      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
208200200528      *****************************************************************
208300200528     C     CANC@S        BEGSR
208400200528      *
208500200528     C/COPY WNCPYSRC,MMDEAMSC03
208600200528      * Return to Main Details Screen
208700200528      *
208800200528     C                   MOVEL     'M'           @SCRN
208900200528     C/COPY WNCPYSRC,MMDEAMSC01
209000200528      *
209100200528     C                   ENDSR
209200200528      *****************************************************************
209300200528      /EJECT
209400200528      *****************************************************************
209500200528      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
209600200528      *****************************************************************
209700200528     C     EXIT@S        BEGSR
209800200528      *
209900200528      * IF SETTLEMENT DETAILS INVALID
210000200528      *
210100200528     C     ##RTCD        IFEQ      '*ERRORS'
210200200528      *
210300200528      * RETURN TO MAIN DETAILS SCREEN
210400200528      *
210500200528     C                   MOVEL     'M'           @SCRN
210600200528     C                   ELSE
210700200528      *
210800200528      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
210900200528      *
211000200528     C                   MOVEL     'C'           @SCRN
211100200528      *
211200200528      * UPDATE VALID DEAM: PAYMENT SETTLEMENT INSTRUCTIONS
211300200528      *
211400200528     C**********         MOVEL     FLPAY         IGPAY                                        CGL029
211500200528     C                   EVAL      %SUBST(IGPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
211600200528     C                   EVAL      IGPONS = %SUBST(FLPAY:3:18)                                CGL029
211700200528     C                   EVAL      %SUBST(IGPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
211800200528     C     FLPOBR        IFNE      *BLANKS                                      137552
211900200528     C                   MOVEL     FLPOBR        IGOSBR
212000200528     C                   END                                                    137552
212100200528     C                   MOVEL     FLCVMR        IGCVMR
212200200528      ************                                                                     179510 200400
212300200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
212400200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
212500200528      ************                                                                     179510 200400
212600200528     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
212700200528     C************       MOVE      @@MOPI        IGMOPI                                179510 200400
212800200528     C************       ENDIF                                                         179510 200400
212900200528      *
213000200528      * UPDATE VALID DEAM: RECEIPT SETTLEMENT INSTRUCTIONS
213100200528      *
213200200528     C**********         MOVEL     FLREC         IGREC                                        CGL029
213300200528     C                   EVAL      %SUBST(IGREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
213400200528     C                   EVAL      IGRONS = %SUBST(FLREC:3:18)                                CGL029
213500200528     C                   EVAL      %SUBST(IGREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
213600200528     C     FLROBR        IFNE      *BLANKS                                      137552
213700200528     C                   MOVEL     FLROBR        IGOSBR
213800200528     C                   END                                                    137552
213900200528      *
214000200528      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
214100200528      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
214200200528      ************                                                                     179510 200400
214300200528     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
214400200528     C************       MOVE      @@MORI        IGMORI                                179510 200400
214500200528     C************       ENDIF                                                         179510 200400
214600200528      ************                                                                     179510 200400
214700200528      * UPDATE VALID DEAM: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
214800200528     C     FLPSCY        IFNE      *BLANKS                                                    196808
214900200528      *
215000200528     C                   MOVEL     FLPSCY        IGSTCY
215100200528     C                   ELSE                                                                 196808
215200200528     C                   MOVEL     FLRSCY        IGSTCY                                       196808
215300200528     C                   ENDIF                                                                196808
215400200528     C                   MOVEL     FLIC72        IGIC72
215500200528     C/COPY WNCPYSRC,MMDEAMSC02
215600200528     C                   END
215700200528      *
215800200528     C                   ENDSR
215900200528      *****************************************************************
216000200528      /EJECT
216100200528      *****************************************************************
216200200528      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
216300200528      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
216400200528      *****************************************************************
216500200528     C     SCRN@C        BEGSR
216600200528      *
216700200528      * Prior to validation, initialize error indicators as 'OK'
216800200528      *
216900200528     C                   MOVE      *ALL'Y'       MMEDEM
217000200528      *
217100200528      * Validate deam details
217200200528      *
217300200528     C                   CALLB     'MMDEAMVAL'
217400200528     C                   PARM                    RespMode
217500200528     C                   PARM                    NwDlScnFmt
217600200528     C                   PARM                    InfData                        CAP051
217700200528     C                   PARM                    ExtData                        CAP004
217800200528     C                   PARM                    MMEDEM
217900200528     C                   PARM                    FldNameArr
218000200528     C                   PARM                    MsgIdArr
218100200528     C                   PARM                    MsgDtaArr
218200200528     C                   PARM      *ZERO         Idx               3 0
218300200528     C                   PARM                    WFldNamArr
218400200528     C                   PARM                    WMsgIdArr
218500200528     C                   PARM                    WMsgDtaArr
218600200528     C                   PARM      *ZERO         WIdx              3 0
218700200528     C                   PARM                    NwDlFilFmt
218800200528      *
218900200528      * If transaction is valid output message 'Press enter to accept'
219000200528      *
219100200528     C     Idx           IFEQ      *ZERO
219200200528     C                   MOVEL     '*ANY'        FldNameArr(1)
219300200528     C                   MOVEL     'MMM1030'     MsgIdArr(1)
219400200528     C                   END
219500200528                                                                                              CDL006
219600200528      ** Retrieve warning message, if needed.                                                 CDL006
219700200528                                                                                              CDL006
219800200528     C                   If        DDACTN = 'D' or DDACTN = 'I'                               CDL006
219900200528                                                                                              CDL006
220000200528     C                   Move      DDDLNO        DealNo                                       CDL006
220100200528                                                                                              CDL006
220200200528     C                   CallB     'MMDEAMWRN'                                                CDL006
220300200528     C                   Parm                    DealNo                                       CDL006
220400200528     C                   Parm                    DDACTN                                       CDL006
220500200528     C                   Parm                    DDMTYP                                       CDL006
220600200528     C                   Parm                    WFldNamArr                                   CDL006
220700200528     C                   Parm                    WMsgIdArr                                    CDL006
220800200528     C                   Parm                    WMsgDtaArr                                   CDL006
220900200528     C                   Parm                    WIdx                                         CDL006
221000200528                                                                                              CDL006
221100200528     C                   Endif                                                                CDL006
221200200528                                                                                              CDL006
221300200528      *
221400200528      * WRITE/READ DISPLAY SCREEN
221500200528      *
221600200528     C                   CALLB     'MMDEAMDSP'
221700200528      *
221800200528      * INPUT PARAMETERS
221900200528      *
222000200528      * RETURN CODE
222100200528     C                   PARM      *BLANK        RetCodeOut
222200200528      *
222300200528      * DEAM (IN SCREEN FORMAT)
222400200528     C                   PARM                    NwDlScnFmt
222500200528      *
222600200528      * DEAM STATUS
222700200528     C                   PARM                    DDSTS            24
222800200528      *
222900200528      * FIELDS IN ERROR
223000200528     C                   PARM                    MMEDEM
223100200528      *
223200200528      * ERRORS
223300200528     C                   PARM                    FldNameArr
223400200528     C                   PARM                    MsgIdArr
223500200528     C                   PARM                    MsgDtaArr
223600200528      *
223700200528      * WARNINGS
223800200528     C                   PARM                    WFldNamArr
223900200528     C                   PARM                    WMsgIdArr
224000200528     C                   PARM                    WMsgDtaArr
224100200528      *
224200200528      * ENABLED KEY & DETAIL FIELDS
224300200528      *
224400200528     C                   PARM      'N'           @EKYFD
224500200528     C                   PARM      'N'           @EDTFD
224600200528      *
224700200528      * ENABLED FUNCTION KEYS
224800200528     C                   PARM      'N'           @EINKG
224900200528     C                   PARM      'N'           @EINKH
225000200528     C                   PARM      'N'           @EINKJ
225100200528     C                   PARM      'N'           @EINKN
225200200528     C                   PARM      'N'           @EINKP
225300200528      *
225400200528      * SUCCESFUL INSERT DEAM
225500200528     C                   PARM                    @LSQN             3
225600200528      *
225700200528      * OUTPUT PARAMETERS
225800200528      *
225900200528      * FUNCTION KEYS
226000200528     C                   PARM      '0'           @INKC             1
226100200528     C                   PARM      '0'           @INKG             1
226200200528     C                   PARM      '0'           @INKH             1
226300200528     C                   PARM      '0'           @INKJ             1
226400200528     C                   PARM      '0'           @INKL             1
226500200528     C                   PARM      '0'           @INKN             1
226600200528     C                   PARM      '0'           @INKP             1
226700200528     C                   PARM      'N'           WriteOnly         1
226800200528     C/COPY WNCPYSRC,MMDEAMSC26
226900200528      *
227000200528      * RESET ERRORS
227100200528      *
227200200528     C                   MOVE      *ALL'Y'       MMEDEM
227300200528     C                   MOVEL     *BLANK        FldNameArr
227400200528     C                   MOVEL     *BLANK        MsgIdArr
227500200528     C                   MOVEL     *BLANK        MsgDtaArr
227600200528     C                   MOVEL     *BLANK        WFldNamArr
227700200528     C                   MOVEL     *BLANK        WMsgIdArr
227800200528     C                   MOVEL     *BLANK        WMsgDtaArr
227900200528      *
228000200528      * CK/3 - END PROGRAM
228100200528      *
228200200528     C     @INKC         CASEQ     '1'           ENDP
228300200528      *
228400200528      * CK/12 - CANCEL ON CONFIRMATION SCREEN
228500200528      *
228600200528     C     @INKL         CASEQ     '1'           CANC@C
228700200528      *
228800200528      * EXIT CONFIRMATION SCREEN
228900200528      *
229000200528     C                   CAS                     EXIT@C
229100200528     C                   END
229200200528      *
229300200528     C                   ENDSR
229400200528      *****************************************************************
229500200528      /EJECT
229600200528      *****************************************************************
229700200528      * CANC@C - CANCEL ON CONFIRMATION SCREEN
229800200528      *****************************************************************
229900200528     C     CANC@C        BEGSR
230000200528      *
230100200528      * RETURN TO MAIN DETAILS SCREEN
230200200528      *
230300200528     C                   MOVEL     'M'           @SCRN
230400200528      *
230500200528      * Initialize field status on main details screen
230600200528      *
230700200528     C                   EXSR      IFDS@M
230800200528      *
230900200528      * Set function key status on main details screen
231000200528      * (according to action code)
231100200528      *
231200200528     C                   EXSR      SFKS@M
231300200528      *
231400200528     C                   ENDSR
231500200528      *****************************************************************
231600200528      /EJECT
231700200528      *****************************************************************
231800200528      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
231900200528      *****************************************************************
232000200528     C     EXIT@C        BEGSR
232100200528      *
232200200528      * IF NO ERRORS IN VALIDATION
232300200528      *
232400200528     C     Idx           IFEQ      *ZERO
232500200528      *
232600200528      * CONTINUE WITH UPDATES
232700200528      *
232800200528     C                   MOVEL     'U'           @SCRN
232900200528      *
233000200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
233100200528      *
233200200528     C                   ELSE
233300200528     C                   MOVEL     'M'           @SCRN
233400200528      *
233500200528      * Initialize field status on main details screen
233600200528      *
233700200528     C                   EXSR      IFDS@M
233800200528      *
233900200528      * Set function key status on main details screen
234000200528      * (according to action code)
234100200528      *
234200200528     C                   EXSR      SFKS@M
234300200528     C                   END
234400200528      *
234500200528     C                   ENDSR
234600200528      *****************************************************************
234700200528      /EJECT
234800200528      *****************************************************************
234900200528      *                                                               *
235000200528      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
235100200528      *              for Inserts.                                     *
235200200528      *                                                               *
235300200528      *****************************************************************
235400200528     C     SETUPDASEQ    BEGSR
235500200528     C*
235600200528     C**  Load deal number into numeric field passed to MM0085
235700200528     C                   MOVE      DDDLNO        DealNo            6 0
235800200528     C*
235900200528     C** Format Value Date
236000200528     C     DDVDAT        IFNE      *BLANKS                                      B1
236100200528     C*
236200200528     C** Load value date to numeric keyfield,in YYYYMMDD format
236300200528     C                   MOVE      DDVDAT        @VDAT
236400200528
236500200528     C                   Z-ADD     0             @PDAT                          **2
236600200528     C                   MOVE      @DSPY         @PYEAR                         **2
236700200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
236800200528     C                   MOVE      @DSPD         @PDDD                          **2
236900200528     C                   ELSE                                                                  BHF18
237000200528     C                   MOVE      @DSPD         @PDMM                                         BHF18
237100200528     C                   END                                                                   BHF18
237200200528     C     BJDFIN        IFEQ      'D'                                                         BHF18
237300200528     C                   MOVE      @DSPM         @PDMM                          **2
237400200528     C                   ELSE                                                                  BHF18
237500200528     C                   MOVE      @DSPM         @PDDD                                         BHF18
237600200528     C                   END                                                                   BHF18
237700200528     C*
237800200528     C** Century
237900200528     C     @PYEAR        IFGE      72                                           B**3
238000200528     C     @PDYY         ADD       1900          @PDYY                          ***3
238100200528     C                   ELSE                                                   ***3
238200200528     C     @PDYY         ADD       2000          @PDYY                          ***3
238300200528     C                   END                                                    E**3
238400200528     C                   ELSE                                                   X1
238500200528     C                   Z-ADD     0             @PDAT                          *1
238600200528     C                   END                                                    E1
238700200528     C                   Z-ADD     @PDAT         ValueDate         8 0
238800200528
238900200528      ** Generate DEAM Sequence Number
239000200528     C                   CALLB     'MM0085'
239100200528     C                   PARM                    Term              1
239200200528     C                   PARM                    DealNo
239300200528     C                   PARM                    ValueDate
239400200528     C                   PARM                    SeqNoPack         3 0
239500200528      *
239600200528      ** If error returned from MM0085
239700200528     C     Term          IFNE      *BLANK
239800200528     C                   EXSR      *PSSR
239900200528     C                   ELSE
240000200528     C                   Z-ADD     SeqNoPack     IGDS38
240100200528     C                   MOVEL     IGDS38        @LSQN
240200200528     C                   ENDIF
240300200528
240400200528     C                   ENDSR
240500200528      *****************************************************************
240600200528      /EJECT
240700200528      *****************************************************************
240800200528      * UPDATS - UPDATES
240900200528      *****************************************************************
241000200528     C     UPDATS        BEGSR
241100200528      *
241200200528      * For inserts generate Deal Amendment Sequence Number
241300200528      *
241400200528     C                   IF        DDACTN = 'I'
241500200528     C                   EXSR      SETUPDASEQ
241600200528     C                   ENDIF
241700200528      *
241800200528      * UPDATE VALID DEAM: DEAL NUMBER
241900200528      *
242000200528     C                   MOVEL     DDDLNO        IGDA38
242100200528      *
242200200528      * UPDATE VALID DEAM: LAST ACTION CODE
242300200528      *
242400200528     C                   MOVEL     DDACTN        IGLACT
242500200528     C/COPY WNCPYSRC,MMDEAMSC27
242600200528      *
242700200528      * MONEY MARKET UPDATES
242800200528      *
242900200528     C                   CALLB     'MMDEAMUPM'
243000200528     C                   PARM      *BLANK        @RTCD             7
243100200528     C                   PARM                    NwDlFilFmt
243200200528      *
243300200528      * DEAMS UPDATES
243400200528      *
243500200528     C     @RTCD         IFEQ      *BLANK
243600200528     C                   CALLB     'MMDEAMUPD'
243700200528     C                   PARM                    @RTCD
243800200528     C                   PARM                    NwDlFilFmt
243900200528     C                   END
244000200528      *
244100200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
244200200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
244300200528      *
244400200528     C     @RTCD         IFNE      *BLANK
244500200528     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
244600200528     C                   If        (CSC022 = 'N')                                             CSC022
244700200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
244800200528     C                   ROLBK
244900200528     C                   EndIf                                                                CSC022
245000200528     C                   EXSR      *PSSR
245100200528     C                   ELSE
245200200528     C                   If        (CSC022 = 'N')                                             CSC022
245300200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
245400200528     C                   COMMIT
245500200528     C                   EndIf                                                                CSC022
245600200528     C                   END
245700200528      *
245800200528     C** If update not done due to record being updated by another              CAP006
245900200528     C** workstation send message to screen.                                    CAP006
246000200528     C                                                                          CAP006
246100200528     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
246200200528     C                                                                          CAP006
246300200528     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
246400200528     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
246500200528     C                                                                          CAP006
246600200528     C                   END                                                    CAP006
246700200528     C                                                                          CAP006
246800200528      * BLANK THE MAIN DETAILS SCREEN
246900200528      *
247000200528     C                   MOVEL     *BLANK        NwDlScnFmt
247100200528     C                   MOVEL     *BLANK        DDSTS
247200200528      *
247300200528      * Initialize field and function key status on main details screen
247400200528      *
247500200528     C                   EXSR      IFDS@M
247600200528     C                   EXSR      IFKS@M
247700200528      *
247800200528      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
247900200528      *
248000200528     C     @RDNB         IFEQ      'Y'
248100200528     C                   MOVEL     'R'           @SCRN
248200200528     C/COPY WNCPYSRC,MMDEAMSC28
248300200528     C                   ELSE
248400200528      *
248500200528      * ELSE, RETURN TO MAIN DETAILS SCREEN
248600200528      *
248700200528     C                   MOVEL     'M'           @SCRN
248800200528     C                   END
248900200528      *
249000200528     C                   ENDSR
249100200528      *****************************************************************
249200200528      /EJECT
249300200528      *****************************************************************
249400200528      * ENDP - END PROGRAM
249500200528      *****************************************************************
249600200528     C     ENDP          BEGSR
249700200528      *
249800200528      * Issue rollback to clear any possible updates in window function
249900200528      *
250000200528     C     BGWDPR        IFEQ      'Y'
250100200528     C                   If        (CSC022 = 'N')                                             CSC022
250200200528     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
250300200528     C                   ROLBK
250400200528     C                   Else                                                                 CSC022
250500200528     C                   SetOn                                        U7U8                    CSC022
250600200528     C                   EndIf                                                                CSC022
250700200528     C                   END
250800200528      *
250900200528     C                   MOVEL     'T'           @SCRN
251000200528     C                   ENDSR
251100200528      *****************************************************************
251200200528      /EJECT
251300200528      *****************************************************************
251400200528      * *INZSR - INITIAL PROCESSING
251500200528      *****************************************************************
251600200528     C     *INZSR        BEGSR
251700200528      *
251800200528      ** Initialize program name
251900200528      *
252000200528     C                   MOVEL     'MMDEAMSIN'   DBPGM
252100200528      *
252200200528      ** ACCESS BANK DETAILS
252300200528      *
252400200528     C                   CALL      'AOBANKR0'
252500200528     C                   PARM      *BLANKS       @RTCD             7
252600200528     C                   PARM      '*FIRST '     @OPTN             7
252700200528     C     SDBANK        PARM      SDBANK        DSFDY
252800200528      *
252900200528      * DATABASE ERROR
253000200528      *
253100200528     C     @RTCD         IFNE      *BLANKS
253200200528     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
253300200528     C                   MOVEL     '901'         DBASE                          * DBERR 901*
253400200528     C                   MOVEL     @OPTN         DBKEY                          ************
253500200528     C                   EXSR      *PSSR
253600200528     C                   END
253700200528      *
253800200528      ** Access Module Details
253900200528      *
254000200528     C                   CALL      'AOMMODR0'
254100200528     C                   PARM      *BLANKS       @RTCD
254200200528     C                   PARM      '*FIRST '     @OPTN
254300200528     C     SDMMOD        PARM      SDMMOD        DSFDY
254400200528      *
254500200528      * DATABASE ERROR
254600200528      *
254700200528     C     @RTCD         IFNE      *BLANKS
254800200528     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
254900200528     C                   MOVEL     '902'         DBASE                          * DBERR 901*
255000200528     C                   MOVEL     @OPTN         DBKEY                          ************
255100200528     C                   EXSR      *PSSR
255200200528     C                   END
255300200528      *
255400200528      * Start on Main Details Screen
255500200528      *
255600200528     C                   MOVEL     'M'           @SCRN             1
255700200528      *
255800200528      * Initialize field and function key status on main details screen
255900200528      *
256000200528     C                   EXSR      IFDS@M
256100200528     C                   EXSR      IFKS@M
256200200528      *
256300200528                                                                                              CDL006
256400200528      ** Access Switchable Features file to check if Dealing Fiducia                          CDL006
256500200528      ** ry is installed.                                                                     CDL006
256600200528                                                                                              CDL006
256700200528     C                   CallB     'MMFIDINIT'                                                CDL006
256800200528     C                   Parm      *Blanks       RetCode           7                          CDL006
256900200528
257000200528      *  Hook to enable non-core initial processing to be included
257100200528      /COPY WNCPYSRC,MMDEAMS010
257200200528      ** Access SAR details file to determine if Commitment Control                           CSC022
257300200528      ** Changes is switched on.                                                              CSC022
257400200528     C                   CallB     'AOSARDR0'                                                 CSC022
257500200528     C                   Parm      *BLANKS       @RTCD                                        CSC022
257600200528     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
257700200528     C                   Parm      'CSC022'      @SARD                                        CSC022
257800200528     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
257900200528                                                                                              CSC022
258000200528     C                   If        @RTCD = *BLANKS                                            CSC022
258100200528      *                                                                                       CSC022
258200200528     C                   Eval      CSC022 = 'Y'                                               CSC022
258300200528     C                   In        SCCMTJOB                                                   CSC022
258400200528     C                   If        ComitNum > 0                                               CSC022
258500200528      ** Check if Current Job exists in the Commitment Job Names                              CSC022
258600200528      ** Data Area.                                                                           CSC022
258700200528     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
258800200528     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
258900200528     C                   If        *IN20                                                      CSC022
259000200528     C                   Eval      wCommitSkip = 'Y'                                          CSC022
259100200528     C                   EndIf                                                                CSC022
259200200528     C                   EndIf                                                                CSC022
259300200528      *                                                                                       CSC022
259400200528     C                   Else                                                                 CSC022
259500200528      ** Database error                                                                       CSC022
259600200528     C                   If        @RTCD <> '*NRF'                                            CSC022
259700200528     C     *LOCK         In        LDA                                                        CSC022
259800200528     C                   Eval      DBKey = 'CSC022'                                           CSC022
259900200528     C                   Eval      DBPgm = 'MMDEAMSIN'                                        CSC022
260000200528     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
260100200528     C                   Eval      DBase = 905                                                CSC022
260200200528     C                   Out       LDA                                                        CSC022
260300200528     C                   ExSr      *PSSR                                                      CSC022
260400200528     C                   EndIf                                                                CSC022
260500200528      *                                                                                       CSC022
260600200528     C                   EndIf                                                                CSC022
260700200528
260800200528     C                   ENDSR
260900200528      *****************************************************************
261000200528      /EJECT
261100200528      *****************************************************************
261200200528      ** Program, module and procedure names for database error processing.
261300200528      ** =================================================================
261400200528      ** The following /COPY sets these values, and also defines LDA as
261500200528      ** an external data area
261600200528      ********************************************************************
261700200528      /COPY ZACPYSRC,PSSR_ILE
261800200528      ********************************************************************
261900200528**  CPY@
262000200528(c) Finastra International Limited 2001
