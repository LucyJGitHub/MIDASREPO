     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits input')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNISIN - LOANS/DEPOSITS & NAS ISSUED SCREEN INPUT         *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for loan and deposit deals.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD036070           Date 19Oct15               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258601             Date 17Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009             Date 04May04               *
      *                 CDL033             Date 10Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM105             Date 22Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1908            Date 16Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 196380             Date 15May02               *
      *                 192916             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192530             Date 15May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 182224             Date 24Aug00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             DATE 11May99               *
      *                 CAP052             DATE 25Nov99               *
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      *                 165402             DATE 04Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 09Mar99               *
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 09Sep98               *
      *                 CAP003             Date 05May98               *
      *                 136433             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MMH00001                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  258601 - Validate value date against the back value period   *
      *           defined in PF/SDBANKPD.                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIS008,MMLDNISC34,MMLDNISC38,*
      *                              MMLDNISC39,                      *
      *           Core hooks added:MMLDNISC74                         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1908- Any input made on LDNI results in DB error          *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  196380 - Do not allow deletion of a deal if linked to a      *
      *           'Live' Depot Movement.                              *
      *  192916 - Rollback of window updates wrongly managed in Core  *
      *           API's modules RPR and SIN.                          *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510                                  *
      *  192530 - Pass the correct date to ZASETINSIN.                *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
      *           in   FX &  MM  input options .  When  F12  is pressed
      *           from  the last confirmation  screen ,  the  ROLBK   *
      *           is not performed  every time .                      *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to MMLDNIDSP and ZASETINDFT.                        *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  CGL011 - Collateral Processing for Midas DBA                 *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - APIs phase 3.                                       *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  136433 - Deals enquiry should not default settle instructions*
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
                                                                                              CDL006
     FSDCCGRL1  IF   E           K DISK    USROPN                                             CDL006
     F                                     INFSR(*PSSR)                                       CDL006
     F/COPY WNCPYSRC,MMLDNISF01

     F/COPY WNCPYSRC,MMLDNISF02
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D***Inv_FIDT        S             42    DIM(99)                                   209905 CGL029
     D Inv_FIDT        S             48    DIM(99)                                            CGL029
                                                                                              209905
     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format

     D CrDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)

     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
      * New Deal in File Format
     D***IKREC**              456    524                                                      CGL029
     D***IKPAY**              525   1083                                                      CGL029
     D  IKREC                470    524                                                       CGL029
     D  IKPAY                539   1083                                                       CGL029

     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * New Deal in Screen Format

     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
      * Error indicators

     D MMELDN2       E DS                  EXTNAME(MMELDN2PD)                                 CDL016
      * Error indicators screen 2                                                             CDL016

     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
                                                                                              CDL018
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
      ** File - Payment Further Settlement Instructions                                       CDL018
                                                                                              CDL018
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
      ** File - Receive Further Settlement Instructions                                       CDL018

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
     D/COPY WNCPYSRC,MMLDNISD01
      ************                                                                     179510 200400
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
                                                                                              CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
      ** External data structure for SAR details                                              CDL006
                                                                                              CDL006
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CDL006
      ** External data structure for dealing ICD                                              CDL006
                                                                                              CDL006
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CDL006
      ** External data structure for customer details                                         CDL006

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CDL006
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CDL006
      ** Third DS for access programs, very long data structure                               CDL006
                                                                                              CDL007
     D InfData       E DS                  EXTNAME(MMLDIFPD)                                  CDL007
     D                                     PREFIX(IF_)                                        CDL007
      * MM (LDNI) Extra Data - File (D/B) format                                              CDL007
                                                                                              CDL006
                                                                                              CAP004
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                                  CAP004
      * MM (LDNI) Extra Data - File (D/B) format                                              CAP004

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAS011
      ** Long Data Structure for Access Programs                                              CAS011
                                                                                              CAS011
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     D/COPY QWINDSRC,MMLDNISDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CDL006
      ** Dealing Fiduciary                                                                    CDL006
     D CDL006          S              1A   IMPORT                                             CDL006

     D PFrontId1       S             20A                                                      209905
     D PFrontId2       S             20A                                                      209905
     D PAsocId         S             20A                                                      209905
     D PProtect        S              1A                                                      209905
                                                                                              209905
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
     D DLNO            S              6  0                                                    CDL033
     D Mode            S                   LIKE(DDACTN)                                       CDL033
     D Pcurrency       S                   LIKE(DDBRAT)                                       CDL033
     D MaturityDate    S                   LIKE(IKMATD)                                       CDL033
     D ValueDate       S                   LIKE(IKDVSD)                                       CDL033
     D PMessage        S                   LIKE(#MSGID)                                       CDL033
     D WErrMsgID       S                   LIKE(#MSGID)                                       CDL033
                                                                                              CDL033
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIS008

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

      /COPY WNCPYSRC,MMLDNIS001

      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END

      /COPY WNCPYSRC,MMLDNIS002

      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
                                                                                              CDL016
      * DO WHILE SCREEN: Screen 2 Details                                                     CDL016
     C     @SCRN         DOWEQ     'N'                                                        CDL016
     C                   EXSR      SCRN@N                                                     CDL016
     C                   ENDDO                                                                CDL016
                                                                                              CDL006
     ** Fiduciary transaction processing                                                      CDL006
                                                                                              CDL006
     C     CDL006        IFEQ      'Y'                                                        CDL006
     C     @SCRN         ANDEQ     'F'                                                        CDL006
     C                   EXSR      SCRN@F                                                     CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL033
     C                   IF        CDL033 = 'Y' AND @SCRN = 'X'                               CDL033
     C                   EXSR      SRSched                                                    CDL033
     C                   ENDIF                                                                CDL033

      /COPY WNCPYSRC,MMLDNIS003

      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END

      /COPY WNCPYSRC,MMLDNIS004

      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END

      /COPY WNCPYSRC,MMLDNIS005

      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END

      /COPY WNCPYSRC,MMLDNIS006

      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END

      /COPY WNCPYSRC,MMLDNIS007

      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                192916
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNIS009

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
     C     DDACTN        ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
     C/COPY WNCPYSRC,MMLDNISC31
                                                                                              182224
      * Check for the work field indicating Deal No. allocation has run                       182224
     C     @WFRUN        OREQ      'Y'                                                        182224
                                                                                              182224
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,MMLDNISC32
                                                                                              182224
     C                   EVAL      @WFRUN = *BLANKS                                           182224
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMLDNISC33
      *                                                                                       CDL016
      * If Action code or Deal No. has changed and previous values                            CDL016
      * are not blank, then reset Block/Unblock Action                                        CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     DDACTN        ANDNE     'A'                                                        CDL016
      *                                                                                       CDL016
     C     DDDLNO        IFNE      @PDLNO                                                     CDL016
     C     @PDLNO        ANDNE     *BLANKS                                                    CDL016
     C     DDACTN        ORNE      @PACTN                                                     CDL016
     C     @PACTN        ANDNE     *BLANKS                                                    CDL016
     C     DDACTN        OREQ      *BLANKS                                                    CDL016
     C     DDDLNO        OREQ      *BLANKS                                                    CDL016
     C                   EVAL      BUACT = *BLANKS                                            CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     DDDLNO        @PDLNO            6
     C                   MOVEL     DDACTN        @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
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
     C/COPY WNCPYSRC,MMLDNISC51
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS           10                          CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
     C/COPY WNCPYSRC,MMH00096
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
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNISIN '  CPGM             10                          CAP067
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNISC09
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDN
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
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C/COPY WNCPYSRC,MMH00120
     C                   EXSR      RTVDEL
      *
      * If action code, deal number or booking branch are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKBRCA        OREQ      'N'
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
      * or action code is amend and deal number has changed
      *   Put the deal on the main details screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDDLNO        ANDNE     @PDLNO
     C     DDACTN        OREQ      'A'                                          165402
     C     DDACTN        ANDNE     @PACTN                                       165402
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal number or screen control indicators have changed
      *   Re-output screen
      *
     C     DDDLNO        IFNE      @PDLNO
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
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC52
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C/COPY WNCPYSRC,MMLDNISC42
     C                   MOVEL     'U'           @SCRN
     C/COPY WNCPYSRC,MMLDNISC03
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC53
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
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
     C                   MOVEL     'F'           @SCRN                                        CDL006
                                                                                              CDL006
     C                   ELSE                                                                 CDL006
                                                                                              CDL006
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      *                                                                                       CDL016
      * Display second screen if Fixed Deposit Deal                                           CDL016
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
     C     DDTYPE        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   MOVEL     'N'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
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
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC54
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
      *                                                                                       CDL016
      * Display second screen if Fixed Deposit Deal                                           CDL016
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
     C     DDTYPE        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   MOVEL     'N'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
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
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       MMELDN
     C     ERRFSR        IFNE      'Y'                                                        258601
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
     C                   ENDIF                                                                258601
     C/COPY WNCPYSRC,MMLDNISC44
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C/COPY WNCPYSRC,MMH00121
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC55
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'MMLDNIAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deal in file format
     C                   PARM                    CrDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC56
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMELDN
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
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                                      CDL007
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT                         CPB002
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMELDN
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC57
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNISC34
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
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
     C                   MOVE      'F'           @SCRN                                        CDL006
                                                                                              CDL006
     C                   ELSE                                                                 CDL006
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
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
      *                                                                                       CDL016
      * Display second screen if Fixed Deposit Deal                                           CDL016
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
     C     DDTYPE        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   MOVEL     'N'           @SCRN                                        CDL016
      *                                                                                       CDL016
      * Reset errors                                                                          CDL016
     C                   MOVEL     *BLANK        FldNameArr                                   CDL016
     C                   MOVEL     *BLANK        MsgIdArr                                     CDL016
     C                   MOVEL     *BLANK        MsgDtaArr                                    CDL016
     C                   MOVEL     *BLANK        WFldNamArr                                   CDL016
     C                   MOVEL     *BLANK        WMsgIdArr                                    CDL016
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CDL016
     C                   ENDIF                                                                CDL016
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL016
      *****************************************************************                       CDL016
      * SCRN@N - PROCESS SCREEN: Screen 2 Details                                             CDL016
      *****************************************************************                       CDL016
     C     SCRN@N        BEGSR                                                                CDL016
      *                                                                                       CDL016
      * Update 'previous' deal number & screen control indicator                              CDL016
      *                                                                                       CDL016
      *                                                                                       CDL016
      * WRITE/READ DISPLAY SCREEN 2                                                           CDL016
      *                                                                                       CDL016
     C                   CALLB     'MMLDNIDS2'                                                CDL016
      *                                                                                       CDL016
      * INPUT PARAMETERS                                                                      CDL016
      *                                                                                       CDL016
      * RETURN CODE                                                                           CDL016
     C                   PARM      *BLANK        RetCodeOut                                   CDL016
      *                                                                                       CDL016
      * DEAL (IN SCREEN FORMAT)                                                               CDL016
     C                   PARM                    NwDlScnFmt                                   CDL016
      *                                                                                       CDL016
      * DEAL STATUS                                                                           CDL016
     C                   PARM                    DDSTS                                        CDL016
      *                                                                                       CDL016
      * FIELDS IN ERROR                                                                       CDL016
     C                   PARM                    MMELDN2                                      CDL016
      *                                                                                       CDL016
      * ERRORS                                                                                CDL016
     C                   PARM                    FldNameArr                                   CDL016
     C                   PARM                    MsgIdArr                                     CDL016
     C                   PARM                    MsgDtaArr                                    CDL016
      *                                                                                       CDL016
      * WARNINGS                                                                              CDL016
     C                   PARM                    WFldNamArr                                   CDL016
     C                   PARM                    WMsgIdArr                                    CDL016
     C                   PARM                    WMsgDtaArr                                   CDL016
      *                                                                                       CDL016
      * ENABLED KEY & DETAIL FIELDS                                                           CDL016
      *                                                                                       CDL016
     C                   PARM                    @EKYFD                                       CDL016
     C                   PARM                    @EDTFD                                       CDL016
      *                                                                                       CDL016
      * ENABLED FUNCTION KEYS                                                                 CDL016
     C                   PARM                    @EINKG                                       CDL016
     C                   PARM                    @EINKH                                       CDL016
     C                   PARM                    @EINKJ                                       CDL016
     C                   PARM                    @EINKN                                       CDL016
     C                   PARM                    @EINKP                                       CDL016
     C                   PARM      'N'           @EINKT                                       CDL016
      *                                                                                       CDL016
      * SUCCESFUL INSERT DEAL                                                                 CDL016
     C                   PARM                    @SIDN                                        CDL016
      * CALLING PGM                                                                           CDL016
     C                   PARM      'MMLDNISIN '  CPGM                                         CDL016
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT                                        CDL016
     C                   PARM                    CDL016                                       CDL033
     C                   PARM                    CDL019                                       CDL033
     C                   PARM                    CDL020                                       CDL033
      *                                                                                       CDL016
      * OUTPUT PARAMETERS                                                                     CDL016
      *                                                                                       CDL016
      * FUNCTION KEYS                                                                         CDL016
     C                   PARM      '0'           @INKC                                        CDL016
     C                   PARM      '0'           @INKG                                        CDL016
     C                   PARM      '0'           @INKH                                        CDL016
     C                   PARM      '0'           @INKJ                                        CDL016
     C                   PARM      '0'           @INKL                                        CDL016
     C                   PARM      '0'           @INKN                                        CDL016
     C                   PARM      '0'           @INKP                                        CDL016
     C                   PARM      '0'           @INKT                                        CDL016
     C                   PARM      'N'           WriteOnly                                    CDL016
     C                   PARM      'N'           RepoFlag                                     CDL016
      *                                                                                       CDL016
      * RESET ERRORS                                                                          CDL016
      *                                                                                       CDL016
     C                   MOVE      *ALL'Y'       MMELDN2                                      CDL016
     C                   MOVEL     *BLANK        FldNameArr                                   CDL016
     C                   MOVEL     *BLANK        MsgIdArr                                     CDL016
     C                   MOVEL     *BLANK        MsgDtaArr                                    CDL016
     C                   MOVEL     *BLANK        WFldNamArr                                   CDL016
     C                   MOVEL     *BLANK        WMsgIdArr                                    CDL016
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CDL016
      *                                                                                       CDL016
      * CK/3 - END PROGRAM                                                                    CDL016
      *                                                                                       CDL016
     C     @INKC         CASEQ     '1'           ENDP                                         CDL016
      *                                                                                       CDL016
      * CK/7 - ROLL BACKWARDS                                                                 CDL016
      *                                                                                       CDL016
     C     @INKG         CASEQ     '1'           ROLL                                         CDL016
      *                                                                                       CDL016
      * CK/8 - ROLL FORWARDS                                                                  CDL016
      *                                                                                       CDL016
     C     @INKH         CASEQ     '1'           ROLL                                         CDL016
      *                                                                                       CDL016
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN                                                 CDL016
      *                                                                                       CDL016
     C     @INKL         CASEQ     '1'           CANC@N                                       CDL016
      *                                                                                       CDL016
      * CK/15 - BUILD BROWSE                                                                  CDL016
      *                                                                                       CDL016
     C     @INKP         CASEQ     '1'           BLDBRW                                       CDL016
      *                                                                                       CDL016
      * VALIDATE INPUT TO MAIN DETAILS SCREEN 2                                               CDL016
      *                                                                                       CDL016
     C                   CAS                     VAL@N                                        CDL016
     C                   END                                                                  CDL016
      *                                                                                       CDL016
     C                   ENDSR                                                                CDL016
      *****************************************************************                       CDL016
      /EJECT                                                                                  CDL016
      *****************************************************************                       CDL016
      * VAL@N  - VALIDATE INPUT TO MAIN DETAILS SCREEN 2                                      CDL016
      *****************************************************************                       CDL016
     C     VAL@N         BEGSR                                                                CDL016
      *                                                                                       CDL016
      * Set field and function key status on main details screen                              CDL016
      * (according to action code)                                                            CDL016
      *                                                                                       CDL016
     C                   EXSR      SFDS@M                                                     CDL016
     C                   EXSR      SFKS@M                                                     CDL016
      *                                                                                       CDL016
      *----------------------------------------------------------------                       CDL016
      * IF ENQUIRE                                                                            CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'E'                                                        CDL016
      *                                                                                       CDL016
      * Update Deal in File Format                                                            CDL016
      *                                                                                       CDL016
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt                                   CDL016
      *                                                                                       CDL016
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN                                        CDL016
      * If windows processing on, call window routine                                         CDL016
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD                                CDL016
      *                                                                                       CDL016
     C     @INKN         IFEQ      '1'                                                        CDL016
     C                   MOVEL     'S'           @SCRN                                        CDL016
     C                   ELSE                                                                 CDL016
                                                                                              CDL016
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C     BGWDPR        IFEQ      'Y'                                                        CDL016
     C                   MOVEL     'W'           @SCRN                                        CDL016
     C                   ELSE                                                                 CDL016
     C     @RDNB         IFEQ      'Y'                                                        CDL016
     C                   MOVEL     'R'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL033
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   GOTO      EVAL@N                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      *----------------------------------------------------------------                       CDL016
      * IF AUTHORIZE                                                                          CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'X'                                                        CDL016
      *                                                                                       CDL016
      * Update Deal in File Format                                                            CDL016
      *                                                                                       CDL016
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt                                   CDL016
      *                                                                                       CDL016
      * If windows processing on, call window routine                                         CDL016
      * otherwise, continue to settlements screen                                             CDL016
      *                                                                                       CDL016
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C     BGWDPR        IFEQ      'Y'                                                        CDL016
     C                   MOVEL     'W'           @SCRN                                        CDL016
     C                   ELSE                                                                 CDL016
     C                   MOVEL     'S'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL016
     C                   GOTO      EVAL@N                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      *----------------------------------------------------------------                       CDL016
      * IF INSERT OR AMEND                                                                    CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'I'                                                        CDL016
     C     DDACTN        OREQ      'A'                                                        CDL016
      *                                                                                       CDL016
      * Prior to validation, initialize error indicators as 'OK'                              CDL016
      *                                                                                       CDL016
     C                   Z-ADD     *ZERO         Idx                                          CDL016
     C                   Z-ADD     *ZERO         WIdx                                         CDL016
     C                   MOVE      *ALL'Y'       MMELDN2                                      CDL016
      *                                                                                       CDL016
      * If Amend Update Deal in File Format                                                   CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'A'                                                        CDL016
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt                                   CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      * Validate deal details                                                                 CDL016
      *                                                                                       CDL016
     C                   CALLB     'MMLDNIVL2'                                                CDL016
     C                   PARM                    RespMode                                     CDL016
     C                   PARM                    NwDlScnFmt                                   CDL016
     C                   PARM                    InfData                                      CDL016
     C                   PARM      IKSTCY        @@RSCY                                       CDL016
     C                   PARM      IKRSTM        @@RSTM                                       CDL016
     C                   PARM      IKRONS        @@RONS                                       CDL016
     C                   PARM      IKSTCY        @@PSCY                                       CDL016
     C                   PARM      IKPSTM        @@PSTM                                       CDL016
     C                   PARM      IKPONS        @@PONS                                       CDL016
     C                   PARM      IKFRNT        @@FRNT                                       CDL016
     C                   PARM                    ExtData                                      CDL016
     C                   PARM                    MMELDN2                                      CDL016
     C                   PARM                    FldNameArr                                   CDL016
     C                   PARM                    MsgIdArr                                     CDL016
     C                   PARM                    MsgDtaArr                                    CDL016
     C                   PARM                    Idx                                          CDL016
     C                   PARM                    WFldNamArr                                   CDL016
     C                   PARM                    WMsgIdArr                                    CDL016
     C                   PARM                    WMsgDtaArr                                   CDL016
     C                   PARM                    WIdx                                         CDL016
     C                   PARM                    NwDlFilFmt                                   CDL016
     C                   PARM      'N'           RepoFlag          1                          CDL016
     C                   PARM                    CDL016                                       CDL016
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
     C                   PARM                    CAS005                                       CDL033
     C                   PARM                    CDL033                                       CDL033
     C                   PARM      IKINTR        SRate            11 7                        CDL033
      *                                                                                       CDL016
      * If errors returned                                                                    CDL016
      *                                                                                       CDL016
     C     Idx           IFNE      0                                                          CDL016
     C                   GOTO      EVAL@N                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      * If windows processing on, call window routine                                         CDL016
      * otherwise, continue to settlements screen                                             CDL016
      *                                                                                       CDL016
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C     BGWDPR        IFEQ      'Y'                                                        CDL016
     C                   MOVEL     'W'           @SCRN                                        CDL016
     C                   ELSE                                                                 CDL016
     C                   MOVEL     'S'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL033
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
      *----------------------------------------------------------------                       CDL016
     C     EVAL@N        ENDSR                                                                CDL016
      *****************************************************************                       CDL016
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       MMELDN
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,MMLDNISC35
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
     C/COPY WNCPYSRC,MMLDNISC58
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS                                       CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
     C/COPY WNCPYSRC,MMH00097
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
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNISIN '  CPGM             10                          CAP067
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT                                        CDL016
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNISC10
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C/COPY WNCPYSRC,MMLDNISC36
                                                                                              CDL006
      ** Call the appropriate module to get the next deal number                              CDL006
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
     C                   PARM      *ZERO         PDealNo                                      CDL006
     C                   MOVE      PDealno       I#DDDLNO                                     CDL006
     C                   Z-ADD     PDealno       IKDN38                                       CDL006
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
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
      * Set up the work field indicating the Deal No. allocation has run                      182224
     C                   MOVE      'Y'           @WFRUN            1                          182224
                                                                                              182224
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   END
      *
     C/COPY WNCPYSRC,MMLDNISMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'MMLDNISIN'   #PGM             10
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
     C/COPY WNCPYSRC,MMLDNISC11
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                192916
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE
     C/COPY WNCPYSRC,MMLDNISC37
     C                   EVAL      @SCRN = 'S'
     C/COPY WNCPYSRC,MMLDNISC07
     C                   ENDIF
     C                   ENDIF
      *
     C/COPY WNCPYSRC,MMLDNISC02
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
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
      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
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
     C                   CALLB     'MMLDNIRED'
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
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      * If deal read
      *
     C     @DLRED        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
     C                   END
      *                                                                                       CDL016
     C                   EVAL      @SCRN = 'M'                                                CDL016
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
     C/COPY WNCPYSRC,MMLDNISC12
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMLDNIBRW'
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
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,MMLDNISC13
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
     C/COPY WNCPYSRC,MMLDNISC14
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
     C/COPY WNCPYSRC,MMLDNISC15
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'MMLDNIBRW'
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
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,MMLDNISC16
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C/COPY WNCPYSRC,MMLDNISC17
     C                   MOVEL     @DLSEL        DDDLNO
     C                   EXSR      RTVDEL
     C/COPY WNCPYSRC,MMLDNISC18
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
     C/COPY WNCPYSRC,MMLDNISC19
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C/COPY WNCPYSRC,MMLDNISC20
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,MMLDNISC21
     C                   END
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
     C/COPY WNCPYSRC,MMLDNISC22
      *
     C                   ENDSR
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
     C/COPY WNCPYSRC,MMLDNISC59
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT                                        CDL016
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
     C/COPY WNCPYSRC,MMLDNISC74
                                                                                              CDL006
      ** Display warnings for deletion of fiduciary transactions                              CDL006
                                                                                              CDL006
     C     CDL006        IFEQ      'Y'                                                        CDL006
     C     DDACTN        ANDEQ     'D'                                                        CDL006
     C                   CALLB     'MMLDNIWRN'                                                CDL006
     C                   PARM                    DDDLNO                                       CDL006
     C                   PARM                    DDTYPE                                       CDL006
     C                   PARM                    WFldNamArr                                   CDL006
     C                   PARM                    WMsgIdArr                                    CDL006
     C                   PARM                    WMsgDtaArr                                   CDL006
     C                   PARM                    WIdx                                         CDL006
     C                   ENDIF                                                                CDL006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from MMDELDPP
      *
     C                   CALLB     'MMLDNICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC60
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNISC61
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS                                       CGL011
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
     C/COPY WNCPYSRC,MMLDNISC62
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
      * (key fields = action code & deal number; detail fields = rest)
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
     C/COPY WNCPYSRC,MMLDNISC23
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
     C     IDX           ANDEQ     0                                                          CAS009
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
     C/COPY WNCPYSRC,MMLDNISC24
      *
     C                   EVAL      IKTNTR = 0                                                 CAS005
      *                                                                                       CAS005
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
     C/COPY WNCPYSRC,MMLDNISC25
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
     C/COPY WNCPYSRC,MMLDNISC26
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
     C/COPY WNCPYSRC,MMLDNISC27
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,MMLDNISC28
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNISC63
     C                   MOVEL     *BLANK        DDSTS
     C                   MoveL     *BLANK        DDCSTS                                       CGL011
     C/COPY WNCPYSRC,MMH00098
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
      *****************************************************************                       CDL016
      * CANC@N - CANCEL ON SECOND DEATILS SCREEN                                              CDL016
      *****************************************************************                       CDL016
     C     CANC@N        BEGSR                                                                CDL016
      *                                                                                       CDL016
      * Return to previous screen                                                             CDL016
     C                   MOVEL     'M'           @SCRN                                        CDL016
      *                                                                                       CDL016
     C                   ENDSR                                                                CDL016
      *****************************************************************                       CDL016
      /EJECT                                                                                  CDL016
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
      *                                                                                       192530
      ** DETERMINE IF LOAN OR DEPOSIT                                                         192530
      *                                                                                       192530
     C     DDTYPE        IFEQ      'IP'                                                       192530
     C     DDTYPE        OREQ      'TI'                                                       192530
     C     DDTYPE        OREQ      'LN'                                                       192530
     C     DDTYPE        OREQ      'CL'                                                       192530
     C     DDTYPE        OREQ      'DL'                                                       192530
     C     DDTYPE        OREQ      'FL'                                                       192530
     C     CDL006        ANDEQ     'Y'                                                        192530
     C     DDTYPE        OREQ      'DP'                                                       192530
     C     CDL006        ANDEQ     'Y'                                                        192530
     C     DDTYPE        OREQ      'LP'                                                       192530
     C     CDL006        ANDEQ     'Y'                                                        192530
     C                   MOVEL     'L'           ##LOD             1                          192530
     C                   ELSE                                                                 192530
     C                   MOVEL     'D'           ##LOD                                        192530
     C                   END                                                                  192530
      *                                                                                       192530
      ** PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT                        192530
      *                                                                                       192530
     C     ##LOD         IFEQ      'L'                                                        192530
     C                   Z-ADD     IKDVSD        ##DATP                                       192530
     C                   ELSE                                                                 192530
     C     IKMATD        IFEQ      0                                                          192530
     C                   Z-ADD     99999         ##DATP                                       192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKMATD        ##DATP                                       192530
     C                   END                                                                  192530
     C                   END                                                                  192530
      *                                                                                       192530
      ** RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT                        192530
      *                                                                                       192530
     C     ##LOD         IFEQ      'L'                                                        192530
     C     IKMATD        IFEQ      0                                                          192530
     C                   Z-ADD     99999         ##DATR                                       192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKMATD        ##DATR                                       192530
     C                   END                                                                  192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKDVSD        ##DATR                                       192530
     C                   END                                                                  192530
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
     C/COPY WNCPYSRC,MMLDNISC08
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
      ************                                                                     179510 200400
     C/COPY WNCPYSRC,MMH00001
      *                                                                                       CDL018
      * If no errors input Further Settlemnent Instructions                                   CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
     C     ##RTCD        ANDEQ     *BLANKS                                                    CDL018
                                                                                              CDL018
      *                                                                                       CDL018
      * Further Settlement Instructions Input                                                 CDL018
      * -------------------------------------                                                 CDL018
     C     FLRMAC        IFEQ      'Y'                                                        CDL018
     C     FLPMAC        OREQ      'Y'                                                        CDL018
     C     DDACTN        OREQ      'E'                                                        CDL018
     C     DDRMAC        ANDEQ     'Y'                                                        CDL018
     C     DDACTN        OREQ      'E'                                                        CDL018
     C     DDPMAC        ANDEQ     'Y'                                                        CDL018
      *                                                                                       CDL018
     C     DDDLNO        IFEQ      *BLANKS                                                    CDL018
     C                   MOVE      IKDN38        ##DLNO                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   CALLB     'ZAFSETISIN'                                               CDL018
      *                                                                                       CDL018
      * INPUTS                                                                                CDL018
      * Return Code                                                                           CDL018
     C                   PARM      *BLANKS       ##RTCD                                       CDL018
      *                                                                                       CDL018
      * Action Code                                                                           CDL018
     C                   PARM                    ##ACTN                                       CDL018
      *                                                                                       CDL018
      * Deal Number                                                                           CDL018
     C                   PARM                    ##DLNO                                       CDL018
      *                                                                                       CDL018
      * Protect Payment Field                                                                 CDL018
     C                   PARM                    ##PPAY                                       CDL018
      *                                                                                       CDL018
      * Protect Receipt Field                                                                 CDL018
     C                   PARM                    ##PREC                                       CDL018
      *                                                                                       CDL018
      ** Calling program                                                                      CDL018
     C                   PARM                    ##CALP                                       CDL018
      *                                                                                       CDL018
      * Payment currency                                                                      CDL018
     C                   PARM                    ##PCCY                                       CDL018
      *                                                                                       CDL018
      * Receive currency                                                                      CDL018
     C                   PARM                    ##RCCY                                       CDL018
      *                                                                                       CDL018
      ** Transaction Type                                                                     CDL018
     C                   PARM                    ##TTYP                                       CDL018
      *                                                                                       CDL018
      * Booking branch                                                                        CDL018
     C                   PARM                    ##BRCA                                       CDL018
      *                                                                                       CDL018
      * Receipt Date                                                                          CDL018
      * (must = 99999 if no back valuation validation to be done)                             CDL018
     C                   PARM                    ##DATR                                       CDL018
      *                                                                                       CDL018
      * Payment Date                                                                          CDL018
      * (must = 99999 if no back valuation validation to be done)                             CDL018
     C                   PARM                    ##DATP                                       CDL018
      *                                                                                       CDL018
      * Payment instructions - screen format                                                  CDL018
     C                   PARM                    ##PAYS                                       CDL018
      *                                                                                       CDL018
      * Receive instructions - screen format                                                  CDL018
     C                   PARM                    ##RECS                                       CDL018
      *                                                                                       CDL018
      * Deal details                                                                          CDL018
     C                   PARM                    NwDlFilFmt                                   CDL018
      *                                                                                       CDL018
      * OUTPUTS                                                                               CDL018
      * Function Keys                                                                         CDL018
     C                   PARM                    @INKC                                        CDL018
     C                   PARM                    @INKL                                        CDL018
      *                                                                                       CDL018
      * Payment - Further Settle instructions - File format                                   CDL018
     C                   PARM                    #FPAYF                                       CDL018
      *                                                                                       CDL018
      * Receipt - Further Settle instructions - File format                                   CDL018
     C                   PARM                    #FRECF                                       CDL018
                                                                                              CDL018
     C                   ENDIF                                                                CDL018
                                                                                              CDL018
     C                   ENDIF                                                                CDL018
      *
     C/COPY WNCPYSRC,MMLDNISC43
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
     C     DDTYPE        OREQ      'FL'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
     C     DDTYPE        OREQ      'DP'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
     C     DDTYPE        OREQ      'LP'                                                       CDL006
     C     CDL006        ANDEQ     'Y'                                                        CDL006
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
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVE      IKPSTM        FLPSTM                                       CGL029
     C                   MOVE      IKPONS        FLPONS                                       CGL029
     C                   MOVEL     IKPAY         FLPAY
     C                   MOVEL     IKPOBR        FLPOBR
     C                   MOVEL     IKCVMR        FLCVMR
     C                   MOVEL     IKSTCY        FLPSCY
     C                   MOVEL     IKIC72        FLIC72
     C                   MOVEL     IKPMAC        FLPMAC                                       CDL018
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVE      IKRSTM        FLRSTM                                       CGL029
     C                   MOVE      IKRONS        FLRONS                                       CGL029
     C                   MOVEL     IKREC         FLREC
     C                   MOVEL     IKROBR        FLROBR
     C                   MOVEL     IKSTCY        FLRSCY
     C                   MOVEL     IKRMAC        FLRMAC                                       CDL018
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'                                          136433
      *
     C/COPY WNCPYSRC,MMH00032
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
     C/COPY WNCPYSRC,MMLDNISC48
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
      ** Deal Subtype                                                                         CSD095
     C                   PARM      DDSTYP        ##STYP            2                          CSD095
      ** Branch                                                                               CSD095
     C                   PARM      DDBRCA        ##BRCH            3                          CSD095
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
     C/COPY WNCPYSRC,MMH00033
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C/COPY WNCPYSRC,MMLDNISC04
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
     C/COPY WNCPYSRC,MMLDNISC05
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
     C                   MOVEL     FLPAY         IKPAY
     C                   MOVE      FLPONS        IKPONS                                       CGL029
     C                   MOVE      FLPSTM        IKPSTM                                       CGL029
     C                   MOVEL     FLPOBR        IKPOBR
     C                   MOVEL     FLCVMR        IKCVMR
     C                   MOVEL     FLPMAC        IKPMAC                                       CDL018
      ************                                                                     179510 200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        IKMOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      *
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVE      FLRSTM        IKRSTM                                       CGL029
     C                   MOVE      FLRONS        IKRONS                                       CGL029
     C                   MOVEL     FLREC         IKREC
     C                   MOVEL     FLROBR        IKROBR
     C                   MOVEL     FLRMAC        IKRMAC                                       CDL018
      *
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        IKMORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
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
     C                   MOVE      *ALL'Y'       MMELDN
      *
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                                      CDL007
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    MMELDN
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC64
     C                   PARM      'N'           RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNISC38
      *                                                                                       CDL016
      * Validate second screen if feature is on and Fixed Deposit Deal                        CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     CDL019        OREQ      'Y'                                                        CDL019
     C     CDL020        OREQ      'Y'                                                        CDL020
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
      *                                                                                       CDL016
     C                   MOVE      *ALL'Y'       MMELDN2                                      CDL016
      *                                                                                       CDL016
     C                   CALLB     'MMLDNIVL2'                                                CDL016
     C                   PARM                    RespMode                                     CDL016
     C                   PARM                    NwDlScnFmt                                   CDL016
     C                   PARM                    InfData                                      CDL016
     C                   PARM      IKSTCY        @@RSCY                                       CDL016
     C                   PARM      IKRSTM        @@RSTM                                       CDL016
     C                   PARM      IKRONS        @@RONS                                       CDL016
     C                   PARM      IKSTCY        @@PSCY                                       CDL016
     C                   PARM      IKPSTM        @@PSTM                                       CDL016
     C                   PARM      IKPONS        @@PONS                                       CDL016
     C                   PARM      IKFRNT        @@FRNT                                       CDL016
     C                   PARM                    ExtData                                      CDL016
     C                   PARM                    MMELDN2                                      CDL016
     C                   PARM                    FldNameArr                                   CDL016
     C                   PARM                    MsgIdArr                                     CDL016
     C                   PARM                    MsgDtaArr                                    CDL016
     C                   PARM                    Idx                                          CDL016
     C                   PARM                    WFldNamArr                                   CDL016
     C                   PARM                    WMsgIdArr                                    CDL016
     C                   PARM                    WMsgDtaArr                                   CDL016
     C                   PARM                    WIdx                                         CDL016
     C                   PARM                    NwDlFilFmt                                   CDL016
     C                   PARM      'N'           RepoFlag                                     CDL016
     C                   PARM                    CDL016                                       CDL016
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
     C                   PARM                    CAS005                                       CDL033
     C                   PARM                    CDL033                                       CDL033
     C                   PARM      IKINTR        SRate            11 7                        CDL033
                                                                                              CDL020
      * Recalculate Total Interest here so that it can be shown on the                        CDL020
      * confirmation screen and updated on the file without being validated.                  CDL020
                                                                                              CDL020
     C     CDL020        IFEQ      'Y'                                                        CDL020
                                                                                              CDL020
     C                   CALLB     'ZACTOTINT'                                                CDL020
     C                   PARM      *BLANKS       ReturnCode                                   CDL020
     C                   PARM                    MSG1              7                          CDL020
     C                   PARM                    DDACTN                                       CDL020
     C                   PARM                    MSGDATA          45                          CDL020
     C                   PARM                    IKMTTI                                       CDL020
     C                   PARM                    DDTOTI                                       CDL020
     C                   PARM                    S01468                                       CDL020
     C                   PARM                    DDNTCE                                       CDL020
     C                   PARM                    DDTYPE                                       CDL020
     C                   PARM                    IKINTR                                       CDL020
     C                   PARM                    IKAMNP                                       CDL020
     C                   PARM                    DDICMT                                       CDL020
     C                   PARM                    IKDVSD                                       CDL020
     C                   PARM      'Y'           DDCcyOK           1                          CDL020
     C                   PARM                    IKCYDP                                       CDL020
     C                   PARM      'Y'           DDVDatOK          1                          CDL020
     C                   PARM      'Y'           DDNtceOK          1                          CDL020
     C                   PARM      'Y'           DDAMNPOK          1                          CDL020
     C                   PARM      'Y'           DDBsRCOK          1                          CDL020
     C                   PARM      'Y'           DDSpRtOK          1                          CDL020
     C                   PARM      'Y'           DDICMTOK          1                          CDL020
     C                   PARM                    DDMDAT                                       CDL020
     C                   PARM                    IKMATD                                       CDL020
     C                   PARM      'Y'           DDMDatOK          1                          CDL020
     C                   PARM                    IKNTCE                                       CDL020
     C                   PARM                    DDFLID                                       CDL020
     C                   PARM                    DDRDFC                                       CDL020
     C                   PARM                    BNDCSP                                       CDL020
      *                                                                                       CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *                                                                                       258601
     C     Idx           IFNE      *ZERO                                                      258601
     C                   EXSR      SFDS@M                                                     258601
     C                   EXSR      SFKS@M                                                     258601
     C                   MOVEL     'Y'           ERRFSR            1                          258601
     C                   ELSE                                                                 258601
     C                   MOVEL     'N'           @EKYFD                                       258601
     C                   MOVEL     'N'           @EDTFD                                       258601
     C                   MOVEL     'N'           @EINKG                                       258601
     C                   MOVEL     'N'           @EINKH                                       258601
     C                   MOVEL     'N'           @EINKJ                                       258601
     C                   MOVEL     'N'           @EINKN                                       258601
     C                   MOVEL     'N'           @EINKP                                       258601
     C                   MOVEL     'N'           ERRFSR                                       258601
     C                   END                                                                  258601
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
     C/COPY WNCPYSRC,MMLDNISC65
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS                                       CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
     C/COPY WNCPYSRC,MMH00099
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
     C**********         PARM      'N'           @EKYFD                                       258601
     C                   PARM                    @EKYFD                                       258601
     C**********         PARM      'N'           @EDTFD                                       258601
     C                   PARM                    @EDTFD                                       258601
      *
      * ENABLED FUNCTION KEYS
     C**********         PARM      'N'           @EINKG                                       258601
     C                   PARM                    @EINKG                                       258601
     C**********         PARM      'N'           @EINKH                                       258601
     C                   PARM                    @EINKH                                       258601
     C**********         PARM      'N'           @EINKJ                                       258601
     C                   PARM                    @EINKJ                                       258601
     C**********         PARM      'N'           @EINKN                                       258601
     C                   PARM                    @EINKN                                       258601
     C**********         PARM      'N'           @EINKP                                       258601
     C                   PARM                    @EINKP                                       258601
     C                   PARM      'N'           @EINKT
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNISIN '  CPGM             10                          CAP067
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT                                        CDL016
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'N'           RepoFlag          1                          176883
     C/COPY WNCPYSRC,MMLDNISC29
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDN
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
     C     ERRFSR        CASEQ     'Y'           VAL@M                                        258601
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
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
     C/COPY WNCPYSRC,MMLDNISC50
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
                                                                                              CDL006
      ** Call the appropriate module to get the next deal number                              CDL006
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
     C                   PARM      *ZERO         PDealNo                                      CDL006
     C                   Z-ADD     PDealno       IKDN38                                       CDL006
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
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   END
     C                   MOVEL     DDDLNO        @SIDN
     C                   END
      *
     C/COPY WNCPYSRC,MMLDNISC49
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        IKDN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IKLACT
     C/COPY WNCPYSRC,MMH00100
      *                                                                                       CDL016
      * Update Valid Deal: Blocked Indicator                                                  CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     BUACT         IFEQ      'B'                                                        CDL016
     C                   MOVE      'Y'           IKBLKA                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C     BUACT         IFEQ      'U'                                                        CDL016
     C     DDACTN        OREQ      'I'                                                        CDL016
     C                   MOVE      'N'           IKBLKA                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
     C                   PARM      *BLANKS       PBFRCD          100                          CDL033
     C                   PARM      *BLANKS       PAFRCD          100                          CDL033
     C/COPY WNCPYSRC,MMLDNISC39
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNISC40
     C                   END
      *                                                                                       CDL018
      ** Update Further Settlement Instructions if no Errors                                  CDL018
     C     @RTCD         IFEQ      *BLANK                                                     CDL018
     C     CDL018        ANDEQ     'Y'                                                        CDL018
     C                   MOVE      IKDN38        ##DLNO                                       CDL018
     C                   CALLB     'ZAFSETIUPD'                                               CDL018
     C                   PARM                    @RTCD                                        CDL018
     C                   PARM                    ##DLNO                                       CDL018
     C                   PARM                    FLRMAC                                       CDL018
     C                   PARM                    FLPMAC                                       CDL018
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
     C                   ENDIF                                                                CDL018
                                                                                              CDL006
     ** Update the database of the fiduciary takings for the associated                       CDL006
     ** fiduciary placings.                                                                   CDL006
                                                                                              CDL006
     C     CDL006        IFEQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'FL'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'DP'                                                       CDL006
     C     CDL006        OREQ      'Y'                                                        CDL006
     C     DDTYPE        ANDEQ     'LP'                                                       CDL006
     C                   MOVE      DDDLNO        PDealNo                                      CDL006
     C                   CALLB     'MMFIDTUPF'                                                CDL006
     C                   PARM      'MMLDNISIN'   PProgram         10                          CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    PDealNo           6 0                        CDL006
     C                   PARM                    PLinkDealNo       6 0                        CDL006
     C                   PARM                    FOTRID                                       209905
     C                   PARM                    @RTCD                                        CDL006
     C                   ENDIF                                                                CDL006
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,MMLDNISC06
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
     C                   MoveL     *BLANK        DDCSTS                                       CGL011
     C                   MoveL     *BLANK        BUACT                                        CGL016
     C/COPY WNCPYSRC,MMLDNISC66
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS004
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS004
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS004
     C/COPY WNCPYSRC,MMH00101
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
     C/COPY WNCPYSRC,MMLDNISC30
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
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *
     C                   MOVEL     'T'           @SCRN
     C/COPY WNCPYSRC,MMLDNISC01
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL006
      *****************************************************************                       CDL006
      *  SCRN@F - Fiduciary transactions processing.                                          CDL006
      *****************************************************************                       CDL006
     C     SCRN@F        BEGSR                                                                CDL006
                                                                                              CDL006
      ** ------------------- **                                                               CDL006
      ** Fiduciary Placings  **                                                               CDL006
      ** ------------------- **                                                               CDL006
                                                                                              CDL006
      ** Insert or Enquiry                                                                    CDL006
      ** Display associated fiduciary takings of the fiduciary placing                        CDL006
                                                                                              CDL006
     C     DDACTN        IFEQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'FL'                                                       CDL006
     C     DDACTN        OREQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'DP'                                                       CDL006
     C     DDACTN        OREQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'LP'                                                       CDL006
     C     DDACTN        OREQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'FL'                                                       CDL006
     C     DDACTN        OREQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'DP'                                                       CDL006
     C     DDACTN        OREQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'LP'                                                       CDL006
     C                   CALLB     'MMFIDTSFL'                                                CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    DDDLNO                                       CDL006
     C                   PARM      IKLNKN        PLNKN             6 0                        CDL006
     C**********         PARM      IKCNUM        PCNUM             6 0                 CDL006 CSD027
     C                   PARM      IKCNUM        PCNUM             6                          CSD027
     C                   PARM                    IKCCY                                        CDL006
     C                   PARM      IKAMNP        PAMNP            15 0                        CDL006
     C                   PARM      IKINTR        PINTR            11 7                        CDL006
     C                   PARM      IKDDND        PDDND             5 0                        CDL006
     C                   PARM      IKDVSD        PVDAT             5 0                        CDL006
     C                   PARM      IKMATD        PMDAT             5 0                        CDL006
     C                   PARM      IKNTCE        PNTCE             3 0                        CDL006
     C                   PARM                    IKTYPE                                       CDL006
     C                   PARM                    IKSTYP                                       CDL006
     C                   PARM                    IKBRCA                                       CDL006
     C                   PARM      DDNTCE        PDDNTCE           3                          CDL006
     C                   PARM      DDMDAT        PDDMDAT           6                          CDL006
     C                   PARM                    NwDlFilFmt                                   CDL006
     C                   PARM                    Inv_FIDT                                     209905
     C                   PARM      *BLANKS       PFrontId1                                    209905
     C                   PARM      *BLANKS       PFrontId2                                    209905
     C                   PARM      *BLANKS       PAsocId                                      209905
     C                   PARM      'N'           PProtect                                     209905
     C                   PARM      *BLANKS       PReturnCode       7                          CDL006
     C                   PARM      IKFTST        PFTST             1                          CDL006
     C                   PARM      IKFRN1        PFRN1            60                          CDL006
     C                   PARM      IKFRN2        PFRN2            60                          CDL006
     C                   PARM      IKFRN3        PFRN3            60                          CDL006
     C                   PARM      IKFRN4        PFRN4            60                          CDL006
                                                                                              CDL006
      ** Move default values for charges                                                      CDL006
                                                                                              CDL006
     C                   MOVE      *BLANKS       IKFCGC                                       CDL006
     C                   MOVE      *BLANKS       IKFCGD                                       CDL006
     C                   Z-ADD     0             IKFCGA                                       CDL006
     C                   Z-ADD     0             IKFCGT                                       CDL006
                                                                                              CDL006
      ** Move default values for commissions                                                  CDL006
                                                                                              CDL006
     C                   MOVE      *BLANKS       IKFCMC                                       CDL006
     C                   MOVE      *BLANKS       IKFCMD                                       CDL006
     C                   Z-ADD     0             IKFCMA                                       CDL006
     C                   Z-ADD     0             IKFCMT                                       CDL006
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** ----------------- **                                                                 CDL006
      ** Fiduciary Takings **                                                                 CDL006
      ** ----------------- **                                                                 CDL006
                                                                                              CDL006
      ** Insert or Amend                                                                      CDL006
                                                                                              CDL006
     C     DDACTN        IFEQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'FT'                                                       CDL006
     C     DDACTN        OREQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'DT'                                                       CDL006
     C     DDACTN        OREQ      'I'                                                        CDL006
     C     DDTYPE        ANDEQ     'LT'                                                       CDL006
     C     DDACTN        OREQ      'A'                                                        CDL006
     C     DDTYPE        ANDEQ     'FT'                                                       CDL006
     C     DDACTN        OREQ      'A'                                                        CDL006
     C     DDTYPE        ANDEQ     'DT'                                                       CDL006
     C     DDACTN        OREQ      'A'                                                        CDL006
     C     DDTYPE        ANDEQ     'LT'                                                       CDL006
                                                                                              CDL006
      ** Validate trust agreement status                                                      CDL006
                                                                                              CDL006
     C     DDTYPE        IFEQ      'LT'                                                       CDL006
     C                   MOVE      DDDLNO        PDealNo                                      CDL006
     C**********         Z-ADD     IKCNUM        PCNUM                                 CDL006 CSD027
     C                   EVAL      PCNUM = IKCNUM                                             CSD027
     C                   CALLB     'MMFIDTSTS'                                                CDL006
     C                   PARM      'MMLDNISIN'   PProgram                                     CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    PDealNo                                      CDL006
     C                   PARM                    PCNUM                                        CDL006
     C                   PARM                    IKFTST                                       CDL006
     C                   PARM                    IKFRN1                                       CDL006
     C                   PARM                    IKFRN2                                       CDL006
     C                   PARM                    IKFRN3                                       CDL006
     C                   PARM                    IKFRN4                                       CDL006
     C                   PARM      'N'           PProtect                                     CDL006
     C                   PARM      *BLANKS       PReturnCode                                  CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** Access customer file to get charge/commission details                                CDL006
                                                                                              CDL006
     C     BNCHTK        IFEQ      'Y'                                                        CDL006
     C     BNCOTK        OREQ      'Y'                                                        CDL006
     C                   CALLB     'AOCUSTR1'                                                 CDL006
     C                   PARM      *BLANKS       WRTCD             7                          CDL006
     C                   PARM      '*KEY   '     WOPTN             7                          CDL006
     C                   PARM      DDCUST        WKEY1            10                          CDL006
     C                   PARM      *BLANKS       WKEY2             7                          CDL006
     C     SDCUST        PARM      SDCUST        DSLDY                                        CDL006
     C     WRTCD         IFNE      *BLANKS                                                    CDL006
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CDL006
     C                   Z-ADD     5             DBASE                                        CDL006
     C                   MOVEL     WKEY1         DBKEY                                        CDL006
     C                   EXSR      *PSSR                                                      CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** Set up charges fields on MMVLDNIPD for database update                               CDL006
                                                                                              CDL006
     C     PReturnCode   IFEQ      *BLANKS                                                    CDL006
     C     BNCHTK        ANDEQ     'Y'                                                        CDL006
                                                                                              CDL006
     C     BBCHRG        IFEQ      *BLANKS                                                    CDL006
     C                   MOVE      *BLANKS       IKFCGC                                       CDL006
     C                   ELSE                                                                 CDL006
     C     BBCHRG        CHAIN     SDCCGRL1                           20                      CDL006
     C     *IN20         IFEQ      *ON                                                        CDL006
     C                   MOVE      *BLANKS       IKFCGC                                       CDL006
     C                   ELSE                                                                 CDL006
     C                   MOVE      DDDLNO        PDealNo                                      CDL006
     C                   Z-ADD     IKAMNP        PAMNP13                                      CDL006
     C                   CALLB     'MMFIDTCHG'                                                CDL006
     C                   PARM      'MMLDNISIN'   PProgram                                     CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    PDealNo                                      CDL006
     C                   PARM      IKCNUM        PCNUM                                        CDL006
     C                   PARM                    IKCCY                                        CDL006
     C                   PARM                    PAMNP13                                      CDL006
     C                   PARM      CCCHOD        IKFCGC                                       CDL006
     C                   PARM                    IKFCGD                                       CDL006
     C                   PARM      IKFCGA        PFCGA            13 0                        CDL006
     C                   PARM      *BLANKS       PReturnCode                                  CDL006
     C     PReturnCode   IFEQ      *BLANKS                                                    CDL006
     C                   Eval      IKFCGA = PFCGA                                             CDL006
     C                   Eval      IKFCGT = 0                                                 CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
     C     IKFCGC        IFEQ      *BLANKS                                                    CDL006
     C                   MOVE      *BLANKS       IKFCGD                                       CDL006
     C                   Z-ADD     0             IKFCGA                                       CDL006
     C                   Z-ADD     0             IKFCGT                                       CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** Set up commission fields on MMVLDNIPD for database update                            CDL006
     C/COPY WNCPYSRC,MMLDNISC45
                                                                                              CDL006
     C     PReturnCode   IFEQ      *BLANKS                                                    CDL006
     C     BNCOTK        ANDEQ     'Y'                                                        CDL006
     C                                                                                        CDL006
     C     BBCOMG        IFEQ      *BLANKS                                                    CDL006
     C                   MOVE      *BLANKS       IKFCMC                                       CDL006
     C                   ELSE                                                                 CDL006
     C     BBCOMG        CHAIN     SDCCGRL1                           20                      CDL006
     C     *IN20         IFEQ      *ON                                                        CDL006
     C                   MOVE      *BLANKS       IKFCMC                                       CDL006
     C                   ELSE                                                                 CDL006
     C                   MOVE      DDDLNO        PDealNo                                      CDL006
     C                   Z-ADD     IKAMNP        PAMNP                                        CDL006
     C                   CALLB     'MMFIDTCOM'                                                CDL006
     C                   PARM      'MMLDNISIN'   PProgram                                     CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    PDealNo                                      CDL006
     C                   PARM      IKCNUM        PCNUM                                        CDL006
     C                   PARM                    IKCCY                                        CDL006
     C                   PARM                    IKTYPE                                       CDL006
     C                   PARM      IKMATD        PMDAT                                        CDL006
     C                   PARM      IKVDDD        PVDDD             2 0                        CDL006
     C                   PARM      IKVDMM        PVDMM             2 0                        CDL006
     C                   PARM      IKVDYY        PVDYY             2 0                        CDL006
     C                   PARM                    IKRDFC                                       CDL006
     C                   PARM                    IKICMT                                       CDL006
     C                   PARM                    PAMNP                                        CDL006
     C                   PARM      CCCCOD        IKFCMC                                       CDL006
     C                   PARM                    IKFCMD                                       CDL006
     C                   PARM      IKFCMA        PFCMA            13 0                        CDL006
     C                   PARM      *BLANKS       PReturnCode       7                          CDL006
     C     PReturnCode   IFEQ      *BLANKS                                                    CDL006
     C                   Eval      IKFCMA = PFCMA                                             CDL006
     C                   Eval      IKFCMT = 0                                                 CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
     C     IKFCMC        IFEQ      *BLANKS                                                    CDL006
     C                   MOVE      *BLANKS       IKFCMD                                       CDL006
     C                   Z-ADD     0             IKFCMA                                       CDL006
     C                   Z-ADD     0             IKFCMT                                       CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C/COPY WNCPYSRC,MMLDNISC46
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** Enquiry                                                                              CDL006
                                                                                              CDL006
     C     DDACTN        IFEQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'FT'                                                       CDL006
     C     DDACTN        OREQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'DT'                                                       CDL006
     C     DDACTN        OREQ      'E'                                                        CDL006
     C     DDTYPE        ANDEQ     'LT'                                                       CDL006
     C                   MOVE      DDDLNO        PDealNo                                      CDL006
     C                   CALLB     'MMFIDTENQ'                                                CDL006
     C                   PARM      'MMLDNISIN'   PProgram                                     CDL006
     C                   PARM                    DDACTN                                       CDL006
     C                   PARM                    PDealNo                                      CDL006
     C                   PARM                    IKTYPE                                       CDL006
     C                   PARM      IKCNUM        PCNUM                                        CDL006
     C                   PARM                    IKCCY                                        CDL006
     C                   PARM      IKAMNP        PAMNP13          13 0                        CDL006
     C                   PARM      IKINTR        PINTR                                        CDL006
     C                   PARM      IKDDND        PDDND                                        CDL006
     C                   PARM      IKDVSD        PVDAT                                        CDL006
     C                   PARM      IKMATD        PMDAT                                        CDL006
     C                   PARM      IKNTCE        PNTCE                                        CDL006
     C                   PARM                    IKFCGC                                       CDL006
     C                   PARM                    IKFCGD                                       CDL006
     C                   PARM      IKFCGA        PFCGA                                        CDL006
     C                   PARM      IKFCGT        PFCGT             9 0                        CDL006
     C                   PARM                    IKFCMC                                       CDL006
     C                   PARM                    IKFCMD                                       CDL006
     C                   PARM      IKFCMA        PFCMA                                        CDL006
     C                   PARM      IKFCMT        PFCMT             9 0                        CDL006
     C                   PARM                    IKFTST                                       CDL006
     C                   PARM                    IKFRN1                                       CDL006
     C                   PARM                    IKFRN2                                       CDL006
     C                   PARM                    IKFRN3                                       CDL006
     C                   PARM                    IKFRN4                                       CDL006
     C                   PARM      *BLANKS       PReturnCode                                  CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
      ** ---------------------- **                                                            CDL006
      ** Return code processing **                                                            CDL006
      ** ---------------------- **                                                            CDL006
                                                                                              CDL006
     C     PReturnCode   IFNE      *BLANKS                                                    CDL006
                                                                                              CDL006
     C                   SELECT                                                               CDL006
     C     PReturnCode   WHENEQ    'Y2U9999'                                                  CDL006
     C                   EXSR      ENDP                                                       CDL006
     C     PReturnCode   WHENEQ    'USR0790'                                                  CDL006
     C                   MOVE      'M'           @SCRN                                        CDL006
     C                   OTHER                                                                CDL006
     C                   ENDSL                                                                CDL006
                                                                                              CDL006
     C                   ELSE                                                                 CDL006
                                                                                              CDL006
     C     DDACTN        IFEQ      'E'                                                        CDL006
     C                   SELECT                                                               CDL006
     C     BGWDPR        WHENEQ    'Y'                                                        CDL006
     C                   MOVE      'W'           @SCRN                                        CDL006
     C     @RDNB         WHENEQ    'Y'                                                        CDL006
     C                   MOVE      'R'           @SCRN                                        CDL006
     C                   ENDSL                                                                CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C     DDACTN        IFEQ      'I'                                                        CDL006
     C     DDACTN        OREQ      'A'                                                        CDL006
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C     BGWDPR        IFEQ      'Y'                                                        CDL006
     C                   MOVE      'W'           @SCRN                                        CDL006
     C                   ELSE                                                                 CDL006
     C                   MOVE      'S'           @SCRN                                        CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL006
     C                   ENDIF                                                                CDL033
                                                                                              CDL006
     C                   ENDIF                                                                CDL006
                                                                                              CDL006
     C                   ENDSR                                                                CDL006
      *****************************************************************                       CDL006
      /EJECT                                                                                  CDL006
      *****************************************************************                       CDL033
     C     SRSched       BEGSR                                                                CDL033
                                                                                              CDL033
     C                   IF        DDDLNO = *BLANK                                            CDL033
     C                   CALLB     'CAGETNXTDL'                                               CDL033
     C                   PARM      *BLANKS       RTNCD             7                          CDL033
     C                   PARM      *BLANKS       PMessage                                     CDL033
     C                   PARM                    WDLNO             6                          CDL033
     C                   PARM      *ZEROS        W2DLNO            6 0                        CDL033
     C                   IF        PMessage <> *BLANKS                                        CDL033
     C                   EVAL      DBFILE = 'CAGTNXDL'                                        CDL033
     C                   EVAL      DBASE = 102                                                CDL033
     C                   EVAL      DBKEY = DDDLNO                                             CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   IF        DDDLNO <> *BLANKS                                          CDL033
     C                   MOVE      DDDLNO        DLNO                                         CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      WDLNO         DLNO                                         CDL033
     C                   EVAL      DDDLNO =  WDLNO                                            CDL033
     C                   ENDIF                                                                CDL033
     C                   MOVE      IKMATD        MaturityDate                                 CDL033
     C                   MOVE      IKDVSD        ValueDate                                    CDL033
     C                   CALLB     'MMLDNICHD'                                                CDL033
     C                   PARM      *BLANKS       RTNCD                                        CDL033
     C                   PARM      DDACTN        Mode                                         CDL033
     C                   PARM                    NwDlScnFmt                                   CDL033
     C                   PARM      DLNO          PDealNo                                      CDL033
     C                   PARM      DDCCY         PCurrency                                    CDL033
     C                   PARM                    MaturityDate                                 CDL033
     C                   PARM                    ValueDate                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      *BLANKS       WErrMsgID                                    CDL033
     C                   IF        WErrMsgID <> *BLANKS                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   SELECT                                                               CDL033
      *                                                                                       CDL033
      ** Exit the screen                                                                      CDL033
     C                   WHEN      RTNCD = 'Y2U9999'                                          CDL033
     C                   EXSR      ENDP                                                       CDL033
      *                                                                                       CDL033
      ** Previous screen                                                                      CDL033
     C                   WHEN      RTNCD = 'USR0790'                                          CDL033
     C                   EVAL      @SCRN = 'N'                                                CDL033
                                                                                              CDL033
     C                   WHEN      RTNCD = *BLANKS                                            CDL033
     C                   IF        BGWDPR = 'Y'                                               CDL033
     C                   EVAL      @SCRN = 'W'                                                CDL033
     C                   ELSEIF    DDACTN = 'E'                                               CDL033
     C                   EVAL      @SCRN = 'W'                                                CDL033
     C                   ELSEIF    @RDNB = 'Y'                                                CDL033
     C                   EVAL      @SCRN = 'R'                                                CDL033
     C                   ELSE                                                                 CDL033
     C                   EVAL      @SCRN = 'M'                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
     C/COPY WNCPYSRC,MMLDNISC41
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNISIN'   DBPGM
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
                                                                                              CDL006
      ** Access Dealing ICD and SAR files                                                     CDL006
                                                                                              CDL006
     C                   CALLB     'MMFIDINIT'                                                CDL006
     C                   PARM      *BLANKS       @RTCD                                        CDL006
     C     @RTCD         IFEQ      *BLANKS                                                    CDL006
     C                   OPEN      SDCCGRL1                                                   CDL006
     C                   ENDIF                                                                CDL006
      *                                                                                       CDL020
      ** Access Dealing details via access program                                            CDL020
      *  (database error handling done in access program)                                     CDL020
     C**********         CALLB     'AODEALR0'                                          CDL020 CAS011
     C                   CALLB     'AODEALR1'                                                 CAS011
     C                   PARM      '*DBERR '     @RTCD             7                          CDL020
     C                   PARM      '*FIRST '     @OPTN             7                          CDL020
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                 CDL020 CAS011
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CAS011
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Automatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD             7                          CDL016
     C                   Parm      '*VERIFY'     POPTN             7                          CDL016
     C                   Parm      'CDL016'      PSARD             6                          CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Eval      BUACT = *Blanks                                            CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL018
      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
                                                                                              CDL018
     C                   CallB     'AOSARDR0'                                                 CDL018
     C                   Parm      *Blanks       PRTCD                                        CDL018
     C                   Parm      '*VERIFY'     POPTN                                        CDL018
     C                   Parm      'CDL018'      PSARD                                        CDL018
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
      *                                                                                       CDL018
     C                   Move      'N'           CDL018            1                          CDL018
     C                   If        PRTCD = *Blanks                                            CDL018
     C                   Eval      CDL018 = 'Y'                                               CDL018
     C                   Endif                                                                CDL018
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       PRTCD                                        CDL019
     C                   Parm      '*VERIFY'     POPTN                                        CDL019
     C                   Parm      'CDL019'      PSARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        PRTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
                                                                                              CDL020
      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
      ** (Apply Base Rate at Value Date)                                                      CDL020
                                                                                              CDL020
     C                   CallB     'AOSARDR0'                                                 CDL020
     C                   Parm      *Blanks       PRTCD                                        CDL020
     C                   Parm      '*VERIFY'     POPTN                                        CDL020
     C                   Parm      'CDL020'      PSARD                                        CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C                   Move      'N'           CDL020            1                          CDL020
     C                   If        PRTCD = *Blanks                                            CDL020
     C                   Eval      CDL020 = 'Y'                                               CDL020
     C                   Endif                                                                CDL020
      *                                                                                       CDL020
      ** Access SAR details file to determine if S01468 (changed                              CDL020
      ** validation for total interest field) is on.                                          CDL020
      *                                                                                       CDL020
     C                   CALLB     'AOSARDR0'                                                 CDL020
     C                   PARM      *BLANKS       @RTCD                                        CDL020
     C                   PARM      '*VERIFY'     @OPTN                                        CDL020
     C                   PARM      'S01468'      @SARD             6                          CDL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C     @RTCD         IFEQ      *BLANK                                                     CDL020
     C                   MOVEL     'Y'           S01468            1                          CDL020
     C                   ELSE                                                                 CDL020
     C                   MOVEL     'N'           S01468                                       CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 903                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033 is switched on                        CDL033
      *                                                                                       CDL033
     C                   CallB     'AOSARDR0'                                                 CDL033
     C                   Parm      *Blanks       PRTCD                                        CDL033
     C                   Parm      '*VERIFY'     POPTN                                        CDL033
     C                   Parm      'CDL033'      PSARD                                        CDL033
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C                   Move      'N'           CDL033            1                          CDL033
     C                   If        PRTCD = *Blanks                                            CDL033
     C                   Eval      CDL033 = 'Y'                                               CDL033
     C                   Endif                                                                CDL033
                                                                                              CDL033
      ** Verify if Hedge Accounting Enhancement is on.                                        CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CAS005'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      @RTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CAS005            1                          CDL033
     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 904                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CAS005                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
     C/COPY WNCPYSRC,MMLDNISC47
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

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIS010

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
