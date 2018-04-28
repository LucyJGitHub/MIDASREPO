     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayment validate and update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LEMAPYVU - LE Manual repayment validate and update           *
      *                                                               *
      *  Function: This Program Validates Manual repayments for       *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Manual repayment details fields   *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. CDL094             Date 01Sep14               *
      *                 MD025009B          Date 12May14               *
      *                 MD024398           Date 11May14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD022301           Date 06Sep13               *
      *                 AR868380           Date 11Jun13               *
      *                 MD020733           Date 14Jun13               *
      *                 MD020445           Date 16May13               *
      *                 AR830785           Date 07May13               *
      *                 AR1080805          Date 25Feb13               *
      *                 AR1005230          Date 07Feb13               *
      *                 AR1070996          Date 20Dec12               *
      *                 AR805843           Date 14Oct12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863279           Date 09Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249232             Date 18Jul07               *
      *                 247673             Date 10May07               *
      *                 246120             Date 05Mar07               *
      *                 244955             Date 12Jan07               *
      *                 244552             Date 19Dec06               *
      *                 249205             Date 20Jul07               *
      *                 BUG13710           Date 03Apr07               *
      *                 244636             Date 15Feb07               *
      *                 245082             Date 30Jan07               *
      *                 243757             Date 17Nov06               *
      *                 BUG13350           Date 20Feb07               *
      *                 BUG13331           Date 15Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240070             Date 26May06               *
      *                 239587             Date 14May05               *
      *                 CSD031             Date 10Apr06               *
      *                 239364             Date 11May06               *
      *                 CSD027A            Date 09May06               *
      *                 236151             Date 22Nov05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9754            Date 03Feb06               *
      *                 BUG8124            Date 10Aug05               *
      *                 BUG8944            Date 12Oct05               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4502            Date 08Oct04               *
      *                 BUG4211            Date 11Sep04               *
      *                 BUG4183            Date 10Sep04               *
      *                 BUG4208            Date 16Sep04               *
      *                 BUG4153            Date 03Sep04               *
      *                 BUG3114            Date 09Aug04               *
      *                 BUG2480            Date 26May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CDE005             Date 14Jan03               *
      *                 CAP084  *CREATE    Date 20Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *              (Recompile)                                      *
      *  MD025009B - API returned a Serious midas error has occurred  *
      *  MD024398 - API Performance Optimisation                      *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD022301 - Missing branch in defaulted account from original *
      *             loan                                              *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD020733 - CLE134_ transfer to past due duplicated. Output   *
      *             record to LELOMKPD (same as LOAMSDK) when MR is   *
      *             created by PDCL generation in IC. Reuse UpSRFlg   *
      *             to check MR Autogen events from PDCL online.      *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  AR830785 - Looping on insert of accrued interest adjustment  *
      *             Extended core fix 263533. (Child: AR830786)       *
      *  AR1080805 - Error in LEMAPYUPD                               *
      *  AR1005230 - Error on cross ccy settlement of a Manual        *
      *              Repayment on a Loan (Child:AR1005231)            *
      *              (Recompile)                                      *
      *  AR1070996 - Unable to create Manual Repayment_A serious Midas*
      *              error occurred                                   *
      *  AR805843 - Zero-outstanding interest to date displayed on    *
      *             MAPY. Do not zeroise WrkPaidInt if interest rate  *
      *             is zero. (Child: AR805844)                        *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - CC02: Manual Repayment Feature                      *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - Some codes of AR863279 will be physically deleted  *
      *          - CCR016: Settlement Allocation                      *
      *  AR863279 - Pay Settlement Customer Name on Input fields      *
      *             are not displayed                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249232 - Recompile over changes LEMAP2PD. Reinstate 244552.  *
      *  247673 - Roll back also when the updater returns '*RECUPD'   *
      *           because it may have already changed several files   *
      *           before the error is encountered.                    *
      *           The commit of changes was done whatever is the      *
      *           return code *BLANKS or '*RECUPD'.                   *
      *  246120 - Changed code to default settlement receipt for loan/*
      *           parts purchased and settlement payment for part sold*
      *  244955 - Recompile over changes LEMAP2PD. Reverse 244552.    *
      *  244552 - Recompile over changes LEMAP2PD.                    *
      *  249205 - Protect pay/receive settlement details flag         *
      *           according to processing types                       *
      *  BUG13710- Populate DDATYP only during update                 *
      *  244636 - If no settlement details for MAPY are entered       *
      *           then default settlement details from related loan   *
      *  245082 - Corrected processing for ADDI = 'B' to treat it as  *
      *           First day from start date and to add 1 day on       *
      *           maturity date.                                      *
      *  243757 - Default loan settlement if no extended settlement   *
      *           default exists.                                     *
      *         - annotated as BUG13331                               *
      *  BUG13331- If defaulted settlement details don't exist then   *
      *            default the settlement details from the loan       *
      *  BUG13350-Ensure Amendment type screen field is populated     *
      *  240070 - No Default Settlement details during Insert Mode.   *
      *           Refer to 8944.
      *  239587 - For MAPY there are either pay or receive, never     *
      *           both sides of settlement, therefore need to stop    *
      *           validation that pay and rec ccy are the same.       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  239364 - No Default Settlement details during Insert Mode.   *
      *           (Same as BUG8944)                                   *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  236151 - unable to input a reversal.                         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9754 - Recompiled due to changes in LEMAP2PD.             *
      *  BUG8124 - Msg error display if Currency not specified        *
      *  BUG8944 - Used correct customer and processing type for call *
      *            to default settlement program.                     *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits.       *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates                           *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG4502 - Memos not updated during insert.                   *
      *  BUG4211 - Database error is reported if loan not specified   *
      *  BUG4183- Settlement details overwritten during authorisation *
      *           Thus, causing the system to post the MR to suspense *
      *           account.                                            *
      *  BUG4208- Make sure correct customer used for call to default *
      *           settlements program.                                *
      *           Clear settlement instructions depending on the loan *
      *           processing type - rules are as follows :-           *
      *           Processing types 61/62/63/64/65/68/70/71 should be  *
      *           receipt only.                                       *
      *           Processing types 66/67/69/72 should be payment only.*
      *           Overwite with 00 in above cases.                    *
      *  BUG4153 - MAPY showing 0.00 in outstanding interest to date  *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CDE005 - Reservation ID                                      *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Facility Details file
     F                                     Include(FCLTYFMF)
     F                                     Prefix(FC_)
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(LOAMSDKF:LOAMRPY)
      ***  Midas Loan Amendment File (Live Record)
     F                                     PREFIX(RPY_)
 
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE035
      ***  Midas LE Facility Extension file                                                   CLE035
     F                                     Prefix(LT)                                         CLE035
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      *
      ***  Compile time Array
     D POWER           S              7S 3 DIM(7) CTDATA PERRCD(1)
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
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
 
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
     D                                     INZ                                             AR1070996
     D***LoanRecInst          459    527                                                      CGL029
     D***LoanPayInst          528   1086                                                      CGL029
     D  LoanRecInst          473    527                                                       CGL029
     D  LoanPayInst          542   1086                                                       CGL029
     D  LoanRecInstEx       1597   1614                                                       CGL029
     D  LoanPayInstEx       1615   1632                                                       CGL029
      ***  Loan Payment/receipt instructions
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(PD_)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
      *
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Transaction
     D TranInMAPY    E DS                  EXTNAME(LEMAPYPD)
     D TranInMAP2    E DS                  EXTNAME(LEMAP2PD)                                  CLE106
     D  Incomkey               1     51
 
      ** Interface Data Format Definition File format                                         CAP086
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      ** Repayment schedule Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(LEMAEXPD)
 
      ** Valid repayment schedules layout
     D ValidMAPY     E DS                  EXTNAME(LEVMAPYPD)
     D                                     PREFIX(V_)
     D***ValidREC             321    389                                                      CGL029
     D***ValidPAY             390    948                                                      CGL029
     D  ValidREC             335    389                                                       CGL029
     D  ValidPAY             404    948                                                       CGL029
     D  ValidRECEx          1195   1212                                                       CGL029
     D  ValidPAYEx          1213   1230                                                       CGL029
 
      ** (Current) repayment schedule in file Format
     D MAPYFilFmt    E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(MR_)
 
      ** (Current) Transaction in Screen Format - Main Details
     D CurTrMAPY     E DS                  EXTNAME(LEMAPYPD)
     D                                     PREFIX(@)
     D  Insertkey              1     51
 
      ** Error indicators
     D OKTrMAPY      E DS                  EXTNAME(LEEMAPYPD)
 
      ** Pay Settlement Instructions - Input
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      ** Receive Settlement Instructions - Input
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      ** FRA/IRS Settlement Instructions - Input
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      ** Pay Settlement Instructions - File (D/B) format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
      ** Receive Settlement Instructions - File (D/B) format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
      ** FRA/IRS Settlement Instructions - File (D/B) format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
      ** Old settlement details
     D  OldStsDS       DS
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
 
      ** New settlement details
     D  NewStsDS       DS
     D  WTYPE                  1      2
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
      *
     D PassDtaDS       DS           512
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D WrkDDESEQ              11     13A
     D WrkDDPASD              14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
 
 
      ** Flags to indicate whether Pay Settlement instruction fields
      ** are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether Receive Settlement instruction fields
      ** are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
 
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                 BUG3114
      ** External DS for General Ledger Details                                              BUG3114
                                                                                             BUG3114
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSF011
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A                                                      CLE106
 
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Parameters for LEMAPYRTV
     D ModeofOp        S              6
     D WrkWHoldTaxRat  S             11  7
     D WrkExpectTyp    S              1
     D WrkPTYP72       S              1
     D WrkExpAmdTp     S              2
     D WrkRepayTp      S              1  0
 
      ** LEMAPYCVT parameters
     D WrkProcTypLoan  S              2  0
     D WrkOutPrinc     S             13  0
     D WrkRemainInt    S             13  0
 
      ** Parameters for ZASETINDFT
     D ##CALP          S              4
     D ##PCCY          S              3
     D ##RCCY          S              3
     D ##CSNM          S             10
     D ##TTYP          S              2
     D ##FFND          S              1
     D BQISDA          S              4
     D BQAGTY          S              6
     D BQAGDT          S              6
     D BQAGVV          S              2
     D Blank2          S              2
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Parameters for ZDATE1
     D DATEA           S              6
     D*ZDAYNO**********S              5  0                                                   BUG3114
     D ZDAYNmbr        S              5  0                                                   BUG3114
     D ErrorFlag       S              1
 
      ** Parameters for ZASETINVAL
     D ##BRCA          S              3
     D ##DATR          S              5  0
     D ##DATP          S              5  0
     D ##ACTN          S              1
     D ##VALITER       S              3
     D ##PPAY          S              1                                                       222373
     D ##PREC          S              1                                                       222373
 
      ** Parameters for LEMAPYAMD
     D ResetErrs       S              1
 
      ** Parameters for *ENTRY
     D UpdateYN        S              1
     D Buffer          S           6000
     D APIRetc         S              1
 
     D  ZOUT22         DS            22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *                                                                                      BUG3114
      ** Data structure to define variables used in holiday sub-routines                     BUG3114
      *                                                                                      BUG3114
     D  ZIND           S              1                                                      BUG3114
     D  ZDAYNO         S              5  0                                                   BUG3114
     D  ZCCY           S              3                                                      BUG3114
     D  ZLOC           S              3                                                      BUG3114
      *                                                                                      BUG3114
     D                 DS
     D  TmpLPAM                1     13 00
     D  TmpRATE1               1     13 07
 
     D CLE106          S              1                                                       CLE106
     D CLE036          S              1                                                       CLE106
     D TmpRPRI         S             14                                                       CLE106
     D TmpRINT         S             14                                                       CLE106
     D TmpRTOT         S             14                                                       CLE106
     D TmpRPEN         S             14                                                       CLE106
     D TmpPTYP         S              2S 0                                                   BUG8944
     D CDE005          S              1
     D WOSAC           S             18                                                       CGL029
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
     D CAP086          S              1A                                                      CAP086
                                                                                              CAP086
     D WKCNUM          S              6A                                                      CLE035
     D WKFACT          S              3A                                                      CLE035
     D WKFCNO          S              2A                                                      CLE035
                                                                                              244636
      ** Parameter for LEMAPYRTV                                                              244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
                                                                                              244636
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   EVAL      TranInMAPY = Trans5001
     C                   EVAL      TranInMAP2 = Trans5002                                     CLE106
     C                   EVAL      InfData = InfData500                                       CAP086
     C                   EVAL      Extdata = Extdata500
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_MRAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                            BUG13350
      ***Set*up*Amendment*Type*field*to*be*'MR'************************            BUG13350 BUG13710
     C**********         EVAL      DDATYP = 'MR'                                   BUG13350 BUG13710
 
      ** Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      ** Validate Action Code
     C                   EXSR      VALIDATEAC
 
      *  Display output only fields
      ** Currency
     C**********         IF        CLE036 = 'N' Or DDSCCY = *Blanks                   CLE106 BUG8124
     C**********         EVAL      DDSCCY = WRKLNCCY                                         BUG8124
     C**********         ENDIF                                                        CLE106 BUG8124
 
      ** Amount
     C                   CLEAR                   SDCURR                                      BUG4211
     C**********         MOVEL     DDSCCY        @CURR             3                         BUG8124
     C                   MOVEL     WRKLNCCY      @CURR             3                         BUG8124
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C*****@RTCD         IFNE      *BLANKS                                                   BUG4211
     C**********         MOVEL     @CURR         DBKEY                                       BUG4211
     C**********         MOVEL     'SDCURRPD'    DBFILE                                      BUG4211
     C**********         MOVEL     '002'         DBASE                                       BUG4211
     C**********         EXSR      *PSSR                                                     BUG4211
     C**********         ENDIF                                                               BUG4211
 
     C                   MOVE      A6NBDP        CrNBDP            1 0
 
     C                   Z-ADD     WRKLNCPAM     ZFLD15           15 0
     C                   Z-Add     CrNBDP        ZDECS             1 0
     C                   MOVE      'J'           ZECODE
 
     C                   EXSR      ZFRPED
      *
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDCURP
     C                   else
     C                   MOVE      Zout20        DDCURP
     C                   endif
      *
      * Withholding tax amount
     C                   if        PD_VDAT <> 0
     C                   Z-ADD     PD_WTXA       WrkExpWtx        13 0
     C                   Z-ADD     WrkExpWtx     ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDWHTX
     C                   else
     C                   MOVE      ZOUT20        DDWHTX
     C                   endif
     C                   endif
 
      * Withholding tax indicator
     C                   MOVE      WRKLNWTIN     DDWTTP
 
      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon Action Code
     C                   SELECT
 
      ** Processing for Inserts
     C                   WHEN         DDACTN = 'I'
     C                   EVAL         Insertkey = Incomkey
     C                   EXSR      SetupIns
      *
      ***  PUT Loan details in Transaction to be validated
 
     C                   EXSR      ValidateTr
                                                                                              CLE106
     C                   IF        CLE036 = 'Y'                                               CLE106
     C                   EXSR      SRCnvAmt                                                   CLE106
     C                   ENDIF                                                                CLE106
 
      ** If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
                                                                                CDE005
      ** Validate reservation id for -ve manual repayments only                 CDE005
     C     UpdateYN      IFEQ      'Y'                                          CDE005
     C     CDE005        ANDEQ     'Y'                                          CDE005
     C     DDPSIG        ANDEQ     '-'                                          CDE005
     C                   EXSR      ValidateRs                                   CDE005
                                                                                CDE005
     C                   IF        Idx <> 0                                     CDE005
     C                   GOTO      INVALID                                      CDE005
     C                   ENDIF                                                  CDE005
                                                                                CDE005
     C                   ENDIF                                                  CDE005
      ***********                                                                      244636 249205
      ***Default*settlement details from related loan                                  244636 249205
     C***********        IF        InRecSttmt = *blank AND                             244636 249205
     C***********                  PRcvParm <> *blank                                  244636 249205
     C***********        MOVEL     PRcvParm      InRecSttmt                            244636 249205
     C***********        ENDIF                                                         244636 249205
      ***********                                                                      244636 249205
      ***Protect*Pay Settlement from Validation as it is already not in use            244636 249205
     C***********        EVAL      ##PPAY = 'Y'                                        244636 249205
 
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
 
      ** Processing for Amends or Changes
     C**********         WHEN      DDACTN = 'A' OR DDACTN = 'R'                              BUG4183
     C                   WHEN      DDACTN = 'A' OR DDACTN = 'R' OR DDACTN = 'X'              BUG4183
     C                   EXSR      SetupAmd
                                                                                              CLE106
     C                   IF        CLE036 = 'Y'                                               CLE106
     C                   EXSR      SRCnvAmt                                                   CLE106
     C                   ENDIF                                                                CLE106
 
      ** If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   If        DDACTN <> 'R'                                              CLE164
     C                             and CLE134 = 'Y'                                           CLE164
     C                   EXSR      ValidateTr                                                 CLE164
     C                   EndIf                                                                CLE164
                                                                                              CLE164
     C                   EXSR      ValidateSt
     C                   IF        DDACTN = 'A'
     C                   EXSR      ValdateAmd
     C                   ENDIF
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Populate Customer Name on Input fields                                               CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      ** Write to database
     C                   IF        UpdateYN = 'Y' AND Idx = 0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      ** Remerge buffer with all relevant data structures
     C*******************EVAL      Buffer = TranInMAPY + ReservID                            BUG2480
     C*******************                  + InRecSttmt + InPaySttmt + ExtData               BUG2480
 
     C                   EVAL      Buffer = TranInMAPY                                       BUG2480
     C                                     + TranInMAP2                                       CLE106
     C**********                           + UpSRFlg                              AR1080805 MD020445
     C                                     + UpSRFlg                                        MD020733
     C                                     + DDAuto                                           CLE164
     C**********                           + InRecSttmt + InPaySttmt + ExtData        BUG2480 CAP086
     C                                     + InRecSttmt + InPaySttmt + InfData                CAP086
     C                                     + ExtData                                          CAP086
     C                   RETURN
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
      ** Validate action code versus transaction IDs supplied
      ** The repayment sch. in file format from the LE database is retrieved
      ** as well.
     C                   CALLB     'LEMAPYRTV'
 
      ** Inputs
 
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *BLANKS       ModeofOp
 
      ** Response mode
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
 
      ** (Midas) Transaction Number
     C                   PARM                    DDLNRF
 
      ** (Midas) Value date
     C                   PARM                    DDVALD
 
      **(Midas) Sequence no.
     C                   PARM                    DDSEQN
     C                   PARM                    DDEVAL
     C                   PARM                    DDESEQ
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014
 
      ** Outputs
 
      ** (Current) Repayment sch. in file format
     C                   PARM                    MAPYFilFmt
 
      ** OK - Action code
     C                   PARM                    DDActnOK
 
      ** OK - Transaction Number
     C                   PARM                    DDLnrfOK
 
      ** OK - Value Date
     C                   PARM      *BLANK        DDValdOK
 
      ** OK - Sequence no.
     C                   PARM      *BLANK        DDSeqnOK
     C                   PARM      *BLANK        DDEVALOK                       OK Expected Date
     C                   PARM      *BLANK        DDESEQOK                       OK Expected Sequence
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators/DS for display and Managements
     C                   PARM                    WrkWHoldTaxRat                 W/hold Tax Rate
     C                   PARM      ' '           WrkExpectTyp                   Expect Amend Loan tp
     C                   PARM      ' '           WrkPTYP72                      Expected on type 72
     C                   PARM      '  '          WrkExpAmdTp                    PD/RE Amend Type
     C                   PARM      0             WrkRepayTp                     Loan Repay. Type
     C                   PARM                    WrkReactFacil                  React. Matured
     C                   PARM      0             WrkCntrMR                      Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkLnDetails                   Loan File Fmt
 
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM                    PRcvParm                                     244636
     C**********         PARM      *BLANKS       UpSRFlg           1                 CLE134 MD020445
     C                   PARM                    UpSRFlg           1                          CLE164
     C                   PARM                    DDauto            1                          CLE164
 
      ** Save the settlement details for update if not insert
     C                   IF        DDACTN <> 'I'
     C                   EVAL      OSETP = MR_SETP
     C                   EVAL      OOSAC = MR_OSAC
     C                   EVAL      OTSEN = MR_TSEN
     C                   EVAL      OFACO = MR_FACO
     C                   EVAL      ValidMAPY = MAPYFilFmt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
 
      *****************************************************************
      * SetupIns - Set up relevant screen fields for insert mode      *
      *****************************************************************
     C     SetupIns      BEGSR
 
      **  Key to retrieve Facilty loan Details
     C     KEYLoanFac    KLIST
     C**********         KFLD                    K@CNUM            6 0                       CSD027A
     C                   KFLD                    K@CNUM            6                         CSD027A
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
      *                                                                                       CLE035
      ***  Key to retrieve Facility Extension file                                            CLE035
      *                                                                                       CLE035
     C     KEYFaciExt    KLIST                                                                CLE035
     C                   KFLD                    WKCNUM                                       CLE035
     C                   KFLD                    WKFACT                                       CLE035
     C                   KFLD                    WKFCNO                                       CLE035
 
      **  Retrieve Facility details
     C                   EVAL      K@CNUM = WRKLNFCUS
     C                   EVAL      K@FACT = WRKLNFTYP
     C                   EVAL      K@FCNO = WRKLNFSEQ
 
     C     KEYLoanFac    CHAIN     FCLTY
      *                                                                                       CLE035
      ** Retrieve corresponding Facilities extension file                                     CLE035
      *                                                                                       CLE035
     C                   MOVEL     K@CNUM        WKCNUM                                       CLE035
     C                   MOVEL     K@FACT        WKFACT                                       CLE035
     C                   MOVEL     K@FCNO        WKFCNO                                       CLE035
     C     KEYFaciExt    CHAIN     LEFCLTLH                                                   CLE035
      ** Date
     C                   MOVE      DDVALD        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C**********         PARM                    ZDAYNO            5 0                       BUG3114
     C**********         Z-ADD     ZDAYNO        MR_VDAT                                     BUG3114
     C**********         Z-ADD     ZDAYNO        WrkValDate        5 0                       BUG3114
     C                   PARM                    ZDAYNmbr          5 0                       BUG3114
     C                   Z-ADD     ZDAYNmbr      MR_VDAT                                     BUG3114
     C                   Z-ADD     ZDAYNmbr      WrkValDate        5 0                       BUG3114
      *
      ***  Calculate Outstanding Interest
      *
     C                   EXSR      OutstInt
      *
     C                   Z-ADD     WrkOutIntr    ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
 
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDINTD
     C                   else
     C                   MOVE      ZOUT20        DDINTD
     C                   endif
      *                                                                                      BUG3114
      ***  For flat rate personal loans, calculate interest refunded and                     BUG3114
      ***  charges refunded                                                                  BUG3114
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y' and WrkLnPTYP = 80                           BUG3114
     C                   EXSR      SRRFND                                                    BUG3114
      *                                                                                      BUG3114
      ***  Add charges and/or interest to the principal where these                          BUG3114
      ***  have been added on, but only if the loan hasn't started                           BUG3114
      *                                                                                      BUG3114
     C                   If        WrkLnORED = BJRDNB                                        BUG3114
     C                             or WrkLnORED < WrkLnVDAT                                  BUG3114
     C                   if        WrkLnADIF = 'Y'                                           BUG3114
     C                   ADD       WrkLnFLTI     WrkOutPrinc                                 BUG3114
     C                   ADD       WrkLnFLTI     WrkLnCPAM                                   BUG3114
     C                   endif                                                               BUG3114
     C                   if        WrkLnADCF = 'Y'                                           BUG3114
     C                   ADD       WrkLnCHGA     WrkOutPrinc                                 BUG3114
     C                   ADD       WrkLnCHGA     WrkLnCPAM                                   BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   Endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   Endif                                                               BUG3114
      *
      ***  Calculate Expected Loan Details
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
     C                   Z-ADD     0             WrkExpPrin       13 0
     C                   if        PD_VDAT <> 0
      *
     C                   MOVE      PD_VDAT       ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
     C                   MOVE      ZDateFmt6     DDEVAL
      *
     C                   MOVE      PD_LASN       DDESEQ
      *
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
      ***  Expected Principal Amount
      *
     C                   if        DDESEQ = 'LN '
     C                   Z-ADD     WRKLNRAMT     WrkExpPrin
     C                   Else
     C                   Z-ADD     PD_PRAM       WrkExpPrin
     C                   Endif
     C                   Z-ADD     WrkExpPrin    ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPRI
     C                   else
     C                   MOVE      ZOUT20        DDEPRI
     C                   endif
      *
      ***  Expected Interest/Withholding tax Amounts
      *
     C                   Z-ADD     PD_INTA       WrkExpInt        13 0
     C                   Z-ADD     WrkExpInt     ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEINT
     C                   else
     C                   MOVE      ZOUT20        DDEINT
     C                   endif
      *
      ***  Expected Total
      *
     C                   IF        DDESEQ = 'LN '
     C                   Z-ADD     WRKLNRAMT     WrkExpTot        13 0
     C                   Else
     C                   Z-add     PD_TAMT       WrkExpTot
     C                   endif
     C                   Z-ADD     WrkExpTot     ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDETOT
     C                   else
     C                   MOVE      ZOUT20        DDETOT
     C                   endif
      *
      ***  Calculated Expected Penality
      *
     c                   Z-ADD     0             WrkExpPen        13 0
     C                   IF        MR_VDAT > PD_VDAT and PD_AMTP = 'PD'
     C                   EXSR      SRPNAM
      *
     C                   Z-ADD     WrkExpPen     ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPEN
     C                   else
     C                   MOVE      ZOUT20        DDEPEN
     C                   endif
     C                   Endif
      *
     C                   Endif
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ZFRPED -                                                      *
      *****************************************************************
     C     ZFRPED        BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * OutstInt    - Calculate Outstanding Interest                  *
      *****************************************************************
     C     OutstInt      BEGSR
      *
      ***  Calculate Amounts to be displayed : Outstanding Interest
      ***  Calculate Evaluate Principal (WrkOutPrinc) and Evaluate Interest
      *
     C                   Z-ADD     WRKLNCPAM     WrkOutPrinc      13 0
     C                   Z-ADD     0             WrkMRIntr        13 0
     C                   Z-ADD     0             WrkOutIntr       13 0
      *
      ***  Read all live Loan Amendments to know Active Repayments
      *
     C**********         MOVE      DDLNRF        K@LNRF            6 0                        CLE148
     C                   MOVE      DDLNRF        K@LNRF            6                          CLE148
     C     k@LNRF        SetLL     LOAMRPY
     C     k@LNRF        READE     LOAMRPY                                99
     C                   DoW       *IN99= *OFF
      *
     C                   select
     C                   when      RPY_AMTP = 'MR'
     C                             AND RPY_XAVD = 0                                           236151
      *
      ***  Manual Repayment
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'RE' and RPY_AUTO = 'Y'
     C**********                   or RPY_AMTP = 'RE' and RPY_AUTO = 'C'             CLE134 MD020445
     C**********                   and  CLE134 = 'Y'                                 CLE134 MD020445
      *
      ***  Repayment schedule
      ***  if Currency is not = To current Details, Convert
      *
     C                   if        RPY_CCY <> WRKLNCCY
     C                   MOVEL     RPY_CCY       @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-Add     0             WrkAmnt          19 3
     C                   Z-ADD     A6NBDP        WrNBDP            1 0
     C                   Eval(H)   WrkAmnt = (RPY_PRAM)
     C                                      * power((CrNBDP-WrNBDP)+4)
     C                   if        WRKLNFMDI = 'D'
     C                   Eval(H)   RPY_PRAM = Wrkamnt*WRKLNFCXR
     C                   else
     C                   Eval(H)   RPY_PRAM = Wrkamnt/WRKLNFCXR
     C                   endif
     C                   Endif
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PF'
      *
      ***  Principal F.....
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PI' or RPY_AMTP = 'PT'
      *
      ***  Principal Increase or Principal T....
      *
     C                   if        RPY_VDAT < WrkValDate
     c                   Eval      WrkOutPrinc = WrkOutPrinc + RPY_PRAM
     C                   Endif
     C                   Endsl
      *
     C     k@LNRF        ReadE     LOAMRPY                                99
      *
     C                   Enddo
      *
      ***  Recalculate Interest on period : Setup Fields for GLINTC
      *
     C                   if        WrkValDate > BJRDNB and CLE005 = 'Y'
     c                   Z-ADD     WrkValDate    ZIEND             5 0
     C                   else
     C                   Z-ADD     BJRDNB        ZIEND
     C                   endif
      *
     C                   if        WRKLNMDAT <> 0 and WRKLNMDAT < BJRDNB
     C                   Z-ADD     WRKLNMDAT     ZIEND
     C                   endif
      *
     C                   if        WrkReactFacil = 'Y' and CLE007 = 'Y'
     C                   Z-ADD     0             ZINTR
     c                   Else
      *
      *** Add 1 day to End Date depending on Loan Add Day indicator
      *
     c                   Z-ADD     WRKLNIACD     ZIBEG
     C**********         if        WRKLNADDI = 'B' and ZIBEG = WrkValDate                     245082
     C                   if        WrkLnADDI = 'B' and ZIEND = WrkLnMDAT                      245082
     C                             and WrkLnORED < WrkLnMDAT                                  245082
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
      ***  if Original entry Date is after Maturity Date
      *
     C                   if        WRKLNADDI = 'B' and WRKLNORED >= WRKLNMDAT
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
     C                   MOVE      WRKLNICBS     ZICALC
     C                   MOVE      WRKLNINTR     ZIRATE
     C                   Z-ADD     WRKLNCPAM     ZIAMT
      *
     C                   If        CLE028 = 'Y' and WrkLnPTYP = 80                           BUG3114
     C                   EXSR      SROSIN                                                    BUG3114
     C                   Z-ADD     ZINTR         WrkOutIntr                                  BUG3114
     C                   else                                                                BUG3114
     C/COPY WNCPYSRC,LEH01280
     C                   EXSR      GLINTC
     C/COPY WNCPYSRC,LEH01384
     C                   Endif                                                               BUG3114
      *
      ***  Round interest if defined so.
      *
     C                   IF        WRKLNRDFC = 'Y'
     C                             and WrkLnPTYP <> 80                                       BUG3114
     C                   Z-ADD     ZINTR         WrkIntRound      13 0
     C                   Z-ADD     WrkIntRound   ZINTR
     C                   Endif
      *
     C                   endif
      *
      ***  Compute interest paid
      *
     C                   Z-ADD     0             WrkPaidInt       13 0
      *
     C                   if        WRKLNMDAT < WRKLNIACD and WRKLNMDAT <> 0
     C                             and WRKLNRECI = 'D'
     C                   Eval      WrkPaidInt=WRKLNAIAP+WRKLNAIMN+WRKLNPDIN
      *
     C                   Else
      *
      ***  Check if Stop Accrual is true
      *
     C                   TESTB     '3'           WRKLNLONI                99
     C                   If        *IN99 = *ON
     C                   Eval(h)   WrkPaidInt=WRKLNAITC+WRKLNAIAP+WRKLNAIMN
     C                   Else
     C                   if        CLE028 = 'N' or CLE028 = 'Y'                              BUG3114
     C                             and WrkLnPTYP <> 80                                       BUG3114
     C                   Eval(h)   WrkPaidInt=ZINTR+WRKLNAITC                                BUG3114
     C                   endif                                                               BUG3114
     C**********         Eval(h)   WrkPaidInt=ZINTR+WRKLNAITC+WRKLNAIAP                      BUG3114
     C**********                   +WRKLNAIMN                                                BUG3114
     C**********         Eval(h)   WrkPaidInt=WRKLNAIAP+WRKLNAIMN                    BUG3114 BUG4153
     C                   EVAL(H)   WrkPaidInt = WrkPaidInt+WRKLNAIAP+WRKLNAIMN               BUG4153
     C                   Endif
     C                   endif
      *
      ***  Substract Interest already paid
      *
     C                   If        CLE028 = 'N' or (CLE028 = 'Y'                             BUG3114
     C                             and WrkLnPTYP <> 80) or (CLE028 = 'Y'                     BUG3114
     C                             and WrkLnPTYP = 80 and WrkLnADIF <> 'Y')                  BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-WRKLNIPRD                           BUG3114
     C**********         Eval      WrkPaidInt=WrkPaidInt-WRKLNIPRD-WRKLNICTD                 BUG3114
     C**********                   -WRKLNIWOD                                                BUG3114
     C                   Endif                                                               BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-WRKLNICTD                           BUG3114
     C                             -WRKLNIWOD                                                BUG3114
      *
     C**********         if        ZIRATE = 0 and WrkPaidInt > 0                            AR805843
     C**********                   or ZIRATE <> 0 and WrkPaidInt < 0                        AR805843
     C                   IF        ZIRATE <> 0 and WrkPaidInt < 0                           AR805843
     C                   Eval      WrkPaidInt = 0
     C                   Endif
      *
      ***  Outstanding = Interest - Paid Interest
      *
     C                   Eval      WrkOutIntr = WrkPaidInt
      *
      ***  Remaining interest = (Interest - Paid interest) - "MR" interest
      *
     C                   Z-ADD     0             WrkRemainInt     13 0
     C                   Eval      WrkRemainInt = WrkOutintr - WrkMRIntr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPNAM - Calculate Expected penality                          *
      *****************************************************************
     C     SRPNAM        BEGSR
      *
      ***  Calcul are working with Facilty details
      *
      ***  If Late Payment type is 'A', expected penalty will be
      ***  equal to the late payment amount
      *
     C     FC_LPTP       IFEQ      'A'
     C     FC_FCCY       IFEQ      WRKLNCCY
     C                   Z-ADD     FC_LPAM       WrkExpPen
     C                   else
     C     WRKLNFMDI     Ifeq      'M'
     C                   Eval      WrkExpPen = FC_LPAM / WRKLNFCXR
     C                   Else
     C                   Eval      WrkExpPen = FC_LPAM * WRKLNFCXR
     C                   Endif
     C                   Endif
     C                   Endif
      *
      ***  If Late Payment Type is 'P' , use base rate
      *
     C     FC_LPTP       IFEQ      'P'
     C                   MOVEL     FC_LPBR       TmpLPBR           2
     C                   Z-ADD     FC_LPAM       TmpLPAM
     C                   IF        LTFCXPFR <> 0                                              CLE035
     C                   EVAL      WrkRATE = LTFCXPFR                                         CLE035
     C                   ELSE                                                                 CLE035
     C                   IF        CLE035 = 'Y'                                               CLE035
      *                                                                                       CLE035
      ***  Determine rate                                                                     CLE035
      *                                                                                       CLE035
     C                   IF        FC_LPBR <> 0                                               CLE035
      *                                                                                       CLE035
      ***  Read Base rate details                                                             CLE035
      *                                                                                       CLE035
     C                   CALLB     'AOBSRTR0'                                                 CLE035
     C                   PARM      *BLANKS       @RTCD                                        CLE035
     C                   PARM      '*KEY   '     @OPTN                                        CLE035
     C                   PARM      FC_FCCY       PCCY                                         CLE035
     C                   PARM      TmpLPBR       PBSRT                                        CLE035
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CLE035
     C     @RTCD         IFEQ      *BLANKS                                                    CLE035
     C                   EVAL      WrkRATE = BACBSR                                           CLE035
     C                   ENDIF                                                                CLE035
     C                   ELSE                                                                 CLE035
     C                   EVAL      WrkRATE = LTFCXPRT                                         CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE035
     C     FC_LPPS       IFEQ      '+'                                                        CLE035
     C                   EVAL      WrkRATE = WrkRATE + LTFCXPSR                               CLE035
     C                   ELSE                                                                 CLE035
     C                   EVAL      WrkRATE = WrkRATE - LTFCXPSR                               CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   ELSE                                                                 CLE035
      *
      ***  Determine rate
      *
     C                   if        FC_LPBR <> 0
      *
      ***  Read Base rate details
      *
     C                   CallB     'AOBSRTR0'
     C                   parm      *BLANKS       @RTCD
     C                   parm      '*KEY   '     @OPTN
     C                   parm      FC_FCCY       PCCY              3
     C                   parm      TmpLPBR       PBSRT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     FC_LPPS       IFEQ      '+'
     C     BACBSR        Add       TmpRATE1      WrkRATE          11 7
     C                   else
     C     BACBSR        Sub       TmpRATE1      WrkRATE
     C                   Endif
     C                   Endif
      *
     C                   Else
      *
      ***  if Late Penality Base rate is not 'P',
      *
     C                   Z-ADD     TmpRATE1      WrkRate
     C                   Endif
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
      *
      ***  Compute penality
      *
     C                   Z-ADD     PD_VDAT       ZIBEG
     C                   Z-ADD     MR_VDAT       ZIEND
     C                   Z-ADD     WRKLNICBS     ZICALC
     C                   Z-ADD     WrkExpTot     ZIAMT
     C                   Z-ADD     WrkRATE       ZIRATE
     C/COPY WNCPYSRC,LEH01281
     C                   EXSR      GLINTC
     C/COPY WNCPYSRC,LEH01385
     C                   Z-ADD     ZINTR         WrkExpPen
     C                   Endif
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GLINTC - Calculate Interest on period                         *
      *****************************************************************
     C     GLINTC        BEGSR
      *
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG             5 0
     C                   PARM                    ZIEND             5 0
     C                   PARM                    ZICALC            1 0
     C                   PARM                    ZIAMT            15 0
     C                   PARM                    ZIRATE           11 7
     C                   PARM                    ZINTR            30 9
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR
 
      *                                                                                       249205
      ***  Need to set correct processing type for defaults                                   249205
      *                                                                                       249205
     C                   IF        RPY_PTYP = *Zeros                                          249205
     C                   EVAL      TmpPTYP = WrkLnPTYP                                        249205
     C                   ELSE                                                                 249205
     C                   EVAL      TmpPTYP = RPY_PTYP                                         249205
     C                   ENDIF                                                                249205
      * If ANY of the Settlements fields have been entered, bypass this
      * routine.
      * Otherwise, use modules which will use Standard Settlement
      * Instructions to apply defaults.
     C                   IF        InRecSttmt = *blank AND
     C                             InPaySttmt = *blank
     C                   EVAL      FLPEXR = *Zeros                                            CLE106
     C                   EVAL      FLREXR = *Zeros                                            CLE106
      ***********                                                                     BUG8944 249205
      *****Need*to set correct processing type for defaults                           BUG8944 249205
      ***********                                                                     BUG8944 249205
     C***********        IF        RPY_PTYP = *Zeros                                  BUG8944 249205
     C***********        EVAL      TmpPTYP = WrkLnPTYP                                BUG8944 249205
     C***********        ELSE                                                         BUG8944 249205
     C***********        EVAL      TmpPTYP = RPY_PTYP                                 BUG8944 249205
     C***********        ENDIF                                                        BUG8944 249205
      *                                                                                      BUG4208
      ***  Need to set correct customer number for defaults                                  BUG4208
      *                                                                                      BUG4208
     C**********         IF        RPY_PTYP = 64 or RPY_PTYP =65                     BUG4208 BUG4208
     C                   IF        TmpPTYP = 64 or TmpPTYP =65                               BUG8944
     C**********                   or RPY_PTYP = 68 or RPY_PTYP = 71                 BUG4208 BUG4208
     C                             or TmpPTYP = 68 or TmpPTYP = 71                           BUG8944
     C                   MOVEL     WrkLnOLNO     ##CSNM                                      BUG4208
     C                   else                                                                BUG4208
     C                   MOVEL     RPY_CNUM      ##CSNM                                      BUG4208
                                                                                             BUG8944
     C**********         IF        RPY_CNUM = *Zeros                                 BUG8944 CSD027A
     C                   IF        RPY_CNUM = *Blanks                                        CSD027A
     C                   MOVEL     WrkLnCNUM     ##CSNM                                      BUG8944
     C                   ENDIF                                                               BUG8944
                                                                                             BUG8944
     C                   Endif                                                               BUG4208
 
     C                   CALLB     'ZASETINDFT'
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP
      ** Payment currency
     C                   PARM      DDSCCY        ##PCCY
      ** Receive currency
     C                   PARM      DDSCCY        ##RCCY
      ** Customer (shortname or number)
     C                   PARM                    ##CSNM
      **  Loan Type
     C                   PARM      *BLANK        ##TTYP
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV
      ** Version century of ISDA Agreement
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
 
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
 
     C                   IF            FLRSTM     = 00                                      BUG13331
     C                             AND FLPSTM     = 00                                      BUG13331
                                                                                            BUG13331
     C                   EVAL      FLRSTM     = WrkLnRSTM                                   BUG13331
     C                   EVAL      FLRONS     = WrkLNRONS                                   BUG13331
     C                   EVAL      FLREC      = LoanRecInst                                 BUG13331
     C                   EVAL      FLROBR     = WrKLnOMDB                                   BUG13331
     C                   EVAL      FLPSTM     = WrkLnPSTM                                   BUG13331
     C                   EVAL      FLPONS     = WrkLnPONS                                   BUG13331
     C                   EVAL      FLPAY      = LOANPayInst                                 BUG13331
     C                   EVAL      FLPOBR     = WrkLnOSDB                                   BUG13331
     C                   EVAL      FLCVMR     = WrkLnCVMR                                   BUG13331
     C                   EVAL      FLPSCY     = WrkLnPSCY                                   BUG13331
     C                   EVAL      FLIC72     = WrkLnICCY                                   BUG13331
                                                                                            BUG13331
     C                   IF        (TmpPTYP = 66 OR                                         MD022301
     C                             TmpPTYP = 67 OR                                          MD022301
     C                             TmpPTYP = 69 OR                                          MD022301
     C                             TmpPTYP = 72)                                            MD022301
     C                   EVAL      FLROBR     = WrkLnOSDB                                   MD022301
     C                   EVAL      FLPOBR     = WrkLnOMDB                                   MD022301
     C                   ENDIF                                                              MD022301
     C                                                                                      MD022301
     C                   ENDIF                                                              BUG13331
 
      ** The defaulted instructions are in file format, but the
      ** Settlements validation requires that they are in the input format.
      ** Therefore run them through a conversion module.
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      DDSCCY        #TRCCY                                      CSF011A
     C                   PARM      DDSCCY        #TPCCY                                      CSF011A
 
     C                   ENDIF
      ** Clear settlement instructions depending on loan processing                          BUG4208
      ** type - rules are as follows :-                                                      BUG4208
      ** Processing types 61/62/63/64/65/68/70/71 - s/be Receipt only                        BUG4208
      ** Processing types 66/67/69/72 - s/be Payment only                                    BUG4208
     C                   SELECT                                                              BUG4208
     C**********         WHEN         RPY_PTYP = 61                                  BUG4208 BUG8944
     C                   WHEN         TmpPTYP = 61                                           BUG8944
     C**********                   OR RPY_PTYP = 62                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 62                                           BUG8944
     C**********                   OR RPY_PTYP = 63                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 63                                           BUG8944
     C**********                   OR RPY_PTYP = 64                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 64                                           BUG8944
     C**********                   OR RPY_PTYP = 65                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 65                                           BUG8944
     C**********                   OR RPY_PTYP = 68                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 68                                           BUG8944
     C**********                   OR RPY_PTYP = 70                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 70                                           BUG8944
     C**********                   OR RPY_PTYP = 71                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 71                                           BUG8944
     C                   MOVE      *BLANKS       DBPaySttmt                                  BUG4208
     C                   MOVE      *BLANKS       InPaySttmt                                  BUG4208
     C                   MOVE      '00'          FLPSTM                                      BUG4208
     C**********         MOVE      '00'          DDPSTM                               BUG4208 246120
     C                   EVAL      ##PPAY = 'Y'                                               249205
     C                   EVAL      ##PREC = ' '                                               249205
     C                   IF        InRecSttmt = *blank                                       BUG4208
     C                   MOVE      *BLANKS       DBRecSttmt                                  BUG4208
     C                   MOVE      *BLANKS       InRecSttmt                                  BUG4208
     C                   MOVE      '00'          FLRSTM                                      BUG4208
     C                   MOVE      '00'          DDRSTM                                      BUG4208
     C                   ENDIF                                                               BUG4208
     C**********         WHEN         RPY_PTYP = 66                                  BUG4208 BUG8944
     C                   WHEN         TmpPTYP = 66                                           BUG8944
     C**********                   OR RPY_PTYP = 67                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 67                                           BUG8944
     C**********                   OR RPY_PTYP = 69                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 69                                           BUG8944
     C**********                   OR RPY_PTYP = 72                                  BUG4208 BUG8944
     C                             OR TmpPTYP = 72                                           BUG8944
     C                   MOVE      *BLANKS       DBRECSttmt                                  BUG4208
     C                   MOVE      *BLANKS       InRecSttmt                                  BUG4208
     C                   MOVE      '00'          FLRSTM                                      BUG4208
     C**********         MOVE      '00'          DDRSTM                               BUG4208 246120
     C                   EVAL      ##PREC = 'Y'                                               249205
     C                   EVAL      ##PPAY = ' '                                               249205
     C                   IF        InPaySttmt = *blank                                       BUG4208
     C                   MOVE      *BLANKS       DBPaySttmt                                  BUG4208
     C                   MOVE      *BLANKS       InPaySttmt                                  BUG4208
     C                   MOVE      '00'          FLPSTM                                      BUG4208
     C                   MOVE      '00'          DDPSTM                                      BUG4208
     C                   ENDIF                                                               BUG4208
     C                   ENDSL                                                               BUG4208
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
      *
      ***  For Amends, put the complete (pre-existing) Manual repayment into the Valid
      ***  file record - fields in this will be updated during processing
      *
     C                   MOVE      MAPYFilFmt    ValidMAPY
      *
      ***  For Amends, convert the Manual repayment to screen format
      *
     C                   CALLB     'LEMAPYCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      ***  Repayment sch. - file formats
     C                   PARM                    ValidMAPY
     C                   PARM                    PDLoAmFilFmt
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    CLE023            1            Feature
     C                   parm                    WrkReactFacil     1            (from RTV)
      *
      ***  Output parameters
      *
      ***  Manual Repayment Details - screen format
     C                   PARM                    CurTrMAPY
     C                   PARM      0             WrkProcTypLoan    2 0
     C                   PARM                    WrkOutPrinc      13 0
     C                   PARM                    WrkRemainInt     13 0
      *
      ***  PUT Loan details in Transaction to be validated
      *
     C                   MOVEL     @DDSCCY       DDSCCY                         MR currency
     C                   MOVEL     @DDCURP       DDCURP                         Loan CurR. Princ.
     C                   MOVEL     @DDINTD       DDINTD                         Loan Outst. Interest
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y'                                              BUG3114
     C                   MOVEL     @DDINRF       DDINRF                                      BUG3114
     C                   MOVEL     @DDCGRF       DDCGRF                                      BUG3114
     C                   Endif                                                               BUG3114
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      ** Validate Manual repayment details
     C                   CALLB     'LEMAPYVAL'
 
      ** Inputs
 
      ** Response mode
     C                   PARM      'S'           APRespMode
 
      ** Repayment Schedule Transaction Details
     C                   PARM                    TranInMAPY
     C**********         PARM                    TranInMAP2                            244552 244955
     C                   PARM                    TranInMAP2                                   249232
     C                   PARM                    DDAuto                                       CLE164
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan Details
     C                   PARM                    WrkReactFacil                  Reactivated facility
     C                   PARM                    WrkOutPrinc                    Outstanding Princ.
     C                   PARM                    WrkRemainInt                   Loan Remaining int.
     C                   PARM                    WrkPTYP72                      Expected on type 72
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
 
      ** Extra Data
     C                   PARM                    ExtData
 
      ** Outputs
 
      ** Repayment schedule Details OK inds
     C                   PARM                    OKTrMAPY
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Repayment schedule Transaction (DS) from/to caller
     C                   PARM                    ValidMAPY
     C**********         PARM      *BLANKS       UpSRFlg           1                 CLE134 MD020445
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
      ** Set up date of receipt, and date of payment
     C                   EVAL      ##DATR = *ZEROS
     C                   EVAL      DATEA = DDVALD
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C**********         PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZDAYNmbr                                    BUG3114
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** Set the Pay Date and Receive Date = Value Date
     C**********         EVAL      ##DATP = ZDAYNO                                           BUG3114
     C**********         EVAL      ##DATR = ZDAYNO                                           BUG3114
     C                   EVAL      ##DATP = ZDAYNmbr                                         BUG3114
     C                   EVAL      ##DATR = ZDAYNmbr                                         BUG3114
 
     C                   RESET                   ReturnCode
      ** Need this code here as well as in defaulting cause edit option                      BUG4208
      ** does not call default routine.                                                      BUG4208
      ** Clear settlement instructions depending on loan processing                          BUG4208
      ** type - rules are as follows :-                                                      BUG4208
      ** Processing types 61/62/63/64/65/68/70/71 - s/be Receipt only                        BUG4208
      ** Processing types 66/67/69/72 - s/be Payment only                                    BUG4208
     C*****DDACTN        IFEQ      'A'                                                       BUG4208
     C                   SELECT                                                              BUG4208
     C                   WHEN         MR_PTYP = 61                                           BUG4208
     C                             OR MR_PTYP = 62                                           BUG4208
     C                             OR MR_PTYP = 63                                           BUG4208
     C                             OR MR_PTYP = 64                                           BUG4208
     C                             OR MR_PTYP = 65                                           BUG4208
     C                             OR MR_PTYP = 68                                           BUG4208
     C                             OR MR_PTYP = 70                                           BUG4208
     C                             OR MR_PTYP = 71                                           BUG4208
     C                   MOVE      *BLANKS       DBPaySttmt                                  BUG4208
     C                   MOVE      *BLANKS       InPaySttmt                                  BUG4208
     C                   MOVE      '00'          FLPSTM                                      BUG4208
     C**********         MOVE      '00'          DDPSTM                               BUG4208 246120
     C                   EVAL      ##PPAY = 'Y'                                               249205
     C                   EVAL      ##PREC = ' '                                               249205
     C                   IF        InRecSttmt = *blank                                       BUG4208
     C                             AND DDACTN = 'A'                                           249205
     C                   MOVE      *BLANKS       DBRecSttmt                                  BUG4208
     C                   MOVE      *BLANKS       InRecSttmt                                  BUG4208
     C                   MOVE      '00'          FLRSTM                                      BUG4208
     C                   MOVE      '00'          DDRSTM                                      BUG4208
     C                   ENDIF                                                               BUG4208
     C                   WHEN         MR_PTYP = 66                                           BUG4208
     C                             OR MR_PTYP = 67                                           BUG4208
     C                             OR MR_PTYP = 69                                           BUG4208
     C                             OR MR_PTYP = 72                                           BUG4208
     C                   MOVE      *BLANKS       DBRECSttmt                                  BUG4208
     C                   MOVE      *BLANKS       InRecSttmt                                  BUG4208
     C                   MOVE      '00'          FLRSTM                                      BUG4208
     C**********         MOVE      '00'          DDRSTM                               BUG4208 246120
     C                   EVAL      ##PREC = 'Y'                                               249205
     C                   EVAL      ##PPAY = ' '                                               249205
     C                   IF        InPaySttmt = *blank                                       BUG4208
     C                             AND DDACTN = 'A'                                           249205
     C                   MOVE      *BLANKS       DBPaySttmt                                  BUG4208
     C                   MOVE      *BLANKS       InPaySttmt                                  BUG4208
     C                   MOVE      '00'          FLPSTM                                      BUG4208
     C                   MOVE      '00'          DDPSTM                                      BUG4208
     C                   ENDIF                                                               BUG4208
     C                   ENDSL                                                               BUG4208
     C***********        ENDIF                                                               BUG4208
 
      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Calling function type
     C**********         PARM      'LEND'        ##CALP                                       239587
     C                   PARM      'MAPY'        ##CALP                                       239587
 
      ** Payment currency
     C**********         PARM      DDSCCY        ##PCCY                                       CLE036
     C                   PARM      WrkLnCCY      ##PCCY                                       CLE036
 
      ** Receive currency
     C**********         PARM      DDSCCY        ##RCCY                                       CLE036
     C                   PARM      WrkLnCCY      ##RCCY                                       CLE036
 
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM
 
      ** Loan type
     C**********         PARM      MR_LTYP       ##TTYP                                      BUG4502
     C                   PARM      V_MRLTYP      ##TTYP                                      BUG4502
 
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND
 
      ** Booking Branch
     C**********         PARM      MR_BRCA       ##BRCA                                      BUG4502
     C                   PARM      V_MRBRCA      ##BRCA                                      BUG4502
 
      ** Receipt Date
     C                   PARM                    ##DATR
 
      ** Payment Date
     C                   PARM                    ##DATP
 
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
 
      ** Action Code
     C                   PARM      DDACTN        ##ACTN
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
 
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
 
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
 
      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
 
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFraSttmt
 
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN
 
      ** Validation Iteration
     C                   PARM      '1ST'         ##VALITER
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      *
      ***  update valid Manual Repayment settlement instructions
      *
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     FLRONS        ValidRECEx                                   CGL029
     C                   MOVEL     FLRSTM        V_MRRSTM                                     CGL029
     C                   MOVEL     FLRSCY        V_MRSCCY
      *
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVEL     FLPONS        ValidPAYEx                                   CGL029
     C                   MOVEL     FLPSTM        V_MRPSTM                                     CGL029
     C                   MOVEL     FLCVMR        V_MRCVMR
     C                   MOVEL     FLPSCY        V_MRSCCY
     C                   MOVEL     FLIC72        V_MRICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_MRREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_MRPEXR                                     CLE031
     C                   MOVE      FLREXI        V_MRREXI                                     CLE031
     C                   MOVE      FLPEXI        V_MRPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_MRSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_MRPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
      *
     C*****MR_PTYP       IFEQ      66                                                        BUG4502
     C     V_MRPTYP      IFEQ      66                                                        BUG4502
     C     CLE005        OREQ      'Y'
     C*****MR_PTYP       ANDEQ     69                                                        BUG4502
     C     V_MRPTYP      ANDEQ     69                                                        BUG4502
     C     CLE005        OREQ      'Y'
     C*****MR_PTYP       ANDEQ     72                                                        BUG4502
     C     V_MRPTYP      ANDEQ     72                                                        BUG4502
     C                   MOVE      FLPOBR        V_MROSBR
     C                   ELSE
     C                   MOVE      FLROBR        V_MROSBR
     C                   END
      *
     C*****MR_PTYP       IFEQ      66                                                        BUG4502
     C     V_MRPTYP      IFEQ      66                                                        BUG4502
     C     CLE005        OREQ      'Y'
     C*****MR_PTYP       ANDEQ     69                                                        BUG4502
     C     V_MRPTYP      ANDEQ     69                                                        BUG4502
     C     CLE005        OREQ      'Y'
     C*****MR_PTYP       ANDEQ     72                                                        BUG4502
     C     V_MRPTYP      ANDEQ     72                                                        BUG4502
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C                   Endif
      *
      ***  Save NEW values for shadow posting
      *
     C                   MOVE      *BLANKS       NewStsDS
     C                   MOVE      WSETP         WTYPE
     C                   MOVEL     WOSAC         WOURS
     C                   MOVEL     WTSEN         WTHRS
     C                   MOVEL     FLBENN        WFACO
      *
      ***  Perform the additional validations
      *
      ***  Set up PassDtaDs fields
     C                   eval      WrkDDeseq = DDeseq
     C                   eval      WrkDDpasd = DDpasd
     C
     C                   CALLB     'LEMAPY2VL'
      *
      ***  Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      *
      ***  Valid Manual Repayment
     C                   PARM                    ValidMAPY
      *
      ***  Payment instructions
     C                   PARM                    DBPaySttmt
      *
      ***  Receive instructions
     C                   PARM                    DBRecSttmt
      *
     C                   PARM                    WTYPE             2          Settlement methode
     C                   PARM                    PassDTADs                    Settlement methode
      *
      ***  Field OK flags (DS)
     C                   PARM                    OKTrMAPY
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
                                                                                              CLE106
      ** If entry was in facility currency, use the converted amount                          CLE106
                                                                                              CLE106
     C                   IF        CLE036 = 'Y' And DDLCCY <> *Blanks                         CLE106
     C                   EVAL      TmpRPRI = DDRPRI                                           CLE106
     C                   EVAL      TmpRINT = DDRINT                                           CLE106
     C                   EVAL      TmpRTOT = DDRTOT                                           CLE106
     C                   EVAL      TmpRPEN = DDRPEN                                           CLE106
     C                   EVAL      DDRPRI = DDLCPR                                            CLE106
     C                   EVAL      DDRINT = DDLCIA                                            CLE106
     C                   EVAL      DDRTOT = DDLCTA                                            CLE106
     C                   EVAL      DDRPEN = DDLCPN                                            CLE106
     C                   ENDIF                                                                CLE106
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LEMAPYAMD'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInMAPY
 
      ** (Current) Deal in Screen Format
     C                   PARM                    CurTrMAPY
 
      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKTrMAPY
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx
 
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs
 
      ** If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   EVAL      Idx = AmIdx
     C                   ENDIF
                                                                                              CLE106
      ** Return the actual transaction data to screen                                         CLE106
                                                                                              CLE106
     C                   IF        CLE036 = 'Y' And DDLCCY <> *Blanks                         CLE106
     C                   EVAL      DDRPRI = TmpRPRI                                           CLE106
     C                   EVAL      DDRINT = TmpRINT                                           CLE106
     C                   EVAL      DDRTOT = TmpRTOT                                           CLE106
     C                   EVAL      DDRPEN = TmpRPEN                                           CLE106
     C                   ENDIF                                                                CLE106
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CDE005
      ******************************************************************        CDE005
      *                                                                *        CDE005
      * ValidateRs - Validate Reservation ID                           *        CDE005
      *                                                                *        CDE005
      ******************************************************************        CDE005
     C     ValidateRs    BEGSR                                                  CDE005
                                                                                CDE005
     C                   CALLB     'LERSVIDVL'                                  CDE005
     C                   PARM      'LE'          Module            2            CDE005
     C                   PARM      'LOAN'        TransType         4            CDE005
     C                   PARM                    DDACTN                         CDE005
     C                   PARM                    ResrvId                        CDE005
     C                   PARM                    FldNameArr                     CDE005
     C                   PARM                    MsgIdArr                       CDE005
     C                   PARM                    MsgDtaArr                      CDE005
     C                   PARM                    Idx                            CDE005
                                                                                CDE005
     C                   ENDSR                                                  CDE005
      *****************************************************************         CDE005
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteToDB - Write to database                                 *
      *                                                               *
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   CLEAR                   CurTrMAPY
 
     C                   MOVE      *ALL'Y'       OKTrMAPY
 
     C                   CLEAR                   ValidMAPY
 
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SetupValid    BEGSR
 
      ** For Reversed put the complete (pre-existing) Repayment schedule
      ** into the Valid file record
     C                   IF        DDACTN = 'R' OR DDACTN = 'X'
     C                   EVAL      ValidMAPY = MAPYFilFmt
     C                   ENDIF
 
      ** Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_MRCHTP = DDACTN
 
      ** Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_MRFRNT = APFOTranID
                                                                                              CLE106
     C**********         IF        CLE106 = 'Y'                                       CLE106 CSF011A
     C**********                   Or DDLUTN <> *Blanks                               CLE106 CSF011A
     C                   EVAL      V_MRPCRF = DDLUTN                                          CLE106
     C**********         ELSE                                                         CLE106 CSF011A
     C                   IF        APFOTranID <> *BLANKS                                     CSF011A
     C                   EVAL      V_MRPCRF = APFOTranID
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   EVAL      V_MRREPA = APRprLocn
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_MRAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                            BUG13710
      ** Set up Amendment Type field to be 'MR'                                             BUG13710
     C                   EVAL      DDATYP = 'MR'                                            BUG13710
                                                                                              CAP086
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UpdateDB      BEGSR
 
     C                   CALLB     'LEMAPYUPD'
     C                   PARM      *BLANKS       @RTCD
 
      ** New Repayment schedule in file format
     C                   PARM                    ValidMAPY
      ***  Past Due/Repayment Scheduled in file format
     C                   PARM                    PDLoAmFilFmt
      ***  Loan in File Fmt
     C                   PARM                    WrkLnDetails
      ** Old settlement details
     C                   PARM                    OldStsDS
 
      ** New settlement details
     C                   PARM                    NewStsDS
 
      ** Pass data
     C                   PARM                    PassDtaDS
 
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKTrMAPY
 
      ** Error fields/message IDs/message data (arrays) from/to calle  r
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Reservation ID                                                          CDE005
     C                   PARM                    ResrvId          10            CDE005
     C**********         PARM                    UpSRFlg           1                 CLE134 MD020445
     C                   PARM                    UpSRFlg           1                        MD020733
     C                   PARM                    DDAuto                                       CLE164
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, COMMIT the updates
     C**********         IF        @RTCD<>*BLANK AND @RTCD<>'*RECUPD'                         247673
     C                   IF        @RTCD<>*BLANK                                              247673
     C                   IF        @RTCD <> '*RECUPD'                                      MD025009B
     C                   EVAL      APIRetc = '0'
     C                   ENDIF                                                             MD025009B
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   IF        @RTCD <> '*RECUPD'                                         247673
     C                             AND @RTCD <> '*RECLCK'                                   AR868380
     C                   EXSR      *PSSR
     C                   EndIF                                                                247673
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
     C                   IF        @RTCD = '*RECUPD'
     C                             OR @RTCD = '*RECLCK'                                     AR868380
 
     C                   EVAL      FldNameArr(1) = '*ANY'
 
      ** Amend this message number with correct detail
     C                   EVAL      MsgIdArr(1) = 'LEL0666'
      *                                                                                     AR868380
     C                   IF        @RTCD = '*RECLCK'                                        AR868380
     C                   EVAL      MsgIdArr(1) = 'LEL0817'                                  AR868380
     C                   ENDIF                                                              AR868380
     C                   ELSE
 
      * Allocated sequence number on insert
     C                   IF        DDACTN = 'I'
     C                   MOVE      V_MRLASN      DDSEQN
     C                   MOVEL     V_MRPCRF      DDLUTN                                      CSF011A
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      * SRCnvAmt - Convert amounts based on Currency used for display *                       CLE106
      *****************************************************************                       CLE106
     C     SRCnvAmt      BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LEMAPYCVA'                                                CLE106
     C                   PARM                    TraninMapy                                   CLE106
     C                   PARM                    TraninMap2                                   CLE106
     C                   PARM                    MapyFilFmt                                   CLE106
     C                   PARM                    WrkLnDetails                                 CLE106
     C                   PARM                    ValidMapy                                    CLE106
     C                   PARM                    OKTrMAPY                                     CLE106
                                                                                              CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
     C                   PARM                    MsgDtaArr                                    CLE106
     C                   PARM                    Idx                                          CLE106
                                                                                              CLE106
     C                   PARM                    WFldNamArr                                   CLE106
     C                   PARM                    WMsgIDArr                                    CLE106
     C                   PARM                    WMsgDtaArr                                   CLE106
     C                   PARM                    WIdx                                         CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SRRFND - Calculate Interest Refunded and Charges Refunded     *                      BUG3114
      *****************************************************************                      BUG3114
     C     SRRFND        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     WrkLnVDAT     W78VDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnMDAT     W78MDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnFLTI     W78FLT           15 0                       BUG3114
     C                   MOVE      WrkLnRFRQ     W78RPF            1                         BUG3114
     C                   Z-ADD     WrkLnFRPD     W78FRD            5 0                       BUG3114
     C                   Z-ADD     WrkLnRDYN     W78RPM            2 0                       BUG3114
     C                   MOVE      WrkLnCCY      W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   If        ZDAYNmbr = WrkLnMDAT                                      BUG3114
     C                   Z-ADD     WrkLnMDAT     W78BEG            5 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   eval      W78BEG = ZDAYNmbr + 1                                     BUG3114
     C                   EndIf                                                               BUG3114
     C                   Z-ADD     WrkLnMDAT     W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
      ** Compute for interest refunded if manual payment is for early                        BUG3114
      ** pay-offs and Add on interest is 'Y'                                                 BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and WrkLnADIF = 'Y'                          BUG3114
     C                   Z-SUB(H)  W78INT        WINRF            13 0                       BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WINRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDINRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      ZOUT20        DDINRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for charges refunded if manual payment is for early                         BUG3114
      ** pay-offs and Add on charges is 'Y'                                                  BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and WrkLnADCF = 'Y'                          BUG3114
      *                                                                                      BUG3114
      ** Compute for charge amount per payment                                               BUG3114
      *                                                                                      BUG3114
     C                   if        W78NPY <> 0                                               BUG3114
     C     WrkLnCHGA     DIV       W78NPY        WCHGPY           30 9                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for number of months for charges to be refunded                             BUG3114
      ** if value date is not equal to rundate.                                              BUG3114
      *                                                                                      BUG3114
     C     ZDAYNmbr      IFLT      WrkLnMDAT                                                 BUG3114
     C     W78NPY        SUB       W78NTH        WMOSRF            5 0                       BUG3114
     C                   ADD       2             WMOSRF                                      BUG3114
     C     WCHGPY        MULT      WMOSRF        WCHGRF           30 9                       BUG3114
     C                   Z-SUB(H)  WCHGRF        WCGRF            13 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     *ZERO         WCGRF                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WCGRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDCGRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      Zout20        DDCGRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SROSIN - Calculate Outstanding Interest via Rule of 78        *                      BUG3114
      *****************************************************************                      BUG3114
     C     SROSIN        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     WrkLnVDAT     W78VDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnMDAT     W78MDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnFLTI     W78FLT           15 0                       BUG3114
     C                   MOVE      WrkLnRFRQ     W78RPF            1                         BUG3114
     C                   Z-ADD     WrkLnFRPD     W78FRD            5 0                       BUG3114
     C                   Z-ADD     WrkLnRDYN     W78RPM            2 0                       BUG3114
     C                   MOVE      WrkLnCCY      W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   Z-ADD     WrkLnVDAT     W78BEG            5 0                       BUG3114
     C                   Z-ADD     ZIEND         W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
      *                                                                                      BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78INT        ZINTR                                       BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * RULE78 - Calculate Outstanding interest for a given period    *                      BUG3114
      *          based on Rule of 78                                  *                      BUG3114
      *****************************************************************                      BUG3114
     C     RULE78        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
      ** Define input and output fields                                                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78VDT        W78VDT            5 0                       BUG3114
     C                   Z-ADD     W78MDT        W78MDT            5 0                       BUG3114
     C                   Z-ADD     W78FLT        W78FLT           15 0                       BUG3114
     C                   MOVE      W78RPF        W78RPF            1                         BUG3114
     C                   Z-ADD     W78FRD        W78FRD            5 0                       BUG3114
     C                   Z-ADD     W78RPM        W78RPM            2 0                       BUG3114
     C                   MOVE      W78CCY        W78CCY            3                         BUG3114
     C                   MOVE      W78LCN        W78LCN            3                         BUG3114
     C                   Z-ADD     W78BEG        W78BEG            5 0                       BUG3114
     C                   Z-ADD     W78END        W78END            5 0                       BUG3114
     C                   MOVE      W78ROA        W78ROA            1                         BUG3114
     C                   Z-ADD     *ZERO         W78INT           30 9                       BUG3114
     C                   Z-ADD     *ZERO         W78SUM            6 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NPY            5 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NTH            3 0                       BUG3114
     C                   Z-ADD     *ZERO         W78PRD            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Save fields, may be used in other programs                                          BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     ZDAYNO        WZDAYN            6 0                       BUG3114
     C                   MOVE      ZFREQ         WZFREQ            1                         BUG3114
     C                   Z-ADD     ZMDAY         WZMDAY            2 0                       BUG3114
     C                   MOVE      ZCCY          WZCCY             3                         BUG3114
     C                   MOVE      ZLOC          WZLOC             3                         BUG3114
      *                                                                                      BUG3114
      ** Compute for the total number of payments during the life of                         BUG3114
      ** the loan, depending on the repayment frequency                                      BUG3114
      *                                                                                      BUG3114
     C     W78RPF        IFEQ      *BLANKS                                                   BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     1             W78NPY                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C     ZDAYNO        DOWLT     W78MDT                                                    BUG3114
     C     ZDAYNO        ANDGE     W78FRD                                                   AR830785
     C                   ADD       1             W78NPY                                      BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Add 1 to total number of payments to include repayment on                           BUG3114
      ** maturity date                                                                       BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NPY                                      BUG3114
      *                                                                                      BUG3114
      ** Compute for the sum of digits                                                       BUG3114
      *                                                                                      BUG3114
     C     W78NPY        ADD       1             WKSUM             8 2                       BUG3114
     C                   DIV       2             WKSUM                                       BUG3114
     C     WKSUM         MULT      W78NPY        W78SUM                                      BUG3114
      *                                                                                      BUG3114
      ** If first repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      *BLANKS       ZIND                                        BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for the Nth payment for interest for a given period                         BUG3114
      *                                                                                      BUG3114
     C     W78ROA        IFEQ      'A'                                                       BUG3114
     C     W78VDT        IFEQ      W78BEG                                                    BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     2             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ELSE                                                                BUG3114
     C     W78BEG        IFLT      ZDAYNO                                                    BUG3114
     C     W78BEG        IFEQ      W78END                                                    BUG3114
     C                   Z-ADD     ZDAYNO        W78END                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     ZDAYNO        W78BEG                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      ZDAYNO        TDAYNO            5 0                      AR830785
     C     ZDAYNO        DOWLT     W78BEG                                                    BUG3114
     C     ZDAYNO        ANDGE     TDAYNO                                                   AR830785
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** If end date < start date, OR amortisation date same or after                        BUG3114
      ** maturity date, OR repayment date is after maturity date,                            BUG3114
      ** OR repayment date earlier than the first repayment date                             BUG3114
      ** - zeroise the interest amount                                                       BUG3114
      *                                                                                      BUG3114
     C     W78END        IFLT      W78BEG                                                    BUG3114
     C     W78BEG        ORGE      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORLT      W78VDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORGT      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C     W78BEG        ORLT      W78FRD                                                    BUG3114
     C     W78END        ANDLT     W78FRD                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C                   Z-ADD     *ZERO         W78INT                                      BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78NTH        WKSAV             3 0                       BUG3114
      *                                                                                      BUG3114
      ** Compute for outstanding interest for the period                                     BUG3114
      ** until given end date or until                                                       BUG3114
      *                                                                                      BUG3114
     C     ZDAYNO        DOUGT     W78END                                                    BUG3114
     C     W78NTH        ORGT      W78NPY                                                    BUG3114
     C     W78NPY        SUB       W78NTH        WINTPD           30 9                       BUG3114
     C                   ADD       1             WINTPD                                      BUG3114
     C                   MULT      W78FLT        WINTPD                                      BUG3114
     C                   DIV       W78SUM        WINTPD                                      BUG3114
     C                   ADD       WINTPD        W78INT                                      BUG3114
      *                                                                                      BUG3114
      ** Do not process frequency date calculation on first payment                          BUG3114
      ** date, i.e., beginning date is less than FRPD                                        BUG3114
      *                                                                                      BUG3114
     C     W78NTH        IFNE      1                                                         BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78ROA        OREQ      'R'                                                       BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
     C                   ADD       1             W78PRD                                      BUG3114
     C                   ENDDO                                                               BUG3114
     C                   SUB       1             W78PRD                                      BUG3114
     C                   Z-ADD     WKSAV         W78NTH            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Restore fields, may be used in other programs                                       BUG3114
      *                                                                                      BUG3114
     C     ERUL78        TAG                                                                 BUG3114
     C                   Z-ADD     WZDAYN        ZDAYNO                                      BUG3114
     C                   MOVE      WZFREQ        ZFREQ                                       BUG3114
     C                   Z-ADD     WZMDAY        ZMDAY                                       BUG3114
     C                   MOVE      WZCCY         ZCCY                                        BUG3114
     C                   MOVE      WZLOC         ZLOC                                        BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      *                                                               *                      BUG3114
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *                      BUG3114
      *                                                               *                      BUG3114
      *****************************************************************                      BUG3114
     C     ZFREQB        BEGSR                                                               BUG3114
                                                                                             BUG3114
     C                   CallB     'ZFREQB'                                                  BUG3114
     C                   Parm      *blanks       RetCodeIn                                   BUG3114
     C                   Parm                    ZFREQ             1                         BUG3114
     C                   Parm                    ZDAYNO            5 0                       BUG3114
     C                   Parm                    ZCCY              3                         BUG3114
     C                   PARM                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY             2 0                       BUG3114
     C                   Parm                    BJDFIN                                      BUG3114
     C                   Parm      SDGELR        SDGELR                                      BUG3114
                                                                                             BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCUST                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 BUG3114
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
 
      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CLE106
     C**********         PARM                    UpSRFlg                          AR1080805 MD020445
     C                   PARM                    UpSRFlg                                    MD020733
     C                   PARM                    DDAuto            1                          CLE164
 
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C**********         PARM                    InFRASttmt                                   222373
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
     C                   PARM                    ReservID         10                          222373
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
      **Reservation*ID                                                                 CDE005 222373
     C**********         PARM                    ResrvId                               CDE005 222373
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSGF'
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LEMAPYM01
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE005 = 'Y'
     C                   ELSE
     C                   EVAL      CLE005 = 'N'
     C                   ENDIF
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
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CEU004 = 'Y'
     C                   ELSE
     C                   EVAL      CEU004 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE002 = 'Y'
     C                   ELSE
     C                   EVAL      CLE002 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE007 = 'Y'
     C                   ELSE
     C                   EVAL      CLE007 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   EVAL      CDE001 = 'N'
     C                   ENDIF
                                                                                CDE005
      ** Access SAR details file                                                CDE005
     C                   CALLB     'AOSARDR0'                                   CDE005
     C                   PARM      *BLANKS       @RTCD                          CDE005
     C                   PARM      '*VERIFY'     @OPTN                          CDE005
     C                   PARM      'CDE005'      @SARD                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                          CDE005
                                                                                CDE005
     C                   IF        @RTCD = *BLANK                               CDE005
     C                   EVAL      CDE005 = 'Y'                                 CDE005
     C                   ELSE                                                   CDE005
     C                   EVAL      CDE005 = 'N'                                 CDE005
     C                   ENDIF                                                  CDE005
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE003 = 'Y'
     C                   ELSE
     C                   EVAL      CLE003 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE004 = 'Y'
     C                   ELSE
     C                   EVAL      CLE004 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE009 = 'Y'
     C                   ELSE
     C                   EVAL      CLE009 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE014 = 'Y'
     C                   ELSE
     C                   EVAL      CLE014 = 'N'
     C                   ENDIF
 
      ** Access SAR details file
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CLE023 = 'Y'
     C                   ELSE
     C                   EVAL      CLE023 = 'N'
     C                   ENDIF
                                                                                              CLE106
      ** Access SAR details file                                                              CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Access SAR details file                                                              CLE106
                                                                                              CLE106
     C                   EVAL      CLE036 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE036'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE036 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      *                                                                                       CLE035
      ** Access Switchable SAR details for the existence of CLE035                            CLE035
      *                                                                                       CLE035
     C                   CALLB     'AOSARDR0'                                                 CLE035
     C                   PARM      *BLANK        @RTCD                                        CLE035
     C                   PARM      '*VERIFY'     @OPTN                                        CLE035
     C                   PARM      'CLE035'      @SARD                                        CLE035
      *                                                                                       CLE035
     C     @RTCD         IFEQ      *BLANKS                                                    CLE035
     C                   MOVE      'Y'           CLE035            1                          CLE035
     C                   ELSE                                                                 CLE035
     C                   MOVE      'N'           CLE035                                       CLE035
     C                   ENDIF                                                                CLE035
      ** Determine if enhancement CSC022 is switched on                                       CSC022
      ** CSC022 is a mandatory feature already so it's always on                     CSC022 MD024398
                                                                                              CSC022
     C**********         CALLB     'AOSARDR0'                                        CSC022 MD024398
     C**********         PARM      *BLANKS       PRTCD             7                 CSC022 MD024398
     C**********         PARM      '*VERIFY'     POPTN             7                 CSC022 MD024398
     C**********         PARM      'CSC022'      PSARD             6                 CSC022 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC022 MD024398
      * Initialize work fields                                                                CSC022
     C**********         Eval      CSC022 = 'N'                                      CSC022 MD024398
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C**********         If        PRTCD = *Blanks                                   CSC022 MD024398
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C**********         Else                                                        CSC022 MD024398
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C**********         If        PRTCD <> '*NRF'                                   CSC022 MD024398
     C**********         Eval      DBFILE = 'SCSARDPD'                               CSC022 MD024398
     C**********         Eval      DBKEY = 'CSC022'                                  CSC022 MD024398
     C**********         Eval      DBASE = 004                                       CSC022 MD024398
     C**********         EXSR      *PSSR                                             CSC022 MD024398
     C**********         EndIf                                                       CSC022 MD024398
     C**********         EndIf                                                       CSC022 MD024398
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
     C                   EVAL      DBPGM = 'LEMAPYVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 005                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
     C/COPY WNCPYSRC,LEH01282
 
                                                                                              CLE134
      ** Determine if Past Due Call Loans is installed                                        CLE134
                                                                                              CLE134
     C                   MOVE      'N'           CLE134            1                          CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
                                                                                              CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR
      *****************************************************************
**  POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
