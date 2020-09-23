     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid loans/deposits repair')               *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIRPR - Invalid Loans/Deposits Repair                    *
      *                                                               *
      *  Function:  This function allows invalid loans/deposits to be *
      *             'repaired' and applied to the Midas database.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD031031           Date 24Feb15               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244036             Date 22Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG9877            Date 12Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7220            Date 18May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2876            Date 28May04               *
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
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 196380             Date 15May02               *
      *                 192916             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192530             Date 15May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 174857             Date 23Feb00               *
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 17Feb00               *
      *                 CSE006             DATE 14Feb00               *
      *                 CAP051             DATE 10Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP014             Date 10Dec99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      *                 163820             Date 12Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             DATE 09Mar99               *
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 24Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031031 - F1DLNO missing in DLDLDnQD file for LDNI, NASP,   *
      *             NASS, FRA, CIRS and SIRS. Write to extension file *
      *             whether CLE025 is *ON or *OFF.                    *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
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
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  244036 - Missing deals in extension file DLDLDCQD (done from *
      *           Java layer).                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9877 - Missing parameters in call to MMLDNIDS2            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG7220- Recompile due to changes in MMILDNIPD.              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIR010,MMLDNIRC11,MMLDNIRC12,*
      *                              MMLDNIRC13,                      *
      *           Core hooks added:  MMLDNIPC19                       *
      *  BUG2876- Parameter mismatch in MMLDNIDSP caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  192916 - Rollback of window updates wrongly managed in Core  *
      *           API's modules RPR and SIN.                          *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510                                  *
      *  192530 - Pass the correct date to ZASETINSIN.                *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  174857 - Program name passed to WN0010 is SIN instead of RPR *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to MMLDNIDSP and also ZASETINDFT.                   *
      *  CGL011 - Collateral Processing for Midas - new parameter     *
      *           on CALLB to MMLDNICVT.                              *
      *  CSE006 - Addition of Repos flag parameter to MMLDNIVAL calls.*
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the     *
      *           transaction and convert it into a another           *
      *           Midas Deal.                                         *
      *  163820 - Transactions Repair Function performs SPF checking  *
      *           to find if user is authorised to the Branch , but   *
      *           does that against User's Default Branch code instead*
      *           of the selected transaction's Booking/Origin branch *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - APIs Phase 3.                                       *
      *           - Add extra parm for Extra Data                     *
      *           - Change definition of MSGTYPE to be based on file  *
      *             field                                             *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FMMILDNIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMILDNID0 : MMILDNIX0)
     FMMILDNIL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              209905
     FMMIFIDTL1 IF   E           K DISK    INFSR(*PSSR)                                       209905
     F                                     RENAME(MMIFIDTD0 : MMIFIDTX0)                      209905
     FMMIFIDTL0 UF   E           K DISK    INFSR(*PSSR)                                       209905
     F                                     COMMIT                                             209905
 
      ** API Invalid log file by Type/FO Id/Time                                              CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
     FSDCCGRL1  IF   E           K DISK    INFSR(*PSSR)                                       209905
                                                                                              209905
     FDLIFRSCL1 UF   E           K DISK    INFSR(*PSSR)                                       CDL033
     F                                     COMMIT                                             CDL033
                                                                                              CDL033
     FDLIFRSCL0 IF   E           K DISK    INFSR(*PSSR)                                       CDL033
     F                                     RENAME(DLIFRSCD0 : DLIFRSCX0)                      CDL033
                                                                                              CDL033
     FMMILDLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(MMILDLXD6:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      ** Midas DL Money Market & Loans Deals Extension Details.                               244036
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       244036
     F                                     IGNORE(DLDLDBD0)                                   244036
     F                                     IGNORE(DLDLDGD0)                                   244036
                                                                                              244036
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMLDNIR009
 
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
 
     D @EI             S              1    DIM(60)
     D***Inv_FIDT        S             42    DIM(99)                                   209905 CGL029
     D Inv_FIDT        S             48    DIM(99)                                            CGL029
 
 
     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
     D***HKREC**              456    524                                               CAP011 CGL029
     D***HKPAY**              525   1083                                               CAP011 CGL029
     D  HKREC                470    524                                                       CGL029
     D  HKPAY                539   1083                                                       CGL029
     D**HKRECEx*            1741   1758                                                CGL029 CDL033
     D**HKPAYEx*            1759   1776                                                CGL029 CDL033
     D  HKRECEx             1756   1773                                                       CDL033
     D  HKPAYEx             1774   1791                                                       CDL033
 
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
     D**IKRECEx*            1741   1758                                                CGL029 CDL033
     D**IKPAYEx*            1759   1776                                                CGL029 CDL033
     D  IKRECEx             1756   1773                                                       CDL033
     D  IKPAYEx             1774   1791                                                       CDL033
 
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * New Deal in Screen Format
                                                                                              CER001
      ** New Deal in File Format (#6LXVL)                                                     CER001
     D NwDlFilFmtLux E DS                  EXTNAME(MMVLDLX1PD)                                CER001
                                                                                              CER001
      ** Current Deal in File Format (VL)                                                     CER001
     D CrDlFilFmtLux E DS                  EXTNAME(MMDLX1L0)                                  CER001
                                                                                              CER001
      ** Screen Format - LUX                                                                  CER001
     D NwDlScnFmtLux E DS                  EXTNAME(MMLDRXPD)                                  CER001
                                                                                              CER001
     D/COPY WNCPYSRC,MMLDNIR013
 
     D MMELDNI       E DS                  EXTNAME(MMELDNIPD)
      * Error indicators
                                                                                              CDL016
     D MMELDNI2      E DS                  EXTNAME(MMELDN2PD)                                 CDL016
      * Error indicators screen 2                                                             CDL016
                                                                                              209905
     D MMInvFIDT     E DS                  EXTNAME(MMIFIDTPD)                                 209905
      ** Invalid Fiduciary Taking Transaction                                                 209905
 
 
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
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
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
 
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
      ** File - Payment Further Settlement Instructions                                       CDL018
                                                                                              CDL018
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
      ** File - Receive Further Settlement Instructions                                       CDL018
                                                                                              CDL018
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
                                                                                              209905
     D WFIDTDTA        DS                                                                     209905
     D***WFIDTDTA1               1   3696                                              209905 CGL029
     D***WFIDTDTA2            3697   4158                                              209905 CGL029
     D WFIDTDTA1               1   4224                                                       CGL029
     D WFIDTDTA2            4225   4686                                                       CGL029
                                                                                              209905
     D WFIDTNAR        DS                                                                     209905
     D WFIDTNAR1               1     60                                                       209905
     D WFIDTNAR2              61    120                                                       209905
     D WFIDTNAR3             121    180                                                       209905
     D WFIDTNAR4             181    240                                                       209905
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
                                                                                              209905
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  209905
      ** External datastructure for dealing details                                           209905
                                                                                              209905
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  209905
      ** External data structure for customer details                                         209905
                                                                                              209905
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     209905
      ** Third DS for access programs, very long data structure                               209905
                                                                                CDL007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL007
      ** EXTERNAL DS FOR SAR DETAILS                                            CDL007
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
      *                                                                                       CER001
      ** External data structure for Currency Details file                                    CER001
      *                                                                                       CER001
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CER001
                                                                                              CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                CDL007
     D InfData       E DS                  EXTNAME(MMLDIFPD)                    CDL007
     D                                     PREFIX(IF_)                          CDL007
      * MM (LDNI) Extra Data - File (D/B) format                                CDL007
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                    CAP004
      * MM (LDNI) Extra Data - File (D/B) format                                CAP004
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CDL033
     D PIDTES          DS          3600                                                       CDL033
      ** Maximum of 600 elements of dates (6A)                                                CDL033
                                                                                              CDL033
     D PICONF          DS           600                                                       CDL033
      ** Maximum of 600 elements of Confirmed Holiday indicators (6A)                         CDL033
 
     D/COPY QWINDSRC,MMLDNISDTA
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
     D  L1FLD1                 1      6  0                                                    CER001
     D  L1DN38                 1      6                                                       CER001
     D  L1DLTP                 7      8                                                       CER001
     D  L1CNUM                 9     14                                                       CER001
     D  L1CCY                 15     17                                                       CER001
     D  L1AMNT                18     32  0                                                    CER001
     D  L1VDAT                33     38                                                       CER001
     D  L1MDAT                39     44                                                       CER001
     D  L1FOTR                45     64                                                       CER001
     D  L1TMST                65     90Z                                                      CER001
     D  #1DEXT                91     91                                                       CER001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
                                                                                CDL007
      **   Old Maturity Date                                                    CDL007
     D OLD_MATD        S              5P 0                                      CDL007
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('MMLDNIPD')
 
     D Field           S             10A   INZ('DDACTN')
     D FieldExt        S             10A   INZ('L6LXLUSU')                                    CER001
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
     D FldOffsetExt    S              5P 0                                                    CER001
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
      ** of the file field when the file field was changed.                     CAP004
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
                                                                                CAP004
     D CSC011          S              1A   INZ('N')                                           CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Work fields for 209905                                                               209905
     D CDL006          S              1A   IMPORT                                             209905
     D PDealNo         S              6P 0                                                    209905
     D PLinkDlno       S              6P 0                                                    209905
     D PMode           S              1A                                                      209905
     D PProgram        S             10A                                                      209905
     D Ix              S              3P 0                                                    209905
     D PAMNP13         S             13S 0                                                    209905
                                                                                              209905
      ** Fields used for call to MMFIDTSFL                                                    209905
     D PLNKN           S              6P 0                                                    209905
     D*PCNUM****       S              6P 0                                             209905 CSD027
     D PCNUM           S              6A                                                      CSD027
     D PAMNP           S             15P 0                                                    209905
     D PINTR           S             11P 7                                                    209905
     D PDDND           S              5P 0                                                    209905
     D PVDAT           S              5P 0                                                    209905
     D PMDAT           S              5P 0                                                    209905
     D PNTCE           S              3P 0                                                    209905
     D PDDNTCE         S              3A                                                      209905
     D PDDMDAT         S              3A                                                      209905
     D PReturnCode     S              7A                                                      209905
     D PFTST           S              1A                                                      209905
     D PFRN1           S             60A                                                      209905
     D PFRN2           S             60A                                                      209905
     D PFRN3           S             60A                                                      209905
     D PFRN4           S             60A                                                      209905
     D PFRONTID1       S             20A                                                      209905
     D PFRONTID2       S             20A                                                      209905
     D PProtect        S              1A                                                      209905
     D ACtr            S              3S 0                                                    209905
     D AStr            S              5S 0                                                    209905
                                                                                              209905
      ** Fields used for call to AOCUSTR1                                                     209905
     D WKEY1           S             10A                                                      209905
     D WKEY2           S              7A                                                      209905
                                                                                              209905
      ** Fields used for call to MMFIDTCHG                                                    209905
     D PFCGA           S             13P 0                                                    209905
                                                                                              209905
      ** Fields used for call to MMFIDTCOM                                                    209905
     D PVDDD           S              2P 0                                                    209905
     D PVDMM           S              2P 0                                                    209905
     D PVDYY           S              2P 0                                                    209905
     D PFCMA           S             13P 0                                                    209905
                                                                                              209905
     D DDTMESTMP       S             26Z                                                      CER001
     D DDFOTRANID      S             20                                                       CER001
     D WWERR           S              1                                                       CER001
     D WFIND           S              1                                                       CER001
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D ZFIELD          S             16                                                       CER001
     D ZADEC           S              1  0                                                    CER001
      ** Fields used to call CAGETNXTDL                                                       CDL033
     D PMessage        S              7A                                                      CDL033
     D WDLNO           S              6A                                                      CDL033
     D W2DLNO          S              6S 0                                                    CDL033
      *                                                                                       CDL033
     D PAction         S                   LIKE(DDACTN)                                       CDL033
     D PCurrency       S                   LIKE(DDCCY)                                        CDL033
     D PMaturity       S              5P 0                                                    CDL033
     D WErrMsgId       S             10A                                                      CDL033
      *                                                                                       CDL033
      ** Additional Field for MMLDNIVL2                                                       CDL033
     D SRate           S                   LIKE(IKINTR)                                       CDL033
      *                                                                                       CDL033
      ** Fields used to call ZDATE1                                                           CDL033
      *                                                                                       CDL033
     D PInDate         S              6                                                       CDL033
     D PConvdate       S              5P 0                                                    CDL033
     D PErrorFlag      S              1A   INZ('N')                                           CDL033
      *                                                                                       CDL033
     D CDL033          S              1A                                                      CDL033
                                                                                              CDL033
     D PCONF           S              1A                                                      CDL033
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      *                                                                                       CDL033
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIR010
 
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
 
      /COPY WNCPYSRC,MMLDNIR001
 
      * DO SCREEN: BROWSE INVALID DEALS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR002
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR003
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
                                                                                              CDL016
      * DO WHILE SCREEN: Screen 2 Details                                                     CDL016
     C     @SCRN         DOWEQ     'N'                                                        CDL016
     C                   EXSR      SCRN@N                                                     CDL016
     C                   ENDDO                                                                CDL016
 
      /COPY WNCPYSRC,MMLDNIR004
 
      ** When CDL006 enhancement is installed                                                 209905
                                                                                              209905
     C                   IF        CDL006 = 'Y' AND @SCRN = 'F'                               209905
     C                   EXSR      SCRN@F                                                     209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** When CDL033 enhancement is installed                                                 CDL033
     C                   IF        CDL033 = 'Y' AND @SCRN = 'X'                               CDL033
     C                   EXSR      SRSched                                                    CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      *                                                                                       CER001
      ** Extension Screen Validation                                                          CER001
      *                                                                                       CER001
     C     @SCRN         IFEQ      'L'                                                        CER001
     C                   EXSR      Sr_ScnLUX                                                  CER001
     C                   END                                                                  CER001
                                                                                              CER001
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR005
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR006
 
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR007
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      /COPY WNCPYSRC,MMLDNIR008
 
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
      /COPY WNCPYSRC,MMLDNIR011
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID DEALS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMLDNIRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      ** Floating Rate CD Issued                                                              CDL033
     C                   PARM                    CDL033                                       CDL033
      *                                                                                       CDL033
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CDL006                                       209905
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
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
     C                   CALLB     'MMLDNIRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      ** Floating Rate CD Issued                                                              CDL033
     C                   PARM                    CDL033                                       CDL033
      *                                                                                       CDL033
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CDL006                                       209905
      *                                                                         CAP004
      * If CK/3 taken within invalid transaction deletion function,             CAP004
      * End program                                                             CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   EXSR      ENDP                                         CAP004
     C                   GOTO      ERDNBRW                                      CAP004
     C                   END                                                    CAP004
      *
      * IF INVALID DEAL READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C/COPY WNCPYSRC,MMLDNIRC18
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
      * Retrieve deal details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C                   MOVEL     @FOASOCSEL    FOASID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
      *                                                                         163820
     C     ZATRNKX0      CHAIN     MMILDNIX0                          99        163820
      *                                                                         163820
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVDEL
      *                                                                                       CER001
      ** Retrieve extension record if switchable is on                                        CER001
      *                                                                                       CER001
     C                   IF        ULX600  = 'Y'                                              CER001
     C                   EXSR      Sr_SetLUX                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * If deal details were retrieved
      * Put the deal on the main details screen
      *
     C     HKRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid deals file (except for the Midas deal number
      * and Midas associated deal number retrieved above using the
      * front office transaction and associated transaction IDs).
      * Access invalid deal with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDDLNO        ##DDDLNO          6
     C                   MOVEL     DDDADN        ##DDDADN          6
     C     ZATRNKX0      CHAIN     MMILDNIX0                          99
     C     HKRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDDLNO      DDDLNO
     C                   MOVEL     ##DDDADN      DDDADN
     C                   END
                                                                                              CDL033
     C     ZATRNKD0      CHAIN     DLIFRSCX0                          50                      CDL033
      *
      * Access invalid deal settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *                                                                         CAP011
      * If deal details were retrieved and this is an amendment                 CAP011
      *                                                                         CAP011
     C     HKRCID        IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      NwDlScnFmt                             99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
      * Setup settlement instructions on amend                                  CAP011
                                                                                CAP011
     C                   EXSR      SetupAmend                                   CAP011
                                                                                CAP011
      * Data Substitution - Settlement Details                                  CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      ##PAYS                                 99    CAP011
     C  N99GHSUBS        SCAN      ##RECS                                 99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
     C                   END                                                    CAP011
      *
      * If action code, or deal number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the deals error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C*******************ENDSR                                                  CAP004
     C     ERDNBRW       ENDSR                                                  CAP004
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     MMELDNI       @EI
      *
      ** Read error messages for deal
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   IF        ULX600  = 'N'  Or                                          CER001
     C                             (ULX600 = 'Y' And ABFIELDID <= FldOffsetExt)               CER001
     C/COPY WNCPYSRC,MMLDNIRC02
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,MMLDNIRC03
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           MMELDNI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
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
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
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
     C/COPY WNCPYSRC,MMLDNIRC19
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
     C/COPY WNCPYSRC,MMH00056
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
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C/COPY WNCPYSRC,MMH00155
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMLDNIRPR '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C/COPY WNCPYSRC,MMH00156
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    RepoFlag          1                         176883
     C/COPY WNCPYSRC,MMLDNIRC04
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
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNIRC20
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C/COPY WNCPYSRC,MMLDNIRC05
     C                   END
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
     C/COPY WNCPYSRC,MMLDNIRC21
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
      * Display second screen if Fixed Deposit Deal                                           CDL016
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
     C                   MOVEL     'N'           @SCRN                                        CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
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
     C/COPY WNCPYSRC,MMLDNIRC22
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   Z-ADD     IKMATD        OLD_MATD                       CDL007
     C/COPY WNCPYSRC,MMLDNIRC32
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
     C/COPY WNCPYSRC,MMLDNIRC23
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMELDNI
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
     C/COPY WNCPYSRC,MMH00157
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
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
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
     C/COPY WNCPYSRC,MMLDNIRC24
     C                   PARM      'N'           RepoFlag          1                          CSE006
      *                                                                                       CDL033
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM      'N'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMLDNIRC11
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C/COPY WNCPYSRC,MMH00158
     C                   GOTO      EVAL@M
     C                   END
      *                                                                         CDL007
      * Setup Breakdown fiels on the Valid file                                 CDL007
     C     CDL007        IFEQ      'Y'                                          CDL007
     C     DDACTN        ANDEQ     'A'                                          CDL007
     C                   MOVEL     DDBUSR        IKBUSR                         CDL007
     C                   IF        IKMATD < OLD_MATD                            CDL007
     C                             AND DDTYPE = 'TD'                            CDL007
     C                             OR IKMATD < OLD_MATD                         CDL007
     C                             AND DDTYPE = 'TI'                            CDL007
     C                   EVAL      IKOMDT = OLD_MATD                            CDL007
     C                   EVAL      IKPRIN = *BLANKS                             CDL007
     C                   ENDIF                                                  CDL007
     C                   ENDIF                                                  CDL007
      *                                                                         CAP051
      * Setup Automatic Authorisation flag on the Valid file                    CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   EVAL      IKAUTH = DDAUTH                              CAP051
     C                   ENDIF                                                  CAP051
                                                                                              209905
     C                   IF        DDTYPE = 'FL' OR DDTYPE = 'DP' OR                          209905
     C                             DDTYPE = 'LP' OR DDTYPE = 'FT' OR                          209905
     C                             DDTYPE = 'DT' OR DDTYPE = 'LT'                             209905
     C                   EVAL      @SCRN = 'F'                                                209905
     C                   ELSE                                                                 209905
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
                                                                                              209905
     C                   ENDIF                                                                209905
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
      * Issue rollback to clear any possible updates in window function                       CDL016
      *                                                                                       CDL016
     C     BGWDPR        IFEQ      'Y'                                                        CDL016
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                CDL016
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CDL016
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
      *                                                                                       CDL016
      * FIELDS IN ERROR                                                                       CDL016
     C                   PARM                    MMELDNI2                                     CDL016
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
     C                   PARM      'N'           @EKYFD            1                          CDL016
     C                   PARM                    @EDTFD            1                          CDL016
      *                                                                                       CDL016
      * ENABLED FUNCTION KEYS                                                                 CDL016
     C                   PARM      'N'           @EINKG            1                          CDL016
     C                   PARM      'N'           @EINKH            1                          CDL016
     C                   PARM                    @EINKJ            1                          CDL016
     C                   PARM      'N'           @EINKN            1                          CDL016
     C                   PARM      'N'           @EINKP            1                          CDL016
     C                   PARM      'N'           @EINKT            1                          CDL016
      *                                                                                       CDL016
      * SUCCESFUL INSERT DEAL                                                                 CDL016
     C                   PARM                    @SIDN             6                          CDL016
      * CALLING PGM                                                                           CDL016
     C                   PARM      'MMLDNIRPR '  CPGM             10                          CDL016
      *                                                                                       CDL038
      * Blocked/Unblock Action                                                                CDL038
     C                   PARM                    BUACT                                        CDL038
     C                   PARM                    CDL016                                       CDL038
     C                   PARM                    CDL019                                       CDL038
     C                   PARM                    CDL020                                       CDL038
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                               BUG9877
     C                   PARM                    BUACT             1                         BUG9877
      *                                                                                      BUG9877
      * Autumatic Rollover of Fixed Term Loan/Deposit                                        BUG9877
     C                   PARM                    CDL016            1                         BUG9877
      *                                                                                      BUG9877
      * Allow Base Rate Changes on Fixed Deposits/Loans                                      BUG9877
     C                   PARM                    CDL019            1                         BUG9877
      *                                                                                      BUG9877
      * Apply Base Rate at Value Date                                                        BUG9877
     C                   PARM                    CDL020            1                         BUG9877
                                                                                             BUG9877
      * OUTPUT PARAMETERS                                                                     CDL016
      *                                                                                       CDL016
      * FUNCTION KEYS                                                                         CDL016
     C                   PARM      '0'           @INKC             1                          CDL016
     C                   PARM      '0'           @INKG             1                          CDL016
     C                   PARM      '0'           @INKH             1                          CDL016
     C                   PARM      '0'           @INKJ             1                          CDL016
     C                   PARM      '0'           @INKL             1                          CDL016
     C                   PARM      '0'           @INKN             1                          CDL016
     C                   PARM      '0'           @INKP             1                          CDL016
     C                   PARM      '0'           @INKT             1                          CDL016
     C                   PARM      'N'           WriteOnly         1                          CDL016
     C                   PARM                    RepoFlag          1                          CDL016
      *                                                                                       CDL016
      * RESET ERRORS                                                                          CDL016
      *                                                                                       CDL016
     C                   MOVE      *ALL'Y'       MMELDNI2                                     CDL016
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
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN                                                 CDL016
      *                                                                                       CDL016
     C     @INKL         CASEQ     '1'           CANC@N                                       CDL016
      *                                                                                       CDL016
      * VALIDATE INPUT TO MAIN DETAILS SCREEN                                                 CDL016
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
     C     BGWDPR        IFEQ      'Y'                                                        CDL016
     C                   MOVEL     'W'           @SCRN                                        CDL016
     C                   ELSE                                                                 CDL016
     C                   MOVEL     'S'           @SCRN                                        CDL016
     C                   END                                                                  CDL016
      *                                                                                       CDL016
     C                   GOTO      EVAL@N                                                     CDL016
     C                   END                                                                  CDL016
      *                                                                                       CDL016
      *----------------------------------------------------------------                       CDL016
      * IF INSERT OR AMEND                                                                    CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'I'                                                        CDL016
     C     DDACTN        OREQ      'A'                                                        CDL016
      *                                                                                       CDL016
      * Prior to validation, initialize error indicators as 'OK'                              CDL016
      * and clear Deal in File Format                                                         CDL016
      *                                                                                       CDL016
     C                   Z-ADD     *ZERO         Idx                                          CDL016
     C                   Z-ADD     *ZERO         WIdx                                         CDL016
     C                   MOVE      *ALL'Y'       MMELDNI2                                     CDL016
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
     C                   PARM                    MMELDNI2                                     CDL016
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
     C                   PARM      IKINTR        SRate                                        CDL033
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
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *----------------------------------------------------------------                       CDL016
     C     EVAL@N        ENDSR                                                                CDL016
      *****************************************************************                       CDL016
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  Sr_ScnLUX - LUX Extension Screen                             *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_ScnLUX     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Change mode to Enquire only when Option selected is "N"                              CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      ACTION = 'E'                                               CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ACTION = DDACTN                                            CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Display LUX Extension Screen                                                         CER001
      *                                                                                       CER001
     C                   CALL      'MMLDNI2RP'                                                CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    W0RTN             7                          CER001
     C                   PARM                    NwDlFilFmtLux                                CER001
     C                   PARM                    NwDlScnFmtLux                                CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
      *                                                                                       CER001
      ** Process command keys if pressed                                                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      W0RTN   = 'Y2U9999'                                        CER001
     C                   EXSR      ENDP                                                       CER001
     C                   WHEN      W0RTN   = 'USR0790'                                        CER001
     C                   EVAL      @SCRN   = 'S'                                              CER001
     C                   WHEN      @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   OTHER                                                                CER001
     C                   EVAL      @SCRN   = 'C'                                              CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  Sr_SetLUX - Setup LUX Parameters To Be Passed                *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_SetLUX     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Setup DATALUX                                                                        CER001
      *                                                                                       CER001
     C                   EVAL      L1DN38 = DDDLNO                                            CER001
     C                   EVAL      L1DLTP = DDTYPE                                            CER001
     C                   EVAL      L1CCY  = DDCCY                                             CER001
     C                   MOVE      DDAMNP        L1AMNT                                       CER001
     C                   EVAL      L1VDAT = DDVDAT                                            CER001
     C                   EVAL      L1MDAT = DDMDAT                                            CER001
     C                   EVAL      L1TMST = DDTMESTMP                                         CER001
     C                   EVAL      L1FOTR = DDFOTRANID                                        CER001
     C                   CLEAR                   NwDlFilFmtLux                                CER001
     C                   CLEAR                   CrDlFilFmtLux                                CER001
      *                                                                                       CER001
     C     LUXKEY        CHAIN     RTVIDX1                                                    CER001
      *                                                                                       CER001
      ** Move data from Invalid File to Screen Format DS                                      CER001
      *                                                                                       CER001
     C                   MOVE      #6LXLUSU      L6LXLUSU                                     CER001
     C                   MOVE      #6LXIM93      L6LXIM93                                     CER001
     C                   MOVE      #6LXCLAT      L6LXCLAT                                     CER001
     C                   MOVE      #6LXSUBR      L6LXSUBR                                     CER001
     C                   MOVE      *BLANKS       L6LXMOBL                                     CER001
     C                   MOVEL     #6LXMOBL      L6LXMOBL                                     CER001
     C                   MOVE      #6LXRISC      L6LXRISC                                     CER001
      *                                                                                       CER001
     C     VL1UAC        IFEQ      5                                                          CER001
     C                   MOVE      #6LXGUAC      L6LXGUAC                                     CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      '0'           L6LXGUAC                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      #6LXIMEX      L6LXIMEX                                     CER001
     C                   MOVE      #6LXPPSC      L6LXPPSC                                     CER001
      *                                                                                       CER001
      ** Access Currency file to retrieve decimal position                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOCURRR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*KEY   '     @Optn                                        CER001
     C                   PARM      L1CCY         @CURR             3                          CER001
     C     SDCURR        PARM      SDCURR        DSSDY                                        CER001
      *                                                                                       CER001
     C     @RtCd         IFNE      *BLANK                                                     CER001
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     @CURR         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      #6LXCOAM      L6LXCOAM                                     CER001
     C                   EVAL      #1DEXT  = 'Y'                                              CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * Sr_UpdLUX - Update LUX Extension File                         *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Sr_UpdLUX     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVLDN38 = IKDN38                                        CER001
      *                                                                                       CER001
     C                   CALLB     'MMLDNI2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwDlFilFmtLux                                CER001
     C                   PARM                    CrDlFilFmtLux                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
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
     C/COPY WNCPYSRC,MMLDNIRC25
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
     C/COPY WNCPYSRC,MMH00057
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
     C/COPY WNCPYSRC,MMH00159
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
     C                   PARM      'MMLDNIRPR '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C/COPY WNCPYSRC,MMH00160
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      '0'           @INKT
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM                    RepoFlag          1                          176883
     C/COPY WNCPYSRC,MMLDNIRC06
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
                                                                                              209905
      ** Call the appropriate module to get the next deal number                              209905
                                                                                              209905
     C                   IF        CDL006 = 'Y' AND DDTYPE = 'FL'                             209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'FT'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'LP'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'LT'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'DP'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'DT'                          209905
     C                                                                                        209905
     C                   CALLB     'CAGTNXTFID'                                               209905
     C                   PARM                    DDTYPE                                       209905
     C                   PARM      *Zeros        PDealNo                                      209905
                                                                                              209905
     C                   MOVE      PDealNo       I#DDDLNO                                     209905
     C                   Z-ADD     PDealNo       IKDN38                                       209905
                                                                                              209905
     C                   ELSE                                                                 209905
                                                                                              209905
      ** Verify if system-generation of deal number can be skipped.                           CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     PDealNo       ANDGT     0                                                          CDL033
                                                                                              CDL033
     C                   MOVE      PDealNo       I#DDDLNO                                     CDL033
     C                   Z-ADD     PDealNo       IKDN38                                       CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
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
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                209905
     C                   END
      *
     C/COPY WNCPYSRC,MMLDNISMV1
      *
     C                   CALL      'WN0010'
     C**********         PARM      'MMLDNISIN'   #PGM             10            174857
     C                   PARM      'MMLDNIRPR'   #PGM             10            174857
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
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                192916
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
     C/COPY WNCPYSRC,MMLDNIRC07
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
     C/COPY WNCPYSRC,MMLDNIRC26
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
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
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
     C/COPY WNCPYSRC,MMLDNIPC19
      *
     C                   IF        CDL006 = 'Y' AND DDACTN = 'D'                              209905
     C                   CALLB     'MMLDNIWRN'                                                209905
     C                   PARM                    DDDLNO                                       209905
     C                   PARM                    DDTYPE                                       209905
     C                   PARM                    WFldNamArr                                   209905
     C                   PARM                    WMsgIdArr                                    209905
     C                   PARM                    WMsgDtaArr                                   209905
     C                   PARM                    Ix                                           209905
     C                   ENDIF                                                                209905
                                                                                              209905
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
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
     C/COPY WNCPYSRC,MMLDNIRC27
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
     C/COPY WNCPYSRC,MMLDNIRC28
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
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
     C/COPY WNCPYSRC,MMH00161
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
      *                                                                         CAP014
      * If no changes are allowed, protect (but still validate)                 CAP014
      * all instructions by passing action code 'X' to ZASETINSIN               CAP014
      *                                                                         CAP014
     C     @OPSEL        IFEQ      'N'                                          CAP014
     C                   MOVEL     'X'           ##ACTN                         CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     DDACTN        ##ACTN                         CAP014
     C                   ENDIF                                                  CAP014
     C/COPY WNCPYSRC,MMLDNIRC01
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
     C                   PARM                    ##ACTN            1            CAP014
     C*******************PARM      DDACTN        ##ACTN            1            CAP014
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
      *
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
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
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
                                                                                              CDL018
     C                   ENDIF                                                                CDL018
                                                                                              CDL018
     C                   ENDIF                                                                CDL018
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
     C     CDL006        OREQ      'Y'                                                        209905
     C     DDTYPE        ANDEQ     'FL'                                                       209905
     C     CDL006        OREQ      'Y'                                                        209905
     C     DDTYPE        ANDEQ     'DP'                                                       209905
     C     CDL006        OREQ      'Y'                                                        209905
     C     DDTYPE        ANDEQ     'LP'                                                       209905
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
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
     C                   END
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVE      IKPSTM        FLPSTM                                       CGL029
     C                   MOVE      IKPAYEx       FLPONS                                       CGL029
     C                   MOVEL     IKPAY         FLPAY
     C                   MOVEL     IKPOBR        FLPOBR
     C                   MOVEL     IKCVMR        FLCVMR
     C                   MOVEL     IKSTCY        FLPSCY
     C                   MOVEL     IKIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVE      IKRSTM        FLRSTM                                       CGL029
     C                   MOVE      IKRECEx       FLRONS                                       CGL029
     C                   MOVEL     IKREC         FLREC
     C                   MOVEL     IKROBR        FLROBR
     C                   MOVEL     IKSTCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
      *
     C/COPY WNCPYSRC,MMH00029
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
     C/COPY WNCPYSRC,MMLDNIRC15
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
     C/COPY WNCPYSRC,MMH00030
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
     C/COPY WNCPYSRC,MMLDNIRC08
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
     C/COPY WNCPYSRC,MMLDNIRC09
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
     C                   IF        ULX600  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   ELSE                                                                 CER001
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVE      FLPSTM        IKPSTM                                       CGL029
     C                   MOVE      FLPONS        IKPAYEx                                      CGL029
     C                   MOVEL     FLPAY         IKPAY
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
     C                   MOVE      FLRSTM        IKRSTM                                       CGL029
     C                   MOVE      FLRONS        IKRECEx                                      CGL029
     C                   MOVEL     FLREC         IKREC
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
     C                   Z-ADD     IKMATD        OLD_MATD                       CDL007
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
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
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
     C/COPY WNCPYSRC,MMLDNIRC29
     C                   PARM      'N'           RepoFlag          1                          CSE006
      *                                                                                       CDL033
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM      'Y'           PCONF                                        CDL033
      *                                                                                       CDL033
     C/COPY WNCPYSRC,MMLDNIRC12
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *                                                                         CDL007
      * Setup Breakdown fiels on the Valid file                                 CDL007
     C     CDL007        IFEQ      'Y'                                          CDL007
     C     DDACTN        ANDEQ     'A'                                          CDL007
     C     IDx           ANDEQ     *ZEROS                                       CDL007
     C                   MOVEL     DDBUSR        IKBUSR                         CDL007
     C                   IF        IKMATD < OLD_MATD                            CDL007
     C                             AND DDTYPE = 'TD'                            CDL007
     C                             OR IKMATD < OLD_MATD                         CDL007
     C                             AND DDTYPE = 'TI'                            CDL007
     C                   EVAL      IKOMDT = OLD_MATD                            CDL007
     C                   EVAL      IKPRIN = *BLANKS                             CDL007
     C                   ENDIF                                                  CDL007
     C                   ENDIF                                                  CDL007
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
     C/COPY WNCPYSRC,MMLDNIRC30
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
     C/COPY WNCPYSRC,MMH00058
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
     C/COPY WNCPYSRC,MMH00162
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
     C                   PARM      'MMLDNIRPR '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C/COPY WNCPYSRC,MMH00163
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    RepoFlag          1                          176883
     C/COPY WNCPYSRC,MMLDNIRC10
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
     C/COPY WNCPYSRC,MMH00168
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
     C/COPY WNCPYSRC,MMLDNIRC17
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
                                                                                              209905
      ** Call the appropriate module to get the next deal number                              209905
                                                                                              209905
     C                   IF        CDL006 = 'Y' AND DDTYPE = 'FL'                             209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'FT'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'LP'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'LT'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'DP'                          209905
     C                             OR CDL006 = 'Y' AND DDTYPE = 'DT'                          209905
     C                                                                                        209905
     C                   CALLB     'CAGTNXTFID'                                               209905
     C                   PARM                    DDTYPE                                       209905
     C                   PARM      *Zeros        PDealNo                                      209905
                                                                                              209905
     C                   Z-ADD     PDealno       IKDN38                                       209905
                                                                                              209905
     C                   ELSE                                                                 209905
                                                                                              209905
      ** Verify if system-generation of deal number can be skipped.                           CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     PDealNo       ANDGT     0                                                          CDL033
                                                                                              CDL033
     C                   MOVE      PDealNo       DDDLNO                                       CDL033
     C                   Z-ADD     PDealNo       IKDN38                                       CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
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
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                209905
     C                   END
     C                   MOVEL     DDDLNO        @SIDN
     C                   END
      *
     C/COPY WNCPYSRC,MMLDNIRC16
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        IKDN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IKLACT
      *
      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    IKFRNT
      *
      * UPDATE VALID DEAL: FRONT OFFICE ASSOCIATED TRANSACTION ID
      *
     C                   MOVEL     @FOASOCSEL    IKAFRT
      *
      * MONEY MARKET DATABASE UPDATES
      *
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
      *                                                                                       CDL033
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM      *BLANKS       PBFRCD          100                          CDL033
      *                                                                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM      *BLANKS       PAFRCD          100                          CDL033
      *                                                                                       CDL033
     C/COPY WNCPYSRC,MMLDNIRC13
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMLDNIRC31
     C                   END
      *                                                                                       CER001
      ** Update LUX Extension File if allowed                                                 CER001
      *                                                                                       CER001
     C                   IF        ULX600 = 'Y' and                                           CER001
     C                             @RTCD = *Blanks and                                        CER001
     C                             DDACTN <> 'A'                                              CER001
     C                   EXSR      Sr_UpdLUX                                                  CER001
     C                   ENDIF                                                                CER001
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
     C                   ENDIF
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID MM DEAL ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'                                    168345
     C                   EXSR      *PSSR
     C                   ENDIF                                                  168345
     C                                                                          CAP006
     C                   ELSE
                                                                                              244036
      ** Add record within Deals Master Extension File (done from Java layer).                244036
     C**********         IF        DDACTN = 'I'                                         244036247888
     C**********         IF        DDACTN = 'I' AND CLE025 = 'Y'                     247888 MD031031
     C                   IF        DDACTN = 'I'                                             MD031031
     C                   EXSR      WriteDLDLDC                                                244036
     C                   END                                                                  244036
                                                                                              244036
     C     ZATRNKD0      CHAIN     MMILDNID0                          99
     C  N99              DELETE    MMILDNID0
     C                   IF        ULX600 = 'Y'                                               CER001
     C     LUXKEY        CHAIN     RTVIDX1                                                    CER001
     C                   IF        %FOUND(MMILDLX1L0)                                         CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   IF        CDL006 = 'Y'                                               209905
     C     ZATRNKD0      SETLL     MMIFIDTD0                                                  209905
     C     ZATRNKD0      READE     MMIFIDTD0                              99                  209905
     C                   DOW       *IN99 = *OFF                                               209905
     C                   DELETE    MMIFIDTD0                                                  209905
     C     ZATRNKD0      READE     MMIFIDTD0                              99                  209905
     C                   ENDDO                                                                209905
     C                   ENDIF                                                                209905
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *                                                                                       CDL033
      ** Delete record from the log file if CDL033 is on                                      CDL033
      *                                                                                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
      *                                                                                       CDL033
      ** Delete all records in DLIFRSCPD                                                      CDL033
      *                                                                                       CDL033
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CDL033
     C     KFrntOffID    SETLL     DLIFRSCL1                                                  CDL033
     C     KFrntOffID    READE     DLIFRSCL1                              99                  CDL033
     C                   DOW       *IN99 = *OFF                                               CDL033
     C                   DELETE    DLIFRSCD0                                                  CDL033
     C     KFrntOffID    READE     DLIFRSCL1                              99                  CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CSC011
      ** Delete invalid record from the log file                                              CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = @MSGTYPE                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPLOG        CHAIN     APILOGL0                           99                      CSC011
                                                                                              CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** When CDL006 enhancement is installed                                                 209905
                                                                                              209905
     C                   IF        CDL006 = 'Y'                                               209905
     C                   IF        DDTYPE = 'FL' OR DDTYPE = 'DP' OR                          209905
     C                             DDTYPE = 'LP'                                              209905
                                                                                              209905
     C                   MOVE      IKDN38        PDealNo                                      209905
                                                                                              209905
     C                   CALLB     'MMFIDTUPF'                                                209905
     C                   PARM      'MMLDNIRPR'   PProgram                                     209905
     C                   PARM      IKLACT        PMode                                        209905
     C                   PARM                    PDealNo                                      209905
     C                   PARM                    PLinkDlno                                    209905
     C                   PARM                    @FOTRANSEL                                   209905
     C                   PARM                    PRtcd                                        209905
                                                                                              209905
     C                   IF        PRtcd <> *Blanks                                           209905
     C                   EVAL      DBFile = 'MMFIDTUPF'                                       209905
     C                   EVAL      DBASE = 3                                                  209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,MMLDNIRC14
     C                   END
      *
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
     C/COPY WNCPYSRC,MMH00164
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
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      *****************************************************************                       209905
      *  SCRN@F - Fiduciary transactions processing                                           209905
      *****************************************************************                       209905
     C     SCRN@F        BEGSR                                                                209905
                                                                                              209905
      ** ------------------- **                                                               209905
      ** Fiduciary Placings  **                                                               209905
      ** ------------------- **                                                               209905
                                                                                              209905
      ** Insert                                                                               209905
      ** Display associated fiduciary takings of the fiduciary placing                        209905
                                                                                              209905
     C     DDACTN        IFEQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'FL'                                                       209905
     C     DDACTN        OREQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'DP'                                                       209905
     C     DDACTN        OREQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'LP'                                                       209905
                                                                                              209905
      ** Setup Inv_FIDT array                                                                 209905
                                                                                              209905
     C                   Z-ADD     1             ACtr                                         209905
     C                   Z-ADD     1             AStr                                         209905
     C     ZATRNKX0      SETLL     MMIFIDTL1                                                  209905
     C     ZATRNKX0      READE     MMIFIDTL1                              99                  209905
     C                   IF        *IN99 = *OFF                                               209905
     C                   EVAL      PFRONTID1 = SFOTRANID                                      209905
     C**********         EVAL      WFIDTDTA1 = (%SUBST(MMInvFIDT:1:3696))              209905 CGL029
     C**********         EVAL      WFIDTNAR = (%SUBST(MMInvFIDT:3697:240))             209905 CGL029
     C                   EVAL      WFIDTDTA1 = (%SUBST(MMInvFIDT:1:4224))                     CGL029
     C                   EVAL      WFIDTNAR = (%SUBST(MMInvFIDT:4225:240))                    CGL029
     C     ZATRNKX0      READE     MMIFIDTL1                              99                  209905
     C                   IF        *IN99 = *OFF                                               209905
     C                   EVAL      PFRONTID2 = SFOTRANID                                      209905
     C                   EVAL      WFIDTDTA2 = (%SUBST(MMInvFIDT:1:462))                      209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C     PFRONTID1     IFNE      *BLANK                                                     209905
     C                   DOW       ACtr <= 99                                                 209905
     C**********         EVAL      Inv_FIDT(ACtr) = (%SUBST(WFIDTDTA:AStr:42))         209905 CGL029
     C                   EVAL      Inv_FIDT(ACtr) = (%SUBST(WFIDTDTA:AStr:48))                CGL029
     C                   EVAL      ACtr = ACtr + 1                                            209905
     C                   EVAL      AStr = AStr + 42                                           209905
     C                   ENDDO                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** No update allowed, protect the subfile fields                                        209905
                                                                                              209905
     C                   IF        @OPSEL = 'N'                                               209905
     C                   EVAL      PProtect = 'Y'                                             209905
     C                   ELSE                                                                 209905
     C                   EVAL      PProtect = 'N'                                             209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   CALLB     'MMFIDTSFL'                                                209905
     C                   PARM                    DDACTN                                       209905
     C                   PARM                    DDDLNO                                       209905
     C                   PARM      IKLNKN        PLNKN                                        209905
     C                   PARM      IKCNUM        PCNUM                                        209905
     C                   PARM                    IKCCY                                        209905
     C                   PARM      IKAMNP        PAMNP                                        209905
     C                   PARM      IKINTR        PINTR                                        209905
     C                   PARM      IKDDND        PDDND                                        209905
     C                   PARM      IKDVSD        PVDAT                                        209905
     C                   PARM      IKMATD        PMDAT                                        209905
     C                   PARM      IKNTCE        PNTCE                                        209905
     C                   PARM                    IKTYPE                                       209905
     C                   PARM                    IKSTYP                                       209905
     C                   PARM                    IKBRCA                                       209905
     C                   PARM      DDNTCE        PDDNTCE                                      209905
     C                   PARM      DDMDAT        PDDMDAT                                      209905
     C                   PARM                    NwDlFilFmt                                   209905
     C                   PARM                    Inv_FIDT                                     209905
     C                   PARM                    PFRONTID1                                    209905
     C                   PARM                    PFRONTID2                                    209905
     C                   PARM                    SFOASOCID                                    209905
     C                   PARM                    PProtect                                     209905
     C                   PARM      *BLANKS       PReturnCode                                  209905
     C                   PARM      SFTRAS01      PFTST                                        209905
     C                   PARM      WFIDTNAR1     PFRN1                                        209905
     C                   PARM      WFIDTNAR2     PFRN2                                        209905
     C                   PARM      WFIDTNAR3     PFRN3                                        209905
     C                   PARM      WFIDTNAR4     PFRN4                                        209905
                                                                                              209905
     C     PReturnCode   IFNE      *BLANKS                                                    209905
                                                                                              209905
     C                   SELECT                                                               209905
     C     PReturnCode   WHENEQ    'Y2U9999'                                                  209905
     C                   EXSR      ENDP                                                       209905
     C     PReturnCode   WHENEQ    'USR0790'                                                  209905
     C                   MOVE      'M'           @SCRN                                        209905
     C                   ENDSL                                                                209905
                                                                                              209905
     C                   GOTO      ENDFD                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Move default values for charges                                                      209905
                                                                                              209905
     C                   MOVE      *BLANKS       IKFCGC                                       209905
     C                   MOVE      *BLANKS       IKFCGD                                       209905
     C                   Z-ADD     0             IKFCGA                                       209905
     C                   Z-ADD     0             IKFCGT                                       209905
                                                                                              209905
      ** Move default values for commissions                                                  209905
                                                                                              209905
     C                   MOVE      *BLANKS       IKFCMC                                       209905
     C                   MOVE      *BLANKS       IKFCMD                                       209905
     C                   Z-ADD     0             IKFCMA                                       209905
     C                   Z-ADD     0             IKFCMT                                       209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** ----------------- **                                                                 209905
      ** Fiduciary Takings **                                                                 209905
      ** ----------------- **                                                                 209905
                                                                                              209905
      ** Insert or Amend                                                                      209905
                                                                                              209905
     C     DDACTN        IFEQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'FT'                                                       209905
     C     DDACTN        OREQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'DT'                                                       209905
     C     DDACTN        OREQ      'I'                                                        209905
     C     DDTYPE        ANDEQ     'LT'                                                       209905
     C     DDACTN        OREQ      'A'                                                        209905
     C     DDTYPE        ANDEQ     'FT'                                                       209905
     C     DDACTN        OREQ      'A'                                                        209905
     C     DDTYPE        ANDEQ     'DT'                                                       209905
     C     DDACTN        OREQ      'A'                                                        209905
     C     DDTYPE        ANDEQ     'LT'                                                       209905
                                                                                              209905
      ** Validate trust agreement status                                                      209905
                                                                                              209905
     C     DDTYPE        IFEQ      'LT'                                                       209905
     C                   MOVE      DDDLNO        PDealNo                                      209905
     C**********         Z-ADD     IKCNUM        PCNUM                                 209905 CSD027
     C                   EVAL      PCNUM= IKCNUM                                              CSD027
     C                   CALLB     'MMFIDTSTS'                                                209905
     C                   PARM      'MMLDNIRPR'   PProgram                                     209905
     C                   PARM                    DDACTN                                       209905
     C                   PARM                    PDealNo                                      209905
     C                   PARM                    PCNUM                                        209905
     C                   PARM                    IKFTST                                       209905
     C                   PARM                    IKFRN1                                       209905
     C                   PARM                    IKFRN2                                       209905
     C                   PARM                    IKFRN3                                       209905
     C                   PARM                    IKFRN4                                       209905
     C                   PARM                    PProtect                                     209905
     C                   PARM      *BLANKS       PReturnCode                                  209905
                                                                                              209905
     C     PReturnCode   IFNE      *BLANKS                                                    209905
                                                                                              209905
     C                   SELECT                                                               209905
     C     PReturnCode   WHENEQ    'Y2U9999'                                                  209905
     C                   EXSR      ENDP                                                       209905
     C     PReturnCode   WHENEQ    'USR0790'                                                  209905
     C                   MOVE      'M'           @SCRN                                        209905
     C                   ENDSL                                                                209905
                                                                                              209905
     C                   GOTO      ENDFD                                                      209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Access customer file to get charge/commission details                                209905
                                                                                              209905
     C     BNCHTK        IFEQ      'Y'                                                        209905
     C     BNCOTK        OREQ      'Y'                                                        209905
     C                   CALLB     'AOCUSTR1'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*KEY   '     POPTN                                        209905
     C                   PARM      DDCUST        WKEY1                                        209905
     C                   PARM      *BLANKS       WKEY2                                        209905
     C     SDCUST        PARM      SDCUST        DSLDY                                        209905
     C     PRTCD         IFNE      *BLANKS                                                    209905
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       209905
     C                   Z-ADD     4             DBASE                                        209905
     C                   MOVEL     WKEY1         DBKEY                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Set up charges fields on MMVLDNIPD for database update                               209905
                                                                                              209905
     C     PReturnCode   IFEQ      *BLANKS                                                    209905
     C     BNCHTK        ANDEQ     'Y'                                                        209905
                                                                                              209905
     C     BBCHRG        IFEQ      *BLANKS                                                    209905
     C                   MOVE      *BLANKS       IKFCGC                                       209905
     C                   ELSE                                                                 209905
     C     BBCHRG        CHAIN     SDCCGRL1                           20                      209905
     C     *IN20         IFEQ      *ON                                                        209905
     C                   MOVE      *BLANKS       IKFCGC                                       209905
     C                   ELSE                                                                 209905
     C                   MOVE      DDDLNO        PDealNo                                      209905
     C                   Z-ADD     IKAMNP        PAMNP13                                      209905
     C                   CALLB     'MMFIDTCHG'                                                209905
     C                   PARM      'MMLDNISIN'   PProgram                                     209905
     C                   PARM                    DDACTN                                       209905
     C                   PARM                    PDealNo                                      209905
     C                   PARM      IKCNUM        PCNUM                                        209905
     C                   PARM                    IKCCY                                        209905
     C                   PARM                    PAMNP13                                      209905
     C                   PARM      CCCHOD        IKFCGC                                       209905
     C                   PARM                    IKFCGD                                       209905
     C                   PARM      IKFCGA        PFCGA                                        209905
     C                   PARM      *BLANKS       PReturnCode                                  209905
     C     PReturnCode   IFEQ      *BLANKS                                                    209905
     C                   Eval      IKFCGA = PFCGA                                             209905
     C                   Eval      IKFCGT = 0                                                 209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C     IKFCGC        IFEQ      *BLANKS                                                    209905
     C                   MOVE      *BLANKS       IKFCGD                                       209905
     C                   Z-ADD     0             IKFCGA                                       209905
     C                   Z-ADD     0             IKFCGT                                       209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Set up commission fields on MMVLDNIPD for database update                            209905
                                                                                              209905
     C     PReturnCode   IFEQ      *BLANKS                                                    209905
     C     BNCOTK        ANDEQ     'Y'                                                        209905
                                                                                              209905
     C     BBCOMG        IFEQ      *BLANKS                                                    209905
     C                   MOVE      *BLANKS       IKFCMC                                       209905
     C                   ELSE                                                                 209905
     C     BBCOMG        CHAIN     SDCCGRL1                           20                      209905
     C     *IN20         IFEQ      *ON                                                        209905
     C                   MOVE      *BLANKS       IKFCMC                                       209905
     C                   ELSE                                                                 209905
     C                   MOVE      DDDLNO        PDealNo                                      209905
     C                   Z-ADD     IKAMNP        PAMNP                                        209905
     C                   CALLB     'MMFIDTCOM'                                                209905
     C                   PARM      'MMLDNISIN'   PProgram                                     209905
     C                   PARM                    DDACTN                                       209905
     C                   PARM                    PDealNo                                      209905
     C                   PARM      IKCNUM        PCNUM                                        209905
     C                   PARM                    IKCCY                                        209905
     C                   PARM                    IKTYPE                                       209905
     C                   PARM      IKMATD        PMDAT                                        209905
     C                   PARM      IKVDDD        PVDDD                                        209905
     C                   PARM      IKVDMM        PVDMM                                        209905
     C                   PARM      IKVDYY        PVDYY                                        209905
     C                   PARM                    IKRDFC                                       209905
     C                   PARM                    IKICMT                                       209905
     C                   PARM                    PAMNP                                        209905
     C                   PARM      CCCCOD        IKFCMC                                       209905
     C                   PARM                    IKFCMD                                       209905
     C                   PARM      IKFCMA        PFCMA                                        209905
     C                   PARM      *BLANKS       PReturnCode                                  209905
     C     PReturnCode   IFEQ      *BLANKS                                                    209905
     C                   Eval      IKFCMA = PFCMA                                             209905
     C                   Eval      IKFCMT = 0                                                 209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C     IKFCMC        IFEQ      *BLANKS                                                    209905
     C                   MOVE      *BLANKS       IKFCMD                                       209905
     C                   Z-ADD     0             IKFCMA                                       209905
     C                   Z-ADD     0             IKFCMT                                       209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C     DDACTN        IFEQ      'I'                                                        209905
     C     DDACTN        OREQ      'A'                                                        209905
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C                   MOVEL     'X'           @SCRN                                        CDL033
     C                   ELSE                                                                 CDL033
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   MOVE      'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        209905
     C                   MOVE      'W'           @SCRN                                        209905
     C                   ELSE                                                                 209905
     C                   MOVE      'S'           @SCRN                                        209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CDL033
                                                                                              209905
     C     ENDFD         ENDSR                                                                209905
                                                                                              209905
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NwDlScnFmt    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrDlScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NwDlScnFmt                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SetupAmend - Setup Settlement Instructions on Amendment       *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SetupAmend    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
     C                   MOVE      HKRSTM        FLRSTM                                       CGL029
     C                   MOVE      HKRECEx       FLRONS                                       CGL029
     C                   MOVEL     HKREC         FLREC                          CAP011
     C                   MOVEL     HKROBR        FLROBR                         CAP011
     C                   MOVEL     HKSTCY        FLRSCY                         CAP011
     C                   MOVE      HKPSTM        FLPSTM                                       CGL029
     C                   MOVE      HKPAYEx       FLPONS                                       CGL029
     C                   MOVEL     HKPAY         FLPAY                          CAP011
     C                   MOVEL     HKPOBR        FLPOBR                         CAP011
     C                   MOVEL     HKCVMR        FLCVMR                         CAP011
     C                   MOVEL     HKSTCY        FLPSCY                         CAP011
     C                   MOVEL     HKIC72        FLIC72                         CAP011
                                                                                CAP011
     C                   CALLB     'ZASETINCVT'                                 CAP011
                                                                                CAP011
      ** Deal Settlement Instructions in file format                            CAP011
     C                   PARM                    ##PAYF                         CAP011
     C                   PARM                    ##RECF                         CAP011
     C                   PARM      *BLANK        ##FRIF                         CAP011
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM      *BLANK        CrPaySttmt                     CAP011
     C                   PARM      *BLANK        CrRecSttmt                     CAP011
     C                   PARM      *BLANK        CrFRASttmt                     CAP011
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A
                                                                                CAP011
      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (##PAYS = *blank)                        CAP011
     C                   EVAL      ##PAYS = CrPaySttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (##RECS = *blank)                        CAP011
     C                   EVAL      ##RECS = CrRecSttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##PAYS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##PAYS                         CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##RECS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##RECS                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      * Schedule                                                      *                       CDL033
      *****************************************************************                       CDL033
     C     SRSched       BEGSR                                                                CDL033
                                                                                              CDL033
     C                   IF        DDDLNO = *BLANKS                                           CDL033
     C                   CALLB     'CAGETNXTDL'                                               CDL033
     C                   PARM      *BLANKS       PReturnCode                                  CDL033
     C                   PARM      *BLANKS       PMessage                                     CDL033
     C                   PARM                    WDLNO                                        CDL033
     C                   PARM      *ZEROS        W2DLNO                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   IF        PMessage <> *BLANKS                                        CDL033
     C                   EVAL      DBFILE  = 'CAGTNXDL'                                       CDL033
     C                   EVAL      DBASE   = 102                                              CDL033
     C                   EVAL      DBKEY   = DDDLNO                                           CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      *                                                                                       CDL033
      ** If the deal number is blanks, use auto deal number to pass to                        CDL033
      ** Rates/Payment schedule maintenance                                                   CDL033
      *                                                                                       CDL033
     C                   IF        DDDLNO  = *BLANKS                                          CDL033
     C                   MOVE      WDLNO         PDealNo                                      CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      DDDLNO        PDealNo                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVE      IKMATD        PMaturity                                    CDL033
                                                                                              CDL033
     C     DDRCFR        IFEQ      'Z'                                                        CDL033
     C                   CALL      'MM0091'                                                   CDL033
     C                   PARM                    PDealNo                                      CDL033
     C                   PARM      DDTYPE        PDTYP             2                          CDL033
     C                   PARM      'R'           PRCIP             1                          CDL033
     C                   PARM      IKRCDT        PCTDAT            5 0                        CDL033
     C                   PARM      IKDVSD        PCVDAT            5 0                        CDL033
     C                   PARM      IKMATD        PCMDAT            5 0                        CDL033
     C                   PARM      DDCCY         PCCY              3                          CDL033
     C                   PARM      DDACTN        PPSCD             1                          CDL033
     C                   PARM      SRDAT164      PIDTES                                       CDL033
     C                   PARM      SRCOH164      PICONF                                       CDL033
     C                   PARM      *BLANKS       PReturnCode                                  CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      ** Continue with the Interest Payment schedule if <enter> was                           CDL033
      ** pressed in the previous call.                                                        CDL033
     C     DDIPFQ        IFEQ      'Z'                                                        CDL033
     C     PReturnCode   ANDEQ     *BLANKS                                                    CDL033
     C                   CALL      'MM0091'                                                   CDL033
     C                   PARM                    PDealNo                                      CDL033
     C                   PARM      DDTYPE        PDTYP                                        CDL033
     C                   PARM      'R'           PRCIP                                        CDL033
     C                   PARM      IKNIPD        PCTDAT                                       CDL033
     C                   PARM      IKDVSD        PCVDAT                                       CDL033
     C                   PARM      IKMATD        PCMDAT                                       CDL033
     C                   PARM      DDCCY         PCCY                                         CDL033
     C                   PARM      DDACTN        PPSCD                                        CDL033
     C                   PARM      SPDAT164      PIDTES                                       CDL033
     C                   PARM      SPCOH164      PICONF                                       CDL033
     C                   PARM      *BLANKS       PReturnCode                                  CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   SELECT                                                               CDL033
      ** F3 = Exit                                                                            CDL033
     C                   WHEN      PReturnCode = 'Y2U9999'                                    CDL033
     C                   EXSR      ENDP                                                       CDL033
      ** F12 = Previous                                                                       CDL033
     C                   WHEN      PReturnCode = 'USR0790'                                    CDL033
     C                   EVAL      @SCRN = 'N'                                                CDL033
      ** <Enter>                                                                              CDL033
     C                   WHEN      PReturnCode = *BLANKS                                      CDL033
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   MOVE      'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
     C                   IF        BGWDPR = 'Y'                                               CDL033
     C                   EVAL      @SCRN = 'W'                                                CDL033
     C                   ELSE                                                                 CDL033
     C                   IF        DDACTN = 'E'                                               CDL033
     C                   EVAL      @SCRN = 'S'                                                CDL033
     C                   ELSE                                                                 CDL033
     C                   IF        @RDNB = 'Y'                                                CDL033
     C                   EVAL      @SCRN = 'R'                                                CDL033
     C                   ELSE                                                                 CDL033
     C                   EVAL      @SCRN = 'M'                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CER001
                                                                                              CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
                                                                                              CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  244036
      *****************************************************************                       244036
      *                                                               *                       244036
      * WriteDLDLDC - WRITE Money Market & Loans Deals Extension      *                       244036
      *               record (done from Java layer).                  *                       244036
      *                                                               *                       244036
      *****************************************************************                       244036
     C     WriteDLDLDC   BEGSR                                                                244036
      *                                                                                       244036
      ** When opening new deals within DEALSDC, write a corresponding                         244036
      ** record in the Deals details extension file DLDLDCQD.                                 244036
      *                                                                                       244036
     C     @KeyDealL5    KLIST                                                                244036
     C                   KFLD                    F1DLNO                                       244036
      *                                                                                       244036
     C                   MOVE      DDDLNO        F1DLNO                                       244036
     C     @KeyDealL5    CHAIN     DLDLDCD0                           82                      244036
      *                                                                                       244036
     C     *IN82         IFEQ      *ON                                                        244036
     C                   EVAL      F1BRCA = DDBRCA                                            244036
     C                   WRITE     DLDLDCD0                                                   244036
                                                                                              244036
     C                   ENDIF                                                                244036
                                                                                              244036
     C                   ENDSR                                                                244036
      *****************************************************************                       244036
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMILDNIMNT'  DBPGM
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
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                         CAP011
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '903'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
                                                                                              209905
      ** Access Deal ICD file                                                                 209905
                                                                                              209905
     C**********         CALLB     'AODEALR0'                                          209905 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtcd                                        209905
     C                   PARM      '*FIRST '     POptn                                        209905
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                 209905 CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
                                                                                              209905
     C                   IF        PRtcd <> *Blanks                                           209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      *INU7 = *ON                                                209905
     C                   EVAL      *INU8 = *ON                                                209905
     C                   EVAL      DBASE = 905                                                209905
     C                   EVAL      DBFILE = 'SDDEALPD'                                        209905
     C                   EVAL      DBKEY = POptn                                              209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Access SAR files                                                                     209905
                                                                                              209905
     C                   CALLB     'MMFIDINIT'                                                209905
     C                   PARM      *BLANKS       PRTCD                                        209905
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
     C     KAPLOG        KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
     C     LUXKEY        KLIST                                                                CER001
     C                   KFLD                    L1TMST                                       CER001
     C                   KFLD                    L1FOTR                                       CER001
 
      ** Message Type
     C*******************MOVEL     'MMLDNI'      @MSGTYPE          8            CAP004
     C                   MOVEL     'MMLDNI'      @MSGTYPE                       CAP004
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *                                                                                       CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    Format                                       CER001
     C                   PARM                    FieldExt                                     CER001
     C                   PARM                    FieldNo                                      CER001
                                                                                              CER001
     C                   IF        ReturnCode   = *BLANK                                      CER001
     C                   EVAL      FldOffsetExt = FieldNo - 1                                 CER001
      *                                                                                       CER001
      ** If there was an error default the offset to 121                                      CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      FldOffsetExt = 121                                         CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,MMH00165
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      ** Access SAR details file to determine if CDL007 is on.                  CDL007
      ** (Deposit Breakdown Penalty)                                            CDL007
      *                                                                         CDL007
     C                   MOVEL     'N'           CDL007                         CDL007
     C                   CALLB     'AOSARDR0'                                   CDL007
     C                   PARM      *BLANKS       @RTCD                          CDL007
     C                   PARM      '*VERIFY'     @OPTN                          CDL007
     C                   PARM      'CDL007'      @SARD             6            CDL007
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL007
      *                                                                         CDL007
     C     @RTCD         IFEQ      *BLANKS                                      CDL007
     C                   MOVEL     'Y'           CDL007            1            CDL007
     C                   ENDIF                                                  CDL007
      *                                                                         CAP051
      ** Access SAR details file to determine if CAP051 is on.                  CAP051
      ** (Automatic Authorisation (MM Part))                                    CAP051
      *                                                                         CAP051
     C                   MOVEL     'N'           CAP051                         CAP051
     C                   CALLB     'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD             6            CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANKS                                      CAP051
     C                   MOVEL     'Y'           CAP051            1            CAP051
     C                   ENDIF                                                  CAP051
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Automatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL017
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
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   OPEN      APILOGL0                                                   CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 904                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
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
     C                   EVAL      DBASE = 906                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033                                       CDL033
      ** (Floating Rate CD Issued) is on.                                                     CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C                   IF        @RTCD = *BLANKS                                            CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Verify if Hedge Accounting Enhancement is on.                                        CDL033
      *                                                                                       CDL033
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
     C                   EVAL      DBASE = 907                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CAS005                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX600 switchable                            CER001
      ** feature is switched on                                                               CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX600'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   MOVE      'N'           ULX600            1                          CER001
                                                                                              CER001
     C                   IF        @RTCD  = *Blanks                                           CER001
     C                   EVAL      ULX600 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX600 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ELSEIF    @RTCD <> '*NRF'                                            CER001
                                                                                              CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX600'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 907                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Only open LUX related files when SAR is installed                                    CER001
      *                                                                                       CER001
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   OPEN      MMILDLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C/COPY WNCPYSRC,MMH00031
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIR012
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMH00166
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
