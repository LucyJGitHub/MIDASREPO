     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayment - controller')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYCTL - LE Manual Repayments - Controller                *
      *                                                               *
      *  Function: This Program Validates Manual Repayments for       *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the manual repayment details fields   *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this manual repayment and bypass the rest*
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 243329             Date 06May20               *
      *  Prev Amend No. MD020027           Date 12Mar20               *
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 13Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 01Jul04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  243329 - If no defined settlement details entered, default   *
      *           payment settlement details of the loan if PTYP is   *
      *           66, 67, 69, or 72. Pattern fix 242348.              *
      *         - Applied for MD049414.                               *
      *         - Applied for MD020027.                               *
      *  MD020027 - Pay Settlement details are not defaulted from     *
      *             original part sold transactions.  Added defaulting*
      *             of pay/receipt settlement during insert.          *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  CSD027 - Conversion Of Customer Number to Alpha (Recompile)  *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
      *
     FLEVMAPYPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      *
     FLEIMAPYPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FLEVMAPYL0 IF   E           K DISK
     F                                     RENAME(LEVMAPYD0:LEVMAPYL00)
      *
     FLEVMAPYL1 IF   E           K DISK
     F                                     RENAME(LEVMAPYD0:LEVMAPYL01)
      *
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEMAPYC001
      *
      *****************************************************************
      *  +--------------------------------------+
      *    Automatically included D-specs        
      *    ==============================        
      *  +--------------------------------------+
      *
      *  Standard D-specs
      *  ================
      *
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      *                                     handler)
      *  and the following variables:
      *     RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *  Program Status Data Structure
      *  =============================
      *  The following /COPY line includes all the defined fields in the
      *  PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *  The following /COPY line includes definitions for the above fields
      *  as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      *  corresponding fields in the PSDS /COPY member, so that member
      *  must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for error and
      *  warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      * --------------------------------------------------------------------------------------------
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for arrays
      *  specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      * --------------------------------------------------------------------------------------------
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for fields
      *  used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      * --------------------------------------------------------------------------------------------
      *
      *  +--------------------------------------+
      *    End of automatically included D-specs 
      *    ===================================== 
      *  +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  +--------------------------------------+
      *    Manually included D-specs             
      *    =========================             
      *  +--------------------------------------+
      *
      *  +--------------------------------------+
      *    Named constants                       
      *    ===============                       
      *  +--------------------------------------+
      *
      ***  String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      *
      *  +--------------------------------------+
      *    Arrays and Data Structures            
      *    ==========================            
      *  +--------------------------------------+
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
      ***  Loan PAyment/receipt instructions
     D***LoanRecInst          459    527                                                      CGL029
     D***LoanPayInst          528   1086                                                      CGL029
     D  LoanRecInst          473    527                                                       CGL029
     D  LoanPayInst          542   1086                                                       CGL029
     D  LoanRecInstEx       1597   1614                                                       CGL029
     D  LoanPayInstEx       1615   1632                                                       CGL029
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
      *
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      ***  Incoming Header
      *
     D TransIncom    E DS                  EXTNAME(LEMAPYPD)
      ***  Incoming Transaction
     D  Incomkey               1     51
      *
     D ValidMAPY     E DS                  EXTNAME(LEVMAPYPD)
      ***  Valid manual repayments layout
     D                                     PREFIX(V_)
     D***ValidREC             321    389                                                      CGL029
     D***ValidPAY             390    948                                                      CGL029
     D  ValidREC             335    389                                                       CGL029
     D  ValidPAY             404    948                                                       CGL029
     D  ValidRECEx          1195   1212                                                       CGL029
     D  ValidPAYEx          1213   1230                                                       CGL029
      *
     D MAPYFilFmt    E DS                  EXTNAME(LOAMSDK)
      ***  (Current) Manual Repayment in file Format
     D                                     PREFIX(MR_)
     D***MAPYFilREC           321    389                                                      CGL029
     D***MAPYFilPAY           390    948                                                      CGL029
     D  MAPYFilREC           335    389                                                       CGL029
     D  MAPYFilPAY           404    948                                                       CGL029
     D  MAPYFilRECEx        1195   1212                                                       CGL029
     D  MAPYFilPAYEx        1213   1230                                                       CGL029
      *
     D CurMAPYCF     E DS                  EXTNAME(LEMAPYPD)
      ***  (Current) Screen Format
     D                                     PREFIX(@)
     D  Insertkey              1     51
      *
     D OKMAPY        E DS                  EXTNAME(LEEMAPYPD)
      ***  Error indicators
      *
     D L_REC         E DS                  EXTNAME(SDESFRPD)
      ***  File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
      *
     D L_PAY         E DS                  EXTNAME(SDESFPPD)
      ***  File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
      *
     D L_FRI         E DS                  EXTNAME(SDESFFPD)
      ***  File Fra/irs instructions
      *
     D S_REC         E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive instructions
      *
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      * Screen Payment instructions
      *
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
      ***  Screen Fra/irs instructions
      *
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
      ***  Current Screen Receive instructions
      *
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
      ***  Current Screen Payment instructions
      *
     D C_FRA         E DS                  EXTNAME(SDESSFPD) PREFIX(C_)
      ***  FRA/IRS Settlement Instructions - Current
      *
     D OKPayInsDS      DS
      ***  Flags to indicate whether Pay Settlement instruction fields
      ***  are valid
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
      *
     D OKRecInsDS      DS
      ***  Flags to indicate whether Receive Settlement instruction fields
      ***  are valid
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
      *
     D OKFRAInsDS      DS
      ***  Flags to indicate whether FRA/IRS instruction fields are valid
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
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for Bank Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for Midas modules details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
      * Manual Repayment Extra Data - File (D/B) format                                       CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(LEMAEXPD)
      ***  Manual Repayment Extra Data - File (D/B) format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs - short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs - long data structure
      *
     D***OldSettlDS     DS            34                                                      CGL029
     D  OldSettlDS     DS            40                                                       CGL029
      ***  Current Settlement details for Loan Amendment
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
      *
     D***NewSettlDS     DS            34                                                      CGL029
     D  NewSettlDS     DS            40                                                       CGL029
      ***  New settlement details for Loan Amendments
     D  WTYPE                  1      2
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
      *
     D PTranID         DS            20
      ***  Midas transaction ID for the Message Handling module "CallMsgHdl"
     D  PLNRFId                1      6
     D  PVDATId                7     12
     D  PLASNId               13     15
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
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      *  +--------------------------------------+
      *    Declared variables                    
      *    ==================                    
      *  +--------------------------------------+
      *
      ***  Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
      *
      ***  Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ***  Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      *
      ***  Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
      *
      ***  Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *
      ***  Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
      *
      ***  Indicies for arrays used to set up corresponding sequence numbers
      ***  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
      *
      ***  Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
      *
      ***  Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
      *
      ***  Timestamp for the transaction
     D TimeStamp       S             26Z
      *
     D Object          S             10A   INZ('LEMAPYUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
      *
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
      ***  Whether or not to clear the program message queue (this is not
      ***  actually used, but is required by the message handler's parameter
      ***  list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      *
      ***  Flags to indicate whether substitution is required in
      ***  each of the various parts the transaction
     D RepScrn         S              1A   inz('N')
                                                                                              CGL029
     D WOSAC           S             18A                                                      CGL029
      *
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              244636
      ** Parameter for LERPSCRTV                                                              244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
      ** Parameter for LEMAPYRTV                                                            MD020027
     D***PPayParm        S            335                                            MD020027 243329
     D PPayParm        S           1045                                                       243329
                                                                                            MD020027
                                                                                              CAP086
     D CAP086          S              1A                                                      CAP086
                                                                                              CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSC022
      *  +--------------------------------------+
      *    End of D-specs                        
      *    ==============                        
      *  +--------------------------------------+
      *
      *  +----------------------------------------+
      *    Hook for non-core D-specs (all types)   
      *    also any I-specs (if necessary)         
      *    =====================================   
      *  +----------------------------------------+
      /COPY WNCPYSRC,LEMAPYC002
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  +--- Start of Main processing -----------------------------------+
      *                                                                    
      *    Initial processing is performed automatically: the *INZSR is    
      *    executed at program activation.                                 
      *                                                                    
      *  +----------------------------------------------------------------+
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC003
      *
      ***  Incoming transaction is broken into 500A fields, so that a common CL
      ***  can be used between this module and the one that read the MQ queue.
      ***  This module needs to break these 500A fields by loading them into
      ***  the appropriate (externally described) data structure.
      *
     C                   MOVEL     Trans5001     TransIncom
     C                   EVAL      InfData = InfData500                                       CAP086
     C                   MOVEL     Extdata500    Extdata
      *
      ***  Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      ***  Reset variables gradually updated
      *
     C                   EXSR      ResetCycle
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC004
      *
      ***  Check if valid Manual repayment details exists
      *
     C                   EXSR      ChkValMAPY
      *
      ***  If Manual repayment does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Check if valid Manual repayment exists for Midas
      *
     C                   EXSR      ChkValMiRS
      *
      ***  If valid Manual repayment does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Reset variables again in case the details have been corrupted
      ***  by previous chain to valid Manual repayment details file.
      *
     C                   EXSR      ResetCycle
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC005
      *
      ***  Validate Action Code
      *
     C                   EXSR      ValidateAc
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC006
      *
      ***  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Processing depends upon Action Code
      *
     C                   SELECT
      *
     C                   WHEN         DDACTN = 'I'
      *
      ***  Processing for Inserts
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC007
      *
      ***  For insert, use LEMAPYCVT to setup loan details which will impact validation,
      ***  these are WrkOutPrinc and WrkRemainInt used by LEMAPYVAL Module.
      *
     C                   MOVEL     Incomkey      Insertkey
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
     C                   PARM                    CurMAPYCF
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
      *
      ***  Expected details ????
      *
     C     @DDESEQ       IFNE      *BLANKS
     C                   Endif
      *
     C                   EXSR      ValidateTr
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC008
      *                                                                                       244636
      ** Default settlement details from related loan                                         244636
     C                   IF        S_Rec = *blank AND                                         244636
     C                             PRcvParm <> *blank                                         244636
     C                   MOVEL     PRcvParm      S_Rec                                        244636
     C                   ENDIF                                                                244636
      *                                                                                     MD020027
      ** Default settlement details from related loan                                       MD020027
     C                   IF        WRKLNPTYP = 66 or WRKLNPTYP = 67                           243329
     C                             or WRKLNPTYP = 69 or WRKLNPTYP = 72                        243329
     C                   IF        S_Pay = *blank AND                                       MD020027
     C                             PPayParm <> *blank                                       MD020027
     C                   MOVEL     PpayParm      S_Pay                                      MD020027
     C                   ENDIF                                                              MD020027
     C                   ENDIF                                                                243329
      *                                                                                     MD020027
     C                   EXSR      ValidateSt
      *
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'R'
     C                             OR DDACTN = 'X'
      *
      ***  Processing for Amends or Changes
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC009
      *
      ***  Check for the existence of the replacement character; if this is
      ***  used, only the changed data has been sent, and all occurrences of
      ***  the replacement character must be replaced with the corresponding
      ***  character from the original transaction.
      *
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
      *
     C     GHSUBS        scan      TransIncom                             99
     C                   if        *in99
     C                   eval      RepScrn = 'Y'
     C                   endif
      *
      ***  If any of the flags set above is true, do the data
      ***  substution subroutine.
      *
     C                   if        (RepScrn = 'Y')
     C                   EXSR      DtaSubs
     C                   endif
      *
     C                   endif
      *
     C                   EXSR      SetupAmd
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC010
      *
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateAmd
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC011
     C                   EXSR      ValidateSt
      *
     C                   ENDSL
      *
     C     Invalid       TAG
      *
      ***  Check for exception error from any program lower in the stack
      ***  If error detected, send message to system operator and
      ***  return to calling program without updating database or
      ***  prompting the database update program
      *
     C                   IN        APDUMP
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC012
      *
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
     C                   ELSE
      *
      ***  Processing for Error checking/write to database
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC013
     C                   EXSR      CheckWrite
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC014
      *
      ***  If valid, send data queue entry to prompt DB update program
      *
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *
      ***  Check if update program active using Allocate Object API
      ***  No prompting necessary if program is running
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
      *
     C     Return        IFEQ      *BLANK
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes a check for whether there
      *  are messages on the server/updater data queue, and sends a 'GO'.
      *  message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      * --------------------------------------------------------------------------------------------
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEMAPYC015
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValMAPY - Routine to check if valid Manual repayment       *
      *              details exist                                    *
      *****************************************************************
     C     ChkValMAPY    BEGSR
      *
      ***  Check for Manual repayment on Valid file
      *
     C     APFOTranID    CHAIN     LEVMAPYL0                          99
      *
      ***  If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ***  Delay, then repeat check
      *
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
      *
     C     APFOTranID    CHAIN     LEVMAPYL0                          99
     C                   END                                                                  247549
      *
      ***  Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValMiRS - Routine to check if valid Repayment exists for   *
      *              Manual Repayment reference                       *
      *****************************************************************
     C     ChkValMiRS    BEGSR
      *
      ***  Key list for file LEVMAPYL1
      *
     C     KMAPY1        KLIST
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    KLASN             3 0
      *
     C     DDLNRF        IFNE      *BLANKS
     C     DDVALD        ANDNE     *BLANKS
     C     DDSEQN        ANDNE     *BLANKS
      *
      ***  Check for Manual repayment on Valid file
      *
     C                   MOVE      DDLNRF        KLNRF
      *
     C                   MOVE      DDVALD        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   MOVE      ZDAYNO        KVDAT
      *
     C                   MOVE      DDSEQN        KLASN
     C     KMAPY1        CHAIN     LEVMAPYL1                          99
      *
      ***  If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ***  ..delay, then repeat check
      *
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
      *
     C     KMAPY1        CHAIN     LEVMAPYL1                          99
     C                   END                                                                  247549
      *
      ***  Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx) = 'LEL0664'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateAc - Routine to validate action code versus the       *
      *              Manual repayment supplied                        *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TransIncom    SubForTRNN        2 0
     C                   ENDIF
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   IF        TransIncom = *BLANK
     C                             OR SubForTRNN <> 0
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     *BLANKS       ModeofOp
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate action code versus transaction IDs supplied
      ***  The Manual repayment in file format from the LE database is retrieved
      ***  as well.
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'LEMAPYRTV'
      *
      ***  INPUTS
      *
     C                   PARM      *BLANK        ReturnCode                     Return code
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
     C                   PARM                    APRESPMODE        1            Response mode
     C                   PARM                    DDACTN                         Action Code
     C                   PARM                    APFOTranID       20            Front Office ID
     C                   PARM                    DDLNRF
     C                   PARM                    DDVALD
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
      *
      ***  Outputs
      *
      ***  (Current) Manual Repayment in file format
     C                   PARM                    MAPYFilFmt
     C                   PARM                    DDActnOK                       OK Actn code
     C                   PARM                    DDLnrfOK                       OK Loan ref
     C                   PARM      *BLANK        DDVALDOK                       OK Value Date
     C                   PARM      *BLANK        DDSeqnOK                       OK Sequence
     C                   PARM      *BLANK        DDEvalOK                       OK Expected Date
     C                   PARM      *BLANK        DDEseqOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WrkWHoldTaxRat   11 7          W/hold Tax Rate
     C                   PARM                    WrkExpectTyp      1            Expect Amend Loan tp
     C                   PARM                    WrkPTYP72         1            Expected on type 72
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkLnDetails                   Loan File Fmt
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
     C                   PARM                    WIdx
     C                   PARM                    PRcvParm                                     244636
     C                   PARM                    PPayParm                                   MD020027
      *
      ***  Save the settlement details for update if not insert
      *
     C     DDACTN        IFNE      'I'
     C                   MOVE      MR_SETP       OSETP
     C                   MOVEL     MR_OSAC       OOSAC
     C                   MOVEL     MR_TSEN       OTSEN
     C                   MOVEL     MR_FACO       OFACO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
      *
      ***  Set up date of receipt, and date of payment
      *
     C                   Z-ADD     *ZERO         ##DATR
      *
     C                   MOVE      DDVALD        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   Z-ADD     ZDAYNO        ##DATP
     C                   Z-ADD     ZDAYNO        ##DATR
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'ZASETINVAL'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Following parameters are output to called module
      ***  Calling function type
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDSCCY        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDSCCY        ##RCCY            3
      *
      ***  Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan type
     C                   PARM      MR_LTYP       ##TTYP            2
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Booking Branch
     C                   PARM      MR_BRCA       ##BRCA            3
      *
      ***  Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM                    ##DATP            5 0
      *
      ***  Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
      *
      ***  Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
      *
      ***  Following parameters are returned by called module
      ***  Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      *
      ***  Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      *
      ***  FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      *
      ***  Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      *
      ***  File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    L_Pay
     C                   PARM                    L_Rec
     C                   PARM                    L_FRI
      *
      ***  Extra Input
      ***  Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
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
     C     MR_PTYP       IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MR_PTYP       ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MR_PTYP       ANDEQ     72
     C                   MOVE      FLPOBR        V_MROSBR
     C                   ELSE
     C                   MOVE      FLROBR        V_MROSBR
     C                   END
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
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
     C                   MOVE      *BLANKS       NewSettlDS
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
     C                   PARM                    RespMode
      *
      ***  Valid Manual Repayment
     C                   PARM                    ValidMAPY
      *
      ***  Payment instructions
     C                   PARM                    L_Pay
      *
      ***  Receive instructions
     C                   PARM                    L_Rec
      *
     C                   PARM                    WTYPE             2          Settlement methode
     C                   PARM                    PassDTADs                    Settlement methode
      *
      ***  Field OK flags (DS)
     C                   PARM                    OKMAPY
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments and changes.                         *
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
     C                   PARM                    CurMAPYCF
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
      *
      ***  Expected details ????
      *
     C     @DDESEQ       IFNE      *BLANKS
     C                   Endif
      *
      ***  The sett instructions are in file format (retrieved on ValidateAc, but the
      ***   Settlements validation requires that they are in the input format.
      ***  Therefore run them through a conversion module.
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Defaulted Settlement Instructions in file format
     C                   PARM                    L_PAY
     C                   PARM                    L_REC
     C                   PARM      *BLANK        L_FRI
      *
      ***  Current Settlement Instruction in input format
     C                   PARM                    C_Pay
     C                   PARM                    C_Rec
     C                   PARM                    C_FRA
     C                   PARM      DDSCCY        #TRCCY                                      CSF011A
     C                   PARM      DDSCCY        #TPCCY                                      CSF011A
      *
      ***  If no Payment or Receive instructions have been supplied
      ***  Default them to those currently on the deal.
      *
     C                   IF            (S_Pay = *blank)
     C                   EVAL      S_Pay = C_Pay
     C                   ENDIF
      *
     C                   IF            (S_Rec = *blank)
     C                   EVAL      S_Rec = C_Rec
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      * ValidateTr - Routine to validate the main transaction details  *
      ******************************************************************
     C     ValidateTr    BEGSR
      *
      ***  Validate Manual repayment details screen
      *
     C                   EXSR      ValdTrPrim
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValdTrPrim - Validate Manual repayment details                 *
      *****************************************************************
     C     ValdTrPrim    BEGSR
      *
     C                   CALLB     'LEMAPYVAL'
      *
      * INPUTS
      *
      ***  Response mode
     C                   PARM                    RespMode          1
      *
      ***  Screen Details
     C                   PARM                    TransIncom
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan Details
     C                   PARM                    WrkReactFacil     1            Reactivated facility
     C                   PARM                    WrkOutPrinc      13 0          Outstanding Princ.
     C                   PARM                    WrkRemainInt     13 0          Loan Remaining int.
     C                   PARM                    WrkPTYP72         1            Expected on type 72
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  OUTPUTS
      *
     C                   PARM                    OKMAPY                         Ok Flag
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidMAPY                      Nw MR in File Format
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateAmd - Routine to check whether the fields amended     *
      *              are amendable.                                   *
      *****************************************************************
     C     ValidateAmd   BEGSR
      *
      * This subroutine calls a procedure which checks whether it
      * was valid to Amend or Change any of the fields which have been
      * altered.  Some are never amendable and some are amendable depending
      * on the Action Code - "A" for Amend.
      *
      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.
      *
      * These fields are then compared with the fields on the input
      * transaction.
      *
      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.
      *
      * Manual Repayment  - Amend module for main screen
      * =============================================
      *
     C                   CALLB     'LEMAPYAMD'
      *
      ***  INPUTS
      *
     C                   PARM                    RetCodeIn                      Return Code
     C                   PARM                    TransIncom                     New MR in Screen fmt
     C                   PARM                    CurMAPYCF                      Cur MR in Screen fmt
      *
      ***  OUTPUTS
      *
     C                   PARM                    OKMAPY                         OK FLags
     C                   PARM                    AmFldNamAr                     Error Fields Array
     C                   PARM                    AmMsgIdArr                           Msg Ids
     C                   PARM                    AmMsgDtaAr                           Msg Data
     C                   PARM                    AmIdx                                Idx
      *
     C                   PARM      'Y'           ResetErrs         1            Reset Fld in error
      *
      ***  If any errors overwrite previous error information
      *
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *****************************************************************
     C     CheckWrite    BEGSR
      *
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Manual Repayment status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
††††† *
††††† *  +--- Note for a later release -------------------------------+
††††† *  ¶                                                            ¶
††††† *  ¶ At a later date this routine will have to cater for        ¶
††††† *  ¶ warning messages.  The following logic will have to be     ¶
††††† *  ¶ inserted before "If no errors were found", in the          ¶
††††† *  ¶ above comments (and the code):                             ¶
††††† *  ¶                                                            ¶
††††† *  ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† *  ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† *  ¶                                                            ¶
††††† *  ¶ -†††If errors exist                                        ¶
††††† *  ¶†††††-†††††Add the warning array index to the error array   ¶
††††† *  ¶†††††††††††index                                            ¶
††††† *  ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† *  ¶†††††††††††end of the error arrays                          ¶
††††† *  ¶ -†††Else                                                   ¶
††††† *  ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† *  ¶†††††††††††array index                                      ¶
††††† *  ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† *  ¶†††††††††††error arrays                                     ¶
††††† *  ¶ -†††Endif                                                  ¶
††††† *  ¶                                                            ¶
††††† *  ¶ Endif                                                      ¶
††††† *  ¶                                                            ¶
††††† *  ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† *  ¶ can probably be implemented unconditionally (ie the same   ¶
††††† *  ¶ logic will apply whether errors exist as well as warnings  ¶
††††† *  ¶ or not).  It is shown in the above form for clarity.       ¶
††††† *  ¶                                                            ¶
††††† *  +------------------------------------------------------------+
      *
     C                   IF        Idx = 0
      *
     C                   EXSR      SetupValid
     C                   WRITE     LEVMAPYD0
      *
     C                   EXSR      CallMsgHdl
      *
     C                   ENDIF
      *
     C     Idx           IFGT      0
     C                   EXSR      SetupInVal
      *
      ***  Only write to Invalid files if repair in back office
      *
     C                   IF        APRprLocn = 'B'
     C                   WRITE     LEIMAPYD0
     C                   WRITE     APIDSETD0
      *
     C                   ENDIF
      *
     C                   EXSR      CallMsgHdl
      *
     C                   ENDIF
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetCycle- Reset error information that is gradually         *
      * updated during each run of this program                       *
      *****************************************************************
     C     ResetCycle    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
      *
     C                   RESET                   FldNoArr
      *
     C                   CLEAR                   CurMAPYCF
      *
     C                   MOVE      *ALL'Y'       OKMAPY
      *
     C                   CLEAR                   ValidMAPY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupInVal - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *****************************************************************
     C     SetupInVal    BEGSR
      *
      ***  Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'LEMAPY'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                              CAP086
      * Setup the Automatic Autorisation Flag                                                 CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
     C                   EVAL      TranStatus = 'F'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC016
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *****************************************************************
     C     SetupValid    BEGSR
      *
      ***  For Reversed put the complete (pre-existing) Manual Repayment
      ***  into the Valid file record
      *
     C                   IF           DDACTN = 'R' OR DDACTN = 'X'
     C                   MOVE      MAPYFilFmt    ValidMAPY
     C                   ENDIF
      *
      ***  Set Valid file field(s) that are needed for all Action Codes
      *
     C                   EVAL      V_MRCHTP = DDACTN
      *
      ***  Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      V_MRFRNT = APFOTranID
     C                   EVAL      V_MRPCRF = APFOTranID
     C                   EVAL      V_MRREPA = APRprLocn
     C                   EVAL      V_MRTMES = TimeStamp
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_MRAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
     C                   EVAL      TranStatus = 'S'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC017
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CallMsgHdl - Call the Message Handling module                 *
      *****************************************************************
     C     CallMsgHdl    BEGSR
      *
      ***  Set up an array of sequence numbers that correspond to the fields
      ***  with errors
      *
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
      *
     C                   IF        FldNameArr(Ix) <> *blanks
      *
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             Ix
      *
     C                   ENDDO
      *
     C                   RESET                   ReturnCode
      *
     C                   MOVEL     DDLNRF        PLNRFID
     C                   MOVEL     DDVALD        PVDATID
     C                   MOVEL     DDSEQN        PLASNID
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      ***  Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      *
      ***  Repair location (1A, from caller)
     C                   PARM                    APRprLocn
      *
      ***  Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      *
      ***  List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      *
      ***  List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      *
      ***  List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      *
      ***  List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ***  Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      *
      ***  Midas module ID (2A)
     C                   Parm                    ModuleID
      *
      ***  Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      *
      ***  Message file (10A, from caller)
     C                   PARM                    #MsgFile
      *
      ***  Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ***  Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      *
      ***  Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      *
      ***  The following three parameters are needed when messages are to
      ***  be displayed on a screen
      ***  Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      *
      ***  Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      *
      ***  Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      *
      ***  The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      *
      ***  The transaction's timestamp
     C                   PARM                    TimeStamp
      *
      ***  Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      *
      ***  Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DtaSubs - Data Substitution                                   *
      *****************************************************************
     C     DtaSubs       BEGSR
      *
      ***  Convert file fields to screen format
      *
     C                   RESET                   ReturnCode
      *
     C                   EXSR      SetupAmd
      *
      ***  Substitute the data for the various parts of the transaction,
      ***  dependent on the flags that were set earlier.
      *
     C                   IF        RepScrn = 'Y'
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM                    GHSUBS
      *
      ***  Incoming Data
     C                   PARM      TransIncom    IncData        2000
      *
      ***  Current Data
     C                   PARM      CurMAPYCF     CurData        2000
      *
     C                   MOVEL     IncDATA       TransIncom
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Common header information (DS) from source system
     C                   PARM                    HeadIn
      *
      ***  Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    InfData500                                   CAP086
      *
      ***  Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
     C                   PARM                    ExtData500
      *
      ***  Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ***  Set up the name of the primary and secondary message files from
      ***  which the message handler will get the messages
      *
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
      *
      ***  Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'LE'
      *
      ***  Access Bank details via access program
      ***  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Access MIDAS Modules details via access program
      ***  (database error handling done in access program)
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ***  Determine if the features are installed
      *
     C                   MOVEL     'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
     C                   MOVEL     'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
     C                   MOVEL     'N'           CLE004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE004
     C                   END
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVEL     'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
     C                   END
      *
     C                   MOVEL     'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
      *
     C                   MOVEL     'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *
     C                   MOVEL     'N'           CLE023            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   END
      *
     C                   MOVEL     'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
     C                   MOVEL     'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
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
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
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
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 001                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APMAPYDTQ'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYC018
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
      *                                                                                       CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 002                                                CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
