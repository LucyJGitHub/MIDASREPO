     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayment input - retrieve')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYRTV - Manual Repayment - Retrieve                      *
      *                                                               *
      *  Function:  This module retrieves a Manual Repayment from     *
      *             the database. As it does so, it validates the     *
      *             action code, the loan reference and the sequence  *
      *             and Customer Loans, Expected Date/Sequence        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 246320             Date 06May20               *
      *  Prev Amend No. 243329             Date 06May20               *
      *                 MD049414           Date 06May20               *
      *                 CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034264           Date 05May15               *
      *                 CLE164             Date 18Aug14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD024398           Date 11May14               *
      *                 MD000091           Date 10May13               *
      *                 MD020445           Date 16May13               *
      *                 AR1096464          Date 05Apr13               *
      *                 AR809168           Date 09Jan13               *
      *                 AR1081671          Date 29Jan13               *
      *                 AR1070996          Date 20Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR317587           Date 19Aug11               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18693           Date 13May08               *
      *                 BUG17103A          Date 14Apr08               *
      *                 BUG17103           Date 24Mar08               *
      *                 CPK027             Date 16Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      *                 244314             Date 12Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242276             Date 27Sep06               *
      *                 BUG12002           Date 15Sep06               *
      *                 CAP185             Date 21Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 BUG8550            Date 16Jun06               *
      *                 BUG11240           Date 23May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG7240            Date 06Jun05               *
      *                 BUG4326            Date 17Dec04               *
      *                 BUG4209            Date 22Sep04               *
      *                 BUG3114            Date 08Aug04               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG1191            Date 17Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 224507             Date 21Jan04               *
      *                 CAP084             Date 11Oct02               *
      *                 CSF002             Date 11Aug03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  246320 - Error in account validation if settlement method is *
      *           '05'. Enhanced fix 242348 and 243329.               *
      *         - Applied for MD-49414.                               *
      *  243329 - If no defined settlement details entered, default   *
      *           payment settlement details of the loan if PTYP is   *
      *           66, 67, 69, or 72. Pattern fix 242348.              *
      *         - Applied for MD-49414.                               *
      *  MD-49414 - CLE031. Settlement ccy defaulting does not        *
      *             happen.                                           *
      *         - Applied for MD020027.                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034264 - Unable to reject transaction due to wrong sequence*
      *           - number. Remove unnecessary CHAIN.                 *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD024398 - API Performance Optimisation                      *
      *  MD000091 - Event Codes Substitution                          *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  AR1096464 - Only event code is displayed, actual message     *
      *              missing.                                         *
      *  AR809168 - System allow to delete MR. Do not allow for MR    *
      *             to be deleted if transaction is link to an        *
      *             inserted PDCL loan (Child: AR809169)              *
/*    *  AR1081671 - Expected functionality when CCR02 set to 'Y'     *
/*    *              is not working                                   *
      *  AR1070996 - Unable to create Manual Repayment_A serious Midas*
      *              error occurred                                   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - CC02: Manual Repayment Feature                      *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  AR317587 - Matured Loan can't be recovered using maturity    *
      *             date as the value date of the manual repayment.   *
      *             Amended program to allow value date of MR greater *
      *             than Maturity date for past due loans.            *
      *             (Child: AR810533)                                 *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18693 - All details of a reversed MAPY were lost          *
      *             after authorisation                               *
      *  BUG17103A - Error encountered while trying to make past due  *
      *              repayment on a loan.                             *
      *  BUG17103 - Error encountered while trying to make past due   *
      *             repayment on a loan in Singapore zone.            *
      *  CPK027 - Errors in compiling MP1_3_TTTS - 244636 incompatible*
      *           with CSD027.                                        *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  242276 - Unable to enter manual repayment for pastdue loan.  *
      *           Restored BUG11240.                                  *
      *  BUG12002 - Reverse 11240 - fix is incorrect                  *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if MAPY was amended after original entry date  *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG11240 - Unable to Authorise and/or Reject newly inserted  *
      *             Manual Repayment, error msg LEM0102 displayed.    *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSC024 - Open Month End                                      *
      *  BUG7240- Do not highlight value date and sequence number     *
      *           during display of LEM0176 error.                    *
      *  BUG4326- Highlighting wrong field                            *
      *         - Also allow lower case entry                         *
      *         - Can't have one message/two fields in error          *
      *  BUG4209- Error LEL0564 occurs when authorising transaction   *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs                                       *
      *  BUG1191- Unable to amend or authorise record with            *
      *           expected date and expected sequence <> blank.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224507 - Module loops on Dow %FOUND                          *
      *  CAP084 - Midas Plus API development                          *
      *  CSF002 - Global layer.                                       *
      *         - Replace previous ZBACT* parameters with the new     *
      *           unique code.                                        *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
     FLEMAPYL0  IF   E           K DISK    INFSR(*PSSR)
      ***  Manual Repayment by front office id
     F                                     RENAME(LOAMSDKF:LOAMSDKFOI)
      *
     F**********LELOAML0  IF   E           K DISK    INFSR(*PSSR)                           BUG18693
     FLOAMSOM1  IF   E           K DISK    INFSR(*PSSR)                                     BUG18693
      ***  Midas LE Manual Repayment file
     F                                     RENAME(LOAMSDKF:LOAMSDKRS)
     F                                     PREFIX(LO_)
     FLELOAML6  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Past Due Records in Loan Amendment
     F                                     RENAME(LOAMSDKF:LOAMSDKPD)
     F                                     PREFIX(PD_)
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE All Loan Amendments with RECi = 'D'
     F                                     RENAME(LOAMSDKF:LOAMSDKAL)
     F                                     PREFIX(AL_)
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(CL_)
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Facility Details file
     F                                     Include(FCLTYFMF)
     F                                     Prefix(FC_)
      *
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Facility Details file
     F                                     Prefix(FA_)
      *
      ** Compliance Watch Hit List File                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3760
                                                                                             BUG3760
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
                                                                                              CAP185
     F***LOAMSL3   IF   E           K DISK    INFSR(*PSSR) RENAME(LOAMSDKF:LOAML3)   CLE134 MD020445
     F***LOAMSLA   IF   E           K DISK    INFSR(*PSSR) RENAME(LOAMSDKF:LOAMLA)   CLE134 MD020445
     FLEPDUELB  IF   E           K DISK    INFSR(*PSSR)                                     AR809168
      ** Midas LE Past Due & Original Loan Link                                             AR809168
      *                                                                                     AR809168
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
                                                                                              CSC024
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
     D*WPARM****       S             20A   INZ('AutoAdjSchedRepaymnt')              CLE134 AR1070996
     D*WPARM****       S             20A   INZ('PDCLAutoAdjSchedRep')             AR1070996 MD020445
      *
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
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  Midas Feature details accessed via access program
      *
                                                                                             BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Watch List Tranaction Details File                                                  BUG3760
     D CWLCDS        E DS                  EXTNAME(SDWLTOPD)                                 BUG3760
                                                                                             BUG3760
      ** External DS for Compliance Watch Configuration Data File                            BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D PRcvParm      E DS                  EXTNAME(SDESSRPD)                                  244636
     D***WComplete             15     15                                              244636 CSF011A
     D  WComplete             16     16                                                      CSF011A
      ***  Screen Receive Instructions                                                        244636
      *                                                                                       244636
     D PPayParm      E DS                  EXTNAME(SDESSPPD)                                  243329
     D  ZComplete             15     15                                                       243329
      ***  Screen Payment Instructions                                                        243329
      *                                                                                       243329
     D ZMUSER          DS            17
     D  USRID                  1     10                                                     MD024398
     D  BRC                   11     13
     D  DEPT                  14     16
      *                                                                                       243329
      ** Data structure to get settlement method                                              243329
      *                                                                                       243329
     D P_PSTM          DS             2                                                       243329
     D  P1_PSTM                1      2  0                                                    243329
     D CMaPyFilFmt   E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(LO_)
      ***  Loan in File Format CL
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Loan in File Format AL - Past Due or Repayment Schedule Loan Amendment
     D                                     PREFIX(AL_)
      *
     D WrkDSLOAN     E DS                  EXTNAME(CLOANCL) prefix(CL_)
      *
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D OLNOAlpha               1      6                                                       CSD027
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
      *                                                                         CAP084
      ** Index for arrays of of error message ids etc                           CAP084
     D CntrMR          S              1S 0                                      CAP084
      *
      ***  Midas 24h/24h 7d/7d Interface
     D SC24X7        E DS                  EXTNAME(SC24X7)
      ***  24X7 Data Structure
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ***  SDSTAT Data Structure
                                                                                             BUG3760
      ** Switchable features - Watch List Checking                                           BUG3760
     D CSD015          S              1A                                                     BUG3760
     D CSC011          S              1A                                                     BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D WLNRF           S              6                                                      BUG3760
     D WKVDAT          S              5                                                      BUG3760
     D WLASN           S              3                                                      BUG3760
     D PSard           S              6                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
                                                                                              CSC024
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
                                                                                              CSC024
     D CAP086          S              1A                                                      CAP086
     D CLE056          S              1A                                                      CLE056
 
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
                                                                                              CLE148
     D RTNCDE          S              7A                                                      CLE148
     D SVALK1          S             20A                                                      CLE148
     D SVAL1           S            200A                                                      CLE148
     D SVALK2          S             20A                                                      CLE148
     D SVAL2           S            200A                                                      CLE148
     D SVALK3          S             20A                                                      CLE148
     D SVAL3           S            200A                                                      CLE148
     D SVALK4          S             20A                                                      CLE148
     D SVAL4           S            200A                                                      CLE148
     D SVALK5          S             20A                                                      CLE148
     D SVAL5           S            200A                                                      CLE148
     D SVALK6          S             20A                                                      CLE148
     D SVAL6           S            200A                                                      CLE148
     D SVALK7          S             20A                                                      CLE148
     D SVAL7           S            200A                                                      CLE148
     D SVALK8          S             20A                                                      CLE148
     D SVAL8           S            200A                                                      CLE148
     D SVALK9          S             20A                                                      CLE148
     D SVAL9           S            200A                                                      CLE148
     D SVALK0          S             20A                                                      CLE148
     D SVAL10          S            200A                                                      CLE148
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ***  Initialisation
      *
      *                                                                                      BUG8550
      ***  Get ZMUSER to access default branch.                                              BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
 
      ** Check whether user is a web browser user, if so overwrite                            CAP084
     C**********         CALL      'SFC000026'                                       CAP084 MD024398
     C**********         PARM      *BLANKS       USER             10                 CAP084 MD024398
      *                                                                                       CAP084
     C**********         IF        USER <> *BLANKS                                   CAP084 MD024398
     C**********         EVAL      PSUSER = USER                                     CAP084 MD024398
     C                   IF        USRID <> *BLANKS                                  CAP084 MD024398
     C                   EVAL      PSUSER = USRID                                    CAP084 MD024398
     C                   ENDIF                                                                CAP084
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             ModeofOp = '      '                                        CAP086
     C                   EVAL      LO_AUTH = *BLANKS                                          CAP086
     C                   ENDIF                                                                CAP086
      *
      ***  If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  do (EXTRA) validation for front office transaction interface
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
     C                   EXSR      VFRNT
      *
      ***  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C     OKVALD        OREQ      'N'
     C     OKEVAL        OREQ      'N'
     C     OKESEQ        OREQ      'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF                                                  *FRONT
      *
      ***  Validate Key fields and Input details
      *
     C                   EXSR      VAL
      *
      ***  Carry out no further validation if errors occurred
      *    ==================================================
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C     OKVALD        OREQ      'N'
     C                   RETURN
     C                   END
      *
      ***  *-----------------------------------------------*
      ***  * Access Security Checking                      *
      ***  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
 
      ***  Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for front office transaction interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ***  Error if action code is not 'I', 'A', 'R' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  'Action Code Must be IARX for Front Office transactions Interface'
      *
     C                   MOVEL     'LEL0603'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ***  Error if front office transaction ID is blank
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  'Front Office Id. cannot be left blank'
      *
     C                   MOVEL     'LEL0604'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ***  Access loan with front office transaction ID
      *
     C     FOTRID        CHAIN     LOAMSDKFOI                         99
      *
      ***  I N S E R T
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Front office transaction ID can't be present already
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      *** 'Insert but FO Id. &1 is already used'
      *
     C                   MOVEL     'LEL0605'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  N O T    I N S E R T
      *
      ***  front office transaction ID must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  'FO Id. Not found.'
      *
     C                   MOVEL     'LEL0606'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ***  If not insert, update Midas Key fieds :
      ***      loan number, Value date and sequence
      *
     C                   MOVEL     LNRF          DDLNRF
     C                   MOVEL     LASN          DDSEQN
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVALD
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of action code, loan number, sequence
      *       and value date
      *****************************************************************
     C     VAL           BEGSR
      *
      ***  Reset Wroking details for later validation
      *
     C                   MOVE      *blanks       WrkExpectTyp      1
     C                   Z-ADD     0             WrkExpectDayN     5 0
     C                   MOVE      *blanks       WrkPTYP72         1
     C                   MOVE      *blanks       WrkExpAmdTp       2            PD/RE Amend Type
     C                   Z-Add     0             WrkRepayTp        1 0          Loan Repay. Type
     C                   MOVE      'N'           WrkReactFacil     1            React. Matured
      *
      ***  Validate Action code - all available
      *
      ***  Action code must be I, E, A, X or R
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'R'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  'Action Code is not IEAXR'
      *
     C                   MOVEL     'LEM0021'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Check that input is made
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan must be entered and in valid format'
      *
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     'LES0030'     MsgIdArr(Ix)
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C     DDLNRF        IFNE      *BLANKS
      *
      ***  Validate Loan Number
      ***  check 1) Loan number must be numeric
      *
     C                   If        wLoanAlpha = 'N'                                           CLE148
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVEL     DDLNRF        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZRVAL            16
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan must be numeric and in valid format'
      *
     C                   MOVEL     'LES0030'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   IF        PValid <> *BLANKS                                          CLE148
     C                   EVAL      Ix = Ix + 1                                                CLE148
     C                   EVAL      OKLNRF = 'N'                                               CLE148
     C                   EVAL      FldNameArr(Ix) = 'DDLNRF'                                  CLE148
     C                   EVAL      MsgIdArr(Ix) = '5045549'                                   CLE148
     C                   GOTO      EVAL                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *
      ***  check 2) Loan must exist on Loans file as live
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN     CLOAN                              99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan number Mandatory or not found'
      *
     C                   MOVEL     'LEM0032'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                                       244636
      ** Default payment settlement details for parts sold.                                   243329
      *                                                                                       243329
     C     CL_PTYP       IFEQ      66                                                         243329
     C     CL_PTYP       OREQ      69                                                         243329
     C     CL_PTYP       OREQ      67                                                         243329
     C     CL_PTYP       OREQ      72                                                         243329
     C                   IF        DDACTN = 'I'                                               243329
     C                   IF        CL_PSTM <> 0                                               243329
     C                   Z-ADD     CL_PSTM       P1_PSTM                                      243329
     C                   MOVEL     P_PSTM        DDPSTM                                       243329
     C                   ENDIF                                                                243329
     C                   IF        CL_PONS <> *BLANKS AND                                     243329
     C                             CL_BRCA <> *BLANKS                                         243329
     C**********         IF        ZComplete <> *BLANKS                                243329 246320
     C                   IF        CL_PSTM =  05                                              246320
     C                   MOVE      CL_PONS       DDPONX                                       243329
     C                   MOVEL     CL_BRCA       DDPONX                                       243329
     C                   ELSE                                                                 243329
     C                   EVAL      DDPONX = CL_PONS                                           243329
     C                   ENDIF                                                                243329
     C                   ENDIF                                                                243329
      *                                                                                     MD049414
     C                   IF        CLE031 = 'Y'                                             MD049414
     C                   MOVE      CL_PSCY       DDPSCY                                     MD049414
     C                   MOVE      CL_PEXI       DDPEXI                                     MD049414
     C                   MOVE      *BLANK        ZFIELD                                     MD049414
      *                                                                                     MD049414
     C     CL_PEXR       IFNE      *ZEROS                                                   MD049414
     C                   MOVE      CL_PEXR       ZFIELD                                     MD049414
     C                   Z-ADD     8             ZADEC                                      MD049414
     C                   CALLB     'ZEDIT'                                                  MD049414
     C                   PARM                    ZFIELD                                     MD049414
     C                   PARM                    ZADEC                                      MD049414
     C                   MOVE      ZFIELD        DDPEXR                                     MD049414
     C                   ELSE                                                               MD049414
     C                   MOVE      *BLANKS       DDPEXR                                     MD049414
     C                   ENDIF                                                              MD049414
     C                   ENDIF                                                              MD049414
      *                                                                                     MD049414
     C                   IF        CL_POCN <> *BLANKS                                         243329
     C                   MOVEL     CL_POCN       DDPOCN                                       243329
     C                   ENDIF                                                                243329
     C                   IF        CL_POBN <> *BLANKS                                         243329
     C                   MOVEL     CL_POBN       DDPOBN                                       243329
     C                   ENDIF                                                                243329
     C                   IF        CL_PIBN <> *BLANKS                                         243329
     C                   EVAL      DDPIBN = CL_PIBN                                           243329
     C                   ENDIF                                                                243329
     C                   ENDIF                                                                243329
      *                                                                                       243329
     C                   ELSE                                                                 243329
      *                                                                                       243329
     C                   IF        DDACTN = 'I'                                               244636
     C                   IF        CL_RSTM <> 0                                               244636
     C                   MOVEL     CL_RSTM       DDRSTM                                       244636
     C                   ENDIF                                                                244636
     C                   IF        CL_RONS <> *BLANKS AND                                     244636
     C                             CL_BRCA <> *BLANKS                                         244636
     C**********         IF        WComplete <> *BLANKS                         244636 243329 246320
     C                   IF        CL_RSTM =  05                                              246320
     C                   MOVE      CL_RONS       DDRONX                                       244636
     C                   MOVEL     CL_BRCA       DDRONX                                       244636
     C                   ELSE                                                                 244636
     C                   EVAL      DDRONX = CL_RONS                                           244636
     C                   ENDIF                                                                244636
     C                   ENDIF                                                                244636
      *                                                                                     MD049414
     C                   IF        CLE031 = 'Y'                                             MD049414
     C                   MOVE      CL_SCCY       DDRSCY                                     MD049414
     C                   MOVE      CL_REXI       DDREXI                                     MD049414
     C                   MOVE      *BLANK        ZFIELD                                     MD049414
      *                                                                                     MD049414
     C     CL_PEXR       IFNE      *ZEROS                                                   MD049414
     C                   MOVE      CL_REXR       ZFIELD                                     MD049414
     C                   Z-ADD     8             ZADEC                                      MD049414
     C                   CALLB     'ZEDIT'                                                  MD049414
     C                   PARM                    ZFIELD                                     MD049414
     C                   PARM                    ZADEC                                      MD049414
     C                   MOVE      ZFIELD        DDREXR                                     MD049414
     C                   ELSE                                                               MD049414
     C                   MOVE      *BLANKS       DDREXR                                     MD049414
     C                   ENDIF                                                              MD049414
     C                   ENDIF                                                              MD049414
      *                                                                                     MD049414
     C**********         IF        CL_ROCN <> 0                                        244636 CPK027
     C                   IF        CL_ROCN <> *BLANKS                                         CPK027
     C                   MOVEL     CL_ROCN       DDROCN                                       244636
     C                   ENDIF                                                                244636
     C**********         IF        CL_ROBN <> 0                                        244636 CPK027
     C                   IF        CL_ROBN <> *BLANKS                                         CPK027
     C                   MOVEL     CL_ROBN       DDROBN                                       244636
     C                   ENDIF                                                                244636
     C                   IF        CL_RIBN <> *BLANKS                                         244636
     C                   EVAL      DDRIBN = CL_RIBN                                           244636
     C                   ENDIF                                                                244636
     C                   ENDIF                                                                244636
      *                                                                                       243329
     C                   ENDIF                                                                243329
      *
      ***  check 3) Loan should not have status of Reversed
      ***  apart from action code reverse
      *
     C     CL_RECI       IFEQ      'R'                                          Reversed
     C     DDACTN        ANDNE     'R'                                          Reversed
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Not live record on DB'
      *
     C                   MOVEL     'LEM0025'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  check 4) Loan should not have status of Matured (except when CLE007 is actived)
      ***  apart from action code reverse
      *
     C     CL_RECI       IFEQ      'M'                                          Matured
     C     CLE007        ANDNE     'Y'                                           when not CLE007
     C     DDACTN        ANDNE     'R'                                          Reversed
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  Loan has matured , cannot be processed
      *
     C                   MOVEL     'LEM0027'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'                                          Reversing a Matured
     C     CL_RECI       ANDEQ     'M'                                          Loan and Feature
     C     CLE005        ANDEQ     'Y'
      *
      ***  Check if some other Loan Amend exists (reci = 'D')
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      0             K@VALD
     C                   MOVE      0             K@LASN
     C*******************Z-ADD     0             CntrMR            1 0          Counter MR    CAP084
     C                   Z-ADD     0             CntrMR                         Counter MR    CAP084
     C                   Z-ADD     0             CntrLoAm          3 0          counter Loan Amend.
      *
     C     K@LOAM        SETLL     LOAMSDKAL
     C     K@LNRF        READE     LOAMSDKAL                              99
     C******             Dow       %FOUND                                                     224507
     C                   DoW       *IN99 = *Off                                               224507
      *
      ***  Check number of 'MR' with negative Amount (Past due repaument)
      *
     C                   if        AL_AMTP = 'MR' And AL_TAMT < 0
     C                             And AL_PAST = 'Y'
     C                   Add       1             CntrMR
     C                   Endif
      *
      ***  Check number of Other Active Loan Amendments
      *
     C                   if        AL_AMTP <> 'MR'
     C                   Add       1             CntrLoAm
     C                   Endif
     C     K@LNRF        READE     LOAMSDKAL                              99
     C                   Enddo
      *
     C                   if        CntrMR = 1 and CntrLoAm > 0
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  Reverse all transactions against this loan before reversing this neg. repayment
      *
     C                   MOVEL     'LEV1042'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
     C                   Endif
      *
      ***  check 5) Loan should not have other status than 'D' 'R' or 'M'
      *
     C     CL_RECI       IFNE      'D'                                          Live
     C     CL_RECI       ANDNE     'R'                                          Reversed
     C     CL_RECI       ANDNE     'M'                                          Matured
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  Not in DB
      *
     C                   MOVEL     'LEM0025'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  check 6)
      ***  Manual Repayment wasn't authorised if CLE005 is not actived for
      ***  for loan Processing type 68, 69 , 71 and 72.
      *
     C                   if        CLE005 <> 'Y'
     C     CL_PTYP       IFEQ      68
     C     CL_PTYP       OREQ      69
     C     CL_PTYP       OREQ      71
     C     CL_PTYP       OREQ      72
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEM0030'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   Endif
      *                                                                                      BUG3114
      ** If CLE028 is not installed, do not allow repayments for                             BUG3114
      ** flat rate personal loans                                                            BUG3114
      *                                                                                      BUG3114
     C                   if        CLE028 <> 'Y' and CL_PTYP = 80                            BUG3114
     C                   ADD       1             Ix                                          BUG3114
     C                   MOVE      'N'           OKLNRF                                      BUG3114
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                              BUG3114
     C                   MOVEL     'LEM0400'     MsgIdArr(Ix)                                BUG3114
     C                   GOTO      EVAL                                                      BUG3114
     C                   Endif                                                               BUG3114
      *
      ***  Check 7)
      ***  If trying to Re-activated a Matured Loans, a facility must exist
      ***  and must not be expired (When CLE007 (Backvalue enhancement))
      *
     C                   If        CLE007 = 'Y' and CL_RECI = 'M'
      *
      ***  build a Key for LF/FCLTY using LF/CLOAN details
      *
     C                   MOVE      'A'           k@RCTP
     C                   Eval      k@CNUM = CL_FCUS
     C                   Eval      K@FACT = CL_FTYP
     C                   Eval      K@FCNO = CL_FSEQ
      *
     C     K@FCLTY       CHAIN     FCLTY                              99
 
     C                   IF        *IN99 = *On or                               Not Found
     C                             *IN99 = *Off and FC_RECI = 'E' or            Expired
     C                             CLE005 = 'Y' and
     C                             *IN99 = *Off and FC_RECI = 'C'               Closed
 
      ***  No Facility Found,
      *
     C                   If        *IN99 = *on                                  Not Found
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Facility of Loan doesn' t exist'
      *
     C                   MOVEL     'LEM0057'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  When facility was found, check if Facility is re-activated (LF/LEFCAML3)
      *
     C     k@LEFCAML3    Setll     LEFCAML3
     C     k@LEFCAML3    ReadE     LEFCAML3                               99
     C                   DOW       *IN99 = *OFF and FA_FATP <> 'FR'             Found, not react
     C                             or *IN99 = *OFF and FA_FATP = 'FR' and       found, react but
     C                             FA_RECI <> 'D'                                not live
     C     K@LEFCAML3    ReadE     LEFCAML3                               99
     C                   ENDDO
      *
     C                   if        *IN99 = *OFF and FA_FATP = 'FR' and          found, reactivated
     C                             FA_RECI = 'D'                                and Live
     C                   Else                                                   not reactivated
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Facility of Loan has matured or was closed'
      *
     C                   MOVEL     'LEM0056'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   endif                                                  Facilty React.
      *
     C                   Endif                                                  Facilty exist
      *
     C                   MOVE      'Y'           WrkReactFacil     1            React. Matured
      *
     C                   Endif                                                  CLE007 and Matured
      *
      ***  Validate 'X' Action Code
      ***  Allow action 'X' if CLE002 = Y and Manual Repayment Auth = Y
      *
     C     DDACTN        IFEQ      'X'
     C     CLE002        IFNE      'Y'
     C     BPMRAU        ORNE      'Y'                                          from SDCLNDPD
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  Action Code 'X' (Authorised) is not allowed.
      *
     C                   MOVEL     'LEM0011'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
     C                   Endif                                                  DDACTN ' X'
      *
     C                   Endif                                                  DDLNRF not Blank
      *
      ***  Validate Value Date
      *
     C                   MOVE      *BLANK        WVERR             1
      *
      ***  Value date should not be blanks
      *
     C     DDVALD        IFEQ      *BLANKS
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date is Mandatory and in valid format
      *
     C                   MOVEL     'LEM0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Value date should be numeric and in valid date format
      *
     C                   MOVEL     DDVALD        WFLD7N            6 0
     C                   MOVEL     WFLD7N        WFLD6A            6
     C     DDVALD        IFNE      WFLD6A
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date is Mandatory and in valid format
      *
     C                   MOVEL     'LEM0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   MOVE      DDVALD        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date is Mandatory and in valid format
      *
     C                   MOVEL     'LEM0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        WrkValueDayN      5 0
      *
      ***  If action is Insert, add Validation for Value date
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Value date should not be earlier than start date and no later
      ***  than maturity date
      *
     C                   if        CLE003 <> 'Y' and WrkValueDayN <= CL_VDAT or
     C                             CLE003 = 'Y' and WrkValueDayN < CL_VDAT or
     C                             CL_MDAT <> 0 and WrkValueDayN > CL_MDAT
                                                                                            AR317587
      ** If Maturity Date is in the past and loan is still not matured,                     AR317587
      ** then repayment should be allowed for pastdue loan with value                       AR317587
      ** date greater than maturity.                                                        AR317587
                                                                                            AR317587
     C                   IF        CL_RECI = 'D' and CL_MDAT < BJRDNB                       AR317587
     C                             and CL_CPAM <> 0 and                                     AR317587
     C                             DDEVAL <> *BLANKS or                                     AR317587
     C                             CL_RECI = 'D' and CL_MDAT < BJRDNB                       AR317587
     C                             and CL_PDIN <> 0 and                                     AR317587
     C                             DDEVAL <> *BLANKS                                        AR317587
     C                   ELSE                                                               AR317587
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Error on Value date - Earlier than Start date or GT Maturity date'
      *
     C                   MOVEL     'LEM0103'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF                                                              AR317587
     C                   Endif
      *
      ***  Extra validation for value date
      *
      ***  When CLE005 IS NOT activated, value date must not be after rundate
      *
     C                   if        CLE005 <> 'Y' and WrkValueDayN > BJRDNB
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Error on Value date - Must not be aftre rundate'
      *
     C                   MOVEL     'LEM0199'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  When CLE007 is activated and Processing a Matured Loans
      ***  value date must be equal to Maturity date
      *
     C                   if        CLE007 = 'Y' and CL_RECI = 'M' and
     C                             WrkValueDayN <> CL_MDAT
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Error on Value date - Must not be aftre rundate'
      *
     C                   MOVEL     'LEM0028'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  Calculate Back value limit
      *
     C     BJRDNB        SUB       BJBVPD        WBKLIM            5 0
      *
      ***  CLE003 - BacKvaluation
      *
     C     CLE003        IFNE      'Y'                                           not Active
      *
      ***  If Start date/last interest date is LT Limit and Value date is LT start Date
      ***  or                               is GE Limit and            is LT Limit date
      *
     C     CL_SLID       IFLT      WBKLIM
     C     WrkValueDayN  ANDLT     CL_SLID
     C     CL_SLID       ORGE      WBKLIM
     C     WrkValueDayN  ANDLT     WBKLIM
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
     C                   MOVEL     'LEM0111'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF                                                  CLE003
      *
      ***  If CLE014 is on, value date must not be between multi-currency
      ***  rollover date and the working date after it.
      *
     C     CLE014        IFEQ      'Y'
     C     CL_RLDT       ANDNE     *ZERO
      *
     C                   MOVE      'B'           K@RCDT
     C     K@LOAN        CHAIN     CLOANCKF                           99
      *
     C     *IN99         IFEQ      *OFF
     C     CL_NCCY       ANDNE     *BLANKS
     C     CL_NCCY       ANDNE     CL_CCY
      *
     C                   Z-ADD     CL_RLDT       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
     c                   if        WrkValueDayN > CL_RLDT
     c                             and WrkValueDayN < ZDYNBR
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date is an holiday after the scheduled multi-ccy Rollover Date'
      *
     C                   MOVEL     'LEM0038'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  Back-valued Manual Repayment is prohibited if rollover
      ***  details exists
      *
     C                   if        CL_RLDT < WRNDAY
     c                             and WrkValueDayN < WRNDAY
     c                             and WrkValueDayN > CL_RLDT
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date After Specified Rollover date'
      *
     C                   MOVEL     'LEM0039'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
     C                   ENDIF                                                  CL_NCCY
      *
     C                   ENDIF                                                  CLE014
      *
      ***  Validate Value date depending on CLE003 back valuation with rollover
      *
     C                   IF        CLE003='Y' and CL_MCRA='Y' and CL_LMCD<>0    CLE003
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
      *
      ***  'Value date must no be earlier than last M-Ccy rollover Date.'
      *
     C                   MOVEL     'LEM0022'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
     C                   Endif                                                  DDACTN = 'I'
      *
      ***  Validate Sequence Number
      ***  Sequence number should be blank if action is Insert
      *
     C     DDSEQN        IFEQ      '000'
     C                   MOVE      *BLANKS       DDSEQN
     C                   ENDIF
                                                                                              CSC024
      ***Allow*entry*for*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C**********         IF        CSC024 <> 'Y' OR                                    CSC024 CSC054
     C**********                   WOMEInd <> 'Y'                                      CSC024 CSC054
     C                   IF        CSC054 <> 'Y' OR                                           CSC054
     C                             WPEAInd <> 'Y'                                             CSC054
      *
     C     DDSEQN        IFEQ      *BLANKS
     C     DDACTN        ANDNE     'I'
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
      *
      ***  'Sequence mandatory when Action code is not 'I'.'
      *
     C                   MOVEL     'LEM0107'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Sequence number should not be blank if action is not Insert
      *
     C     DDSEQN        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'I'
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
      *
      ***  'Sequence is forbidden when Action code is 'I'.'
      *
     C                   MOVEL     'LEM0108'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
                                                                                              CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         IF        CSC024 = 'Y' AND                                    CSC024 CSC054
     C**********                   WOMEInd = 'Y'                                       CSC024 CSC054
     C                   IF        CSC054 = 'Y' AND                                           CSC054
     C                             WPEAInd = 'Y'                                              CSC054
                                                                                              CSC024
     C                   IF        DDACTN = 'I' AND                                           CSC024
     C                             DDSEQN <> *BLANKS                                          CSC024
                                                                                              CSC024
     C                   MOVE      DDLNRF        K@LNRF                                       CSC024
     C                   MOVE      ZDAYNO        K@VALD                                       CSC024
     C                   MOVE      DDSEQN        K@LASN                                       CSC024
                                                                                              CSC024
     C     K@LOAM        CHAIN     LOAMSDKAL                                                  CSC024
     C                   IF        %FOUND(LELOAML3)                                           CSC024
     C                   MOVE      'N'           OKACTN                                       CSC024
     C                   EVAL      Ix = Ix + 1                                                CSC024
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CSC024
     C                   MOVEL     'LEM1525'     MsgIdArr(Ix)                                 CSC024
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ENDIF                                                                CSC024
      *
      ***  Sequence number should be numeric
      *
     C     DDSEQN        IFNE      *BLANKS
     C                   MOVEL     DDSEQN        WFLD4N            3 0
     C                   MOVEL     WFLD4N        WFLD3A            3
     C     DDSEQN        IFNE      WFLD3A
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
      *
      ***  'Invalid Sequence Number'
      *
     C                   MOVEL     'LEM0031'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG1191
      ***  If Action not 'I', blank expected value date and expected                         BUG1191
      ***  sequence number and reset at end of subroutine.                                   BUG1191
      *                                                                                      BUG1191
     C                   if        DDACTN <> 'I'                                             BUG1191
      *                                                                                      BUG1191
     C                   MOVE      DDEVAL        SVEVAL                                      BUG1191
     C                   MOVE      DDESEQ        SVESEQ                                      BUG1191
     C                   MOVE      *BLANKS       DDEVAL                                      BUG1191
     C                   MOVE      *BLANKS       DDESEQ                                      BUG1191
     c                   Endif                                                               BUG1191
      *
      ***  Validate Expected Value Date
      ***  If Action not 'I', Expected value date must be left Blank
      *
     C                   if        DDACTN <> 'I' and DDEVAL <> *BLANKS
      *
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Actionn not 'I', Expected value date must be left blank.'
      *
     C                   MOVEL     'LEM0109'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   Endif
      **********                                                                   BUG11240 BUG12002
     C**********         If        DDACTN <> 'I'                                   BUG11240 BUG12002
     C**********         Eval      DDEVAL = SVEVAL                                 BUG11240 BUG12002
     C**********         EndIf                                                     BUG11240 BUG12002
      *                                                                                       242276
     C                   If        DDACTN <> 'I'                                              242276
     C                   Eval      DDEVAL = SVEVAL                                            242276
     C                   EndIf                                                                242276
      *
      ***  Processing for a discounted Loans must be To Settle an expected Repayment
      ***  thus Expected Date must be filled in.
      *
     C                   If        CL_PTYP=63 or CL_PTYP=65 or CL_PTYP = 67
     C**********         if        DDACTN <> 'I' or DDEVAL = *BLANKS                          242276
     C                   if        DDACTN <> 'I' and DDEVAL = *BLANKS                         242276
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Discount loan but not Past Due details input'
      *
     C                   MOVEL     'LEM0102'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
     C                   Endif
      **********                                                                   BUG11240 BUG12002
     C**********         If        DDACTN <> 'I'                                   BUG11240 BUG12002
     C**********         Eval      SVEVAL = DDEVAL                                 BUG11240 BUG12002
     C**********         Eval      DDEVAL = *BLANKS                                BUG11240 BUG12002
     C**********         EndIf                                                     BUG11240 BUG12002
      *                                                                                       242276
     C                   If        DDACTN <> 'I'                                              242276
     C                   Eval      SVEVAL = DDEVAL                                            242276
     C                   Eval      DDEVAL = *BLANKS                                           242276
     C                   EndIf                                                                242276
      *
      ***  Expected Value date should be numeric and in valid date format
      *
     C     DDEVAL        IFNE      *BLANKS
      *
     C                   MOVE      DDEVAL        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Value date is Mandatory and in valid format
      *
     C                   MOVEL     'LEM0104'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        WrkExpectDayN     5 0
      *
      ***  Expected date must be :
      ***  - After value date Or
      ***  - Before value date and After Maturity date (when non 0)
      *
     C                   IF        WrkExpectDayN <= CL_VDAT or                  before value date
     C                             CL_MDAT <> 0 and WrkExpectDayN > CL_MDAT     if Mat date not 0
      *                                                                         but after Mat. Date
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
 
      ***  'Value date is Mandatory and in valid format
      *
     C                   MOVEL     'LEM0106'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF                                                  DDEVAL not Blank
      *
      ***  Validate Expected Sequence
      ***  If Action not 'I', Expected value date must be left Blank
      *
     C                   if        DDACTN <> 'I' and DDESEQ <> *BLANKS
      *
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
      *
      ***  'Actionn not 'I', Expected Sequence must be left blank.'
      *
     C                   MOVEL     'LEM0110'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   Endif
      *
     c                   if        DDACTN = 'I'                                 insert Validation
 
      ***  1) Expected Sequence is mandatory when Insert and Expected Value Date was input
      *
     C                   If        DDESEQ = *BLANKS and DDEVAL <> *BLANKS
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
      *
      ***  'Expected Seq. must be LN or a valid Sequence'
      *
     C                   MOVEL     'LEM0202'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   endif
 
      ***  2) Expected Value Date must be input if Action ='I' and Exp. seq. is input.
      *
     C                   If        DDESEQ <> *BLANKS and DDEVAL = *BLANKS
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C**********         MOVEL     'DDESEQ'      FldNameArr(Ix)                              BUG4326
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)                              BUG4326
 
      ***  'Please, fill in Expected Date when Expected sequence is filled in (when Insert).'
      *
     C                   MOVEL     'LEM0210'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   endif
 
      ***  3) Expected Value date may be LN or a valid numeric
      *
      * Allow lower case entry                                                               BUG4326
     C                   If        %Subst(DDESEQ:1:1) = 'l '                                 BUG4326
     C                   Eval      %Subst(DDESEQ:1:1) = 'L '                                 BUG4326
     C                   EndIf                                                               BUG4326
     C                   If        %Subst(DDESEQ:2:1) = 'n '                                 BUG4326
     C                   Eval      %Subst(DDESEQ:2:1) = 'N '                                 BUG4326
     C                   EndIf                                                               BUG4326
                                                                                             BUG4326
     c                   if        DDESEQ <> 'LN ' And DDESEQ <> *blanks
      *
     C                   MOVEL     DDESEQ        WFLD4N            3 0
     C                   MOVEL     WFLD4N        WFLD3A            3
      *
     C                   if        DDESEQ = '000' or DDESEQ <> WFLD3A
      *
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
 
      ***  'Invalid or wrong format for sequence number'
      *
     C                   MOVEL     'LEM0031'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   endif                                                  not numeric
     c                   endif                                                  'LN '
      *
     C                   endif                                                  DDACTN = 'I'
 
      *
      ***  Other Validation : Check Manual Repayment Loan Amendment
      ***  Access loan amendment record what ever Action Code is.
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      WrkValueDayN  K@VALD
     C                   MOVE      DDSEQN        K@LASN
      *
     C**********K@LOAM        CHAIN     LELOAML0                           99        LOAMSDKBUG18693
     C     K@LOAM        CHAIN     LOAMSOM1                           99        LOAMSDK     BUG18693
      *
     C                   if        DDACTN <> 'I'
      *
      ***  Error if loan amendment not found
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan Amendment cannot be found in DB'
      *
     C                   MOVEL     'LEM0176'     MsgIdArr(Ix)
     C**********         MOVE      'N'           OKVALD                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDVALD'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C**********         MOVE      'N'           OKSEQN                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDSEQN'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  if loan amendment type MR (as expected), then verify RECI
      *
     C     DDACTN        IFEQ      'E'
     C     LO_AMTP       ANDEQ     'MR'
     C     LO_RECI       ANDNE     'R'
     C     LO_RECI       ANDNE     'D'
     C     DDACTN        ORNE      'E'
     C     LO_AMTP       ANDEQ     'MR'
     C     LO_RECI       ANDNE     'D'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEM0001'     MsgIdArr(Ix)
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                                     AR809168
      ** If to be reversed, check if 'MR' is link to an inserted                            AR809168
      ** PDCL loan                                                                          AR809168
      *                                                                                     AR809168
     C     DDACTN        IFEQ      'R'                                                      AR809168
     C     LO_RECI       ANDEQ     'D'                                                      AR809168
     C     CLE134        ANDEQ     'Y'                                                      AR809168
     C     CL_AUTO       ANDEQ     'C'                                                      AR809168
      *                                                                                     AR809168
     C                   MOVE      DDLNRF        K@LNRF                                     AR809168
      *                                                                                     AR809168
     C     K@LEPDUEPD    SETLL     LEPDUED0                                                 AR809168
     C     K@LEPDUEPD    READE     LEPDUED0                               99                AR809168
      *                                                                                     AR809168
     C     *IN99         DOWEQ     '0'                                                      AR809168
     C     YRECI         IFEQ      'D'                                                      AR809168
     C     YVDAT         ANDEQ     LO_VDAT                                                  AR809168
     C                   MOVE      YPCPAM        WPPRAM           13 0                      AR809168
     C                   MOVE      YPDINT        WPINTA           13 0                      AR809168
     C     WPPRAM        IFEQ      LO_PRAM                                                  AR809168
     C     YPDCT         ANDEQ     'P'                                                      AR809168
     C     WPINTA        OREQ      LO_INTA                                                  AR809168
     C     YPDCT         ANDEQ     'I'                                                      AR809168
     C     WPPRAM        OREQ      LO_PRAM                                                  AR809168
     C     WPINTA        ANDEQ     LO_INTA                                                  AR809168
     C     YPDCT         ANDEQ     'T'                                                      AR809168
      *                                                                                     AR809168
     C     YPCBIC        IFEQ      'I'                                                      AR809168
     C                   MOVE      'N'           OKLNRF                                     AR809168
     C                   ADD       1             Ix                                         AR809168
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                             AR809168
     C                   MOVEL     '5045869'     MsgIdArr(Ix)                               AR809168
     C                   GOTO      EVAL                                                     AR809168
     C                   ENDIF                                                              AR809168
      *                                                                                     AR809168
     C                   ENDIF                                                              AR809168
     C                   ENDIF                                                              AR809168
     C     K@LEPDUEPD    READE     LEPDUED0                               99                AR809168
     C                   ENDDO                                                              AR809168
      *                                                                                     AR809168
     C                   ENDIF                                                              AR809168
      *
      ***  if not MR, Output message depending type
      *
     C                   If        LO_AMTP <> 'MR'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     c                   select
     C                   When      LO_AMTP = 'RE'
     C                   MOVEL     'LEM0002'     MsgIdArr(Ix)
     C                   When      LO_AMTP = 'PD'
     C                   MOVEL     'LEM0003'     MsgIdArr(Ix)
     C                   Other
     C                   MOVEL     'LEM0008'     MsgIdArr(Ix)
     C                   Endsl
     C                   MOVE      'N'           OKVALD
     C                   ADD       1             Ix
     C                   MOVEL     'DDVALD'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
     C                   if                      DDACTN = 'X'
      *
      ***  error if status is not 'C'omplete or 'R'eauthorise
      *
     C     CLE002        IFEQ      'Y'
     C     BPMRAU        ANDEQ     'Y'
      *
      ***  Check status of loan amendment
      *
     C     LO_ASTS       IFNE      'C'
     C     LO_ASTS       ANDNE     'R'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  Action is invalid.
      *
     C                   MOVEL     'LEM0014'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  Error if User is the same as Insert/Amendment User
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
     C     LO_LCD        ANDGT     LO_ORED                                                    240968
     C     LO_CHTP       ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     LO_ORED                                                    240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
     C     LO_CHTP       ANDEQ     'A'                                                        244314
     C     LO_ASTS       ANDEQ     'R'                                                        244314
     C     PSUser        IFEQ      LO_AUSR                                                    240968
     C                   MOVE      'N'           OKACTN                                       240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LEM0013'     MsgIdArr(Ix)                                 240968
     C                   GOTO      EVAL                                                       240968
     C                   END                                                                  240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PsUSer        COMP      LO_IUSR                                51
     C     *IN51         IFEQ      '0'
     C     PsUser        COMP      LO_AUSR                                51
     C                   ENDIF
     C     *IN51         IFEQ      *ON
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and LO_ORED = BJRDNB                         CLE056
     C                                           and PSUser = LO_IUSR) or                     CLE056
     C                             (CLE056 = 'Y' and LO_LCD = BJRDNB and                      CLE056
     C                              LO_CHTP = 'A' and PSUser = LO_AUSR)                       CLE056
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *
      ***  'User should not be the same as Insert/Amendment User'
      *
     C                   MOVEL     'LEM0013'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   EndIf                                                                CLE056
     C                   Endif
     C                   ENDIF                                                                240968
     C                   Endif                                                  BPMRAU = 'Y'
      *                                                                                       CAP185
     C                   ENDIF                                                                CAP185
                                                                                             BUG3760
      **  Watch List Checking Applied                                                        BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVE      DDLNRF        WLNRF                                       BUG3760
     C                   MOVE      DDVALD        WKVDAT                                      BUG3760
     C                   MOVE      DDSEQN        WLASN                                       BUG3760
     C                   EVAL      WFuncType = 'LOAMSDK'                                     BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WIdntifier = %TRIM(WLNRF + WKVDAT + WLASN)                BUG3760
     C                   EVAL      WBranch = BRCA                                            BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                           06                     BUG3760
                                                                                             BUG3760
     C**********         IF        *IN06 = '1' AND W3TREL <> 'Y'                     BUG3760 BUG4209
     C                   IF        *IN06 = '0' AND W3TREL <> 'Y'                             BUG4209
     C                   ADD       1             Ix                                          BUG3760
     C                   MOVEL     'LEL0564'     MsgIdArr(Ix)                                BUG3760
     C                   EVAL      FldNameArr(Ix)  = 'DDACTN'                                BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   Endif                                                  DDACTN = 'X'
     c                   Endif                                                  DDACTN <> 'I'
      *
      ***  if Expected value date is filled check that Loam Amendment RE or PD exist
      *
     C                   if        DDACTN <> 'I'
     C                   Z-ADD     LO_XAVD       K@VALD                   67
     C                   MOVE      LO_XASQ       K@LASN
     C                   Else
     C                   Z-ADD     WrkExpectDayN K@VALD                   67
     C                   MOVE      DDESEQ        K@LASN
     C                   Endif
      *
      ***  if sequence is not 'LN '
      *
     C                   if        DDESEQ <> 'LN '
      *
     C                   if        *IN67 = *ON                                  No PD or RE details
     C                   GOTO      EVAL
     c                   Endif
      *
      ***  Access Expected Date /Seq Loan Amendment
      *
     C     k@LOAM        Chain     LOAMSDKAL                          99
      *
      ***  if not live record exist, error (AL_RECI = 'D')
      *
     C                   if        *IN99 = *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'No Valid repayment found at expected date'
      *
     C                   MOVEL     'LEM0176'     MsgIdArr(Ix)
     C**********         MOVE      'N'           OKVALD                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDVALD'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C**********         MOVE      'N'           OKSEQN                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDSEQN'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C                   GOTO      EVAL
     C                   endif
      *
      ***  Loan Amendment must be a Past due or a Repayment Scheduled
      ***  For Insert of Manual Repayment wih expected date
      *
     C                   if        DDACTN = 'I'
      *
     C                   if        AL_AMTP <> 'PD' and AL_AMTP <> 'RE'
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'No Valid repayment found at expected date'
      *
     C                   MOVEL     'LEM0176'     MsgIdArr(Ix)
     C**********         MOVE      'N'           OKESEQ                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDESEQ'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C                   GOTO      EVAL
     C                   Endif
      *
      ***  RE or PD must be with Autosettle Flag = 'N'
      ***  For Insert of Manual Repayment wih expected date
      *
     C**********         if        AL_AUTO <> 'N'                                           MD020445
     C                   if        AL_AUTO = 'Y'                                            MD020445
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Repayment is autosettle'
      *
     C                   MOVEL     'LEM0307'     MsgIdArr(Ix)
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
     C                   Endif                                                  DDACTN = 'I'
      *
      ***  Processing for discounted loans is only allowed for past due settlements
      *
     C                   If        CL_PTYP = 63 or CL_PTYP = 65 or CL_PTYP = 67
     C                   if        AL_AMTP <> 'PD'
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Dicounted loand but no Past due Record'
      *
     C                   MOVEL     'LEM0102'     MsgIdArr(Ix)
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   endif
     C                   endif
      *
      ***  if not in insert, and amended loan type is nor RE or PD, Error
      *
     C                   if        DDACTN <> 'I' and AL_AMTP <> 'RE'
     C                                           and AL_AMTP <> 'PD'
     C**********         MOVE      'N'           OKACTN                                      BUG7240
     C                   ADD       1             Ix
      *
      ***  'No Valid repayment found at expected date'
      *
     C                   MOVEL     'LEM0176'     MsgIdArr(Ix)
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                              BUG7240
      *
     C                   MOVE      'N'           OKLNRF
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
     C**********         MOVE      'N'           OKVALD                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDVALD'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
      *
     C**********         MOVE      'N'           OKSEQN                                      BUG7240
     C**********         ADD       1             Ix                                          BUG7240
     C**********         MOVEL     'DDSEQN'      FldNameArr(Ix)                              BUG7240
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG7240
     C                   GOTO      EVAL
     C                   endif
      *
      ***  if Action is 'I', Returns type of Repayment
      *
     c                   Eval      WrkExpAmdTp = AL_AMTP
     C                   if        DDACTN = 'I' and AL_AMTP = 'PD'
     C                   Eval      WrkExpectTyp = 'Y'
     C                   endif
      *
     C                   endif                                                  <> 'LN '
      *
      ***  if action is 'I', check processing type
      ***                    check Autosettle flag
      ***                    check Repayment date
      *
     C                   if        DDACTN = 'I'
     C                   select
     C                   When      CL_PTYP=63 or CL_PTYP=65 or CL_PTYP=67
      *
     C                   if        AL_AMTP <> 'PD'
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'discounted loan, but Expected loan is not a Past due'
      *
     C                   MOVEL     'LEM0102'     MsgIdArr(Ix)
     C                   MOVE      'N'           OKESEQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDESEQ'      FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   Endif                                                  AMTP <> 'PD'
      *
     C                   When      CL_PTYP = 61 or CL_PTYP = 62 or
     C                             CL_PTYP = 64 or CL_PTYP = 66 or
     C                             CL_PTYP = 68 or CL_PTYP = 69 or
     C                             CL_PTYP = 70 or CL_PTYP = 71
      *
     C                   when      CL_PTYP = 72 and CLE005 = 'Y'
      *
      ***  Access old loan number
      *
     C*****              Z-Add     CL_OLNO       K@LNRF                                       CSD027
     C                   EVAL      OLNOAlpha = CL_OLNO                                        CSD027
     C**********         EVAL      K@LNRF = OLNONum                                    CSD027 CLE148
     C                   EVAL      K@LNRF = CL_OLNO                                           CLE148
     C                   MOVE      'A'           K@RCDT
     C     K@LOAN        CHAIN     CLOAN                              99
      *
     C                   if        CL_PTYP = 63 or CL_PTYP = 65 or CL_PTYP= 67
     C                   eval      WrkPTYP72 = 'Y'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan Processing type is not 61, 62, 64, 66, 68, 69, 70, 71 or 72'
      *
     C                   MOVEL     'LEM0211'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     c                   endif
      *
      ***  Re-access Loan Details
      *
     C                   MOVE      DDLNRF        k@LNRF
     C     K@LOAN        CHAIN     CLOAN                              99
      *
     C                   other
      *
      ***  Wrong Loan Type  PTYP
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan Processing type is not 61, 62, 64, 66, 68, 69, 70, 71 or 72.'
      *
     C                   MOVEL     'LEM0211'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   endsl                                                  CL_PTYP
      *
      ***  Autosettle must be 'N'
      *
     C**********         if        DDESEQ = 'LN ' and CL_AUTO <> 'N'                        BUG17103
     C**********                   or DDESEQ <> 'LN ' and AL_AUTO <> 'N'                    BUG17103
     C**********         if        DDESEQ = 'LN ' and AL_AUTO <> 'N'              BUG17103 BUG17103A
     C**********                   or DDESEQ <> 'LN ' and CL_AUTO <> 'N'          BUG17103 BUG17103A
     C                   if        DDESEQ = 'LN ' and CL_AUTO = 'Y'                        BUG17103A
     C                             or DDESEQ <> 'LN ' and AL_AUTO = 'Y'                    BUG17103A
     C**********                   or DDESEQ = 'LN ' and CL_AUTO = 'C' and           CLE134 MD020445
     C**********                   CLE134 =  'Y'                                     CLE134 MD020445
     C**********                   or DDESEQ <> 'LN ' and AL_AUTO = 'C' and          CLE134 MD020445
     C**********                   CLE134 =  'Y'                                     CLE134 MD020445
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
      *
      ***  'Loan matched against autosettle loan. '
      *
     C                   MOVEL     'LEM0208'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   endif                                                  autosettle
      *
      ***  when 'LN ', check next Repayment date
      *
     C                   if        DDESEQ = 'LN ' and
     C                             WrkExpectDAyN  <> CL_NRPD and
     C                             CL_REPT <> 2
     C                   MOVE      'N'           OKEVAL
     C                   ADD       1             Ix
     C                   MOVEL     'DDEVAL'      FldNameArr(Ix)
      *
      ***  'Expected value date <> Next Repayment Value date'
      *
     C                   MOVEL     'LEM0207'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   Endif
      *
     C                   endif                                                  'I'
      *
     C     EVAL          tag
      *    --------------------
      *
      ***  if Insert Check if Past Due Record exist when Expected date not filled in in Insert.
      *
     C                   if        DDACTN = 'I' and DDEVAL = *blanks
     C     k@LNRF        SETLL     LOAMSDKPD                              99
     C                   if        *IN99 = *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Wx
     C**********         MOVE      'DDLNRF'      WFldNamArr(Wx)                            AR1096464
     C                   MOVEL     'DDLNRF'      WFldNamArr(Wx)                            AR1096464
      *
      ***  'Past due exist, but expected date not entered'.
      *
     C                   MOVEL     'LEM0231'     WMsgIdArr(Wx)
     C                   endif
     C                   endif
      *
      ***  Warning : if Participation linked to a syndicated Loans
      *
     C                   if        DDACTN = 'I'
     C                             And CLE106 <> 'Y'                                          CLE106
     C                   IF        CL_LNKS = 'Y'                                Loan syndicated
     C                   IF        CL_PTYP = 64 or CL_PTYP = 65 or CL_PTYP = 66
     C                             or CL_PTYP= 67 or CL_PTYP= 68 or CL_PTYP = 69
     C                             or CL_PTYP = 71 or CL_PTYP = 72
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Wx
     C                   MOVE      'DDACTN'      WFldNamArr(Wx)
      *
      ***  'W:This is syndicated - Use Loan Manager if you required Autogeneration'
      *
     C                   MOVEL     'LEM0232'     WMsgIdArr(Wx)
      *
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Wx
     C                   MOVE      'DDLNRF'      WFldNamArr(Wx)
     C                   MOVEL     *BLANKS       WMsgIdArr(Wx)
     C                   Endif
     C                   Else                                                   CL_LNKS not 'Y'
      *
      ***  Warning if Loan or direct Participation Purchased with Facility syndicated
      *
     C                   IF        CL_PTYP = 61 or CL_PTYP = 62 or CL_PTYP = 63
     C                             or CL_PTYP= 64 or CL_PTYP= 65 or CL_PTYP = 68
     C                             or CL_PTYP = 70 or CL_PTYP = 71
     c                   IF        FC_SYIN = 'Y'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Wx
     C                   MOVE      'DDACTN'      WFldNamArr(Wx)
      *
      ***  'W:This is syndicated - Use Loan Manager if you required Autogeneration'
      *
     C                   MOVEL     'LEM0232'     WMsgIdArr(Wx)
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Wx
     C                   MOVE      'DDLNRF'      WFldNamArr(Wx)
     C                   MOVEL     *BLANKS       WMsgIdArr(Wx)
     C                   Endif                                                  FC_SYIN
     C                   Endif                                                  Loans
     C                   Endif                                                  CL_LNKS
     C                   Endif                                                  DDACTN
      *
     C                   if        Ix  = *zero
      *
      ***  transfer Working Details for DSP, RTV or CVT modules
      *
     C                   Eval      WrkExpAmdTp = AL_AMTP
     C                   Eval      WrkRepayTp  = CL_REPT                        Loan Repay. type
      *
      ***  Keep Withholding Tax Rate for CVT Module
      *
     C                   if        CL_WTIN = 'G'
     C                   Eval      WrkWHoldTaxRat = CL_WTRT
     C                   endif
      *
     c                   endif
     C**********         IF        CLE134 = 'Y' AND DDACTN = 'R'                    CLE134 AR1081671
     C**********         IF        CLE134 = 'Y' AND DDACTN = 'R' OR               AR1081671 MD020445
     C**********                   CLE134 = 'Y' AND DDACTN = 'X'                  AR1081671 MD020445
     C**********         EXSR      Chckrversedta                                     CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
      *
      *                                                                                      BUG1191
      ***  If Action not 'I' and DDEVAL was previously blanked to                            BUG1191
      ***  avoid error message LEM0109 reset now to avoid error                              BUG1191
      ***  LEM0603 from LEMAPYAMD.                                                           BUG1191
      *                                                                                      BUG1191
     C                   if        DDACTN <> 'I'                                             BUG1191
      *                                                                                      BUG1191
     C                   MOVE      SVEVAL        DDEVAL                                      BUG1191
     C                   MOVE      SVESEQ        DDESEQ                                      BUG1191
     c                   Endif                                                               BUG1191
      *                                                                                      BUG1191
      *                                                                                       CLE164
     C                   If        CLE134 = 'Y'                                               CLE164
     C                   if        DDACTN <> 'A' And                                          CLE164
     C                             DDACTN <> 'I' And                                          CLE164
     C                             DDACTN <> 'X'                                              CLE164
      *                                                                                       CLE164
     C*****K@LOAM        Chain     LOAMSDKRS                                         CLE164 MD034264
     C                   Move      LO_AUTO       DDAuto                                       CLE164
      *                                                                                       CLE164
     C                   Endif                                                                CLE164
     C                   EndIf                                                                CLE164
      *                                                                                       CLE164
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - Access security checking
      *****************************************************************
     C     ACSSEC        BEGSR
      *
      ***  Validate User Authority on Action/Branch
      *
     C                   MOVE      *BLANK        WAERR             1
      *
      ***  For single branch system, check if user is authorised to the
      ***  action
      *
     C                   Z-ADD     *ZERO         @ERR
     C     BGMBIN        IFEQ      'N'
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBACTU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @USER
     C**********         PARM                    @ZMGRP                                       CSF002
     C**********         PARM                    @ZICDE                                       CSF002
     C                   PARM                    @UNQCDE                                      CSF002
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @ERR
     C                   ENDIF
     C     @ERR          IFNE      0
     C                   MOVEL     'LES0302'     SaveMsgIdArr      7
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
      ***  For multibranching system, and action codes A/E/R, branch code
      ***  on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
     C                   MOVE      DDACTN        @ZACTN
     C                   MOVE      CL_BRCA       @ZBR
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBACTBU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @ZBR
     C                   PARM                    @USER            10
     C**********         PARM                    @ZMGRP            4 0                        CSF002
     C**********         PARM                    @ZICDE            4                          CSF002
     C                   PARM                    @UNQCDE          10                          CSF002
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @ZBR              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
     C     @ERR          IFEQ      1
     C                   MOVEL     'LES0303'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVEL     'LES0304'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
      ***  For multibranching system, and action codes A/R, originating
      ***  branch on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     BKOBUV        ANDEQ     'Y'
     C     BKOBRU        ANDEQ     'Y'
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBOBU'
     C                   PARM      CL_ORBR       @ZOBRX
     C                   PARM                    @USER
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVOBU'
     C                   PARM      CL_ORBR       @ZOBRX            3
     C                   PARM                    @ERR
     C                   ENDIF
     C     @ERR          IFEQ      1
     C                   MOVEL     'LES0305'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVEL     'LES0306'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
     C     WAERR         IFEQ      'Y'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     SaveMsgIdArr  MsgIdArr(Ix)
     C**********         MOVE      'N'           OKACTN                                      BUG4326
     C**********         ADD       1             Ix                                          BUG4326
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                              BUG4326
     C**********         MOVEL     *BLANKS       MsgIdArr(Ix)                                BUG4326
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      *** Is the support system on?
      *
     C     CSC011        IFEQ      'Y'
     C**********         IN        SDSTAT                                                   MD024398
     C**********         IN        SC24X7                                                   MD024398
     C     S1SUPP        Ifeq      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   Else
     C                   Z-ADD     BJRDNB        WRNDAY
     C                   Endif
     C                   ENDIF
      *
      ***  Clear outputs
      *
     C                   CLEAR                   CMaPyFilFmt
     C                   CLEAR                   PDLoAmFilFmt                  PD or RE (LOAMSDK)
     C                   CLEAR                   WrkDSLOAN                     Loan Details(CLOANCL)
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKLNRF
     C                   MOVEL     'Y'           OKVALD
     C                   MOVEL     'Y'           OKSEQN
     C                   MOVEL     'Y'           OKEVAL                         expected Val. date
     C                   MOVEL     'Y'           OKESEQ                         Expected Sequence
      *
     C                   Z-ADD     *ZERO         Ix                             Error
     C                   Z-ADD     *ZERO         Wx                             Warning
      *
     C                   ENDSR
      *****************************************************************
     C*****Chckrversedta BEGSR*****************************************              CLE134 MD020445
      *****************************************************************              CLE134 MD020445
     C*****MRTKEY        KLIST                                                       CLE134 MD020445
     C**********         KFLD                    CLNRF             6                 CLE134 MD020445
     C**********         KFLD                    CVALD             5 0               CLE134 MD020445
     C**********         MOVE      CL_LTYP       NPDLC             1                 CLE134 MD020445
     C**********         MOVE      'N'           UpSRFlg                             CLE134 MD020445
     C*****WrkValueDayN  IFEQ      BJRDNB                                            CLE134 MD020445
     C*****NPDLC         ANDNE     'Z'                                               CLE134 MD020445
     C*****NPDLC         ANDNE     'X'                                               CLE134 MD020445
     C*****NPDLC         ANDNE     'Y'                                               CLE134 MD020445
     C*****CL_REPT       ANDEQ     2                                                 CLE134 MD020445
     C*****MSRCMP        ANDEQ     'Y'                                               CLE134 MD020445
     C**********         MOVEL     DDLNRF        CLNRF                               CLE134 MD020445
     C**********         MOVEL     BJRDNB        CVALD                               CLE134 MD020445
     C*****MRTKEY        CHAIN     LOAMSL3                            99             CLE134 MD020445
     C**********         MOVE      DDSEQN        XXSEQN            3 0               CLE134 MD020445
     C******IN99         IFEQ      *OFF                                              CLE134 MD020445
     C*****XXSEQN        ANDEQ     LASNCL                                            CLE134 MD020445
     C*****MRTKEY        CHAIN     LOAMSLA                            99             CLE134 MD020445
     C******IN99         IFEQ      *OFF                                              CLE134 MD020445
     C**********         MOVE      'N'           OKLNRF                              CLE134 MD020445
     C**********         ADD       1             WX                                  CLE134 MD020445
     C**********         EVAL      WFldNamArr(Wx) = 'DDLNRF'                         CLE134 MD020445
     C**********         IF        DDACTN = 'X'                                   AR1081671 MD020445
     C**********         EVAL      WMsgIDArr(Wx)  = '5045556'                     AR1081671 MD020445
     C**********         ELSE                                                     AR1081671 MD020445
     C**********         EVAL      WMsgIDArr(Wx)  = '5045557'                        CLE134 MD020445
     C**********         ENDIF                                                    AR1081671 MD020445
     C**********         MOVE      'Y'           UpSRFlg                             CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDSR                                                       CLE134 MD020445
      *****************************************************************              CLE134 MD020445
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *    ======
     C                   PARM                    RetCodeIn                      Ret Code
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
     C                   PARM                    RespMode          1            Response mode
     C                   PARM                    DDACTN            1            Action Code
     C                   PARM                    FOTRID           20            Front Office ID
     C                   PARM                    DDLNRF            6            Midas loan Number
     C                   PARM                    DDVALD            6            Midas Value date
     C                   PARM                    DDSEQN            3            Midas Sequence no.
     C                   PARM                    DDEVAL            6            Expected Date
     C                   PARM                    DDESEQ            3            Expected Sequence
      *** Feature indicator
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE009            1
     C                   PARM                    CLE014            1
      *
      ***  OUTPUTS
      *    =======
      ***  (Current) loan in file format CL
     C                   PARM                    CMaPYFilFmt
     C                   PARM                    OKACTN            1            OK Actn code
     C                   PARM                    OKLNRF            1            OK Loan ref
     C                   PARM                    OKVALD            1            OK Value Date
     C                   PARM                    OKSEQN            1            OK Sequence
     C                   PARM                    OKEVAL            1            OK Expected Date
     C                   PARM                    OKESEQ            1            OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators/DS for display and Managements
     C                   PARM                    WrkWHoldTaxRat   11 7          W/hold Tax Rate
     C                   PARM                    WrkExpectTyp      1            Expect Amend Loan tp
     C                   PARM                    WrkPTYP72         1            Expected on type 72
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    CntrMR                         Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkDSLOAN                      Loan File Fmt
      ***  Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
     C                   PARM                    Wx                3 0
     C                   PARM                    PRcvParm                                     244636
     C                   PARM                    PPayParm                                     243329
     C**********         PARM                    UpSRFlg           1                 CLE134 MD020445
     C                   PARM                    UpSRFlg           1                          CLE164
     C                   PARM                    DDAuto            1                          CLE164
                                                                                             BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
      *
      ***  Initialise program name
      *
     C                   MOVEL     'LEMAPYRTV'   DBPGM
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
                                                                                              CLE134
      ** Access Switchable SAR details for the existence of CLE134                            CLE134
                                                                                              CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
                                                                                              CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134            1                          CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                       CLE106
      ** Access Switchable SAR details for the existence of CLE106                            CLE106
      *                                                                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANK        @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106            1                          CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                     MD049414
      ** Access Switchable SAR details for the existence of CLE031                          MD049414
      *                                                                                     MD049414
     C                   CALLB     'AOSARDR0'                                               MD049414
     C                   PARM      *BLANK        @RTCD                                      MD049414
     C                   PARM      '*VERIFY'     @OPTN                                      MD049414
     C                   PARM      'CLE031'      @SARD                                      MD049414
      *                                                                                     MD049414
     C     @RTCD         IFEQ      *BLANKS                                                  MD049414
     C                   MOVE      'Y'           CLE031            1                        MD049414
     C                   ELSE                                                               MD049414
     C                   MOVE      'N'           CLE031                                     MD049414
     C                   ENDIF                                                              MD049414
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
      ***  Retrieve midas module details
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
      ***  Access CSC011 feature, 24x7 Interface
      *
      ** CSC011 is a redundant feature. No need to check                                    MD024398
                                                                                            MD024398
     C                   MOVE      'N'           CSC011            1
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD             6                        MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      *
     C*****@RTCD         IFEQ      *BLANKS                                                  MD024398
     C**********         MOVE      'Y'           CSC011                                     MD024398
     C******DTAARA       DEFINE                  SDSTAT                                     MD024398
     C******DTAARA       DEFINE                  SC24X7                                     MD024398
     C**********         Endif                                                              MD024398
      *                                                                                      BUG3760
      **  Access SAR details to see if CSD015 is switched on.                                BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 906                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CSC024
      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C                   PARM      'CSC024'      @SARD                                        CSC024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS AND                                       CSC024
     C                             @RTCD <> '*NRF   '                                         CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C                   EVAL      DBKey  = 'CSC024'                                          CSC024
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
     C                   ENDIF                                                                240968
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 240968
     C                   PARM      CLAuthORED    P@OP02                                       240968
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C**********         PARM      *BLANKS       P@OP03                                CSC024 244314
     C                   PARM      CLAuthSMDT    P@OP03                                       244314
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C**********         PARM      *BLANKS       P@OP04                                CSC024 CLE134
     C**********         PARM      WPARM         P@OP04                              CLE134 MD020445
     C                   PARM      *BLANKS       P@OP04                                     MD020445
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
     C**********         ENDIF                                                         CSC024 240968
     C                   MOVEL     P@VL02        ATHORED           1                          240968
     C                   MOVEL     P@VL03        ATHSMDT           1                          244314
     C**********         MOVEL(P)  P@VL04        WRK01             1                 CLE134 MD020445
     C*****WRK01         IFEQ      'Y'                                               CLE134 MD020445
     C**********         MOVE      'Y'           MSRCMP            1                 CLE134 MD020445
     C**********         ELSE                                                        CLE134 MD020445
     C**********         MOVE      'N'           MSRCMP                              CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
                                                                                              CSC024
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
     C                   MOVEL     'MAPY'        @APINAME                                     CAP185
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
      *                                                                                       CAP185
      ** Check System Value: LoanAlphaAllow                                                   CLE148
      *                                                                                       CLE185
     C                   EVAL      SVALK1 = 'LoanAlphaAllow'                                  CLE148
      *                                                                                       CLE148
     C                   CALL      'AOSVALR0'                                                 CLE148
     C                   PARM                    RTNCDE                                       CLE148
     C                   PARM                    SVALK1                                       CLE148
     C                   PARM                    SVAL1                                        CLE148
     C                   PARM                    SVALK2                                       CLE148
     C                   PARM                    SVAL2                                        CLE148
     C                   PARM                    SVALK3                                       CLE148
     C                   PARM                    SVAL3                                        CLE148
     C                   PARM                    SVALK4                                       CLE148
     C                   PARM                    SVAL4                                        CLE148
     C                   PARM                    SVALK5                                       CLE148
     C                   PARM                    SVAL5                                        CLE148
     C                   PARM                    SVALK6                                       CLE148
     C                   PARM                    SVAL6                                        CLE148
     C                   PARM                    SVALK7                                       CLE148
     C                   PARM                    SVAL7                                        CLE148
     C                   PARM                    SVALK8                                       CLE148
     C                   PARM                    SVAL8                                        CLE148
     C                   PARM                    SVALK9                                       CLE148
     C                   PARM                    SVAL9                                        CLE148
     C                   PARM                    SVALK0                                       CLE148
     C                   PARM                    SVAL10                                       CLE148
      *                                                                                       CLE148
      ** If the system value is not found then issue a database error                         CLE148
      *                                                                                       CLE148
     C                   IF        RTNCDE <> *BLANKS                                          CLE148
     C                   EVAL      DBFile = 'SDSVALPD'                                        CLE148
     C                   EVAL      DBKey  = '*FIRST  '                                        CLE148
     C                   EVAL      DBase  = 7                                                 CLE148
     C                   EXSR      *PSSR                                                      CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     SVAL1         wLoanAlpha                                   CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
jim   *
jim   ***  Temp field for expected value date
jim   *
jim  C     *LIKE         DEFINE    DDEVAL        SVEVAL
jim  C     *LIKE         DEFINE    DDESEQ        SVESEQ
      *
      ***  Key list for LOAMS/LELOAML0/LELOAML6
      *
     C     K@LOAM        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@VALD            5 0
     C                   KFLD                    K@LASN            3 0
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@RCDT            1
      *
      ***  Key list for FCLTY
      *
     C     K@FCLTY       KLIST
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
     C                   KFLD                    K@RCTP            1
      *
      ***  Key list for LEFCAML3
      *
     C     K@LEFCAML3    KLIST
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
      *                                                                                     AR809168
      ** Key list for LEPDUEPD                                                              AR809168
      *                                                                                     AR809168
     C     K@LEPDUEPD    KLIST                                                              AR809168
     C                   KFLD                    K@LNRF                                     AR809168
      *
      ***  Get ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
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
     C                   EVAL      DBase  = 5                                                 CAP086
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
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSard                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF   '                                      CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBase = 9                                                  CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
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
(c) Finastra International Limited 2002
