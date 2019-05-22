     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Invalid accounts repair')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADRPR - INVALID ACCOUNTS SCREEN INPUT                    *
      *                                                               *
      *  Function:  This function allows invalid Accounts to          *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 222427             Date 05Dec16               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR899028           Date 25Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR847269           Date 09Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247342             Date 07Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243973             Date 15Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 LLN022             Date 24Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAAA03             Date 30Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 194431             Date 22May02               *
      *                 198865             Date 25Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 190343             Date 07Dec01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 02Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189774             Date 13Feb01               *
      *                 180721             Date 04May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186718             Date 15Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176842             Date 01Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP011             Date 23Dec99               *
      *                 CAP014             Date 21Dec99               *
      *                 CAP013             Date 19Nov99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 28May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  222427 - AMAN - 'Extra Daily Statement Commission' default   *
      *           value is 0.00.  Data structure which includes       *
      *           DDSTFQ should be included in the parameter list on  *
      *           call to module GLAMAD4DT.                           *
      *           Partially Applied for MD042713.                     *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247342 - Replication is dumping due to 'BOGUS' accounts  AMAD*
      *           created during repair. Amended program to not clear.*
      *           Account Details when F-12 is pressed.               *
      *  243973 - to add missing account master extension record      *
      *           within file GLACNTQD, for accounts coming from      *
      *           MQSeries API Interface.                             *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAAA03 - Webfacing Changes                                   *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation.                        *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  194431 - Change parameter list to match changes in GLAMADRTV *
      *  198865 - DBASE 039 in GLAMADUPD because AMTNLU is zero.      *
      *           Add DUMP to debug '*RECUPD' returned from GLAMADUPD *
      *  CSC011 - 24x7 Midas Availability                             *
      *  190343 - Recompile over changed GLAMADUPD.                   *
      *  193883 - Recompile over changed GLAMADUPD.                   *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  189774 - Window processing for Account Details API program   *
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *  186718 - Fix for correcting indicators on errors on screen   *
      *  176842 - Fix for defaulting values to 4th screen             *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***ZATRNERRL0IF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FZATRNERRL2IF   E           K DISK    INFSR(*PSSR)                                       CGL029
 
     F***GLIAMADL0 IF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLIAMADL2 IF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     RENAME(GLIAMADD0 : GLIAMADX0)
     F***GLIAMADL1 UF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLIAMADL3 UF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     COMMIT
 
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
                                                                                              CSC011
     F***APILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                      CSC011 CGL029
     FAPILOGL1  UF   E           K DISK    INFSR(*PSSR) USROPN                                CGL029
     F                                     COMMIT                                             CSC011
 
     FGLIAMLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(GLIAMLXD6:RTVIDX1)                          CER001
     F                                     PREFIX(L:1)                                        CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      ** Account Master Extension File.                                                       243973
     FGLACNTL3  UF A E           K DISK    INFSR(*PSSR)                                       243973
     F                                     COMMIT                                             243973
                                                                                              243973
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLAMADR011
      *                                                                                      LLN022A
     FGLIAMADY0 UF   E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(GLIAMADD0 : IAMADD0)                       LLN022A
 
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
 
     D @EI             S              1    DIM(60)
 
 
      * Current Account in File Format
     D CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(C_)
      * Current Account in File Format (Extension File)
     D CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(CA_)
      * Current Account in File Format (Retail Int. & Chg. Extension File)
     D CARIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(CB_)
     D CARIFilFmt1             1    144                                                       CGL029
     D CARIFilFmtEx          146    218                                                       CGL029
      * Current Account in File Format (Retail Comm. Extension File)
     D CACOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(CC_)
     D CACOFilFmt1             1    286                                                       CGL029
     D CACOFilFmtEx          287    296                                                       CGL029
      **Current*Account*in*File*Format*(Retail*Password*Extension*File)                       CSD101
     D***CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)                                CSD101
     D***                                    PREFIX(CD_)                                      CSD101
     D***CAPWFilFmt1             1     33                                              CGL029 CSD101
     D***CAPWFilFmtEx           34     43                                              CGL029 CSD101
     D CAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CSD101
     D                                     PREFIX(CD_)                                        CSD101
     D CAPWFilFmt1             1    146                                                       CSD101
     D CAPWFilFmtEx          214    223                                                       CSD101
 
 
      * (Current) Account in Screen Format - Master Details
     D CurAcMast     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Debit Details
     D CurAcDebi     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Credit Details
     D CurAcCred     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Commision Details
     D CurAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Other Details
     D CurAcOthe     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@)
 
 
      * New Account in File Format
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)
      * New Extn. Account layout -> ACCNTBXC
     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D  GLBXACOD     E                     EXTFLD(QQACOD)                                     CGL029
      * New Extn. Account layout -> REIACD
     D NARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D  GLRIACOD     E                     EXTFLD(QQACOD)                                     CGL029
     D NARIFilFmt1             1    144                                                       CGL029
     D NARIFilFmtEx          212    284                                                       CGL029
      * New Extn. Account layout -> RECOMD
     D NACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)
     D  GLCOACOD     E                     EXTFLD(QQACOD)                                     CGL029
     D NACOFilFmt1             1    286                                                       CGL029
     D NACOFilFmtEx          354    363                                                       CGL029
      *** New Extn. Account layout -> REAPWDPD*************************                       CSD101
     D NAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)
     D  GLPWACOD     E                     EXTFLD(QQACOD)                              CGL029 CSD101
     D***NAPWFilFmt1             1     33                                              CGL029 CSD101
     D***NAPWFilFmtEx          101    110                                              CGL029 CSD101
     D NAPWFilFmt1             1    146                                                       CSD101
     D NAPWFilFmtEx          214    223                                                       CSD101
 
     D P1RIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 CGL029
     D                                     PREFIX(P1)                                         CGL029
     D P1RIFilFmt1             1    144                                                       CGL029
     D P1RIFilFmtEx          212    284                                                       CGL029
      * Account in File Format (Extension File)                                               CGL029
     D P1COFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 CGL029
     D                                     PREFIX(P2)                                         CGL029
     D P1COFilFmt1             1    286                                                       CGL029
     D P1COFilFmtEx          354    363                                                       CGL029
      * Account in File Format (Extension File)                                               CGL029
     D P1PWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CGL029
     D                                     PREFIX(P3)                                         CGL029
     D P1PWFilFmt1             1     33                                                       CGL029
     D P1PWFilFmtEx          101    110                                                       CGL029
      * Account in File Format (Extension File)                                               CGL029
 
      * New Account in Screen Format - Master Details
     D NewAcMast     E DS                  EXTNAME(GLAMADPD)
      * New Account in Screen Format - Debit Details
     D NewAcDebi     E DS                  EXTNAME(GLAMDIPD)
      * New Account in Screen Format - Credit Details
     D NewAcCred     E DS                  EXTNAME(GLAMCIPD)
      * New Account in Screen Format - Commision Details
     D NewAcComm     E DS                  EXTNAME(GLAMCOPD)
      * New Account in Screen Format - Other Details
     D NewAcOthe     E DS                  EXTNAME(GLAMODPD)
 
 
      * (Previous) Account in Screen Format - Master Details
     D PrvAcMast     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@P)
      * (Previous) Account in Screen Format - Debit Details
     D PrvAcDebi     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@P)
      * (Previous) Account in Screen Format - Credit Details
     D PrvAcCred     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@P)
      * (Previous) Account in Screen Format - Commision Details
     D PrvAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@P)
      * (Previous) Account in Screen Format - Other Details
     D PrvAcOthe     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@P)
 
 
      * Error indicators
     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      * External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
      *                                                                                       CER001
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CER001
      ** External data structure for Currency Details file                                    CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D InfData       E DS                  EXTNAME(GLAMIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** GL (AMAD) Extra Data - File (D/B) format                                             CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(GLAMEXPD)
      * GL Accounts Extra Data - File (D/B) format
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSD012
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
 
     D/COPY QWINDSRC,GLAMADDTA                                                                189774
                                                                                              189774
     D DATALUX         DS          1024                                                       CER001
     D  L1FLD1                 1      6  0                                                    CER001
      *                                                                                       CER001
     D  L1CNUM                 1      6                                                       CER001
     D  L1CCY                  7      9                                                       CER001
     D  L1ACOD                10     19                                                       CER001
     D  L1ACSQ                20     21                                                       CER001
     D  L1BRCA                22     24                                                       CER001
     D  L1ATYP                25     25                                                       CER001
     D  L1STFQ                26     26                                                       CER001
     D  L1AMNT                27     41  0                                                    CER001
     D  L1FOTR                45     84                                                       CER001
     D  L1TMST                85    110Z                                                      CER001
     D  L1DEXT               111    111                                                       CER001
                                                                                              CER001
      *                                                                                       CER001
     D NwDlScnFmt    E DS                  EXTNAME(GLAMRXPD)                                  CER001
      *                                                                                       CER001
      ** New Account in Screen Format (L6LX)                                                  CER001
      *                                                                                       CER001
     D NwDlFilFmt    E DS                  EXTNAME(GLVAMLX1PD)                                CER001
      *                                                                                       CER001
      ** New Account in File Format (#6LXWE)                                                  CER001
      *                                                                                       CER001
     D CrDlFilFmt    E DS                  EXTNAME(REACX1L0)                                  CER001
      *                                                                                       CER001
      ** Current Account in File Format (WE)                                                  CER001
      *                                                                                       CER001
     D QQACODC       E                     EXTFLD(QQACOD)                                     CER001
                                                                                              CER001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D*FormatM*********S*************10A   INZ('GLAMADPD')                                    186718
     D FormatM         S             10A   INZ('GLACCNPD')                                    186718
     D*FormatD*********S*************10A   INZ('GLAMDIPD')                                    186718
     D FormatD         S             10A   INZ('GLACCNPD')                                    186718
     D*FormatC*********S*************10A   INZ('GLAMCIPD')                                    186718
     D FormatC         S             10A   INZ('GLACCNPD')                                    186718
     D*FormatS*********S*************10A   INZ('GLAMCOPD')                                    186718
     D FormatS         S             10A   INZ('GLACCNPD')                                    186718
     D*FormatO*********S*************10A   INZ('GLAMODPD')                                    186718
     D FormatO         S             10A   INZ('GLACCNPD')                                    186718
 
     D FieldM          S             10A   INZ('DDACTN')
     D FieldD          S             10A   INZ('DDDRIB')
     D FieldC          S             10A   INZ('DDCRIB')
     D FieldS          S             10A   INZ('DDCEXA')
     D FieldO          S             10A   INZ('DDMINB')
 
     D FieldNo         S              5P 0
 
     D FldOffsetM      S              5P 0
     D FldOffsetD      S              5P 0
     D FldOffsetC      S              5P 0
     D FldOffsetS      S              5P 0
     D FldOffsetO      S              5P 0
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** Field to tell whether Commissions are to be displayed
     D CommDisp        S              1A
 
 
      ** Fields to hold Account Key to stop it from being overwritten
     D     ##DDCUSN    S                   LIKE(DDCUSN)
     D     ##DDCCY     S                   LIKE(DDCCY)
     D     ##DDACOD    S                   LIKE(DDACOD)
     D     ##DDACSQ    S                   LIKE(DDACSQ)
     D     ##DDBRCA    S                   LIKE(DDBRCA)
 
                                                                                CAP011
      ** Flags to indicate whether substitution is required in                  CAP011
      ** each of the various parts the transaction                              CAP011
     D RepMast         S              1A   inz('N')                             CAP011
     D RepDebi         S              1A   inz('N')                             CAP011
     D RepCred         S              1A   inz('N')                             CAP011
     D RepComm         S              1A   inz('N')                             CAP011
     D RepOthe         S              1A   inz('N')                             CAP011
 
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D CAP086          S              1A                                                      CAP086
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KFrntAscID      S             20A                                                      CGL029
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC011
      ** Fields Defined for CSD012                                                            CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqAccntMaint')                         CSD012
                                                                                              CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSD012
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
      *                                                                                       CER048
      ** Field defined for enhancement CER048                                                 CER048
      *                                                                                       CER048
     D WHit            S              1P 0 INZ(0)                                             CER048
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      *                                                                                       CER001
      ** Fields for enhancement CER001                                                        CER001
      *                                                                                       CER001
     D ULX606          S              1A   INZ('N')                                           CER001
     D PAction         S              1A                                                      CER001
     D PFind           S              1                                                       CER001
     D @CURR           S              3                                                       CER001
     D ZFIELD          S             16                                                       CER001
     D ZADEC           S              1  0                                                    CER001
     D w_PrvScn        S              1                                                       CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Key Fields for REACX1L0                                                              CER001
      *                                                                                       CER001
     D     K@CNUM      S                   LIKE(WECNUM)                                       CER001
     D     K@CCYC      S                   LIKE(WECCYC)                                       CER001
     D     K@ACOD      S                   LIKE(WEACOD)                                       CER001
     D     K@ACSQ      S                   LIKE(WEACSQ)                                       CER001
     D     K@BRCA      S                   LIKE(WEBRCA)                                       CER001
                                                                                              CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,GLAMADR012
 
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
      *
      /COPY WNCPYSRC,GLAMADR001
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKE         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   END
 
      * Clear externally-defined data structures to ensure that
      * packed decimal fields are correctly initialised; this is to
      * prevent decimal data errors in called procedures.
      *                                                                         180721
     C     @INKL         IFEQ      '1'                                          180721
     C     @INKE         OREQ      '1'                                          180721
     C                   MOVE      AMATYP        AMATYP_SAVE       1            180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     @INKL         IFNE      '1'                                                        247342
     C                   CLEAR                   NwAcFilFmt
     C                   ENDIF                                                                247342
      *                                                                         180721
     C     @INKL         IFEQ      '1'                                          180721
     C     @INKE         OREQ      '1'                                          180721
     C                   MOVE      AMATYP_SAVE   AMATYP                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     @INKL         IFNE      '1'                                                        247342
     C                   CLEAR                   NABXFilFmt
     C                   CLEAR                   NARIFilFmt
     C                   CLEAR                   NACOFilFmt
     C                   CLEAR                   NAPWFilFmt
     C                   EXSR      SRClear                                                    CGL029
     C                   ENDIF                                                                247342
 
      /COPY WNCPYSRC,GLAMADR002
     C                   IF        ULX606 = 'Y'                                               CER001
     C                   CLEAR                   CrAcFilFmt                                   CER001
     C                   ENDIF                                                                CER001
 
      * DO SCREEN: BROWSE INVALID ACCOUNTS
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,GLAMADR003
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLAMADR004
      *
      ** DO WHILE screen: Account Master Details Screen
      *
     C                   EXSR      SNDM@M
     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      Scrn@M
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLAMADR005
      *
      ** DO WHILE screen: Account Debit Details Screen
      *
     C                   EXSR      SNDM@D
     C                   Z-ADD     *ZERO         WIdx_DVAL         3 0
     C     @SCRN         DOWEQ     'D'
     C                   EXSR      Scrn@D
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLAMADR006
      *
      ** DO WHILE screen: Account Credit Details Screen
      *
     C                   EXSR      SNDM@C
     C                   Z-ADD     *ZERO         WIdx_CVAL         3 0
     C     @SCRN         DOWEQ     'C'
     C                   EXSR      Scrn@C
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLAMADR007
      *
      ** DO WHILE screen: Account Commision Details Screen
      *
     C                   EXSR      SNDM@S
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLAMADR008
      *
      ** DO WHILE screen: Account Other Details Screen
      *
     C                   EXSR      SNDM@O
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C                   ENDDO
      *                                                                                       CER001
      ** DO WHILE screen: Extension File                                                      CER001
      *                                                                                       CER001
     C     @SCRN         DOWEQ     'L'                                                        CER001
     C                   EXSR      Scrn@L                                                     CER001
     C                   ENDDO                                                                CER001
      *                                                                                       189774
      /COPY WNCPYSRC,GLAMADR015                                                               189774
      *                                                                                       189774
      ** DO WHILE screen: Window processing                                                   189774
      *                                                                                       189774
     C     @SCRN         DOWEQ     'W'                                                        189774
     C                   EXSR      Scrn@W                                                     189774
     C                   ENDDO                                                                189774
      *
      /COPY WNCPYSRC,GLAMADR009
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLAMADR010
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLAMADR013
 
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRClear -  Initialises Packed-type Variables to Zero         *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRClear       BEGSR                                                                CGL029
                                                                                              CGL029
     C                   EVAL      RINRCA = *ZEROS                                            CGL029
     C                   EVAL      RIRCA  = *ZEROS                                            CGL029
     C                   EVAL      RIMCLB = *ZEROS                                            CGL029
     C                   EVAL      RINOALT = *ZEROS                                           CGL029
     C                   EVAL      RITCHO = *ZEROS                                            CGL029
                                                                                              CGL029
     C                   EVAL      COFXDC = *ZEROS                                            CGL029
     C                   EVAL      COACCEA = *ZEROS                                           CGL029
     C                   EVAL      COACCC = *ZEROS                                            CGL029
     C                   EVAL      COGVDPE = *ZEROS                                           CGL029
     C                   EVAL      COGVDPC = *ZEROS                                           CGL029
     C                   EVAL      COACCRA = *ZEROS                                           CGL029
     C                   EVAL      COCACCC = *ZEROS                                           CGL029
     C                   EVAL      COCDIE = *ZEROS                                            CGL029
     C                   EVAL      COCDICA = *ZEROS                                           CGL029
     C                   EVAL      COCDRR = *ZEROS                                            CGL029
     C                   EVAL      COCCDIC = *ZEROS                                           CGL029
     C                   EVAL      COIACE = *ZEROS                                            CGL029
     C                   EVAL      COIACCC = *ZEROS                                           CGL029
     C                   EVAL      COCIACC = *ZEROS                                           CGL029
     C                   EVAL      COCMBE = *ZEROS                                            CGL029
     C                   EVAL      COCMBC = *ZEROS                                            CGL029
     C                   EVAL      COACCB = *ZEROS                                            CGL029
     C                   EVAL      COCCMBC = *ZEROS                                           CGL029
     C                   EVAL      COCHDBE = *ZEROS                                           CGL029
     C                   EVAL      COCHDBC = *ZEROS                                           CGL029
     C                   EVAL      COHDRB = *ZEROS                                            CGL029
     C                   EVAL      COCHDBR = *ZEROS                                           CGL029
     C                   EVAL      COCCHDBC = *ZEROS                                          CGL029
     C                   EVAL      COCCINST = *ZEROS                                          CGL029
     C                   EVAL      COVATAM = *ZEROS                                           CGL029
     C                   EVAL      CONOIS = *ZEROS                                            CGL029
     C                   EVAL      CONOCC = *ZEROS                                            CGL029
     C                   EVAL      COPESP = *ZEROS                                            CGL029
     C                   EVAL      CONOIP = *ZEROS                                            CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************                       CGL029
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID ACCOUNTS
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'GLAMADRPB'
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
      * Error in update of previous Account
     C                   PARM                    @ERRUP            1
      *
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
     C**********         PARM                    @FOTRANSEL       20                          CGL029
     C                   PARM                    @FOTRANSEL       40                          CGL029
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
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
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'GLAMADRPB'
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
      * Error in update of previous Account
     C                   PARM                    @ERRUP            1
      *
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
     C**********         PARM      *BLANK        @FOTRANSEL       20                          CGL029
     C                   PARM      *BLANK        @FOTRANSEL                                   CGL029
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID TRADE READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE SCREENS
      *
     C                   MOVEL     *BLANK        NewAcMast
     C                   MOVEL     *BLANK        NewAcDebi
     C                   MOVEL     *BLANK        NewAcCred
     C                   MOVEL     *BLANK        NewAcComm
     C                   MOVEL     *BLANK        NewAcOthe
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVE      *ALL'Y'       OKAcDebi
     C                   MOVE      *ALL'Y'       OKAcCred
     C                   MOVE      *ALL'Y'       OKAcComm
     C                   MOVE      *ALL'Y'       OKAcOthe
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve Account details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         CAP013
      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
      * module for SPF checking .                                               CAP013
      *                                                                         CAP013
     C*****ZATRNKX0      CHAIN     GLIAMADL0                          99               CAP013 CGL029
     C     ZATRNKX0      CHAIN     GLIAMADL2                          99                      CGL029
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDACCN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVACNT
      *
      * If Account details were retrieved
      * Convert the Account to screen format.
      *
     C*****C_CNUM        IFNE      *ZERO                                                      CSD027
     C     C_CNUM        IFNE      *BLANKS                                                    CSD027
     C     C_CCY         ANDNE     *BLANK
     C     C_ACOD        ANDNE     *ZERO
     C     C_ACSQ        ANDNE     *ZERO
     C     C_BRCA        ANDNE     *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTACNT
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
     C                   MOVEL     CABXFilFmt    NABXFilFmt
     C**********         MOVEL     CARIFilFmt    NARIFilFmt                                   CGL029
     C                   MOVEL     CARIFilFmt1   NARIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  NARIFilFmtEx                                 CGL029
     C**********         MOVEL     CACOFilFmt    NACOFilFmt                                   CGL029
     C                   MOVEL     CACOFilFmt1   NACOFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  NACOFilFmtEx                                 CGL029
     C**********         MOVEL     CAPWFilFmt    NAPWFilFmt                                   CGL029
     C                   MOVEL     CAPWFilFmt1   NAPWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  NAPWFilFmtEx                                 CGL029
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid trades file (except for the Midas Account Key
      * retrieved above using the front office transaction ID).
      * Access invalid Account with timestamp & front office transaction ID.
      *
     C                   MOVEL(P)  DDCUSN        ##DDCUSN
     C                   MOVEL(P)  DDCCY         ##DDCCY
     C                   MOVEL(P)  DDACOD        ##DDACOD
     C                   MOVEL(P)  DDACSQ        ##DDACSQ
     C                   MOVEL(P)  DDBRCA        ##DDBRCA
     C     ZATRNKX0      CHAIN     GLIAMADX0                          99
 
     C*****C_CNUM        IFNE      *ZERO                                                      CSD027
     C     C_CNUM        IFNE      *BLANKS                                                    CSD027
     C     C_CCY         ANDNE     *BLANK
     C     C_ACOD        ANDNE     *ZERO
     C     C_ACSQ        ANDNE     *ZERO
     C     C_BRCA        ANDNE     *BLANK
     C     DDACTN        ANDNE     'I'
     C                   MOVEL(P)  ##DDCUSN      DDCUSN
     C                   MOVEL(P)  ##DDCCY       DDCCY
     C                   MOVEL(P)  ##DDACOD      DDACOD
     C                   MOVEL(P)  ##DDACSQ      DDACSQ
     C                   MOVEL(P)  ##DDBRCA      DDBRCA
     C                   END
      *                                                                                       CER001
      ** Access LUX Invalids Data                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX606 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      DDCUSN        L1CNUM                                       CER001
     C                   MOVE      DDCCY         L1CCY                                        CER001
     C                   MOVE      DDACOD        L1ACOD                                       CER001
     C                   MOVE      DDACSQ        L1ACSQ                                       CER001
     C                   MOVE      DDBRCA        L1BRCA                                       CER001
     C                   MOVE      DDTMESTMP     L1TMST                                       CER001
     C                   EVAL      L1FOTR  =  DDFOTRANID + DDFOASOCID                         CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C                   MOVE      L1CNUM        K@CNUM                                       CER001
     C                   MOVE      L1CCY         K@CCYC                                       CER001
     C                   MOVE      L1ACOD        K@ACOD                                       CER001
     C                   MOVE      L1ACSQ        K@ACSQ                                       CER001
     C                   MOVE      L1BRCA        K@BRCA                                       CER001
      *                                                                                       CER001
      ** Now overwrite the fields on the main details screen with those                       CER001
      ** on the invalid extended deals file                                                   CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN     RTVIDX1                                                    CER001
     C                   IF        %Found(GLIAMLX1L0)                                         CER001
     C                   EVAL      L1DEXT = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SRINZ                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access Currency file to retrieve decimal position                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOCURRR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*KEY   '     @OPTN                                        CER001
     C                   PARM      DDCCY         @CURR                                        CER001
     C     SDCURR        PARM      SDCURR        DSSDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD <> *BLANK                                            CER001
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     @CURR         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                         CAP011
      * If Account details were retrieved and this is an amendment              CAP011
      *                                                                         CAP011
     C*****C_CNUM        IFNE      *ZERO                                               CAP011 CSD027
     C     C_CNUM        IFNE      *BLANKS                                                    CSD027
     C     C_CCY         ANDNE     *BLANK                                       CAP011
     C     C_ACOD        ANDNE     *ZERO                                        CAP011
     C     C_ACSQ        ANDNE     *ZERO                                        CAP011
     C     C_BRCA        ANDNE     *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewAcMast                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepMast = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewAcDebi                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepDebi = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewAcCred                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepCred = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewAcComm                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepComm = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewAcOthe                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepOthe = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
      ** If any of the flags set above is true, do the data                     CAP011
      ** substution subroutine.                                                 CAP011
     C                   if         RepMast = 'Y' OR RepDebi = 'Y' OR           CAP011
     C                              RepCred = 'Y' OR RepComm = 'Y' OR           CAP011
     C                              RepOthe = 'Y'
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   END                                                    CAP011
                                                                                CAP011
                                                                                CAP011
     C                   END                                                    CAP011
     C                                                                          CAP011
      **Validate input to Master screen
     C                   EVAL      WFMT = 'FK'
     C                   EXSR      VAL@M
      *
      * If action code, or Account number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C     DDACNOOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the Accounts error messages to the master details screen
      * and GO TO MASTER DETAILS SCREEN. Unless an enquire number has
      * been used in which case set up messages for that screen and go
      * straight to it.
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID TRADE READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this Account,
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C     DDACNOOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKAcMast      @EI
      *
      ** Read error messages for Account
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   IF        ULX606 = 'N' or                                            CER001
     C                             (ULX606 = 'Y' and ABFIELDID <= FldOffsetM)                 CER001
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatM
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetM    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C                   ENDIF                                                                CER001
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKAcMast
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@D - SEND A MESSAGE TO DEBIT DETAILS SCREEN
      *****************************************************************
     C     SNDM@D        BEGSR
 
     C                   Z-ADD     Idx           E
      *
      ** If there are fundamental errors in this Account,
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKAcDebi      @EI
      *
      ** Read error messages for Account
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatD
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetD    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKAcDebi
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@C - SEND A MESSAGE TO CREDIT DETAILS SCREEN
      *****************************************************************
     C     SNDM@C        BEGSR
 
     C                   Z-ADD     Idx           E
      *
      ** If there are fundamental errors in this Account,
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKAcCred      @EI
      *
      ** Read error messages for Account
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatC
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetC    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKAcCred
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@S - SEND A MESSAGE TO COMMISSIONS DETAILS SCREEN
      *****************************************************************
     C     SNDM@S        BEGSR
 
     C                   Z-ADD     Idx           E
      *
      ** If there are fundamental errors in this Account,
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKAcComm      @EI
      *
      ** Read error messages for Account
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetS    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKAcComm
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@O - SEND A MESSAGE TO OTHER DETAILS SCREEN
      *****************************************************************
     C     SNDM@O        BEGSR
 
     C                   Z-ADD     Idx           E
      *
      ** If there are fundamental errors in this Account,
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKAcOthe      @EI
      *
      ** Read error messages for Account
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatO
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetO    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKAcOthe
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MASTER DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & trade reference; detail fields = rest)
      * (Action code can only be 'I', 'A' or 'D' in this subroutine)
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'N'           WriteOnly         1
     C                   MOVEL     'Y'           @EDTFD                         CAP014
     C                   ELSE
     C                   MOVEL     'Y'           WriteOnly
     C                   MOVEL     'N'           @EDTFD                         CAP014
     C                   END
      *----------------------------------------------------------------
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ            1
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      *----------------------------------------------------------------
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcMast     PrvAcMast
      *
     C
      *
      ** WRITE/READ DISPLAY SCREEN - Master Details
      *
     C                   CALLB     'GLAMAD1DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - Master)
     C                   PARM                    NewAcMast
      *
      * Fields in error
     C                   PARM                    OKAcMast
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
      *
      ** Output Only fields
     C                   PARM                    DDDACC
     C                   PARM                    DDLINK
     C                   PARM                    DDFAMT
      *
      ** ICD
     C                   PARM                    R_CNDS
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
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
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKF             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKI             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @IN49             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
     C/COPY WNCPYSRC,GLAMADRC02
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   EVAL      WFMT = 'F1'
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Master Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      **Validate input to Master screen
     C                   CAS                     VAL@M
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MASTER DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve Account details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVACNT
      *
      * If action code, or Account key are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C     DDACNOOK      OREQ      'N'
     C                   GOTO      EndVAL@M
     C                   END
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Account in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   IF        WFMT = 'FK'
     C                   CLEAR                   NwAcFilFmt
     C                   CLEAR                   NABXFilFmt
     C                   CLEAR                   NARIFilFmt
     C                   CLEAR                   NACOFilFmt
     C                   CLEAR                   NAPWFilFmt
     C                   EXSR      SRClear                                                    CGL029
     C                   ENDIF
      *
      * Validate Account Master details
      *
     C                   CALLB     'GLAMAD1VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      * Screen Format
     C                   PARM                    WFMT              2
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Primary Details
     C                   PARM                    NewAcMast
                                                                                180721
      ** Front Office Id                                                        180721
     C                   PARM                    FOTRID                         180721
 
      * OUTPUTS :
 
      ** Account Master Details OK inds
     C                   PARM                    OKAcMast
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_MVAL
 
      * Full GL Account Number
     C                   PARM      *BLANK        WGLKEY           18
 
      * IBAN Sequence                                                           CFT004
     C                   PARM                    DDIBSQ            3            CFT004
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
     C/COPY WNCPYSRC,GLAMADRC03
                                                                                              CSD012
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
                                                                                              CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@M
     C                   END
      *                                                                                       CER048
      ** To re-output the screen for Warnings                                                 CER048
      *                                                                                       CER048
     C                   IF        WIdx_MVAL <> *ZEROS  AND                                   CER048
     C                             WHit < 1                                                   CER048
     C                   ADD       1             WHit                                         CER048
     C                   GOTO      EndVAL@M                                                   CER048
      *
      * If the screen has changed in the course of the validation
      * re-output the screen
      *
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      WHit = *ZEROS                                              CER048
     C     NewAcMast     IFNE      PrvAcMast
     C                   GOTO      EndVAL@M
     C                   END
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
                                                                                              CAP086
      ** Setup Automatic Authorisation flag on the Valid file                                 CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AMAUTH = DDAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *                                                                                       CER048
      ** Reset Errors                                                                         CER048
      *                                                                                       CER048
     C                   MOVE      *ALL'Y'       OKAcMast                                     CER048
     C                   MOVEL     *BLANK        FldNameArr                                   CER048
     C                   MOVEL     *BLANK        MsgIdArr                                     CER048
     C                   MOVEL     *BLANK        MsgDtaArr                                    CER048
     C                   MOVEL     *BLANK        WFldNamArr                                   CER048
     C                   MOVEL     *BLANK        WMsgIdArr                                    CER048
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CER048
      *
      * Go to Debit details screen
      **   else if account type is not Retail and window processing                           189774
      **   is on then display window first                                                    189774
      *
     C                   IF        DDACNO <> *BLANKS
     C                   MOVEL     'D'           @SCRN
     C                   ELSE
      *                                                                                       189774
     C                   IF        ULX606 = 'Y'                                               CER001
     C                   EVAL      w_PrvScn = @SCRN                                           CER001
     C                   MOVE      'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                CER001
      *                                                                                       189774
     C                   ENDIF
      *
     C     EndVAL@M      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - PROCESS DEBIT SCREEN
      *****************************************************************
     C     SCRN@D        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewAcDebi     PrvAcDebi
      *                                                                         CAP014
      * If no changes are allowed, protect (but still validate)                 CAP014
      * all instructions by passing action code 'E' to GLAMAD2DP                CAP014
      *                                                                         CAP014
     C     @OPSEL        IFEQ      'N'                                          CAP014
     C                   MOVEL     'E'           ##ACTN            1            CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     DDACTN        ##ACTN                         CAP014
     C                   ENDIF                                                  CAP014
     C                   MOVEL     ##ACTN        DDACTN                         CAP014
      *
      ** WRITE/READ DISPLAY SCREEN - Debit Details
      *
     C                   CALLB     'GLAMAD2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - Master / Debit)
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcDebi
      *
      * Fields in error
     C                   PARM                    OKAcDebi
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only fields
     C                   PARM                    DODRCD
     C                   PARM                    DOPOLC
     C                   PARM                    DOPOLE
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcDebi
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go to Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Debit Screen
     C     @INKL         CASEQ     '1'           CANC@D
      *
      * Validate Input to Debit Screen
     C                   CAS                     VAL@D
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - VALIDATE INPUT TO DEBIT SCREEN
      *****************************************************************
     C     VAL@D         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVE      *ALL'Y'       OKAcDebi
      *
      * Validate Debit Screen details
      *
     C                   CALLB     'GLAMAD2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      ** Account Master and Debit Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcDebi
     C                   PARM                    NewAcComm                      208221
                                                                                180721
      ** Front Office Id                                                        180721
     C                   PARM                    FOTRID                         180721
      * OUTPUTS :
      ** Trade Primary Details OK inds
     C                   PARM                    OKAcDebi
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
     C                   PARM                    WFldNamArr                                   CER055
     C                   PARM                    WMsgIDArr                                    CER055
     C                   PARM                    WMsgDtaArr                                   CER055
      * Array index (3P0) from/to caller                                                      CER055
     C                   PARM                    WIdx                                         CER055
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    NARIFilFmt
      * Revenue Analysis                                                        208221
     C                   PARM                    CDE002                         208221
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@D
     C                   END
      *
      * If the screen has changed in the course of the validation
      *
     C     NewAcDebi     IFNE      PrvAcDebi
     C                   GOTO      EndVAL@D
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVE      *ALL'Y'       OKAcDebi
      *
      * Go to Credit details screen
      *
     C                   MOVEL     'C'           @SCRN
      *----------------------------------------------------------------
      *
     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS CREDIT DETAILS SCREEN
      *****************************************************************
     C     SCRN@C        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewAcCred     PrvAcCred
      *
      ** WRITE/READ DISPLAY - Credit Details Screen
      *
     C                   CALLB     'GLAMAD3DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Trade (IN SCREEN FORMAT) - Master/Credit Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcCred
      * Fields in error
     C                   PARM                    OKAcCred
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only field
     C                   PARM                    DOCRCD
      *
      ** ICD
     C                   PARM                    R_TCAL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcCred
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Credit Details Screen
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * Validate Input to Credit Details Screen
     C                   CAS                     VAL@C
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@C  - VALIDATE INPUT TO CREDIT DETAILS SCREEN
      *****************************************************************
     C     VAL@C         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKAcCred
      *
      * Validate Credit Details Screen
      *
     C                   CALLB     'GLAMAD3VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      ** Account Master Details
      ** Account Credit Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcCred
     C                   PARM                    NewAcComm                      208221
      ** ICD
     C                   PARM                    R_TCAL
                                                                                180721
      ** Front Office Id                                                        180721
     C                   PARM                    FOTRID                         180721
      *
      * OUTPUTS :
 
      ** Account Credit details OK inds
     C                   PARM                    OKAcCred
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
     C                   PARM                    WFldNamArr                                 AR847249
     C                   PARM                    WMsgIDArr                                  AR847249
     C                   PARM                    WMsgDtaArr                                 AR847249
      ** Array index (3P0) from/to caller                                                   AR847249
     C                   PARM                    WIdx                                       AR847249
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NABXFilFmt                     208221
      * Revenue Analysis                                                        208221
     C                   PARM                    CDE002                         208221
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@C
     C                   END
      *
      * If the screen has changed in the course of the validation
      * re-output the screen
      *
     C     NewAcCred     IFNE      PrvAcCred
     C                   GOTO      EndVAL@C
     C                   END
      *
      ** Test if at least one commission present
      ** or CDE002 installed                                                    CDE002
     C     CommDisp      IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'O'           @SCRN
     C                   ENDIF
      *
      *----------------------------------------------------------------
      *
     C     EndVAL@C      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS COMMISSION DETAILS SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
 
      * IF INSERT                                                               176842
      * DO DEFAULTING FOR CHARGES & COMMISSIONS SCREEN                          176842
      * (Only do this once per transaction unless details on other screens      176842
      *  have changed)                                                          176842
      *
     C     DDACTN        IFEQ      'I'                                          176842
     C                   EXSR      DFT@O                                        176842
     C                   END                                                    176842
      *
      * IF AMEND OR ENQUIRE                                                     176842
      * Do charges and VAT calculations only if first time through              176842
      * for transaction.                                                        176842
     C     DDACTN        IFNE      'I'                                          176842
     C*****DDACCN        IFNE      #DACCN                                              176842 222427
     C                   EXSR      DFT@O                                        176842
     C**********         MOVEL     DDACCN        #DACCN           18                   176842 222427
     C**********         END                                                           176842 222427
     C                   END                                                    176842
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewAcComm     PrvAcComm
      *
      ** WRITE/READ DISPLAY - Commissions Details Screen
      *
     C                   CALLB     'GLAMAD4DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Trade (IN SCREEN FORMAT) - Master/Commission Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcComm
      * Fields in error
     C                   PARM                    OKAcComm
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only fields
     C                   PARM                    DDCEXA1
     C                   PARM                    DDCEXB1
     C                   PARM                    DDCEXC1
     C                   PARM                    DDCEXD1
     C                   PARM                    DDCEXE1
     C                   PARM                    DDCEXF1
     C                   PARM                    DDCEXG1
     C                   PARM                    DDDRMG1                        CDE002
     C                   PARM                    DDCRMG1                        CDE002
      *
      ** ICD
     C                   PARM                    RETABLE
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002                         CDE002
      *                                                                         CDE002
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcComm
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Commissions Details Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * Validate Input to Commissions Details Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    176842
      *****************************************************************         176842
      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN                 176842
      *****************************************************************         176842
     C     DFT@O         BEGSR                                                  176842
      *
     C                   EXSR      SRRTVCG
      *                                                                         176842
     C                   CALLB     'GLAMAD4DT'                                  176842
      *                                                                         176842
      * INPUTS :                                                                176842
      * Response mode                                                           176842
     C                   PARM                    RetCodeIn                      176842
                                                                                176842
      * Customer Retail Group                                                   176842
     C                   PARM                    BBCGRP                         176842
      *                                                                         CDE002
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                176842
      * Account details (DS) in file format                                     176842
     C                   PARM                    NwAcFilFmt                     176842
     C                   PARM                    NABXFilFmt                     208221
     C                   PARM                    NewAcMast                                    222427
                                                                                176842
      * OUTPUTS :                                                               176842
      * Screen 4 Output                                                         176842
     C                   PARM                    DDCEXA1          11            176842
     C                   PARM                    DDCEXB1          11            176842
     C                   PARM                    DDCEXC1          11            176842
     C                   PARM                    DDCEXD1           8            176842
     C                   PARM                    DDCEXE1           8            176842
     C                   PARM                    DDCEXF1           8            176842
     C                   PARM                    DDCEXG1           8            176842
     C                   PARM                    DDDRMG1                        CDE002
     C                   PARM                    DDCRMG1                        CDE002
 
     C                   ENDSR                                                  176842
      *****************************************************************
      /EJECT                                                                    176842
      *****************************************************************         176842
      *  SRRTVCG - Routine to retrieve and validate customer group              176842
      *****************************************************************         176842
     C     SRRTVCG       BEGSR                                                  176842
      *                                                                         176842
      ** ACCESS CUSTOMER GROUP IN SDCUSTPD                                      176842
     C                   CALL      'AOCUSTR0'                                   176842
     C                   PARM      '*DBERR '     @RTCD                          176842
     C                   PARM      '*KEY   '     @OPTN                          176842
     C                   PARM      DDCUSN        @CNUM            10            176842
     C                   PARM      *BLANKS       @CNST             7            176842
     C     SDCUST        PARM      SDCUST        DSSDY                          176842
      *
     C     @RTCD         IFEQ      *BLANKS                                      176842
     C                   MOVE      BBCUST        DDCUSN                         176842
     C                   ENDIF
      *                                                                         176842
     C     BBCGRP        IFEQ      *BLANKS                                      176842
     C                   MOVEL     '1'           BBCGRP                         176842
     C                   ENDIF                                                  176842
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO COMMISSIONS DETAILS SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKAcComm
      *
      * Validate Commissions Details Screen
      *
     C                   CALLB     'GLAMAD4VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      ** Account Master Details
      ** Account Commissions Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcComm
 
      ** ICD
     C                   PARM                    RETABLE
      *
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                CDE002
      * OUTPUTS :
 
      ** Account Credit details OK inds
     C                   PARM                    OKAcComm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              208221
      * Warning fields/message IDs/message data (arrays) from/to caller                       208221
     C                   PARM                    WFldNamArr                                   208221
     C                   PARM                    WMsgIDArr                                    208221
     C                   PARM                    WMsgDtaArr                                   208221
      * Array index (3P0) from/to caller                                                      208221
     C                   PARM                    WIdx              3 0                        208221
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NACOFilFmt
      *
      * Valid Account layout (Extension file) (DS) from/to caller               CDE002
     C                   PARM                    NABXFilFmt                     CDE002
      * Valid Account layout (DS) from/to caller                                208221
     C                   PARM                    NwAcFilFmt                     208221
      *                                                                         CDE002
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * If the screen has changed in the course of the validation
      * re-output the screen
      *
     C     NewAcComm     IFNE      PrvAcComm
     C                   GOTO      EndVAL@S
     C                   END
      *
     C                   MOVEL     'O'           @SCRN
      *
      *----------------------------------------------------------------
      *
     C     EndVAL@S      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@O - PROCESS OTHER DETAILS SCREEN
      *****************************************************************
     C     SCRN@O        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewAcOthe     PrvAcOthe
      *
      ** WRITE/READ DISPLAY - Other Details Screen
      *
     C                   CALLB     'GLAMAD5DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Trade (IN SCREEN FORMAT) - Master/Other Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcOthe
      * Fields in error
     C                   PARM                    OKAcOthe
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      ** ICD
     C                   PARM                    R_PBKU
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcOthe
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Other Details Screen
     C     @INKL         CASEQ     '1'           CANC@O
      *
      * Validate Input to Other Details Screen
     C                   CAS                     VAL@O
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@O  - VALIDATE INPUT TO OTHER DETAILS SCREEN
      *****************************************************************
     C     VAL@O         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKAcOthe
      *
      * Validate Other Details Screen
      *
     C                   CALLB     'GLAMAD5VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      ** Account Master Details
      ** Account Other Details
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcOthe
      *
      * OUTPUTS :
 
      ** Account Credit details OK inds
     C                   PARM                    OKAcOthe
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER047
     C                   PARM                    WFldNamArr                                   CER047
     C                   PARM                    WMsgIDArr                                    CER047
     C                   PARM                    WMsgDtaArr                                   CER047
      * Array index (3P0) from/to caller                                                      CER047
     C                   PARM                    WIdx                                         CER047
                                                                                              CER047
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NAPWFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@O
     C                   END
      *
      * If the screen has changed in the course of the validation
      * re-output the screen
      *
     C     NewAcComm     IFNE      PrvAcComm
     C                   GOTO      EndVAL@O
     C                   END
      *
     C                   IF        ULX606 = 'Y'                                               CER001
     C                   EVAL      w_PrvScn = @SCRN                                           CER001
     C                   MOVE      'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                CER001
      *
      *----------------------------------------------------------------
      *
     C     EndVAL@O      ENDSR
      *****************************************************************
      /EJECT                                                                                  189774
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SCRN@L - EXTENSION FILE PROCESSING                           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SCRN@L        BEGSR                                                                CER001
      *                                                                                       CER001
      *                                                                                       CER001
     C                   IF        @OPSEL   = 'N'                                             CER001
     C                   EVAL      PAction  = 'E'                                             CER001
     C                   EVAL      L1DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      PAction  = DDACTN                                          CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      AMATYP        L1ATYP                                       CER001
      *                                                                                       CER001
     C                   CALL      'GLAMAD2RP'                                                CER001
     C                   PARM      *BLANKS       RetCodeIn                                    CER001
     C                   PARM                    PAction                                      CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    PWRtn                                        CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   PARM                    NwDlFilFmt                                   CER001
      *                                                                                       CER001
     C                   EVAL      L1DEXT = *Blanks                                           CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** CASE: PAR.*Return code is *Exit                                                      CER001
      *                                                                                       CER001
     C                   WHEN      PWRtn = 'Y2U9999'                                          CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      ** Else if F12 pressed, return to previous screen                                       CER001
      *                                                                                       CER001
     C                   WHEN      PWRtn = 'USR0790'                                          CER001
     C                   EVAL      @SCRN = w_PrvScn                                           CER001
      *                                                                                       CER001
      ** Else if ENTER key was pressed,                                                       CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
     C                   IF        BGWDPR  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'W'                                              CER001
     C                   ELSEIF    BGWDPR  = 'N' and                                          CER001
     C                             @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   ELSEIF    BGWDPR  = 'N' and                                          CER001
     C                             @OPSEL <> 'N'                                              CER001
     C                   EVAL      @SCRN   = 'U'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDSL                                                                CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       189774
      * SCRN@W - WINDOW PROCESSING                                                            189774
      *****************************************************************                       189774
     C     SCRN@W        BEGSR                                                                189774
      *                                                                                       189774
      ** If account is retail, redisplay first detail screen                                  189774
      *                                                                                       189774
     C     DDACNO        IFEQ      *Blanks                                                    189774
     C                   CALLB     'GLAMAD1DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blanks       RetCodeIn                                    189774
     C                   PARM                    NewAcMast                                    189774
     C                   PARM                    OKAcMast                                     189774
     C                   PARM                    NwAcFilFmt                                   189774
     C                   PARM                    NARIFilFmt                                   189774
     C                   PARM                    DDDACC                                       189774
     C                   PARM                    DDLINK                                       189774
     C                   PARM                    DDFAMT                                       189774
     C                   PARM                    R_CNDS                                       189774
     C                   PARM                    R_FACH                                       189774
     C                   PARM                    R_TSTMC                                      189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    WFldNamArr                                   189774
     C                   PARM                    WMsgIdArr                                    189774
     C                   PARM                    WMsgDtaArr                                   189774
     C                   PARM                    @EKYFD                                       189774
     C                   PARM                    @EDTFD                                       189774
     C                   PARM                    @EIN25                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKE                                        189774
     C                   PARM                    @INKF                                        189774
     C                   PARM                    @INKG                                        189774
     C                   PARM                    @INKH                                        189774
     C                   PARM                    @INKI                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @INKP                                        189774
     C                   PARM                    @IN49                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
      *                                                                                       189774
      ** Else if account is not retail, redisplay fifth detail screen                         189774
      *                                                                                       189774
     C                   ELSE                                                                 189774
     C                   CALLB     'GLAMAD5DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blank        RetCodeIn                                    189774
     C                   PARM                    NewAcMast                                    189774
     C                   PARM                    NewAcOthe                                    189774
     C                   PARM                    OKAcOthe                                     189774
     C                   PARM                    NwAcFilFmt                                   189774
     C                   PARM                    R_PBKU                                       189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    WFldNamArr                                   189774
     C                   PARM                    WMsgIdArr                                    189774
     C                   PARM                    WMsgDtaArr                                   189774
     C                   PARM                    @EIN25                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKE                                        189774
     C                   PARM                    @INKF                                        189774
     C                   PARM                    @INKI                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @IN49                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
     C                   ENDIF                                                                189774
                                                                                              189774
     C/COPY WNCPYSRC,GLAMADSMV1                                                               189774
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window                                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C                   MOVE      DDBRCA        BYBRCD                                      LLN022A
     C                   MOVE      DDCUSN        BYCNUM                                      LLN022A
     C                   MOVE      DDCCY         BYCCY                                       LLN022A
     C                   MOVE      DDACOD        BYACOD                                      LLN022A
     C                   MOVE      DDACSQ        BYACSQ                                      LLN022A
      *                                                                                      LLN022A
      ** Account Type                                                                        LLN022A
      *                                                                                      LLN022A
     C                   MOVE      AMATYP        BYATYP                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       189774
     C                   CALL      'WN0010'                                                   189774
     C                   PARM      'GLAMADRIN'   PWPgm            10                          189774
     C                   PARM                    PWKey             2                          189774
     C                   PARM      DDACTN        PWAction          1                          189774
     C                   PARM                    Data                                         189774
     C                   PARM      *Blanks       PWRtn             7                          189774
     C                   PARM                    PWSpare         256                          189774
      *                                                                                       189774
      ** If F3 pressed, end program                                                           189774
      *                                                                                       189774
     C                   SELECT                                                               189774
     C                   WHEN      PWRtn = 'Y2U9999'                                          189774
     C                   EXSR      ENDP                                                       189774
      *                                                                                       189774
      ** Else if F12 pressed, return to previous screen                                       189774
      *                                                                                       189774
     C                   WHEN      PWRtn = 'USR0790'                                          189774
      *                                                                                       189774
     C                   IF        DDACNO = *Blanks                                           189774
     C                   EXSR      CANC@D                                                     189774
     C                   ELSE                                                                 189774
     C                   EVAL      @SCRN = 'O'                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
      ** Else if ENTER key was pressed,                                                       189774
      *                                                                                       189774
     C                   OTHER                                                                189774
      *                                                                                       189774
     C***  DDACTN        IFEQ      'E'                                                 189774 CER001
     C                   IF        DDACTN = 'E' or                                            CER001
     C                             (ULX606 = 'Y' and @OPSEL = 'N')                            CER001
     C                   EXSR      CANC@P                                                     189774
     C                   ELSE                                                                 189774
     C     DDACTN        IFEQ      'I'                                                        189774
     C     DDACTN        OREQ      'A'                                                        189774
     C                   EVAL      @SCRN = 'U'                                                189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDSL                                                                189774
      *                                                                                       189774
     C                   ENDSR                                                                189774
      *****************************************************************                       189774
      /EJECT
      *****************************************************************
      * RTVACNT - RETRIEVE ACCOUNT
      *****************************************************************
     C     RTVACNT       BEGSR
      *
      * RETRIEVE ACCOUNT
      *
     C                   CALLB     'GLAMADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C**********         PARM                    FOTRID           20                          CGL029
     C                   PARM                    FOTRID           40                          CGL029
      * (Midas) Account Key
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      * Commissions
     C                   PARM                    CommDisp
      * IBAN                                                                    CFT004
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    DDIBAN                                       238839
      *                                                                                       194431
      ** New Accounts Currency                                                                194431
      *                                                                                       194431
     C                   PARM                    WDCCY             3                          194431
      * OUTPUTS :
      * (Current) TRADE in file format
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C                   PARM                    CARIFilFmt
     C                   PARM                    CACOFilFmt
     C                   PARM                    CAPWFilFmt
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Account Key
     C                   PARM                    DDCUSNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    DDACODOK
     C                   PARM                    DDACSQOK
     C                   PARM                    DDBRCAOK
     C                   PARM                    DDACNOOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
     C     EndRTVACNT    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTACNT - PUT AN ACCOUNT TO THE SCREEN
      *****************************************************************
     C     CVTACNT       BEGSR
      *                                                                                       CGL029
      ** Since Valid File and Actual File have some fields in different positions,            CGL029
      ** before calling Convert, this must be mapped correctly                                CGL029
      *                                                                                       CGL029
     C                   MOVEL     CARIFilFmt1   P1RIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  P1RIFilFmtEx                                 CGL029
     C                   MOVEL     CACOFilFmt1   P1COFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  P1COFilFmtEx                                 CGL029
     C                   MOVEL     CAPWFilFmt1   P1PWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  P1PWFilFmtEx                                 CGL029
      *
      * Call program to fill screen fields with data from ACCNTAB
      *
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS :
      * Return Code
      * TRADE in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C**********         PARM                    CARIFilFmt                                   CGL029
     C**********         PARM                    CACOFilFmt                                   CGL029
     C                   PARM                    CAPWFilFmt                            CGL029 CSD101
     C                   PARM                    P1RIFilFmt                                   CGL029
     C                   PARM                    P1COFilFmt                                   CGL029
     C                   PARM                    P1PWFilFmt                                   CGL029
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002            1            CDE002
      *                                                                         CDE002
      * Retail charges details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * OUTPUTS
      * Trade - screen formats
     C                   PARM                    NewAcMast
     C                   PARM                    NewAcDebi
     C                   PARM                    NewAcCred
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthe
      *
      * Screen 1 Output
     C                   PARM                    DDDACC            6
     C                   PARM                    DDLINK           18
     C                   PARM                    DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM                    DODRCD            6
     C                   PARM                    DOPOLC            6
     C                   PARM                    DOPOLE            6
      *
      * Screen 3 Output
     C                   PARM                    DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1          12            CDE002
     C                   PARM                    DDCRMG1          12            CDE002
 
      *
      * Update 'Current' TRADE with TRADE in Screen Format
      *
     C                   MOVEL     NewAcMast     CurAcMast
     C                   MOVEL     NewAcDebi     CurAcDebi
     C                   MOVEL     NewAcCred     CurAcCred
     C                   MOVEL     NewAcComm     CurAcComm
     C                   MOVEL     NewAcOthe     CurAcOthe
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - CANCEL ON DEBIT DETAILS SCREEN
      *****************************************************************
     C     CANC@D        BEGSR
      *
      * Return to Master Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CREDIT DETAILS
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * Return to Debit Screen
      *
     C                   MOVEL     'D'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON COMMISSION SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Other Details Screen
      *
     C                   MOVEL     'C'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@O - CANCEL ON OTHER DETAILS SCREEN
      *****************************************************************
     C     CANC@O        BEGSR
      *
      * Return to Commission Screen
      *
      ** Test if at least one commission present
     C     CommDisp      IFEQ      'Y'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * UPDATE VALID ACCOUNT: CHANGE TYPE
      *
     C                   MOVEL     DDACTN        AMCHTP
     C                   EVAL      AMIBAN = DDIBAN                              CFT004
     C                   EVAL      AMIBSEQN = DDIBSQ                            CFT004
      *
      * UPDATE VALID ACCOUNT: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    AMFRNT
                                                                                              CGL029
      ** Update file field associated front ofc id with the second half                       CGL029
      ** of the 40-long front ofc id                                                          CGL029
                                                                                              CGL029
     C                   MOVE      @FOTRANSEL    AMAFRT                                       CGL029
      *                                                                         198865
      * AMTNLU not updated for AMEND.                                           198865
     C*****C_CNUM        IFNE      *ZERO                                               198865 CSD027
     C     C_CNUM        IFNE      *BLANKS                                                    CSD027
     C     C_CCY         ANDNE     *BLANK                                       198865
     C     C_ACOD        ANDNE     *ZERO                                        198865
     C     C_ACSQ        ANDNE     *ZERO                                        198865
     C     C_BRCA        ANDNE     *BLANK                                       198865
     C     DDACTN        ANDEQ     'A'                                          198865
     C                   Z-ADD     C_TNLU        AMTNLU                         198865
     C                   ENDIF                                                  198865
      *                                                                         198865
      * RECOM key fields not updated for AMEND.                                 198865
     C*****CC_CNUM       IFNE      *ZERO                                               198865 CSD027
     C     CC_CNUM       IFNE      *BLANKS                                                    CSD027
     C     CC_CCY        ANDNE     *BLANK                                       198865
     C     CC_ACOD       ANDNE     *ZERO                                        198865
     C     CC_ACSQ       ANDNE     *ZERO                                        198865
     C     CC_BRCA       ANDNE     *BLANK                                       198865
     C     DDACTN        ANDEQ     'A'                                          198865
     C**********         Z-ADD     CC_CNUM       COCNUM                                198865 CSD027
     C                   EVAL      COCNUM = CC_CNUM                                           CSD027
     C                   Move      CC_CCY        COCCY                          198865
     C                   Z-ADD     CC_ACOD       COACOD                         198865
     C                   Z-ADD     CC_ACSQ       COACSQ                         198865
     C                   Move      CC_BRCA       COBRCA                         198865
     C                   ENDIF                                                  198865
      *
      * Account UPDATES
      *
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    RespMode
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NACOFilFmt
     C                   PARM                    NAPWFilFmt
     C                   PARM                    CEU013
     C                   PARM                    CRT001
     C                   PARM                    CRT002
     C                   PARM                    CRE001
     C                   PARM                    CRT101
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    CDE002                         CDE002
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
     C                   IF        ULX606 = 'Y'                                               CER001
     C                   IF        @RTCD  = *BLANKS                                           CER001
     C                   EXSR      UPDEXT                                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID TRADE ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
                                                                                              243973
      ** Add record within Account Master Extension File (done from Java layer).              243973
     C                   IF        AMCHTP = 'I'                                               243973
     C                   EXSR      WriteACNTQD                                                243973
     C                   END                                                                  243973
                                                                                              243973
     C     ZATRNKD0      CHAIN     GLIAMADD0                          90
     C  N90              DELETE    GLIAMADD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'GLAMAD'                                        CSC011
                                                                                              CGL029
      ** Divide 40-long front office id into front office id and                              CGL029
      ** associated front office id for chain                                                 CGL029
                                                                                              CGL029
     C**********         EVAL      KFrntOffID = @FOTRANSEL                             CSC011 CGL029
     C                   MOVEL     @FOTRANSEL    KFrntOffID                                   CGL029
     C                   MOVE      @FOTRANSEL    KFrntAscID                                   CGL029
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C*****KAPILOGL0     CHAIN     APILOGL0                           99               CSC011 CGL029
     C     KAPILOGL1     CHAIN     APILOGL1                           99                      CGL029
     C                   IF        *IN99 = *OFF                                               CSC011
     C**********         DELETE    APILOGL0                                            CSC011 CGL029
     C                   DELETE    APILOGL1                                                   CGL029
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,GLAMADRC01
      *                                                                                      LLN022A
     C     ZATRNKX1      KLIST                                                               LLN022A
     C                   KFLD                    @TMESTPSEL                                  LLN022A
     C                   KFLD                    KFrntOfcID       20                         LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C                   MOVEL     @FOTRANSEL    KFrntOfcID                                  LLN022A
      *                                                                                      LLN022A
      ** Delete extra data on the invalid file                                               LLN022A
      *                                                                                      LLN022A
     C     ZATRNKX1      CHAIN     IAMADD0                            99                     LLN022A
     C  N99              DELETE    IAMADD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   DUMP                                               198865
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRINZ - Initialize screen fields                             *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRINZ         BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CLEAR                   L6LX1UAC                                     CER001
     C                   CLEAR                   L6LXLUSU                                     CER001
     C                   CLEAR                   L6LXCOAM                                     CER001
     C                   CLEAR                   L6LXCOAC                                     CER001
     C                   CLEAR                   L6LXCOBR                                     CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  UPDEXT - UPDATE EXTENSION                                    *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     UPDEXT        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'GLAMAD6UP'                                                CER001
     C                   PARM                    PAction                                      CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      *BLANKS       PFind                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
      *                                                                                       CER001
      ** If there were any errors in the update functions, rollback                           CER001
      ** any updates and end this pgm, otherwise delete the invalid                           CER001
      ** extended deal and commit the updates                                                 CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C     K@KEY1        CHAIN     RTVIDX1                            81                      CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       243973
      /EJECT                                                                                  243973
      *****************************************************************                       243973
      *                                                               *                       243973
      * WriteACNTQD - WRITE Account Master Extension record (done     *                       243973
      *               from Java layer).                               *                       243973
      *                                                               *                       243973
      *****************************************************************                       243973
     C     WriteACNTQD   BEGSR                                                                243973
                                                                                              243973
      ** When opening new accounts in ACCNTAB, write a corresponding                          243973
      ** record in the account details extension file GLACNTQD.                               243973
                                                                                              243973
     C     @KeyAcntL3    KLIST                                                                243973
     C                   KFLD                    AMCNUM                                       243973
     C                   KFLD                    AMCCY                                        243973
     C                   KFLD                    AMACOD                                       243973
     C                   KFLD                    AMACSQ                                       243973
     C                   KFLD                    AMBRCA                                       243973
                                                                                              243973
     C     @KeyAcntL3    CHAIN     GLACNTD0                           82                      243973
                                                                                              243973
     C     *IN82         IFEQ      *ON                                                        243973
     C                   EVAL      F1CNUM = AMCNUM                                            243973
     C                   EVAL      F1CCY  = AMCCY                                             243973
     C                   EVAL      F1ACOD = AMACOD                                            243973
     C                   EVAL      F1ACSQ = AMACSQ                                            243973
     C                   EVAL      F1BRCA = AMBRCA                                            243973
     C                   EVAL      F1FCHD = *ZEROS                                            243973
     C                   EVAL      F1LFCD = *ZEROS                                            243973
     C                   EVAL      F1ACBL = *ZEROS                                            243973
     C                   EVAL      F1TEXO = *ZEROS                                            243973
     C                   EVAL      F1TEOF = *ZEROS                                            243973
     C                   EVAL      F1TEOC = *ZEROS                                            243973
     C                   WRITE     GLACNTD0                                                   243973
                                                                                              243973
     C                   ENDIF                                                                243973
                                                                                              243973
     C                   ENDSR                                                                243973
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       189774
      ** Rollback to clear any possible updates in window function                            189774
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                189774
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                189774
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
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
      ** Substitute the data for the various parts of the transaction,          CAP011
      ** dependent on the flags that were set earlier.                          CAP011
                                                                                CAP011
     C                   if        RepMast = 'Y'                                CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewAcMast     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurAcMast     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewAcMast                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepDebi = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewAcDebi     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurAcDebi     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewAcDebi                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepCred = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewAcCred     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurAcCred     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewAcCred                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepComm = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewAcComm     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurAcComm     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewAcComm                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepOthe = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewAcOthe     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurAcOthe     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewAcOthe                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * IF ACTION CODE IS INSERT, GO TO MASTER DETAIL SCREEN
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADRPR'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   MOVEL     @OPTN         DBKEY                          *************
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
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Postings Narrative) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Access SAR details file to determine if CRE001
      ** (Overdraft Interest Calculations) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001            1
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   END
      *
      ** Access SAR details file to determine if CRT101
      ** (Passworrd on Retail Account Facility) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101            1
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   END
      *                                                                         CFT004
      ** Access SAR details file to determine if CFT004 is on.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
      *                                                                         CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004            1            CFT004
     C                   ELSE                                                   CFT004
     C                   MOVEL     'N'           CFT004                         CFT004
     C                   END                                                    CFT004
      *
      ** Access SAR details file to determine if CRT001
      ** (Retail Teller System) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001            1
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   END
      *
      ** Access SAR details file to determine if CRT002
      ** (Retail Branch Access) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002            1
     C                   ELSE
     C                   MOVEL     'N'           CRT002
     C                   END
      *                                                                         CDE002
      ** Access SAR details file to determine if CDE002 is on.                  CDE002
      *                                                                         CDE002
     C                   CALLB     'AOSARDR0'                                   CDE002
     C                   PARM      *BLANKS       @RTCD                          CDE002
     C                   PARM      '*VERIFY'     @OPTN                          CDE002
     C                   PARM      'CDE002'      @SARD                          CDE002
     C     SCSARD        PARM      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C     @RTCD         IFEQ      *BLANK                                       CDE002
     C                   MOVEL     'Y'           CDE002            1            CDE002
     C                   ELSE                                                   CDE002
     C                   MOVEL     'N'           CDE002                         CDE002
     C                   END                                                    CDE002
      *                                                                         CDE002
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C**********         OPEN      APILOGL0                                            CSC011 CGL029
     C                   OPEN      APILOGL1                                                   CGL029
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSD012
      ** Check if CSD012 is installed                                                         CSD012
      *                                                                                       CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Account Authorisation is ON                                CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     906           DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'GLAMADRPR'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Account Authorisation is On set to Authorise                                      CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
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
     C                   EVAL      DBASE = 907                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *
      ** Access Retail ICD for Commissions
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                80
     C     *IN80         IFEQ      *ON
     C     R_RECI        ORNE      'D'
     C                   MOVEL     'TABTBRE '    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C                   IF        R_CDTO='Y' or R_CHOV='Y' or R_FXAC='Y'
     C                             or R_CNDS='Y' or R_CDRI='Y'
     C                             or R_CMBL='Y' or R_CINA='Y'
     C                   EVAL      CommDisp='Y'
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF
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
      *                                                                                       CER001
      ** Check is switchable feature ULX606 is switched on                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   EVAL      ULX606 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX606 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL       ULX606 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Only open LUX related files when SAR is installed                                    CER001
      *                                                                                       CER001
     C                   IF        ULX606 = 'Y'                                               CER001
     C                   OPEN      GLIAMLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLAMADRPR'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 908                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *
      ** Access Switchable SAR details for the existence                                     LLN022A
      ** of LLN022 (Bank of England)                                                         LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN022'      @SARD                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
     C*****KAPILOGL0     KLIST                                                         CSC011 CGL029
     C     KAPILOGL1     KLIST                                                                CGL029
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                            CSC011 CGL029
     C                   KFLD                    KFrntAscID                                   CGL029
     C                   KFLD                    KTimeStamp                                   CSC011
 
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    L1TMST                                       CER001
     C                   KFLD                    L1FOTR                                       CER001
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@CNUM                                       CER001
     C                   KFLD                    K@CCYC                                       CER001
     C                   KFLD                    K@ACOD                                       CER001
     C                   KFLD                    K@ACSQ                                       CER001
     C                   KFLD                    K@BRCA                                       CER001
      *                                                                                       CER001
      ** Get the field number for the action code field; the master
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatM
     C                   PARM                    FieldM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetM = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the action code field; the debit
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatD
     C                   PARM                    FieldD
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetD = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the action code field; the credit
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatC
     C                   PARM                    FieldC
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetC = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the action code field; the commissions
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    FieldS
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetS = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the action code field; the Other details
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatO
     C                   PARM                    FieldO
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetO = FieldNo - 1
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
      *
      ** Disable Roll Function Keys
     C                   MOVEL     'N'           @EIN25            1
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLAMADR014
 
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
(c) Finastra International Limited 2001
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
