     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits retr + act/deal validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIRTV - LOANS/DEPOSITS RETRIEVE                          *
      *              (WITH ACTION CODE VERSUS DEAL NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves a loan/deposit deal from    *
      *             the database. As it does so, it validates the     *
      *             action code and deal number.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CDL098             Date 06Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 14May13               *
      *                 AR665113           Date 28Nov12               *
      *                 260452             Date 03Oct12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR996631           Date 28Jun12               *
      *                 CRE073             Date 06Dec10               *
      *                 259924A            Date 31May09               *
      *                 259924             Date 10May09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256795             Date 25Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241948             Date 30Sep06               *
      *                 CAP185             Date 21Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 238211             Date 15Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10315           Date 08Feb06               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 04May04               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7411            Date 01Jun05               *
      *                 BUG6768            Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 BUG6164            Date 01Apr05               *
      *                 BUG5517            Date 19Jan05               *
      *                 BUG4560 (Reversed) Date 04Nov04               *
      *                 BUG4560            Date 06Sep04               *
      *                 BUG4422            Date 01Oct04               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 225791 (BG1771)    Date 16Mar03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 208100             Date 05Aug02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 176841             Date 09May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 09Mar97               *
      *                 154477             Date 29Jan99               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL098 - Cancelled Deal Numbers                              *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  AR665113 - Check if deal no. is used for rollover of deals.  *
      *             (CHILD: AR665114)                                 *
      *  260452 - DL: Impossible to reject the amendment of MM deal   *
      *           - "Deal has matured". Remove validation for         *
      *           Back-valued Maturity Date (Reverse BUG10315).       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR996631 - System should not validate deal number range      *
      *             if PEA indicator is on                            *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  259924A- Amended so that system will validate front office   *
      *           ID that came from Meridian.                         *
      *  259924 - Amended so that program will check front office ID  *
      *           in all deals.                                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256795 - Penalty termination of time deposits (CDL052).      *
      *  241948 - Delete requested, deal status is not C or A.        *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  238211 - When authorising deal, remove validation of         *
      *           historic associated deals.                          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10315 - LDNI: Amend System allowed amendment of matured   *
      *             deal                                              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CDL033 - Floating rate CDs issued (Recompile)                *
      *  BUG7411-CDL028 fields missing from DLGHISPD (Recompile)
      *  BUG6768- Correct conditioning of 'Item under review by       *
      *           Compliance Officer'.                                *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  BUG6164- During WIP authorisation HKDSTS can be 'A'.         *
      *  BUG5517- Authorisation Error on LDNI.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  BUG4560 - Reopened - Reversed out.                           *
      *         - This fix was intended to be cosmetic but actually   *
      *           allowed blocked deals to be amended.                *
      *  BUG4560- Block/Unblock is not permitted if deal is in WIP    *
      *           cycle, so allow 'amendment' of a blocked deal.      *
      *           This allows a blocked completed deal to be          *
      *           authorised through the WIP cycle.                   *
      *  BUG4422- Authorisation Error on LDNI.  Retrieve contents of  *
      *           DTAARA/ZMUSER for each user authorisation check.    *
      *  CMM105 - Core changes for GBO005                             *
      *           Fixed Deposits Held Under Lien                      *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:MMLDNIID02,MMLDNIIF01,           *
      *           Core hooks added:  MMLDNIIC26,MMLDNIIC25            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  225791 - Authorizations wrongly rejected (if rollover deal)  *
      *           BG1771 is applying this Release 5.0 fix to MidasPlus*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  208100 - Check for further errors in subroutine VALAX.       *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  196380 - Do not allow deletion of a deal that is still       *
      *           linked to a 'Live' Depot Movements.                 *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *  176841 - User should be able to re-authorise a deal if       *
      *           'MM Authorisation Required' is 'N' and              *
      *           'MM Reauthorise Amended deals' is 'Y'.              *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CGL011 - Collateral Processing for Midas. Recompile.         *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP006 - Do not check for MMM0164 if deal number has been    *
      *           generated through APIs                              *
      *  154477 - Recompile for change to MMDELDPP.                   *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)
     F                                     RENAME(MMDELDP0:MMDELFOI)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
     FDEALSCL1  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
     F                                     RENAME(DEALSDCF:DEALSRCF)                        AR665113
     FDLCANCI0  IF   E           K DISK    INFSR(*PSSR)                                       CDL098
      *                                                                                       CDL098
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,MMLDNIIF01
     FMMDELDL3  IF   E           K DISK    INFSR(*PSSR)                         CDL006
     F                                     RENAME(MMDELDP0:MMDELDP3)            CDL006
     F                                     PREFIX(F)                            CDL006
                                                                                              CAS004
      ** Midas AS Hedge Transation Fike                                                       CAS004
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
                                                                                              CAS004
      ** Midas AS Hedge Linkage File                                                          CAS004
     FASHGLKL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     PREFIX(LK:2)                                       CAS004
     FDPTMVR    IF   E           K DISK                                                       196380
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
     FDLFEEDL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS009
                                                                                              CAP185
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
     FFRNTOFCL1 IF   E           K DISK    INFSR(*PSSR)                                       259924
     F                                     RENAME(MMDELDP0:MMDELDX0)                          259924
     F                                     RENAME(MMDENBP0:MMDENBX0)                          259924
     F                                     RENAME(MMDENSP0:MMDENSX0)                          259924
     F                                     RENAME(ABDEALP0:ABDEALX0)                          259924
     F                                     RENAME(FXDEALP0:FXDEALX0)                          259924
     F                                     RENAME(DEALSDGF:DEALSGX0)                          259924
 
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
 
      **  Data structure for file status of MM deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS004
      ** External DS for Switchable Features Details                                          CAS004
     D  SCLCD        E                     EXTFLD(LCD)                                        CAS004
                                                                                              CAS004
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
      ** Deal in File Format
                                                                                              CAS004
     D                 DS                                                                     CAS004
     D FSHEDI                  1      6  0                                                    CAS004
     D FSHEDI_Char             1      6                                                       CAS004
 
     D/COPY WNCPYSRC,MMLDNIID01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *****************************************************************              BUG10315 260452
      ****Data*structure*for*date*in,*to*change*format.****************              BUG10315 260452
     D**********       DS                                                            BUG10315 260452
     D**DateIn**               1      8  0                                           BUG10315 260452
     D**@@YY****               1      4  0                                           BUG10315 260452
     D**@@MM****               5      6  0                                           BUG10315 260452
     D**@@DD****               7      8  0                                           BUG10315 260452
      *****************************************************************              BUG10315 260452
      ** Dealing Fiduciary                                                      CDL006
     D CDL006          S              1A   IMPORT                               CDL006
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D CDL098          S              1                                                       CDL098
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D PFunc           S              8                                                       CSD015
                                                                                              CAS004
     D PRetCode        S              7A                                                      CAS004
     D POption         S              7A                                                      CAS004
     D PSard           S              6A                                                      CAS004
                                                                                              CAS004
     D CAS004          S              1A                                                      CAS004
     D CAS009          S              1A                                                      CAS009
                                                                                              CAS004
     D KMod            S              2A                                                      CAS004
     D*KDlNo****       S              6  0                                             CAS004 CLE148
     D KDlNo           S              6                                                       CLE148
                                                                                              CAS004
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
 
     D/COPY WNCPYSRC,MMLDNIID02
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
     D P@OP01          S             20A                                                    AR996631
     D P@VL01          S            200A                                                    AR996631
     D P@OP02          S             20A                                                    AR996631
     D P@VL02          S            200A                                                    AR996631
     D P@OP03          S             20A                                                    AR996631
     D P@VL03          S            200A                                                    AR996631
     D P@OP04          S             20A                                                    AR996631
     D P@VL04          S            200A                                                    AR996631
     D P@OP05          S             20A                                                    AR996631
     D P@VL05          S            200A                                                    AR996631
     D P@OP06          S             20A                                                    AR996631
     D P@VL06          S            200A                                                    AR996631
     D P@OP07          S             20A                                                    AR996631
     D P@VL07          S            200A                                                    AR996631
     D P@OP08          S             20A                                                    AR996631
     D P@VL08          S            200A                                                    AR996631
     D P@OP09          S             20A                                                    AR996631
     D P@VL09          S            200A                                                    AR996631
     D P@OP10          S             20A                                                    AR996631
     D P@VL10          S            200A                                                    AR996631
     D WPEAInd         S              1A                                                    AR996631
     D CSC054          S              1A                                                    AR996631
      *                                                                                     AR996631
     D/COPY WNCPYSRC,MMH00082
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     IDPTMVDF                                                                                 196380
     I              RECI                        DRECI                                         196380
      *                                                                                       196380
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
 
      * INITIALIZATION
     C                   EXSR      INIT
 
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C     ModeofOp      OREQ      ' '                                                       259924A
     C     FOTRID        ANDNE     ' '                                                       259924A
     C     DDACTN        ANDEQ     'I'                                                       259924A
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,MMH00083
     C                   END
 
      * VALIDATE ACTION CODE & DEAL NUMBER
     C                   EXSR      VAL
      *                                                                                       256795
     C     CDL052        IFEQ      'Y'                                                        256795
     C     DDACTN        IFEQ      'A'                                                        256795
     C     DDACTN        OREQ      'D'                                                        256795
      *                                                                                       256795
     C                   Z-ADD     @@DLNO        @DLNO             6 0                        256795
      *                                                                                       256795
     C                   CALL      'MM5294'                                                   256795
     C                   PARM                    @DLNO                                        256795
     C                   PARM      *Blanks       @ERR              1                          256795
     C                   PARM      *Blanks       @ERRM            55                          256795
      *                                                                                       256795
     C     @ERR          IFEQ      'Y'                                                        256795
     C                   MOVE      'N'           OKDLNO                                       256795
     C                   ADD       1             Ix                                           256795
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               256795
     C     DDACTN        IFEQ      'A'                                                        256795
     C                   MOVEL     'MMM5400'     MsgIdArr(Ix)                                 256795
     C                   ENDIF                                                                256795
     C     DDACTN        IFEQ      'D'                                                        256795
     C                   MOVEL     'MMM5401'     MsgIdArr(Ix)                                 256795
     C                   ENDIF                                                                256795
     C                   ENDIF                                                                256795
     C                   ENDIF                                                                256795
     C                   ENDIF                                                                256795
      *                                                                                       256795
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC01
 
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the deal no. is not to be generated.)
     C     DDACTN        IFEQ      'I'
     C     DDDLNO        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
     C/COPY WNCPYSRC,MMH00084
 
     C/COPY WNCPYSRC,MMLDNIIC25
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
                                                                                CAP051
      * If the mode is 'Front Office transaction interface'                     CAP051
      * do authorisation are required                                           CAP051
     C     ModeofOp      IFEQ      '      '                                     CAP051
     C                   MOVE      *BLANKS       HKAUTH                         CAP051
     C                   ENDIF                                                  CAP051
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      * ACCESS DEAL WITH FRONT OFFICE TRANSACTION ID
     C*****FOTRID        CHAIN     MMDELFOI                           99                      259924
     C     FOTRID        CHAIN     FRNTOFCL1                          99                      259924
 
      * IF INSERT
     C     DDACTN        IFEQ      'I'
 
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      ** For CDL006, if record retrieved has no last change date yet (still to                209905
      ** be completed by UPM), not an error or the deal type of the record                    209905
      ** retrieved is 'FT'                                                                    209905
     C     *IN99         IFEQ      '0'
     C     CDL006        ANDNE     'Y'                                                        209905
     C     *IN99         OREQ      '0'                                                        209905
     C     HKLCD         ANDNE     0                                                          209905
     C     HKTYPE        ANDNE     'FT'                                                       209905
     C     CDL006        ANDEQ     'Y'                                                        209905
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
     C                   ELSE
 
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
      * IF NOT INSERT, UPDATE MIDAS DEAL NUMBER
     C                   MOVEL     HKDN38        DDDLNO
 
     C                   END
 
      * IF FRONT OFFICE ASSOCIATED TRANSACTION ID IS NOT BLANK
     C     FOASID        IFNE      *BLANK
     C     RepoFlag      ANDNE     'Y'                                                        CAP067
 
      * ERROR IF DEAL NOT FOUND
     C     FOASID        CHAIN     MMDELFOI                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
      * UPDATE MIDAS ASSOCIATED DEAL NUMBER
     C                   MOVEL     HKDN38        DDDADN
     C                   END
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER
      *****************************************************************
     C     VAL           BEGSR
                                                                                              CDL016
      **  If CDL016 is ON allow deals to be blocked                                           CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
                                                                                              CDL016
      **  Check that the action code is valid; if authorizations are                          CDL016
      **  not in the system, then action code X is not allowed.                               CDL016
                                                                                              CDL016
     C     BNMMAU        IFEQ      'N'                                                        CDL016
     C     BNMMRA        ANDEQ     'N'                                                        CDL016
     C     DDACTN        IFNE      *BLANK                                                     CDL016
     C     DDACTN        ANDNE     'I'                                                        CDL016
     C     DDACTN        ANDNE     'A'                                                        CDL016
     C     DDACTN        ANDNE     'D'                                                        CDL016
     C     DDACTN        ANDNE     'E'                                                        CDL016
     C     DDACTN        ANDNE     'B'                                                        CDL016
     C     DDACTN        ANDNE     'U'                                                        CDL016
     C                   MOVE      'N'           OKACTN                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0336'     MsgIdArr(Ix)                                 CDL016
     C                   ENDIF                                                                CDL016
     C                   ELSE                                                                 CDL016
                                                                                              CDL016
     C     DDACTN        IFNE      *BLANK                                                     CDL016
     C     DDACTN        ANDNE     'I'                                                        CDL016
     C     DDACTN        ANDNE     'A'                                                        CDL016
     C     DDACTN        ANDNE     'D'                                                        CDL016
     C     DDACTN        ANDNE     'E'                                                        CDL016
     C     DDACTN        ANDNE     'X'                                                        CDL016
     C     DDACTN        ANDNE     'B'                                                        CDL016
     C     DDACTN        ANDNE     'U'                                                        CDL016
     C                   MOVE      'N'           OKACTN                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0335'     MsgIdArr(Ix)                                 CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      **  If the deal number is not blank, check that it is numeric.                          CDL016
     C                   TESTN                   DDDLNO               98                      CDL016
     C                   MOVE      DDDLNO        @@TEST            1                          CDL016
     C                   TESTZ                   @@TEST                   99                  CDL016
     C     DDDLNO        IFNE      *BLANKS                                                    CDL016
     C     *IN98         ANDEQ     '0'                                                        CDL016
     C     DDDLNO        ORNE      *BLANKS                                                    CDL016
     C     *IN99         ANDEQ     '0'                                                        CDL016
     C                   MOVE      'N'           OKDLNO                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0162'     MsgIdArr(Ix)                                 CDL016
     C                   GOTO      EVAL                                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      **  If CDL016 is OFF do original processing                                             CDL016
     C                   ELSE                                                                 CDL016
 
      **  Check that the action code is valid; if authorizations are
      **  not in the system, then action code X is not allowed.
 
     C     BNMMAU        IFEQ      'N'
     C     BNMMRA        ANDEQ     'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0161'     MsgIdArr(Ix)
     C                   END
     C                   ELSE                                                                 176841
 
     C*****BNMMAU        IFNE      'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0160'     MsgIdArr(Ix)
     C                   END
     C                   END                                                                  176841
 
      **  If the deal number is not blank, check that it is numeric.
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     DDDLNO        ORNE      *BLANKS
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0162'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      **  Action codes 'B' and 'U' are same as Amend, therefore set                           CDL016
      **  Action code to be 'A' and set the Blocked Action code.                              CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'B'                                                        CDL016
     C                   MOVE      'A'           DDACTN                                       CDL016
     C                   MOVE      'B'           BUACT                                        CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'U'                                                        CDL016
     C                   MOVE      'A'           DDACTN                                       CDL016
     C                   MOVE      'U'           BUACT                                        CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
 
      **  Set up the deal number as a numeric field.
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
 
      **  If the deal number is blank, it is an error.
 
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC09
 
     C**  If there is no valid record on MMDEALLL, it is an error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
     C**  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
 
      **  If the deal status is not C,A, R or M, it is an error.
     C     HKDSTS        IFNE      'C'
     C     HKDSTS        ANDNE     'A'
     C     HKDSTS        ANDNE     'R'
     C     HKDSTS        ANDNE     'M'
     C/COPY WNCPYSRC,MMLDNIIC04
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0168'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC05
 
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR
 
     C**  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC10
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
     C**  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC02
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANK
     C     HKDDLT        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0165'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ELSE
 
      **  If the deal status is not C or R, it is an error.
     C     HKDSTS        IFNE      'C'
     C     HKDSTS        ANDNE     'R'
     C     HKDSTS        ANDNE     'A'                                                       BUG6164
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0171'     MsgIdArr(Ix)
     C                   GOTO      EVALAX                                                     208100
     C                   ELSE
 
      **  If the rollover/bought/sold indicator is N, use the deal's
      **  related deal number to access the related deal.
     C     HKRBSI        IFEQ      'N'
     C                   MOVE      HKDADN        @@RDNO            6 0
     C     @@RDNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
 
      **  If no valid record is found, or the record does not have a
      **  status of 'A' or 'R', it is an error.
      * - If associated deal is not found (already historic)
      *   and status 'R' required Reauth. allows authorisation
      * - If associated deal is matured  allows authorisation
     C******IN65         IFEQ      '1'                                                        238211
     C*****HKDSTS        ANDNE     'R'                                                        238211
     C*****HKDLTF        ORNE      *BLANK                                                     238211
     C     *IN65         IFEQ      '0'                                                        238211
     C     HKDLTF        ANDNE     *BLANK                                                     238211
     C     HKDSTS        ORNE      'A'
     C     *IN65         ANDEQ     '0'                                                        238211
     C     HKDSTS        ANDNE     'R'
     C     HKDSTS        ANDNE     'M'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0173'     MsgIdArr(Ix)
     C                   GOTO      EVALAX                                                     208100
 
     C**********         ELSE                                                                 208100
      ****No*error*so chain to the deals file, to set up the file                             208100
      ****fields*with the current deal's values.                                              208100
     C*****@@DLNO        CHAIN     MMDEALLL                           65                      208100
     C**********         GOTO      EVALAX                                                     208100
     C                   END
     C                   END
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC06
                                                                                             BUG6768
      ** If Compliance Watch is enabled, check for pending cases.                            BUG6768
 
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C**********                   AND (CSC011 = 'N' OR CSC011 = 'Y'                  CSD015 BUG6768
     C**********                   AND LIBR = S1MAIN) AND OKDLNO <> 'N'               CSD015 BUG6768
     C                   IF        CSC011 <> 'Y'                                             BUG6768
     C                             OR (CSC011 = 'Y' AND LIBR = S1MAIN)                       BUG6768
                                                                                              CSD015
      ** If the FRA transaction exists, setup error message                                   CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'MMDELDPP'                                     CSD015
     C                   MOVEL     HKDN38        WIdntifier                                   CSD015
     C                   EVAL      WBranch = HKBRCA                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   If        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                         CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   EVAL      FldNameArr(Ix) = 'DDDLNO'                                  CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                               BUG6768
                                                                                             BUG6768
     C                   ENDIF                                                                CSD015
      *                                                                                       225791
      **  Access the deals file, to set up the file                                           225791
      **  fields with the current deal's values.                                              225791
     C     @@DLNO        CHAIN     MMDEALLL                           65                      225791
                                                                                              CSD015
      ***Retrieve*latest content of DTAARA/ZMUSER                                   BUG4422  BUG5517
      **************                                                                BUG4422  BUG5517
     C**************     IN        ZMUSER                                           BUG4422  BUG5517
     C**************     UNLOCK    ZMUSER                                           BUG4422  BUG5517
 
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C                   IF        CAP185 = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'Y' AND                                           CAP185
     C                             @TYPE = '1'                                                CAP185
      *                                                                                       CAP185
      ** User cannot authorise an authorised deal or deal requires                            CDL010
      ** double authorisation.                                                                CDL010
      *                                                                                       CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C     HKUSER        ANDEQ     ZUSER                                                      CDL010
     C                   MOVE      'N'           OKDLNO                                       CDL010
     C                   ADD       1             Ix                                           CDL010
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL010
     C                   MOVEL     'MMM0702'     MsgIdArr(Ix)                                 CDL010
     C                   GOTO      EVALAX                                                     CDL010
     C                   END                                                                  CDL010
                                                                                              CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       208100
      ****No*error*so*chain*to the deals file, to set up the file                      208100 225791
      ****fields*with*the*current deal's values.                                       208100 225791
     C*****@@DLNO********CHAIN     MMDEALLL                           65               208100 225791
      *                                                                                       208100
      *                                                                                       208100
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      **  Check that the deal does not exist on any Deals File
      **  Midas or DRS. If it does it's an error.
     C     @@DLNO        SETLL     DEALSALL                               65
      *                                                                                     AR665113
      ** Check that deal no. is not used as rollover of any deals                           AR665113
      *                                                                                     AR665113
     C                   IF        *IN65 = '0'                                              AR665113
     C     @@DLNO        SETLL     DEALSCL1                               65                AR665113
     C                   ENDIF                                                              AR665113
      *                                                                                     AR665113
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0163'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
 
      *                                                                                       CDL098
     C     CDL098        IFeq      'Y'                                                        CDL098
     C     @@DLNO        Setll     DLCANCI0                               65                  CDL098
      *                                                                                       CDL098
     C     *IN65         IFeq      '1'                                                        CDL098
     C                   Move      'N'           OKDLNO                                       CDL098
     C                   Add       1             Ix                                           CDL098
     C                   MoveL     'DDDLNO'      FldNameArr(Ix)                               CDL098
     C                   MoveL     'FXM7004'     MsgIdArr(Ix)                                 CDL098
     C                   GOTO      EVALAI                                                     CDL098
     C                   Endif                                                                CDL098
     C                   Endif                                                                CDL098
      *                                                                                       CDL098
 
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      **  Check that the deal number is in the allowed range.
      ** (do not check if deal number generated through APIs)                   CAP006
     C     @@DLNO        IFLT      NORDLN
     C     @@DLNO        OREQ      999999
     C     ModeofOp      IFNE      '*FRONT'                                     CAP006
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0164'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END                                                    CAP006
     C                   END
     C                   ENDIF                                                              AR996631
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC12
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      **  If the deal has been deleted, then it may not be amended.
     C     HKDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0172'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      *****************************************************************              BUG10315 260452
      ****Check*if*deal*past*maturity.*********************************              BUG10315 260452
      *****************************************************************              BUG10315 260452
     C**********         Z-ADD     HKMDYY        @@YY                                BUG10315 260452
     C**********         Z-ADD     HKMDMM        @@MM                                BUG10315 260452
     C**********         Z-ADD     HKMDDD        @@DD                                BUG10315 260452
     C*****DateIn        IFNE      0                                                 BUG10315 260452
     C**********         CALLB     'ZDATE10'                                         BUG10315 260452
     C**********         PARM                    DateIn                              BUG10315 260452
     C**********         PARM                    ZZMDNO            5 0               BUG10315 260452
     C*****ZZMDNO        IFLT      BJRDNB                                            BUG10315 260452
     C**********         MOVE      'N'           OKDLNO                              BUG10315 260452
     C**********         ADD       1             Ix                                  BUG10315 260452
     C**********         MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG10315 260452
     C**********         MOVEL     'ABM0201'     MsgIdArr(Ix)                        BUG10315 260452
     C**********         GOTO      EVALAA                                            BUG10315 260452
     C**********         ENDIF                                                       BUG10315 260452
     C**********         ENDIF                                                       BUG10315 260452
      *****************************************************************              BUG10315 260452
      **  If the record exists, its status must be C,A or R.
     C     HKDSTS        IFNE      'C'
     C     HKDSTS        ANDNE     'A'
     C     HKDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0166'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
                                                                                              CDL016
      **  Blocked/Unblock validation                                                          CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
      **  A Blocked Deal cannot be amended                                                    CDL016
      ****Amendment*is*now*done*through*WIP*so*only*stop*amending*'COMPLETE'*deals.  BUG4560 BUG4560
     C     HKBLKA        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     BUACT         IFNE      'B'                                                        CDL016
     C     BUACT         ANDNE     'U'                                                        CDL016
     C*****HKDSTS        ANDEQ     'C'                                               BUG4560 BUG4560
     C                   MOVE      'N'           OKDLNO                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0337'     MsgIdArr(Ix)                                 CDL016
     C                   GOTO      EVALAA                                                     CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      **  Deal is already Blocked                                                             CDL016
     C     BUACT         IFEQ      'B'                                                        CDL016
     C     HKBLKA        ANDEQ     'Y'                                                        CDL016
     C                   MOVE      'N'           OKDLNO                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0338'     MsgIdArr(Ix)                                 CDL016
     C                   GOTO      EVALAA                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      **  Deal is already Unblocked                                                           CDL016
     C     BUACT         IFEQ      'U'                                                        CDL016
     C     HKBLKA        ANDNE     'Y'                                                        CDL016
     C                   MOVE      'N'           OKDLNO                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0339'     MsgIdArr(Ix)                                 CDL016
     C                   GOTO      EVALAA                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
     C/COPY WNCPYSRC,MMLDNIIC07
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
      *                                                                                       196380
     C                   ELSE                                                                 196380
      *                                                                                       196380
      **  Further check if Deal Number to be deleted is not linked to                         196380
      **  any 'Live' Depot Movement.  Otherwise, send error message.                          196380
      *                                                                                       196380
     C     DDDDMR        CHAIN     DPTMVR                             88                      196380
      *                                                                                       196380
     C     *IN88         IFEQ      '0'                                                        196380
     C     DRECI         ANDEQ     'D'                                                        196380
     C                   MOVE      'N'           OKDLNO                                       196380
     C                   ADD       1             Ix                                           196380
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               196380
     C                   MOVEL     'MMM1009'     MsgIdArr(Ix)                                 196380
     C                   GOTO      EVALAD                                                     196380
     C                   ENDIF                                                                196380
      *                                                                                       196380
     C                   END
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  If a valid record exists and the deal deleted indicator is
      **  not blank, it is an error.
     C     HKDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0172'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  Disallow deletion of Internal Funding Deals
     C     HKTYPE        IFEQ      'IL'
     C     HKTYPE        OREQ      'ID'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0112'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      ****The*deal*status must be C or A.                                                     241948
      **  The deal status must be C or A or R.                                                241948
      *                                                                                       241948
     C     HKDSTS        IFNE      'C'
     C     HKDSTS        ANDNE     'A'
     C     HKDSTS        ANDNE     'R'                                                        241948
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0169'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
                                                                                CDL006
      ** Fiduciary placings                                                     CDL006
      ** Read file to access all related taking deals.                          CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     HKTYPE        ANDEQ     'FL'                                         CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     HKTYPE        ANDEQ     'LP'                                         CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     HKTYPE        ANDEQ     'DP'                                         CDL006
                                                                                CDL006
     C                   Z-ADD     HKDN38        WDLNO             6 0          CDL006
     C     WDLNO         SETLL     MMDELDL3                                     CDL006
     C     WDLNO         READE     MMDELDL3                               60    CDL006
     C     *IN60         DOWEQ     *OFF                                         CDL006
     C     FHKDDLT       IFNE      'D'                                          CDL006
     C     FHKDSTS       ANDNE     'C'                                          CDL006
     C     FHKDSTS       ANDNE     'A'                                          CDL006
     C                   MOVE      'N'           OKDLNO                         CDL006
     C                   ADD       1             Ix                             CDL006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CDL006
     C                   MOVEL     'MMM9003'     MsgIdArr(Ix)                   CDL006
     C**********         MOVEL     FHKDN38       MsgDtaArr(Ix)                       CDL006 MD000091
     C                   MOVEL     FHKDN38       MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   GOTO      EVALAD                                       CDL006
     C                   ENDIF                                                  CDL006
     C     WDLNO         READE     MMDELDL3                               60    CDL006
     C                   ENDDO                                                  CDL006
                                                                                CDL006
     C                   ENDIF                                                  CDL006
 
      **  Access the deal amendments file; if a live amendment exists
      **  for the deal, this is an error.
      **  Set the deam file pointer to be before any deam for the deal.
     C                   MOVE      DDDLNO        @DEAMN
     C                   MOVE      *ZEROS        @VDYY
     C                   MOVE      *ZEROS        @VDMM
     C                   MOVE      *ZEROS        @VDDD
     C                   MOVE      *ZEROS        @DEAMS
     C     @DEAMK        SETLL     MMLVDMLL
 
      **  Read the next record on file.
     C                   READ      MMLVDMLL                               65
     C                   MOVE      HNDA38        @DA38             6
 
      **  Read through the deal amendments until one of the following
      **  conditions obtains...
      **  - the end of file has been reached.
      **  - the deal no. of the record found is not the same as that
      **    used in the access.
      **  - a valid deal amendment has been found; an error.
     C     *IN65         DOWEQ     '0'
     C     @DA38         IFEQ      DDDLNO
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0170'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ELSE
     C                   MOVE      '1'           *IN65
     C                   END
     C                   READ      MMLVDMLL                               65
     C                   END
      ** IF THE 'ROLLED OVER BY' IS NOT BLANK, USE ITS VALUE TO ACCESS
      ** THE DRS DEALS FILE. IF A LIVE RECORD IS FOUND, IT IS AN ERROR.
     C     HKROBY        IFNE      *BLANKS
     C                   MOVE      HKROBY        @@RDNO
     C     @@RDNO        CHAIN     MMDEALLL                           65
     C     *IN65         IFEQ      '0'
     C     HKDLTF        ANDEQ     *BLANKS
     C     HKDDLT        ANDNE     'D'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0174'     MsgIdArr(Ix)
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC08
 
      **  Chain to the deals file, to set up the file fields with the
      **  current deal's values.
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C                   GOTO      EVALAD
     C                   END
                                                                                              CAS004
      ** Issue warning if deal to be deleted is a hedged item                                 CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   MOVE      DDDLNO        KDlNo                                        CAS004
                                                                                              CAS004
      ** Check if Hedge Transaction file for the Deal                                         CAS004
                                                                                              CAS004
     C     KTran         SETLL     ASHTRNLA                                                   CAS004
     C     KTran         READE     ASHTRNLA                                                   CAS004
                                                                                              CAS004
      ** Check for the Hedge Linkage if Effective or Discontinued                             CAS004
                                                                                              CAS004
     C                   DOW       NOT %EOF(ASHTRNLA)                                         CAS004
                                                                                              CAS004
     C     FSHEDI        CHAIN     ASHGLKL0                                                   CAS004
                                                                                              CAS004
      ** If record is not found, database error                                               CAS004
                                                                                              CAS004
     C                   IF        NOT %FOUND(ASHGLKL0)                                       CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'ASHGLKPD'                                        CAS004
     C                   EVAL      DBKEY = FSHEDI_Char                                        CAS004
     C                   EVAL      DBASE = 906                                                CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** If Hedge Linkage is effective or discontinued, issue warning message                 CAS004
                                                                                              CAS004
     C                   IF        FSHTID = 'D' AND LKRECI = 'D' OR                           CAS004
     C                             FSHTID = 'D' AND LKRECI = 'X'                              CAS004
     C                   EVAL      WIdx = WIdx + 1                                            CAS004
     C                   EVAL      WFldNamArr(WIdx) = 'DDDLNO'                                CAS004
     C                   EVAL      WMsgIdArr(WIdx)  = 'MMM3400'                               CAS004
     C                   GOTO      EVALAD                                                     CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     KTran         READE     ASHTRNLA                                                   CAS004
     C                   ENDDO                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CDL016
      **  Blocked/Unblock validation                                                          CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
      **  A Blocked Deal cannot be deleted                                                    CDL016
     C     HKBLKA        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     BUACT         IFNE      'B'                                                        CDL016
     C     BUACT         ANDNE     'U'                                                        CDL016
     C                   MOVE      'N'           OKDLNO                                       CDL016
     C                   ADD       1             Ix                                           CDL016
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL016
     C                   MOVEL     'MMM0337'     MsgIdArr(Ix)                                 CDL016
     C                   GOTO      EVALAD                                                     CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
 
      **  Check if a lived adjustment to yield fee is attached to the deal. If yes,           CAS009
      **  send an error message.                                                              CAS009
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C     @@DLNO        CHAIN     DLFEEDL1                           89                      CAS009
     C                   DOW       *IN89 = *OFF                                               CAS009
     C                   IF        DFRECI = 'D'                                               CAS009
     C                             AND DFADJY = 'Y'                                           CAS009
      *                                                                                       CAS009
     C                   MOVE      'N'           OKDLNO                                       CAS009
     C                   ADD       1             Ix                                           CAS009
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CAS009
     C                   MOVEL     'DLM1026'     MsgIdArr(Ix)                                 CAS009
     C                   GOTO      EVALAD                                                     CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C     @@DLNO        READE     DLFEEDL1                               89                  CAS009
     C                   ENDDO                                                                CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
 
      * If not multi-branching, check authority to only action code
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
 
      * If multi-branching, check authority to booking branch
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        IFEQ      'I'
     C     DDBRCA        IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   MOVE      BRC           DDBRCA
     C                   ELSE
     C                   MOVE      DDBRCA        ZBR
     C                   END
     C                   ELSE
     C                   MOVE      HKBRCA        ZBR
     C                   END
     C     DDACTN        IFEQ      'I'
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'MMM0115'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   ELSE
     C                   MOVEL     A8BRCD        ZBR
     C                   MOVEL     A8BRCD        DDBRCA
     C                   END
     C                   END
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C     ACTRJ         ANDNE     'Y'                                                      AR701789
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
 
      * Check authority to originating branch
     C     BKOBUV        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      HKORBR        ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
 
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      * CLEAR OUTPUTS
     C                   CLEAR                   DealFilFmt
     C/COPY WNCPYSRC,MMLDNIIC13
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKBRCA
     C                   EVAL      WIdx = *ZEROS                                              CAS004
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR            6                          196380
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN            6
      * Booking branch
     C                   PARM                    DDBRCA            3
      * REPO Flag                                                                             CAP067
     C                   PARM                    RepoFlag          1                          CAP067
 
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
     C/COPY WNCPYSRC,MMLDNIIC14
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
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
     C/COPY WNCPYSRC,MMLDNIIC26
 
      ** Initialize program name
 
     C                   MOVEL     'MMLDNIRTV'   DBPGM
 
      * Key Lists
     C     @DEAMK        KLIST
     C                   KFLD                    @DEAMN            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
 
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS GENERAL LEDGER DETAILS
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS DEALING DETAILS
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C/COPY WNCPYSRC,MMLDNIIC03
      *                                                                                       256795
     C                   CALLB     'AOSARDR0'                                                 256795
     C                   PARM      *BLANKS       PRetCode                                     256795
     C                   PARM      '*VERIFY'     POption                                      256795
     C                   PARM      'CDL052'      PSard                                        256795
     C     SCSARD        PARM      SCSARD        DSFDY                                        256795
     C     @RTCD         IFEQ      *BLANK                                                     256795
     C                   MOVEL     'Y'           CDL052            1                          256795
     C                   else                                                                 256795
     C                   MOVEL     'N'           CDL052            1                          256795
     C                   ENDIF                                                                256795
 
      ** ACCESS DEAL NUMBER RECORD
     C     1             CHAIN     FDDLNMLL                           99
 
      * DATABASE ERROR
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Check if CSC011 is installed                                                         CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *Blanks                                         CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 905                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancment (CSD015) is on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) AND                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF'                                     CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   END                                                                  CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Hedge Accounting is installed                                               CAS004
                                                                                              CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRetCode                                     CAS004
     C                   PARM      '*VERIFY'     POption                                      CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRetCode = *BLANKS                                         CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   IF        PRetCode <> '*NRF   '                                      CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY  = 'CAS004'                                          CAS004
     C                   EVAL      DBASE  = 905                                               CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Klist for Hedge Transaction File                                                     CAS004
                                                                                              CAS004
     C     KTran         KLIST                                                                CAS004
     C                   KFLD                    KMod                                         CAS004
     C                   KFLD                    KDlNo                                        CAS004
                                                                                              CAS004
     C                   EVAL      KMod = 'DL'                                                CAS004
 
      **    Check if Dealing Transaction Authorisation is installed                           CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       @RTCD             7                          CDL010
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL010
     C                   PARM      'CDL010'      @SARD             6                          CDL010
     C                   PARM                    DSFDY                                        CDL010
      *                                                                                       CDL010
     C     @RTCD         IFEQ      *BLANK                                                     CDL010
     C                   MOVE      'Y'           CDL010            1                          CDL010
     C                   ELSE                                                                 CDL010
     C     @RTCD         IFEQ      '*NRF'                                                     CDL010
     C                   MOVE      'N'           CDL010                                       CDL010
     C                   ELSE                                                                 CDL010
      *                                                                                       CDL010
      **    Database error processing                                                         CDL010
      *                                                                                       CDL010
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CDL010
     C                   MOVEL     '905'         DBASE                          * DBERR 905 * CDL010
     C                   MOVEL     'CDL010'      DBKEY                          ************* CDL010
     C                   EXSR      *PSSR                                                      CDL010
     C                   END                                                                  CDL010
     C                   END                                                                  CDL010
      *                                                                                       CDL010
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
      *                                                                                       CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRetCode                                     CDL016
     C                   Parm      '*VERIFY'     POption                                      CDL016
     C                   Parm      'CDL016'      PSard                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRetCode = *Blanks                                         CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL016
      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   CALL      'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRetCode                                     CAS009
     C                   PARM      '*VERIFY'     POption                                      CAS009
     C                   PARM      'CAS009'      PSard                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
     C                   IF        PRetCode = *BLANKS                                         CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   ELSE                                                                 CAS009
     C                   IF        PRetCode <> '*NRF   '                                      CAS009
     C     *LOCK         IN        LDA                                                        CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBKEY  = 'CAS009'                                          CAS009
     C                   EVAL      DBASE  = 909                                               CAS009
     C                   OUT       LDA                                                        CAS009
     C                   EXSR      *PSSR                                                      CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAP185
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   IF        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'LDNI'        @APINAME                                     CAP185
     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
     C                   IF        %FOUND(APICFGL0)                                           CAP185
     C                   MOVE      APAUT         @AUTHO            1                          CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ELSE                                                                 CAP185
     C                   IF        @RTCD = '*NRF'                                             CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ELSE                                                                 CAP185
     C*                                                                                       CAP185
     C**    Database error processing                                                         CAP185
     C*                                                                                       CAP185
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
     C                   EXSR      *PSSR                                                      CAP185
     C                   END                                                                  CAP185
     C                   END                                                                  CAP185
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF'                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 910                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CDL098
      ** Check if Cancelled Deal Numbers Enhancement (CDL098) is on.                          CDL098
                                                                                              CDL098
     C                   EVAL      CDL098 = 'N'                                               CDL098
     C                   CALLB     'AOSARDR0'                                                 CDL098
     C                   PARM      *BLANKS       PRetCode                                     CDL098
     C                   PARM      '*VERIFY'     POption                                      CDL098
     C                   PARM      'CDL098'      PSard                                        CDL098
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL098
                                                                                              CDL098
      ** Database error                                                                       CDL098
                                                                                              CDL098
     C                   IF        (PRetCode <> *BLANKS) and                                  CDL098
     C                             (PRetCode <> '*NRF   ')                                    CDL098
     C     *LOCK         IN        LDA                                                        CDL098
     C                   EVAL      DBKEY = 'CDL098'                                           CDL098
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL098
     C                   EVAL      DBASE = 911                                                CDL098
     C                   OUT       LDA                                                        CDL098
     C                   EXSR      *PSSR                                                      CDL098
     C                   ENDIF                                                                CDL098
      *                                                                                       CDL098
     C                   IF        PRetCode = *BLANKS                                         CDL098
     C                   EVAL      CDL098 = 'Y'                                               CDL098
     C                   ENDIF                                                                CDL098
      *                                                                                       CDL098
      *                                                                                     AR996631
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       @RTCD                                      AR996631
     C                   PARM      '*VERIFY'     @OPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
      *                                                                                     AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
      *                                                                                     AR996631
     C                   IF        @RTCD <> *BLANKS                                         AR996631
     C                             AND @RTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        @RTCD = *BLANKS                                          AR996631
     C                   EVAL      CSC054 = 'Y'                                             AR996631
      *                                                                                     AR996631
     C                   CALL      'AOSVALR0'                                               AR996631
     C                   PARM      *BLANKS       PRetCode                                   AR996631
     C                   PARM      PSysVal1      P@OP01                                     AR996631
     C                   PARM      *BLANKS       P@VL01                                     AR996631
     C                   PARM      *BLANKS       P@OP02                                     AR996631
     C                   PARM      *BLANKS       P@VL02                                     AR996631
     C                   PARM      *BLANKS       P@OP03                                     AR996631
     C                   PARM      *BLANKS       P@VL03                                     AR996631
     C                   PARM      *BLANKS       P@OP04                                     AR996631
     C                   PARM      *BLANKS       P@VL04                                     AR996631
     C                   PARM      *BLANKS       P@OP05                                     AR996631
     C                   PARM      *BLANKS       P@VL05                                     AR996631
     C                   PARM      *BLANKS       P@OP06                                     AR996631
     C                   PARM      *BLANKS       P@VL06                                     AR996631
     C                   PARM      *BLANKS       P@OP07                                     AR996631
     C                   PARM      *BLANKS       P@VL07                                     AR996631
     C                   PARM      *BLANKS       P@OP08                                     AR996631
     C                   PARM      *BLANKS       P@VL08                                     AR996631
     C                   PARM      *BLANKS       P@OP09                                     AR996631
     C                   PARM      *BLANKS       P@VL09                                     AR996631
     C                   PARM      *BLANKS       P@OP10                                     AR996631
     C                   PARM      *BLANKS       P@VL10                                     AR996631
      *                                                                                     AR996631
     C                   IF        PRetCode  <> *BLANKS                                     AR996631
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR996631
     C                   EVAL      DBKEy = '*KEY   '                                        AR996631
     C                   EVAL      DBase = 4                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   MOVEL     P@VL01        WPEAInd                                    AR996631
      *                                                                                     AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                       CAP185
      ****GET*ZMUSER to access default branch.                                               BUG5517
     C******DTAARA**     DEFINE                  ZMUSER                                      BUG5517
     C**************     IN        ZMUSER                                                    BUG5517
     C**************     UNLOCK    ZMUSER                                                    BUG5517
     C/COPY WNCPYSRC,MMH00085
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
