     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans retr + act/loan validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPRTV - Customer loans retrieve                          *
      *              (with action code versus loan reference          *
      *               validation)                                     *
      *                                                               *
      *  Function:  This module retrieves a customer loan from        *
      *             the database. As it does so, it validates the     *
      *             action code and loan reference                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. MD032052           Date 23Jan15               *
      *                 MD031225           Date 10Dec14               *
      *                 MD025945           Date 19Aug14               *
      *                 MD000091           Date 09May13               *
      *                 AR1021136          Date 24Apr13               *
      *                 AR1079502          Date 03Feb13               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR968606           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21757           Date 26Nov08               *
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255335             Date 10Jul08               *
      *                 245273             Date 26Jan07               *
      *                 246167             Date 05Mar07               *
      *                 245210             Date 12Jan07               *
      *                 244314             Date 11Dec06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 240968             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD027A            Date 08May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10122           Date 30Jan06               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG8241            Date 23Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6108            Date 03May05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 BUG3760            Date 30Jul04               *
      *                 225959             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 225215             Date 23Feb04               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 05Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  MD031225 - Bypass validation of loan number on COB since it  *
      *             was auto generated.                               *
      *  MD025945 - Do not allow deletion of original loan if PDCL    *
      *             still exist.                                      *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1021136 - CLE148: Loan with reference '000000' can be      *
      *              created. Allow loan '000000' to be reversed or   *
      *              display an error message for A and X action.     *
      *              (Child: AR1021140)                               *
      *  AR1079502 - Be able to reverse a PDCL created on line        *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR968606 - Incorrect validation of Loan Reference            *
/*    *             (Child: AR968609)                                 *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ß24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG21757 - Loan related error on facility fee                *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255335 - Execute loan number validation only if LNRF <> 0    *
      *  245273 - Do not allow Authorise for record created by Prin   *
      *           transfer transaction if taken from Loan entry.      *
      *  246167   Fix 241196 cause commitment error CPF4392           *
      *           use of PSOLD2 to avoid CPF4293 in LECLIPRPR/UPC     *
      *  245210 - User should not be able to reopen matured           *
      *           participant loan                                    *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CAP185 - MQ Series Interface                                 *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if loan was amended after original entry date  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG10122- Bypass validation LEL0064 if the loan being        *
      *            reversed is primary.                               *
      *  CLE106 - Syndications Manager                                *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  BUG8241- OME RPG patch for delivery                          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSC024 - Open Month End                                      *
      * BUG6108 - Allow manual entry of loan numbers                  *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPTD01,LECLIPTC01,LECLIPTC02,  *
      *                            LECLIPTF01                         *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  225959 - Missing CAS00x changes                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  225215 - Cannot amend reactivated loan                       *
      *  CAP084 - Midas Plus API development                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
     FLECLIPL0  IF   E           K DISK    INFSR(*PSSR)
      ***  Loans by front office id
     F                                     RENAME(CLOANCKF:CLOANCKFOI)
     F                                     RENAME(CLOANCLF:CLOANCLFOI)
      *
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans File
     F                                     RENAME(CLOANCKF:CLOANCKLN)
     F                                     RENAME(CLOANCLF:CLOANCLLN)
     F**PSOLD*IF   E           K DISK    INFSR(*PSSR)         * Wrong commit level     CLE106 246167
     FPSOLD2    IF   E           K DISK    INFSR(*PSSR)                                       246167
      ***  Parts Sold                                                                         CLE106
     F                                     RENAME(CLOANCLF:PSOLDF)                            CLE106
     F                                     PREFIX(PS_)                                        CLE106
                                                                                              CLE106
     FPPURC     IF   E           K DISK    INFSR(*PSSR)                                       CLE106
      ***  Parts Purchased                                                                    CLE106
     F                                     RENAME(CLOANCLF:PPURCF)                            CLE106
     F                                     PREFIX(PP_)                                        CLE106
                                                                                              CLE106
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     F                                     PREFIX(LA_)
     FLEFEEDL2  IF   E           K DISK    INFSR(*PSSR)
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)                         225959
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)                         225959
     F/COPY WNCPYSRC,LECLIPTF01
      *
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      ** Compliance Watch Hit List by Function Type/Identifier/Branch                        BUG3760
      *                                                                                      BUG3760
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
                                                                                              CAP185
     FCLOANL4   IF   E           K DISK                                                       CLE134
     F                                     PREFIX(pd_) RENAME(CLOANCLF:CLOANL4F)              CLE134
     FLEPDUEL2  IF   E           K DISK                                                       CLE134
      *                                                                                       CLE134
     FLEPDUELC  IF   E           K DISK    RENAME(LEPDUED0:LEPDUEDC)                       AR1079502
      *                                                                                    AR1079502
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *                                                                                      BUG6108
      * Constant to hold input parameter for AOSVALR0.                                       BUG6108
     D AutoAlloc       C                   Const('LoanNbrAutoAllocate')                      BUG6108
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
      *
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for General Ledger details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External DS for branch details
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  External DS for loans details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3760
      ***  SAR Details                                                                       BUG3760
      *                                                                                      BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      *                                                                                      BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
      *                                                                                      BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
      ** Midas SD Watch List Configuration Data File                                         BUG3760
      *                                                                                      BUG3760
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      *
     D CliLFilFmt    E DS                  EXTNAME(CLOANCL)
     D  LLCD         E                     EXTFLD(LCD)                                       BUG3760
      ***  Loan in File Format CL
      *
     D CliKFilFmt    E DS                  EXTNAME(CLOANCK)
      ***  Loan in File Format CK
     D  KRECI        E                     EXTFLD(RECI)
     D  KLNRF        E                     EXTFLD(LNRF)
     D  KRCDT        E                     EXTFLD(RCDT)
     D  KMRIN        E                     EXTFLD(MRIN)
     D  KORED        E                     EXTFLD(ORED)
     D  KLCD         E                     EXTFLD(LCD)
     D  KCHTP        E                     EXTFLD(CHTP)
     D  KTNLU        E                     EXTFLD(TNLU)
     D  KFRNT        E                     EXTFLD(FRNT)
     D  KAFRT        E                     EXTFLD(AFRT)
     D  KREPA        E                     EXTFLD(REPA)
     D  KTMST        E                     EXTFLD(TMST)
      *
     D*COPY*WNCPYSRC,MMCLIPID01
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ***  Index for arrays of of warning message ids etc                       225959
     D Wx              S              3P 0                                      225959
     D/COPY WNCPYSRC,LECLIPTD01

      ** SAR Indicators (on/off)                                                             BUG3760
     D CCF001          S              1                                                      BUG3760
     D CSC011          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
     D CLE106          S              1                                                       CLE106
     D CAS009          S              1                                                       CLE143
     D CLE143          S              1                                                       CLE143
      *                                                                                      BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D WPartsOK        S              1                                                       CLE106
     D WPrimary        S              1                                                     BUG10122
                                                                                              CSC024
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
     D CAP086          S              1A                                                      CAP086
     D CLE056          S              1A                                                      CLE056
                                                                                             BUG6108
     D PSysVal01       S             20A   INZ('LoansPartPrchPartSld')                       BUG6108
     D PCurSet01       S            200A                                                     BUG6108
     D PSysVal02       S             20A                                                     BUG6108
     D PCurSet02       S            200A                                                     BUG6108
     D PSysVal03       S             20A                                                     BUG6108
     D PCurSet03       S            200A                                                     BUG6108
     D PSysVal04       S             20A                                                     BUG6108
     D PCurSet04       S            200A                                                     BUG6108
     D PSysVal05       S             20A                                                     BUG6108
     D PCurSet05       S            200A                                                     BUG6108
     D PSysVal06       S             20A                                                     BUG6108
     D PCurSet06       S            200A                                                     BUG6108
     D PSysVal07       S             20A                                                     BUG6108
     D PCurSet07       S            200A                                                     BUG6108
     D PSysVal08       S             20A                                                     BUG6108
     D PCurSet08       S            200A                                                     BUG6108
     D PSysVal09       S             20A                                                     BUG6108
     D PCurSet09       S            200A                                                     BUG6108
     D PSysVal10       S             20A                                                     BUG6108
     D PCurSet10       S            200A                                                     BUG6108
      *                                                                                       CLE134
     D CLE134          S              1A   INZ('N')                                           CLE134
     D DSPDSts         S             10A   INZ                                                CLE134
      *                                                                                       CLE134
      ** Key fields for CLE134 amendments                                                     CLE134
      *                                                                                       CLE134
     D Kpd_LNRF        S                   INZ LIKE(pd_LNRF)                                  CLE134
     D Kpd_RECI        S                   INZ LIKE(pd_RECI)                                  CLE134
      *                                                                                       CLE134
     D KYPORG          S                   INZ LIKE(YPORG)                                    CLE134
      *                                                                                       CLE134
      ** Data Structure for MPHAS Dataarea                                                  MD031225
     D MPHAS           DS             1                                                     MD031225
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************

      * Rename input fields (must be included in DS CliKFilFmt)
     ICLOANCKLN
     I              RECI                        KRECI
     I              LNRF                        KLNRF
     I              RCDT                        KRCDT
     I              MRIN                        KMRIN
     I              ORED                        KORED
     I              LCD                         KLCD
     I              CHTP                        KCHTP
     I              TNLU                        KTNLU
     I              FRNT                        KFRNT
     I              AFRT                        KAFRT
     I              REPA                        KREPA
     I              TMST                        KTMST
      /EJECT

      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ***  Get ZMUSER to access default branch.                                              BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
      ***  Initialisation
      *
     C                   EXSR      INIT

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             ModeofOp = *BLANKS                                         CAP086
     C                   EVAL      AUTH = *BLANKS                                             CAP086
     C                   ENDIF                                                                CAP086
      *
      ***  If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  do (EXTRA) validation for front office transaction interface
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      ***  Carry out no further validation if errors have occurred.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      ***  Validate action code & loan number
      *
     C                   EXSR      VAL
      *
      ***  Carry out no further validation if errors have occurred
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *------------------------------------------------------*
      *  * Validation for Action Code 'E', '1', '2', '3' or '4' *
      *  *------------------------------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the loan no. is not to be generated.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDLNRF        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'R' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'R'
     C                   EXSR      VALACR
     C                   END
      *                                                                                       CLE030
      *  *--------------------------------*                                                   CLE030
      *  * Validation for Action Code 'Q' *                                                   CLE030
      *  *--------------------------------*                                                   CLE030
      *                                                                                       CLE030
     C     DDACTN        IFEQ      'Q'                                                        CLE030
     C                   EXSR      VALACQ                                                     CLE030
     C                   END                                                                  CLE030
      *
      ***  Carry out no further validation if errors occurred
      *    ==================================================
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END

      * Determine Processing type

     C                   EXSR      DET_PROCTYPE

      * Determine Loan type

     C                   EXSR      DET_LOANTYPE
                                                                                              CLE143
     C     DDLNRF        IFNE      *BLANKS                                                    CLE143
     C                   EXSR      RET_EAIR                                                   CLE143
     C                   ENDIF                                                                CLE143
      *
      ***  Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for front office transaction interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      *****Error*if*action*code*is*not*'I',*'A',*'R'*or*'X'                                   CLE030
      ***  Error if action code is not 'I', 'A', 'R', 'X' or 'Q'                              CLE030
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0603'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Error if front office transaction ID is blank
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0604'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Access loan with front office transaction ID
      *
     C     FOTRID        CHAIN(N)  CLOANCLFOI                         99
     C     FOTRID        CHAIN(N)  CLOANCKFOI                         99
      *
      ***  If insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Front office transaction ID can't be present already
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0605'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      ***  If not insert, front office transaction ID must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0606'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  If not insert, update Midas loan number and the special intructions
      *
     C                   MOVEL     LNRF          DDLNRF
      *
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of action code and loan number
      *****************************************************************
     C     VAL           BEGSR
      *
     C     DDACTN        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0021'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C     DDACTN        IFEQ      *BLANK
     C                   MOVEL     'E'           DDACTN
     C                   END

      *
      ***  If the loan number is not blank, check that it is numeric.
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'                                                CLE148
     C                   PARM      DDLNRF        PLNRF             6                          CLE148
     C                   PARM      *BLANKS       PValid            6                          CLE148
     C                   PARM      *BLANK        PChkDigit         1                          CLE148
     C                   PARM      *BLANKS       PData             2                          CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *
     C******IN98         IFEQ      '0'                                                        CLE148
     C******IN99         OREQ      '0'                                                        CLE148
     C**********         IF         (wLoanAlpha = 'N' AND *IN98 = *OFF               CLE148 AR968606
     C**********                     OR *IN99 = *OFF) OR (wLoanAlpha = 'Y'           CLE148 AR968606
     C**********                    AND PValid <> *BLANKS)                           CLE148 AR968606
     C                   IF        (wLoanAlpha = 'N'                                        AR968606
     C                              AND (*IN98 = *OFF OR *IN99 = *OFF)                      AR968606
     C                              OR (wLoanAlpha = 'Y' AND PValid <> *BLANKS))            AR968606

     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C**********         MOVEL     'LEL0022'     MsgIdArr(Ix)                                 CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PData         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PData))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PData)                     MD000091
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   GOTO      EVAL
     C                   END
      *
      ***  Set up the loan number as a numeric field
      *
     C                   MOVE      DDLNRF        K@LNRF
      *
      ***  Access loan with the loan reference if it's not insert
      *
     C     DDACTN        IFNE      'I'
     C*****DDLNRF        ANDNE     *ZEROS                                           255335 AR1021136
     C     K@LNRF        CHAIN(N)  CLOANCLLN                          99
     C     K@LNRF        CHAIN(N)  CLOANCKLN                          99
     C/COPY WNCPYSRC,LECLIPTC02
      *
      ***  The loan must be present
      *
     C******IN99         IFEQ      '1'                                                      BUG21757
     C                   IF        *IN99 = '1' AND                                          BUG21757
     C                             DDLNRF <> *ZERO                                          BUG21757
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0024'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      ** Remove validation for output in screen                                               245210
      ** Validation deployed in LECLIPVU.                                                     245210
      *****The*loan*has*been*reserved**********************                                   245210
      *
     C*****RECI          IFEQ      'R'                                                        245210
     C*****DDACTN        ANDNE     'E'                                                        245210
     C**********         MOVE      'N'           DDLNRFOK                                     245210
     C**********         ADD       1             Ix                                           245210
     C**********         MOVEL     'DDLRNF'      FldNameArr(Ix)                               245210
     C**********         MOVEL     'LEL0040'     MsgIdArr(Ix)                                 245210
     C**********         GOTO      EVAL                                                       245210
     C**********         END                                                                  245210
      *
      *****The*loan*has*been*matured******************************                            245210
      *
     C*****RECI          IFEQ      'M'                                                        245210
     C*****DDACTN        ANDNE     'E'                                                        245210
     C**********         IF        RATF <> 'Y' OR CLE005 <> 'Y'                        225215 245210
     C**********         MOVE      'N'           DDLNRFOK                                     245210
     C**********         ADD       1             Ix                                           245210
     C**********         MOVEL     'DDLRNF'      FldNameArr(Ix)                               245210
     C**********         MOVEL     'LEL0041'     MsgIdArr(Ix)                                 245210
     C**********         GOTO      EVAL                                                       245210
     C**********         ENDIF                                                         225215 245210
     C**********         END                                                                  245210
      *
     C                   END
     C                   END
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - Validation of action code 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0022'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - Validation of action code 'X'
      *****************************************************************
     C     VALACX        BEGSR
      *
      ***  If authorisation feature (CLE002) is not installed authorisation action
      ***  is not allowed
      *
     C     CLE002        IFEQ      'N'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0402'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *
      ***  If authorisation feature is installed,
      ***  Authorisation must be set as needed in order to continue
      *
     C     BPLOAU        IFNE      'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0403'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *                                                                                       CLE030
      ***  If the loan status is 'Requires Release' then Authorise option                     CLE030
      ***  is an error.                                                                       CLE030
      *                                                                                       CLE030
     C     LSTS          IFEQ      'Q'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0125'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAX                                                     CLE030
     C                   END                                                                  CLE030
      *
      ***  Authorised user must be different from the insert and
      ***  amend users
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056
      *
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
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date then allow authorise user to be same as original insert user      240968
      *                                                                                       244314
      * Or if CLAuthSameORED = 'Y' then allow authorise user to be same as original           244314
      * insert user as long as the last change type was an amendment and the                  244314
      * current status of transaction is 'Reauthorise Required'                               244314
      *                                                                                       240968
     C     ATHORED       IFEQ      'Y'                                                        240968
     C     ATHSMDT       ANDNE     'Y'                                                        244314
     C     LCD           ANDGT     ORED                                                       240968
     C     CHTP          ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     ORED                                                       240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
     C     CHTP          ANDEQ     'A'                                                        244314
     C     LSTS          ANDEQ     'R'                                                        244314
     C     PSUser        IFEQ      AUSR                                                       240968
     C                   MOVE      'N'           DDACTNOK                                     240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LEL0404'     MsgIdArr(Ix)                                 240968
     C                   GOTO      EVALAX                                                     240968
     C                   END                                                                  240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PSUser        IFEQ      IUSR
     C     PSUser        OREQ      AUSR
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and ORED = BJRDNB                            CLE056
     C                                           and PSUser = IUSR) or                        CLE056
     C                             (CLE056 = 'Y' and LCD = BJRDNB and                         CLE056
     C                              CHTP = 'A'   and PSUser = AUSR)                           CLE056
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0404'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ENDIF                                                                CLE056
     C                   END
     C                   ENDIF                                                                240968
     C                   ENDIF                                                                CAP185
      *
      *
      ***  If the loan status is not C or R, it is an error
      *
     C     LSTS          IFNE      'C'
     C     LSTS          ANDNE     'R'
     C     LSTS          ANDNE     'Q'                                                        CLE030
     C     @ACTRV        ANDNE     'Y'                                                      AR804863
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0405'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *                                                                                       245273
      ***  Authorise is no allowed if transaction is created by Principal                     245273
      ***  transfer transaction and action is taken from Loan Entry.                          245273
      *                                                                                       245273
     C                   IF        LSTS   = 'C' AND                                           245273
     C                             GPRT   = 'Y' AND                                           245273
     C                             PFPTF <> 'Y'                                               245273
     C                   EVAL      DDLNRFOK = 'N'                                             245273
     C                   EVAL      Ix = Ix + 1                                                245273
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               245273
     C                   MOVEL     'LEM0614'     MsgIdArr(Ix)                                 245273
     C                   GOTO      EVALAX                                                     245273
     C                   ENDIF                                                                245273
      *                                                                                      BUG3760
      ** If Compliance Watch Enhancement (CSD015) is installed, Watch                        BUG3760
      ** List Checking Applied and Authorization is allowed....                              BUG3760
      ** If 24x7 Midas Availability is not installed or it is installed and                  BUG3760
      ** in the main system...                                                               BUG3760
      ** Determine  if there is a pending case.                                              BUG3760
      ** If there no pending case or case has been temporarily released,                     BUG3760
      ** continue normal processing.  Otherwise send error message.                          BUG3760
      *                                                                                      BUG3760
     C                   IF        (CSD015 = 'Y') AND                                        BUG3760
     C                             (W1EWLC = 'Y')                                            BUG3760
      *                                                                                      BUG3760
     C                   IF        (CSC011 = 'N') OR                                         BUG3760
     C                             (S1MAIN = LIBR)                                           BUG3760
     C                   EVAL      WFuncType = 'CLOANCL'                                     BUG3760
     C                   EVAL      WIdntifier = DDLNRF                                       BUG3760
     C                   EVAL      WBranch = BRCA                                            BUG3760
      *                                                                                      BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND                                      BUG3760
     C                             (W3TREL <> 'Y')                                           BUG3760
     C                   EVAL      Ix = Ix + 1                                               BUG3760
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                              BUG3760
     C                   EVAL      MsgIdArr(Ix) = 'LEL0564'                                  BUG3760
     C                   GOTO      EVALAX                                                    BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                    AR1021136
      ** If the loan reference is '000000', it is an error.                                AR1021136
      *                                                                                    AR1021136
     C     DDLNRF        IFEQ      '000000'                                                AR1021136
     C     CHTP          ANDNE     'R'                                                     AR1021136
     C                   MOVE      'N'           DDLNRFOK                                  AR1021136
     C                   ADD       1             Ix                                        AR1021136
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                            AR1021136
     C                   MOVEL     '5045917'     MsgIdArr(Ix)                              AR1021136
     C                   GOTO      EVALAX                                                  AR1021136
     C                   ENDIF                                                             AR1021136
      *
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - Validation of action code 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ***  If the loan number is blank, it is an error
      ***  if auto allocation of loan numbers is on                                          BUG6108
      *
     C     DDLNRF        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'I'
     C     AUTOLN        ANDEQ     'Y'                                                       BUG6108
                                                                                              CSC024
      ***Allow*entry*for*loan*number*for*Insert*if*CSC024*is                           CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for loan number for Insert if CSC054 is                                  CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
                                                                                              CSC024
     C                   MOVE      *BLANKS       WFOTRID           8                        MD032052
     C                   MOVEL     FOTRID        WFOTRID                                    MD032052
     C     CLE134        IFEQ      'N'                                                      MD031225
     C     CLE134        OREQ      'Y'                                                      MD031225
     C     MPHAS         ANDNE     'C'                                                      MD031225
     C     WFOTRID       ANDNE     'LE000473'                                               MD032052
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0401'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF                                                              MD031225
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
      ** Check Loan Reference Duplicate                                                       CSC024
     C                   MOVE      DDLNRF        K@LNRF                                       CSC024
     C     K@LNRF        CHAIN(N)  CLOANCLLN                          99                      CSC024
     C     *IN99         IFEQ      *OFF                                                       CSC024
     C                   EVAL      DDLNRFOK       = 'N'                                       CSC024
     C                   EVAL      Ix            += 1                                         CSC024
     C                   EVAL      FldNameArr(Ix) = 'DDLNRF  '                                CSC024
     C**********         EVAL      MsgIdArr(Ix)   = 'LEL0700 '                       CSC024  BUG8241
     C                   EVAL      MsgIdArr(Ix)   = 'LEL0703 '                       CSC024  BUG8241
     C                   GOTO      EVALAI                                                     CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   END
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - Validation of action code 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0022'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
      *                                                                                       CLE030
      ***  If the loan status is 'Requires Release' then Amend option                         CLE030
      ***  is an error.                                                                       CLE030
      *                                                                                       CLE030
     C     LSTS          IFEQ      'Q'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0099'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAA                                                     CLE030
     C                   END                                                                  CLE030
      *                                                                                    AR1021136
      ** If the loan reference is '000000', it is an error.                                AR1021136
      *                                                                                    AR1021136
     C     DDLNRF        IFEQ      '000000'                                                AR1021136
     C                   MOVE      'N'           DDLNRFOK                                  AR1021136
     C                   ADD       1             Ix                                        AR1021136
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                            AR1021136
     C                   MOVEL     '5045917'     MsgIdArr(Ix)                              AR1021136
     C                   GOTO      EVALAA                                                  AR1021136
     C                   ENDIF                                                             AR1021136
      *
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACR - Validation of action code 'R'
      *****************************************************************
     C     VALACR        BEGSR
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0022'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   END
      *
      ** Check if unactioned loan amendments still exists for the loan
      *
     C**********         Z-ADD     LNRF          K@LNRF                                       CLE148
     C                   MOVEL     LNRF          K@LNRF                                       CLE148
     C     K@LOAN        SETLL     LOAMS
     C     *IN89         DOUEQ     '1'
     C     K@LOAN        READE     LOAMS                                  89
     C     *IN89         IFEQ      '0'
     C     LA_RECI       ANDEQ     'D'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0063'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
     C                   ENDDO
      *
      ** Check if outstanding fees still exists for the loan
      *
     C**********         Z-ADD     CNUM          K@CNUM                                       CSD027
     C                   EVAL      K@CNUM = CNUM                                              CSD027
     C                   Z-ADD     *ZEROS        K@FACL
     C**********         Z-ADD     LNRF          K@LNRF                                       CLE148
     C                   MOVEL     LNRF          K@LNRF                                       CLE148
     C     K@FEE         SETLL     LEFEEDL2
     C     *IN89         DOUEQ     '1'
     C     K@FEE         READE     LEFEEDL2                               89
     C     *IN89         IFEQ      '0'
     C     FERECI        ANDEQ     'D'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0065'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
     C                   ENDDO
      ****************************************************************                        CLE106
      ***Check*if*outstanding*parts*sold*still*exists*for*the*loan****                        CLE106
      ****************************************************************                        CLE106
      *                                                                                       CLE106
      ** Check if outstanding participating loans still exists for the loan                   CLE106
      *                                                                                       CLE106
     C                   EVAL      WPartsOK = 'N'                                             CLE106
     C                   EVAL      WPrimary = 'N'                                           BUG10122
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                             And NOPS > 0                                               CLE106
     C                   EVAL      WPartsOK = 'Y'                                             CLE106
     C                   MOVE      LNRF          LNRFA             6                         CSD027A
     C*****LNRF          SETLL     PSOLD                                              CLE106 CSD027A
     C*****LNRF          READE     PSOLD                                              CLE106 CSD027A
     C*****LNRFA         SETLL     PSOLD                                              CSD027A 246167
     C*****LNRFA         READE     PSOLD                                              CSD027A 246167
     C     LNRFA         SETLL     PSOLD2                                                     246167
     C     LNRFA         READE     PSOLD2                                                     246167
                                                                                              CLE106
      ** Check if any of the Parts Sold is not associated with a Participant                  CLE106
      ** if any were found loan cannot be reversed by Syndications Manager                    CLE106
                                                                                              CLE106
     C**********         DOW       Not %EOF(PSOLD)                                    CLE106  246167
     C                   DOW       Not %EOF(PSOLD2)                                           246167
     C                             And WPartsOK = 'Y'                                         CLE106
     C**********         IF        PS_PTFC = *Zeros                                   CLE106 CSD027A
     C                   IF        PS_PTFC = *Blanks                                         CSD027A
     C                   EVAL      WPartsOK = 'N'                                             CLE106
     C                   ENDIF                                                                CLE106
     C*****LNRF          READE     PSOLD                                              CLE106 CSD027A
     C*****LNRFA         READE     PSOLD                                              CSD027A 246167
     C     LNRFA         READE     PSOLD2                                                     246167
     C                   ENDDO                                                                CLE106
                                                                                              CLE106
      ** Do the same for Parts Purchased                                                      CLE106
                                                                                              CLE106
     C     LNRF          SETLL     PPURC                                                      CLE106
     C     LNRF          READE     PPURC                                                      CLE106
                                                                                              CLE106
      ** Check if any of the IPP  is not associated with a Participant                        CLE106
      ** if any were found loan cannot be reversed by Syndications Manager                    CLE106
                                                                                              CLE106
     C                   DOW       Not %EOF(PPURC)                                            CLE106
     C                             And WPartsOK = 'Y'                                         CLE106
     C**********         IF        PS_PTFC = *Zeros                                   CLE106 CSD027A
     C                   IF        PS_PTFC = *Blanks                                         CSD027A
     C                   EVAL      WPartsOK = 'N'                                             CLE106
     C                   ENDIF                                                                CLE106
     C     LNRF          READE     PPURC                                                      CLE106
     C                   ENDDO                                                                CLE106
                                                                                            BUG10122
      ** Check if primary loan                                                              BUG10122
                                                                                            BUG10122
     C**********         IF        PTFC = *ZEROS                                    BUG10122 CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A
     C                             AND PTFT = *ZEROS                                        BUG10122
     C                             AND PTFN = *ZEROS                                        BUG10122
     C                   EVAL      WPrimary = 'Y'                                           BUG10122
     C                   ENDIF                                                              BUG10122
                                                                                            BUG10122
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C     NOPS          IFGT      0
     C     WPartsOK      ANDEQ     'N'                                                        CLE106
     C     WPrimary      ANDEQ     'N'                                                      BUG10122
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0064'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
      ** Issue warning if record to be deleted is a hedged item                 225959
      *                                                                         225959
     C     CAS004        IFEQ      'Y'                                          225959
     C                   MOVE      DDLNRF        KFSDLN                         225959
      *                                                                         225959
     C     KASHF         SETLL     ASHTRNLA                                     225959
     C     KASHF         READE     ASHTRNLA                               89    225959
      *                                                                         225959
     C     *IN89         DOWEQ     *OFF                                         225959
      *                                                                         225959
     C     FSHEDI        CHAIN     ASHGLKL1                           89        225959
      *                                                                         225959
     C     *IN89         IFEQ      *ON                                          225959
     C                   MOVEL     'ASHGLKPD'    DBFILE                         *************225959
     C                   MOVEL     '008'         DBASE                          * DBERR 008 *225959
     C                   MOVEL     FSHEDI        DBKEY                          *************225959
     C                   EXSR      *PSSR                                        225959
     C                   ENDIF                                                  225959
      *                                                                         225959
     C     FSHTID        IFEQ      'D'                                          225959
     C     FSRECI        ANDEQ     'D'                                          225959
     C     FSHTID        OREQ      'D'                                          225959
     C     FSRECI        ANDEQ     'X'                                          225959
     C                   MOVE      'W'           DDACTNOK                       225959
     C                   ADD       1             Wx                             225959
     C                   MOVEL     'DDACTN'      WFldNamArr(Wx)                 225959
     C                   MOVEL     'LEM2000'     WMsgIDArr(Wx)                  225959
     C                   GOTO      EVALAR                                       225959
     C                   ENDIF                                                  225959
      *                                                                         225959
     C     KASHF         READE     ASHTRNLA                               89    225959
     C                   ENDDO                                                  225959
      *                                                                         225959
     C                   ENDIF                                                  225959
      *                                                                                       CLE134
      ** If Origin, Do not allow reversal if PDCL with a principal                            CLE134
      ** exists.                                                                              CLE134
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   IF        %SUBST(LTYP:1:1) <> 'X'                                    CLE134
     C                             AND %SUBST(LTYP:1:1) <> 'Y'                                CLE134
     C                             AND %SUBST(LTYP:1:1) <> 'Z'                                CLE134
     C                   EVAL      DSPDSts = *BLANKS                                          CLE134
      *                                                                                       CLE134
     C                   EVAL      KYPORG = LNRF                                              CLE134
     C     KLEPDUEL2     SETLL     LEPDUEL2                                                   CLE134
     C*****KLEPDUEL2     READE(E)  LEPDUEL2                                          CLE134 MD025945
     C     KLEPDUEL2     READE(E)  LEPDUEL2                               10                MD025945
      *                                                                                       CLE134
      ** Don't use EOF to shorten the process time.                                         MD025945
      ** Don't allo deletion of original loan of PDCL's RECI <> 'R'                         MD025945
      *                                                                                     MD025945
     C**********         DOW       NOT %EOF(LEPDUEL2)                                CLE134 MD025945
     C                   DOW       *IN10 = '0'                                              MD025945
     C                             AND DSPDSts <> '*LIVE'                                     CLE134
     C                   IF        YRECI = 'D'                                                CLE134
     C                   EVAL      Kpd_RECI = 'D'                                             CLE134
     C                   EVAL      Kpd_LNRF = YPLON                                           CLE134
     C     KCLOANL4      CHAIN(E)  CLOANL4                                                    CLE134
      *                                                                                       CLE134
     C                   IF        %FOUND(CLOANL4)                                            CLE134
     C**********                   AND pd_CPAM <> 0                                  CLE134 MD025945
     C                             AND pd_RECI <> 'R'                                       MD025945
     C                   EVAL      DSPDSts = '*LIVE'                                          CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        DSPDSts <> '*LIVE'                                         CLE134
     C*****KLEPDUEL2     READE(E)  LEPDUEL2                                          CLE134 MD025945
     C     KLEPDUEL2     READE(E)  LEPDUEL2                               10                MD025945
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
      *                                                                                       CLE134
      ** If LIVE PDCL exists, display Error.                                                  CLE134
      *                                                                                       CLE134
     C                   IF        DSPDSts = '*LIVE'                                          CLE134
     C                   EVAL      DDLNRFOK = 'N'                                             CLE134
     C                   EVAL      Ix += 1                                                    CLE134
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'                                  CLE134
     C                   EVAL      MsgIdArr(Ix)   = '5045599'                                 CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
      ** Else (PDCL), Do not allow reversal if Principal exists.                              CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C**********         IF        CPAM <> 0                                        CLE134 AR1079502
     C**********         EVAL      DDLNRFOK = 'N'                                   CLE134 AR1079502
     C**********         EVAL      Ix += 1                                          CLE134 AR1079502
     C**********         EVAL      FldNameArr(Ix) = 'DDACTN'                        CLE134 AR1079502
     C**********         EVAL      MsgIdArr(Ix) = '5045600'                         CLE134 AR1079502
     C**********         ENDIF                                                      CLE134 AR1079502
      **********                                                                  AR1079502 MD025945
     C**********         IF        ORED < BJRDNB                                  AR1079502 MD025945
     C**********         EVAL      DDLNRFOK = 'N'                                 AR1079502 MD025945
     C**********         EVAL      Ix += 1                                        AR1079502 MD025945
     C**********         EVAL      FldNameArr(Ix) = 'DDACTN'                      AR1079502 MD025945
     C**********         EVAL      MsgIdArr(Ix) = '5045600'                       AR1079502 MD025945
     C**********         ELSE                                                     AR1079502 MD025945
      **********                                                                  AR1079502 MD025945
     C**********         EVAL      KYPORG = LNRF                                  AR1079502 MD025945
     C*****KLEPDUEL2     CHAIN(N)  LEPDUELC                                       AR1079502 MD025945
     C**********         IF        %FOUND(LEPDUELC)                               AR1079502 MD025945
     C**********         IF        YPCBIC = 'C'                                   AR1079502 MD025945
     C**********         EVAL      DDLNRFOK = 'N'                                 AR1079502 MD025945
     C**********         EVAL      Ix += 1                                        AR1079502 MD025945
     C**********         EVAL      FldNameArr(Ix) = 'DDACTN'                      AR1079502 MD025945
     C**********         EVAL      MsgIdArr(Ix) = '5045600'                       AR1079502 MD025945
     C**********         ENDIF                                                    AR1079502 MD025945
     C**********         ENDIF                                                    AR1079502 MD025945
      **********                                                                  AR1079502 MD025945
     C**********         ENDIF                                                    AR1079502 MD025945
      **********                                                                  AR1079502 MD025945
     C                   IF        CPAM <> 0  and                                           MD025945
     C                             ORED < BJRDNB                                            MD025945
     C                   EVAL      DDLNRFOK = 'N'                                           MD025945
     C                   EVAL      Ix += 1                                                  MD025945
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'                                MD025945
     C                   EVAL      MsgIdArr(Ix) = '5045600'                                 MD025945
     C                   ENDIF                                                              MD025945
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *
     C     EVALAR        ENDSR
      *****************************************************************                       CLE030
      /EJECT                                                                                  CLE030
      *****************************************************************                       CLE030
      * VALACQ - Validation of action code 'Q' - Requires Release                             CLE030
      *****************************************************************                       CLE030
     C     VALACQ        BEGSR                                                                CLE030
      *                                                                                       CLE030
      ***  If Authorisation feature CLE002 is not switched on then                            CLE030
      ***  this is an error.                                                                  CLE030
      *                                                                                       CLE030
     C     CLE002        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0100'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   END                                                                  CLE030
      *                                                                                       CLE030
      ***  If Loans to be authorised is not 'Y' then this is an error                         CLE030
      *                                                                                       CLE030
     C     BPLOAU        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0104'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   END                                                                  CLE030
      *                                                                                       CLE030
      ***  Release Authorisation feature (CLE030) must be switched on.                        CLE030
      *                                                                                       CLE030
     C     CLE030        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0105'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   END                                                                  CLE030
      *                                                                                       CLE030
      ***  If loan status is not 'Requires Release' then this action                          CLE030
      ***  code is not allowed.                                                               CLE030
      *                                                                                       CLE030
     C     LSTS          IFNE      'Q'                                                        CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0106'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   END                                                                  CLE030
      *                                                                                       CLE030
      ***  User field cannot be the same as Authorised user from loan                         CLE030
      ***  file.                                                                              CLE030
      *                                                                                       CLE030
     C     PSUSER        IFEQ      XUSR                                                       CLE030
     C                   MOVE      'N'           DDLNRFOK                                     CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEL0107'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   END                                                                  CLE030
      *
      ***  User field cannot be the same as insert or last amend user
      ***  from loan file
      *
     C     PSUSER        IFEQ      IUSR
     C     PSUSER        OREQ      AUSR
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0404'     MsgIdArr(Ix)
     C                   GOTO      EVALAQ
     C                   END
      *                                                                                       CLE030
     C     EVALAQ        ENDSR                                                                CLE030
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - Access security checking
      *****************************************************************
     C     ACSSEC        BEGSR
      *
      ***  For single branch system, check if user is authorised to the
      ***  action

     C                   MOVEL     *BLANKS       WWACTN            1

     C     DDACTN        IFEQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C                   MOVEL     DDACTN        WWACTN
     C                   MOVEL     'E'           DDACTN
     C                   END

     C                   Z-ADD     0             @ERR              1 0
      *
     C     BGMBIN        IFEQ      'N'
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR
      *
     C     @ERR          IFNE      0
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0302'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ***  For multibranching system, and action codes not I, branch code
      ***  on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
     C     DDLNRF        ANDNE     *ZERO                                                    BUG21757
     C                   MOVE      DDACTN        @ZACTN
     C                   MOVE      BRCA          @ZBR              3
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ZBR
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0303'     MsgIdArr(Ix)
     C                   END
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0304'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ***  For multibranching system, and action codes A/R, originating
      ***  branch on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     BKOBRU        ANDEQ     'Y'
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'R'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          @ZOBRX            3
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0305'     MsgIdArr(Ix)
     C                   END
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0306'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
     C     WWACTN        IFNE      *BLANKS
     C                   MOVEL     WWACTN        DDACTN
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DET_PROCTYPE - Determine Loan Processing Type                 *
      *****************************************************************
     C     DET_PROCTYPE  BEGSR

     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     61            LoanPtyp
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDLTYP        @LNTY             2
     C                   PARM      DDSUTP        @LNST             2
     C                   PARM      DDCLAS        @LNCL             4                          CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     AYLNTY        DDLTYP
     C                   MOVEL     AYLNST        DDSUTP
     C                   MOVEL     AYLNCL        DDCLAS                                       CLE042
     C                   Z-ADD     AYLNPT        LoanPtyp
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     PTYP          LoanPtyp
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DET_LOANTYPE - Determine Loan Type                            *
      *****************************************************************
     C     DET_LOANTYPE  BEGSR

     C                   SELECT
     C     LoanPtyp      WHENEQ    61
     C     LoanPtyp      OREQ      62
     C     LoanPtyp      OREQ      63
     C     LoanPtyp      OREQ      70
     C     LoanPtyp      OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVEL     'LOAN'        LoanType
     C     LoanPtyp      WHENEQ    64
     C     LoanPtyp      OREQ      65
     C     LoanPtyp      OREQ      68
     C     LoanPtyp      OREQ      71
     C                   MOVEL     'PTPU'        LoanType
     C     LoanPtyp      WHENEQ    66
     C     LoanPtyp      OREQ      67
     C     LoanPtyp      OREQ      69
     C     LoanPtyp      OREQ      72
     C                   MOVEL     'PTSO'        LoanType
     C                   ENDSL

     C                   ENDSR
      *****************************************************************                       CLE143
      /EJECT                                                                                  CLE143
      *****************************************************************                       CLE143
      * RET_EAIR - Retrieve Effective Interest Rate                   *                       CLE143
      *****************************************************************                       CLE143
     C     RET_EAIR      BEGSR                                                                CLE143
                                                                                              CLE143
      ** Retrieve Effective Interest Rate                                                     CLE143
                                                                                              CLE143
     C                   IF        CLE143 = 'Y'  AND                                          CLE143
     C                             CAS009 = 'Y'                                               CLE143
                                                                                              CLE143
     C                   MOVEL     DDLNRF        XLNRFF            6 0                        CLE143
                                                                                              CLE143
     C                   CALL      'LE000070'                                                 CLE143
     C                   PARM                    XLNRFF                                       CLE143
     C                   PARM      *BLANKS       EIRATE           16                          CLE143
                                                                                              CLE143
     C                   IF        EIRATE <> *BLANKS                                          CLE143
     C                   Z-ADD     *ZERO         XEAIR            15 8                        CLE143
     C                   EVAL      XEAIR = %DEC(EIRATE:15:8)                                  CLE143
     C                   Z-ADD     XEAIR         EAIR                                         CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ENDSR                                                                CLE143
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs
      *
     C                   CLEAR                   CliLFilFmt
     C                   CLEAR                   CliKFilFmt
     C                   MOVEL     'Y'           DDACTNOK
     C                   MOVEL     'Y'           DDLNRFOK
      *
     C                   Z-ADD     *ZERO         Ix
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
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
      * (Midas) Customer Loan Reference
     C                   PARM                    DDLNRF            6
      *
      ** Loan type/sub type
     C                   PARM                    DDLTYP            2
     C                   PARM                    DDSUTP            2
     C                   PARM                    DDCLAS            4                          CLE042
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721

      * OUTPUTS

      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      * Loan Type
     C                   PARM                    LoanType          4

      * (Current) Customer loan CL in file format
     C                   PARM                    CliLFilFmt
      * (Current) Customer loan CK in file format
     C                   PARM                    CliKFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Loan Reference
     C                   PARM                    DDLNRFOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *                                                                         225959
      ***  Warning fields/message IDs/message data (arrays) from/to caller      225959
     C                   PARM                    WFldNamArr                     225959
     C                   PARM                    WMsgIDArr                      225959
     C                   PARM                    WMsgDtaArr                     225959
      *                                                                         225959
      ***  Array index (3P0) from/to caller                                     225959
     C                   PARM                    Wx                             225959
     C                   PARM                    PFPTF             1                          245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C/COPY WNCPYSRC,LECLIPTC01
      *
      ***  Initialise program name
      *
     C                   MOVEL     'LECLIPRTV'   DBPGM
     C                   Eval      PSysVal04 = 'LoanAlphaAllow'                               CLE148
                                                                                             BUG6108
      ** Check for auto allocation of loan numbers system value.                             BUG6108
     C                   CALLB     'AOSVALR0'                                                BUG6108
     C                   PARM      *BLANKS       PRtCd             7                         BUG6108
     C                   PARM      AutoAlloc     PSysVal01                                   BUG6108
     C                   PARM                    PCurSet01                                   BUG6108
     C**********         PARM                    PSysVal02                            BUG6108 240968
     C                   PARM      CLAuthORED    PSysVal02                                    240968
     C                   PARM                    PCurSet02                                   BUG6108
     C**********         PARM                    PSysVal03                            BUG6108 244314
     C                   PARM      CLAuthSMDT    PSysVal03                                    244314
     C                   PARM                    PCurSet03                                   BUG6108
     C                   PARM                    PSysVal04                                   BUG6108
     C                   PARM                    PCurSet04                                   BUG6108
     C                   PARM                    PSysVal05                                   BUG6108
     C                   PARM                    PCurSet05                                   BUG6108
     C                   PARM                    PSysVal06                                   BUG6108
     C                   PARM                    PCurSet06                                   BUG6108
     C                   PARM                    PSysVal07                                   BUG6108
     C                   PARM                    PCurSet07                                   BUG6108
     C                   PARM                    PSysVal08                                   BUG6108
     C                   PARM                    PCurSet08                                   BUG6108
     C                   PARM                    PSysVal09                                   BUG6108
     C                   PARM                    PCurSet09                                   BUG6108
     C                   PARM                    PSysVal10                                   BUG6108
     C                   PARM                    PCurSet10                                   BUG6108
                                                                                             BUG6108
     C                   If        PRtCd <> *Blanks                                          BUG6108
     C     *LOCK         In        LDA                                                       BUG6108
     C                   Eval      DBFile = 'SDSVALPD'                                       BUG6108
     C                   Eval      DBase = 17                                                BUG6108
     C                   Eval      DBKey = PSysVal01                                         BUG6108
     C                   Out       LDA                                                       BUG6108
     C                   ExSR      *PSSR                                                     BUG6108
     C                   EndIf                                                               BUG6108
                                                                                             BUG6108
      * Isolate the first character of the current system value setting                      BUG6108
     C                   MOVEL     PCurSet01     WRK01             1                         BUG6108
     C                   If        WRK01 = 'N'                                               BUG6108
     C                   Move      'N'           AUTOLN            1                         BUG6108
     C                   Else                                                                BUG6108
     C                   Move      'Y'           AUTOLN                                      BUG6108
     C                   EndIf                                                               BUG6108
     C                   MOVEL     PCurSet02     ATHORED           1                          240968
     C                   MOVEL     PCurSet03     ATHSMDT           1                          244314
     C                   MOVEL     PCurSet04     wLoanAlpha        1                          CLE148
      *
      ***  Key List
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C     K@FEE         KLIST
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACL            5 0
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C     KASHF         KLIST                                                  225959
     C                   KFLD                    KFSMOD            2            225959
     C**********         KFLD                    KFSDLN            6 0                 225959 CLE148
     C                   KFLD                    KFSDLN            6                          CLE148
      *                                                                         225959
     C                   MOVE      'LE'          KFSMOD                         225959
      *                                                                         225959
      **  Used for SDCWHTL1                                                                  BUG3760
      *                                                                                      BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
      *                                                                                      BUG3760
     C     KCLOANL4      KLIST                                                                CLE134
     C                   KFLD                    Kpd_RECI                                     CLE134
     C                   KFLD                    Kpd_LNRF                                     CLE134
      *                                                                                       CLE134
     C     KLEPDUEL2     KLIST                                                                CLE134
     C                   KFLD                    KYPORG                                       CLE134
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      *
      ***  Check if authorisation feature is installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '005'         DBASE                          * DBERR 005 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ***  Determine if CLE005 is installed                                                   225215
      *                                                                                       225215
     C                   MOVE      'N'           CLE005            1                          225215
     C                   CALLB     'AOSARDR0'                                                 225215
     C                   PARM      *BLANKS       @RTCD                                        225215
     C                   PARM      '*VERIFY'     @OPTN                                        225215
     C                   PARM      'CLE005'      @SARD             6                          225215
      *                                                                                       225215
     C     @RTCD         IFEQ      *BLANKS                                                    225215
     C                   MOVE      'Y'           CLE005                                       225215
     C                   ELSE                                                                 225215
     C     @RTCD         IFEQ      '*NRF'                                                     225215
     C                   MOVE      'N'           CLE005                                       225215
     C                   ELSE                                                                 225215
      *                                                                                       225215
      * DATABASE ERROR                                                                        225215
      *                                                                                       225215
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* 225215
     C                   MOVEL     '006'         DBASE                          * DBERR 006 * 225215
     C                   MOVEL     @OPTN         DBKEY                          ************* 225215
     C                   EXSR      *PSSR                                                      225215
     C                   ENDIF                                                                225215
     C                   ENDIF                                                                225215
      *                                                                                       225959
      ***  Determine if CAS004 is installed                                                   225959
      *                                                                                       225959
     C                   MOVE      'N'           CAS004            1                          225959
     C                   CALLB     'AOSARDR0'                                                 225959
     C                   PARM      *BLANKS       @RTCD                                        225959
     C                   PARM      '*VERIFY'     @OPTN                                        225959
     C                   PARM      'CAS004'      @SARD                                        225959
      *                                                                                       225959
     C     @RTCD         IFEQ      *BLANKS                                                    225959
     C                   MOVE      'Y'           CAS004                                       225959
     C                   ELSE                                                                 225959
     C     @RTCD         IFEQ      '*NRF'                                                     225959
     C                   MOVE      'N'           CAS004                                       225959
     C                   ELSE                                                                 225959
      *                                                                                       225959
      * DATABASE ERROR                                                                        225959
      *                                                                                       225959
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* 225959
     C                   MOVEL     '007'         DBASE                          * DBERR 007 * 225959
     C                   MOVEL     @OPTN         DBKEY                          ************* 225959
     C                   EXSR      *PSSR                                                      225959
     C                   ENDIF                                                                225959
     C                   ENDIF                                                                225959
                                                                                              CLE106
      ** Check for Syndications Manager feature                                               CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALL      'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                      BUG3760
      ** Determine if 24x7 Midas Availability active?                                        BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANK        @RTCD                                       BUG3760
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3760
     C                   PARM      'CSC011'      @SARD                                       BUG3760
     C*                                                                                      BUG3760
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3760
     C                   EVAL      CSC011  = 'Y'                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C*                                                                                      BUG3760
     C                   IN        SDSTAT                                                    BUG3760
     C                   IN        SC24X7                                                    BUG3760
      *                                                                                      BUG3760
      ** Access SAR Details to see if COMPLIANCE WATCH ENHANCEMENT (CSD015)                  BUG3760
      ** is installed.                                                                       BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*VERIFY '    @OPTN                                       BUG3760
     C                   PARM      'CSD015'      @SARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        @RTCD = *BLANKS                                           BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        (@RTCD <> '*NRF    ') AND                                 BUG3760
     C                             (@RTCD <> *BLANKS)                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 56                                                BUG3760
     C                   EVAL      DBKEY = @SARD                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Access SAR Details to see if Concord Interface Development (CCF001)                 BUG3760
      ** is installed.                                                                       BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*VERIFY '    @OPTN                                       BUG3760
     C                   PARM      'CCF001'      @SARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        @RTCD = *BLANKS                                           BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        (@RTCD <> '*NRF    ') AND                                 BUG3760
     C                             (@RTCD <> *BLANKS)                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 57                                                BUG3760
     C                   EVAL      DBKEY = @SARD                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      ** Access Compliance Watch Configuration file to get the                               BUG3760
      ** Private Customer Industry Codes                                                     BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*FIRST '     @OPTN                                       BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        @RTCD <> *BLANKS                                          BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBASE = 58                                                BUG3760
     C                   EVAL      DBKEY = @OPTN                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Check if function code is being monitored by compliance watch.                      BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*KEY   '     @OPTN                                       BUG3760
     C                   PARM      'LENDING'     @FUNC             8                         BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        (@RTCD <> '*NRF    ') AND                                 BUG3760
     C                             (@RTCD <> *BLANKS)                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBASE = 59                                                BUG3760
     C                   EVAL      DBKEY = @FUNC                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustment) is on                            CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 3                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 4                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 9                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 10                                                CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
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
     C                   MOVEL     'CLIP'        @APINAME                                     CAP185
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
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS  AND                                      CSD083
     C                             @RTCD <> '*NRF   '                                         CSD083
                                                                                              CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 11                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CLE143
      ** Check if CAS009 is installed                                                         CLE143
                                                                                              CLE143
     C                   CALL      'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       @RTCD                                        CLE143
     C                   PARM      '*VERIFY'     @OPTN                                        CLE143
     C                   PARM      'CAS009'      @SARD                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        @RTCD <> *BLANKS  AND                                      CLE143
     C                             @RTCD <> '*NRF   '                                         CLE143
                                                                                              CLE143
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE143
     C                   EVAL      DBase = 12                                                 CLE143
     C                   EVAL      DBKey = 'CAS009'                                           CLE143
     C                   EXSR      *PSSR                                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        @RTCD = *BLANKS                                            CLE143
     C                   EVAL      CAS009 = 'Y'                                               CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
      ** Check if CLE143 is installed                                                         CLE143
                                                                                              CLE143
     C                   CALL      'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       @RTCD                                        CLE143
     C                   PARM      '*VERIFY'     @OPTN                                        CLE143
     C                   PARM      'CLE143'      @SARD                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        @RTCD <> *BLANKS  AND                                      CLE143
     C                             @RTCD <> '*NRF   '                                         CLE143
                                                                                              CLE143
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE143
     C                   EVAL      DBase = 13                                                 CLE143
     C                   EVAL      DBKey = 'CLE143'                                           CLE143
     C                   EXSR      *PSSR                                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        @RTCD = *BLANKS                                            CLE143
     C                   EVAL      CLE143 = 'Y'                                               CLE143
     C                   ENDIF                                                                CLE143
      *                                                                                       CAP185
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
      *                                                                                       CLE134
     C                   IF        @RTCD = *BLANK                                             CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C     *DTAARA       DEFINE                  MPHAS                                      MD031225
     C                   IN        MPHAS                                                    MD031225
     C                   UNLOCK    MPHAS                                                    MD031225
     C                   ENDIF                                                                CLE134
      *
      ***  Get ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
     C                   ENDSR
      ********************************************************************
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
(c) Misys International Banking Systems Ltd. 2002
