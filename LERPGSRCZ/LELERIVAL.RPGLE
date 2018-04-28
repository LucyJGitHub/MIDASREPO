     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover instructions validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIVAL - LE Rollover Instructions Validation              *
      *                                                               *
      *  Function: This Program Validates LE Rollover Input into      *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD031083           Date 25Nov14               *
      *  Prev Amend No. MD028338           Date 25Nov14               *
      *                 AR820729           Date 09Sep13               *
      *                 MD000091           Date 09May13               *
      *                 AR826115           Date 07Dec12               *
      *                 AR648838           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR819932           Date 02Sep11               *
      *                 AR848149           Date 15Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE064             Date 02Feb11               *
      *                 262581             Date 25Nov09               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22935           Date 16Feb09               *
      *                 BUG21898           Date 03Mar09               *
      *                 BUG21949           Date 07Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248162             Date 06Jul07               *
      *                 BUG13843           Date 02May07               *
      *                 CAS019             Date 20Apr07               *
      *                 247860             Date 25May07               *
      *                 246575             Date 30Mar07               *
      *                 244339             Date 30Mar07               *
      *                 CRE026             Date 16Feb07               *
      *                 BUG13199           Date 02Feb07               *
      *                 BUG12985           Date 09Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 238523             Date 26Apr06               *
      *                 237744             Date 26Jan06               *
      *                 239717             Date 21Jun06               *
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 15Jun06               *
      *                 240288             Date 06Jun06               *
      *                 BUG11329           Date 08May06               *
      *                 BUG10622           Date 21Feb06               *
      *                 BUG9787 (Reopen)   Date 22Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10232           Date 31Jan06               *
      *                 BUG9787            Date 05Jan05               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9655            Date 19Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6926            Date 17May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4845            Date 01Nov04               *
      *                 BUG4493            Date 14Oct04               *
      *                 BUG3531            Date 07Jul04               *
      *                 BUG3352            Date 30Jun04               *
      *                 BUG2579 (CLE023)   Date 24Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG827             Date 11May04               *
      *                 BUG19  (CAP084)    Date 12Jan04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 WA0021             Date 02Oct03               *
      *                 WA0026             Date 02Oct03               *
      *                 WA0025             Date 01Oct03               *
      *                 WA0023             Date 30Sep03               *
      *                 WA0022             Date 30Sep03               *
      *                 WA0017             Date 29Sep03               *
      *                 WA0005             Date 19Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031083 - Rollover event got an unexpected warning message, *
      *             Dettachment from Base Rate. Prevent display of the*
      *             message when rollover is for FX rate change only. *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Add new  *
      *             field to flag rollover as 'FX Rate Change Only'.  *
      *  AR820729 - Loan remains unauthorised after Rejection. Add    *
      *             error message to prevent amendment when loan      *
      *             details had been changed. (Child: AR820730)       *
      *           - Applied for MD022300                              *
      *  MD000091 - Event Codes Substitution                          *
      *  AR826115 - Allow rollover even if BPBCRF='N' in Lending ICD. *
      *             (Child: AR826116)                                 *
      *  AR648838 - Rollover event defaulted interest payment date    *
      *           - Applied fix 258917A to suppress defaulting        *
      *             when IPFR <> 'R'.                                 *
      *             (Child: AR648839)                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *            (Recompile)                                        *
      *  AR819932 - LEV0603 upon loan event reject (Child:AR819933)   *
      *  AR848149 - Contractual spread does not validate properly if  *
      *             New Base Rate Code has asterisk                   *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  262581 - The validation added by CAS019 is not necessary,    *
      *           since the new maturity date can only be amended     *
      *           to be after the current maturity date.              *
      *           Also, ensure End Amortisation Date is changed on    *
      *           all fees attached to a loan only when loans file    *
      *           is updated.                                         *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ß24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG22935 - Not able to complete the transaction for          *
      *             Multi-currency Rollover                           *
      *  BUG21898 - Missing rollover frequency                        *
      *  BUG21949 - Fix irregular Freq for next rollover date         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248162 - Problems with rejection of loan rollover amendments *
      *           when base rate code and spread rate are blanks but  *
      *           spread rate indicator is 'A'.  Also applied fix     *
      *           BUG12985.                                           *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CAS019  - Upgrade of CAS016 to Midas Plus.                   *
      *  247860 - If there is no record found in SDBSHSPD, initialise *
      *           value of G0HIDT.                                    *
      *  246575 - New MAturity date wrongly set up                    *
      *  244339 - New spread rate indicator should not be left blank  *
      *           if the new base rate code and new spread rates are  *
      *           not blanks.                                         *
      *  CRE026 - Consumer Banking                                    *
      *  BUG13199 - Serious Midas error encountered when trying to    *
      *             complete a loan rollover                          *
      *  BUG12985 - Rejecting a Rollover in WIP does not revert the   *
      *             Rollover Status from 'R' back to 'A' after it has *
      *             been Auto Authorised. Auto Authorisation is auto- *
      *             matically invoked by the thin client after it has *
      *             invoked an Amend transaction for the Loan Roll-   *
      *             over Event.                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  238523 - Dafault SPIN to 'A' when base rate code is blank and*
      *           spread rate has been inserted.                      *
      *  239717 - Highlight the appropriate multi-currency field in   *
      *           error correctly together with error code LEV1047.   *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237744 - Added validation of new maturity date for part sold *
      *           loan.                                               *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  240288 - Rework of 232235/200967 for API module              *
      *  BUG11329  - Incorrect error message. See Bugzilla.           *
      *  BUG10622 - Use CLE036 switchable instead of CLE035.          *
      *  BUG9787 - (Reopen) Added the action code 'X' when checking   *
      *            for the New Maturity Date.                         *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG10232 - Amended validation of New Spread Rate Indicator.  *
      *  BUG9787 - Maturity date should not be entered on call loans. *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9655- Base rate field in Loans, Base Rate Code Change in  *
      *           Loan Event and Rollover Maintenance should be       *
      *           dependent on switchable feature CLE036.             *
      *  CLE106 - Syndications Manager                                *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits. Added *
      *           Base Rate and Fixed Rate fields.                    *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CLE031 - Lending Enhancements for Nordea Head Offices        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG6926 - Re-Authorise deleted rollover for discount loan    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4845 - Remove validation of old rollover date v. expiry dte
      *  BUG4493 - Warning message field ok flag is set up like error.*
      *  BUG3531 - The 25% tolerance doesn't check for multiply/      *
      *            divide indicator.                                  *
      *  BUG3352 - Added error message for New Forward Yield.         *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *            Additional fix: 193859, 215988, 214821, 214226,    *
      *            203095.                                            *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  BUG19  - Midas Plus API development  (CAP084)                *
      *           Remove Rollover Status from defn file.              *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  WA0021 - Remove Rollover Status from defn file (recompile)   *
      *  WA0026 - Wrong currency being used for base rate             *
      *  WA0025 - Only send each error message once                   *
      *  WA0023 - Only send message LEV1050 once                      *
      *  WA0022 - Initialisation of work fields needs to happen every *
      *           time module is called not just once.                *
      *  WA0017 - Rollover Day Number should not be reset if          *
      *           Frequency is invalid                                *
      *  WA0005 - Recompiled over changed LEVLERLPD                   *
      *  CAP084 - Midas Plus API development                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
     FLEHISTL1  IF   E           K DISK
     F                                     PREFIX(H_)
 
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
 
     FFCLTY     IF   E           K DISK
     F                                     PREFIX(F_)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
 
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
 
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
 
     FLELOANL2  IF   E           K DISK
     F                                     RENAME(CLOANCKF:LOANL2F)
     F                                     PREFIX(L2_)
 
      ** Midas LE Fee Details                                                                 CAS019
     FLEFEEDLH  IF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     IGNORE(LEFHSTF)                                    262581
      *                                                                                       CAS019
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELERIV001
 
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** EXTERNAL DS FOR CUSTOMER LENDING ICD
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** EXTERNAL DS FOR BASE RATE CODES
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      ** Profit centre accounting ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D  SCLCD        E                     EXTFLD(LCD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External data structure for branch details
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
     D**   Historic Base Rates
 
     DSDLOAN         E DS                  EXTNAME(SDLOANPD)                                  BUG827
      ** Loan Types/Subtypes                                                                  BUG827
                                                                                              BUG827
     DSDYLDC         E DS                  EXTNAME(SDYLDCPD)                                  BUG827
      ** Yield Curves Master File                                                             BUG827
                                                                                              BUG827
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(LELERIPD)
      * Incoming Transaction Screen format
 
     D ExtData       E DS                  EXTNAME(LELEEXPD)
      * LE Rollover Extra Data - File (D/B) format
 
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Current Loan in File Format CL
     D  @LFSYLDC     E                     EXTFLD(FSYLDC)                                     BUG827
      *
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Current Loan in File Format CK
     D  @KRECI       E                     EXTFLD(RECI)
     D  @KLNRF       E                     EXTFLD(LNRF)
     D  @KRCDT       E                     EXTFLD(RCDT)
     D  @KMRIN       E                     EXTFLD(MRIN)
     D  @KORED       E                     EXTFLD(ORED)
     D  @KLCD        E                     EXTFLD(LCD)
     D  @KCHTP       E                     EXTFLD(CHTP)
     D  @KTNLU       E                     EXTFLD(TNLU)
     D  @KFRNT       E                     EXTFLD(FRNT)
     D  @KAFRT       E                     EXTFLD(AFRT)
     D  @KREPA       E                     EXTFLD(REPA)
     D  @KTMST       E                     EXTFLD(TMST)
      *
     D ValidloanL    E DS                  EXTNAME(LEVLERLPD)
     D                                     PREFIX(L_)
      ***  New Loan in File Format CL
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                542   1086                                                       CGL029
     D***CLRECEx             1579   1596                                               CGL029 TDA023
     D***CLPAYEx             1597   1614                                               CGL029 TDA023
     D  CLRECEx             1597   1614                                                       TDA023
     D  CLPAYEx             1615   1632                                                       TDA023
      *
     D ValidloanK    E DS                  EXTNAME(LEVLERKPD)
      ***  New Loan in File Format CK
     D                                     PREFIX(K_)
     D***CKREC**              401    469                                                      CGL029
     D***CKPAY**              544   1102                                                      CGL029
     D  CKREC                415    469                                                       CGL029
     D  CKPAY                558   1102                                                       CGL029
     D  CKRECEx             1266   1283                                                       CGL029
     D  CKPAYEx             1284   1301                                                       CGL029
      *
     D LELERI2       E DS                  EXTNAME(LELERI2PD)
      ** Rollover Instructions Work fields
 
      *
     D SC24X7        E DS                  EXTNAME(SC24X7)
      * 24X7 Data Structure
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      * SDSTAT Data Structure
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (LERI) Extra Data - File (D/B) format                                              CAP086
      *
      **  Front Office (2 First characters determine System Front Office)
     D FrontOffice     DS            20
     D  W_System               1      2
 
     D FCTREC          DS            12                                                       CLE031
     D**WFCUS***               1      6  0                                            CLE031 CSD027A
     D  WFCUS                  1      6                                                      CSD027A
     D  WFTYP                  7      9  0                                                    CLE031
     D  WFSEQ                 10     11  0                                                    CLE031
     D  WRCTP                 12     12                                                       CLE031
                                                                                              CLE031
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(LEELERIPD)
 
      ** A code to indicate the calling function to the lower level modules
     D LERI            S              4A   INZ('LERI')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      *
      ** Parameters for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
      *
     D ACCYA           S              3    DIM(12)
      *
     D                 DS
      **  Data structure workfield for dates.
     D  W1DTE8                 1      8
     D  W1DTE6                 1      6
     D  W1DTE4                 1      4
     D  W1DTE2                 1      2
     D  W3DTE4                 3      4
     D  W5DTE6                 5      6
     D  W7DTE8                 7      8
      *
      ** Fields for subroutine ZXRATE
     D PRate1          S             13P 8
     D PRate2          S             13P 8
     D PRateX          S             13P 8
     D PMDI1           S              1A
     D PMDI2           S              1A
     D PMDIX           S              1A
      *
      ** Parameters for zchkh
     D PDateIn         S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A
      *
      **  Work fields for rates cross validation                                              CLE035
     D WxBRA           S             12A                                                      CLE035
     D WxBRT           S             12A                                                      CLE035
     D WxRTS           S             12A                                                      CLE035
     D WxRTF           S             12A                                                      CLE035
                                                                                              CLE035
      **  Array containing valid frequency codes
     D*FTAB*****       S              1    DIM(4) CTDATA PERRCD(4)                          BUG21898
     D*FTAB*****       S              1    DIM(5) CTDATA PERRCD(5)                   BUG21898 CLE064
     D FTAB            S              1    DIM(22) CTDATA PERRCD(22)                          CLE064
      *
      ** Format amount returned by standard subroutine ZFRPED
     D                 DS
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *
     D ZOUT25          S             25A
                                                                                              CLE031
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)                            CLE031
      *
      * Work warning field for CLE030 processing                                              CLE030
     D W_CLRSTS        S                   LIKE(K_CLRSTS)                                     CLE030
      ** ReAuthorise constant value                                                          BUG6926
     D W_ReAutho       S             16    Inz('REAUTHORISE REQ.')                           BUG6926
                                                                                             BUG6926
                                                                                              CLE030
     D CLE031          S              1                                                       CLE031
     D*CLE035***       S              1                                              CLE035 BUG10622
     D CLE036          S              1                                                      BUG9655
     D CLE106          S              1                                                       CLE106
                                                                                              CLE106
     D CRE073          S              1                                                       CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D TMBSRT          S             11P 7                                                    CRE073
     D PModule         S              6                                                       CRE073
     D PCurset         S              2  0                                                    CRE073
     D PNewSpread      S             11P 7                                                    CRE073
     D PFinalRate      S             11P 7                                                  AR847249
     D DDFRCOOK        S              1                                                     MD028338
                                                                                              CRE073
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELERIV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
      /COPY WNCPYSRC,LELERIV003
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
      *                                                                                       WA0022
      **  Initialise work fields                                                              WA0022
      *                                                                                       WA0022
     C                   EXSR      SRINIW                                                     WA0022
 
      *                                                                                     AR820729
      ** Check if loan details have been amended                                            AR820729
      *                                                                                     AR820729
     C                   EXSR      SRLSTS                                                   AR820729
      *
      *  *------------------------------------------------------*
      *  *  Display warning message if loan is syndicated       *
      *  *------------------------------------------------------*
      *
     C                   EXSR      SRWARN
 
      /COPY WNCPYSRC,LELERIV004
 
      *
      * VALIDATE FIELDS IN SEQUENCE
      *
 
      *  *-------------------------------*
      *  * Validate Customer             *
      *  *-------------------------------*
      *
 
      /COPY WNCPYSRC,LELERIV005
 
     C                   EXSR      SRCUST
 
      /COPY WNCPYSRC,LELERIV006
 
      *
      *  *------------------------------------------------------*
      *  *  Define the first charater of removable fields       *
      *  *------------------------------------------------------*
      *
 
      /COPY WNCPYSRC,LELERIV007
 
     C                   EXSR      SRRVFD
 
      /COPY WNCPYSRC,LELERIV008
 
      *
      *  *------------------------------------------------------*
      *  * Access history to pick up the last rollover date     *
      *  *------------------------------------------------------*
      *
     C     LNRF          SETGT     LEHISTL1
     C     LNRF          READPE    LEHISTL1                               89
     C     *IN89         IFEQ      *OFF
     C                   Z-ADD     0             WIN89             1 0
     C                   ELSE
     C                   Z-ADD     1             WIN89
     C                   ENDIF
 
      /COPY WNCPYSRC,LELERIV009
 
      *
      *  *------------------------------------------------------*
      *  * Access Facility file                                 *
      *  *------------------------------------------------------*
      *
     C                   MOVE      FCUS          WFCUS
     C                   MOVE      FTYP          WFTYP
     C                   MOVE      FSEQ          WFSEQ
     C                   MOVE      'A'           WRCTP
      *
     C     K#FCLT        CHAIN     FCLTY                              85
 
      /COPY WNCPYSRC,LELERIV010
 
      *
      *  *------------------------------------------------------*
      *  * Validate Rollover Timing Details (Group A amendment) *
      *  *------------------------------------------------------*
      *
      ** Validate Rollover Date
      *
 
      /COPY WNCPYSRC,LELERIV011
 
     C                   EXSR      SRRLDT
 
      /COPY WNCPYSRC,LELERIV012
 
      *
      ** Validate Rollover Frequency
      *
 
      /COPY WNCPYSRC,LELERIV013
 
     C                   EXSR      SRRLFQ
 
      /COPY WNCPYSRC,LELERIV014
 
      *
      ** Validate Rollover Day Number
      *
 
      /COPY WNCPYSRC,LELERIV015
 
     C                   EXSR      SRRLDY
 
      /COPY WNCPYSRC,LELERIV016
 
      *
      *  *------------------------------------------------------*
      *  * Validate  Rollover Details (Group B amendment)       *
      *  *------------------------------------------------------*
      *
      ** Validate New Base Rate Code
      *
 
      /COPY WNCPYSRC,LELERIV017
 
     C**********         IF        CLE035 = 'Y'                                       CLE035 BUG9655
     C                   IF        CLE036 = 'Y'                                              BUG9655
      *                                                                                       CLE035
      ***  Validate Rates (Base and Fixed)                                                    CLE035
      *                                                                                       CLE035
     C                   EXSR      SRFBRT                                                     CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
     C                   EXSR      SRNBRA
 
      /COPY WNCPYSRC,LELERIV018
 
      *
      ** Validate New Spread Rate
      *
 
      /COPY WNCPYSRC,LELERIV019
 
     C                   EXSR      SRNRTS
     C                   ENDIF                                                                CLE035
 
      /COPY WNCPYSRC,LELERIV020
 
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   IF        WCNS2 <> '*'                                               CRE073
                                                                                              CRE073
      ** Validate New Contractual Spread/Sign                                                 CRE073
                                                                                              CRE073
     C                   EXSR      SRNCNSP                                                    CRE073
                                                                                              CRE073
      ** Validate New Rounding Method                                                         CRE073
                                                                                              CRE073
     C                   IF        DDNCNPOK <> 'N'                                            CRE073
                                                                                              CRE073
     C                   EXSR      SRNRDMT                                                    CRE073
                                                                                              CRE073
      ** Validate New Rounding Fraction/Decimal                                               CRE073
                                                                                              CRE073
     C                   EXSR      SRNRDFD                                                    CRE073
                                                                                              CRE073
      ** If all interest rate rounding related fields are valid                               CRE073
      ** compute for the new spread rate                                                      CRE073
                                                                                              CRE073
     C                   IF         DDNCNGOK <> 'N' AND                                       CRE073
     C                              DDNRDMOK <> 'N' AND                                       CRE073
     C                              DDNRFDOK <> 'N' AND                                       CRE073
     C                              DDNBRTOK <> 'N' AND                                       CRE073
     C                              DDNbraOK <> 'N'                                           CRE073
     C                   Z-ADD     TMCNSP        L_CLCNSP                                     CRE073
     C                   MOVEL     DDCNG2B       L_CLCNSG                                     CRE073
     C                   MOVEL     DDRDM2B       L_CLRDMT                                     CRE073
     C                   MOVEL     DDRDF2B       L_CLRDFD                                     CRE073
     C                   EXSR      SRNSPRT                                                    CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ELSE                                                                 CRE073
                                                                                              CRE073
     C                   EVAL      WNRTS1 = '*'                                               CRE073
     C                   EVAL      WNSIN1 = '*'                                               CRE073
     C                   EVAL      DDNRTSB = '*'                                              CRE073
     C                   EVAL      DDNSINB = '*'                                              CRE073
     C                   EVAL      VNRTS = *ZEROS                                             CRE073
     C                   EVAL      VNSIN = *BLANKS                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
      *
      ** Validate New Spread Indicator
      *
 
      /COPY WNCPYSRC,LELERIV021
 
     C                   EXSR      SRNSIN
 
      /COPY WNCPYSRC,LELERIV022
 
      *
      ** Validate New Interest Calculation Basis
      *
 
      /COPY WNCPYSRC,LELERIV023
 
     C                   EXSR      SRNCAS
 
      /COPY WNCPYSRC,LELERIV024
 
      *
      ** Validate New Change Indicator
      *
 
      /COPY WNCPYSRC,LELERIV025
 
     C                   EXSR      SRNCHI
 
      /COPY WNCPYSRC,LELERIV026
 
      ** Validate Forward Yield Curve                                                         BUG827
                                                                                              BUG827
     C     @FYIELD       IFEQ      'Y'                                                        BUG827
     C                   EXSR      SRFYLD                                                     BUG827
     C                   ENDIF                                                                BUG827
      *
      *     *------------------------------------------------------*
      *     * If BLI Lending Enhancements is on, validate          *
      *     * New interest payment date and New Maturity date      *
      *     *------------------------------------------------------*
      *
     C     *IN60         IFEQ      *ON                                          Start of BLI Lend En
      *
     C                   Z-ADD     NIPD          VNIPD
     C                   Z-ADD     NMDT          VNMDT
     C                   Z-ADD     NIDT          VNIDT
      ** Before validating new interest payment date, value of new
      ** maturity date is already necessary for comparison purposes.
     C     DDNMDTB       IFNE      *BLANKS
     C     WNMDT1        ANDNE     '*'
     C     DDNMDT        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNMDT        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'A'
     C                   TESTN                   DDNMDTB              85        *on is num
     C                   MOVE      DDNMDTB       ZDATE
     C                   ELSE
     C                   TESTN                   DDNMDT               85        *on is num
     C                   MOVE      DDNMDT        ZDATE
     C                   ENDIF
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WNMDT             5 0
     C                   ENDIF
 
      /COPY WNCPYSRC,LELERIV027
 
      *
      ** Validate New Interest Payment Date
      *
 
      /COPY WNCPYSRC,LELERIV028
 
     C                   EXSR      SRNIPD
 
      /COPY WNCPYSRC,LELERIV029
 
      *
      ** Validate New Maturity Date
      *
 
      /COPY WNCPYSRC,LELERIV030
 
     C                   EXSR      SRNMDT
 
      /COPY WNCPYSRC,LELERIV031
 
      *
     C                   ENDIF                                                  End of BLI Lend Enh
 
      /COPY WNCPYSRC,LELERIV032
 
      *
      ** Validate Next Rollover Date
      *
 
      /COPY WNCPYSRC,LELERIV033
 
     C                   EXSR      SRNROD
 
      /COPY WNCPYSRC,LELERIV034
 
      ** If CLE031 is available New Principal and Discount validation                         CLE031
      ** is done after New Exchange Rate validation.                                          CLE031
                                                                                              CLE031
     C                   IF        CLE031 <> 'Y'                                              CLE031
      *
      ** Validate New Principal
      *
 
      /COPY WNCPYSRC,LELERIV035
 
     C                   EXSR      SRNPRA
 
      /COPY WNCPYSRC,LELERIV036
 
      *
      ** Validate New Discount Amount
      *
 
      /COPY WNCPYSRC,LELERIV037
 
     C                   EXSR      SRNDAM
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
 
      /COPY WNCPYSRC,LELERIV038
 
      *
      *     *------------------------------------------------------*
      *     * For Mutli - Ccy Rollovers                            *
      *     *------------------------------------------------------*
      *
      **   For multi-currency rollover.
      *
     C     *IN61         IFEQ      *ON                                          Start of Multi Ccy
      *
      **   If multi-currency rollover not allowed,
      **   entry in these fields are forbidden.
     C     MULTIC        IFEQ      *OFF
     C     DDNCCYB       IFNE      *BLANKS
     C     DDNCPAB       ORNE      *BLANKS
     C     DDNFCEB       ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNFMDB       ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNBCEB       ORNE      *BLANKS
     C     DDNBMDB       ORNE      *BLANKS
     C     DDNLRAB       ORNE      *BLANKS
      *
     C     @WERLN        IFEQ      'Y'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDNDAMB'                                239717
     C                   EVAL      MsgIDArr(Idx) = 'LEV1047'
     C**********         MOVEL     @WLNNO        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(@WLNNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@WLNNO)                   MD000091
     C**********         MOVE      'N'           DDNdamOK                                     239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCCYB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
      *                                                                                       239717
     C                   MOVE      'N'           MULTERR           1                          239717
      *                                                                                       239717
     C     DDNCCYB       IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'                                239717
     C                   MOVE      'N'           DDNccyOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
      *                                                                                       239717
     C     DDNCPAB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCPAB'                                239717
     C                   MOVE      'N'           DDNcpaOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
      *                                                                                       239717
     C     DDNFCEB       IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                                239717
     C                   MOVE      'N'           DDNfceOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
     C     DDNFMDB       IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFMDB'                                239717
     C                   MOVE      'N'           DDNfmdOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
     C     DDNLRAB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNLRAB'                                239717
     C                   MOVE      'N'           DDNlraOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
     C     DDNBCEB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBCEB'                                239717
     C                   MOVE      'N'           DDNbceOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1047'                                  WA0025
     C***********        MOVEL     @WLNNO        MsgDtaArr(Idx)                               WA0025
     C     DDNBMDB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBMDB'                                239717
     C                   MOVE      'N'           DDNbmdOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C                   ELSE
      *
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDNDAMB'                                239717
     C                   EVAL      MsgIDArr(Idx) = 'LEV1033'
     C**********         MOVE      'N'           DDNdamOK                                     239717
     C                   MOVE      'N'           MULTERR           1                          239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCCYB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
     C     DDNCCYB       IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'                                239717
     C                   MOVE      'N'           DDNccyOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
      *                                                                                       239717
     C     DDNCPAB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCPAB'                                239717
     C                   MOVE      'N'           DDNcpaOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
      *                                                                                       239717
     C     DDNFCEB       IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                                239717
     C                   MOVE      'N'           DDNfceOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
     C     DDNFMDB       IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFMDB'                                239717
     C                   MOVE      'N'           DDNfmdOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
     C     DDNLRAB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNLRAB'                                239717
     C                   MOVE      'N'           DDNlraOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
     C     DDNBCEB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBCEB'                                239717
     C                   MOVE      'N'           DDNbceOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1033'                                  WA0025
     C     DDNBMDB       IFNE      *BLANKS                                                    239717
     C     MULTERR       ANDNE     'Y'                                                        239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBMDB'                                239717
     C                   MOVE      'N'           DDNbmdOK
     C                   MOVE      'Y'           MULTERR                                      239717
     C                   ENDIF                                                                239717
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDNCCY        IFNE      *BLANKS
     C     DDNCPA        ORNE      *BLANKS
     C     DDNFCE        ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNFMD        ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNBCE        ORNE      *BLANKS
     C     DDNBMD        ORNE      *BLANKS
     C     DDNLRA        ORNE      *BLANKS
      *
     C     @WERLN        IFEQ      'Y'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDNDAMB'                                239717
     C                   EVAL      MsgIDArr(Idx) = 'LEV1047'
     C**********         MOVEL     @WLNNO        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(@WLNNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@WLNNO)                   MD000091
     C**********         MOVE      'N'           DDNdamOK                                     239717
     C                   ELSE
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDNDAMB'                                239717
     C                   EVAL      MsgIDArr(Idx) = 'LEV1033'
     C**********         MOVE      'N'           DDNdamOK                                     239717
     C                   ENDIF
     C     DDNCCY        IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCCY'                                 239717
     C                   MOVE      'N'           DDNccyOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNCPA        IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNCPA'                                 239717
     C                   MOVE      'N'           DDNcpaOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNFCE        IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFCE'                                 239717
     C                   MOVE      'N'           DDNfceOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNFMD        IFNE      *BLANKS                                                    239717
     C     *IN67         ANDEQ     *OFF                                                       239717
     C                   EVAL      FldNameArr(Idx) = 'DDNFMD'                                 239717
     C                   MOVE      'N'           DDNfmdOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNBCE        IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBCE'                                 239717
     C                   MOVE      'N'           DDNbceOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNBMD        IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNBMD'                                 239717
     C                   MOVE      'N'           DDNbmdOK                                     239717
     C                   ELSE                                                                 239717
     C     DDNLRA        IFNE      *BLANKS                                                    239717
     C                   EVAL      FldNameArr(Idx) = 'DDNLRA'                                 239717
     C                   MOVE      'N'           DDNlraOK                                     239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
     C                   ENDIF                                                                239717
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      /COPY WNCPYSRC,LELERIV039
 
      *
      ** Validate New Currency
      *
 
      /COPY WNCPYSRC,LELERIV040
 
     C                   EXSR      SRNCCY
 
      /COPY WNCPYSRC,LELERIV041
 
      *
      ** Validate New Currency Amount
      *
 
      /COPY WNCPYSRC,LELERIV042
 
     C                   EXSR      SRNCPA
     C                   ENDIF                                                               BUG2579
 
      /COPY WNCPYSRC,LELERIV043
 
      *
      ** Validate Exchange rate
      *
 
      /COPY WNCPYSRC,LELERIV044
 
     C                   EXSR      SRNFCE
 
      /COPY WNCPYSRC,LELERIV045
 
      *
      ** Validate Exchange rate Indicator
      *
 
      /COPY WNCPYSRC,LELERIV046
 
     C                   EXSR      SRNFMD
 
      ** Validate FX Rate Change Only Indicator                                             MD028338
                                                                                            MD028338
     C                   EXSR      SRFRCO                                                   MD028338
                                                                                            MD028338
     C                   IF        CLE031 = 'Y'                                               CLE031
                                                                                              CLE031
      ** Validate New Principal                                                               CLE031
                                                                                              CLE031
     C                   EXSR      SRNPRA                                                     CLE031
                                                                                              CLE031
      ** Validate New Discount Amount                                                         CLE031
                                                                                              CLE031
     C                   EXSR      SRNDAM                                                     CLE031
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C     *IN61         IFEQ      *ON                                                       BUG2579
 
      /COPY WNCPYSRC,LELERIV047
 
      *
      ** Validate Base Ccy Exchange rate
      *
 
      /COPY WNCPYSRC,LELERIV048
 
     C                   EXSR      SRNBCE
 
      /COPY WNCPYSRC,LELERIV049
 
      *
      ** Validate Base Ccy Exchange rate Indicator
      *
 
      /COPY WNCPYSRC,LELERIV050
 
     C                   EXSR      SRNBMD
 
      /COPY WNCPYSRC,LELERIV051
 
      *
      ** Validate Next Loan Ccy Repayment Amount
      *
 
      /COPY WNCPYSRC,LELERIV052
 
     C                   EXSR      SRNLRA
 
      /COPY WNCPYSRC,LELERIV053
 
      *
     C                   ENDIF                                                  End of Multi Ccy
      *
      /COPY WNCPYSRC,LELERIV054
      *
      *
      ** Validate Funding Spread Sign
      *
 
      /COPY WNCPYSRC,LELERIV055
 
     C                   EXSR      SRNFSN
 
      /COPY WNCPYSRC,LELERIV056
 
      *
      ** Validate Funding Spread Rate
      *
 
      /COPY WNCPYSRC,LELERIV057
 
     C                   EXSR      SRNFRS
 
      /COPY WNCPYSRC,LELERIV058
 
      *
      *  *------------------------------------------------------*
      *  *  Check if warning messages                           *
      *  *------------------------------------------------------*
      *
     C                   EXSR      SRWDET
 
      /COPY WNCPYSRC,LELERIV059
 
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELERIV060
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
 
      ** If called from CTU and action is Authorise, need to perform
      ** update for Amend and Authorisation
 
     C     @@CTU         IFEQ      'Y'
     C     DDACTN        ANDEQ     'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   EXSR      SRUAMD
     C                   EXSR      SRUAUT
     C                   ELSE
     C     DDACTN        CASEQ     'A'           SRUAMD
     C     DDACTN        CASEQ     'X'           SRUAUT
     C     DDACTN        CASEQ     'Q'           SRUAUT                                       CLE030
     C                   ENDCS
     C                   ENDIF
 
      /COPY WNCPYSRC,LELERIV061
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUAMD  -  Update files for Amend action.                     *
      *                                                               *
      *****************************************************************
     C     SRUAMD        BEGSR
      *
      * Update work field with last change type
      *
     C                   MOVEL     'A'           VCHTP
      *
      * Update fields from CLOANCL - Valid file
      *
     C     WRLDT1        IFEQ      '*'
     C     VRLDT         ORNE      *ZEROS
     C                   Z-ADD     VRLDT         L_CLRLDT
     C                   ENDIF
      *
     C     WNROD1        IFEQ      '*'
     C     VNROD         ORNE      *ZEROS
     C                   Z-ADD     VNROD         L_CLNROD
     C                   ENDIF
      *
     C     WRLFQ1        IFEQ      '*'
     C     VRLFQ         ORNE      *BLANK
     C                   MOVEL     VRLFQ         L_CLRLFQ
     C                   ENDIF
      *
     C     WRLDY1        IFEQ      '*'
     C     VRLDY         ORNE      *ZEROS
     C                   Z-ADD     VRLDY         L_CLRLDY
     C                   ENDIF
      *
     C     WNBRA1        IFEQ      '*'
     C     VNBRA         ORNE      *ZERO
     C     VNBRA         OREQ      *ZERO                                                      248162
     C     DDACTN        ANDEQ     'A'                                                        248162
     C     @@CTU         ANDNE     'Y'                                                        248162
     C                   Z-ADD     VNBRA         L_CLNBRA
     C                   ENDIF
      *
     C     WNRTS1        IFEQ      '*'
     C     VNRTS         ORNE      *ZERO
     C     VNRTS         OREQ      *ZERO                                                      248162
     C     DDACTN        ANDEQ     'A'                                                        248162
     C     @@CTU         ANDNE     'Y'                                                        248162
     C                   Z-ADD     VNRTS         L_CLNRTS
     C                   ENDIF
                                                                                             BUG9655
     C                   IF        CLE036 = 'Y'                                              BUG9655
      *                                                                                       CLE035
     C     WNRTF1        IFEQ      '*'                                                        CLE035
     C     VNRTF         ORNE      *ZERO                                                      CLE035
     C                   Z-ADD     VNRTF         L_CLNRTS                                     CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE035
     C     WNBRT1        IFEQ      '*'                                                        CLE035
     C     VNBRT         ORNE      *ZERO                                                      CLE035
     C                   Z-ADD     VNBRT         L_CLNBSR                                     CLE035
     C                   ENDIF                                                                CLE035
                                                                                             BUG9655
     C                   ENDIF                                                               BUG9655
      *
     C     WNSIN1        IFEQ      '*'
     C     VNSIN         ORNE      *BLANK
     C     VNCAS         ANDNE     *ZERO
     C     VNSIN         OREQ      *BLANK                                                     248162
     C     DDACTN        ANDEQ     'A'                                                        248162
     C     @@CTU         ANDNE     'Y'                                                        248162
     C     VNCAS         ANDNE     *ZERO                                                      248162
     C                   MOVEL     VNSIN         L_CLNSIN
     C                   ENDIF
      *
     C     WNCHI1        IFEQ      '*'
     C     VNCHI         ORNE      *BLANK
     C     VNCAS         ANDNE     *ZERO
     C                   MOVEL     VNCHI         L_CLNCHI
     C                   ENDIF
      *
     C     WNCAS1        IFEQ      '*'
     C     VNCAS         ORNE      *ZERO
     C                   Z-ADD     VNCAS         L_CLNCAS
     C                   ENDIF
      *
     C     VNIDT         IFNE      *ZEROS
     C                   Z-ADD     VNIDT         L_CLNIDT
     C                   ENDIF
      *
      ** Overwrite Interest date with rollover date if interest
      ** frequency is 'R'
      *
     C     CLE005        IFEQ      'Y'
     C     IPFR          ANDEQ     'R'
     C                   SELECT
     C     RLDT          WHENNE    *ZEROS
     C                   Z-ADD     RLDT          L_CLNIDT
     C                   Z-ADD     RLDT          L_CLIBDT
     C     NROD          WHENNE    *ZEROS
     C                   Z-ADD     NROD          L_CLNIDT
     C                   Z-ADD     NROD          L_CLIBDT
     C                   ENDSL
     C                   ENDIF
      *
     C     *IN60         IFEQ      *ON
      *
     C     WNIPD1        IFEQ      '*'
     C     VNIPD         ORNE      *ZEROS
     C                   Z-ADD     VNIPD         L_CLNIPD
     C                   ENDIF
      *
     C     WNMDT1        IFEQ      '*'
     C     VNMDT         ORNE      *ZEROS
     C                   Z-ADD     VNMDT         L_CLNMDT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN62         IFEQ      *ON
      *
     C     VNFRS         IFNE      *ZEROS
     C     VNFRS         ANDNE     NFRS
     C                   Z-ADD     VNFRS         L_CLNFRS
     C                   ENDIF
      *
     C     VNFSN         IFNE      NFSN
     C                   MOVE      VNFSN         L_CLNFSN
     C                   ENDIF
     C                   MOVE      DDNFPCB       L_CLNFPC
     C                   ENDIF
      *
     C                   Z-ADD     VTNLU         L_CLTNLU
     C                   Z-ADD     VLCD          L_CLLCD
     C                   MOVEL     VCHTP         L_CLCHTP
      *
     C                   MOVE      *BLANKS       L_CLPCOB
      *
     C     DDACTN        IFEQ      'I'
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BRCA          PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   Z-ADD     150           DBASE                          * DBERR 58 *
     C                   MOVEL     PBRCA         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     A8MQSM        W#1ST3            3
     C                   MOVEL(P)  W#1ST3        L_CLPCRF
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE106
      ** If Syndications Manager is available, PC Reference must be retained                  CLE106
      ** set field to the value read from CLOANCL                                             CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      L_CLPCRF = PCRF                                            CLE106
     C                   ENDIF                                                                CLE106
      *
     C     PTYP          IFEQ      61
     C     MDAT          ANDEQ     0
     C     PTYP          OREQ      68
     C     MDAT          ANDEQ     0
     C     PTYP          OREQ      69
     C     MDAT          ANDEQ     0
     C**********         Z-ADD     NMDT          L_CLMDAT                                     246575
     C                   Z-ADD     L_CLNMDT      L_CLMDAT                                     246575
     C                   Z-ADD     0             L_CLNMDT
     C                   ENDIF
      *
      **  Update fields from CLOANCK - Valid file
      *
     C     VNPRAM        IFNE      *ZEROS
     C     WNPRA1        OREQ      '*'
     C                   Z-ADD     VNPRAM        K_CLNPRA
     C                   ENDIF
      *
     C     VNDAM         IFNE      *ZEROS
     C     WNDAM1        OREQ      '*'
     C                   Z-ADD     VNDAM         K_CLNDAM
     C                   ENDIF
      *
     C     DDSPI1        IFNE      *BLANKS
     C     DDSPI1        ORNE      SPI1
     C                   MOVEL     DDSPI1        K_CLSPI1
     C                   ENDIF
     C     DDSPI2        IFNE      *BLANKS
     C     DDSPI2        ORNE      SPI2
     C                   MOVEL     DDSPI2        K_CLSPI2
     C                   ENDIF
     C     DDSPI3        IFNE      *BLANKS
     C     DDSPI3        ORNE      SPI3
     C                   MOVEL     DDSPI3        K_CLSPI3
     C                   ENDIF
      *
     C     VNCCY         IFNE      *BLANKS
     C     WNCCY1        OREQ      '*'
     C                   MOVEL     VNCCY         K_CLNCCY
     C     VNCPA         IFNE      *ZEROS
     C     WNCPA1        OREQ      '*'
     C                   Z-ADD     VNCPA         K_CLNCPA
     C                   ENDIF
     C     VNFCE         IFNE      *ZEROS
     C     WNFCE1        OREQ      '*'
     C                   Z-ADD     VNFCE         K_CLNFCE
     C                   ENDIF
     C     VNFMD         IFNE      *BLANK
     C     WNFCE1        OREQ      '*'
     C                   MOVEL     VNFMD         K_CLNFMD
     C                   ENDIF
     C     VNBCE         IFNE      *ZEROS
     C     WNBCE1        OREQ      '*'
     C                   Z-ADD     VNBCE         K_CLNBCE
     C                   ENDIF
     C     VNBMD         IFNE      *BLANK
     C     WNBMD1        OREQ      '*'
     C                   MOVEL     VNBMD         K_CLNBMD
     C                   ENDIF
     C     VNLRA         IFNE      *ZEROS
     C     WNLRA1        OREQ      '*'
     C                   Z-ADD     VNLRA         K_CLNLRA
     C                   ENDIF
     C                   ELSE                                                                BUG2579
                                                                                             BUG2579
      ** Move values to file fields of new facility ccy exchange rate                        BUG2579
      ** and indicator even if new currency details were not entered                         BUG2579
      ** provided that CLE023 is installed and facility is multi-ccy                         BUG2579
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     VNFCE         IFNE      *ZEROS                                                    BUG2579
     C     WNFCE1        OREQ      '*'                                                       BUG2579
     C                   Z-ADD     VNFCE         K_CLNFCE                                    BUG2579
     C                   ENDIF                                                               BUG2579
     C     VNFMD         IFNE      *BLANK                                                    BUG2579
     C     WNFCE1        OREQ      '*'                                                       BUG2579
     C                   MOVEL     VNFMD         K_CLNFMD                                    BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
      *                                                                                      BUG2579
     C                   ENDIF
                                                                                            MD028338
      ** Reuse filler to serve as FX Rate Change Only Indicator                             MD028338
                                                                                            MD028338
     C     VFRCO         IFEQ      'Y'                                                      MD028338
     C                   MOVEL     VFRCO         K_CLZZ04                                   MD028338
     C                   ELSE                                                               MD028338
     C                   MOVE      *BLANKS       K_CLZZ04                                   MD028338
     C                   ENDIF                                                              MD028338
                                                                                              BUG827
     C     VNFYLD        IFNE      *BLANK                                                     BUG827
     C     WNFYLD        OREQ      '*'                                                        BUG827
     C                   MOVEL     VNFYLD        K_CLFYLB                                     BUG827
     C                   ENDIF                                                                BUG827
      *
      **  Set Rollover Insert & Amend User to current user.
     C     RSTS          IFEQ      *BLANK
     C                   MOVEL(P)  PSUSER        K_CLRIUS
     C                   ENDIF
      *
     C                   MOVEL(P)  PSUSER        K_CLRAUS
      *
      **  Set Rollover Authorising User to blanks.
     C                   MOVE      *BLANKS       K_CLRXUS
      *
      ** Set Rollover Status to 'R' if previous status was 'A' or 'R'
      **  else, set Rollover status to 'C'
     C     RSTS          IFEQ      'A'
     C     RSTS          OREQ      'R'
     C                   MOVE      'R'           K_CLRSTS
     C                   ELSE
     C                   MOVE      'C'           K_CLRSTS
     C                   ENDIF
      *
     C                   Z-ADD     VTNLU         K_CLTNLU
     C                   Z-ADD     VLCD          K_CLLCD
     C                   MOVEL     VCHTP         K_CLCHTP
     C     VRPCR         IFNE      *BLANKS
     C                   MOVEL     VRPCR         K_CLRPCR
     C                   ENDIF
      *
      **  Set ECIN to 'Y' if CEU020 is installed and the rollover of
      **  the currency is from an 'In' currency to the Euro currency
      *
     C     CEU020        IFEQ      'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     VNCCY         IFEQ      BKEURO
     C     WINCY         ANDEQ     'Y'
     C                   MOVE      'Y'           K_CLECIN
     C                   ELSE
     C                   MOVE      'N'           K_CLECIN
     C                   ENDIF
     C                   ELSE
     C     CEU020        IFEQ      'Y'
     C     WNCCY1        ANDEQ     '*'
     C     CEU020        OREQ      'Y'
     C     DDNCCY        ANDEQ     *BLANK
     C                   MOVE      'N'           K_CLECIN
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE034
     C                   MOVE      DDRSTA        K_CLRSTA                                     CLE034
                                                                                              CLE034
      *
      **  If LE Autorisation feature is switched off
      **  or not required, do automatic authorisation.
     C     BPROAU        IFNE      'Y'
     C                   EXSR      SRUAUT
     C                   ENDIF
      *
 
      /COPY WNCPYSRC,LELERIV062
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUAUT  -  Update files for Authorise action.                 *
      *                                                               *
      *****************************************************************
     C     SRUAUT        BEGSR
      *
      **  Update fields for CLOANCK
      *
 
      *                                                                                       CLE030
      **  If release authorisation feature is on set K_CLRSTS to                              CLE030
      **  the work warning fiels.                                                             CLE030
     C     CLE030        IFEQ      'Y'                                                        CLE030
     C     W_CLRSTS      ANDNE     *BLANKS                                                    CLE030
     C**********         MOVE      W_CLRSTS      K_CLRSTS                            CLE030 BUG12985
     C                   MOVE      W_CLRSTS      RSTS                                       BUG12985
     C                   ELSE                                                                 CLE030
      *
      **  Set Rollover Status to 'A'.
     C**********         MOVE      'A'           K_CLRSTS                                   BUG12985
     C                   MOVE      'A'           RSTS                                       BUG12985
     C                   ENDIF                                                                CLE030
      *
      **  Set Rollover Authorising User to current user.
     C                   MOVEL(P)  PSUSER        K_CLRXUS
      *
     C                   Z-ADD     VTNLU         K_CLTNLU
     C                   Z-ADD     VLCD          K_CLLCD
     C                   MOVEL     VCHTP         K_CLCHTP
      *
 
      /COPY WNCPYSRC,LELERIV063
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Validate Customer                                    *
      *                                                               *
      *****************************************************************
 
     C     SRCUST        BEGSR
      *
      **  Must not be blank.
     C                   SELECT
     C     DDCUST        WHENEQ    *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0035'
     C                   MOVE      'N'           DDCustOK
      *
      **  Must exist in the master file.
     C     DDCUST        WHENNE    *BLANKS
     C                   MOVEL     DDCUST        PCUST
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM                    PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST            10
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   MOVEL(P)  PCUST         DDCUST
     C     PRTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0035'
     C                   MOVE      'N'           DDCustOK
     C     PRTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDCUST
     C                   ENDIF
      *
      **  Must be same as the loan customer.
     C                   ELSE
     C**********         MOVEL     BBCUST        WCUST             6 0                        CSD027
     C                   MOVEL     BBCUST        WCUST             6                          CSD027
      *
     C                   MOVE      'N'           WPPFL             1
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     PTYP          OREQ      71
     C                   MOVE      'Y'           WPPFL
     C                   ENDIF
      *
     C     WCUST         IFNE      CNUM
     C     WPPFL         ANDNE     'Y'
      *
      ** For Parts Purchased, must be the same as the original borrower
      *
     C     WCUST         ORNE      OLNO
     C     WPPFL         ANDEQ     'Y'
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0104'
     C                   MOVE      'N'           DDCustOK
      *
     C                   ELSE
     C                   MOVEL     BBCUST        DDCUST
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRLDT - Validate Rollover Date                               *
      *                                                               *
      *****************************************************************
 
     C     SRRLDT        BEGSR
      *
     C     WRLDT1        IFNE      '*'
     C     DDACTN        IFEQ      'A'
     C                   TESTN                   DDRLDTB              85        *on means numeric
     C                   MOVE      DDRLDTB       ZDATE
     C                   ELSE
     C                   TESTN                   DDRLDT               85        *on means numer
     C                   MOVE      DDRLDT        ZDATE
     C                   ENDIF
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WRLDT             5 0
      *
      **  Mandatory for Discount loans.
      *
     C                   SELECT
     C     DDRLDTB       WHENEQ    *BLANKS
     C     PTYP          ANDEQ     63
     C     DDACTN        ANDEQ     'A'
     C     DDRLDTB       OREQ      *BLANKS
     C     PTYP          ANDEQ     65
     C     DDACTN        ANDEQ     'A'
     C     DDRLDTB       OREQ      *BLANKS
     C     PTYP          ANDEQ     67
     C     DDACTN        ANDEQ     'A'
      *
     C     DDRLDT        OREQ      *BLANKS
     C     PTYP          ANDEQ     63
     C     DDACTN        ANDEQ     'X'
     C     DDRSTS        ANDNE     W_ReAutho                                                 BUG6926
     C     DDRLDT        OREQ      *BLANKS
     C     PTYP          ANDEQ     65
     C     DDACTN        ANDEQ     'X'
     C     DDRLDT        OREQ      *BLANKS
     C     PTYP          ANDEQ     67
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     PTYP          ANDEQ     63                                                         CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     PTYP          ANDEQ     65                                                         CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     PTYP          ANDEQ     67                                                         CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0464'
     C                   MOVE      'N'           DDRldtOK
      *
      **  If rollover date is blank, frequency code and day number
      **  must be both blank.
      *
     C     DDRLDTB       WHENEQ    *BLANKS
     C     DDRLFQB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDRLDTB       OREQ      *BLANKS
     C     DDRLDYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
      *
     C     DDRLDT        OREQ      *BLANKS
     C     DDRLFQ        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRLDT        OREQ      *BLANKS
     C     DDRLDY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     DDRLFQ        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     DDRLDY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0285'
     C                   MOVE      'N'           DDRldtOK
      *
      ** Mandatory for multi-ccy rollover
      *
     C     DDRLDTB       WHENEQ    *BLANKS
     C     DDRLDT        ANDEQ     *BLANKS
     C     MULTIC        ANDEQ     *ON
     C     DDNCCYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
      *
     C     DDRLDT        OREQ      *BLANKS
     C     MULTIC        ANDEQ     *ON
     C     DDNCCY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     MULTIC        ANDEQ     *ON                                                        CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1044'
     C                   MOVE      'N'           DDRldtOK
      *
      **  Must be numeric.
      *
     C     DDRLDTB       WHENNE    *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'A'
     C     DDRLDT        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDRLDT        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0151'
     C                   MOVE      'N'           DDRldtOK
      *
      **  Must be in valid format.
      *
     C     DDRLDTB       WHENNE    *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDRLDT        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRLDT        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     Errorflag     IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0151'
     C                   MOVE      'N'           DDRldtOK
     C                   ELSE
      *
      **  Must be same as Maturity date for Discount loans.
      *
     C                   SELECT
     C     PTYP          WHENEQ    63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C     WRLDT         IFNE      MDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0464'
     C                   MOVE      'N'           DDRldtOK
     C                   ENDIF
      *
      **  Must be greater than value date and
      **  less than maturity date if S01465 is *OFF, or
      **  less than or equal to maturity date if S01465 is *ON.
      ****less*than*or*equal*to*facility*expiry*date*for*a*call*loan***                       CAP084
      ****with*no*maturity*date****************************************                       CAP084
      *
     C     WRLDT         WHENLE    VDAT
     C     CLE003        ANDEQ     'N'
     C     WRLDT         ORLT      VDAT
     C     CLE003        ANDEQ     'Y'
     C     WRLDT         ORGE      MDAT
     C     *IN60         ANDEQ     *OFF
     C     MDAT          ANDNE     0
     C     WRLDT         ORGT      MDAT
     C     *IN60         ANDEQ     *ON
     C     MDAT          ANDNE     0
                                                                                              CAP084
     C                   ADD       1             Idx                                          CAP084
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'                                CAP084
     C                   EVAL      MsgIDArr(Idx) = 'LEV0174'                                  CAP084
     C                   MOVE      'N'           DDRldtOK                                     CAP084
                                                                                              CAP084
      ** less than or equal to facility expiry date for a call loan                           CAP084
      ** with no maturity date                                                                CAP084
                                                                                              CAP084
     C*****WRLDT         ORGT      F_DTEX                                                     CAP084
     C     WRLDT         WHENGT    F_DTEX                                                     CAP084
     C     PTYP          ANDEQ     61
     C     MDAT          ANDEQ     0
      *
     C     WRLDT         ORGT      F_DTEX
     C     PTYP          ANDEQ     68
     C     MDAT          ANDEQ     0
      *
     C     WRLDT         ORGT      F_DTEX
     C     PTYP          ANDEQ     69
     C     MDAT          ANDEQ     0
      *
     C*******************ADD       1             Idx                                          CLE030
     C*******************EVAL      FldNameArr(Idx) = 'DDRLDTB'                                CLE030
     C*******************EVAL      MsgIDArr(Idx) = 'LEV0152'                                  CLE030
     C*******************MOVE      'N'           DDRldtOK                                     CLE030
     C                   ADD       1             WIdx                                         CLE030
     C                   EVAL      WFldNamArr(WIdx) = 'DDRLDTB'                               CLE030
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0168'                                CLE030
     C**********         MOVE      'N'           DDRldtOK                             CLE030 BUG4493
     C                   MOVE      'W'           DDRldtOK                                    BUG4493
     C                   MOVE      'Q'           W_CLRSTS                                     CLE030
      *
      **  Must be greater than or equal to run date if original entry date
      **  is less than run date.
     C     ORED          WHENLT    WRNDAY
     C     WRLDT         ANDLT     WRNDAY
     C     CLE003        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0275'
     C                   MOVE      'N'           DDRldtOK
      *
      **  Amended rollover date must be greater than or equal to
      **  run date if initial rollover date is less than run date.
     C     RLDT          WHENLT    WRNDAY
     C     WRLDT         ANDLT     WRNDAY
     C     CLE003        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0275'
     C                   MOVE      'N'           DDRldtOK
      *
      **  If rollover frequency code not entered, check that
      **  rollover date falls in the number of months specified
      **  for irregular rollovers on the facility to which the
      **  loan is linked.
      *
     C*****WIN89         IFEQ      0                                                        BUG21949
     C**********         Z-ADD     H_VDAT        ZINDT             5 0                      BUG21949
     C**********         ELSE                                                               BUG21949
     C**********         Z-ADD     VDAT          ZINDT                                      BUG21949
     C**********         ENDIF                                                              BUG21949
      *
     C     DDRLFQB       WHENEQ    *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDRLFQ        OREQ      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRLFQ        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C*****'Z'**         SCAN      F_RTPS                                                   BUG21949
     C     'Z'           SCAN      F_RTPS                                 85                BUG21949
     C     *IN85         IFEQ      *ON
     C     WIN89         IFEQ      0                                                        BUG21949
     C                   Z-ADD     H_VDAT        ZINDT             5 0                      BUG21949
     C                   ELSE                                                               BUG21949
     C                   Z-ADD     VDAT          ZINDT                                      BUG21949
     C                   ENDIF                                                              BUG21949
     C                   Z-ADD     *ZEROS        ZNYR              2 0
     C                   Z-ADD     F_RLPD        ZNMN              2 0
     C                   Z-ADD     *ZEROS        ZNDY              2 0
     C     F_RLPD        IFNE      0
     C                   EXSR      ZCPD
     C                   ENDIF
     C     WRLDT         IFGT      ZPDNO
     C     F_RLPD        ANDNE     0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1039'
     C                   MOVE      'N'           DDRldtOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
      *
      **  If Next Rollover Date on file is not to be amended,
      **  amended rollover date should be earlier.
      *
     C     DDNRODB       WHENEQ    *BLANKS
     C     DDRLDTB       ANDNE     *BLANKS
     C     WRLDT         ANDGE     NROD
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0289'
     C                   MOVE      'N'           DDRldtOK
     C                   ENDSL
      *
      **  It the value date is less than the run date, the new
      **  Rollover date should be greater than or equal to the last
      **  Rollover date.
     C**  N.B. Last Rollover Date must be obtained from the most
     C**  recent "RO" record on HISTSHQ, if it exists. (VDAT check
     C**  is redundant since covered by existence check.)
      **
     C     CLE003        IFEQ      'Y'
     C     DDRldtOK      ANDNE     'N'
     C     DDRLDTB       ANDNE     *BLANK
     C     WIN89         IFEQ      0
     C     WRLDT         ANDLT     H_VDAT
     C     WRLDT         ORLE      LMCD                                                      BUG2579
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1040'
     C                   MOVE      'N'           DDRldtOK
     C                   Z-ADD     H_VDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C**********         MOVEL     ZADATE        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ZADATE))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZADATE)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
      * If no errors
      *
     C     DDRldtOK      IFNE      'N'
     C     DDRLDTB       IFNE      *BLANKS
     C                   Z-ADD     WRLDT         VRLDT
     C                   ENDIF
     C     DDRLDT        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRLDT        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     WRLDT         VRLDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate remove request on rollover timing details.
      *
      **  Remove values of fields as requested.
     C     WRLDT1        IFEQ      '*'
     C     WRLFQ1        ANDEQ     '*'
     C     WRLDY1        ANDEQ     '*'
      *
      ** If new ccy is not equal to blanks and rollover date is to be
      ** removed, multi-ccy details should also be removed.
      *
     C     DDNCCY        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        VRLDT
     C                   MOVE      *BLANK        VRLFQ
     C                   Z-ADD     *ZEROS        VRLDY
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     DDNFCE        ANDNE     *BLANKS                                                   BUG2579
     C     WNFCE1        IFEQ      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
                                                                                             BUG2579
     C                   ELSE                                                                BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1061'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ELSE
     C     WNCCY1        IFEQ      '*'
     C     WNCPA1        ANDEQ     '*'
     C     WNFCE1        ANDEQ     '*'
     C     WNFMD1        ANDEQ     '*'
     C     WNBCE1        ANDEQ     '*'
     C     WNBMD1        ANDEQ     '*'
     C     WNLRA1        ANDEQ     '*'
     C                   Z-ADD     *ZEROS        VRLDT
     C                   MOVE      *BLANK        VRLFQ
     C                   Z-ADD     *ZEROS        VRLDY
     C                   MOVE      *BLANKS       VNCCY
     C                   Z-ADD     *ZEROS        VNCPA
     C                   Z-ADD     *ZEROS        VNFCE
     C                   MOVE      *BLANK        VNFMD
     C                   Z-ADD     *ZEROS        VNBCE
     C                   MOVE      *BLANK        VNBMD
     C                   Z-ADD     *ZEROS        VNLRA
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1045'
     C                   MOVE      'N'           DDRldtOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLFQB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDRlfqOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLDYB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDRldyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCCYB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNccyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNcpaOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNfceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNfmdOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNlraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNbceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1045'                                  WA0025
     C                   MOVE      'N'           DDNbmdOK
     C                   ENDIF
     C                   ENDIF
      *
      **  If a '*' is in the first position of Rollover date, then
      **  Rollover frequency code and day number should also
      **  have '*'s in its first positions.
      *
     C                   ELSE
     C     WRLDT1        IFNE      '*'
     C     WRLFQ1        ANDNE     '*'
     C     WRLDY1        ANDNE     '*'
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0284'
     C                   MOVE      'N'           DDRldtOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLFQB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0284'                                  WA0025
     C                   MOVE      'N'           DDRlfqOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLDYB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0284'                                  WA0025
     C                   MOVE      'N'           DDRldyOK
     C                   ENDIF
     C                   ENDIF
      *
      ** Rollover date must not be followed by any principal increases,
      ** manual repayments or repayment schedules falling due prior to
      ** the next working day in local currency after the rollover date
      *
     C     CLE014        IFEQ      'Y'
      *
     C     MULTIC        IFEQ      *ON
     C     *IN85         ANDEQ     *ON
      *
     C                   Z-ADD     WRLDT         ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC              3
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZFWDT
      *
     C                   Z-ADD     WRLDT         AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     *OFF
     C     LNRF          ANDEQ     A_LNRF
      *
     C     A_AMTP        IFEQ      'RE'
     C     A_AMTP        OREQ      'PI'
     C     A_AMTP        OREQ      'MR'
     C     A_AMTP        OREQ      'PF'
     C     A_AMTP        OREQ      'PT'
      *
     C     A_VDAT        IFGT      WRLDT
     C     A_VDAT        ANDLT     ZDYNBR
     C     DDNCCYB       ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0027'
     C                   MOVE      'N'           DDRldtOK
     C                   LEAVE
     C                   ENDIF
      *
     C     WRLDT         IFLT      WRNDAY
     C     DDNCCYB       ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0028'
     C                   MOVE      'N'           DDRldtOK
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      LELOAML0                               85
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
                                                                                             BUG2579
      ** Validate if rollover on FCXR can be inserted or deleted if                          BUG2579
      ** CLE023 is installed and facility is multi-currency and no                           BUG2579
      ** error on validation of rollover date                                                BUG2579
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     DDRldtOK      ANDNE     'N'                                                       BUG2579
     C                   EXSR      SRVFXR                                                    BUG2579
                                                                                             BUG2579
      ** Do not allow if backvalued rollover on FCXR cannot be entered,                      BUG2579
      ** and if rollover date was changed to be earlier than rundate and                     BUG2579
      ** new facility exchange rate already exist                                            BUG2579
                                                                                             BUG2579
     C     WFCXRA        IFEQ      'N'                                                       BUG2579
     C     RLDT          ANDNE     WRLDT                                                     BUG2579
     C     RLDT          ANDNE     *ZERO                                                     BUG2579
     C     WRLDT1        ANDNE     '*'                                                       BUG2579
     C     WRLDT         ANDLT     BJRDNB                                                    BUG2579
     C     NFCE          ANDNE     *ZEROS                                                    BUG2579
     C     DDNFCEB       ANDEQ     *BLANKS                                                   BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDRLDTB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1059'                                 BUG2579
     C                   MOVE      'N'           DDRldtOK                                    BUG2579
                                                                                             BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRLFQ - Validate Rollover Frequency                          *
      *                                                               *
      *****************************************************************
 
     C     SRRLFQ        BEGSR
      *
     C     WRLFQ1        IFNE      '*'
     C     DDRldtOK      ANDNE     'N'
      *
     C     DDACTN        IFEQ      'A'
     C     DDRLFQB       LOOKUP    FTAB                                   85    *on means found
     C     *IN85         IFEQ      *ON
     C     DDRLFQB       SCAN      F_RTPS                                 85    *on means found
     C                   IF        *IN85 = *OFF                                               CLE064
     C     DDRLFQB       SCAN      F_RTS15                                85                  CLE064
     C                   ENDIF                                                                CLE064
     C                   ENDIF
     C                   ELSE
     C     DDRLFQ        LOOKUP    FTAB                                   85    *on means found
     C     *IN85         IFEQ      *ON
     C     DDRLFQ        SCAN      F_RTPS                                 85    *on means found
     C                   IF        *IN85 = *OFF                                               CLE064
     C     DDRLFQ        SCAN      F_RTS15                                85                  CLE064
     C                   ENDIF                                                                CLE064
     C                   ENDIF
     C                   ENDIF
      *
      **  Rollover frequency code is forbidden for Discount loan.
      *
     C                   SELECT
     C     PTYP          WHENEQ    63
     C     DDRLFQB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     PTYP          OREQ      65
     C     DDRLFQB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     PTYP          OREQ      67
     C     DDRLFQB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
      *
     C     PTYP          OREQ      63
     C     DDRLFQ        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     PTYP          OREQ      65
     C     DDRLFQ        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     PTYP          OREQ      67
     C     DDRLFQ        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     PTYP          OREQ      63                                                         CLE030
     C     DDRLFQ        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     PTYP          OREQ      65                                                         CLE030
     C     DDRLFQ        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     PTYP          OREQ      67                                                         CLE030
     C     DDRLFQ        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLFQB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0467'
     C                   MOVE      'N'           DDRlfqOK
      *
      **  Must be a valid frequency code.
      ****It*can*be*blank,*a*'*'*or*'M',*'Q',*'X'*or*'Y'***************                     BUG21898
      **  It can be blank, a '*' or 'M', 'T', 'Q', 'X' or 'Y'                               BUG21898
      **  unless not specified in the facility to which
      **  the loan is linked.
     C     DDRLFQB       WHENNE    *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'A'
     C     DDRLFQ        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDRLFQ        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLFQB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0055'
     C                   MOVE      'N'           DDRlfqOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDRlfqOK      IFNE      'N'
     C     DDRLFQB       IFNE      *BLANK
     C                   MOVE      DDRLFQB       VRLFQ
     C                   ENDIF
     C     DDRLFQ        IFNE      *BLANK
     C     DDACTN        ANDEQ     'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      DDRLFQ        VRLFQ
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRLDY - Validate Rollover Day Number                         *
      *                                                               *
      *****************************************************************
 
     C     SRRLDY        BEGSR
      *
     C     WRLDY1        IFNE      '*'
     C     DDRldtOK      ANDNE     'N'
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDRLDYB       WRLDY             2 0
     C                   TESTN                   DDRLDYB              85        *on means numeric
     C                   ELSE
     C                   MOVE      DDRLDY        WRLDY             2 0
     C                   TESTN                   DDRLDY               85        *on means numeric
     C                   ENDIF
      *
      **  Rollover frequency day number is forbidden for Discount loan.
      *
     C                   SELECT
     C     PTYP          WHENEQ    63
     C     DDRLDYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     PTYP          OREQ      65
     C     DDRLDYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     PTYP          OREQ      67
     C     DDRLDYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
      *
     C     PTYP          OREQ      63
     C     DDRLDY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     PTYP          OREQ      65
     C     DDRLDY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     PTYP          OREQ      67
     C     DDRLDY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     PTYP          OREQ      63                                                         CLE030
     C     DDRLDY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     PTYP          OREQ      65                                                         CLE030
     C     DDRLDY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     PTYP          OREQ      67                                                         CLE030
     C     DDRLDY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0467'
     C                   MOVE      'N'           DDRldyOK
      *
      **  Rollover frequency day number is forbidden if code is blank.
      *
     C     DDRLFQB       WHENEQ    *BLANK
     C     DDRLDYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDRLFQ        OREQ      *BLANK
     C     DDRLDY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRLFQ        OREQ      *BLANK                                                     CLE030
     C     DDRLDY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0286'
     C                   MOVE      'N'           DDRldyOK
      *
      **  Default to day no. of rollover date if frequency code is entered.
      *
     C     VRLDT         WHENNE    *ZEROS
     C     VRLFQ         ANDNE     *BLANK
     C     DDRLDYB       ANDEQ     *BLANKS
     C     DDRlfqOK      ANDNE     'N'                                                        WA0017
     C                   MOVE      *BLANKS       W1DTE8
     C                   MOVEL     DDRLDTB       W1DTE6
     C     BJDFIN        IFEQ      'D'
     C                   MOVEL     W1DTE2        DDRLDYB
     C                   ELSE
     C                   MOVEL     W3DTE4        DDRLDYB
     C                   ENDIF
     C                   MOVE      DDRLDYB       WRLDY
      *
      **  If entered, must be numeric within the range 01 to 31.
      *
     C     DDRLDYB       WHENNE    *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDRLDYB       ORNE      *BLANKS
     C     WRLDY         ANDLT     01
     C     DDRLDYB       ORNE      *BLANKS
     C     WRLDY         ANDGT     31
     C     DDRLDY        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDRLDY        ORNE      *BLANKS
     C     WRLDY         ANDLT     01
     C     DDACTN        ANDEQ     'X'
     C     DDRLDY        ORNE      *BLANKS
     C     WRLDY         ANDGT     31
     C     DDACTN        ANDEQ     'X'
     C     DDRLDY        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDRLDY        ORNE      *BLANKS                                                    CLE030
     C     WRLDY         ANDLT     01                                                         CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDRLDY        ORNE      *BLANKS                                                    CLE030
     C     WRLDY         ANDGT     31                                                         CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0279'
     C                   MOVE      'N'           DDRldyOK
      *
      **  Calculate next rollover date
      **  and it must be less than maturity date.
      *
     C     VRLDT         WHENNE    *ZEROS
     C     VRLFQ         ANDNE     *BLANK
     C     *IN85         ANDEQ     *ON
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDRLFQB       ZFREQ
     C                   ELSE
     C                   MOVE      DDRLFQ        ZFREQ
     C                   ENDIF
     C                   Z-ADD     VRLDT         ZDAYNO
     C                   Z-ADD     WRLDY         ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   EXSR      ZFREQB
     C     RetCodeIn     IFEQ      '*ERROR '
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZFREQB  '    DBFILE                         ************
     C                   Z-ADD     151           DBASE                          * DBERR 20 *
     C                   MOVEL     RetCodeIn     DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZDAYNO        IFGT      MDAT
     C     MDAT          ANDNE     0
     C     MDAT          OREQ      0
     C     ZDAYNO        ANDGT     F_DTEX
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0054'
     C                   MOVE      'N'           DDRldyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLDTB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0054'                                  WA0025
     C                   MOVE      'N'           DDRldtOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDRLFQB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0054'                                  WA0025
     C                   MOVE      'N'           DDRlfqOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
      * If no errors
      *
     C     DDRldyOK      IFNE      'N'
     C     DDRLDYB       IFNE      *BLANKS
     C                   Z-ADD     WRLDY         VRLDY
     C                   ENDIF
     C     DDRLDY        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     WRLDY         VRLDY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNBRA - Validate New Base Rate Code                          *
      *                                                               *
      *****************************************************************
 
     C     SRNBRA        BEGSR
      *
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                             AND DDCNS2B <> '*'                                         CRE073
     C                   EVAL      WNRTS1 = DDCNS2B                                           CRE073
     C                   EVAL      WNSIN1 = DDCNG2B                                           CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C     WNBRA1        IFNE      '*'
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNBRAB       WNBRA             2 0
     C                   TESTN                   DDNBRAB              85        *on means numeric
     C                   ELSE
     C                   MOVE      DDNBRA        WNBRA             2 0
     C                   TESTN                   DDNBRA               85        *on means numeric
     C                   ENDIF
      *
      **  Skip validation if field is blank and loan not currently
      **  attached to base rate.
      *
     C                   SELECT
     C     BRTT          WHENEQ    *ZEROS
     C     DDNBRAB       ANDEQ     *BLANKS
     C     DDNBRA        ANDEQ     *BLANKS
      *****************************************************************                     AR826115
      ****Base*Rate*Change*Facility*should*be**ON*in*Customer*Lending ICD.                  AR826115
      ****And*it*must*be*numeric.**************************************                     AR826115
      *****************************************************************                     AR826115
     C*****BPBRCF        WHENNE    'Y'                                                      AR826115
     C*****DDNBRAB       ORNE      *BLANKS                                                  AR826115
     C     DDNBRAB       WHENNE    *BLANKS                                                  AR826115
     C     WNBRA1        ANDNE     '?'
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'A'
     C     DDNBRA        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDNBRA        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0139'
     C                   MOVE      'N'           DDNbraOK
      *
      **  Must be a valid base rate code.
     C     DDNBRAB       WHENNE    *BLANKS
     C     DDNBRA        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNBRA        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     WNBRA1        IFEQ      '?'
     C                   MOVE      *ON           SELDON            1
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNBRAB       PBRAT
     C                   ELSE
     C                   MOVE      DDNBRA        PBRAT
     C                   ENDIF
      *
      * If multi-ccy validate against rollover currency for base
      * rate.
      *
     C     DDNCCYB       IFEQ      *BLANKS
     C     DDNCCYB       OREQ      '*'                                                        WA0026
     C                   MOVE      CCY           PCURR
     C                   MOVE      CCY           W#CCY             3
     C     DDNCCY        IFNE      *BLANKS                                                    WA0026
     C                   MOVE      DDNCCY        PCURR                                        WA0026
     C                   MOVE      DDNCCY        W#CCY                                        WA0026
     C                   ENDIF                                                                WA0026
     C                   ELSE
     C                   MOVE      DDNCCYB       PCURR
     C                   MOVE      DDNCCYB       W#CCY
     C                   ENDIF
      *
      * In case of authorisation, use SNCCY (new currency)
      *
     C     DDNCCY        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    WA0026
     C                   MOVE      DDNCCY        PCURR
     C                   MOVE      DDNCCY        W#CCY             3
     C                   END
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PCURR             3
     C                   PARM                    PBRAT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     PBRAT         DDNBRAB
     C                   ENDIF
     C     PRTCD         IFNE      *BLANKS
     C     BACYCD        ORNE      W#CCY
     C     PRTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDNBRAB
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0139'
     C                   MOVE      'N'           DDNbraOK
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     BABSRC        DDNBRAB
     C                   ENDIF
     C                   MOVEL     BABSRC        WNBRA
      *
      **  Note: These details will be used later for
      **        validation of new discount amount.
     C                   Z-ADD     WNBRA         NBRA
     C                   Z-ADD     BANBRT        BASE             11 7
     C                   Z-ADD     BANBRT        TMBSRT                                       CRE073
     C                   ENDIF
      *
      ** If new base rate is not entered, check base rate and
      ** new currency combination if new base rate or current
      ** base rate from file is not zero.
      *
     C     DDNBRAB       WHENEQ    *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDNBRA        ANDNE     *BLANKS
     C     DDNBRAB       OREQ      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     BRTT          ANDNE     *ZEROS
      *
      **  If base rate code is not entered, use the old one
      ** Use new base rate from file if not blank. Otherwise
      ** get the current base currency from file.
      *
     C                   MOVE      'N'           WFLAG             1
      *
     C     DDNBRA        IFNE      *BLANKS
     C                   MOVE      DDNBRA        PBRAT
     C                   ELSE
     C                   MOVE      BRTT          PBRAT
     C                   ENDIF
      *
      * If multi-ccy validate against rollover currency for base
      * rate.
      *
     C     DDNCCYB       IFEQ      *BLANKS
     C     DDNCCYB       OREQ      '*'                                                        WA0026
     C                   MOVE      CCY           PCURR
     C                   MOVE      CCY           W#CCY             3
     C     DDNCCY        IFNE      *BLANKS                                                    WA0026
     C                   MOVE      DDNCCY        PCURR                                        WA0026
     C                   MOVE      DDNCCY        W#CCY                                        WA0026
     C                   ENDIF                                                                WA0026
     C                   ELSE
     C                   MOVE      DDNCCYB       PCURR
     C                   MOVE      DDNCCYB       W#CCY
     C                   ENDIF
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PCURR             3
     C                   PARM                    PBRAT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BACYCD        ORNE      W#CCY
     C     PRTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDNBRAB
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0026'
     C                   MOVE      'N'           DDNccyOK
     C                   MOVE      'Y'           WFLAG
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     BABSRC        WNBRA
      *
      **  Note: These details will be used later for
      **        validation of new discount amount.
      *
     C                   Z-ADD     WNBRA         NBRA
     C                   Z-ADD     BANBRT        BASE
     C                   ENDIF
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNbraOK      IFNE      'N'
     C     DDNBRAB       IFNE      *BLANKS
     C     DDNBRA        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNBRA        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      WNBRA         VNBRA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate remove request on rollover details.
      *
      **  Remove values of fields as requested.
     C                   MOVE      *OFF          RMVINT            1
     C     WNBRA1        IFEQ      '*'
     C     WNRTS1        ANDEQ     '*'
     C     WNSIN1        ANDEQ     '*'
     C     WNCAS1        ANDEQ     '*'
     C     WNCHI1        ANDEQ     '*'
     C*****@FYIELD       ANDEQ     'N'                                                BUG827 BUG3352
      **********                                                                      BUG827 BUG3352
     C*****WNBRA1        OREQ      '*'                                                BUG827 BUG3352
     C*****WNRTS1        ANDEQ     '*'                                                BUG827 BUG3352
     C*****WNSIN1        ANDEQ     '*'                                                BUG827 BUG3352
     C*****WNCAS1        ANDEQ     '*'                                                BUG827 BUG3352
     C*****WNCHI1        ANDEQ     '*'                                                BUG827 BUG3352
     C*****WNFYLD        ANDEQ     '*'                                                BUG827 BUG3352
     C*****@FYIELD       ANDEQ     'Y'                                                BUG827 BUG3352
      **********                                                                      BUG827 BUG3352
     C                   Z-ADD     *ZEROS        VNBRA
     C                   Z-ADD     *ZEROS        VNRTS
     C                   MOVE      *BLANK        VNSIN
     C                   Z-ADD     *ZERO         VNCAS
     C                   MOVE      *BLANK        VNCHI
     C                   MOVE      *ON           RMVINT
      **********                                                                      BUG827 BUG3352
     C*****@FYIELD       IFEQ      'Y'                                                BUG827 BUG3352
     C**********         MOVE      *BLANKS       VNFYLD                               BUG827 BUG3352
     C**********         ENDIF                                                        BUG827 BUG3352
      *
      **  If a '*' is in the first position of New base rate code, then
      **  New spread/rate, New spread indicator, New interest calculation
      **  basis and New change indicator must have '*' in its first
      **  positions.
      ****New*Forward*Yield*Curve*must*also*be*deleted*****************               BUG827 BUG3352
     C                   ELSE
     C     WNBRA1        IFNE      '*'
     C     WNRTS1        ANDNE     '*'
     C     WNSIN1        ANDNE     '*'
     C     WNCAS1        ANDNE     '*'
     C     WNCHI1        ANDNE     '*'
     C*****@FYIELD       ANDEQ     'N'                                                BUG827 BUG3352
      **********                                                                      BUG827 BUG3352
     C*****WNBRA1        ORNE      '*'                                                BUG827 BUG3352
     C*****WNRTS1        ANDNE     '*'                                                BUG827 BUG3352
     C*****WNSIN1        ANDNE     '*'                                                BUG827 BUG3352
     C*****WNCAS1        ANDNE     '*'                                                BUG827 BUG3352
     C*****WNCHI1        ANDNE     '*'                                                BUG827 BUG3352
     C*****WNFYLD        ANDNE     '*'                                                BUG827 BUG3352
     C*****@FYIELD       ANDEQ     'Y'                                                BUG827 BUG3352
                                                                                      BUG827 BUG3352
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0287'
     C                   MOVE      'N'           DDNbraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNRTSB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0287'                                  WA0025
     C                   MOVE      'N'           DDNrtsOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNSINB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0287'                                  WA0025
     C                   MOVE      'N'           DDNsinOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCASB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0287'                                  WA0025
     C                   MOVE      'N'           DDNcasOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCHIB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0287'                                  WA0025
     C                   MOVE      'N'           DDNchiOK
      **********                                                                      BUG827 BUG3352
     C*****@FYIELD       IFEQ      'Y'                                                BUG827 BUG3352
     C**********         MOVE      'N'           DDFYLDOK                             BUG827 BUG3352
     C**********         ENDIF                                                        BUG827 BUG3352
      **********                                                                      BUG827 BUG3352
     C                   ENDIF
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   IF        WNBRA1 <> '*'  AND                                         CRE073
     C                             WCNS2  <> '*'  AND                                         CRE073
     C                             WCNG2  <> '*'  AND                                         CRE073
     C                             WRDM2  <> '*'  AND                                         CRE073
     C                             WRDF2  <> '*'                                              CRE073
     C                   ELSE                                                                 CRE073
     C                   ADD       1             Idx                                          CRE073
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'                                CRE073
     C                   EVAL      MsgIDArr(Idx) = 'LEV0292'                                  CRE073
     C                   MOVE      'N'           DDNBRAOK                                     CRE073
     C                   MOVE      'N'           DDNCNPOK                                     CRE073
     C                   MOVE      'N'           DDNCNGOK                                     CRE073
     C                   MOVE      'N'           DDNRDMOK                                     CRE073
     C                   MOVE      'N'           DDNRFDOK                                     CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF
                                                                                             BUG3352
      **  New Forward Yield Curve must also be deleted                                       BUG3352
                                                                                             BUG3352
     C     @FYIELD       IFEQ      'Y'                                                       BUG3352
                                                                                             BUG3352
     C     WNBRA1        IFEQ      '*'                                                       BUG3352
     C     WNFYLD        ANDEQ     '*'                                                       BUG3352
     C                   MOVE      *ON           RMVINT                                      BUG3352
     C                   MOVE      *BLANKS       VNFYLD                                      BUG3352
     C                   ELSE                                                                BUG3352
                                                                                             BUG3352
      **  If a '*' is in the first position of New base rate code, then                      BUG3352
      **  New forward yield must have '*' on first position                                  BUG3352
                                                                                             BUG3352
     C     WNBRA1        IFNE      '*'                                                       BUG3352
     C     WNFYLD        ANDNE     '*'                                                       BUG3352
                                                                                             BUG3352
     C                   ELSE                                                                BUG3352
     C                   ADD       1             Idx                                         BUG3352
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                               BUG3352
     C                   EVAL      MsgIDArr(Idx) = 'LEV1058'                                 BUG3352
     C                   MOVE      'N'           DDFYLDOK                                    BUG3352
     C                   ENDIF                                                               BUG3352
     C                   ENDIF                                                               BUG3352
                                                                                             BUG3352
     C                   ENDIF                                                               BUG3352
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE035
      *  SRFBRT - Validate New Fixed and Base Rate                    *                       CLE035
      *****************************************************************                       CLE035
     C     SRFBRT        BEGSR                                                                CLE035
                                                                                              CLE035
      ** Setup fields for cross validation                                                    CLE035
                                                                                              CLE035
     C                   IF        DDACTN = 'A' OR DDACTN = 'X'                               CLE035
     C                   EVAL      WxBRA = DDNBRAB                                            CLE035
     C                   EVAL      WxBRT = DDNBRTB                                            CLE035
     C                   EVAL      WxRTS = DDNRTSB                                            CLE035
     C                   EVAL      WxRTF = DDNRTFB                                            CLE035
     C                   ELSE                                                                 CLE035
     C                   EVAL      WxBRA = DDNBRA                                             CLE035
     C                   EVAL      WxBRT = DDNBRT                                             CLE035
     C                   EVAL      WxRTS = DDNRTS                                             CLE035
     C                   EVAL      WxRTF = DDNRTF                                             CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   IF        WxRTF <> *Blanks And WNRTF1 <> '*'                         CLE035
                                                                                              CLE035
      ** No other rates can be entered if Fixed Rate is entered.                              CLE035
                                                                                              CLE035
     C                   IF        DDNBRA <> *Blanks Or DDNBRAB <> *Blanks Or                 CLE035
     C                             DDNBRT <> *Blanks Or DDNBRTB <> *Blanks Or                 CLE035
     C                             DDNRTS <> *Blanks Or DDNRTSB <> *Blanks                    CLE035
     C                   EVAL      DDNRTFOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNRTFB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0702'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2001'                                BUG11329
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      **  Validate if valid Fixed Rate is a valid amount.                                     CLE035
                                                                                              CLE035
     C                   EVAL      ZFIELD = *Blanks                                           CLE035
     C                   EVAL      ZFIELD = WxRTF                                             CLE035
     C                   EVAL      ZADEC = 7                                                  CLE035
     C                   EVAL      ZADIG = 4                                                  CLE035
     C                   EXSR      ZALIGN                                                     CLE035
                                                                                              CLE035
     C                   IF        ZALIGNok <> 'Y'                                            CLE035
     C                   EVAL      DDNRTFOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNRTFB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0138'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2002'                                BUG11329
     C                   ELSE                                                                 CLE035
     C                   MOVE      ZFIELD        VNRTS                                        CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** ... if Fixed Rate is blank, cross validate the remaining rates.                      CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
     C                   IF        WNRTF1 = '*'                                               CLE035
     C                   Z-ADD     *ZEROS        VNRTF                                        CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Validate Spread Rate                                                                 CLE035
                                                                                              CLE035
     C                   IF        CRE073 = 'N'                                               CRE073
     C                   EXSR      SRNRTS2                                                    CLE035
     C                   ENDIF                                                                CRE073
                                                                                              CLE035
     C                   IF        WxBRA <> *Blanks And WNBRA1 <> '*'                         CLE035
                                                                                              CLE035
      ** Base Rate Code is not allowed if Base Rate has been entered.                         CLE035
                                                                                              CLE035
     C                   IF        DDNBRT <> *Blanks Or DDNBRTB <> *Blanks                    CLE035
     C                   EVAL      DDNBRAOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0712'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2003'                                BUG11329
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** No other rates can be entered if Fixed Rate is entered.                              CLE035
                                                                                              CLE035
     C                   IF        DDNRTF <> *Blanks Or DDNRTFB <> *Blanks                    CLE035
     C                   EVAL      DDNBRAOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTA'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0702'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2001'                                BUG11329
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Validate Base Rate Code                                                              CLE035
                                                                                              CLE035
     C                   EXSR      SRNBRA                                                     CLE035
                                                                                              CLE035
      ** Validate Base Rate                                                                   CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
     C                   IF        WxBRT <> *Blanks And WNBRT1 <> '*'                         CLE035
     C                   IF        DDNRTF <> *Blanks Or DDNRTFB <> *Blanks                    CLE035
     C                   EVAL      DDNBRTOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0702'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2001'                                BUG11329
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   IF        DDNBRA <> *Blanks Or DDNBRAB <> *Blanks                    CLE035
     C                   EVAL      DDNBRTOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0712'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2003'                                BUG11329
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Convert to file format if no error found for Base Rate                               CLE035
                                                                                              CLE035
     C                   IF        DDNBRTOK <> 'N'                                            CLE035
     C                   EVAL      ZFIELD = *Blanks                                           CLE035
     C                   EVAL      ZFIELD = WxBRT                                             CLE035
     C                   EVAL      ZADIG = 4                                                  CLE035
     C                   EVAL      ZADEC = 7                                                  CLE035
     C                   EXSR      ZALIGN                                                     CLE035
                                                                                              CLE035
     C                   IF        ZALIGNok <> 'Y'                                            CLE035
     C                   EVAL      DDNBRTOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0713'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2004'                                BUG11329
     C                   ELSE                                                                 CLE035
     C                   MOVE      ZFIELD        VNBRT                                        CLE035
     C                   Z-ADD     VNBRT         TMBSRT                                       CRE073
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** if base rate is to be removed                                                        CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   IF        DDNBRAB = '*'                                            AR848149
     C                             AND WNBRT1 <> '*' AND WNRTS1 <> '*'                      AR848149
     C                             AND WNSIN1 <> '*' AND WNCAS1 <> '*'                      AR848149
     C                             AND WNCHI1 <> '*'                                        AR848149
     C                   EVAL      IDX = IDX + 1                                            AR848149
     C                   EVAL      FLDNAMEARR(Idx) = 'DDNBRTB'                              AR848149
     C                   EVAL      MSGIDARR(IDX) = 'LEV0291'                                AR848149
     C                   EVAL      DDNBRTOK = 'N'                                           AR848149
     C                   ELSE                                                               AR848149
     C                   SELECT                                                               CRE073
     C                   WHEN      (((WxBRT <> *BLANKS AND WNBRT1 = '*') OR                   CRE073
     C                             (WxBRT = *BLANKS AND WNBRT1 <> '*')) AND                   CRE073
     C                             WCNS2 = '*' AND WCNG2 = '*' AND                            CRE073
     C                             WRDM2 = '*' AND WRDF2 = '*' AND                            CRE073
     C                             WNCHI1 = '*')                                              CRE073
     C                   EVAL      WNRTS1 = '*'                                               CRE073
     C                   EVAL      WNSIN1 = '*'                                               CRE073
     C                   EVAL      L_CLCNSP = *ZEROS                                          CRE073
     C                   EVAL      L_CLCNSG = *BLANKS                                         CRE073
     C                   EVAL      L_CLRDMT = *BLANKS                                         CRE073
     C                   EVAL      L_CLRDFD = *BLANKS                                         CRE073
                                                                                              CRE073
     C                   WHEN      WNBRT1 <> '*' AND WCNS2 <> '*' AND                         CRE073
     C                             WCNG2  <> '*' AND WRDM2 <> '*' AND                         CRE073
     C                             WRDF2 <> '*'  AND WNCHI1 <> '*'                            CRE073
                                                                                              CRE073
     C                   OTHER                                                                CRE073
     C                   EVAL      Idx = Idx + 1                                              CRE073
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTB'                                CRE073
     C                   EVAL      MsgIDArr(Idx) = 'LEV0291'                                  CRE073
     C                   EVAL      DDNBRTOK = 'N'                                             CRE073
     C                   ENDSL                                                                CRE073
     C                   ENDIF                                                              AR848149
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   SELECT                                                               CLE035
     C                   WHEN      WxBRT <> *Blanks And WNBRT1 = '*' And                      CLE035
     C                             WNRTS1 = '*' And WNSIN1 = '*' And                          CLE035
     C                             WNCAS1 = '*' And WNCHI1 = '*'                              CLE035
     C                   EVAL      VNBRT = *Zeros                                             CLE035
     C                   EVAL      VNRTS = *Zeros                                             CLE035
     C                   EVAL      VNSIN = *Blank                                             CLE035
     C                   EVAL      VNCAS = *Zeros                                             CLE035
     C                   EVAL      VNCHI = *Blank                                             CLE035
     C                                                                                        CLE035
     C                   WHEN      WxBRT = *Blanks And WNBRT1 <> '*' And                      CLE035
     C                             WNRTS1 = '*' And WNSIN1 = '*' And                          CLE035
     C                             WNCAS1 = '*' And WNCHI1 = '*'                              CLE035
     C                   EVAL      VNRTS = *Zeros                                             CLE035
     C                   EVAL      VNSIN = *Blank                                             CLE035
     C                   EVAL      VNCAS = *Zeros                                             CLE035
     C                   EVAL      VNCHI = *Blank                                             CLE035
     C                                                                                        CLE035
     C                   WHEN      WNBRT1 <> '*' And WNRTS1 <> '*' And                        CLE035
     C                             WNSIN1 <> '*' And WNCAS1 <> '*' And                        CLE035
     C                             WNCHI1 <> '*'                                              CLE035
                                                                                              CLE035
     C                   OTHER                                                                CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNBRTB'                                CLE035
     C                   EVAL      MsgIDArr(Idx) = 'LEV0290'                                  CLE035
     C                   EVAL      DDNBRTOK = 'N'                                             CLE035
     C                   ENDSL                                                                CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDSR                                                                CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
      *****************************************************************
      *                                                               *
      * SRNRTS - Validate New Spread Rate                             *
      *                                                               *
      *****************************************************************
 
     C     SRNRTS        BEGSR
      *
     C     WNRTS1        IFNE      '*'
     C     DDNbraOK      ANDNE     'N'
     C     CRE073        ANDNE     'Y'                                                        CRE073
      *
      **  Must be in a valid rate format.
      *
     C                   SELECT
     C     DDNRTSB       WHENNE    *BLANKS
     C     DDNRTS        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNRTS        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNRTSB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNRTS        ZFIELD
     C                   ENDIF
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRTSB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0140'
     C                   MOVE      'N'           DDNrtsOK
     C                   ELSE
     C                   MOVE      ZFIELD        VNRTS
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C     DDACTN        IFEQ      'A'
     C                   MOVE      ZFIELD        DDNRTSB
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE035
      *                                                               *                       CLE035
      **SRNRTS2*-*Cross*Validate*New*Spread*Rate*for*CLE035************              CLE035 BUG10622
      * SRNRTS2 - Cross Validate New Spread Rate for CLE036           *                     BUG10622
      *                                                               *                       CLE035
      *****************************************************************                       CLE035
                                                                                              CLE035
     C     SRNRTS2       BEGSR                                                                CLE035
                                                                                              CLE035
     C                   IF        DDNRTSB <> *Blanks And WNRTS1 <> '*' And                   CLE035
     C                             DDNBRAOK <> 'N' And DDNBRTOK <> 'N'                        CLE035
                                                                                              CLE035
      ** Spread Rate must be combined with either Base Rate or Base Rate Code                 CLE035
                                                                                              CLE035
     C                   IF        DDNBRA = *Blanks And DDNBRAB = *Blanks And                 CLE035
     C                             DDNBRT = *Blanks And DDNBRTB = *Blanks                     CLE035
     C                   EVAL      DDNRTSOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNRTSB'                                CLE035
     C                   EVAL      MsgIDArr(Idx) = 'LEA0547'                                  CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Valid amount must be entered                                                         CLE035
                                                                                              CLE035
     C                   EVAL      ZFIELD = *Blanks                                           CLE035
     C                   EVAL      ZFIELD = WxRTS                                             CLE035
     C                   EVAL      ZADIG = 4                                                  CLE035
     C                   EVAL      ZADEC = 7                                                  CLE035
     C                   EXSR      ZALIGN                                                     CLE035
     C                   IF        ZALIGNok <> 'Y'                                            CLE035
     C                   EVAL      DDNRTSOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDNRTSB'                                CLE035
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0138'                         CLE035 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2002'                                BUG11329
     C                   ELSE                                                                 CLE035
     C                   MOVE      ZFIELD        VNRTS                                        CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDSR                                                                CLE035
                                                                                              CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
      *****************************************************************
      *                                                               *
      * SRNSIN - Validate New Spread Indicator                        *
      *                                                               *
      *****************************************************************
 
     C     SRNSIN        BEGSR
      *
     C     WNSIN1        IFNE      '*'
     C     DDNbraOK      ANDNE     'N'
     C     DDNBRTOK      ANDNE     'N'                                                        CLE035
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     DDNSINB       WNSIN             1
     C                   ELSE
     C                   MOVEL     DDNSIN        WNSIN
     C                   ENDIF
      *                                                                                       248162
      ** Check if the loan is a guarantee.                                                    248162
      *                                                                                       248162
     C                   MOVE      'N'           W#GUAR            1                          248162
     C     PTYP          IFEQ      70                                                         248162
     C     PTYP          OREQ      71                                                         248162
     C     PTYP          OREQ      72                                                         248162
     C                   MOVE      'Y'           W#GUAR                                       248162
     C                   ENDIF                                                                248162
      *
      **  Default spread indicator to 'A'
      **  if a valid new base rate code was entered
      **  and new spread/rate is blank or vice versa.
     C                   SELECT
     C     DDNSINB       WHENEQ    *BLANK
     C     DDNBRAB       ANDEQ     *BLANKS
     C     DDNRTSB       ANDNE     *BLANKS
     C     WNRTS1        ANDNE     '*'
     C     DDNrtsOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C*****CLE035        ANDEQ     'N'                                               CLE035 BUG10622
     C     CLE036        ANDEQ     'N'                                                      BUG10622
                                                                                              CLE035
     C     DDNSINB       OREQ      *BLANK
     C     DDNRTSB       ANDEQ     *BLANKS
     C     DDNBRAB       ANDNE     *BLANKS
     C     WNBRA1        ANDNE     '*'
     C     DDNbraOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C*****CLE035        ANDEQ     'N'                                               CLE035 BUG10622
     C     CLE036        ANDEQ     'N'                                                      BUG10622
     C                   MOVE      'A'           WNSIN
                                                                                              CLE035
      ***If*CLE035*is*available,*defaulting*of*spread*indicator*must***              CLE035 BUG10622
      ** If CLE036 is available, defaulting of spread indicator must                        BUG10622
      ** be set if Base Rate, Base Rate Code or Spread has been entered                       CLE035
                                                                                              CLE035
     C**********         WHEN      CLE035 = 'Y' And DDACTN = 'A' And                 CLE035 BUG10622
     C                   WHEN      CLE036 = 'Y' And DDACTN = 'A' And                        BUG10622
     C                             DDNSINB = *Blanks And (                                    CLE035
     C                             (DDNBRAB <> *Blanks And WNBRA1 <> '*') Or                  CLE035
     C                             (DDNBRTB <> *Blanks And WNBRT1 <> '*') Or                  CLE035
     C                             (DDNRTSB <> *Blanks And WNRTS1 <> '*' And                  CLE035
     C                             DDNRTSOK <> 'N'))                                          CLE035
     C                   EVAL      WNSIN = 'A'                                                CLE035
      *
      **  Entry is forbidden if no New base rate code
      **  and no New spread/rate;
      **  or either New base rate code or New spread/rate
      **  was not entered and entry is not 'A';
      **  or entry not 'A', 'S' or 'P'.
      *
     C     DDNBRAB       WHENEQ    *BLANKS
     C     DDNBRTB       ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTSB       ANDEQ     *BLANKS
     C     DDNSINB       ANDNE     *BLANKS
     C     W#GUAR        ANDNE     'Y'                                                        248162
     C     DDNBRAB       OREQ      *BLANKS
     C     DDNBRTB       ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTSB       ANDNE     *BLANKS
     C     DDNSINB       ANDNE     'A'
     C     WNSIN         ANDNE     'A'                                                        238523
     C     DDNBRAB       ORNE      *BLANKS
     C     DDNRTSB       ANDEQ     *BLANKS
     C     DDNSINB       ANDNE     'A'
     C     WNSIN         ANDNE     'A'                                                        238523
     C     DDNBRTB       ORNE      *BLANKS                                                    CLE035
     C     DDNRTSB       ANDEQ     *BLANKS                                                    CLE035
     C     DDNSINB       ANDNE     'A'                                                        CLE035
     C     DDNSINB       ORNE      *BLANK
     C     DDNSINB       ANDNE     'A'
     C     DDNSINB       ANDNE     'S'
     C     DDNSINB       ANDNE     'P'
      *
     C     DDNBRA        OREQ      *BLANKS
     C     DDNBRT        ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTS        ANDEQ     *BLANKS
     C     DDNSIN        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     W#GUAR        ANDNE     'Y'                                                        248162
     C     DDNBRA        OREQ      *BLANKS
     C     DDNBRT        ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTS        ANDNE     *BLANKS
     C     DDNSIN        ANDNE     'A'
     C     DDACTN        ANDEQ     'X'
     C     DDNBRA        ORNE      *BLANKS
     C     DDNRTS        ANDEQ     *BLANKS
     C     DDNSIN        ANDNE     'A'
     C     DDACTN        ANDEQ     'X'
     C     DDNBRT        ORNE      *BLANKS                                                    CLE035
     C     DDNRTS        ANDEQ     *BLANKS                                                    CLE035
     C     DDNSIN        ANDNE     'A'                                                        CLE035
     C     DDACTN        ANDEQ     'X'                                                        CLE035
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNSIN        ORNE      *BLANK
     C     DDNSIN        ANDNE     'A'
     C     DDNSIN        ANDNE     'S'
     C     DDNSIN        ANDNE     'P'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNBRA        OREQ      *BLANKS                                                    CLE030
     C     DDNBRT        ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTS        ANDEQ     *BLANKS                                                    CLE030
     C     DDNSIN        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNBRA        OREQ      *BLANKS                                                    CLE030
     C     DDNBRT        ANDEQ     *BLANKS                                                    CLE035
     C     DDNRTS        ANDNE     *BLANKS                                                    CLE030
     C     DDNSIN        ANDNE     'A'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNBRA        ORNE      *BLANKS                                                    CLE030
     C     DDNRTS        ANDEQ     *BLANKS                                                    CLE030
     C     DDNSIN        ANDNE     'A'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNBRT        ORNE      *BLANKS                                                    CLE035
     C     DDNRTS        ANDEQ     *BLANKS                                                    CLE035
     C     DDNSIN        ANDNE     'A'                                                        CLE035
     C     DDACTN        ANDEQ     'Q'                                                        CLE035
     C     CLE030        ANDEQ     'Y'                                                        CLE035
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNSIN        ORNE      *BLANK                                                     CLE030
     C     DDNSIN        ANDNE     'A'                                                        CLE030
     C     DDNSIN        ANDNE     'S'                                                        CLE030
     C     DDNSIN        ANDNE     'P'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C     DDNSINB       OREQ      *BLANKS                                                    244339
     C     DDNBRAB       ANDNE     *BLANKS                                                    244339
     C     DDNRTSB       ANDNE     *BLANKS                                                    244339
     C     DDACTN        ANDEQ     'A'                                                        244339
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNSINB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0142'
     C                   MOVE      'N'           DDNsinOK
     C                   ENDSL
      *
      ** Mandatory if New Spread/Rate has been entered
      *
     C     DDNRTSB       IFNE      *BLANKS
     C     DDNSINB       ANDEQ     *BLANK
     C     WNSIN         ANDEQ     *BLANK                                                     238523
     C*****CLE035        ANDEQ     'Y'                                             BUG10232 BUG10622
     C     CLE036        ANDEQ     'Y'                                                      BUG10622
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNSINB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0142'
     C                   MOVE      'N'           DDNsinOK
     C                   ENDIF
      *
      * If no errors
      *
     C     DDNsinOK      IFNE      'N'
     C                   MOVE      WNSIN         VNSIN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNCAS - Validate New Interest Calculation Basis              *
      *                                                               *
      *****************************************************************
 
     C     SRNCAS        BEGSR
      *
     C     WNCAS1        IFNE      '*'
     C     DDNbraOK      ANDNE     'N'
      *
     C     DDACTN        IFEQ      'A'
     C     DDNCASB       IFEQ      *BLANK
     C     DDNBRAB       ANDNE     *BLANKS
     C     DDNCASB       OREQ      *BLANK
     C     DDNRTSB       ANDNE     *BLANKS
     C     DDNCASB       ORLT      '1'
     C     DDNCASB       ANDNE     *BLANK
     C     DDNCASB       ORGT      '6'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCASB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0141'
     C                   MOVE      'N'           DDNcasOK
     C                   ELSE
     C                   MOVE      DDNCASB       VNCAS
     C                   ENDIF
      *
     C                   ELSE
     C     DDNCAS        IFEQ      *BLANK
     C     DDNBRA        ANDNE     *BLANKS
     C     DDNCAS        OREQ      *BLANK
     C     DDNRTS        ANDNE     *BLANKS
     C     DDNCAS        ORLT      '1'
     C     DDNCAS        ANDNE     *BLANK
     C     DDNCAS        ORGT      '6'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCASB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0141'
     C                   MOVE      'N'           DDNcasOK
     C                   ELSE
     C                   MOVE      DDNCAS        VNCAS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNCHI - Validate New Change Indicator                        *
      *                                                               *
      *****************************************************************
 
     C     SRNCHI        BEGSR
      *
     C     WNCHI1        IFNE      '*'
     C     DDNbraOK      ANDNE     'N'
      *
     C                   MOVEL     DDNCHIB       WNCHI             1
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVEL     DDNCHI        WNCHI
     C                   ENDIF
      *
      **  May be blank if New base rate code not entered,
      **  default to 'D'.  But for discount laon, default to 'N'.
      *
     C                   SELECT
     C     DDNCHIB       WHENEQ    *BLANK
     C     DDNBRAB       ANDEQ     *BLANKS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C                   MOVE      'N'           WNCHI
     C                   ELSE
     C                   MOVE      'D'           WNCHI
     C                   ENDIF
      *
      **  Must be 'R', 'N', or 'D' for non-discount loans
      **  if New base rate code was entered.
      *
     C     DDNCHIB       WHENNE    *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNCHIB       ANDNE     'R'
     C     DDNCHIB       ANDNE     'N'
     C     DDNCHIB       ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
      *
     C     DDNCHI        ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNCHI        ANDNE     'R'
     C     DDNCHI        ANDNE     'N'
     C     DDNCHI        ANDNE     'D'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNCHI        ORNE      *BLANK                                                     CLE030
     C     VNBRA         ANDNE     *ZEROS                                                     CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     PTYP          ANDNE     63                                                         CLE030
     C     PTYP          ANDNE     65                                                         CLE030
     C     PTYP          ANDNE     67                                                         CLE030
     C     DDNCHI        ANDNE     'R'                                                        CLE030
     C     DDNCHI        ANDNE     'N'                                                        CLE030
     C     DDNCHI        ANDNE     'D'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCHIB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0143'
     C                   MOVE      'N'           DDNchiOK
      *
      **  New base rate code not entered and not a discount loan,
      **  must be 'D'.
      *
     C     DDNBRAB       WHENEQ    *BLANKS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNCHIB       ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
      *
     C     DDNBRA        OREQ      *BLANKS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNCHI        ANDNE     'D'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNBRA        OREQ      *BLANKS                                                    CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     PTYP          ANDNE     63                                                         CLE030
     C     PTYP          ANDNE     65                                                         CLE030
     C     PTYP          ANDNE     67                                                         CLE030
     C     DDNCHI        ANDNE     'D'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCHIB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0143'
     C                   MOVE      'N'           DDNchiOK
      *
      **  Must be 'N' for discount loans
      **  if New base rate code was entered.
      *
     C     DDNCHIB       WHENNE    *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     63
     C     DDNCHIB       ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C     DDNCHIB       ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     65
     C     DDNCHIB       ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C     DDNCHIB       ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     67
     C     DDNCHIB       ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
      *
     C     DDNCHI        ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     63
     C     DDNCHI        ANDNE     'N'
     C     DDACTN        ANDEQ     'X'
     C     DDNCHI        ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     65
     C     DDNCHI        ANDNE     'N'
     C     DDACTN        ANDEQ     'X'
     C     DDNCHI        ORNE      *BLANK
     C     VNBRA         ANDNE     *ZEROS
     C     DDNbraOK      ANDNE     'N'
     C     PTYP          ANDEQ     67
     C     DDNCHI        ANDNE     'N'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNCHI        ORNE      *BLANK                                                     CLE030
     C     VNBRA         ANDNE     *ZEROS                                                     CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     PTYP          ANDEQ     63                                                         CLE030
     C     DDNCHI        ANDNE     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDNCHI        ORNE      *BLANK                                                     CLE030
     C     VNBRA         ANDNE     *ZEROS                                                     CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     PTYP          ANDEQ     65                                                         CLE030
     C     DDNCHI        ANDNE     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDNCHI        ORNE      *BLANK                                                     CLE030
     C     VNBRA         ANDNE     *ZEROS                                                     CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     PTYP          ANDEQ     67                                                         CLE030
     C     DDNCHI        ANDNE     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCHIB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0143'
     C                   MOVE      'N'           DDNchiOK
      *
      **  Mandatory if New base rate code entered.
      *
     C     DDNBRAB       WHENNE    *BLANKS
     C     WNBRA1        ANDNE     '*'
     C     DDNbraOK      ANDNE     'N'
     C     DDNCHIB       ANDEQ     *BLANK
      *
     C     DDNBRA        ORNE      *BLANKS
     C     DDNbraOK      ANDNE     'N'
     C     DDNCHI        ANDEQ     *BLANK
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNBRA        ORNE      *BLANKS                                                    CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     DDNCHI        ANDEQ     *BLANK                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCHIB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0143'
     C                   MOVE      'N'           DDNchiOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNchiOK      IFNE      'N'
     C                   MOVE      WNCHI         VNCHI
     C                   ENDIF
      *
     C                   ENDIF
      *
      * A base rate history record must exist which would apply to
      * the base rate code at rollover date.
      * Only do this if a valid base rate/rollover date combination
      * still exists; ie from screen or file.
      *
      * Invalid or removed by '*'
     C     DDRldtOK      IFNE      'N'
     C     WRLDT1        ANDNE     '*'
     C     DDNBRAB       ANDNE     *BLANK
     C     WNBRA1        ANDNE     '*'
     C     DDNbraOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
      *
     C     DDRldtOK      ORNE      'N'
     C     DDNBRA        ANDNE     *BLANK
     C     DDNbraOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDRldtOK      ORNE      'N'                                                        CLE030
     C     DDNBRA        ANDNE     *BLANK                                                     CLE030
     C     DDNbraOK      ANDNE     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     WRLDT         IFGT      *ZERO
     C                   Z-ADD     WRLDT         W#HIDT            5 0
     C                   ELSE
     C                   Z-ADD     RLDT          W#HIDT
     C                   ENDIF
      *
     C                   Z-ADD     WNBRA         G0BSRC
      *
     C                   CALL      'AOBSHSR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM                    POPTN
     C                   PARM      W#CCY         @CCY              3
     C                   PARM      G0BSRC        @BSRN             2 0
     C                   PARM                    @INTD             5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY
      *                                                                                       247860
     C     PRTCD         IFEQ      '*NRF   '                                                  247860
     C                   Z-ADD     0             G0HIDT                                       247860
     C                   ENDIF                                                                247860
     C*
     C                   IF        PRTCD <> *BLANKS AND G0CYCD = *BLANKS                    BUG13199
     C                   EVAL      G0HIDT = *ZEROS                                          BUG13199
     C                   ENDIF                                                              BUG13199
                                                                                            BUG13199
     C*****PRTCD         IFNE      *blanks                                                    240288
      *                                                                                       240288
      ** Check if it exists in SDBSRTPD and if the dates are valid                            240288
      ** regardless if the base rate has history or none                                      240288
      *                                                                                       240288
     C                   MOVE      WNBRA         PBRAT                                        240288
     C                   CALL      'AOBSRTR0'                                                 240288
     C                   PARM      *BLANKS       @RTCD                                        240288
     C                   PARM      '*KEY    '    POPTN                                        240288
     C                   PARM      W#CCY         PCURR                                        240288
     C                   PARM                    PBRAT                                        240288
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        240288
      *                                                                                       240288
      ** When rollover date has a value, issue error message when:                            240288
      ** Base rate not in PF/SDBSRTPD                                                         240288
      *                                                                                       240288
     C     @RTCD         IFNE      *BLANKS                                                    240288
      *                                                                                       240288
      ** Base rate has no history and rollover date is earlier than                           240288
      ** the value date of new base rate                                                      240288
      *                                                                                       240288
     C     BAVDNR        ORGT      W#HIDT                                                     240288
     C     W#HIDT        ANDNE     *ZEROS                                                     240288
     C     PRTCD         ANDNE     *BLANKS                                                    240288
      *                                                                                       240288
      ** Base rate has history but value date of new base rate is                             240288
      ** backvalued (earlier than first base rate history) and                                240288
      ** rollover date is earlier than the value date of new base rate                        240288
      *                                                                                       240288
     C     BAVDNR        ORGT      W#HIDT                                                     240288
     C     BAVDNR        ANDLT     G0HIDT                                                     240288
     C     PRTCD         ANDEQ     *BLANKS                                                    240288
     C     W#HIDT        ANDNE     *ZEROS                                                     240288
      *                                                                                       240288
      ** Base rate has history but rollover date is earlier than                              240288
      ** the value of first base rate history and value date of new                           240288
      ** base rate is not backvalued (i.e. later than first base rate history)                240288
      *                                                                                       240288
                                                                                              240288
     C     G0HIDT        ORGT      W#HIDT
     C     BAVDNR        ANDGE     G0HIDT                                                     240288
     C     W#HIDT        ANDNE     *ZEROS                                                     240288
     C     PRTCD         ANDEQ     *BLANKS                                                    240288
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1041'
     C                   MOVE      'N'           DDNbraOK
     C                   ENDIF
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       BUG827
      *                                                               *                       BUG827
      * SRFYLD - Validate Forward Yield Curve                         *                       BUG827
      *                                                               *                       BUG827
      *****************************************************************                       BUG827
                                                                                              BUG827
     C     SRFYLD        BEGSR                                                                BUG827
                                                                                              BUG827
     C                   CALL      'AOLOANR0'                                                 BUG827
     C                   PARM      *BLANKS       PRTCD                                        BUG827
     C                   PARM      '*KEY   '     POPTN                                        BUG827
     C                   PARM      LTYP          PLNTP             2                          BUG827
     C                   PARM      SUTP          PLNST             2                          BUG827
     C                   PARM      CLAS          PLNCL             4                          CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        BUG827
                                                                                              BUG827
     C     PRTCD         IFNE      *BLANKS                                                    BUG827
     C     *LOCK         IN        LDA                                                        BUG827
     C                   MOVEL     'SDLOANPD'    DBFILE                                       BUG827
     C                   Z-ADD     201           DBASE                                        BUG827
     C     LTYP          CAT       SUTP          DBKEY                                        BUG827
     C                   CAT       CLAS:1        DBKEY                                        CLE042
     C                   OUT       LDA                                                        BUG827
     C                   EXSR      *PSSR                                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** Validate Forward Yield Curve                                                         BUG827
                                                                                              BUG827
     C     WNFYLD        IFNE      '*'                                                        BUG827
                                                                                              BUG827
     C     DDFYLDB       IFNE      *BLANKS                                                    BUG827
     C                   CALL      'AOYLDCR0'                                                 BUG827
     C                   PARM      '*BLANKS'     PRTCD                                        BUG827
     C                   PARM      '*KEY   '     POPTN                                        BUG827
     C                   PARM      DDFYLDB       PPYLDC            5                          BUG827
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        BUG827
                                                                                              BUG827
      ** Error on the Yield Curve entered                                                     BUG827
                                                                                              BUG827
     C     PRTCD         IFEQ      '*NRF   '                                                  BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0535'                         BUG827 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2005'                                BUG11329
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ELSE                                                                 BUG827
                                                                                              BUG827
      ** If no selection was made, default to the value of the Forward                        BUG827
      ** Yield Curve for the loan type/subtype                                                BUG827
                                                                                              BUG827
     C     PRTCD         IFEQ      '*NOSEL '                                                  BUG827
                                                                                              BUG827
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          BUG827
      ** Generate error if no default value set in loan                                       BUG827
      ** type/subtype file.                                                                   BUG827
                                                                                              BUG827
     C     AYYLDM        IFEQ      'Y'                                                        BUG827
     C     AYFYLD        ANDEQ     *BLANKS                                                    BUG827
     C     CAS005        ANDNE     'Y'                                                        BUG827
                                                                                              BUG827
     C     AYFYCM        OREQ      'Y'                                                        BUG827
     C     AYFYLD        ANDEQ     *BLANKS                                                    BUG827
     C     CAS005        ANDEQ     'Y'                                                        BUG827
                                                                                              BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C                   EVAL      MsgIDArr(Idx) = 'LEV1063'                                  BUG827
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ELSE                                                                 BUG827
                                                                                              BUG827
     C                   MOVE      AYFYLD        DDFYLDB                                      BUG827
                                                                                              BUG827
      ** Access yield curves file to get the details                                          BUG827
                                                                                              BUG827
     C     DDFYLDB       IFNE      *BLANK                                                     BUG827
     C                   CALL      'AOYLDCR0'                                                 BUG827
     C                   PARM      '*BLANKS'     PRTCD                                        BUG827
     C                   PARM      '*KEY   '     POPTN                                        BUG827
     C                   PARM      DDFYLDB       PPYLDC                                       BUG827
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        BUG827
                                                                                              BUG827
     C     PRTCD         IFEQ      '*NRF   '                                                  BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0535'                         BUG827 BUG11329
     C                   EVAL      MsgIDArr(Idx) = 'LEV2005'                                BUG11329
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
     C                   ENDIF                                                                BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** Valid yield curve selected                                                           BUG827
                                                                                              BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVEL     FSYLDC        DDFYLDB                                      BUG827
     C                   ENDIF                                                                BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** Error if Non Zero-coupon Yield Curve                                                 BUG827
                                                                                              BUG827
     C     FSYLDT        IFNE      'Z'                                                        BUG827
     C     CAS005        ANDNE     'Y'                                                        BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0533'                        BUG827 BUG113297
     C                   EVAL      MsgIDArr(Idx) = 'LEV2006'                               BUG113297
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** Error if Interpolation Method is neither 'Y' nor 'R'                                 BUG827
                                                                                              BUG827
     C     FSINTP        IFNE      'Y'                                                        BUG827
     C     FSINTP        ANDNE     'R'                                                        BUG827
     C     CAS005        ANDNE     'Y'                                                        BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C                   EVAL      MsgIDArr(Idx) = 'LEV1062'                                  BUG827
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** If Forward Yield Curve is not entered, default value will                            BUG827
      ** come from SDLOANPD                                                                   BUG827
                                                                                              BUG827
     C                   ELSE                                                                 BUG827
                                                                                              BUG827
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          BUG827
      ** Generate error if no default value set in loan                                       BUG827
      ** type/subtype file.                                                                   BUG827
                                                                                              BUG827
     C     AYYLDM        IFEQ      'Y'                                                        BUG827
     C     AYFYLD        ANDEQ     *BLANKS                                                    BUG827
     C     CAS005        ANDNE     'Y'                                                        BUG827
                                                                                              BUG827
     C     AYFYCM        OREQ      'Y'                                                        BUG827
     C     AYFYLD        ANDEQ     *BLANKS                                                    BUG827
     C     CAS005        ANDEQ     'Y'                                                        BUG827
                                                                                              BUG827
     C                   ADD       1             Idx                                          BUG827
     C                   EVAL      FldNameArr(Idx) = 'DDFYLDB'                                BUG827
     C                   EVAL      MsgIDArr(Idx) = 'LEV1063'                                  BUG827
     C                   MOVE      'N'           DDFYLDOK                                     BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      AYFYLD        DDFYLDB                                      BUG827
                                                                                              BUG827
      ** Access yield curves file to get the details                                          BUG827
                                                                                              BUG827
     C     DDFYLDB       IFNE      *BLANK                                                     BUG827
     C                   CALL      'AOYLDCR0'                                                 BUG827
     C                   PARM      '*BLANKS'     PRTCD                                        BUG827
     C                   PARM      '*KEY   '     POPTN                                        BUG827
     C                   PARM      DDFYLDB       PPYLDC                                       BUG827
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        BUG827
     C                   ENDIF                                                                BUG827
     C                   ENDIF                                                                BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
     C                   MOVE      DDFYLDB       VNFYLD                                       BUG827
                                                                                              BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
     C                   ENDSR                                                                BUG827
                                                                                              BUG827
      *****************************************************************                       BUG827
      /EJECT                                                                                  BUG827
      *****************************************************************
      *                                                               *
      * SRNIPD - Validate New Interest Payment Date                   *
      *                                                               *
      *****************************************************************
 
     C     SRNIPD        BEGSR
      *
      **  Validate if not blank and not to be removed.
      *
     C     DDNIPDB       IFNE      *BLANKS
     C     WNIPD1        ANDNE     '*'
     C     DDNIPD        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNIPD        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'A'
     C                   TESTN                   DDNIPDB              85        *on means numeric
     C                   MOVE      DDNIPDB       ZDATE
     C                   ELSE
     C                   TESTN                   DDNIPD               85        *on means numeric
     C                   MOVE      DDNIPD        ZDATE
     C                   ENDIF
     C                   EXSR      ZDATE1
      *
      **  Forbidden for Discount loans.
     C                   SELECT
     C     PTYP          WHENEQ    63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1012'
     C                   MOVE      'N'           DDNipdOK
      *
      **  Must be numeric.
     C     *IN85         WHENEQ    *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0601'
     C                   MOVE      'N'           DDNipdOK
      *
      **  Must be in valid date format.
     C     Errorflag     WHENEQ    'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0601'
     C                   MOVE      'N'           DDNipdOK
      *
      **  Must be later than the loan interest payment date.
     C     ZDAYNO        WHENLE    NIDT
     C     ZDAYNO        ORLT      WRLDT
     C     IPFR          ANDEQ     'R'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0602'
     C                   MOVE      'N'           DDNipdOK
      *
      **  Must not be later than the maturity date.
      *
     C     ZDAYNO        WHENGT    MDAT
     C     MDAT          ANDNE     0
     C     ZDAYNO        ANDGT     WNMDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0607'
     C                   MOVE      'N'           DDNipdOK
      *
      **  Must not be later than the Facility Expiry Date for
      **  Call Loans with no Maturity Date.
     C     ZDAYNO        WHENGT    F_DTEX
     C     MDAT          ANDEQ     0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNIPDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0608'
     C                   MOVE      'N'           DDNipdOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNchiOK      IFNE      'N'
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNIPDB       DDNIPDB
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        VNIPD
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If New interest payment date is blank,
      **  check if Next interest date is blank,
      **  if it is, default to Rollover date.
      **  If not blank, default New interest payment date
      **  to Rollover date.
      *
     C     DDNIPDB       IFEQ      *BLANKS
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     VRLDT         ANDNE     *ZEROS
     C     DDRldtOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C     REPT          ANDEQ     2
     C     NIDT          IFEQ      *ZEROS
     C     VRLDT         ANDGE     WRNDAY
     C     IPFR          ANDEQ     'R'                                                      AR648838
     C                   Z-ADD     VRLDT         VNIDT
     C                   ELSE
     C     VRLDT         IFGT      NIDT
     C     VRLDT         ANDGE     WRNDAY
     C     IPFR          ANDEQ     'R'
     C                   Z-ADD     VRLDT         VNIPD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNMDT - Validate New Maturity Payment Date                   *
      *                                                               *
      *****************************************************************
 
     C     SRNMDT        BEGSR
      *
      **  Validate if not blank and not to be removed.
      *
     C     DDNMDTB       IFNE      *BLANKS
     C     WNMDT1        ANDNE     '*'
     C     DDNMDT        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNMDT        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'A'
     C*****DDACTN        OREQ      'X'                                              BUG9787 AR819932
     C                   TESTN                   DDNMDTB              85        *on means numeric
     C                   MOVE      DDNMDTB       ZDATE
     C                   ELSE
     C                   TESTN                   DDNMDT               85        *on means numeric
     C                   MOVE      DDNMDT        ZDATE
     C                   ENDIF
     C                   EXSR      ZDATE1
      *
      **  Forbidden for Discount loans.
     C                   SELECT
      ****************************************************************               BUG9787 BUG9787
      ***Entry*not*allowed*on*Call*Loans******************************               BUG9787 BUG9787
      ****************************************************************               BUG9787 BUG9787
     C*****PTYP          WHENEQ    61                                                BUG9787 BUG9787
     C**********         ADD       1             Idx                                 BUG9787 BUG9787
     C**********         EVAL      FldNameArr(Idx) = 'DDNMDTB'                       BUG9787 BUG9787
     C**********         EVAL      MsgIDArr(Idx) = 'LEL0130'                         BUG9787 BUG9787
     C**********         MOVE      'N'           DDNmdtOK                            BUG9787 BUG9787
     C     PTYP          WHENEQ    63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1013'
     C                   MOVE      'N'           DDNmdtOK
      *
      **  Must be numeric.
     C     *IN85         WHENEQ    *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0603'
     C                   MOVE      'N'           DDNmdtOK
      *
      **  Must be in valid date format.
     C     Errorflag     WHENEQ    'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0603'
     C                   MOVE      'N'           DDNmdtOK
      *
      **  Must be later than the loan maturity date.
     C     ZDAYNO        WHENLE    MDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0604'
     C                   MOVE      'N'           DDNmdtOK
      *
      **  Must be later than the Rollover date or Next Interest
      **  Payment Date
      *
     C     ZDAYNO        WHENLE    RLDT
     C     ZDAYNO        ORLE      VRLDT
     C     ZDAYNO        ORLE      NROD
     C     ZDAYNO        ORLE      VNROD
     C     ZDAYNO        ORLT      NIPD
     C     ZDAYNO        ORLT      NIDT
     C     ZDAYNO        ORLT      VNIPD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0605'
     C                   MOVE      'N'           DDNmdtOK
      *
      **  Must be not be later than the facility Expiry date.
      *
     C     ZDAYNO        WHENGT    F_DTEX
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0606'
     C                   MOVE      'N'           DDNmdtOK
     C                   ENDSL
      **********                                                                       CAS019 262581
     C**********         IF        CAS016 = 'Y'                                        CAS019 262581
      **********                                                                       CAS019 262581
      ***Check*for valid values of maturity date when amortising fees exist            CAS019 262581
      **********                                                                       CAS019 262581
     C**********         IF        DDACTN = 'A' AND                                    CAS019 262581
     C**********                   DDNMDTB <> *BLANKS                                  CAS019 262581
     C*****LNRF*         CHAIN     LEFEEDF                            21               CAS019 262581
     C**********         DOW       *IN21 = *ON                                       CAS019 BUG22935
     C**********         DOW       *IN21 = *OFF                                      BUG22935 262581
      **********                                                                       CAS019 262581
     C**********         IF        FEAMRI = 'N' AND                                    CAS019 262581
     C**********                   FESTPD <= BJRDNB OR                                 CAS019 262581
     C**********                   FEAMRI = 'Y' AND                                    CAS019 262581
     C**********                   FESTPD <= BJRDNB AND                                CAS019 262581
     C**********                   FEENPD > ZDAYNO                                     CAS019 262581
     C**********         ADD       1             Idx                                   CAS019 262581
     C**********         EVAL      FldNameArr(Idx) = 'DDNMDTB'                         CAS019 262581
     C**********         EVAL      MsgIDArr(Idx) = 'LEV1072'                           CAS019 262581
     C**********         MOVE      'N'           DDRldtOK                              CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
      **********                                                                       CAS019 262581
     C*****LNRF*         READE     LEFEEDF                                21           CAS019 262581
     C**********         ENDDO                                                         CAS019 262581
      **********                                                                       CAS019 262581
      ***Check*for history records                                                     CAS019 262581
      **********                                                                       CAS019 262581
     C*****LNRF*         CHAIN     LEFHSTF                            21               CAS019 262581
     C**********         DOW       *IN21 = *ON                                       CAS019 BUG22935
     C**********         DOW       *IN21 = *OFF                                      BUG22935 262581
      **********                                                                       CAS019 262581
     C**********         IF        HIAMRI = 'N' AND                                    CAS019 262581
     C**********                   HISTPD <= BJRDNB OR                                 CAS019 262581
     C**********                   HIAMRI = 'Y' AND                                    CAS019 262581
     C**********                   HISTPD <= BJRDNB AND                                CAS019 262581
     C**********                   HIENPD > ZDAYNO                                     CAS019 262581
     C**********         ADD       1             Idx                                   CAS019 262581
     C**********         EVAL      FldNameArr(Idx) = 'DDNMDTB'                         CAS019 262581
     C**********         EVAL      MsgIDArr(Idx) = 'LEV1072'                           CAS019 262581
     C**********         MOVE      'N'           DDRldtOK                              CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
      **********                                                                       CAS019 262581
     C*****LNRF*         READE     LEFHSTF                                21           CAS019 262581
     C**********         ENDDO                                                         CAS019 262581
      **********                                                                       CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
      *
      * If no errors
      *
     C     DDNmdtOK      IFNE      'N'
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNMDTB       DDNMDTB
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        VNMDT
     C                   ENDIF
     C                   ENDIF
      *
      **  If New maturity date is blank
      **  or is about to be blanked out
      **  do allow if rollover date is equal to maturity date.
     C     DDNMDTB       IFEQ      *BLANKS
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     NMDT          ANDEQ     *ZERO
     C     VRLDT         ANDNE     *ZEROS
     C     DDRldtOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
      *
     C     DDNMDT        OREQ      *BLANKS
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     NMDT          ANDEQ     *ZERO
     C     VRLDT         ANDNE     *ZEROS
     C     DDRldtOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     DDNMDT        OREQ      *BLANKS                                                    CLE030
     C     PTYP          ANDNE     63                                                         CLE030
     C     PTYP          ANDNE     65                                                         CLE030
     C     PTYP          ANDNE     67                                                         CLE030
     C     NMDT          ANDEQ     *ZERO                                                      CLE030
     C     VRLDT         ANDNE     *ZEROS                                                     CLE030
     C     DDRldtOK      ANDNE     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     VRLDT         IFGE      MDAT
     C     PTYP          ANDNE     61
     C     MDAT          ANDNE     0
     C     VRLDT         ORGE      MDAT
     C     PTYP          ANDNE     68
     C     MDAT          ANDNE     0
     C     VRLDT         ORGE      MDAT
     C     PTYP          ANDNE     69
     C     MDAT          ANDNE     0
     C     RLDT          ORGE      MDAT
     C     PTYP          ANDNE     61
     C     MDAT          ANDNE     0
     C     RLDT          ORGE      MDAT
     C     PTYP          ANDNE     68
     C     MDAT          ANDNE     0
     C     RLDT          ORGE      MDAT
     C     PTYP          ANDNE     69
     C     MDAT          ANDNE     0
      *
     C     VRLDT         ORGE      F_DTEX
     C     PTYP          ANDEQ     61
     C     MDAT          ANDEQ     0
      *
     C     VRLDT         ORGE      F_DTEX
     C     PTYP          ANDEQ     68
     C     MDAT          ANDEQ     0
      *
     C     VRLDT         ORGE      F_DTEX
     C     PTYP          ANDEQ     69
     C     MDAT          ANDEQ     0
      *
     C*****RLDT*         ORGE      F_DTEX                                                    BUG4845
     C*****PTYP*         ANDEQ     61                                                        BUG4845
     C*****MDAT*         ANDEQ     0                                                         BUG4845
      **********                                                                             BUG4845
     C*****RLDT*         ORGE      F_DTEX                                                    BUG4845
     C*****PTYP*         ANDEQ     68                                                        BUG4845
     C*****MDAT*         ANDEQ     0                                                         BUG4845
      **********                                                                             BUG4845
     C*****RLDT*         ORGE      F_DTEX                                                    BUG4845
     C*****PTYP*         ANDEQ     69                                                        BUG4845
     C*****MDAT*         ANDEQ     0                                                         BUG4845
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNMDTB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0152'
     C                   MOVE      'N'           DDNmdtOK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       237744
      ** Parts Sold new maturity date should not be later than                                237744
      ** the related loan's maturity date                                                     237744
      *                                                                                       237744
     C     PTYP          Ifeq      66                                                         237744
     C     PTYP          Oreq      67                                                         237744
     C     PTYP          Oreq      69                                                         237744
     C     PTYP          Oreq      72                                                         237744
      *                                                                                       237744
     C     DDNMDTB       Ifne      *Blanks                                                    237744
     C     WNMDT1        Andne     '*'                                                        237744
     C     DDACTN        Andeq     'A'                                                        237744
     C     NMDT          Orgt      *Zeros                                                     237744
     C     DDACTN        Andeq     'X'                                                        237744
      *                                                                                       237744
     C**********         Z-add     OLNO          WLNRF                                  237744CSD027
     C                   Move      OLNO          WLNRF                                        CSD027
     C                   Move      'A'           WRCDT                                        237744
     C     WLOAN         Chain(N)  CLOAN                              89                      237744
      *                                                                                       237744
     C     *IN89         Ifeq      '0'                                                        237744
     C     LO_NMDT       Andgt     0                                                          237744
     C     ZDAYNO        Andgt     LO_NMDT                                                    237744
     C     *IN89         Oreq      '0'                                                        237744
     C     LO_NMDT       Andeq     0                                                          237744
     C     ZDAYNO        Andgt     LO_MDAT                                                    237744
     C                   Add       1             Idx                                          237744
     C                   Eval      FldnameArr(Idx) = 'DDNMDTB'                                237744
     C                   Eval      MsgIDArr(Idx) = 'LEV0609'                                  237744
     C                   Move      'N'           DDNmdtOK                                     237744
     C                   Endif                                                                237744
      *                                                                                       237744
     C                   Endif                                                                237744
     C                   Endif                                                                237744
      *
      **  Remove field values if required.
      *
     C     WNIPD1        IFEQ      '*'
     C                   Z-ADD     *ZEROS        VNIPD
     C                   ENDIF
     C     WNMDT1        IFEQ      '*'
      *                                                                                       237744
      ** New Maturity of the parts sold can't be blanked out when the related loan            237744
      ** has an existing new maturity date. This is to ensure that the maturity date          237744
      ** of the parts sold will not be later than the maturity date of the related loan       237744
      *                                                                                       237744
     C     PTYP          Ifeq      66                                                         237744
     C     PTYP          Oreq      67                                                         237744
     C     PTYP          Oreq      69                                                         237744
     C     PTYP          Oreq      72                                                         237744
      *                                                                                       237744
     C**********         Z-add     OLNO          WLNRF                                  237744CSD027
     C                   Move      OLNO          WLNRF                                        CSD027
     C                   Move      'A'           WRCDT                                        237744
     C     WLOAN         Chain(N)  CLOAN                              89                      237744
      *                                                                                       237744
     C     *IN89         Ifeq      '0'                                                        237744
     C     LO_NMDT       AndGt     0                                                          237744
     C                   Add       1             Idx                                          237744
     C                   Eval      FldNameArr(Idx) = 'DDNMDTB'                                237744
     C                   Eval      MsgIDArr(Idx) = 'LEV0610'                                  237744
     C                   Move      'N'           DDNmdtOK                                     237744
     C                   Else                                                                 237744
     C                   Z-add     *Zeros        VNMDT                                        237744
     C                   Endif                                                                237744
      *                                                                                       237744
     C                   Else                                                                 237744
     C                   Z-ADD     *ZEROS        VNMDT
     C                   Endif                                                                237744
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNROD - Validate Next Rollover Date                          *
      *                                                               *
      *****************************************************************
 
     C     SRNROD        BEGSR
      *
     C     WNROD1        IFEQ      '*'
     C                   Z-ADD     *ZERO         VNROD
     C                   ENDIF
     C     WNROD1        IFNE      '*'
     C     DDNbraOK      ANDNE     'N'
      *
     C     DDACTN        IFEQ      'A'
     C                   TESTN                   DDNRODB              85        *on means numeric
     C                   MOVE      DDNRODB       ZDATE
     C                   ELSE
     C                   TESTN                   DDNROD               85        *on means numeric
     C                   MOVE      DDNROD        ZDATE
     C                   ENDIF
     C                   EXSR      ZDATE1
      *
      **  Discount loans, this field is mandatory.
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C     DDNRODB       IFEQ      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDNROD        OREQ      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRSTS        ANDNE     W_ReAutho                                                 BUG6926
     C     DDNROD        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0465'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
      *
      **  Next Rollover date entered and no valid amended
      **  Rollover date, the Rollover date of the loan must exist.
      *
     C     DDNRODB       WHENNE    *BLANKS
     C     VRLDT         ANDEQ     *ZEROS
     C     RLDT          ANDEQ     *ZEROS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0289'
     C                   MOVE      'N'           DDNrodOK
      *
      **  Must be numeric.
      *
     C     DDNRODB       WHENNE    *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDNROD        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDNROD        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1014'
     C                   MOVE      'N'           DDNrodOK
      *
      **  Must be in valid date format.
      *
     C     DDNRODB       WHENNE    *BLANKS
     C     Errorflag     ANDEQ     'Y'
     C     DDNROD        ORNE      *BLANKS
     C     Errorflag     ANDEQ     'Y'
     C     DDACTN        ANDEQ     'X'
     C     DDNROD        ORNE      *BLANKS                                                    CLE030
     C     Errorflag     ANDEQ     'Y'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1014'
     C                   MOVE      'N'           DDNrodOK
      *
      **  Must be greater than Rollover date of the loan
      **  if amended Rollover date is not valid or blank.
      **  OR, must be greater than the valid amended Rollover date.
     C     DDNRODB       WHENNE    *BLANKS
     C     Errorflag     ANDEQ     'N'
      *
     C     VRLDT         IFEQ      *ZEROS
     C     ZDAYNO        ANDLE     RLDT
     C     VRLDT         ORNE      *ZEROS
     C     ZDAYNO        ANDLE     VRLDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0289'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
      *
      **  Must be greater than Value date of the loan,
      **  (only if Backvaluation feature is switched off)
      **  and less than Maturity date.
      **  If BLI LE Enhancement feature *ON,
      **  then it must be less than New Maturity date.
      **  Validation against maturity date only for
      **  non-discount loans.
     C     ZDAYNO        IFLE      VDAT
     C     CLE003        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1031'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
     C     *IN60         IFEQ      *ON
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     VNMDT         ANDNE     *ZEROS
     C     ZDAYNO        IFGE      VNMDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1038'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
     C                   ELSE
     C     PTYP          IFNE      63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     ZDAYNO        ANDGE     MDAT
     C     MDAT          ANDNE     *ZEROS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1038'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
     C                   ENDIF
     C     ZDAYNO        IFGE      F_DTEX
     C     MDAT          ANDEQ     0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1043'
     C                   MOVE      'N'           DDNrodOK
     C                   ENDIF
      *
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNrodOK      IFNE      'N'
     C     DDNRODB       IFNE      *BLANKS
     C                   MOVE      DDNRODB       DDNRODB
     C                   Z-ADD     ZDAYNO        VNROD
     C                   ENDIF
     C     DDNROD        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     ZDAYNO        VNROD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C***
     C     DDNrodOK      IFNE      'N'
     C     VNROD         ANDNE     0
     C     VNIDT         ANDNE     0
     C     VNIPD         ANDEQ     0
     C     VNROD         ANDGT     VNIDT
     C     IPFR          ANDEQ     'R'
     C                   Z-ADD     VNROD         VNIPD
     C                   END
     C***
      *
      **  New rollover details should be complete or none at all.
      **  New base rate is empty, thus, new spread indicator,
      **  new interest calc basis and new change indicator must all
      **  be empty; and new spread/rate must be empty or has a valid
      **  entry.
      *
     C     RMVINT        IFEQ      *OFF
     C     DDACTN        ANDEQ     'A'
     C                   MOVE      *OFF          WLOGIC
     C     DDNRTSB       IFEQ      *BLANKS
     C     VNRTS         ORNE      *ZERO
     C                   MOVE      *ON           WLOGIC            1
     C                   ENDIF
     C     DDNBRAB       IFEQ      *BLANKS
     C     DDNSINB       ANDEQ     *BLANK
     C     DDNCASB       ANDEQ     *BLANK
     C     DDNCHIB       ANDEQ     *BLANK
     C     WLOGIC        ANDEQ     *ON
     C                   ELSE
     C     DDNBRAB       IFNE      *BLANKS
     C     DDNSINB       ANDNE     *BLANK
     C     DDNCASB       ANDNE     *BLANK
     C     DDNCHIB       ANDNE     *BLANK
     C     WLOGIC        ANDEQ     *ON
     C                   ELSE
     C     WNSIN         IFEQ      *BLANK
     C     WFLAG         ANDEQ     'N'
     C     WNCHI         OREQ      *BLANK
     C     WFLAG         ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNRODB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0288'
     C                   MOVE      'N'           DDNrodOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0288'                                  WA0025
     C                   MOVE      'N'           DDNbraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNRTSB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0288'                                  WA0025
     C                   MOVE      'N'           DDNrtsOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNSINB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0288'                                  WA0025
     C                   MOVE      'N'           DDNsinOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCASB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0288'                                  WA0025
     C                   MOVE      'N'           DDNcasOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCHIB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0288'                                  WA0025
     C                   MOVE      'N'           DDNchiOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNPRA - Validate New Principal                               *
      *                                                               *
      *****************************************************************
 
     C     SRNPRA        BEGSR
      *
     C     WNPRA1        IFNE      '*'
     C                   MOVEL     CCY           PCURR
     C                   Z-ADD     100           PBASE             3 0
     C                   MOVE      *ON           EDBAS             1
     C                   EXSR      SRCURR
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNPRAB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNPRAM       ZFIELD
     C                   ENDIF
     C                   MOVE      A6NBDP        WNBDP             1 0
     C     13            SUB       WNBDP         ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNPRAM           13 0
      *
      ****Forbidden*for*Non-discount*loans.****************************                       CLE031
      **  Forbidden for Non-discount loans if CLE031 is off.                                  CLE031
      **  If CLE031 is on, loan ccy must be different from facility ccy.                      CLE031
      *
     C                   SELECT
     C     PTYP          WHENNE    63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNPRAB       ANDNE     *BLANKS
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          ORNE      63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNPRAM       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          ORNE      63                                                         CLE030
     C     PTYP          ANDNE     65                                                         CLE030
     C     PTYP          ANDNE     67                                                         CLE030
     C     DDNPRAM       ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDNE     63                                                         CLE031
     C     PTYP          ANDNE     65                                                         CLE031
     C     PTYP          ANDNE     67                                                         CLE031
     C     CCY           ANDEQ     FCCY                                                       CLE031
     C     DDNPRAM       ANDNE     *Blanks                                                    CLE031
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNPRAB'
     C                   IF        CLE031 <> 'Y'                                              CLE031
     C                   EVAL      MsgIDArr(Idx) = 'LEV0466'
     C                   ELSE                                                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'LEV1068'                                  CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      'N'           DDNpraOK
      *
      **  For discount loans, default to New or Current principal
      **  if entry is blank.
      *
     C     PTYP          WHENEQ    63
     C     DDNPRAB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      65
     C     DDNPRAB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      67
     C     DDNPRAB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
                                                                                              CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     63                                                         CLE031
     C     DDNPRAB       ANDEQ     *BLANKS                                                    CLE031
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     DDNFCEB       ANDEQ     *BLANKS                                                    CLE031
     C     DDNFCE        ANDEQ     *BLANKS                                                    CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     65                                                         CLE031
     C     DDNPRAB       ANDEQ     *BLANKS                                                    CLE031
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     DDNFCEB       ANDEQ     *BLANKS                                                    CLE031
     C     DDNFCE        ANDEQ     *BLANKS                                                    CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     67                                                         CLE031
     C     DDNPRAB       ANDEQ     *BLANKS                                                    CLE031
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     DDNFCEB       ANDEQ     *BLANKS                                                    CLE031
     C     DDNFCE        ANDEQ     *BLANKS                                                    CLE031
     C     NPRAM         IFNE      *ZEROS
     C                   Z-ADD     NPRAM         WNPRAM
     C                   ELSE
     C                   Z-ADD     CPAM          WNPRAM
     C                   ENDIF
      *
      **  Must be a valid numeric amount
      *
     C     PTYP          WHENEQ    63
     C     ZALIGNok      ANDEQ     'N'
     C     PTYP          OREQ      65
     C     ZALIGNok      ANDEQ     'N'
     C     PTYP          OREQ      67
     C     ZALIGNok      ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNPRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0460'
     C                   MOVE      'N'           DDNpraOK
      *
      **  Must be less than or equal to Current
      **  principal amount.
      *
     C     PTYP          WHENEQ    63
     C     ZALIGNok      ANDEQ     'Y'
     C     WNPRAM        ANDGT     CPAM
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      65
     C     ZALIGNok      ANDEQ     'Y'
     C     WNPRAM        ANDGT     CPAM
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      67
     C     ZALIGNok      ANDEQ     'Y'
     C     WNPRAM        ANDGT     CPAM
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNPRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0461'
     C                   MOVE      'N'           DDNpraOK
     C                   ENDSL
                                                                                              CLE031
      ** If CLE031 is on and new facility exchange rate has                                   CLE031
      ** been entered:                                                                        CLE031
                                                                                              CLE031
     C                   Z-ADD     *ZEROS        WVPRAM           13 0                        CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ZALIGNok      ANDEQ     'Y'                                                        CLE031
     C     CCY           ANDNE     FCCY                                                       CLE031
     C     DDNfceOK      ANDEQ     'Y'                                                        CLE031
                                                                                              CLE031
     C     DDNFCEB       IFNE      *BLANKS                                                    CLE031
     C     WNFCE1        ANDNE     '*'                                                        CLE031
     C     DDNFCE        ORNE      *BLANKS                                                    CLE031
     C     WNFCE1        ANDNE     '*'                                                        CLE031
                                                                                              CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C     DDACTN        IFEQ      'A'                                                        CLE031
     C                   MOVE      DDNFCEB       ZFIELD                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDNFCE        ZFIELD                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   Z-ADD     5             ZADIG                                        CLE031
     C                   EXSR      ZALIGN                                                     CLE031
     C                   MOVE      ZFIELD        VNFCE                                        CLE031
                                                                                              CLE031
     C                   MOVEL     FCCY          PCURR                                        CLE031
     C                   Z-ADD     90            DBASE                                        CLE031
     C                   MOVE      *ON           EDBAS                                        CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   Z-ADD     A6NBDP        WNFDP             1 0                        CLE031
     C     WNFDP         SUB       WNBDP         DP                1 0                        CLE031
     C                   ADD       4             DP                                           CLE031
     C     DDNFCEB       IFNE      *Blanks                                                    CLE031
     C                   MOVE      DDNFMDB       WNFMDI            1                          CLE031
     C                   ELSE                                                                 CLE031
     C     DDNFCE        IFNE      *Blanks                                                    CLE031
     C                   MOVE      DDNFMD        WNFMDI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C     WNFMDI        IFEQ      'D'                                                        CLE031
     C     VNFCE         DIV(H)    POWER(DP)     WEXR15           15 9                        CLE031
     C     1             DIV       WEXR15        WEXR15                                       CLE031
     C                   ELSE                                                                 CLE031
     C     VNFCE         MULT(H)   POWER(DP)     WEXR15                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Calculate default value of New Principal Amount                                      CLE031
                                                                                              CLE031
     C     FPAM          IFNE      0                                                          CLE031
      ** Loans with Facility Ccy amt FPAM can be rolled over to full                          CLE031
      ** utilisation of the facility, or to loan ccy equiv. of FPAM                           CLE031
                                                                                              CLE031
     C                   EXSR      SRFAMT                                                     CLE031
                                                                                              CLE031
     C     WNFMDI        IFEQ      'M'                                                        CLE031
     C     FPAM          DIV(H)    WEXR15        WCNPAM           13 0                        CLE031
     C                   ELSE                                                                 CLE031
     C     FPAM          MULT(H)   WEXR15        WCNPAM                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ELSE                                                                 CLE031
     C                   Z-ADD     CPAM          WCNPAM                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Revolving credit facility                                                            CLE031
                                                                                              CLE031
     C     F_RVCR        IFEQ      'Y'                                                        CLE031
                                                                                              CLE031
     C     WNPRAM        IFNE      WCNPAM                                                     CLE031
     C     WNPRAM        ANDNE     WLFAMT                                                     CLE031
     C     WNPRAM        IFNE      0                                                          CLE031
     C     NPRAM         ORNE      0                                                          CLE031
      ** Display Warning message only once:                                                   CLE031
     C     WCNPAM        IFNE      PRNPAM                                                     CLE031
     C     WLFAMT        ORNE      PRFAMT                                                     CLE031
     C                   Z-ADD     WCNPAM        PRNPAM           13 0                        CLE031
     C                   Z-ADD     WLFAMT        PRFAMT           13 0                        CLE031
     C                   MOVEL     CCY           PCURR                                        CLE031
     C                   Z-ADD     78            DBASE                                        CLE031
     C                   MOVE      *ON           EDBAS                                        CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      WCNPAM        ZFIELD                                       CLE031
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   EVAL      WIdx = WIdx + 1                                            CLE031
     C**********         EVAL      WMsgDtaArr(WIdx) = ZFIELD                         CLE031 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZFIELD))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(ZFIELD)                 MD000091
     C                   MOVE      WLFAMT        ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C**********         EVAL      WMsgDtaArr(WIdx) = WMsgDtaArr(WIdx) + ZFIELD      CLE031 MD000091
     C                   EVAL      BLen = %Len(%Trim(WMsgDtaArr(WIdx)))                     MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr                                MD000091
     C                                                +%TRIM(WMsgDtaArr(WIdx))              MD000091
     C                   EVAL      BLen = %Len(%Trim(ZFIELD))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = %TRIM(WMsgDtaArr(WIdx))               MD000091
     C                                            + LenStr +%TRIM(ZFIELD)                   MD000091
     C                   EVAL      DDNPRAOK = 'W'                                             CLE031
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1082'                                CLE031
     C                   EVAL      WFldNamArr(WIdx) = 'DDNPRAM'                               CLE031
     C                   EVAL      DDNpraOK = 'N'                                             CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Non-revolving credit facility                                                        CLE031
                                                                                              CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
     C     DDNPRAB       IFEQ      *BLANKS                                                    CLE031
     C                   Z-ADD     WCNPAM        WNPRAM                                       CLE031
     C                   ELSE                                                                 CLE031
     C     WNPRAM        IFNE      WCNPAM                                                     CLE031
     C                   Z-ADD     WCNPAM        WVPRAM                                       CLE031
                                                                                              CLE031
     C                   MOVEL     CCY           PCURR                                        CLE031
     C                   Z-ADD     79            DBASE                                        CLE031
     C                   MOVE      *ON           EDBAS                                        CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      WCNPAM        ZFIELD                                       CLE031
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDNPRAB'                                CLE031
     C                   EVAL      MsgIDArr(Idx) = 'LEV1066'                                  CLE031
     C**********         EVAL      MsgDtaArr(Idx) = ZFIELD                           CLE031 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZFIELD))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZFIELD)                   MD000091
     C                   MOVE      'N'           DDNpraOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      * If no errors
      *
     C     DDNpraOK      IFNE      'N'
     C     WNPRAM        IFNE      *ZEROS
     C                   Z-ADD     80            DBASE                                        CLE031
     C                   MOVE      *ON           EDBAS                                        CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE031
     C                   Z-ADD     WNPRAM        WVPRAM                                       CLE031
     C                   Z-ADD     WNPRAM        VNPRAM
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WNPRAM        ZFIELD
     C                   EXSR      ZEDIT
     C     DDACTN        IFEQ      'A'
     C                   MOVE      ZFIELD        DDNPRAB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate remove request on rollover details.
      *
      **  Remove values of fields as requested.
     C     PTYP          IFEQ      63
     C     WNPRA1        ANDEQ     '*'
     C     WNDAM1        ANDEQ     '*'
     C     PTYP          OREQ      65
     C     WNPRA1        ANDEQ     '*'
     C     WNDAM1        ANDEQ     '*'
     C     PTYP          OREQ      67
     C     WNPRA1        ANDEQ     '*'
     C     WNDAM1        ANDEQ     '*'
     C                   Z-ADD     *ZEROS        VNPRAM
     C                   Z-ADD     *ZEROS        VNDAM
      *
      **  For Discount loans, if a '*' is in the first position
      **  of New principal amount, then New discount amount
      **  must have '*'s in its first positions.
     C                   ELSE
     C     PTYP          IFEQ      63
     C     WNPRA1        ANDNE     '*'
     C     WNDAM1        ANDNE     '*'
     C     PTYP          OREQ      65
     C     WNPRA1        ANDNE     '*'
     C     WNDAM1        ANDNE     '*'
     C     PTYP          OREQ      67
     C     WNPRA1        ANDNE     '*'
     C     WNDAM1        ANDNE     '*'
     C                   ELSE
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNPRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0468'
     C                   MOVE      'N'           DDNpraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNDAMB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV0468'                                  WA0025
     C                   MOVE      'N'           DDNdamOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE031
      * SRFAMT  - Calculate New Principal Amt. based on Facility FAMT *                       CLE031
      *****************************************************************                       CLE031
     C     SRFAMT        BEGSR                                                                CLE031
                                                                                              CLE031
     C                   Z-ADD     0             WLFAMT           13 0                        CLE031
     C                   Z-ADD     0             W#DRAW           13 0                        CLE031
      ** Access FCLTYFM record for facility amount FAMT                                       CLE031
     C                   MOVE      'A'           WRCTP                                        CLE031
     C**********         Z-ADD     FCUS          WFCUS                                CLE031 CSD027A
     C                   MOVE      FCUS          WFCUS                                       CSD027A
     C                   Z-ADD     FTYP          WFTYP                                        CLE031
     C                   Z-ADD     FSEQ          WFSEQ                                        CLE031
                                                                                              CLE031
     C     K#FCLT        CHAIN(N)  FCLTY                                                      CLE031
                                                                                              CLE031
     C                   IF        Not %FOUND(FCLTY)                                          CLE031
     C     *LOCK         IN        LDA                                                        CLE031
     C                   MOVEL     'FCLTY   '    DBFILE                                       CLE031
     C                   Z-ADD     91            DBASE                                        CLE031
     C                   MOVEL     FCTREC        DBKEY                                        CLE031
     C                   OUT       LDA                                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Access FCLTYFN record for drawn amount OAM2:                                         CLE031
                                                                                              CLE031
     C                   MOVE      'B'           WRCTP                                        CLE031
     C     K#FCLT        CHAIN(N)  FCLTY                                                      CLE031
                                                                                              CLE031
     C                   IF        Not %FOUND(FCLTY)                                          CLE031
     C     *LOCK         IN        LDA                                                        CLE031
     C                   MOVEL     'FCLTY   '    DBFILE                                       CLE031
     C                   Z-ADD     92            DBASE                                        CLE031
     C                   MOVEL     FCTREC        DBKEY                                        CLE031
     C                   OUT       LDA                                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Calculate the undrawn facility amount:                                               CLE031
                                                                                              CLE031
     C     F_OAM2        SUB       FPAM          W#DRAW                                       CLE031
     C     F_FAMT        SUB       W#DRAW        W#FAMT           13 0                        CLE031
                                                                                              CLE031
      ** Convert to Loan Currency using New Facility Ccy Exchange Rate:                       CLE031
                                                                                              CLE031
     C     WNFMDI        IFEQ      'M'                                                        CLE031
     C     W#FAMT        DIV(H)    WEXR15        WLFAMT                                       CLE031
     C                   ELSE                                                                 CLE031
     C     W#FAMT        MULT(H)   WEXR15        WLFAMT                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C     WLFAMT        IFLT      0                                                          CLE031
     C                   Z-ADD     0             WLFAMT                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************                       CLE031
      /EJECT                                                                                  CLE031
      *****************************************************************
      *                                                               *
      * SRNDAM - Validate New Discount Amount                         *
      *                                                               *
      *****************************************************************
 
     C     SRNDAM        BEGSR
      *
     C     WNDAM1        IFNE      '*'
     C                   MOVEL     CCY           PCURR
     C                   Z-ADD     101           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNDAMB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNDAM        ZFIELD
     C                   ENDIF
     C                   MOVE      A6NBDP        WNBDP
     C     13            SUB       WNBDP         ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNDAM            13 0
      *
      **  Forbidden for Non-discount loans.
      *
     C                   SELECT
     C     PTYP          WHENNE    63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNDAMB       ANDNE     *BLANKS
     C     PTYP          ORNE      63
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     67
     C     DDNDAM        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     PTYP          ORNE      63                                                         CLE030
     C     PTYP          ANDNE     65                                                         CLE030
     C     PTYP          ANDNE     67                                                         CLE030
     C     DDNDAM        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAMB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0466'
     C                   MOVE      'N'           DDNdamOK
      *
      **  Mandatory for Discount loans.
      *
     C     PTYP          WHENEQ    63
     C     DDNDAMB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      65
     C     DDNDAMB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      67
     C     DDNDAMB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     CLE031        ANDNE     'Y'                                                        CLE031
      *
     C     PTYP          OREQ      63
     C     DDNDAM        ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDRSTS        ANDNE     W_ReAutho                                                 BUG6926
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      65
     C     DDNDAM        ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      67
     C     DDNDAM        ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     CLE031        ANDNE     'Y'                                                        CLE031
      *                                                                                       CLE030
     C     PTYP          OREQ      63                                                         CLE030
     C     DDNDAM        ANDEQ     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      65                                                         CLE030
     C     DDNDAM        ANDEQ     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     PTYP          OREQ      67                                                         CLE030
     C     DDNDAM        ANDEQ     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CLE031        ANDNE     'Y'                                                        CLE031
                                                                                              CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     63                                                         CLE031
     C*****DDNDAM        ANDEQ     *Blanks                                             CLE031 CLE106
     C     DDNDAMB       ANDEQ     *Blanks                                                    CLE106
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     WVPRAM        ANDNE     *Zeros                                                     CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     65                                                         CLE031
     C*****DDNDAM        ANDEQ     *Blanks                                             CLE031 CEL106
     C     DDNDAMB       ANDEQ     *Blanks                                                    CLE106
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     WVPRAM        ANDNE     *Zeros                                                     CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     67                                                         CLE031
     C*****DDNDAM        ANDEQ     *Blanks                                             CLE031 CLE106
     C     DDNDAMB       ANDEQ     *Blanks                                                    CLE106
     C     DDACTN        ANDEQ     'A'                                                        CLE031
     C     WVPRAM        ANDNE     *Zeros                                                     CLE031
                                                                                              CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     63                                                         CLE031
     C     DDNDAM        ANDEQ     *Blanks                                                    CLE031
     C     DDACTN        ANDEQ     'X'                                                        CLE031
     C     DDNPRAM       ANDNE     *Blanks                                                    CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     65                                                         CLE031
     C     DDNDAM        ANDEQ     *Blanks                                                    CLE031
     C     DDACTN        ANDEQ     'X'                                                        CLE031
     C     DDNPRAM       ANDNE     *Blanks                                                    CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     PTYP          ANDEQ     67                                                         CLE031
     C     DDNDAM        ANDEQ     *Blanks                                                    CLE031
     C     DDACTN        ANDEQ     'X'                                                        CLE031
     C     DDNPRAM       ANDNE     *Blanks                                                    CLE031
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAMB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0462'
     C                   MOVE      'N'           DDNdamOK
      *
      **  Must be a valid numeric amount.
      *
     C     PTYP          WHENEQ    63
     C     ZALIGNok      ANDEQ     'N'
     C     PTYP          OREQ      65
     C     ZALIGNok      ANDEQ     'N'
     C     PTYP          OREQ      67
     C     ZALIGNok      ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAMB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0460'
     C                   MOVE      'N'           DDNdamOK
      *
      **  Must agree with the calculated discount amount
      **  within 1 unit of the loan currency.
      *
     C     PTYP          WHENEQ    63
     C     ZFIELD        ANDNE     *BLANKS
     C     PTYP          OREQ      65
     C     ZFIELD        ANDNE     *BLANKS
     C     PTYP          OREQ      67
     C     ZFIELD        ANDNE     *BLANKS
     C                   EXSR      SRNDAM2
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNdamOK      IFNE      'N'
     C     WNDAM         IFNE      *ZEROS
     C                   Z-ADD     WNDAM         VNDAM
     C                   EXSR      ZEDIT
     C     DDACTN        IFEQ      'A'
     C                   MOVE      ZFIELD        DDNDAMB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNDAM2 -  Check New Discount amount against calculated       *
      *                                                               *
      *****************************************************************
     C     SRNDAM2       BEGSR
      *
      **  Get the effective interest.
      *
     C                   EXSR      SREFFI
      *
      **  Calculate discount between rollover and
      **  next rollover dates.  If rollover date was
      **  not validated successfully use maturity date.
      *
      ** Calculate interest only if next rollover date has been entered
      *
     C     VNROD         IFGT      0
      *
     C     VRLDT         IFGT      *ZEROS
     C                   Z-ADD     VRLDT         ZIBEG
     C                   ELSE
     C                   Z-ADD     MDAT          ZIBEG
     C                   ENDIF
     C                   Z-ADD     CALC          ZICALC
     C                   Z-ADD     VNROD         ZIEND
     C                   Z-ADD     VNPRAM        ZIAMT
     C                   Z-ADD     WINTR         ZIRATE
     C                   EXSR      GLINTC
      *
      **  Round down interest if necessary.
      *
     C     RDFC          IFEQ      'Y'
     C                   Z-ADD     ZINTR         CHCKI            13 0
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         CHCKI
     C                   ENDIF
      *
      **  Check if entered New Discount amount is similar
      **  with the calculated within 1 unit.
      *
     C     CHCKI         IFLT      *ZERO
     C                   Z-SUB     CHCKI         CHCKI
     C                   ENDIF
     C     WNDAM         SUB       CHCKI         CHK2             13 0
     C     CHK2          IFLT      *ZERO
     C                   Z-SUB     CHK2          CHK2
     C                   ENDIF
     C     CHK2          IFGT      1
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAMB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0463'
     C                   MOVE      'N'           DDNdamOK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      CHCKI         ZFIELD
     C                   EXSR      ZEDIT
     C**********         MOVEL(P)  ZFIELD        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ZFIELD))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZFIELD)                   MD000091
     C                   ELSE
     C                   Z-ADD     WINTR         VINTR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREFFI  -  Calculate the Effective Interest                   *
      *                                                               *
      *****************************************************************
     C     SREFFI        BEGSR
      *
      **  No new rollover details entered.  Obtain base rate
      **  and spread/rate to be used in computation from file.
      *
     C     DDNBRAB       IFEQ      *BLANKS
     C     DDNRTSB       ANDEQ     *BLANKS
     C     DDNSINB       ANDEQ     *BLANK
     C     DDNCASB       ANDEQ     *BLANK
     C     DDNCHIB       ANDEQ     *BLANK
     C     DDACTN        ANDEQ     'A'
     C     DDNBRA        OREQ      *BLANKS
     C     DDNRTS        ANDEQ     *BLANKS
     C     DDNSIN        ANDEQ     *BLANK
     C     DDNCAS        ANDEQ     *BLANK
     C     DDNCHI        ANDEQ     *BLANK
     C     DDACTN        ANDEQ     'X'
     C     DDNBRA        OREQ      *BLANKS                                                    CLE030
     C     DDNRTS        ANDEQ     *BLANKS                                                    CLE030
     C     DDNSIN        ANDEQ     *BLANK                                                     CLE030
     C     DDNCAS        ANDEQ     *BLANK                                                     CLE030
     C     DDNCHI        ANDEQ     *BLANK                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      **  Next base rate code on file is blank.
     C     NBRA          IFEQ      *ZEROS
      *
      **  If next spread/rate and other related fields
      **  are blank, use old details from file.
     C     NRTS          IFEQ      *ZEROS
     C     NSIN          ANDEQ     *BLANK
     C     NCAS          ANDEQ     *ZERO
     C     NCHI          ANDEQ     *BLANK
     C                   MOVE      SPIN          SPRIND            1
     C                   Z-ADD     RTSP          SPREAD           11 7
     C                   MOVE      ICBS          CALC              1 0
     C                   Z-ADD     BRTE          BASE             11 7
     C                   ELSE
     C                   Z-ADD     *ZEROS        BASE
     C                   MOVE      NSIN          SPRIND
     C                   Z-ADD     NRTS          SPREAD
     C                   Z-ADD     NCAS          CALC
     C                   ENDIF
      *
      **  Next base rate code on file is not blank.
     C                   ELSE
      *
      **  Obtain new base rate base on the
      **  next base rate code.
     C                   MOVE      NBRA          PBRAT
      *                                                                                       WA0026
      * If multi-ccy validate against rollover currency for base                              WA0026
      * rate.                                                                                 WA0026
      *                                                                                       WA0026
     C     NCCY          IFEQ      *BLANKS                                                    WA0026
     C                   MOVE      CCY           PCURR                                        WA0026
     C                   ELSE                                                                 WA0026
     C                   MOVE      NCCY          PCURR                                        WA0026
     C                   ENDIF                                                                WA0026
      *                                                                                       WA0026
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C****************   PARM      CCY           PCURR                                        WA0026
     C                   PARM                    PCURR                                        WA0026
     C                   PARM                    PBRAT
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   Z-ADD     BANBRT        BASE
      *
      **  Apply new base rate if rollover date is earlier
      **  than base rate value date in the Base rate codes file.
     C     VRLDT         IFLT      BAVDNR
     C                   Z-ADD     BACBSR        BASE
     C                   ENDIF
     C                   MOVE      NSIN          SPRIND
     C                   Z-ADD     NRTS          SPREAD
     C                   Z-ADD     NCAS          CALC
     C                   ENDIF
     C                   ENDIF
      *
      **  Otherwise, obtain base rate and spread/rate
      **  from newly entered rollover details.
      **  If some amendable fields are blank,
      **  get its values from the file.
     C                   ELSE
     C                   MOVE      VNSIN         SPRIND
     C                   Z-ADD     VNRTS         SPREAD
     C                   Z-ADD     VNCAS         CALC
      *
      * Need to use the right field to retrive base rate code in
      * authorisation mode.
      *
     C*****DDACTN        IFEQ      'I'                                                        WA0026
     C     DDACTN        IFEQ      'A'                                                        WA0026
     C                   MOVE      DDNBRAB       W#BRAB            2
     C                   ELSE
     C                   MOVE      DDNBRA        W#BRAB
     C                   ENDIF
      *
     C     W#BRAB        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        BASE
     C                   ELSE
      *
      **  Apply new base rate if rollover date is earlier
      **  than base rate value date in the Base rate codes file.
     C     VRLDT         IFLT      BAVDNR
     C                   Z-ADD     BACBSR        BASE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Calculate interest rate to be used.
      ** Blank Spread indicator should be considered as 'A' to prevent                        CLE106
      ** zero interest rate.                                                                  CLE106
      *
     C                   SELECT
     C     SPRIND        WHENEQ    'A'
     C     SPRIND        OREQ      ' '                                                        CLE106
     C     BASE          ADD       SPREAD        WINTR
     C     SPRIND        WHENEQ    'S'
     C     BASE          SUB       SPREAD        WINTR
     C     SPRIND        WHENEQ    'P'
     C     SPREAD        DIV       100           WRK139           13 9
     C     WRK139        MULT(H)   BASE          WINTR            11 7
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNCCY - Validate New Currency                                *
      *                                                               *
      *****************************************************************
 
     C     SRNCCY        BEGSR
      *
     C     WNCCY1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
      *
     C                   MOVE      *OFF          *IN85
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     DDNCCYB       PCURR
     C                   ELSE
     C                   MOVEL     DDNCCY        PCURR
     C                   ENDIF
     C                   MOVE      *BLANKS       A6CYCD
     C** No database error, error message displayed
     C                   MOVE      *OFF          EDBAS
     C                   EXSR      SRCURR
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     PCURR         DDNCCYB
     C                   ENDIF
     C     PRTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDNCCYB
     C                   ENDIF
     C     WNCCY1        IFEQ      '?'
     C                   MOVE      *ON           SELDON
     C                   ENDIF
     C     PRTCD         IFEQ      *BLANKS
     C     F_CSEL        IFEQ      'Y'
     C     DDACTN        IFEQ      'A'
     C     DDNCCYB       LOOKUP    ACCYA                                  85    *on means found
     C                   ELSE
     C     DDNCCY        LOOKUP    ACCYA                                  85    *on means found
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN85
     C                   ENDIF
      *
      ** If CEU020 is installed allow new currency to be equal to Euro
      ** if rolling over from 'IN' currency.
      *
     C     CEU020        IFEQ      'Y'
     C     *IN85         ANDEQ     '0'
     C     DDACTN        ANDEQ     'A'
     C     DDNCCYB       ANDNE     *BLANKS
     C     DDNCCYB       IFEQ      BKEURO
     C     WINCY         IFEQ      'Y'
     C                   MOVE      '1'           *IN85
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C     DDNCCYB       WHENEQ    *BLANKS
     C     DDNCCY        OREQ      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNCCY        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      **  Must be a valid currency code and specified
      **  in the facility to which the loan is linked.
      *
     C     DDNCCYB       WHENNE    *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDNCCY        ORNE      *BLANKS
     C     *IN85         ANDEQ     *OFF
     C     DDACTN        ANDEQ     'X'
     C     DDNCCY        ORNE      *BLANKS                                                    CLE030
     C     *IN85         ANDEQ     *OFF                                                       CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CEU020        IFEQ      'Y'
     C     WINCY         ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0022'
     C                   MOVE      'N'           DDNccyOK
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1023'
     C                   MOVE      'N'           DDNccyOK
     C                   ENDIF
      *
      **  Must not be equal to new currency in the file
      **  or not equal to the loan currency.
      **  except when in batch mode, where it is allowed
      *
     C     DDNCCYB       WHENNE    *BLANKS
     C     NCCY          ANDNE     *BLANKS
     C     NCCY          ANDEQ     DDNCCYB
     C     DDACTN        ANDEQ     'A'
     C     DDNCCYB       ORNE      *BLANKS
     C     CCY           ANDEQ     DDNCCYB
     C     DDACTN        ANDEQ     'A'
     C     DDNCCY        ORNE      *BLANKS
     C     CCY           ANDEQ     DDNCCY
     C     DDACTN        ANDEQ     'X'
     C     DDNCCY        ORNE      *BLANKS                                                    CLE030
     C     CCY           ANDEQ     DDNCCY                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1036'
     C                   MOVE      'N'           DDNccyOK
                                                                                             BUG2579
     C     DDNCCYB       WHENNE    *BLANKS                                                   BUG2579
     C     NCCY          ANDEQ     *BLANKS                                                   BUG2579
     C     NFCE          ANDNE     *ZERO                                                     BUG2579
     C     WFCXRA        ANDEQ     'N'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1055'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
                                                                                             BUG2579
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNccyOK      IFNE      'N'
     C                   MOVE      DDNCCYB       VNCCY
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      DDNCCY        VNCCY
     C                   ENDIF
     C                   MOVE      A6MDIN        WMDIN             1
     C                   Z-ADD     A6SPRT        WSPRT            13 8
     C                   Z-ADD     A6NBDP        W#PWR             1 0
     C                   ENDIF
     C                   ENDIF
      *
      **  If one multi-ccy detail is to be removed,
      **  all of them must be removed.
      *
     C     WNCCY1        IFEQ      '*'
     C     WNCPA1        ANDEQ     '*'
     C     WNFCE1        ANDEQ     '*'
     C     WNFMD1        ANDEQ     '*'
     C     WNBCE1        ANDEQ     '*'
     C     WNBMD1        ANDEQ     '*'
     C     WNLRA1        ANDEQ     '*'
     C                   MOVE      *BLANKS       VNCCY
     C                   Z-ADD     *ZEROS        VNCPA
     C                   Z-ADD     *ZEROS        VNFCE
     C                   MOVE      *BLANK        VNFMD
     C                   Z-ADD     *ZEROS        VNBCE
     C                   MOVE      *BLANK        VNBMD
     C                   Z-ADD     *ZEROS        VNLRA
     C                   ELSE
     C     WNCCY1        IFNE      '*'
     C     WNCPA1        ANDNE     '*'
     C     WNFCE1        ANDNE     '*'
     C     WNFMD1        ANDNE     '*'
     C     WNBCE1        ANDNE     '*'
     C     WNBMD1        ANDNE     '*'
     C     WNLRA1        ANDNE     '*'
     C                   ELSE
     C     MULTIC        IFEQ      *ON
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
                                                                                             BUG2579
     C     MULTIC        OREQ      *ON                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     DDNCCY        ANDNE     *BLANKS                                                   BUG2579
                                                                                             BUG2579
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1034'
     C                   MOVE      'N'           DDNccyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNcpaOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNfceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNfmdOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNlraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNbceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1034'                                  WA0025
     C                   MOVE      'N'           DDNbmdOK
                                                                                             BUG2579
      ** If removal of fields is not for multi-currency details, check                       BUG2579
      ** if this is for facility currency exchange rate details                              BUG2579
                                                                                             BUG2579
     C                   ELSE                                                                BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
                                                                                             BUG2579
     C     WNFCE1        IFEQ      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
     C                   Z-ADD     *ZEROS        VNFCE                                       BUG2579
     C                   MOVE      *BLANK        VNFMD                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C     WNFCE1        IFEQ      '*'                                                       BUG2579
     C     WNFMD1        ANDNE     '*'                                                       BUG2579
     C     WNFCE1        ORNE      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1052'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  If New currency was not entered, other multi-ccy
      **  details are forbidden.
      *
     C     DDNCCYB       IFEQ      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDNCPAB       IFNE      *BLANKS
     C     DDNFCEB       ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNFMDB       ORNE      *BLANK
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNBCEB       ORNE      *BLANKS
     C     DDNBMDB       ORNE      *BLANK
     C     DDNLRAB       ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1035'
     C                   MOVE      'N'           DDNccyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNcpaOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNfceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNfmdOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNlraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNbceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNBMDOK
     C                   ENDIF
     C                   ENDIF
      *
     C     DDNCCY        IFEQ      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNCCY        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDNCPA        IFNE      *BLANKS
     C     DDNFCE        ORNE      *BLANKS
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNFMD        ORNE      *BLANK
     C     *IN67         ANDEQ     *OFF                                                      BUG2579
     C     DDNBCE        ORNE      *BLANKS
     C     DDNBMD        ORNE      *BLANK
     C     DDNLRA        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1035'
     C                   MOVE      'N'           DDNccyOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNCPAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNcpaOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNfceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNfmdOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNLRAB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNlraOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBCEB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNbceOK
      *
     C***********        ADD       1             Idx                                          WA0025
     C***********        EVAL      FldNameArr(Idx) = 'DDNBMDB'                                WA0025
     C***********        EVAL      MsgIDArr(Idx) = 'LEV1035'                                  WA0025
     C                   MOVE      'N'           DDNbmdOK
     C                   ENDIF
     C                   ENDIF
      *
      **  An '* is not allowed if New currency is already blank
      *
     C     WNCCY1        IFEQ      '*'
     C     DDNCCY        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCCYB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV2000'
     C                   MOVE      'N'           DDNccyOK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNCPA - Validate New Currency Amount                         *
      *                                                               *
      *****************************************************************
 
     C     SRNCPA        BEGSR
      *
     C     WNCPA1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
     C                   MOVEL     VNCCY         PCURR
     C** No database error, error message displayed
     C                   MOVE      *OFF          EDBAS
     C                   EXSR      SRCURR
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNCPAB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNCPA        ZFIELD
     C                   ENDIF
     C                   MOVE      A6NBDP        WNBDP
     C     13            SUB       WNBDP         ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNCPA            13 0
      *
      ** Set flag if rollover is EMU multi-ccy rollover
      *
     C                   MOVE      'N'           WDFLT             1
      *
     C     CEU020        IFEQ      'Y'
     C     DDNCCYB       ANDEQ     BKEURO
     C     DDACTN        ANDEQ     'A'
     C     CEU020        OREQ      'Y'
     C     DDNCCY        ANDEQ     BKEURO
     C     DDACTN        ANDEQ     'X'
     C     CEU020        OREQ      'Y'                                                        CLE030
     C     DDNCCY        ANDEQ     BKEURO                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C                   MOVEL     CCY           PCURR
     C** No database error, error message displayed
     C                   MOVE      *OFF          EDBAS
     C                   EXSR      SRCURR
      *
     C     A6INCY        IFNE      'Y'
     C                   MOVE      'N'           WDFLT
     C                   ELSE
     C                   MOVE      'Y'           WDFLT
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           WDFLT             1
     C                   ENDIF
      *
      **  Mandatory if new currency was entered.
      *
     C                   SELECT
     C     DDNCPAB       WHENEQ    *BLANKS
     C     DDNCCYB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     WDFLT         ANDEQ     'N'
     C     DDNCPA        OREQ      *BLANKS
     C     DDNCCY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     WDFLT         ANDEQ     'N'
     C     DDNCPA        OREQ      *BLANKS                                                    CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     WDFLT         ANDEQ     'N'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCPAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1024'
     C                   MOVE      'N'           DDNcpaOK
      *
      **  Must be a valid numeric amount.
      *
     C     DDNCPAB       WHENNE    *BLANKS
     C     VNCCY         ANDNE     *BLANKS
     C     ZALIGNok      ANDEQ     'N'
     C     DDNCPA        ORNE      *BLANKS
     C     VNCCY         ANDNE     *BLANKS
     C     ZALIGNok      ANDEQ     'N'
     C     DDACTN        ANDEQ     'X'
     C     DDNCPA        ORNE      *BLANKS                                                    CLE030
     C     VNCCY         ANDNE     *BLANKS                                                    CLE030
     C     ZALIGNok      ANDEQ     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCPAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1025'
     C                   MOVE      'N'           DDNcpaOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNcpaOK      IFNE      'N'
     C     DDNCPAB       IFNE      *BLANKS
     C     DDNCPA        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNCPA        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     WNCPA         VNCPA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNFCE - Validate New Exchange Rate                           *
      *                                                               *
      *****************************************************************
 
     C     SRNFCE        BEGSR
      *
     C     WNFCE1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C     WNFCE1        ORNE      '*'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
      *
      **  Must be a valid rate amount.
      *
     C     DDNFCEB       IFNE      *BLANKS
     C     DDNFCE        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNFCE        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
                                                                                             BUG2579
      ** If CLE023 is installed and facility is multi-currency,                              BUG2579
      ** entry on facility currency exchange rate is forbidden if                            BUG2579
      ** loan currency is the same with facility currency.  Also if                          BUG2579
      ** Facility exchange rate allowed flag is 'N'.                                         BUG2579
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     DDNCCYB       ANDEQ     *BLANKS                                                   BUG2579
     C     DDNCCY        ANDEQ     *BLANKS                                                   BUG2579
     C     CCY           IFEQ      FCCY                                                      BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1051'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
                                                                                             BUG2579
     C                   ELSE                                                                BUG2579
     C     WFCXRA        IFEQ      'N'                                                       BUG2579
     C     DDACTN        ANDEQ     'A'                                                       BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1053'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
      ** If multi-currency details were previously entered and new                           BUG2579
      ** facility exchange rate and indicator was entered but other                          BUG2579
      ** multi currency details are not, issue an error msg.                                 BUG2579
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     DDNCCY        ANDNE     *BLANKS                                                   BUG2579
     C     DDNCCY        ANDNE     CCY                                                       BUG2579
     C     DDNCCYB       ANDEQ     *BLANKS                                                   BUG2579
     C     DDNBCEB       ANDEQ     *BLANKS                                                   BUG2579
     C     DDNBMDB       ANDEQ     *BLANK                                                    BUG2579
     C     DDNLRAB       ANDEQ     *BLANKS                                                   BUG2579
     C     DDNFCEB       ANDNE     *BLANKS                                                   BUG2579
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1056'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C*****DDNfceOK      IFEQ      'Y'                                               BUG2579 BUG4493
     C     DDNfceOK      IFNE      'N'
      *
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNFCEB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNFCE        ZFIELD
     C                   ENDIF
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1027'
     C                   MOVE      'N'           DDNfceOK
     C                   ELSE
     C                   MOVE      ZFIELD        VNFCE
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C     DDACTN        IFEQ      'A'
     C                   MOVE      ZFIELD        DDNFCEB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                               BUG2579
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNFMD - Validate Exchange Rate Indicator                     *
      *                                                               *
      *****************************************************************
 
     C     SRNFMD        BEGSR
      *
     C     WNFMD1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
     C     *IN61         ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
     C     WNFMD1        ORNE      '*'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
      *
      **  Default to 'M'
     C                   SELECT
     C     DDNFMDB       WHENEQ    *BLANK
     C     DDNFCEB       ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C                   MOVE      'M'           DDNFMDB           1
     C     CEU020        IFEQ      'Y'
     C     MULTIC        ANDEQ     *ON                                                       BUG2579
     C     DDNccyOK      ANDNE     'N'                                                       BUG2579
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C     A6INCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      A6EUMD        DDNFMDB
     C                   ENDIF
      *
      **  Forbidden if exchange rate not entered.
      *
     C     DDNFMDB       WHENNE    *BLANK
     C     DDNFCEB       ANDEQ     *BLANKS
     C     DDNFMD        ORNE      *BLANK
     C     DDNFCE        ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNFMD        ORNE      *BLANK                                                     CLE030
     C     DDNFCE        ANDEQ     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1028'
     C                   MOVE      'N'           DDNfmdOK
      *
      **  Must be 'M' or 'D'.
      *
     C     DDNFCEB       WHENNE    *BLANKS
     C     WNFCE1        ANDNE     '*'                                                       BUG2579
     C     DDNFMDB       ANDNE     'M'
     C     DDNFMDB       ANDNE     'D'
     C     DDNFCE        ORNE      *BLANKS
     C     DDNFMD        ANDNE     'M'
     C     DDNFMD        ANDNE     'D'
     C     DDACTN        ANDEQ     'X'
     C     DDNFCE        ORNE      *BLANKS                                                    CLE030
     C     DDNFMD        ANDNE     'M'                                                        CLE030
     C     DDNFMD        ANDNE     'D'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1029'
     C                   MOVE      'N'           DDNfmdOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNfceOK      IFNE      'N'
     C                   MOVE      DDNFMDB       VNFMD
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      DDNFMD        VNFMD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Further validation on exchange rate/indicator and amount
      *
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     WNFCE1        IFEQ      '*'                                                       BUG2579
     C     WNFMD1        ANDNE     '*'                                                       BUG2579
     C     *IN61         ANDEQ     *OFF                                                      BUG2579
     C     WNFCE1        ORNE      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
     C     *IN61         ANDEQ     *OFF                                                      BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1052'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C     WNFCE1        IFEQ      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C     DDNCCY        ANDEQ     *BLANKS                                                   BUG2579
     C     WNFCE1        OREQ      '*'                                                       BUG2579
     C     WNFMD1        ANDEQ     '*'                                                       BUG2579
     C     *IN61         ANDEQ     *OFF                                                      BUG2579
                                                                                             BUG2579
     C     WFCXRA        IFEQ      'N'                                                       BUG2579
     C                   ADD       1             Idx                                         BUG2579
     C                   EVAL      FldNameArr(Idx) = 'DDNFCEB'                               BUG2579
     C                   EVAL      MsgIDArr(Idx) = 'LEV1054'                                 BUG2579
     C                   MOVE      'N'           DDNfceOK                                    BUG2579
     C                   MOVE      'N'           DDNfmdOK                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   Z-ADD     *ZEROS        VNFCE                                       BUG2579
     C                   MOVE      *BLANK        VNFMD                                       BUG2579
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   MOVE      'N'           WMCCY             1                         BUG2579
     C     DDNccyOK      IFNE      'N'
     C     DDNfceOK      ANDNE     'N'
     C     DDNfmdOK      ANDNE     'N'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCPA1        ANDNE     '*'
     C     WNFCE1        ANDNE     '*'
     C     WNFMD1        ANDNE     '*'
     C     *IN61         ANDEQ     *ON                                                       BUG2579
      *
     C     DDNccyOK      ORNE      'N'
     C     DDNfceOK      ANDNE     'N'
     C     DDNfmdOK      ANDNE     'N'
     C     DDNCCY        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     *IN61         ANDEQ     *ON                                                       BUG2579
      *                                                                                       CLE030
     C     DDNccyOK      ORNE      'N'                                                        CLE030
     C     DDNfceOK      ANDNE     'N'                                                        CLE030
     C     DDNfmdOK      ANDNE     'N'                                                        CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C                   MOVE      'Y'           WMCCY                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C     WMCCY         IFEQ      'Y'                                                       BUG2579
     C     *IN67         OREQ      *ON                                                       BUG2579
     C     DDNfceOK      ANDNE     'N'                                                       BUG2579
     C     DDNfmdOK      ANDNE     'N'                                                       BUG2579
     C     CCY           ANDNE     FCCY                                                      BUG2579
     C     WNFCE1        ANDNE     '*'                                                       BUG2579
     C     WFCXRA        ANDEQ     'Y'                                                       BUG2579
     C                   EXSR      SRRATE
     C                   MOVE      PRATEX        WNFCRT           13 8
     C                   ENDIF
      *
      **  When rolling over from 'In' ccy to Euro, exchange rate is not
      **  amendable
      *
                                                                                             BUG2579
      ** An exchange rate can be entered for non-EMU multi-currency                          BUG2579
      ** rollover, as long as it is within 25% of that calculated by                         BUG2579
      ** the program.                                                                        BUG2579
                                                                                             BUG2579
     C     CEU020        IFEQ      'Y'
     C     WNFCE1        ANDNE     '*'
     C     WINCY         ANDEQ     'Y'
     C     VNFCE         ANDNE     PRATEX
     C     *IN61         ANDEQ     *ON                                                       BUG2579
     C     VNCCY         ANDNE     *BLANKS                                                   BUG2579
                                                                                             BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     WNFCE1        ANDNE     '*'                                                       BUG2579
     C     VNFCE         ANDNE     PRATEX                                                    BUG2579
     C     VNFCE         ANDNE     *ZEROS                                                    BUG2579
     C     VNCCY         ANDEQ     *BLANKS                                                   BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
     C     DDACTN        IFEQ      'A'
     C*****DDNCCYB       ANDNE     *BLANKS                                                   BUG2579
     C     DDNCCYB       ANDEQ     BKEURO                                                    BUG2579
     C     BKEURO        ANDNE     *BLANKS                                                   BUG2579
                                                                                             BUG2579
     C     DDACTN        OREQ      'X'
     C*****DDNCCY        ANDNE     *BLANKS                                                   BUG2579
     C     DDNCCY        ANDEQ     BKEURO                                                    BUG2579
     C     BKEURO        ANDNE     *BLANKS                                                   BUG2579
                                                                                             BUG2579
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    CLE030
     C     BKEURO        ANDNE     *BLANKS                                                   BUG2579
     C     CLE030        ANDEQ     'Y'                                                        CLE030
                                                                                             BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     CCY           ANDEQ     BKEURO                                                    BUG2579
     C     WINCYF        ANDEQ     'Y'                                                       BUG2579
                                                                                             BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     FCCY          ANDEQ     BKEURO                                                    BUG2579
     C     WINCYL        ANDEQ     'Y'                                                       BUG2579
                                                                                             BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     WINCYL        ANDEQ     'Y'                                                       BUG2579
     C     WINCYF        ANDEQ     'Y'                                                       BUG2579
 
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0023'
     C                   MOVE      'N'           DDNfmdOK
      *
     C                   ENDIF
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNBCE - Validate Base Ccy Exchange Rate                      *
      *                                                               *
      *****************************************************************
 
     C     SRNBCE        BEGSR
      *
     C     WNBCE1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
      *
      **  Must be a valid rate amount.
      *
     C     DDNBCEB       IFNE      *BLANKS
     C     DDNBCE        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNBCE        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNBCEB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNBCE        ZFIELD
     C                   ENDIF
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBCEB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1027'
     C                   MOVE      'N'           DDNbceOK
     C                   ELSE
     C                   MOVE      ZFIELD        VNBCE
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C     DDACTN        IFEQ      'A'
     C                   MOVE      ZFIELD        DDNBCEB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNBMD - Validate Base Ccy Exchange Rate Indicator            *
      *                                                               *
      *****************************************************************
 
     C     SRNBMD        BEGSR
      *
     C     WNBMD1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
      *
      **  Forbidden if exchange rate not entered.
      **  Must be 'M' or 'D' if entered
      *
     C     DDNBMDB       IFNE      *BLANK
     C     DDNBMD        ORNE      *BLANK
     C     DDACTN        ANDEQ     'X'
     C     DDNBMD        ORNE      *BLANK                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   SELECT
     C     DDNBCEB       WHENEQ    *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDNBCE        OREQ      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNBCE        OREQ      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1028'
     C                   MOVE      'N'           DDNbmdOK
     C     DDNBMDB       WHENNE    'M'
     C     DDNBMDB       ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
     C     DDNBMD        ORNE      'M'
     C     DDNBMD        ANDNE     'D'
     C     DDACTN        ANDEQ     'X'
     C     DDNBMD        ORNE      'M'                                                        CLE030
     C     DDNBMD        ANDNE     'D'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1029'
     C                   MOVE      'N'           DDNbmdOK
     C                   ENDSL
      *
      **  When rolling over from 'In' ccy to Euro, exchange rate is not
      **  amendable
      *
     C     CEU020        IFEQ      'Y'
     C     WNBCE1        ANDNE     '*'
     C     WINCY         ANDEQ     'Y'
     C     VNBCE         ANDNE     WSPRT
     C     DDACTN        IFEQ      'A'
     C     DDNCCYB       ANDNE     *BLANKS
     C     DDACTN        OREQ      'X'
     C     DDNCCY        ANDNE     *BLANKS
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     DDNCCY        ANDNE     *BLANKS                                                    CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNBMDB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV0024'
     C                   MOVE      'N'           DDNbmdOK
      *
     C                   ENDIF
     C                   ENDIF
      *
      *
      **  Default to spot rate and indicator from new ccys record
      **  if rate is blank, otherwise, default to 'M'
      *
     C                   ELSE
     C     DDNCCYB       IFNE      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C                   MOVE      'M'           DDNBMDB
     C                   MOVE      DDNBMDB       VNBMD
     C     DDNBCEB       IFEQ      *BLANKS
     C                   MOVE      WMDIN         DDNBMDB
     C                   MOVE      WMDIN         VNBMD
     C                   Z-ADD     WSPRT         VNBCE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WSPRT         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNBCEB
     C                   ENDIF
     C                   ENDIF
      *
      **  Default mult/div indicator if base ccy is Euro
      *
     C     BJCYCD        IFEQ      BKEURO
     C     WDFLT         ANDEQ     'Y'
     C                   MOVE      'D'           DDNBMDB
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If no errors
      *
     C     DDNbmdOK      IFNE      'N'
     C                   MOVE      DDNBMDB       VNBMD
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      DDNBMD        VNBMD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNLRA - Validate Next Loan Ccy Repayment Amount              *
      *                                                               *
      *****************************************************************
 
     C     SRNLRA        BEGSR
      *
     C     WNLRA1        IFNE      '*'
     C     MULTIC        ANDEQ     *ON
     C     DDNccyOK      ANDNE     'N'
     C                   MOVEL     VNCCY         PCURR
     C** No database error, error message displayed
     C                   MOVE      *OFF          EDBAS
     C                   EXSR      SRCURR
      *
      **  Default new loan repayment amount if blanks and next
      **  repayment date is not equal to zero only for EMU multi-ccy
      **  rollover
      *
     C     WDFLT         IFEQ      'Y'
     C     NRPD          ANDNE     *ZEROS
     C     DDNLRAB       ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'
     C                   MOVEL     CCY           PCURR
     C** No database error, error message displayed
     C                   MOVE      *OFF          EDBAS
     C                   EXSR      SRCURR
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      RAMT          PFRAM            18 3
     C                   PARM      CCY           PFRCY             3
     C                   PARM      VNCCY         PTOCY             3
     C                   PARM                    POUTA            15 0
     C                   PARM                    PINTA            18 3
     C                   PARM                    PEXRT            15 9
     C                   PARM                    PMDIN             1
     C                   Z-ADD     POUTA         VNLRA
     C                   Z-ADD     POUTA         WNLRA
     C                   MOVEL     VNCCY         PCURR
     C                   Z-ADD     102           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      POUTA         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNLRAB
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD
     C     DDACTN        IFEQ      'A'
     C                   MOVE      DDNLRAB       ZFIELD
     C                   ELSE
     C                   MOVE      DDNLRA        ZFIELD
     C                   ENDIF
     C                   MOVE      A6NBDP        WNBDP
     C     13            SUB       WNBDP         ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNLRA            13 0
      *
      **  Mandatory if new currency was entered
      **  and/or repayment schedule is defined.
     C                   SELECT
     C     DDNLRAB       WHENEQ    *BLANKS
     C     DDNCCYB       ANDNE     *BLANK
     C     NRPD          ANDNE     *ZEROS
     C     WDFLT         ANDEQ     'N'
     C     WNLRA         OREQ      *ZEROS
     C     DDNCCYB       ANDNE     *BLANK
     C     NRPD          ANDNE     *ZEROS
     C     ZALIGNok      ANDEQ     'Y'
      *
     C     NLRA          OREQ      *ZEROS
     C     DDNCCY        ANDNE     *BLANK
     C     NRPD          ANDNE     *ZEROS
     C     DDACTN        ANDEQ     'X'
      *                                                                                       CLE030
     C     NLRA          OREQ      *ZEROS                                                     CLE030
     C     DDNCCY        ANDNE     *BLANK                                                     CLE030
     C     NRPD          ANDNE     *ZEROS                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNLRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1030'
     C                   MOVE      'N'           DDNlraOK
      *
      **  Must be a valid numeric amount.
     C     DDNLRAB       WHENNE    *BLANKS
     C     VNCCY         ANDNE     *BLANKS
     C     ZALIGNok      ANDEQ     'N'
     C     DDNLRA        WHENNE    *BLANKS
     C     VNCCY         ANDNE     *BLANKS
     C     ZALIGNok      ANDEQ     'N'
     C     DDACTN        ANDEQ     'X'
     C     DDNLRA        WHENNE    *BLANKS                                                    CLE030
     C     VNCCY         ANDNE     *BLANKS                                                    CLE030
     C     ZALIGNok      ANDEQ     'N'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNLRAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1032'
     C                   MOVE      'N'           DDNlraOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNlraOK      IFNE      'N'
     C     DDNLRAB       IFNE      *BLANKS
     C     DDNLRA        ORNE      *BLANKS
     C     DDACTN        ANDEQ     'X'
     C     DDNLRA        ORNE      *BLANKS                                                    CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     WNLRA         VNLRA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNFSN - Validate Funding Spread Sign                         *
      *                                                               *
      *****************************************************************
 
     C     SRNFSN        BEGSR
      *
      *
     C     *IN62         IFEQ      *ON
      *
      **  Must be either '+', '-', or blank.
     C                   SELECT
     C     DDNFSNB       WHENNE    '+'
     C     DDNFSNB       ANDNE     '-'
     C     DDNFSNB       ANDNE     *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFSNB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1019'
     C                   MOVE      'N'           DDNfsnOK
      *
      **  Forbidden if funding spread/rate not entered.
     C     DDNFSNB       WHENNE    *BLANK
     C     DDNFRSB       ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFSNB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1020'
     C                   MOVE      'N'           DDNfsnOK
     C                   ENDSL
      *
      * If no errors
      *
     C     DDNfsnOK      IFNE      'N'
     C                   MOVE      DDNFSNB       VNFSN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNFRS - Validate Funding Spread Rate                         *
      *                                                               *
      *****************************************************************
 
     C     SRNFRS        BEGSR
      *
     C     *IN62         IFEQ      *ON
     C     DDNFRSB       ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNFRSB       ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNFRS            11 7
      *
      **  Must be a valid rate amount.
     C     ZALIGNok      IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNFRSB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1021'
     C                   MOVE      'N'           DDNfrsOK
     C                   ENDIF
      *
      * If no errors
      *
     C     DDNfrsOK      IFNE      'N'
     C                   Z-ADD     WNFRS         VNFRS
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVFD  -  Define Removeable fields                           *
      *                                                               *
      *****************************************************************
     C     SRRVFD        BEGSR
      *
      **  Rollover date
     C                   MOVEL     DDRLDTB       WRLDT1            1
      *
      **  Rollover frequency and day number
     C                   MOVEL     DDRLFQB       WRLFQ1            1
     C                   MOVEL     DDRLDYB       WRLDY1            1
      *
      **  New base rate
     C                   MOVEL     DDNBRAB       WNBRA1            1
      *
      **  New spread/rate and spread indicator
     C                   MOVEL     DDNRTSB       WNRTS1            1
     C                   MOVEL     DDNSINB       WNSIN1            1
      *                                                                                       CLE035
     C                   IF        CLE036 = 'Y'                                              BUG9655
      **  New fixed rate                                                                      CLE035
     C                   MOVEL     DDNRTFB       WNRTF1            1                          CLE035
      *                                                                                       CLE035
      **  New base rate                                                                       CLE035
     C                   MOVEL     DDNBRTB       WNBRT1            1                          CLE035
     C                   ENDIF                                                               BUG9655
      *
      **  New interest calculation basis
     C                   MOVEL     DDNCASB       WNCAS1            1
      *
      **  New change indicator
     C                   MOVEL     DDNCHIB       WNCHI1            1
      *
      **  Next rollover date
     C                   MOVEL     DDNRODB       WNROD1            1
                                                                                              BUG827
      **  New Forward Yield Curve                                                             BUG827
     C     @FYIELD       IFEQ      'Y'                                                        BUG827
     C                   MOVEL     DDFYLDB       WNFYLD            1                          BUG827
     C                   ENDIF                                                                BUG827
      *
      **  Principal
     C                   MOVEL     DDNPRAB       WNPRA1            1
      *
      **  New discount amount
     C                   MOVEL     DDNDAMB       WNDAM1            1
      *
      **  New interest and maturity date - for S01465
     C     *IN60         IFEQ      *ON
     C                   MOVEL     DDNIPDB       WNIPD1            1
     C                   MOVEL     DDNMDTB       WNMDT1            1
     C                   ENDIF
      *
      **  For multi-ccy rolover
      *
      **  New currency
     C     *IN61         IFEQ      *ON
     C                   MOVEL     DDNCCYB       WNCCY1            1
      *
      **  New currency amount
     C                   MOVEL     DDNCPAB       WNCPA1            1
      *
      **  Exchange rate
     C                   MOVEL     DDNFCEB       WNFCE1            1
      *
      **  Exchange rate indicator
     C                   MOVEL     DDNFMDB       WNFMD1            1
      *
      **  Base ccy exchange rate
     C                   MOVEL     DDNBCEB       WNBCE1            1
      *
      **  Base ccy exchange rate indicator
     C                   MOVEL     DDNBMDB       WNBMD1            1
      *
      **  Next loan currency repayment amount.
     C                   MOVEL     DDNLRAB       WNLRA1            1
     C                   ELSE                                                                BUG2579
                                                                                             BUG2579
      ** Facility exchange rate and indicator if CLE023 is installed                         BUG2579
      ** and facility is multi-currency                                                      BUG2579
                                                                                             BUG2579
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C                   MOVEL     DDNFCEB       WNFCE1            1                         BUG2579
     C                   MOVEL     DDNFMDB       WNFMD1            1                         BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ENDIF
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVEL     DDCNS2B       WCNS2             1                          CRE073
     C                   MOVEL     DDCNG2B       WCNG2             1                          CRE073
     C                   MOVEL     DDRDM2B       WRDM2             1                          CRE073
     C                   MOVEL     DDRDF2B       WRDF2             1                          CRE073
     C                   ENDIF                                                                CRE073
 
      /COPY WNCPYSRC,LELERIV064
 
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE1 - Validate & convert date to a day number              *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    Zdate             6
     C                   PARM                    Zdayno
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZALIGN - Validate decimal places                             *
      *                                                               *
      *****************************************************************
     C     ZALIGN        BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *
      *                                                               *
      *****************************************************************
     C     ZFREQB        BEGSR
 
     C                   CallB     'ZFREQB'
     C                   Parm      *blanks       RetCodeIn
     C                   Parm                    ZFREQ             1
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZCCY              3
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   Parm                    ZMDAY             2 0
     C                   Parm                    BJDFIN
     C                   Parm      SDGELR        SDGELR
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFWDT - Calculate Working days forward                        *
      *                                                               *
      *****************************************************************
     C     ZFWDT         BEGSR
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRINIW  -  Clear Work fields                                  *
      *                                                               *
      *****************************************************************
     C     SRINIW        BEGSR
      *
      ** Check if BLI Lending Enhancements feature is installed                              BUG2579
                                                                                             BUG2579
     C     S01465        IFEQ      'Y'                                                       BUG2579
     C                   MOVE      *ON           *IN60                                       BUG2579
     C                   END                                                                 BUG2579
                                                                                             BUG2579
      ** Check if Multi-currency allowed by Loan facility                                    BUG2579
                                                                                             BUG2579
     C     @MULTI        IFEQ      'Y'                                                       BUG2579
     C                   MOVE      *ON           *IN61                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      *OFF          *IN61                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
      ** Check if Facility Exchange Rate is allowed (CLE023)                                 BUG2579
                                                                                             BUG2579
     C     @FCXRATE      IFEQ      'Y'                                                       BUG2579
     C                   MOVE      *ON           *IN67                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      *OFF          *IN67                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
      ** Check if Funding Details are required                                               BUG2579
                                                                                             BUG2579
     C     @FUNDING      IFEQ      'Y'                                                       BUG2579
     C                   MOVE      *ON           *IN62                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
      ** Check if Rollover rate fixing day enhancement - CLE011                              BUG2579
      ** feature is installed                                                                BUG2579
                                                                                             BUG2579
     C     CLE011        IFEQ      'Y'                                                       BUG2579
     C                   MOVE      *ON           *IN63                                       BUG2579
     C                   END                                                                 BUG2579
                                                                                             BUG2579
     C                   Z-ADD     *ZEROS        VRLDT             5 0
     C                   MOVE      *BLANK        VRLFQ             1
     C                   Z-ADD     *ZEROS        VRLDY             2 0
     C                   Z-ADD     *ZEROS        VNBRA             2 0
     C                   Z-ADD     *ZEROS        VNRTS            11 7
     C                   Z-ADD     *ZEROS        VNRTF            11 7                        CLE035
     C                   Z-ADD     *ZEROS        VNBRT            11 7                        CLE035
     C                   MOVE      *BLANK        VNSIN             1
     C                   Z-ADD     *ZERO         VNCAS             1 0
     C                   MOVE      *BLANK        VNCHI             1
     C                   Z-ADD     *ZEROS        VNIPD             5 0
     C                   Z-ADD     *ZEROS        VNMDT             5 0
     C                   Z-ADD     *ZEROS        VNIDT             5 0
     C                   Z-ADD     *ZERO         VNROD             5 0
      *
     C                   MOVE      *BLANKS       VNCCY             3
     C                   Z-ADD     *ZEROS        VNCPA            13 0
     C                   Z-ADD     *ZEROS        VNFCE            13 8
     C                   MOVE      *BLANK        VNFMD             1
     C                   Z-ADD     *ZEROS        VNBCE            13 8
     C                   MOVE      *BLANK        VNBMD             1
     C                   Z-ADD     *ZEROS        VNLRA            13 0
      *
     C                   Z-ADD     *ZEROS        VNPRAM           13 0
     C                   Z-ADD     *ZEROS        VNDAM            13 0
     C                   Z-ADD     *ZEROS        VINTR            11 7
      *
     C                   Z-ADD     *ZEROS        VNFRS            11 7
     C                   MOVE      *BLANK        VNFSN             1
                                                                                              BUG827
     C                   MOVE      *BLANK        VNFYLD            5                          BUG827
      *
     C                   Z-ADD     *ZEROS        VTNLU             5 0
     C                   Z-ADD     *ZEROS        VLCD              5 0
     C                   MOVEL     *BLANK        VCHTP             1
     C                   MOVE      *BLANK        VRPCR            15
      *
     C                   MOVE      *BLANKS       WNBRAW            2
     C                   Z-ADD     *ZEROS        WNRODW            5 0
     C                   Z-ADD     *ZEROS        WRLDTW            5 0
     C                   Z-ADD     *ZEROS        WNFRSW           11 7
     C                   Z-ADD     *ZEROS        WNFCEW           13 8
     C                   Z-ADD     *ZEROS        WNBCEW           13 8
     C**********         Z-ADD     *ZEROS        WOLNO             6 0                        CSD027
     C                   Move      *Blanks       WOLNO             6                          CSD027
     C**********         Z-ADD     *ZEROS        WWLNRF            6 0                        CLE148
     C                   MOVEL     *BLANKS       WWLNRF            6                          CLE148
     C                   MOVE      *BLANK        WINCYL                                      BUG2579
     C                   MOVE      *BLANK        WINCYF                                      BUG2579
     C                   MOVE      *BLANK        WEUMDL                                      BUG2579
     C                   Z-ADD     *ZERO         WEUERL                                      BUG2579
     C                   MOVE      *BLANK        VFRCO             1                        MD028338
     C                   EVAL      DDFRCOOK = 'Y'                                           MD028338
 
      /COPY WNCPYSRC,LELERIV065
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZCPD  - Calculate a period                                    *
      *                                                               *
      *****************************************************************
     C     ZCPD          BEGSR
 
     C                   CALLB     'ZCPD'
     C                   PARM                    ZINDT                          Input date
     C                   PARM                    ZNYR                           Number of years
     C                   PARM                    ZNMN                           Number of months
     C                   PARM                    ZNDY                       Number of days    222373
     C                   PARM                    BJDFIN            1            Date Format Indic.
     C                   PARM                    ZPDNO             5 0          Period date
     C                   PARM                    ZPDTE             8            Period date
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN            6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
      *                                                               *
      * SRCURR  -  Get Currency Details                               *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
      *
     C                   MOVE      *BLANKS       PRTCD
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM                    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     EDBAS         ANDEQ     *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     PBASE         DBASE                          * DBERR XX *
     C                   MOVEL     PCURR         DBKEY                          ************
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRATE  -  Validation of exchange rate and amount             *
      *                                                               *
      *****************************************************************
     C     SRRATE        BEGSR
                                                                                             BUG2579
      ** Get loan currency details when CLE023 is installed and                              BUG2579
      ** default to spot rate is 'Y'                                                         BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     WMCCY         ANDEQ     'N'                                                       BUG2579
                                                                                             BUG2579
     C     DDRLDTB       IFNE      *BLANKS                                                   BUG2579
     C     WRLDT1        ANDNE     '*'                                                       BUG2579
     C                   Z-ADD     WRLDT         WWRLDT            6 0                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   Z-ADD     RLDT          WWRLDT            6 0                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   MOVEL     CCY           PCURR                                       BUG2579
     C                   Z-ADD     202           PBASE                                       BUG2579
     C                   MOVE      *ON           EDBAS                                       BUG2579
     C                   EXSR      SRCURR                                                    BUG2579
     C                   MOVE      A6INCY        WINCYL            1                         BUG2579
     C     A6INCY        IFEQ      'Y'                                                       BUG2579
     C                   MOVE      A6EUMD        WEUMDL            1                         BUG2579
     C                   Z-ADD     A6EUER        WEUERL           13 8                       BUG2579
     C                   ENDIF                                                               BUG2579
     C                   MOVE      A6MDIN        WMDIN                                       BUG2579
     C                   Z-ADD     A6SPRT        WSPRT                                       BUG2579
     C                   ENDIF                                                               BUG2579
      *
      ** Get cross exchange rate and multiply/divide indicator
      ** between new loan/rollover ccy and facility currency
      *
                                                                                             BUG2579
      ** For non-EMU multi-currency rollover.                                                BUG2579
                                                                                             BUG2579
     C     WDFLT         IFEQ      'N'                                                       BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     DDNCCYB       ANDEQ     *BLANKS                                                   BUG2579
     C     DDACTN        ANDEQ     'A'                                                       BUG2579
                                                                                             BUG2579
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     DDNCCY        ANDEQ     *BLANKS                                                   BUG2579
     C     DDACTN        ANDEQ     'X'                                                       BUG2579
                                                                                             BUG2579
     C                   MOVEL     FCCY          PCURR
     C                   Z-ADD     103           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   MOVE      A6INCY        WINCYF            1                         BUG2579
                                                                                             BUG2579
      ** If loan and facility is an 'In' currency, default facility                          BUG2579
      ** exchange rate by using the cross rate of the two A6EUER                             BUG2579
                                                                                             BUG2579
     C     A6INCY        IFEQ      'Y'                                                       BUG2579
     C     WINCYL        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      A6EUMD        PMDI1                                       BUG2579
     C                   MOVE      A6EUER        PRATE1                                      BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      A6MDIN        PMDI1
     C                   Z-ADD     A6SPRT        PRATE1
     C                   ENDIF                                                               BUG2579
     C     A6INCY        IFEQ      'Y'                                                       BUG2579
     C     WINCYL        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      WEUMDL        PMDI2                                       BUG2579
     C                   Z-ADD     WEUERL        PRATE2                                      BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      WMDIN         PMDI2
     C                   Z-ADD     WSPRT         PRATE2
                                                                                             BUG2579
     C                   ENDIF                                                               BUG2579
     C                   EXSR      ZXRATE
      *
     C     A6MDIN        IFEQ      'M'
     C     CLE023        OREQ      'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     DDNCCYB       ANDEQ     *BLANKS                                                   BUG2579
     C     A6INCY        ANDEQ     'Y'                                                       BUG2579
     C     A6EUMD        ANDEQ     'M'                                                       BUG2579
     C     WINCYL        ANDEQ     'Y'                                                       BUG2579
     C     WINCYF        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'D'           PMDIX
     C                   ELSE
     C                   MOVE      'M'           PMDIX
     C                   ENDIF
                                                                                             BUG2579
      ** Else this is an EMU multi-currency rollover.                                        BUG2579
      ** Get cross exchange rate and multiply/divide indicator between                       BUG2579
      ** new loan currency (EUR) and the facility currency, by                               BUG2579
      ** converting the old loan currency FCXR with the old currency's                       BUG2579
      ** EMU exchange rate.                                                                  BUG2579
      ** Get details of loan currency.                                                       BUG2579
                                                                                             BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVEL     CCY           PCURR                                       BUG2579
     C                   Z-ADD     204           PBASE                                       BUG2579
     C                   MOVE      *ON           EDBAS                                       BUG2579
     C                   EXSR      SRCURR                                                    BUG2579
     C     A6EUMD        IFEQ      'M'                                                       BUG2579
     C                   MOVE      'D'           PMDI1                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'M'           PMDI1                                       BUG2579
     C                   ENDIF                                                               BUG2579
     C                   Z-ADD     A6EUER        PRATE1                                      BUG2579
     C     FMDI          IFEQ      'M'                                                       BUG2579
     C                   MOVE      'D'           PMDI2                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'M'           PMDI2                                       BUG2579
     C                   ENDIF                                                               BUG2579
     C                   Z-ADD     FCXR          PRATE2                                      BUG2579
     C                   EXSR      ZXRATE                                                    BUG2579
     C                   ENDIF                                                               BUG2579
      *
      ** If exchange rate is left blank, default to cross exch rate
      *
     C     DDACTN        IFEQ      'A'
     C     *IN67         IFEQ      *ON                                                       BUG2579
     C     BPDRTS        ANDEQ     'Y'                                                       BUG2579
     C     WWRLDT        ANDNE     *ZERO                                                     BUG2579
     C     WRLDT1        ANDNE     '*'                                                       BUG2579
     C     DDNFCE        ANDEQ     *BLANKS                                                   BUG2579
     C     WMCCY         OREQ      'Y'                                                       BUG2579
     C     DDNFCEB       IFEQ      *BLANK
                                                                                             BUG2579
     C     DDNCCYB       IFEQ      FCCY                                                      BUG2579
     C                   Z-ADD     1             PRATEX                                      BUG2579
     C                   ENDIF                                                               BUG2579
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PRATEX        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNFCEB
     C                   Z-ADD     PRATEX        VNFCE
     C                   MOVE      PMDIX         DDNFMDB
     C                   MOVE      DDNFMDB       VNFMD
      *
      **  Default mult/div indicator to 'D' if facility ccy is Euro
      *
     C     FCCY          IFEQ      BKEURO
     C     WDFLT         ANDEQ     'Y'
     C                   MOVE      'D'           PMDIX
     C                   MOVE      PMDIX         VNFMD
     C                   MOVE      PMDIX         DDNFMDB
     C                   ENDIF
     C                   ELSE
                                                                                             BUG2579
      ** Else, SNFCEB was not blank. If Facility currency = 'EUR',                           BUG2579
      ** & EMU rollover, will need to get Facility currency details.                         BUG2579
                                                                                             BUG2579
     C     FCCY          IFEQ      BKEURO                                                    BUG2579
     C     WDFLT         ANDEQ     'Y'                                                       BUG2579
     C                   MOVEL     FCCY          PCURR                                       BUG2579
     C                   Z-ADD     205           DBASE                                       BUG2579
     C                   MOVE      *ON           EDBAS                                       BUG2579
     C                   EXSR      SRCURR                                                    BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C     FCCY          IFEQ      BKEURO
     C     WDFLT         ANDEQ     'Y'
     C     VNFCE         ANDEQ     A6SPRT
     C                   MOVE      'D'           PMDIX
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                               BUG2579
     C                   ENDIF                                                               BUG3531
      *
      ** Get cross exchange rate between old and new currencies
      ** using the facility exchange rates
      *
     C*****WMCCY         IFEQ      'Y'                                               BUG2579 BUG3531
     C     DDNFMDB       IFNE      PMDIX
     C     DDACTN        ANDEQ     'A'
     C     NFMD          ORNE      PMDIX
     C     DDACTN        ANDEQ     'X'
     C     NFMD          ORNE      PMDIX                                                      CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     1             DIV       PRATEX        PRATEX
                                                                                             BUG3531
     C     PMDIX         IFEQ      'M'                                                       BUG3531
     C                   MOVE      'D'           PMDIX                                       BUG3531
     C                   ELSE                                                                BUG3531
     C                   MOVE      'M'           PMDIX                                       BUG3531
     C                   ENDIF                                                               BUG3531
                                                                                             BUG3531
     C                   ENDIF
 
     C     DDACTN        IFEQ      'A'                                                       BUG3531
     C     WMCCY         IFEQ      'Y'                                                       BUG3531
     C                   Z-ADD     PRATEX        WZRATE           13 8
     C                   MOVE      PMDIX         WZPMDI            1                         BUG3531
     C                   Z-ADD     FCXR          PRATE1
     C                   MOVE      FMDI          PMDI1
     C                   MOVE      VNFMD         PMDI2
     C                   Z-ADD     VNFCE         PRATE2
     C                   EXSR      ZXRATE
      *
      ** Verify that exchange rate and amounts in old and new ccys
      ** agree
      ** taking into account currency decimal places.
     C     DDNcpaOK      IFNE      'N'
     C                   MOVEL     CCY           PCURR
     C                   Z-ADD     104           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C     WDFLT         IFEQ      'N'
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   Z-ADD     W#PWR         ZCDPO
      *
      ** Use new principal amount field when converting to new ccy
      ** if discount loan
      *
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C     PTYP          OREQ      67
     C                   Z-ADD     VNPRAM        ZAMTCI
     C                   ELSE
     C                   Z-ADD     CPAM          ZAMTCI
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        ZAMTCO
     C                   Z-ADD     PRATEX        ZEXCH
     C                   MOVE      PMDIX         ZMD
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        WNAMT            13 0
     C                   ELSE
     C     Wsett         IFEQ      'Y'
     C     WRLDT         ANDEQ     MDAT
     C     DDNpraOK      ANDNE     'N'
     C                   Z-ADD     VNPRAM        WPFRAM           15 0
     C                   ELSE
     C                   Z-ADD     CPAM          WPFRAM
     C                   ENDIF
     C     DDNpraOK      IFNE      'N'
     C     DDNpraOK      OREQ      'N'
     C     Wsett         ANDNE     'Y'
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      WPFRAM        PFRAM            18 3
     C                   PARM      CCY           PFRCY             3
     C                   PARM      DDNCCYB       PTOCY             3
     C                   PARM                    POUTA            15 0
     C                   PARM                    PINTA            18 3
     C                   PARM                    PEXRT            15 9
     C                   PARM                    PMDIN             1
      *
     C                   Z-ADD     POUTA         WNAMT
      *
      **  Default New ccy principal amount CEU020 is installed, new
      **  ccy is Euro and new principal amt is blanks
      *
     C     DDNCPAB       IFEQ      *BLANKS
     C                   MOVEL     VNCCY         PCURR
     C                   Z-ADD     105           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      POUTA         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNCPAB
     C                   Z-ADD     POUTA         VNCPA
     C                   Z-ADD     POUTA         WNAMT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Check that the amount entered must be within the tolerance of
      ** 5%
      *
     C     WNAMT         MULT(H)   0.95          WNLAMT           13 0
     C     WNAMT         MULT(H)   1.05          WNHAMT           13 0
      *
     C     VNCPA         IFLT      WNLAMT
     C     VNCPA         ORGT      WNHAMT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNCPAB'
     C                   EVAL      MsgIDArr(Idx) = 'LEV1050'
     C                   MOVE      'N'           DDNcpaOK
      *
     C**********         ADD       1             Idx                                          WA0023
     C**********         EVAL      FldNameArr(Idx) = 'DDNFCEB'                                WA0023
     C**********         EVAL      MsgIDArr(Idx) = 'LEV1050'                                  WA0023
     C                   MOVE      'N'           DDNfceOK
      *
     C**********         ADD       1             Idx                                          WA0023
     C**********         EVAL      FldNameArr(Idx) = 'DDNFMDB'                                WA0023
     C**********         EVAL      MsgIDArr(Idx) = 'LEV1050'                                  WA0023
     C                   MOVE      'N'           DDNfmdOK
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WNAMT         ZFLD15
     C                   Z-ADD     ZCDPO         ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZFRPED
     C     ZNEG          IFEQ      '-'
     C**********         MOVEL     ZOUT21        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT21))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZOUT21)                   MD000091
     C                   ELSE
     C**********         MOVEL     ZOUT20        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZOUT20)                   MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     WZRATE        PRATEX
     C                   MOVE      WZPMDI        PMDIX                                       BUG3531
     C                   ENDIF                                                               BUG2579
     C                   ENDIF
      *
 
      /COPY WNCPYSRC,LELERIV066
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG2579
      *                                                               *                      BUG2579
      * SRVFXR  -  Subroutine to check if Rollover of facility        *                      BUG2579
      *            exchange rate will be allowed                      *                      BUG2579
      *                                                               *                      BUG2579
      *****************************************************************                      BUG2579
     C     SRVFXR        BEGSR                                                               BUG2579
                                                                                             BUG2579
     C                   MOVE      'Y'           WFCXRA            1                         BUG2579
     C**********         Z-ADD     LNRF          ALNRF                                BUG2579 CLE148
     C                   MOVEL     LNRF          ALNRF                                        CLE148
                                                                                             BUG2579
     C     DDRLDTB       IFNE      *BLANKS                                                   BUG2579
     C     WRLDT1        ANDNE     '*'                                                       BUG2579
     C                   Z-ADD     WRLDT         AVDAT                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   Z-ADD     RLDT          AVDAT                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   Z-ADD     *ZEROS        ALASN                                       BUG2579
                                                                                             BUG2579
     C     AVDAT         IFLT      BJRDNB                                                    BUG2579
     C     AVDAT         ANDNE     *ZERO                                                     BUG2579
     C     LNRF          SETLL     LELOAML0                                                  BUG2579
     C                   READ      LELOAML0                               85                 BUG2579
                                                                                             BUG2579
     C     *IN85         DOWEQ     '0'                                                       BUG2579
     C     LNRF          ANDEQ     A_LNRF                                                    BUG2579
     C     A_VDAT        ANDLE     BJRDNB                                                    BUG2579
                                                                                             BUG2579
     C     A_AMTP        IFEQ      'PI'                                                      BUG2579
     C     A_AMTP        OREQ      'RE'                                                      BUG2579
     C     A_AMTP        OREQ      'MR'                                                      BUG2579
     C     A_PRAM        ANDNE     *ZERO                                                     BUG2579
     C                   MOVE      'N'           WFCXRA                                      BUG2579
     C                   LEAVE                                                               BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   READ      LELOAML0                               85                 BUG2579
     C                   ENDDO                                                               BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C     AVDAT         IFLT      BJRDNB                                                    BUG2579
     C     AVDAT         ANDNE     *ZEROS                                                    BUG2579
     C     NRPD          ANDLE     BJRDNB                                                    BUG2579
     C     NRPD          ANDNE     *ZEROS                                                    BUG2579
     C                   MOVE      'N'           WFCXRA                                      BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   ENDSR                                                               BUG2579
      *****************************************************************                      BUG2579
      /EJECT                                                                                 BUG2579
      *****************************************************************
      *                                                               *
      * ZXRATE - Obtain x-ccy exchg rate & mlt/div                    *
      *                                                               *
      *****************************************************************
     C     ZXRATE        BEGSR
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    PRATE1
     C                   PARM                    PMDI1
     C                   PARM                    PRATE2
     C                   PARM                    PMDI2
     C                   PARM      *ZEROS        PRATEX
     C                   PARM      *BLANKS       PMDIX
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFRPED -  Edit amount                                         *
      *                                                               *
      *****************************************************************
     C     ZFRPED        BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM      *BLANKS       ZOUT22
     C                   PARM      *BLANKS       ZOUT25
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZCONV  - Cvt amount fm one ccy to another                     *
      *                                                               *
      *****************************************************************
     C     ZCONV         BEGSR
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLINTC - Cvt amount fm one ccy to another                     *
      *                                                               *
      *****************************************************************
     C     GLINTC        BEGSR
 
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG             5 0       STARTING DATE
     C                   PARM                    ZIEND             5 0       FINISHING DATE
     C                   PARM                    ZICALC            1 0       CALC. BASIS
     C                   PARM                    ZIAMT            15 0       PRINCIPAL
     C                   PARM                    ZIRATE           11 7       RATE OF INTRST
     C                   PARM                    ZINTR            30 9       INTEREST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWARN   - Send a warning message if a syndicated loan is     *
      *            being amended, reversed or authorised directly on  *
      *            Midas as Loan Manager should be used to take       *
      *            advantage of the autogeneration process.           *
      *                                                               *
      *****************************************************************
     C     SRWARN        BEGSR
      *
      * If program runs interactively
      *
     C     @TYPE         IFEQ      '1'
     C     CLE106        ANDNE     'Y'                                                        CLE106
      *
      ** Warn if participation linked to a syndicate
      *
     C     PTYP          IFEQ      64
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      65
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      66
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      67
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      68
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      69
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      71
     C     LNKS          ANDEQ     'Y'
     C     PTYP          OREQ      72
     C     LNKS          ANDEQ     'Y'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDACTN'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C**********         MOVE      'N'           DDActnOK                                    BUG4493
     C                   MOVE      'W'           DDActnOK                                    BUG4493
      *
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C**********         MOVE      'N'           DDLnrfOK                                    BUG4493
     C                   MOVE      'W'           DDLnrfOK                                    BUG4493
      *
     C                   ELSE
      *
      ** Warn if loan or direct participation purchased but facility
      ** is syndicated.
      *
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      64
     C     LNKS          ANDNE     'Y'
     C     PTYP          OREQ      65
     C     LNKS          ANDNE     'Y'
     C     PTYP          OREQ      68
     C     LNKS          ANDNE     'Y'
     C     PTYP          OREQ      70
     C     PTYP          OREQ      71
     C     LNKS          ANDNE     'Y'
      *
     C                   MOVE      FCUS          WFCUS
     C                   MOVE      FTYP          WFTYP
     C                   MOVE      FSEQ          WFSEQ
     C                   MOVE      'A'           WRCTP
      *
     C     K#FCLT        CHAIN     FCLTY                              85
     C     F_SYIN        IFEQ      'Y'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDACTN'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C**********         MOVE      'N'           DDActnOK                                    BUG4493
     C                   MOVE      'W'           DDActnOK                                    BUG4493
      *
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C**********         MOVE      'N'           DDLnrfOK                                    BUG4493
     C                   MOVE      'W'           DDLnrfOK                                    BUG4493
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
 
      /COPY WNCPYSRC,LELERIV067
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWDET  -  Warning messages of Detail Screen.                 *
      *                                                               *
      *****************************************************************
     C     SRWDET        BEGSR
      *
      **  If New base rate code is blank and loan is
      **  currently attached to base rate.
      *
     C     BRTT          IFNE      *ZEROS
     C     DDNBRAB       ANDEQ     *BLANKS
     C     DDNBRA        ANDEQ     *BLANKS
     C     DDFRCOB       ANDNE     'Y'                                                      MD031083
     C     DDACTN        ANDEQ     'A'
     C     BRTT          ORNE      *ZEROS
     C     NBRA          ANDEQ     *ZEROS
     C     DDFRCO        ANDNE     'Y'                                                      MD031083
     C     DDACTN        ANDEQ     'X'
     C     BRTT          ORNE      *ZEROS                                                     CLE030
     C     NBRA          ANDEQ     *ZEROS                                                     CLE030
     C     DDFRCO        ANDNE     'Y'                                                      MD031083
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNBRAB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0020'
     C**********         MOVE      'N'           DDNbraOK                                    BUG4493
     C                   MOVE      'W'           DDNbraOK                                    BUG4493
     C     DDACTN        IFEQ      'A'
     C     DDNBRAB       ANDNE     WNBRAW
     C                   MOVEL     DDNBRAB       WNBRAW
     C                   ENDIF
     C                   ENDIF
      *
      **  If New Next Rollover date entered, send
      **  warning message if holiday in Loan currency.
      *
     C     VNROD         IFNE      *ZEROS
     C     DDACTN        ANDEQ     'A'
     C     NROD          ORNE      *ZEROS
     C     DDACTN        ANDEQ     'X'
     C     NROD          ORNE      *ZEROS                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     VNROD         PDateIn
     C                   ELSE
     C                   Z-ADD     NROD          PDateIn
     C                   ENDIF
      *
     C                   MOVE      CCY           PCurrency
     C                   EXSR      ZCHKH
      *
     C     PHolInd       IFEQ      'H'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNRODB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1016'
     C**********         MOVE      'N'           DDNrodOK                                    BUG4493
     C                   MOVE      'W'           DDNrodOK                                    BUG4493
     C     DDACTN        IFEQ      'A'
     C     PDateIn       ANDNE     WNRODW
     C                   Z-ADD     PDateIn       WNRODW
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If New Rollover date was entered, send
      **  warning message if holiday in Loan currency.
      *
     C     VRLDT         IFNE      *ZEROS
     C     DDACTN        ANDEQ     'A'
     C     RLDT          ORNE      *ZEROS
     C     DDACTN        ANDEQ     'X'
     C     RLDT          ORNE      *ZEROS                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     VRLDT         PDateIn
     C                   ELSE
     C                   Z-ADD     RLDT          PDateIn
     C                   ENDIF
      *
     C                   MOVE      CCY           PCurrency
     C                   EXSR      ZCHKH
      *
     C     PHolInd       IFEQ      'H'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDRLDTB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1015'
     C**********         MOVE      'N'           DDRldtOK                                    BUG4493
     C                   MOVE      'W'           DDRldtOK                                    BUG4493
     C     DDACTN        IFEQ      'A'
     C     PDateIn       ANDNE     WRLDTW
     C                   Z-ADD     ZDAYNO        WRLDTW
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If the funding spread/rate and sign are both valid,
      **  determine the actual funding rate.
      *
     C     *IN62         IFEQ      *ON
     C     DDNfrsOK      ANDNE     'N'
     C     DDNfsnOK      ANDNE     'N'
     C     VNFRS         ANDNE     *ZEROS
     C     DDACTN        ANDEQ     'A'
     C     *IN62         OREQ      *ON
     C     NFRS          ANDNE     *ZEROS
     C     DDACTN        ANDEQ     'X'
     C     *IN62         OREQ      *ON                                                        CLE030
     C     NFRS          ANDNE     *ZEROS                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C                   EXSR      SREFFI
     C     DDACTN        IFEQ      'A'
     C                   SELECT
     C     VNFSN         WHENEQ    *BLANK
     C                   Z-ADD     VNFRS         WANFRS           11 7
     C     VNFSN         WHENEQ    '+'
     C     WINTR         ADD       VNFRS         WANFRS
     C     VNFSN         WHENEQ    '-'
     C     WINTR         SUB       VNFRS         WANFRS
     C                   ENDSL
      *
     C                   ELSE
     C                   SELECT
     C     NFSN          WHENEQ    *BLANK
     C                   Z-ADD     NFRS          WANFRS           11 7
     C     NFSN          WHENEQ    '+'
     C     WINTR         ADD       NFRS          WANFRS
     C     NFSN          WHENEQ    '-'
     C     WINTR         SUB       NFRS          WANFRS
     C                   ENDSL
     C                   ENDIF
      *
      **  Compute the maximum and minimum allowable amount
      **  based on the tolerance for Funding Rate.
     C     FTTFRT        DIV       100           WTRATE            3 2
     C     1             ADD       WTRATE        WMAXTL            4 2
     C     WINTR         MULT(H)   WMAXTL        WMAXRT           11 7
     C     1             SUB       WTRATE        WMINTL            4 2
     C     WINTR         MULT(H)   WMINTL        WMINRT           11 7
      *
      **  If the Actual Funding Rate is greater than the
      **  maximum or less than the minimum amount,
      **  display warning message.
     C     WANFRS        IFGT      WMAXRT
     C     WANFRS        ORLT      WMINRT
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNFRSB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1022'
     C**********         MOVE      'N'           DDNfrsOK                                    BUG4493
     C                   MOVE      'W'           DDNfrsOK                                    BUG4493
     C     DDACTN        IFEQ      'A'
     C     WANFRS        ANDNE     WNFRSW
     C                   Z-ADD     WANFRS        WNFRSW
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Send a warning message if new loan amount differs from the
      ** amount calulated by less than or equal to 5%.
      *
     C     VNCPA         IFGE      WNLAMT
     C     VNCPA         ANDLE     WNHAMT
     C     VNCPA         ANDNE     WNAMT
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNCPAB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1049'
     C**********         MOVE      'N'           DDNcpaOK                                    BUG4493
     C                   MOVE      'W'           DDNcpaOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1049'                                WA0025
     C**********         MOVE      'N'           DDNfceOK                                    BUG4493
     C                   MOVE      'W'           DDNfceOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1049'                                WA0025
     C**********         MOVE      'N'           DDNfmdOK                                    BUG4493
     C                   MOVE      'W'           DDNfmdOK                                    BUG4493
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WNAMT         ZFLD15
     C                   Z-ADD     ZCDPO         ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZFRPED
     C     ZNEG          IFEQ      '-'
     C**********         EVAL      WMsgDtaArr(WIdx) = ZOUT21                                MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT21))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(ZOUT21)                 MD000091
     C                   ELSE
     C**********         EVAL      WMsgDtaArr(WIdx) = ZOUT20                                MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(ZOUT20)                 MD000091
     C                   ENDIF
     C                   ENDIF
      *
      ** Warning message will be sent if exchange rate for multi-
      ** currency rollover is not within 25% of the rate calculated
      ** by the system as spot rate
      *
     C     MULTIC        IFEQ      *ON
     C     *IN67         OREQ      *ON                                                       BUG2579
 
     C     DDNFCEB       IFNE      *BLANKS
     C     WNFCE1        ANDNE     '*'
     C     DDNfceOK      ANDNE     'N'
     C     DDNfmdOK      ANDNE     'N'
     C     DDNccyOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C     MULTIC        ANDEQ     *ON                                                       BUG2579
 
     C     NCCY          ORNE      *BLANKS
     C     NCPA          ANDNE     *ZEROS
     C     NFCE          ANDNE     *ZEROS
     C     NFMD          ANDNE     *BLANK
     C     WNFCE1        ANDNE     '*'                                               if from CTU
     C     DDACTN        ANDEQ     'X'
     C     MULTIC        ANDEQ     *ON                                                       BUG2579
 
     C     NCCY          ORNE      *BLANKS                                                    CLE030
     C     NCPA          ANDNE     *ZEROS                                                     CLE030
     C     NFCE          ANDNE     *ZEROS                                                     CLE030
     C     NFMD          ANDNE     *BLANK                                                     CLE030
     C     WNFCE1        ANDNE     '*'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     MULTIC        ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
      ** Or new facility exchange rate is not equal to blanks and                            BUG2579
      ** action is amend and CLE023 is installed and facility is                             BUG2579
      ** multi-currency                                                                      BUG2579
                                                                                             BUG2579
     C     DDNFCEB       ORNE      *BLANKS                                                   BUG2579
     C     WNFCE1        ANDNE     '*'                                                       BUG2579
     C*****DDNfceOK      ANDEQ     'Y'                                                       BUG2579
     C*****DDNfmdOK      ANDEQ     'Y'                                                       BUG2579
     C     DDNfceOK      ANDNE     'N'                                               BUG2579 BUG4493
     C     DDNfmdOK      ANDNE     'N'                                               BUG2579 BUG4493
     C     DDACTN        ANDEQ     'A'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
      ** Or new facility exchange rate is not equal to zero and                              BUG2579
      ** action is authorise and CLE023 is installed and facility is                         BUG2579
      ** multi-currency                                                                      BUG2579
                                                                                             BUG2579
     C     NFCE          ORNE      *ZEROS                                                    BUG2579
     C     NFMD          ANDNE     *BLANK                                                    BUG2579
     C     DDACTN        ANDEQ     'X'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
      ** Or new facility exchange rate is not equal to zero and                              BUG2579
      ** action is Release and CLE023 is installed and facility is                           BUG2579
      ** multi-currency and CLE030 is on.                                                    BUG2579
                                                                                             BUG2579
     C     NFCE          ORNE      *ZEROS                                                    BUG2579
     C     NFMD          ANDNE     *BLANK                                                    BUG2579
     C     DDACTN        ANDEQ     'Q'                                                       BUG2579
     C     CLE030        ANDEQ     'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
                                                                                             BUG2579
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     MULTIC        IFEQ      *ON                                                       BUG2579
     C     NCCY          ANDNE     *BLANKS                                                   BUG2579
     C     NCCY          ANDNE     CCY                                                       BUG2579
     C                   MOVEL     NCCY          PCURR
     C                   ELSE                                                                BUG2579
     C                   MOVE      CCY           PCURR                                       BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                             BUG2579
     C                   Z-ADD     106           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   MOVE      A6MDIN        WMDIN
     C                   Z-ADD     A6SPRT        WSPRT
     C                   EXSR      SRRATE
     C                   ENDIF
     C     CEU020        IFEQ      'Y'
     C     DDNCCYB       IFEQ      BKEURO
     C     DDACTN        ANDEQ     'A'
     C     DDNCCY        OREQ      BKEURO
     C     DDACTN        ANDEQ     'X'
     C     DDNCCY        OREQ      BKEURO                                                     CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      'N'           WTLLMT            1
     C                   ELSE
     C                   MOVE      'Y'           WTLLMT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           WTLLMT
     C                   ENDIF
      *
     C     WTLLMT        IFEQ      'Y'
     C     PRATEX        MULT(H)   .75           WRATL            13 8
     C     PRATEX        MULT(H)   1.25          WRATH            13 8
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     VNFCE         WANFCE           13 8
     C                   ELSE
     C                   Z-ADD     NFCE          WANFCE
     C                   ENDIF
     C     WANFCE        IFLT      WRATL
     C     WANFCE        ORGT      WRATH
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNFCEB'
     C**********         EVAL      WMsgIDArr(WIdx) = 'LEV0010'                               BUG3531
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0060'                               BUG3531
     C**********         MOVE      'N'           DDNfceOK                                    BUG4493
     C                   MOVE      'W'           DDNfceOK                                    BUG4493
                                                                                             BUG3531
     C                   MOVE      *BLANKS       W#14A                                       BUG3531
     C                   MOVE      *BLANKS       W#16A                                       BUG3531
     C                   MOVE      *BLANKS       ZFIELD                                      BUG3531
     C                   MOVE      PRATEX        ZFIELD                                      BUG3531
     C                   Z-ADD     8             ZADEC                                       BUG3531
     C                   EXSR      ZEDIT                                                     BUG3531
     C                   MOVE      ZFIELD        W#14A            14                         BUG3531
     C                   MOVEL     W#14A         W#16A            16                         BUG3531
     C                   MOVE      PMDIX         W#16A                                       BUG3531
                                                                                             BUG3531
     C**********         EVAL      WMsgDtaArr(WIdx) = W#16A                         BUG3531 MD000091
     C                   EVAL      BLen = %Len(%Trim(W#16A))                                MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(W#16A)                  MD000091
                                                                                             BUG3531
     C     DDACTN        IFEQ      'A'
     C     VNFCE         ANDNE     WNFCEW
     C                   Z-ADD     VNFCE         WNFCEW
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Send a warning message if new loan amount differs from the
      ** amount calulated by less than or equal to 5%.
      *
     C     VNCPA         IFGE      WNLAMT
     C     VNCPA         ANDLE     WNHAMT
     C     VNCPA         ANDNE     WNAMT
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNCPAB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1049'
     C**********         MOVE      'N'           DDNcpaOK                                    BUG4493
     C                   MOVE      'W'           DDNcpaOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1049'                                WA0025
     C**********         MOVE      'N'           DDNfceOK                                    BUG4493
     C                   MOVE      'W'           DDNfceOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1049'                                WA0025
     C**********         MOVE      'N'           DDNfmdOK                                    BUG4493
     C                   MOVE      'W'           DDNfmdOK                                    BUG4493
     C                   MOVE      *BLANKS       ZFLD15                         WA0025
     C                   MOVE      VNCPA         ZFLD15                         WA0025
     C                   Z-ADD     ZCDPO         ZDECS                          WA0025
     C                   MOVE      'L'           ZECODE                         WA0025
     C                   EXSR      ZFRPED                                       WA0025
     C     ZNEG          IFEQ      '-'                                          WA0025
     C**********         EVAL      WMsgDtaArr(WIdx) = ZOUT21                         WA0025 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT21))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(ZOUT21)                 MD000091
     C                   ELSE                                                   WA0025
     C**********         EVAL      WMsgDtaArr(WIdx) = ZOUT20                         WA0025 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(ZOUT20)                 MD000091
     C                   ENDIF                                                  WA0025
     C                   ENDIF
     C                   ENDIF                                                               BUG2579
     C                   ENDIF
      *
      ** Warning message will be sent if exchange rate for multi-
      ** currency rollover is not within 25% of the spot rate for the
      ** new currency as is stored in file
      *
     C     MULTIC        IFEQ      *ON                                                       BUG2579
     C     DDNBCEB       IFNE      *BLANKS
     C     WNBCE1        ANDNE     '*'
     C     DDNbceOK      ANDNE     'N'
     C     DDNbmdOK      ANDNE     'N'
     C     DDNccyOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'A'
     C     NCCY          ORNE      *BLANKS
     C     WNBCE1        ANDNE     '*'                                               if from CTU
     C     DDACTN        ANDEQ     'X'
     C     NCCY          ORNE      *BLANKS                                                    CLE030
     C     WNBCE1        ANDNE     '*'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVEL     NCCY          PCURR
     C                   Z-ADD     107           PBASE
     C                   MOVE      *ON           EDBAS
     C                   EXSR      SRCURR
     C                   MOVE      A6MDIN        WMDIN
     C                   Z-ADD     A6SPRT        WSPRT
     C                   Z-ADD     NBCE          VNBCE
     C                   MOVE      NBMD          WNBMDB            1
     C                   ELSE
     C                   MOVE      DDNBMDB       WNBMDB
     C                   ENDIF
      *
     C     WNBMDB        IFEQ      WMDIN
     C                   Z-ADD     WSPRT         PRATEX
     C                   MOVE      WMDIN         PMDIX                                       BUG3531
     C                   ELSE
     C     1             DIV(H)    WSPRT         PRATEX
     C                   MOVE      WNBMDB        PMDIX                                       BUG3531
     C                   ENDIF
                                                                                             BUG3531
     C     WTLLMT        IFEQ      'Y'
     C     PRATEX        MULT(H)   .75           WRATL
     C     PRATEX        MULT(H)   1.25          WRATH
      *
     C     VNBCE         IFLT      WRATL
     C     VNBCE         ORGT      WRATH
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNBCEB'
     C**********         EVAL      WMsgIDArr(WIdx) = 'LEV0012'                               BUG3531
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0061'                               BUG3531
     C**********         MOVE      'N'           DDNbceOK                                    BUG4493
     C                   MOVE      'W'           DDNbceOK                                    BUG4493
                                                                                             BUG3531
     C                   MOVE      *BLANKS       W#14A                                       BUG3531
     C                   MOVE      *BLANKS       W#16A                                       BUG3531
     C                   MOVE      *BLANKS       ZFIELD                                      BUG3531
     C                   MOVE      PRATEX        ZFIELD                                      BUG3531
     C                   Z-ADD     8             ZADEC                                       BUG3531
     C                   EXSR      ZEDIT                                                     BUG3531
     C                   MOVE      ZFIELD        W#14A            14                         BUG3531
     C                   MOVEL     W#14A         W#16A            16                         BUG3531
     C                   MOVE      PMDIX         W#16A                                       BUG3531
                                                                                             BUG3531
     C**********         EVAL      WMsgDtaArr(WIdx) = W#16A                         BUG3531 MD000091
     C                   EVAL      BLen = %Len(%Trim(W#16A))                                MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(W#16A)                  MD000091
                                                                                             BUG3531
     C     DDACTN        IFEQ      'A'
     C     VNBCE         ANDNE     WNBCEW
     C                   Z-ADD     VNBCE         WNBCEW
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Send warning message if multi-ccy rollover details is
      ** different with related loan
      *
     C     MULTIC        IFEQ      *ON
     C     DDNccyOK      ANDNE     'N'
     C     DDNcpaOK      ANDNE     'N'
     C     DDNfceOK      ANDNE     'N'
     C     DDNfmdOK      ANDNE     'N'
     C     DDNlraOK      ANDNE     'N'
     C     DDNbceOK      ANDNE     'N'
     C     DDNbmdOK      ANDNE     'N'
     C     MULTIC        OREQ      *ON
     C     Widx          ANDNE     *zero
      *
      ** If new ccy was entered or being deleted, use this field to
      ** compare to related loan, otherwise, use the new ccy field
      ** file if not blank.
      *
     C     VNCCY         IFNE      *BLANKS
     C     WNCCY1        OREQ      '*'
     C                   MOVE      VNCCY         WNCCY             3
     C                   Z-ADD     VNFCE         WNFCE            13 8
     C                   MOVE      VNFMD         WNFMD             1
     C                   Z-ADD     VNBCE         WNBCE            13 8
     C                   MOVE      VNBMD         WNBMD             1
     C                   ELSE
     C     NCCY          IFNE      *BLANKS
     C                   MOVE      NCCY          WNCCY
     C                   Z-ADD     NFCE          WNFCE
     C                   MOVE      NFMD          WNFMD
     C                   Z-ADD     NBCE          WNBCE
     C                   MOVE      NBMD          WNBMD
     C                   ELSE
     C                   MOVE      *BLANKS       WNCCY
     C                   Z-ADD     *ZEROS        WNFCE
     C                   MOVE      *BLANK        WNFMD
     C                   Z-ADD     *ZEROS        WNBCE
     C                   MOVE      *BLANK        WNBMD
     C                   ENDIF
     C                   ENDIF
      *
      ** If rollover date was entered, use this to compare to rollover
      ** date of the related loan, otherwise use the field from file
      ** if not blank.
      *
     C     VRLDT         IFGT      *ZERO
     C     WRLDT1        OREQ      '*'
     C                   Z-ADD     VRLDT         WRLDT             5 0
     C                   ELSE
     C     RLDT          IFGT      *ZERO
     C                   Z-ADD     RLDT          WRLDT
     C                   ELSE
     C                   Z-ADD     *ZERO         WRLDT
     C                   ENDIF
     C                   ENDIF
      *
     C     WNCCY         IFNE      *BLANKS
     C     WNCCY1        OREQ      '*'
      *
     C**********         Z-ADD     LNRF          WWLNRF            6 0                        CLE148
     C                   MOVEL     LNRF          WWLNRF            6                          CLE148
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     PTYP          OREQ      72
     C                   MOVE      'A'           WRCDT
     C                   MOVE      OLNO          WLNRF
     C     WLOAN         CHAIN     CLOAN                              89
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      'B'           WRCDT
     C                   MOVE      LO_LNRF       WLNRF
     C     WLOAN         CHAIN     CLOAN                              89
     C                   ENDIF
     C     *IN89         IFEQ      '0'
      *
      ** Compare multi-ccy details of parts sold to its Sale of loan
      *
     C     WRLDT         IFEQ      LO_RLDT
     C     WNCCY         ANDEQ     LO_NCCY
     C     WNFCE         ANDEQ     LO_NFCE
     C     WNBCE         ANDEQ     LO_NBCE
     C     WNFMD         ANDEQ     LO_NFMD
     C     WNBMD         ANDEQ     LO_NBMD
     C**********         Z-ADD     LO_LNRF       WOLNO                                        CSD027
     C                   Move      LO_LNRF       WOLNO                                        CSD027
     C                   ELSE
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDRLDTB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1046'
     C**********         MOVE      'N'           DDRldtOK                                    BUG4493
     C                   MOVE      'W'           DDRldtOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNCCYB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNccyOK                                    BUG4493
     C                   MOVE      'W'           DDNccyOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNfceOK                                    BUG4493
     C                   MOVE      'W'           DDNfceOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNfmdOK                                    BUG4493
     C                   MOVE      'W'           DDNfmdOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNBCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNbceOK                                    BUG4493
     C                   MOVE      'W'           DDNbceOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNBMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNbmdOK                                    BUG4493
     C                   MOVE      'W'           DDNbmdOK                                    BUG4493
      *
     C                   MOVEL     LO_LNRF       Wer_LNRF          6
     C**********         EVAL      WMsgDtaArr(WIdx) = Wer_LNRF                              MD000091
     C                   EVAL      BLen = %Len(%Trim(Wer_LNRF))                             MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(Wer_LNRF)               MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C**********         Z-ADD     LNRF          WOLNO                                        CSD027
     C                   Move      LNRF          WOLNO                                        CSD027
     C                   ENDIF
      *
     C     WOLNO         SETLL     PSOLDFF
     C     WOLNO         READE     PSOLDFF                                89
      *
     C     *IN89         DOWEQ     *OFF
     C     DDNccyOK      ANDNE     'N'
      *
     C     P_LNRF        SETLL     LOANL2F
     C                   READ      LOANL2F                                89
      *
     C     *IN89         IFEQ      '0'
     C     WWLNRF        ANDNE     L2_LNRF
      *
      ** Compare multi-ccy details to other related parts sold
      *
     C     WRLDT         IFEQ      P_RLDT                                       from Part Sold rec L
     C     WNCCY         ANDEQ     L2_NCCY                                      from Part Sold rec K
     C     WNFCE         ANDEQ     L2_NFCE                                      from Part Sold rec K
     C     WNBCE         ANDEQ     L2_NBCE                                      from Part Sold rec K
     C     WNFMD         ANDEQ     L2_NFMD                                      from Part Sold rec K
     C     WNBMD         ANDEQ     L2_NBMD                                      from Part Sold rec K
     C                   ELSE
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDRLDTB'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1046'
     C**********         MOVE      'N'           DDRldtOK                                    BUG4493
     C                   MOVE      'W'           DDRldtOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNCCYB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNccyOK                                    BUG4493
     C                   MOVE      'W'           DDNccyOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNfceOK                                    BUG4493
     C                   MOVE      'W'           DDNfceOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNFMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNfmdOK                                    BUG4493
     C                   MOVE      'W'           DDNfmdOK                                    BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNBCEB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNbceOK                                   BUG4493
     C                   MOVE      'W'           DDNbceOK                                   BUG4493
      *
     C***********        ADD       1             WIdx                                         WA0025
     C***********        EVAL      WFldNamArr(WIdx) = 'DDNBMDB'                               WA0025
     C***********        EVAL      WMsgIDArr(WIdx) = 'LEV1046'                                WA0025
     C**********         MOVE      'N'           DDNbmdOK                                    BUG4493
     C                   MOVE      'W'           DDNbmdOK                                    BUG4493
      *
     C**********         MOVE      LO_LNRF       Wer_LNRF                                     CAP084
     C                   MOVE      L2_LNRF       Wer_LNRF                                     CAP084
     C**********         EVAL      WMsgDtaArr(WIdx) = Wer_LNRF                              MD000091
     C                   EVAL      BLen = %Len(%Trim(Wer_LNRF))                             MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(Wer_LNRF)               MD000091
     C                   ENDIF
     C                   ENDIF
     C     WOLNO         READE     PSOLDFF                                89
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Send warning message if rollover date, new base rate,
      ** new spread/rate, new spread indicator, new spread
      ** indicator, or the new currency are amended or removed.
      *
     C     CLE011        IFEQ      'Y'
     C     RFRI          ANDEQ     'Y'
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNRTSB       ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WNRTSB           11 7
      *
     C     DDRLDTB       IFNE      DDRLDT
     C     DDRLDTB       ANDNE     *BLANKS
     C     DDNBRAB       ORNE      DDNBRAB
     C     WNRTSB        ORNE      NRTS
     C     WNRTSB        ANDNE     0
     C     DDNSINB       ORNE      DDNSIN
     C     DDNSINB       ANDNE     *BLANK
     C     DDNCHIB       ORNE      DDNCHI
     C     DDNCHIB       ANDNE     *BLANK
     C     DDNCCYB       ORNE      DDNCCY
     C     DDNCCYB       ANDNE     *BLANKS
      *
     C                   SELECT
      ** Loan
     C     PTYP          WHENEQ    61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      70
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0403'
     C**********         MOVE      'N'           DDLnrfOK                                    BUG4493
     C                   MOVE      'W'           DDLnrfOK                                    BUG4493
      ** Participation Purchased
     C     PTYP          WHENEQ    64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     PTYP          OREQ      71
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0404'
     C**********         MOVE      'N'           DDLnrfOK                                    BUG4493
     C                   MOVE      'W'           DDLnrfOK                                    BUG4493
      ** Participation Sold
     C     PTYP          WHENEQ    66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     PTYP          OREQ      72
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV0405'
     C**********         MOVE      'N'           DDLnrfOK                                    BUG4493
     C                   MOVE      'W'           DDLnrfOK                                    BUG4493
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
                                                                                             BUG2579
      ** Display warning message if new facility exchange rate cannot                        BUG2579
      ** be defaulted due to existing loan amendments even if default                        BUG2579
      ** rate to spot indicator is 'Y'                                                       BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     *IN67         ANDEQ     *ON                                                       BUG2579
     C     WFCXRA        ANDEQ     'N'                                                       BUG2579
     C     BPDRTS        ANDEQ     'Y'                                                       BUG2579
     C     VNFCE         ANDEQ     *ZEROS                                                    BUG2579
     C     WNFCE1        ANDNE     '*'                                                       BUG2579
     C                   ADD       1             WIdx                                        BUG2579
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'                               BUG2579
     C                   EVAL      WMsgIDArr(WIdx) = 'LEV1060'                               BUG2579
     C**********         MOVE      'N'           DDnfceOK                            BUG2579 BUG4493
     C                   MOVE      'W'           DDnfceOK                                    BUG4493
     C                   ENDIF                                                               BUG2579
      *
 
      /COPY WNCPYSRC,LELERIV068
 
     C                   ENDSR
      *****************************************************************                     AR820729
      /EJECT                                                                                AR820729
      *****************************************************************                     AR820729
      *                                                               *                     AR820729
      * SRLSTS  -  Validate Loan Status                               *                     AR820729
      *                                                               *                     AR820729
      *****************************************************************                     AR820729
     C     SRLSTS        BEGSR                                                              AR820729
      *                                                                                     AR820729
      ** Do not allow amendment when there is a pending change on                           AR820729
      ** loan details                                                                       AR820729
      *                                                                                     AR820729
     C                   If        L_CLLSTS = 'R'                                           AR820729
     C                   ADD       1             Idx                                        AR820729
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'                               AR820729
     C                   EVAL      MsgIDArr(Idx) = '5046110'                                AR820729
     C                   Endif                                                              AR820729
      *                                                                                     AR820729
     C                   ENDSR                                                              AR820729
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZCHKH  - Cvt amount fm one ccy to another                     *
      *                                                               *
      *****************************************************************
     C     ZCHKH         BEGSR
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PDateIn
     C                   PARM                    PCurrency
     C                   PARM      *BLANKS       PLocation
     C                   PARM                    PHolInd
     C*
     C**  If PHolInd = 'H' then the date is a holiday.
     C*
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRNCNSP - Validate New Contractual Spread/Sign               *                       CRE073
      *****************************************************************                       CRE073
     C     SRNCNSP       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDNBRTB                                      CRE073
     C                   PARM                    DDNBRAB                                      CRE073
     C                   PARM                    DDNRTFB                                      CRE073
     C                   PARM                    DDCNS2B                                      CRE073
     C                   PARM                    DDCNG2B                                      CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM      'LERI  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDNCNPOK                                     CRE073
     C                   PARM                    DDNCNGOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRNRDMT - Validate New Rounding Method                       *                       CRE073
      *****************************************************************                       CRE073
     C     SRNRDMT       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDM2B                                      CRE073
     C                   PARM                    DDCNS2B                                      CRE073
     C                   PARM                    DDRDF2B                                      CRE073
     C                   PARM      'LERI  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDNRDMOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRNRDFD - Validate New Rounding Fraction/Decimal             *                       CRE073
      *****************************************************************                       CRE073
     C     SRNRDFD       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDF2B                                      CRE073
     C                   PARM                    DDCNS2B                                      CRE073
     C                   PARM                    DDRDM2B                                      CRE073
     C                   PARM      'LERI  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDNRFDOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRNSPRT - Compute for the new spread rate based on the       *                       CRE073
      *            rounding rules                                     *                       CRE073
      *****************************************************************                       CRE073
     C     SRNSPRT       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    TMBSRT                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDCNG2B                                      CRE073
     C                   PARM                    DDRDM2B                                      CRE073
     C                   PARM                    DDRDF2B                                      CRE073
     C                   PARM      *ZERO         PNewSpread                                   CRE073
     C                   PARM      *ZERO         PFinalRate                                 AR847249
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C**********         IF        PFinalRate <= 0  AND                            AR847249 AR947093
     C**********                   DDRDM2B <> *BLANKS                              AR847249 AR947093
     C**********         EVAL      DDNRDMOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      Idx = Idx + 1                                   AR847249 AR947093
     C**********         EVAL      FldNameArr(Idx) = 'DDRDM2'                      AR847249 AR947093
     C**********         EVAL      MsgIDArr(Idx) = 'USS0015'                       AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaArr(Idx) = %EDITC(PFinalRate:'J')         AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        PNewSpread = *ZERO                                         CRE073
     C                   EVAL      DDNRTSB = *BLANKS                                          CRE073
     C                   EVAL      DDNSINB = DDCNG2B                                          CRE073
     C                   ELSEIF    PNewSpread < *ZERO                                         CRE073
     C                             AND DDCNG2B <> 'P'                                         CRE073
                                                                                            AR847249
     C                   EVAL      DDNSINOK = 'W'                                           AR847249
     C                   EVAL      WIdx = WIdx + 1                                          AR847249
     C                   EVAL      WFldNamArr(WIdx) = 'DDNSINB'                             AR847249
     C                   EVAL      WMsgIDArr(WIdx)  = 'USS0016'                             AR847249
     C**********         EVAL      WMsgDtaArr(WIdx) = %EDITC(PNewSpread:'J')       AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(PNewSpread:'J')                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
                                                                                            AR847249
     C                   EVAL      PNewSpread = %ABS(PNewSpread)                              CRE073
     C                   EVAL      DDNRTSB = %CHAR(PNewSpread)                                CRE073
                                                                                              CRE073
     C                   IF        DDCNG2B = 'A'                                              CRE073
     C                   EVAL      DDNSINB = 'S'                                              CRE073
     C                   ELSEIF    DDCNG2B = 'S'                                              CRE073
     C                   EVAL      DDNSINB = 'A'                                              CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDNSINB = DDCNG2B                                          CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDNRTSB = %CHAR(PNewSpread)                                CRE073
     C                   EVAL      DDNSINB = DDCNG2B                                          CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        WxRTF = *BLANKS AND                                        CRE073
     C                             DDCNS2B <> *BLANKS                                         CRE073
                                                                                              CRE073
     C                   Z-ADD     PNewSpread    VNRTS                                        CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR847249 AR947093
     C                   ELSE                                                                 CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                     MD028338
      /EJECT                                                                                MD028338
      *****************************************************************                     MD028338
      *  SRFRCO - Validate FX Rate Change Only Indicator              *                     MD028338
      *****************************************************************                     MD028338
     C     SRFRCO        BEGSR                                                              MD028338
                                                                                            MD028338
     C     DDFRCOB       IFEQ      'Y'                                                      MD028338
     C     DDFRCO        OREQ      'Y'                                                      MD028338
     C     DDACTN        ANDEQ     'X'                                                      MD028338
     C     DDFRCO        OREQ      'Y'                                                      MD028338
     C     DDACTN        ANDEQ     'Q'                                                      MD028338
     C     CLE030        ANDEQ     'Y'                                                      MD028338
                                                                                            MD028338
      ** Entry cannot be Y if loan currency is the same as                                  MD028338
      ** facility currency.                                                                 MD028338
                                                                                            MD028338
     C     CCY           IFEQ      FCCY                                                     MD028338
     C                   ADD       1             Idx                                        MD028338
     C                   EVAL      FldNameArr(Idx) = 'DDFRCOB'                              MD028338
     C                   EVAL      MsgIDArr(Idx) = '5047301'                                MD028338
     C                   MOVE      'N'           DDFRCOOK                                   MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
      ** If Y, New Facility Currency Exchange Rate should not be blanks                     MD028338
                                                                                            MD028338
     C     DDNFCEB       IFEQ      *BLANK                                                   MD028338
     C     DDNFCEB       OREQ      '*'                                                      MD028338
     C     DDNFCE        OREQ      *BLANKS                                                  MD028338
     C     DDACTN        ANDEQ     'X'                                                      MD028338
     C     DDNFCE        OREQ      *BLANKS                                                  MD028338
     C     DDACTN        ANDEQ     'Q'                                                      MD028338
     C     CLE030        ANDEQ     'Y'                                                      MD028338
     C                   ADD       1             Idx                                        MD028338
     C                   EVAL      FldNameArr(Idx) = 'DDFRCOB'                              MD028338
     C                   EVAL      MsgIDArr(Idx) = '5047302'                                MD028338
     C                   MOVE      'N'           DDFRCOOK                                   MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
      ** If Y, input to fields apart from New Facility Currency                             MD028338
      ** Exchange Rate is not allowed.                                                      MD028338
                                                                                            MD028338
     C     DDNFCEB       IFNE      *BLANKS                                                  MD028338
     C     DDNFCEB       ANDNE     '*'                                                      MD028338
     C     DDNFCE        ORNE      *BLANKS                                                  MD028338
     C     DDACTN        ANDEQ     'X'                                                      MD028338
     C     DDNFCE        ORNE      *BLANKS                                                  MD028338
     C     DDACTN        ANDEQ     'Q'                                                      MD028338
     C     CLE030        ANDEQ     'Y'                                                      MD028338
                                                                                            MD028338
     C                   IF        DDNBRAB <> ' ' or DDNBRA <> ' ' or                       MD028338
     C                             DDNRTSB <> ' ' or DDNRTS <> ' ' or                       MD028338
     C                             DDNSINB <> ' ' or DDNSIN <> ' ' or                       MD028338
     C                             DDNCASB <> ' ' or DDNCAS <> ' ' or                       MD028338
     C                             DDNCHIB <> ' ' or DDNCHI <> ' ' or                       MD028338
     C                             DDNBRTB <> ' ' or DDNBRT <> ' ' or                       MD028338
     C                             DDNRTFB <> ' ' or DDNRTF <> ' ' or                       MD028338
     C                             DDNPRAB <> ' ' or DDNPRAM <> ' ' or                      MD028338
     C                             DDNDAMB <> ' ' or DDNDAM <> ' ' or                       MD028338
     C                             DDNIPDB <> ' ' or DDNIPD <> ' ' or                       MD028338
     C                             DDNMDTB <> ' ' or DDNMDT <> ' ' or                       MD028338
     C                             DDNCCYB <> ' ' or DDNCCY <> ' '                          MD028338
     C                   ADD       1             Idx                                        MD028338
     C                   EVAL      FldNameArr(Idx) = 'DDFRCOB'                              MD028338
     C                   EVAL      MsgIDArr(Idx) = '5047303'                                MD028338
     C                   MOVE      'N'           DDFRCOOK                                   MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
     C     DDFRCOOK      IFNE      'N'                                                      MD028338
     C     DDACTN        IFEQ      'A'                                                      MD028338
     C                   MOVEL     DDFRCOB       VFRCO                                      MD028338
     C                   ELSE                                                               MD028338
     C                   MOVEL     DDFRCO        VFRCO                                      MD028338
     C                   ENDIF                                                              MD028338
     C                   ENDIF                                                              MD028338
                                                                                            MD028338
     C                   ENDSR                                                              MD028338
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system  (screen format)
     C                   PARM                    TranIn
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    FrontOffice
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C                   PARM                    WIdx
      * Valid Loans layout (DS) from/to caller
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
      *
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
                                                                                              BUG827
      * Repayment Exist
     C                   PARM                    @WERLN            1
     C                   PARM                    @WLNNO            6
      *
      * Rollover Work Fields
     C                   PARM                    LELERI2
      *
     C                   PARM                    WINCY             1
     C                   PARM                    WPSET             1
     C                   PARM                    WRLDT1            1
     C                   PARM                    WNCCY1            1
     C                   PARM                    MULTIC            1
     C                   PARM                    WSett             1
      * Current Loan
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
      ***  Called from CTU
     C                   PARM                    @@CTU             1
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      ** Define dataareas
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C*
     C     *DTAARA       DEFINE                  SC24X7
     C*
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LELERIVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Customer Lending ICD via access program
      *  (database error handling done in access program)
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      *
      **  Retrieve profit centre accounting ICD.
      *
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C                   ENDIF
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDE002'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDE002            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDE002 = 'Y'
     C                   Endif
                                                                                              CLE031
      ** Access SAR details file to determine if CLE031 is switched on                        CLE031
                                                                                              CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *Blanks       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
     C                   EVAL      CLE031 = 'N'                                               CLE031
     C                   IF        PRTCD = *Blanks                                            CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   ENDIF                                                                CLE031
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
     C                   MOVEL     '902'         DBASE                          * DBERR 902 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      ***Check*if*BLI*Lending*Enhancements*feature*is*installed********                      BUG2579
      *****************************************************************                      BUG2579
     C*****S01465        IFEQ      'Y'                                                       BUG2579
     C**********         MOVE      *ON           *IN60                                       BUG2579
     C**********         END                                                                 BUG2579
      **********                                                                             BUG2579
      ***Check*if*Multi-currency*allowed*by*Loan*facility**************                      BUG2579
      **********                                                                             BUG2579
     C*****@MULTI        IFEQ      'Y'                                                       BUG2579
     C**********         MOVE      *ON           *IN61                                       BUG2579
     C**********         ENDIF                                                               BUG2579
      **********                                                                             BUG2579
      ***Check*if*Funding*Details*are*required*************************                      BUG2579
      **********                                                                             BUG2579
     C*****@FUNDING      IFEQ      'Y'                                                       BUG2579
     C**********         MOVE      *ON           *IN62                                       BUG2579
     C**********         ENDIF                                                               BUG2579
      **********                                                                             BUG2579
      ***Check*if*Rollover*rate*fixing*day*enhancement*-*CLE011********                      BUG2579
      ***feature*is*installed******************************************                      BUG2579
      **********                                                                             BUG2579
     C*****CLE011        IFEQ      'Y'                                                       BUG2579
     C**********         MOVE      *ON           *IN63                                       BUG2579
     C**********         END                                                                 BUG2579
      *
      ** Determine if 24x7 Midas Availability active?
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011            1
     C                   ELSE
     C                   MOVE      'N'           CSC011
     C     PRTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     900           DBASE                          * DBERR 900 *
     C                   MOVEL     'CSC011'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C*
     C* Is the support system on?
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
      *
      **  Access Switchable SAR details for the existence of CEU004
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU004'      PSARD
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004            1
     C                   ELSE
     C                   MOVE      'N'           CEU004
     C     PRTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     901           DBASE                          * DBERR 901 *
     C                   MOVEL     'CEU004'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Determine if Lending Enhancements for BHF-London is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE014'      PSARD
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C     PRTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     902           DBASE                          * DBERR 902 *
     C                   MOVEL     'CLE014'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       PRTCD                                        BUG827
     C                   PARM      '*VERIFY '    POPTN                                        BUG827
     C                   PARM      'CAS001'      PSARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
      *                                                                                       BUG827
     C     PRTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                              BUG827
      ** Determine if CAS005 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       PRTCD                                        BUG827
     C                   PARM      '*VERIFY '    POPTN                                        BUG827
     C                   PARM      'CAS005'      PSARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
      *                                                                                       BUG827
     C     PRTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS005            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS005                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if CLE023 is installed                                                    BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       PRTCD                                       BUG2579
     C                   PARM      '*VERIFY '    POPTN                                       BUG2579
     C                   PARM      'CLE023'      PSARD                                       BUG2579
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2579
                                                                                             BUG2579
     C     PRTCD         IFEQ      *BLANKS                                                   BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                              CLE106
      ** If CLE106 is available                                                               CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       PRTCD                                        CLE106
     C                   PARM      '*VERIFY '    POPTN                                        CLE106
     C                   PARM      'CLE106'      PSARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        PRTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
      *****************************************************************              CLE035 BUG10622
      ***If*CLE035*is*available****************************************              CLE035 BUG10622
      *****************************************************************              CLE035 BUG10622
     C*******************EVAL******CLE035*=*'N'************************              CLE035 BUG10622
     C*******************CALLB*****'AOSARDR0'**************************              CLE035 BUG10622
     C*******************PARM*******Blanks*******PRTCD*****************              CLE035 BUG10622
     C*******************PARM******'*VERIFY*'****POPTN*****************              CLE035 BUG10622
     C*******************PARM******'CLE035'******PSARD*****************              CLE035 BUG10622
     C*****SCSARD********PARM******SCSARD********DSFDY*****************              CLE035 BUG10622
      *****************************************************************              CLE035 BUG10622
     C*******************IF********PRTCD*=**Blanks*********************              CLE035 BUG10622
     C*******************EVAL******CLE035*=*'Y'************************              CLE035 BUG10622
     C*******************ENDIF*****************************************              CLE035 BUG10622
                                                                                             BUG9655
      ** If CLE036 is available                                                              BUG9655
                                                                                             BUG9655
     C                   EVAL      CLE036 = 'N'                                              BUG9655
     C                   CALLB     'AOSARDR0'                                                BUG9655
     C                   PARM      *Blanks       PRTCD                                       BUG9655
     C                   PARM      '*VERIFY '    POPTN                                       BUG9655
     C                   PARM      'CLE036'      PSARD                                       BUG9655
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9655
                                                                                             BUG9655
     C                   IF        PRTCD = *Blanks                                           BUG9655
     C                   EVAL      CLE036 = 'Y'                                              BUG9655
     C                   ENDIF                                                               BUG9655
      *
      ** Determine if CAS016 is installed                                                     CAS019
                                                                                              CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRTCD                                        CAS019
     C                   PARM      '*VERIFY '    POPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
      *                                                                                       CAS019
     C     PRTCD         IFEQ      *BLANKS                                                    CAS019
     C                   MOVE      'Y'           CAS016            1                          CAS019
     C                   ELSE                                                                 CAS019
     C                   MOVE      'N'           CAS016                                       CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CRE073
      ** Determine if CRE073 Interest Rate Rounding feature is installed                      CRE073
                                                                                              CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY '    POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
      *                                                                                       CRE073
     C     PRTCD         IFEQ      *BLANKS                                                    CRE073
     C                   MOVE      'Y'           CRE073                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      'N'           CRE073                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CAS019
      **  Key list for LELOAML0
      *
     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0
      *
      **  Key list for FCLTY
      *
     C     K#FCLT        KLIST
     C**********         KFLD                    WFCUS             6 0                        CSD027
     C                   KFLD                    WFCUS             6                          CSD027
     C                   KFLD                    WFTYP             3 0
     C                   KFLD                    WFSEQ             2 0
     C                   KFLD                    WRCTP             1
      *
      **  Key list for CLOAN
      *
     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
      **  Initialise work fields
      *
     C**************     EXSR      SRINIW                                                     WA0022
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @type             1
     C*
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELERIV069
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                                       CLE064
      ** Changed Array FTAB from 'WQXY' to 'DWFMTQ45X789VEYCIJNU'                             CLE064
      *                                                                                       CLE064
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
**  FTAB
DWFMTQ45X789VEYCIJNU                                                                          CLE064
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
