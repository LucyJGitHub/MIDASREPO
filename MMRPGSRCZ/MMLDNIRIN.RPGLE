     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits rollover input')               *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIRIN - LOANS/DEPOSITS & NAS ISSUED ROLLOVER INPUT       *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for loan and deposit rollovers.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR701789           Date 26Sep16               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2876            Date 28May04               *
      *                 BUG2804            Date 20May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209867             Date 10Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      *                 197711             Date 12Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192829             Date 04May01               *
      *                 190752             Date 09Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 17Feb00               *
      *                 CSE006             Date 15Sep99               *
      *                 CAP051             Date 09Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156950             Date 11Mar99               *
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 13Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating rate CDs issued                            *
      *         - Incomplete parameter list passed to MMLDNIUPM.      *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIO009,MMLDNIWC12,MMLDNIWC16,*
      *                              MMLDNIWC17                       *
      *           Core hooks added:  MMLDNIWC32                       *
      *  BUG2876- Parameter mismatch in MMLDNIDSP caused by CDL016    *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  197711 - Should default settlement instructions from rolled  *
      *           over deal if they exist.                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510                                  *
      *  192829 - The wrong module name passed to WN0010.             *
      *  190752 - Pass parameter 'RODN' down to MMLDNIROP via         *
      *           MMLDNIROB, to indicate which menu option it has     *
      *           been called from.                                   *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CGL011 - Collateral Processing for Midas - new parameter     *
      *           on CALLB to MMLDNIDSP.                              *
      *  CSE006 - Repo Enhancements.                                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  156950 - Deal number positioning and insert message.         *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                               197711
      ** ¦ F-specs                              ¦                               197711
      ** ¦ =======                              ¦                               197711
      ** +--------------------------------------+                               197711
                                                                                197711
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                         197711
     F/COPY WNCPYSRC,MMLDNIWF01
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
      ** External DS for SAR details                                                          CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
 
     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
 
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
      * New Deal in File Format
     D  IKREC                456    524
     D  IKPAY                525   1083
 
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * New Deal in Screen Format
 
     D MMELDNI       E DS                  EXTNAME(MMELDNIPD)
      * Error indicators
 
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D**FLREC***               1     69                                                       CGL029
     D  FLREC                  1     75                                                       CGL029
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D**FLPAY***               1    559                                                       CGL029
     D  FLPAY                  1    565                                                       CGL029
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D**@@RONS**               6     17                                                       CGL029
     D**@@PSCY**              18     20                                                       CGL029
     D**@@PSTM**              21     22  0                                                    CGL029
     D**@@PONS**              23     34                                                       CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
 
     D HKREC           DS                                                       197711
      ** Receive Settlement Instructions from rolled over deal                  197711
     D  @1RSTM                 1      2  0                                      197711
     D**@1RONS**               3     14                                                197711 CGL029
     D**@1RIBN**              15     22                                                197711 CGL029
     D**@1RIBA**              23     57                                                197711 CGL029
     D**@1ROBN**              58     63  0                                             197711 CGL029
     D**@1ROCN**              64     69  0                                             197711 CGL029
     D  @1RONS                 3     20                                                       CGL029
     D  @1RIBN                21     28                                                       CGL029
     D  @1RIBA                29     63                                                       CGL029
     D**@1ROBN**              64     69  0                                             CGL029 CSD027
     D**@1ROCN**              70     75  0                                             CGL029 CSD027
     D  @1ROBN                64     69A                                                      CSD027
     D  @1ROCN                70     75A                                                      CSD027
                                                                                197711
     D HKPAY           DS                                                       197711
      ** Pay Settlement Instructions from rolled over deal                      197711
     D  @1PSTM                 1      2  0                                      197711
     D**@1PONS**               3     14                                                197711 CGL029
     D**@1PIBN**              15     22                                                197711 CGL029
     D**@1PIBA**              23     57                                                197711 CGL029
     D**@1POBN**              58     63  0                                             197711 CGL029
     D**@1POCN**              64     69  0                                             197711 CGL029
     D**@1RCRN**              70     77                                                197711 CGL029
     D**@1RCRA**              78    112                                                197711 CGL029
     D**@1RVNO**             113    120                                                197711 CGL029
     D**@1AWBN**             121    128                                                197711 CGL029
     D**@1AWBA**             129    163                                                197711 CGL029
     D**@1BENN**             164    171                                                197711 CGL029
     D**@1BENA**             172    206                                                197711 CGL029
     D**@1DTP1**             207    241                                                197711 CGL029
     D**@1DTP2**             242    276                                                197711 CGL029
     D**@1DTP3**             277    311                                                197711 CGL029
     D**@1DTP4**             312    346                                                197711 CGL029
     D**@1DCHG**             347    349                                                197711 CGL029
     D**@1BTB1**             350    384                                                197711 CGL029
     D**@1BTB2**             385    419                                                197711 CGL029
     D**@1BTB3**             420    454                                                197711 CGL029
     D**@1BTB4**             455    489                                                197711 CGL029
     D**@1BTB5**             490    524                                                197711 CGL029
     D**@1BTB6**             525    559                                                197711 CGL029
     D  @1PONS                 3     20                                                       CGL029
     D  @1PIBN                21     28                                                       CGL029
     D  @1PIBA                29     63                                                       CGL029
     D**@1POBN**              64     69  0                                             CGL029 CSD027
     D**@1POCN**              70     75  0                                             CGL029 CSD027
     D  @1POBN                64     69A                                                      CSD027
     D  @1POCN                70     75A                                                      CSD027
     D  @1RCRN                76     83                                                       CGL029
     D  @1RCRA                84    118                                                       CGL029
     D  @1RVNO               119    126                                                       CGL029
     D  @1AWBN               127    134                                                       CGL029
     D  @1AWBA               135    169                                                       CGL029
     D  @1BENN               170    177                                                       CGL029
     D  @1BENA               178    212                                                       CGL029
     D  @1DTP1               213    247                                                       CGL029
     D  @1DTP2               248    282                                                       CGL029
     D  @1DTP3               283    317                                                       CGL029
     D  @1DTP4               318    352                                                       CGL029
     D  @1DCHG               353    355                                                       CGL029
     D  @1BTB1               356    390                                                       CGL029
     D  @1BTB2               391    425                                                       CGL029
     D  @1BTB3               426    460                                                       CGL029
     D  @1BTB4               461    495                                                       CGL029
     D  @1BTB5               496    530                                                       CGL029
     D  @1BTB6               531    565                                                       CGL029
                                                                                197711
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
 
     D/COPY WNCPYSRC,MMLDNIWD01
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                CDL007
     D InfData       E DS                  EXTNAME(MMLDIFPD)                    CDL007
     D                                     PREFIX(IF_)                          CDL007
      * MM (LDNI) Extra Data - File (D/B) format                                CDL007
 
     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      * MM (LDNI) Extra Data - File (D/B) format
                                                                                              CDL033
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL033
      ** File - Payment Further Settlement Instructions                                       CDL033
                                                                                              CDL033
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL033
      ** File - Receive Further Settlement Instructions                                       CDL033
 
     D/COPY QWINDSRC,MMLDNISDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CDL006
     D CDL006          S              1A   IMPORT                                             CDL006
 
      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CDL033
     D CDL033          S              1A   INZ('N')                                           CDL033
     D PAction         S              1A                                                      CDL033
     D PConf           S              1A                                                      CDL033
     D PMessage        S              7A                                                      CDL033
     D PRtrnCde7       S              7A                                                      CDL033
     D PRtrnCde10      S             10A                                                      CDL033
     D PDealNo         S              6S 0                                                    CDL033
     D PCurrency       S                   LIKE(DDCCY)                                        CDL033
     D PValDate        S              5  0                                                    CDL033
     D PMatDate        S              5  0                                                    CDL033
     D WErrMsgID       S             10A                                                      CDL033
     D WDLNO           S              6A                                                      CDL033
     D W2DLNO          S              6S 0                                                    CDL033
     D PDateIn         S              6A                                                      CDL033
     D PDayNoOut       S              5P 0                                                    CDL033
     D PErrorFlg       S              1A                                                      CDL033
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIO009
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,MMLDNIO001
 
      * DO SCREEN: BROWSE ROLLOVER DEALS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO002
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO003
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO004
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     @SCRN         ANDEQ     'X'                                                        CDL033
     C                   EXSR      SRSched                                                    CDL033
     C                   ENDIF                                                                CDL033
 
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO005
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO006
 
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO007
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      /COPY WNCPYSRC,MMLDNIO008
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNIO010
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE ROLLOVER DEALS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMLDNIROB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         156950
      * SELECTION DEAL NUMBER                                                   156950
     C                   PARM                    @PTDN             6            156950
      *
      * SELECTION BRANCH
     C                   PARM                    @BRCA             3
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *                                                                         156950
      * SUCCESFUL INSERT DEAL                                                   156950
     C                   PARM                    @SIDN             6            156950
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * ROLLOVER ACTION SELECTED
     C                   PARM                    @RASEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @DLSEL            6
      *
      * DEAL IN SCREEN FORMAT
     C                   PARM                    NwDlScnFmt
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
      *                                                                                       190752
      * Menu Option                                                                           190752
     C                   PARM      'RODN'        @MENU             4                          190752
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'MMLDNIROB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         156950
      * SELECTION DEAL NUMBER                                                   156950
     C                   PARM                    @PTDN             6            156950
      *
      * SELECTION BRANCH
     C                   PARM                    @BRCA             3
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *                                                                         156950
      * SUCCESFUL INSERT DEAL                                                   156950
     C                   PARM                    @SIDN             6            156950
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * ROLLOVER ACTION SELECTED
     C                   PARM      *BLANK        @RASEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @DLSEL            6
      *
      * DEAL IN SCREEN FORMAT
     C                   PARM                    NwDlScnFmt
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
      *                                                                                       190752
      * Menu Option                                                                           190752
     C                   PARM      'RODN'        @MENU                                        190752
      *
      * If CK/3 taken within rollover prompt function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF ROLLOVER READ FROM SUBFILE
      *
     C     @RASEL        IFNE      *BLANK
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO ROLLOVER READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
     C/COPY WNCPYSRC,MMLDNIWC21
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,MMLDNIWC11
     C                   END
     C/COPY WNCPYSRC,MMLDNIWC03
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMLDNIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNIWC23
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'Y'           @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C/COPY WNCPYSRC,MMH00144
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNIRIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C/COPY WNCPYSRC,MMH00145
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNIWC07
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVDEL
      *
      * If action code, or deal number are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
     C/COPY WNCPYSRC,MMH00146
      *
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ACTRJ             1                        AR701789
     C                   PARM                    InfData                        CDL007
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData
     C                   PARM                    MMELDNI
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNIWC24
     C                   PARM      'N'           RepoFlag          1                          CSE006
     C                   PARM      'N'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMLDNIWC12
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C/COPY WNCPYSRC,MMH00154
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
     C                   ENDIF                                                                CDL033
      *
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,MMLDNIWC13
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'MMLDNIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNIWC25
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C/COPY WNCPYSRC,MMH00147
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNIRIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C/COPY WNCPYSRC,MMH00148
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      '0'           @INKT
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNIWC08
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C/COPY WNCPYSRC,MMLDNIWC14
                                                                                              CDL006
     C     CDL006        IFEQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'FL'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'FT'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'LP'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'LT'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'DP'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'DT'                                                       CDL006
                                                                                              CDL006
     C                   CALLB     'CAGTNXTFID'                                               CDL006
     C                   PARM                    DDTYPE                                       CDL006
     C                   PARM                    PDDDLNO           6 0                        CDL006
     C                   MOVE      PDDDLNO       I#DDDLNO                                     CDL006
                                                                                              CDL006
     C                   ELSE                                                                 CDL006
                                                                                              CDL006
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDDLNO          6
     C                   PARM      *ZERO         IKDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     DDDLNO        DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   END
      *
     C/COPY WNCPYSRC,MMLDNISMV1
      *
     C                   CALL      'WN0010'
     C**********         PARM      'MMLDNISIN'   #PGM             10                          192829
     C                   PARM      'MMLDNIRIN'   #PGM             10                          192829
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C/COPY WNCPYSRC,MMLDNIWC15
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR                                       196380
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
     C/COPY WNCPYSRC,MMLDNIWC26
      *                                                                                     AR701789
     C                   PARM                    ACTRJ                                      AR701789
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMLDNIWC32
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
     C/COPY WNCPYSRC,MMLDNIWC04
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
     C/COPY WNCPYSRC,MMH00149
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDCCY         ORNE      ##PCCY
     C     DDCUST        ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
     C/COPY WNCPYSRC,MMLDNIWC06
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM      DDACTN        ##ACTN            1
      *
      * Deal number
     C                   PARM      DDDLNO        ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      * Booking branch
     C                   PARM      DDBRCA        ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      * DETERMINE IF LOAN OR DEPOSIT
      *
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C                   MOVEL     'L'           ##LOD             1
     C                   ELSE
     C                   MOVEL     'D'           ##LOD
     C                   END
      *
      * PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C                   Z-ADD     IKDVSD        ##DATP
     C                   ELSE
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATP
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATP
     C                   END
     C                   END
      *
      * RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATR
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATR
     C                   END
     C                   ELSE
     C                   Z-ADD     IKDVSD        ##DATR
     C                   END
      *
      * Convert Transaction Date to a Midas Day Number
      *
     C                   Z-ADD     IKDTYY        @@YY
     C                   Z-ADD     IKDTMM        @@MM
     C                   Z-ADD     IKDTDD        @@DD
     C     DateIn        IFEQ      0
     C                   Z-ADD     BJRDNB        TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C                   MOVE      ZZMDNO        TransDate         5 0
     C                   END
      *
      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
      *
     C     ##DATP        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PPAY
     C                   END
     C     ##DATR        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   END
      *                                                                         197711
      * Access rolled over deal to pick up Settlement Instructions              197711
      *                                                                         197711
     C                   MOVEL     @DLSEL        DLKEY             6 0          197711
     C     DLKEY         CHAIN     MMDEALLL                           99        197711
     C     *IN99         IFEQ      '0'                                          197711
     C                   MOVEL     HKPSTM        @1PSTM                         197711
     C                   MOVEL     HKPONS        @1PONS                         197711
     C                   MOVEL     HKPIBN        @1PIBN                         197711
     C                   MOVEL     HKPIBA        @1PIBA                         197711
     C                   MOVEL     HKPOBN        @1POBN                         197711
     C                   MOVEL     HKPOCN        @1POCN                         197711
     C                   MOVEL     HKRCRN        @1RCRN                         197711
     C                   MOVEL     HKRCRA        @1RCRA                         197711
     C                   MOVEL     HKRVNO        @1RVNO                         197711
     C                   MOVEL     HKAWBN        @1AWBN                         197711
     C                   MOVEL     HKAWBA        @1AWBA                         197711
     C                   MOVEL     HKBENN        @1BENN                         197711
     C                   MOVEL     HKBENA        @1BENA                         197711
     C                   MOVEL     HKDTP1        @1DTP1                         197711
     C                   MOVEL     HKDTP2        @1DTP2                         197711
     C                   MOVEL     HKDTP3        @1DTP3                         197711
     C                   MOVEL     HKDTP4        @1DTP4                         197711
     C                   MOVEL     HKDCHG        @1DCHG                         197711
     C                   MOVEL     HKBTB1        @1BTB1                         197711
     C                   MOVEL     HKBTB2        @1BTB2                         197711
     C                   MOVEL     HKBTB3        @1BTB3                         197711
     C                   MOVEL     HKBTB4        @1BTB4                         197711
     C                   MOVEL     HKBTB5        @1BTB5                         197711
     C                   MOVEL     HKBTB6        @1BTB6                         197711
     C                   MOVEL     HKPAY         FLPAY                          197711
     C                   MOVEL     HKPOBR        FLPOBR                         197711
     C                   MOVEL     HKCVMR        FLCVMR                         197711
     C                   MOVEL     HKSTCY        FLPSCY                         197711
     C                   MOVEL     HKIC72        FLIC72                         197711
     C                   MOVEL     HKRSTM        @1RSTM                         197711
     C                   MOVEL     HKRONS        @1RONS                         197711
     C                   MOVEL     HKRIBN        @1RIBN                         197711
     C                   MOVEL     HKRIBA        @1RIBA                         197711
     C                   MOVEL     HKROBN        @1ROBN                         197711
     C                   MOVEL     HKROCN        @1ROCN                         197711
     C                   MOVEL     HKREC         FLREC                          197711
     C                   MOVEL     HKROBR        FLROBR                         197711
     C                   MOVEL     HKSTCY        FLRSCY                         197711
     C                   ELSE                                                   197711
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     IKPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(IKPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = IKPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(IKPAY:15:545)                CGL029
     C                   MOVEL     IKPOBR        FLPOBR
     C                   MOVEL     IKCVMR        FLCVMR
     C                   MOVEL     IKSTCY        FLPSCY
     C                   MOVEL     IKIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     IKREC         FLREC                                        CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(IKREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = IKRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(IKREC:15:55)                  CGL029
     C                   MOVEL     IKROBR        FLROBR
     C                   MOVEL     IKSTCY        FLRSCY
     C                   ENDIF                                                  197711
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
      *
     C/COPY WNCPYSRC,MMH00026
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
     C/COPY WNCPYSRC,MMLDNIWC22
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century                                                    176883
     C                   PARM                    Blank2            2                          176883
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C/COPY WNCPYSRC,MMH00027
     C                   END
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C/COPY WNCPYSRC,MMLDNIWC01
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
     C/COPY WNCPYSRC,MMLDNIWC02
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLPAY         IKPAY                                        CGL029
     C                   EVAL      %SUBST(IKPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      IKPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(IKPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        IKPOBR
     C                   MOVEL     FLCVMR        IKCVMR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        IKMOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         IKREC                                        CGL029
     C                   EVAL      %SUBST(IKREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      IKRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(IKREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        IKROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        IKMORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        IKSTCY
     C                   MOVEL     FLIC72        IKIC72
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       MMELDNI
      *
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    InfData                        CDL007
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT                         CPB002
     C                   PARM                    ExtData
     C                   PARM                    MMELDNI
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNIWC27
     C                   PARM      'N'           RepoFlag          1            CSE006
     C                   PARM      'Y'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMLDNIWC16
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMLDNIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNIWC28
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C/COPY WNCPYSRC,MMH00150
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNIRIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C/COPY WNCPYSRC,MMH00151
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNIWC09
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
     C/COPY WNCPYSRC,MMH00167
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
 
     C     CDL006        IFEQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'FL'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'FT'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'LP'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'LT'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'DP'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'DT'                                                       CDL006
                                                                                              CDL006
     C                   CALLB     'CAGTNXTFID'                                               CDL006
     C                   PARM                    DDTYPE                                       CDL006
     C                   PARM                    PDDDLNO                                      CDL006
     C                   MOVE      PDDDLNO       I#DDDLNO                                     CDL006
                                                                                              CDL006
     C                   ELSE                                                                 CDL006
                                                                                              CDL006
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDDLNO
     C                   PARM      *ZERO         IKDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     DDDLNO        DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   END
     C                   MOVEL     DDDLNO        @SIDN
     C                   END
      *
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        IKDN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IKLACT
      *
      * MONEY MARKET DATABASE UPDATES
      *
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C                   PARM                    #FPAYF                                       CDL033
     C                   PARM                    #FRECF                                       CDL033
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM                    PBFRCD          100                          CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM                    PAFRCD          100                          CDL033
     C/COPY WNCPYSRC,MMLDNIWC17
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNIWC29
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C/COPY WNCPYSRC,MMLDNIWC10
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,MMLDNIWC20
     C                   END
     C/COPY WNCPYSRC,MMLDNIWC05
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      * SRSched  - Routine that maintains user-defined dates.                                 CDL033
      *****************************************************************                       CDL033
     C     SRSched       BEGSR                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDDLNO = *BLANK                                            CDL033
      *                                                                                       CDL033
     C                   CALLB     'CAGETNXTDL'                                               CDL033
     C                   PARM      *Blanks       PRtrnCde10                                   CDL033
     C                   PARM      *Blanks       PMessage                                     CDL033
     C                   PARM                    WDLNO                                        CDL033
     C                   PARM      *Zeros        W2DLNO                                       CDL033
     C                   IF        PMessage <> *Blanks                                        CDL033
     C                   EVAL      DBFILE = 'CAGTNXDL'                                        CDL033
     C                   EVAL      DBASE  = 102                                               CDL033
     C                   EVAL      DBKEY  = DDDLNO                                            CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDDLNO = *Blanks                                           CDL033
     C                   MOVEL     WDLNO         PDealNo                                      CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVEL     DDDLNO        PDealNo                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** convert maturity date screen format to MIDAS day no.                                 CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDMDAT        PDateIn                                      CDL033
     C     PMatDate      PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
      ** convert value date screen format to MIDAS day no.                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDVDAT        PDateIn                                      CDL033
     C     PValDate      PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
      ** MM Loans/deposits change date controller                                             CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMLDNICHD'                                                CDL033
     C                   PARM      *Blanks       PRtrnCde7                                    CDL033
     C                   PARM      DDACTN        PAction                                      CDL033
     C                   PARM                    NwDLScnFmt                                   CDL033
     C                   PARM                    PDealNo                                      CDL033
     C                   PARM      DDCCY         PCurrency                                    CDL033
     C                   PARM                    PMatDate                                     CDL033
     C                   PARM                    PValDate                                     CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      *Blanks       WErrMsgID                                    CDL033
      *                                                                                       CDL033
      ** warning message received                                                             CDL033
      *                                                                                       CDL033
     C                   IF        WErrMsgID <> *Blanks                                       CDL033
     C                   EVAL      WIdx             = WIdx + 1                                CDL033
     C                   EVAL      WMsgIdArr (WIdx) = WErrMsgID                               CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** F3 is pressed - exit screen                                                          CDL033
      *                                                                                       CDL033
     C                   IF        PRtrnCde7 = 'Y2U9999'                                      CDL033
     C                   EVAL      @SCRN = 'T'                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** F12 is pressed - return to main screen                                               CDL033
      *                                                                                       CDL033
     C                   IF        PRtrnCde7 = 'USR0790'                                      CDL033
     C                   EVAL      @SCRN = 'M'                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Enter is pressed                                                                     CDL033
      *                                                                                       CDL033
     C                   IF        PRtrnCde7 = *Blanks                                        CDL033
     C                   IF        BGWDPR = 'Y'                                               CDL033
     C                   EVAL      @SCRN = 'W'                                                CDL033
     C                   ELSE                                                                 CDL033
     C                   EVAL      @SCRN = 'S'                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
     C/COPY WNCPYSRC,MMLDNIWC18
      *                                                                                       209867
      ** Issue rollback to clear any possible updates in window function                      209867
      *                                                                                       209867
     C     BGWDPR        IFEQ      'Y'                                                        209867
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK                                                                209867
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                                  209867
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMLDNIWC19
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIRIN'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
      ** Check if Dealing Fiduciary is switched ON                                            CDL006
                                                                                              CDL006
     C                   CALLB     'MMFIDINIT'                                                CDL006
     C                   PARM      *BLANKS       WRTCD             7                          CDL006
     C/COPY WNCPYSRC,MMH00152
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'MMLDNIRIN'                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 903                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,MMH00028
      *                                                                                       CSC022
      ** Access SAR details file to determine if CDL033 is switched on                        CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *Blanks       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   IF        @RTCD = *Blanks                                            CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Database error                                                                       CDL033
      *                                                                                       CDL033
     C                   If        @RTCD <> '*NRF' and                                        CDL033
     C                             @RTCD <> *Blank                                            CDL033
     C     *LOCK         In        LDA                                                        CDL033
     C                   Eval      DBKey = 'CDL033'                                           CDL033
     C                   Eval      DBPgm = 'MMLDNIRIN'                                        CDL033
     C                   Eval      DBFile = 'SCSARDPD'                                        CDL033
     C                   Eval      DBase = 904                                                CDL033
     C                   Out       LDA                                                        CDL033
     C                   ExSr      *PSSR                                                      CDL033
     C                   EndIf                                                                CDL033
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIO011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMH00153
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
