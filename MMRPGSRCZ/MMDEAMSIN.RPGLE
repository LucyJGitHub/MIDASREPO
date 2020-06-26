     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments input')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMSIN - DEAL AMENDMENTS SCREEN INPUT                     *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Deal Amendments.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 260173             Date 22May20               **
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3045            Date 02Jun02               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196808             Date 25Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 182558             Date 11Aug00               *
      *                 181274             Date 18Jul00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 25Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 165402             DATE 04Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 09Mar99               *
      *                 137552             Date 23Jun98               *
      *                 CAP004  *CREATE    Date 09Sep98               *
      *                 136433             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
      *           parameter mismatch. Apply fix 258724.               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3045- Protect pay/receive instructions for deal amendment *
      *           types EM and BC.                                    *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  196808 - IGSTCY should take the value of FLRSCY when FLPSCY  *
      *           is blank.                                           *
      *  200400 - Reverse fix 179510                                  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  182558 - Change the conditioning, as ZASETINDFT was not      *
      *           being called at all.                                *
      *  181274 - Branch code  BRCA  not correctly initialised  and   *
      *           is  stoping  the input  of  a  Deal Amendment  when *
      *           Settlement Method = 04  .   Error  msg   ESM0904 =  *
      *            'Must reference a Live Retail account '  issued  . *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  CGL011 - Collateral Processing for Midas DBA. Recompile.     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  137552 - Settlement branch not set on some deal amendments   *
      *  CAP004 - APIs phase 3.                                       *
      *           Add extra parm for Extra Data                       *
      *  136433 - Deals enquiry should not default settle instructions*
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
                                                                                              CDL006
      ** Loans/Deposit details file                                                           CDL006
     FMMDEALLL  IF   E           K DISK    USROPN                                             CDL006
     F                                     INFSR(*PSSR)                                       CDL006
     F                                     IGNORE(MMDENSP0:MMDENBP0)                          CDL006
                                                                                              CSD095
     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
     F                                     INFSR(*PSSR)                                       CSD095

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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

     D                 DS                                                                     CDL006
      ** Data structure for ZDATE10 date conversion module                                    CDL006
     D  WDate                  1      8  0                                                    CDL006
     D  WYear                  1      4  0                                                    CDL006
     D  WMonth                 5      6  0                                                    CDL006
     D  WDay                   7      8  0                                                    CDL006
                                                                                              CDL006
     D  WMidasDayNo    S              5  0                                                    CDL006
                                                                                              CDL006
      ** Dealing Fiduciary Switchable Feature                                                 CDL006
     D  CDL006         S              1A   IMPORT                                             CDL006
                                                                                              CDL006
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
     D CrDlFilFmt    E DS                  EXTNAME(MMDEAMPP)
      * Current Deam in File Format

     D CrDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
      * (Current) Deam in Screen Format
     D                                     PREFIX(@)

     D NwDlFilFmt    E DS                  EXTNAME(MMVDEAMPD)
      * New Deam in File Format
     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D  IGREC                300    368
     D  IGPAY                369    927

     D NwDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
      * New Deam in Screen Format

     D MMEDEM        E DS                  EXTNAME(MMEDEAMPD)
      * Error indicators


     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                  1     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D***FLPAY**                1    559                                                      CGL029
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
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029

     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7

     D @PCI@M          DS             7
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN

     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0

     D                 DS
     D**  Data Structure to format date parameter passed to mm0085
     D  @PDAT                  1      8  0
     D  @PDYY                  1      4  0
     D  @PYEAR                 3      4  0
     D  @PDMM                  5      6  0
     D  @PDDD                  7      8  0
     D*
     D                 DS
     D**  Data Structure for screen value date
     D  @VDAT                  1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6
     D*

     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Sett Meth = 04 )                   179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
      ************                                                                     179510 200400
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM

      ** External Data Structure for Access Program AOSARDR0                                  CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
                                                                                              CDL006
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                CAP051
     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
     D                                     PREFIX(IF_)                          CAP051
      * MM (DEAM) Extra Data - File (D/B) format                                CAP051
                                                                                              CAP004
     D ExtData       E DS                  EXTNAME(MMDAEXPD)                                  CAP004
      * MM DEAM Extra Data - File (D/B) format                                                CAP004

     D/COPY QWINDSRC,MMDEAMSDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMDEAMS008

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

      /COPY WNCPYSRC,MMDEAMS001

      *
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END

      /COPY WNCPYSRC,MMDEAMS002

      *
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C     @SCRN         IfEq      'F'                                                        CDL006
     C                   ExSr      SCRN@F                                                     CDL006
     C                   EndIf                                                                CDL006
     C                   END

      /COPY WNCPYSRC,MMDEAMS003

      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END

      /COPY WNCPYSRC,MMDEAMS004

      *
      *
      * DO WHILE SCREEN: SETTLEMENT DETAILS
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END

      /COPY WNCPYSRC,MMDEAMS005

      *
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END

      /COPY WNCPYSRC,MMDEAMS006

      *
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END

      /COPY WNCPYSRC,MMDEAMS007

      *
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMDEAMS009

      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      * Only required if deal number or action code has been changed
      * (this check will also cater for F12 taken from main screen)
      *
     C     BGWDPR        IFEQ      'Y'
     C     DDDLNO        IFNE      @PDLNO
     C     DDVDAT        ORNE      @PVDAT                                       165402
     C     DDDS38        ORNE      @PDS38                                       165402
     C     DDACTN        ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   END
     C                   END
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     DDDLNO        @PDLNO            6
     C                   MOVEL     DDVDAT        @PVDAT            6
     C                   MOVEL     DDDS38        @PDS38            3
     C                   MOVEL     DDACTN        @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMDEAMDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAM (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAM STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMEDEM
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
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAL AMENDMENT (Sequence Number Generated)
     C                   PARM                    @LSQN             3
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
     C/COPY WNCPYSRC,MMDEAMSC06
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMEDEM
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
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
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
      *                                                               *                       CDL006
      *  SCRN@F - Calls Fiduciary Takings Enquiry Module              *                       CDL006
      *                                                               *                       CDL006
      *  Called By: Main Processing                                   *                       CDL006
      *                                                               *                       CDL006
      *  Calls:                                                       *                       CDL006
      * MMFIDTENQ - Fiduciary Takings Enquiry                         *                       CDL006
      * SRSETUP   - Sets up Deal details                              *                       CDL006
      *                                                               *                       CDL006
      *****************************************************************                       CDL006
                                                                                              CDL006
     C     SCRN@F        BEGSR                                                                CDL006
                                                                                              CDL006
      ** Set up Deal details                                                                  CDL006
                                                                                              CDL006
     C                   ExSr      SrSetup                                                    CDL006
                                                                                              CDL006
      ** Call Fiduciary Takings Enquiry                                                       CDL006
                                                                                              CDL006
     C                   CallB     'MMFIDTENQ'                                                CDL006
     C                   Parm                    #PGM             10                          CDL006
     C                   Parm                    ActionCode        1                          CDL006
     C                   Parm                    DealNo            6 0                        CDL006
     C                   Parm                    Dealtype          2                          CDL006
     C**********         Parm                    CustNo            6 0                 CDL006 CSD027
     C                   Parm                    CustNo            6                          CSD027
     C                   Parm                    Currency          3                          CDL006
     C                   Parm                    DealAmt          13 0                        CDL006
     C                   Parm                    IntRate          11 7                        CDL006
     C                   Parm                    DealDate          5 0                        CDL006
     C                   Parm                    ValDate           5 0                        CDL006
     C                   Parm                    MatDate           5 0                        CDL006
     C                   Parm                    NotDays           3 0                        CDL006
     C                   Parm                    ChCode            2                          CDL006
     C                   Parm                    ChDesc           20                          CDL006
     C                   Parm                    ChAmt            13 0                        CDL006
     C                   Parm                    TaxOnCharge       9 0                        CDL006
     C                   Parm                    ComCode           2                          CDL006
     C                   Parm                    ComDesc          20                          CDL006
     C                   Parm                    ComAmt           13 0                        CDL006
     C                   Parm                    TaxOnComm         9 0                        CDL006
     C                   Parm                    TrustSts          1                          CDL006
     C                   Parm                    RestNarr1        60                          CDL006
     C                   Parm                    RestNarr2        60                          CDL006
     C                   Parm                    RestNarr3        60                          CDL006
     C                   Parm                    RestNarr4        60                          CDL006
     C                   Parm                    ReturnCode                                   CDL006
                                                                                              CDL006
     C     ReturnCode    IfNe      *BLANK                                                     CDL006
     C     ReturnCode    IfEq      'Y2U9999'                                                  CDL006
     C                   ExSr      ENDP                                                       CDL006
     C                   Else                                                                 CDL006
                                                                                              CDL006
     C     ReturnCode    IfEq      'USR0790'                                                  CDL006
     C                   Eval      @SCRN = 'M'                                                CDL006
     C                   Else                                                                 CDL006
     C     *Lock         In        LDA                                                        CDL006
     C                   Z-Add     904           Dbase                                        CDL006
     C                   MoveL     'MMFIDTENQ'   DbFile                                       CDL006
     C                   MoveL     ReturnCode    DbKey                                        CDL006
     C                   MoveL     'MMDEAMSIN'   DbPgm                                        CDL006
     C                   Move      *On           *INU7                                        CDL006
     C                   Move      *On           *INU8                                        CDL006
     C                   Move      *On           *INLR                                        CDL006
     C                   Out       LDA                                                        CDL006
     C                   Exsr      *PSSR                                                      CDL006
     C                   Endif                                                                CDL006
     C                   Endif                                                                CDL006
                                                                                              CDL006
     C                   Else                                                                 CDL006
     C     BGWDPR        IfEq      'Y'                                                        CDL006
     C                   Eval      @SCRN = 'W'                                                CDL006
     C                   Else                                                                 CDL006
                                                                                              CDL006
     C     @RDNB         IfEq      'Y'                                                        CDL006
     C                   Eval      @SCRN = 'R'                                                CDL006
     C                   EndIf                                                                CDL006
                                                                                              CDL006
     C                   EndIf                                                                CDL006
                                                                                              CDL006
     C                   EndIf                                                                CDL006
                                                                                              CDL006
     C                   EndSr                                                                CDL006
      *****************************************************************                       CDL006
      /EJECT                                                                                  CDL006
      *****************************************************************                       CDL006
      *                                                               *                       CDL006
      *  SrSetup - Sets up Deal details                               *                       CDL006
      *                                                               *                       CDL006
      *  Called By: SCRN@F Subroutine                                 *                       CDL006
      *                                                               *                       CDL006
      *  Calls:                                                       *                       CDL006
      * ZDATE10   - Converts YYYY/MM/DD to Midas day no.              *                       CDL006
      *                                                               *                       CDL006
      *****************************************************************                       CDL006
                                                                                              CDL006
     C     SrSetup       BegSr                                                                CDL006
                                                                                              CDL006
      ** Deal details                                                                         CDL006
                                                                                              CDL006
     C                   Move      DDDLNO        DealNo                                       CDL006
                                                                                              CDL006
     C                   If        CDL006 = 'Y' and WOpen = ' '                               CDL006
     C                   Open      MMDEALLL                                                   CDL006
     C                   Move      'Y'           WOpen             1                          CDL006
     C                   EndIf                                                                CDL006
                                                                                              CDL006
     C     DealNo        Chain     MMDELDP0                           20                      CDL006
                                                                                              CDL006
      ** Convert Deal date to Midas day (Deal Amendment deal date)                            CDL006
                                                                                              CDL006
     C                   Z-Add     HNDMDY        WYear                                        CDL006
     C                   Z-Add     HNDMDM        WMonth                                       CDL006
     C                   Z-Add     HNDMDD        WDay                                         CDL006
     C                   CallB     'ZDATE10'                                                  CDL006
     C                   Parm                    WDate                                        CDL006
     C                   Parm                    WMidasDayNo                                  CDL006
                                                                                              CDL006
     C                   Z-Add     WMidasDayNo   DealDate                                     CDL006
                                                                                              CDL006
      ** Convert Value date to Midas day (Deal Amendment value date)                          CDL006
                                                                                              CDL006
     C                   Z-Add     HNVDYY        WYear                                        CDL006
     C                   Z-Add     HNVDMM        WMonth                                       CDL006
     C                   Z-Add     HNVDDD        WDay                                         CDL006
     C                   CallB     'ZDATE10'                                                  CDL006
     C                   Parm                    WDate                                        CDL006
     C                   Parm                    WMidasDayNo                                  CDL006
                                                                                              CDL006
     C                   Z-Add     WMidasDayNo   ValDate                                      CDL006
                                                                                              CDL006
      ** Convert Maturity date to Midas Day (Deal maturity date)                              CDL006
                                                                                              CDL006
     C                   Z-Add     HKMDYY        WYear                                        CDL006
     C                   Z-Add     HKMDMM        WMonth
     C                   Z-Add     HKMDDD        WDay                                         CDL006
     C                   CallB     'ZDATE10'                                                  CDL006
     C                   Parm                    WDate                                        CDL006
     C                   Parm                    WMidasDayNo                                  CDL006
                                                                                              CDL006
     C                   Z-Add     WMidasDayNo   MatDate                                      CDL006
                                                                                              CDL006
     C                   MoveL     'MMDEAMSIN'   #PGM                                         CDL006
     C                   Eval      ActionCode = DDACTN                                        CDL006
     C                   Eval      Dealtype = HKTYPE                                          CDL006
     C                   Eval      CustNo = HKCNUM                                            CDL006
     C                   Eval      Currency = HNCCY                                           CDL006
     C                   Eval      DealAmt = HNAMNP                                           CDL006
     C                   Eval      IntRate = HKINTR                                           CDL006
     C                   Eval      NotDays = HKNTCE                                           CDL006
     C                   Eval      ChCode =  FCGC                                             CDL006
     C                   Eval      ChDesc =  FCGD                                             CDL006
     C                   Eval      ChAmt = FXGA                                               CDL006
     C                   Eval      TaxOnCharge = FCGT                                         CDL006
     C                   Eval      ComCode = HKFCMC                                           CDL006
     C                   Eval      ComDesc = HKFCMD                                           CDL006
     C                   Eval      ComAmt = HKFCMA                                            CDL006
     C                   Eval      TaxOnComm = HKFCMT                                         CDL006
     C                   Eval      TrustSts = HKFTST                                          CDL006
     C                   Eval      RestNarr1 = HKFRN1                                         CDL006
     C                   Eval      RestNarr2 = HKFRN2                                         CDL006
     C                   Eval      RestNarr3 = HKFRN3                                         CDL006
     C                   Eval      RestNarr4 = HKFRN4                                         CDL006
     C                   Eval      ReturnCode = *BLANK                                        CDL006
                                                                                              CDL006
     C                   EndSr                                                                CDL006
      *****************************************************************                       CDL006
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deaM details
      *
     C                   EXSR      RTVDEL
      *
      * If action code, deal number, value date or sequence no. are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKVDAT        OREQ      'N'
     C     OKDS38        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete, enquire or authorize
      * or action code is amend and deal number, value date or sequence
      * number has changed
      *   Put the deam on the main details screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDDLNO        ANDNE     @PDLNO
     C     DDACTN        OREQ      'A'
     C     DDVDAT        ANDNE     @PVDAT
     C     DDACTN        OREQ      'A'
     C     DDDS38        ANDNE     @PDS38
     C     DDACTN        OREQ      'A'                                          165402
     C     DDACTN        ANDNE     @PACTN                                       165402
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal number, value date, sequence number or screen control
      * indicators have changed
      *   Re-output screen
      *
     C     DDDLNO        IFNE      @PDLNO
     C     DDACTN        ANDNE     'I'
     C     DDVDAT        ORNE      @PVDAT
     C     DDACTN        ANDNE     'I'
     C     DDDS38        ORNE      @PDS38
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update DeaM in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C/COPY WNCPYSRC,MMDEAMSC04
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update DeaM in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
                                                                                              CDL006
      ** If Dealing Fiduciary is installed, include additional proces -                       CDL006
      ** sing for fiduciary transactions.                                                     CDL006
                                                                                              CDL006
     C                   If        CDL006 = 'Y' and                                           CDL006
     C                             (HNOGDT = 'DT' or HNOGDT = 'LT') and                       CDL006
     C                             (DDMTYP = 'PI' or DDMTYP = 'PD')                           CDL006
     C                   Eval      @SCRN = 'F'                                                CDL006
     C                   Else                                                                 CDL006
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
     C                   EndIf                                                                CDL006
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE
      *
     C     DDACTN        IFEQ      'X'
      *
      * Update Deam in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      * CONTINUE TO SETTLEMENTS SCREEN
      ** (Do not display settlement screen if Deal Amendment type
      ** is 'Rate Change' or 'Capitalise Interest')
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     DDMTYP        IFNE      'SC'
     C     DDMTYP        ANDNE     'CI'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deam in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       MMEDEM
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         IGRSTM
     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
     C                   EVAL      IGROBN = *BLANKS                                           CSD027
     C                   EVAL      IGROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IGPSTM
     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deam in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'MMDEAMAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deam in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deam in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deam in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMEDEM
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      * Validate deam details
      *
     C                   CALLB     'MMDEAMVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                        CAP051
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMEDEM
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      ** (Do not display settlement screen if Deal Amendment type
      ** is 'Rate Change' or 'Capitalise Interest')
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     DDMTYP        IFNE      'SC'
     C     DDMTYP        ANDNE     'CI'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
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
     C                   MOVE      *ALL'Y'       MMEDEM
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'MMDEAMDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMEDEM
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
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAM
     C                   PARM                    @LSQN             3
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'Y'           WriteOnly         1
     C/COPY WNCPYSRC,MMDEAMSC07
      *
      * For inserts generate Deal Amendment Sequence Number
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ENDIF
      *
     C/COPY WNCPYSRC,MMDEAMSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'MMDEAMSIN'   #PGM             10
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
     C/COPY WNCPYSRC,MMDEAMSC08
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
      ** (Do not display settlement screen if Deal Amendment type
      ** is 'Rate Change' or 'Capitalise Interest')
      *
     C     DDMTYP        IFNE      'SC'
     C     DDMTYP        ANDNE     'CI'
     C                   EVAL      @SCRN = 'S'
     C                   ELSE
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
     C/COPY WNCPYSRC,MMDEAMSC05
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEAMS FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON DEAMS FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'MMDEAMRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDDS38            3
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *                                                                         CAP052
      * Front Office Associated ID READ                                         CAP052
     C                   PARM      *BLANK        @FARED           20            CAP052
      *
      * VALUE DATE READ
     C                   PARM      *BLANK        @VDRED            6
      *
      * SEQUENCE NUMBER READ
     C                   PARM      *BLANK        @SQRED            3
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      * If deam read
      *
     C     @DLRED        IFNE      *BLANK
     C     @VDRED        ANDNE     *BLANK
     C     @SQRED        ANDNE     *BLANK
      *
      * Retrieve deam details
      *
     C                   MOVEL     @DLRED        DDDLNO
     C                   MOVEL     @VDRED        DDVDAT
     C                   MOVEL     @SQRED        DDDS38
     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deam on the main details screen
      *
     C                   EXSR      PUTD@M
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
     C/COPY WNCPYSRC,MMDEAMSC09
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMDEAMBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * VALUE DATE POINTER
     C                   PARM                    DDVDAT            6
      *
      * SEQUENCE POINTER
     C                   PARM                    DDDS38            3
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * VALUE DATE SELECTED
     C                   PARM                    @VDSEL            6
      *
      * SEQWUENCE SELECTED
     C                   PARM                    @SQSEL            3
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,MMDEAMSC10
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C/COPY WNCPYSRC,MMDEAMSC11
     C                   GOTO      EBLDBR
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
     C/COPY WNCPYSRC,MMDEAMSC12
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'MMDEAMBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * VALUE DATE POINTER
     C                   PARM                    DDVDAT            6
      *
      * SEQUENCE POINTER
     C                   PARM                    DDDS38            3
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * VALUE DATE SELECTED
     C                   PARM                    @VDSEL            6
      *
      * SEQUENCE SELECTED
     C                   PARM                    @SQSEL            3
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,MMDEAMSC13
      *
      * IF DEAM READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deam details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C/COPY WNCPYSRC,MMDEAMSC14
     C                   MOVEL     @DLSEL        DDDLNO
     C                   MOVEL     @VDSEL        DDVDAT
     C                   MOVEL     @SQSEL        DDDS38
     C                   EXSR      RTVDEL
     C/COPY WNCPYSRC,MMDEAMSC15
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deam on the main details screen
      *
     C                   EXSR      PUTD@M
     C/COPY WNCPYSRC,MMDEAMSC16
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C/COPY WNCPYSRC,MMDEAMSC17
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,MMDEAMSC18
     C                   END
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
     C/COPY WNCPYSRC,MMDEAMSC19
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAM
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAM
      *
     C                   CALLB     'MMDEAMRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
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
      *
      * Value Date
     C                   PARM                    DDVDAT            6
      *
      * Sequence Number
     C                   PARM                    DDDS38            3
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP           15
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP            2
      * Action Code (Reversal transaction)                                                    260173
     C                   PARM      *BLANK        @ACTRV            1                          260173
      *
      * OUTPUTS
      *
      * (Current) deam in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Value Date
     C                   PARM                    OKVDAT
      *
      * OK - Sequence Number
     C                   PARM                    OKDS38
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CDL006
      ** Retrieve warning message, if needed.                                                 CDL006
                                                                                              CDL006
     C                   If        DDACTN = 'D' or DDACTN = 'I'                               CDL006
                                                                                              CDL006
     C                   Move      DDDLNO        DealNo                                       CDL006
                                                                                              CDL006
     C                   CallB     'MMDEAMWRN'                                                CDL006
     C                   Parm                    DealNo                                       CDL006
     C                   Parm                    DDACTN                                       CDL006
     C                   Parm                    HNMTYP                                       CDL006
     C                   Parm                    WFldNamArr                                   CDL006
     C                   Parm                    WMsgIdArr                                    CDL006
     C                   Parm                    WMsgDtaArr                                   CDL006
     C                   Parm                    WIdx                                         CDL006
                                                                                              CDL006
     C                   Endif                                                                CDL006
                                                                                              CDL006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAM ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from MMDEAMPP
      *
     C                   CALLB     'MMDEAMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deam in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Deam in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deam Status
     C                   PARM                    DDSTS            24
      *
      * Update 'Current' Deam with Deam in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & deal number / value date / sequence no.
      *  detail fields = rest)
      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
     C/COPY WNCPYSRC,MMDEAMSC20
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I, A, X display settlement details automatically)
      * (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
     C/COPY WNCPYSRC,MMDEAMSC21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C/COPY WNCPYSRC,MMDEAMSC22
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
     C/COPY WNCPYSRC,MMDEAMSC23
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
     C/COPY WNCPYSRC,MMDEAMSC24
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,MMDEAMSC25
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   END
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTN
     C                   END
      *
      ** Deal number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMM0162'
     C                   MOVE      'N'           OKDLNO
     C                   END
      *
      ** Value Date on screen must be blank or valid date for pointer
      *
     C     @ERRMS        IFEQ      'MMM0125'
     C                   MOVE      'N'           OKVDAT
     C                   END
      *
      ** Sequence no. must be numeric if entered
      *
     C     @ERRMS        IFEQ      'MMM0196'
     C                   MOVE      'N'           OKDS38
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
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
      * IF FIRST TIME FOR ACTION CODE OR DEAL AMENDMENT
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDVDAT        ORNE      ##VDAT
     C     DDDS38        ORNE      ##DS38
     C     DDMTYP        ORNE      ##TTYP
     C     DDPENP        ORNE      ##PENP                                                    BUG3045
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *
      * SETTLEMENT INSTRUCTIONS INPUT
     C/COPY WNCPYSRC,MMDEAMSC29
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
     C                   PARM      'DEAM'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCSNM        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDMTYP        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      *
      * Booking branch
     C**********         PARM                    ##BRCA            3                          181274
     C                   PARM      IGBRCA        ##BRCA            3                          181274
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
      *
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
     C/COPY WNCPYSRC,MMDEAMSC30
     C                   MOVE      DDVDAT        ##VDAT            6
     C                   MOVE      DDDS38        ##DS38            3
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
      ** SET PAYMENT AND RECEIVE DATES TO VALUE DATE OF DEAL AMENDMENT
     C                   Z-ADD     IGDVSD        ##DATR
     C                   Z-ADD     IGDVSD        ##DATP
      *
      * LOAN OR DEPOSIT TYPE DEAL?
      *
     C     HNOMDT        IFEQ      'IT'
     C     HNOMDT        OREQ      'TD'
     C     HNOMDT        OREQ      'CI'
     C     HNOMDT        OREQ      'CD'
     C     HNOMDT        OREQ      'FT'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
     C     HNOMDT        OREQ      'DT'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
     C     HNOMDT        OREQ      'LT'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
     C                   MOVEL     'D'           W#LOD             1
     C                   ELSE
     C                   MOVEL     'L'           W#LOD
     C                   END
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
      *
      ** Protect both Pay and Receive instructions if Deal Amendment type
      ** is 'Rate Change' or 'Capitalise Interest'
      *
     C     DDMTYP        IFEQ      'SC'
     C     DDMTYP        OREQ      'CI'
     C                   MOVEL     'Y'           ##PPAY
     C                   MOVEL     'Y'           ##PREC
     C                   END
      *
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     DDMTYP        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     DDMTYP        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     DDMTYP        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
      *
     C                   MOVEL     'Y'           ##PREC
      *
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
      *
     C     DDMTYP        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     DDMTYP        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     DDMTYP        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
      *
     C                   MOVEL     'Y'           ##PPAY
      *
     C                   END
     C                   END
      *                                                                                      BUG3045
      ** For deal amendment EM protect pay/receive instructions according                    BUG3045
      ** to whether a penalty is being paid and the pay/receive flag                         BUG3045
     C     DDMTYP        IFEQ      'EM'                                                      BUG3045
      *                                                                                      BUG3045
     C                   SELECT                                                              BUG3045
     C     DDAMNP        WHENNE    *BLANKS                                                   BUG3045
     C     DDPENP        ANDEQ     'P'                                                       BUG3045
     C                   MOVE      'Y'           ##PREC                                      BUG3045
     C     DDAMNP        WHENNE    *BLANKS                                                   BUG3045
     C     DDPENP        ANDEQ     'R'                                                       BUG3045
     C                   MOVE      'Y'           ##PPAY                                      BUG3045
     C                   OTHER                                                               BUG3045
     C                   MOVE      'Y'           ##PREC                                      BUG3045
     C                   MOVE      'Y'           ##PPAY                                      BUG3045
     C                   ENDSL                                                               BUG3045
      *                                                                                      BUG3045
     C                   ENDIF                                                               BUG3045
      *                                                                                      BUG3045
      ** Save penalty pay/receive indicator flag                                             BUG3045
     C                   MOVE      DDPENP        ##PENP            1                         BUG3045
      *                                                                                      BUG3045
      ** For deal amendment BC protect pay/receive instructions        ng                    BUG3045
     C     DDMTYP        IFEQ      'BC'                                                      BUG3045
     C                   MOVE      'Y'           ##PREC                                      BUG3045
     C                   MOVE      'Y'           ##PPAY                                      BUG3045
     C                   ENDIF                                                               BUG3045
      **                                                                                     BUG3045
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAM
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     IGPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(IGPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = IGPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(IGPAY:15:545)                CGL029
     C                   MOVEL     IGOSBR        FLPOBR
     C                   MOVEL     IGCVMR        FLCVMR
     C                   MOVEL     IGSTCY        FLPSCY
     C                   MOVEL     IGIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAM
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     IGREC         FLREC                                        CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(IGREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = IGRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(IGREC:15:55)                  CGL029
     C                   MOVEL     IGOSBR        FLROBR
     C                   MOVEL     IGSTCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT INSTRUCTIONS ARE NOT PROTECTED
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'                                          182558
     C*****FLRSTM        OREQ      *ZERO                                        136433
     C*****FLRSTM        ANDEQ     *ZERO                                  136433182558
     C     FLRSTM        OREQ      *ZERO                                        182558
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'                                          136433
                                                                                              CSD095
      ** Retrieve the subtype and branch associated with the deal                             CSD095
                                                                                              CSD095
     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
                                                                                              CSD095
     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
     C                   ENDIF                                                                CSD095
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'DEAM'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
     C/COPY WNCPYSRC,MMDEAMSC31
      *
      * Customer shortname
     C                   PARM      DDCSNM        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDMTYP        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
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
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDSTYP            2                          CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRCA            3                          CSD095
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
     C                   END
      *
      * Clear payment instructions if protected
      *
     C     ##PPAY        IFEQ      'Y'
     C                   CLEAR                   ##PAYF
     C                   Z-ADD     *ZERO         FLPSTM
     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
     C                   END
      *
      * Clear receipt instructions if protected
      *
     C     ##PREC        IFEQ      'Y'
     C                   CLEAR                   ##RECF
     C                   Z-ADD     *ZERO         FLRSTM
     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
     C                   EVAL      FLROBN = *BLANKS                                           CSD027
     C                   EVAL      FLROCN = *BLANKS                                           CSD027
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
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C/COPY WNCPYSRC,MMDEAMSC03
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
     C/COPY WNCPYSRC,MMDEAMSC01
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
      * UPDATE VALID DEAM: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLPAY         IGPAY                                        CGL029
     C                   EVAL      %SUBST(IGPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      IGPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(IGPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C     FLPOBR        IFNE      *BLANKS                                      137552
     C                   MOVEL     FLPOBR        IGOSBR
     C                   END                                                    137552
     C                   MOVEL     FLCVMR        IGCVMR
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        IGMOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      *
      * UPDATE VALID DEAM: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         IGREC                                        CGL029
     C                   EVAL      %SUBST(IGREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      IGRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(IGREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C     FLROBR        IFNE      *BLANKS                                      137552
     C                   MOVEL     FLROBR        IGOSBR
     C                   END                                                    137552
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        IGMORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAM: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
     C     FLPSCY        IFNE      *BLANKS                                                    196808
      *
     C                   MOVEL     FLPSCY        IGSTCY
     C                   ELSE                                                                 196808
     C                   MOVEL     FLRSCY        IGSTCY                                       196808
     C                   ENDIF                                                                196808
     C                   MOVEL     FLIC72        IGIC72
     C/COPY WNCPYSRC,MMDEAMSC02
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
     C                   MOVE      *ALL'Y'       MMEDEM
      *
      * Validate deam details
      *
     C                   CALLB     'MMDEAMVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                        CAP051
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMEDEM
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
                                                                                              CDL006
      ** Retrieve warning message, if needed.                                                 CDL006
                                                                                              CDL006
     C                   If        DDACTN = 'D' or DDACTN = 'I'                               CDL006
                                                                                              CDL006
     C                   Move      DDDLNO        DealNo                                       CDL006
                                                                                              CDL006
     C                   CallB     'MMDEAMWRN'                                                CDL006
     C                   Parm                    DealNo                                       CDL006
     C                   Parm                    DDACTN                                       CDL006
     C                   Parm                    DDMTYP                                       CDL006
     C                   Parm                    WFldNamArr                                   CDL006
     C                   Parm                    WMsgIdArr                                    CDL006
     C                   Parm                    WMsgDtaArr                                   CDL006
     C                   Parm                    WIdx                                         CDL006
                                                                                              CDL006
     C                   Endif                                                                CDL006
                                                                                              CDL006
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMDEAMDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAM (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAM STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMEDEM
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
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      * SUCCESFUL INSERT DEAM
     C                   PARM                    @LSQN             3
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
     C/COPY WNCPYSRC,MMDEAMSC26
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMEDEM
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
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
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
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
      *              for Inserts.                                     *
      *                                                               *
      *****************************************************************
     C     SETUPDASEQ    BEGSR
     C*
     C**  Load deal number into numeric field passed to MM0085
     C                   MOVE      DDDLNO        DealNo            6 0
     C*
     C** Format Value Date
     C     DDVDAT        IFNE      *BLANKS                                      B1
     C*
     C** Load value date to numeric keyfield,in YYYYMMDD format
     C                   MOVE      DDVDAT        @VDAT

     C                   Z-ADD     0             @PDAT                          **2
     C                   MOVE      @DSPY         @PYEAR                         **2
     C     BJDFIN        IFEQ      'D'                                                         BHF18
     C                   MOVE      @DSPD         @PDDD                          **2
     C                   ELSE                                                                  BHF18
     C                   MOVE      @DSPD         @PDMM                                         BHF18
     C                   END                                                                   BHF18
     C     BJDFIN        IFEQ      'D'                                                         BHF18
     C                   MOVE      @DSPM         @PDMM                          **2
     C                   ELSE                                                                  BHF18
     C                   MOVE      @DSPM         @PDDD                                         BHF18
     C                   END                                                                   BHF18
     C*
     C** Century
     C     @PYEAR        IFGE      72                                           B**3
     C     @PDYY         ADD       1900          @PDYY                          ***3
     C                   ELSE                                                   ***3
     C     @PDYY         ADD       2000          @PDYY                          ***3
     C                   END                                                    E**3
     C                   ELSE                                                   X1
     C                   Z-ADD     0             @PDAT                          *1
     C                   END                                                    E1
     C                   Z-ADD     @PDAT         ValueDate         8 0

      ** Generate DEAM Sequence Number
     C                   CALLB     'MM0085'
     C                   PARM                    Term              1
     C                   PARM                    DealNo
     C                   PARM                    ValueDate
     C                   PARM                    SeqNoPack         3 0
      *
      ** If error returned from MM0085
     C     Term          IFNE      *BLANK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     SeqNoPack     IGDS38
     C                   MOVEL     IGDS38        @LSQN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * For inserts generate Deal Amendment Sequence Number
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ENDIF
      *
      * UPDATE VALID DEAM: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        IGDA38
      *
      * UPDATE VALID DEAM: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IGLACT
     C/COPY WNCPYSRC,MMDEAMSC27
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMDEAMUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
      *
      * DEAMS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
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
     C                   END
      *
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                                                                          CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C/COPY WNCPYSRC,MMDEAMSC28
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
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
     C                   END
      *
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMSIN'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
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
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
                                                                                              CDL006
      ** Access Switchable Features file to check if Dealing Fiducia                          CDL006
      ** ry is installed.                                                                     CDL006
                                                                                              CDL006
     C                   CallB     'MMFIDINIT'                                                CDL006
     C                   Parm      *Blanks       RetCode           7                          CDL006

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMDEAMS010
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
     C                   Eval      DBPgm = 'MMDEAMSIN'                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 905                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
