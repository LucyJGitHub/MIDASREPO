     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility details validate and update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Lending ILE Module                                   *
      *                                                               *
      *  LEFCIPVU - Facilities details validate and update            *
      *                                                               *
      *  Function: This Program Validates LE Facilities details for   *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD039655           Date 11Feb20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD031146           Date 08Apr16               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD024398           Date 11May14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR937578A          Date 02Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 260940             Date 29Jul09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 244505             Date 12Jan07               *
      *                 245247             Date 31Jan07               *
      *                 244915             Date 05Feb07               *
      *                 BUG13174           Date 02Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 241113             Date 13Jul06               *
      *                 BUG10540           Date 14Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10093           Date 26Jan06               *
      *                 BUG9933            Date 17Jan06               *
      *                 BUG9613            Date 14Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9460            Date 03Dec05               *
      *                 BUG8870            Date 07Oct05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 BUG1621            Date 01Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 30Oct03               *
      *                 CAP084  *CREATE    Date 20Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039655 - Facility cannot be rejected.                      *
      *             Pattern fix from MD-29208 and MD-34908.           *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031146 - Amended program to populate FRNT and AFRT fields  *
      *             in FCLTYFN.                                       *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks amended:LEFCIPVD01,LEFCIPDTA,LEFCIPVC02, *
      *                              LEFCIPVC01,LEFCIPVC03,LEFCIPVC04 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD024398 - API Performance Optimisation                      *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSC054 - Period End Adjustments                              *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR006: SYNMAN Auto-Generated Events Browser       *
      *  CLE147 - Aggregate Facility                                  *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00359                                 *
      *             WNCPYSRC,LEH00321                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  260940 - Branch code does not default in Facilities Input.   *
      *           Default branch from ZMUSER if branch is not defined *
      *           during insert.                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  244505 - FCIP: fields for REGDATA not correctly retrieved    *
      *           due to additional fild 'DDPATH' sent by JAVA        *
      *           (field added by BUG11649). Annotated as BUG13174.   *
      *  245247 - Participant is unlinked when amended.               *
      *  244915 - Participant settlement is not defaulting            *
      *  BUG13174 - Applied fix 244505                                *
      *  239211 - Amending user is not captured during closure.       *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  241113 - If system value AllowEnterFctySeqNo = 'Y' then      *
      *           allow entry of facility sequence number during      *
      *           insert of a facility                                *
      *  BUG10540 - Add new assignment indicator. (Recompile)         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG10093- Mapping error in FCIP                              *
      *  BUG9933 - Settlement details must be validated only when     *
      *            the facility is syndicated.                        *
      *  BUG9613 - Interchanged the position of InfData and ExtData   *
      *            during concatenation on buffer parameter.          *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG9460 - On Approve of Facility Input, Settlement errors    *
      *            occurred.                                          *
      *  BUG8870 - Returned the correct status when action code is X. *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSC024 - Open Month End                                      *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG3723 - Recompile due to changes to LEFCSPPD.              *
      *  BUG1621 - Response mode should be 'S'                        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
 
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer Details                                                     CSF011
 
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
 
     D*PSysVal1*       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D PSysVal2        C                   CONST('AllowEnterFctySeqNo')                       241113
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LEFCPPPD)
     D TranInSeco    E DS                  EXTNAME(LEFCSPPD)
     D TranInDsUp    E DS                  EXTNAME(LEFCXPPD)                                  CLE106
     D TranInPrtn    E DS                  EXTNAME(LEFCZPPD)                                  CLE106
      *                                                                                       CLE106
      ** Pay settlement instructions in screen format                                         CLE106
      *                                                                                       CLE106
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)                                  CLE106
      *                                                                                       CLE106
      ** Receive settlement instructions in screen format                                     CLE106
      *                                                                                       CLE106
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)                                  CLE106
      *                                                                                       CLE106
      ** FRA/IRS settlement instructions in screen format                                     CLE106
      *                                                                                       CLE106
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)                                  CLE106
 
      * Valid Facility Details Screen A layout
     D ValidFCIM     E DS                  EXTNAME(LEVFCIMPD)
     D                                     PREFIX(V_)
      * Valid Facility Details Screen B layout
     D ValidFCIN     E DS                  EXTNAME(LEVFCINPD)
     D                                     PREFIX(V_)
                                                                                              CER001
     D ValidLUX      E DS                  EXTNAME(LEVFCLX1PD)                                CER001
      *                                                                                       CER001
      ** LE Facilities LUX Valid File Format                                                  CER001
      *                                                                                       CER001
                                                                                              CER001
      * (Current) Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FM_)
      * (Current) Facility record FN in file Format
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
     D                                     PREFIX(FN_)
 
     D FacnExFilFmt  E DS                  EXTNAME(BYFCLTX0)                                MD044880
     D                                     PREFIX(EX_)                                      MD044880
      * (Current) Facility in Screen Format - Primary Details
     D CurFcPrim     E DS                  EXTNAME(LEFCPPPD)
     D                                     PREFIX(@)
      * (Current) Facility in Screen Format - Secondary Details
     D CurFcSeco     E DS                  EXTNAME(LEFCSPPD)
     D                                     PREFIX(@)
      *                                                                                       CLE106
      ** Pay settlement instructions in file format                                           CLE106
      *                                                                                       CLE106
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)                                  CLE106
      *                                                                                       CLE106
      ** Receive settlement instructions in file format                                       CLE106
      *                                                                                       CLE106
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)                                  CLE106
      *                                                                                       CLE106
      ** FRA/IRS settlement instructions in file format                                       CLE106
      *                                                                                       CLE106
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)                                  CLE106
      *                                                                                       CLE106
      ** Pay settlement instructions - current                                                CLE106
      *                                                                                       CLE106
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)                        CLE106
      *                                                                                       CLE106
      * Receive settlement instructions - current                                             CLE106
      *                                                                                       CLE106
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)                        CLE106
      *                                                                                       CLE106
      ** FRA/IRS settlement instructions - current                                            CLE106
      *                                                                                       CLE106
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)                        CLE106
 
     D CrFCIPExtDta  E DS                  EXTNAME(LEFCEXPD) PREFIX(@)                      MD044880
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** Interface Data Format Definition File format                                         CAP086
 
      * Error indicators
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)
      *                                                                                       CLE106
      ** Flags to indicate whether Pay Settlement instruction fields                          CLE106
      **  are valid                                                                           CLE106
      *                                                                                       CLE106
     D OKPayInsDS      DS                                                                     CLE106
     D  DDPscyOK                      1A   INZ('Y')                                           CLE106
     D  DDPstmOK                      1A   INZ('Y')                                           CLE106
     D  DDPonxOK                      1A   INZ('Y')                                           CLE106
     D  DDRvnoOK                      1A   INZ('Y')                                           CLE106
     D  DDCvmrOK                      1A   INZ('Y')                                           CLE106
     D  DDPocnOK                      1A   INZ('Y')                                           CLE106
     D  DDPobnOK                      1A   INZ('Y')                                           CLE106
     D  DDRcrnOK                      1A   INZ('Y')                                           CLE106
     D  DDRcraOK                      1A   INZ('Y')                                           CLE106
     D  DDPibnOK                      1A   INZ('Y')                                           CLE106
     D  DDPibaOK                      1A   INZ('Y')                                           CLE106
     D  DDAwbnOK                      1A   INZ('Y')                                           CLE106
     D  DDAwbaOK                      1A   INZ('Y')                                           CLE106
     D  DDBennOK                      1A   INZ('Y')                                           CLE106
     D  DDBenaOK                      1A   INZ('Y')                                           CLE106
     D  DDDtp1OK                      1A   INZ('Y')                                           CLE106
     D  DDDtp2OK                      1A   INZ('Y')                                           CLE106
     D  DDDtp3OK                      1A   INZ('Y')                                           CLE106
     D  DDDtp4OK                      1A   INZ('Y')                                           CLE106
     D  DDDchgOK                      1A   INZ('Y')                                           CLE106
     D  DDIc72OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb1OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb2OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb3OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb4OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb5OK                      1A   INZ('Y')                                           CLE106
     D  DDBtb6OK                      1A   INZ('Y')                                           CLE106
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
      *                                                                                       CLE106
      ** Flags to indicate whether Receive Settlement instruction fields                      CLE106
      **  are valid                                                                           CLE106
      *                                                                                       CLE106
     D OKRecInsDS      DS                                                                     CLE106
     D  DDRscyOK                      1A   INZ('Y')                                           CLE106
     D  DDRstmOK                      1A   INZ('Y')                                           CLE106
     D  DDRonxOK                      1A   INZ('Y')                                           CLE106
     D  DDRocnOK                      1A   INZ('Y')                                           CLE106
     D  DDRobnOK                      1A   INZ('Y')                                           CLE106
     D  DDRibnOK                      1A   INZ('Y')                                           CLE106
     D  DDRibaOK                      1A   INZ('Y')                                           CLE106
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
      *                                                                                       CLE106
      ** Flags to indicate whether FRA/IRS instruction fields are valid                       CLE106
      *                                                                                       CLE106
     D OKFRAInsDS      DS                                                                     CLE106
     D  DDDsr1OK                      1A   INZ('Y')                                           CLE106
     D  DDDsr2OK                      1A   INZ('Y')                                           CLE106
     D  DDDsr3OK                      1A   INZ('Y')                                           CLE106
     D  DDDsr4OK                      1A   INZ('Y')                                           CLE106
     D  DDDsr5OK                      1A   INZ('Y')                                           CLE106
     D  DDDsr6OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr1OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr2OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr3OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr4OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr5OK                      1A   INZ('Y')                                           CLE106
     D  DDSsr6OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd1OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd2OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd3OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd4OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd5OK                      1A   INZ('Y')                                           CLE106
     D  DDCnd6OK                      1A   INZ('Y')                                           CLE106
     D  DDIsdaOK                      1A   INZ('Y')                                           CLE106
     D  DDAgtyOK                      1A   INZ('Y')                                           CLE106
     D  DDAgdtOK                      1A   INZ('Y')                                           CLE106
     D  DDAgvvOK                      1A   INZ('Y')                                           CLE106
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D ExtData       E DS                  EXTNAME(LEFCEXPD)
     D FCIPNotes     E DS                  EXTNAME(LEFCNTPD) PREFIX(N_)                     BUG10093
      * LE Facilities details Extra Data - File (D/B) format
     D RegData       E DS                  EXTNAME(LEFCRXPD)                                  CER001
     D                                     PREFIX(LR)                                         CER001
      *                                                                                       CER001
      ** Regional data in file format                                                         CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1CNUM                 1      6                                                       CER001
     D  #1FACT                 7      9                                                       CER001
     D  #1FCNO                10     11                                                       CER001
     D  #1RCTP                12     12                                                       CER001
     D  #1CCY                 13     15                                                       CER001
     D  #1AMNT                16     30S 0                                                    CER001
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5007       S            500A                                                      CLE106
     D Trans5009       S            500A                                                      CLE106
 
     D InfData500      S            500A                                                      CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
                                                                                            BUG10093
      ** Field (500A) to receive the incoming Facility Notes                                BUG10093
     D FCIPNote500     S            500A                                                    BUG10093
      ** Field (500A) to receive the incoming Regional Data                                   CER001
     D RegData500      S            500A                                                      CER001
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LEFCIPUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
     D ULX004          S              1A                                                      CER001
     D ZAMSID          S              7A                                                      CLE106
     D ZAMSGF          S             10A                                                      CLE106
     D ZAMSDA          S            132A                                                      CLE106
     D ZAMSTX          S            132A                                                      CLE106
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepFCIP         S              1A   INZ('N')
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     239211
                                                                                              LLN022
     D/COPY QWINDSRC,LEFCIPDTA                                                                LLN022
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
                                                                                              CSC024
     D CAP086          S              1A   INZ('N')                                           CAP086
                                                                                              CSF011
     D PCNum           S             10A                                                      CSF011
     D PKey7           S              7A                                                      CSF011
      ** Parameters for Calling AOCUSTR0                                                      CSF011
                                                                                              CSF011
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
                                                                                             LLN022A
     D ValidBoe      E DS                  EXTNAME(LEVFCIPX0)                                LLN022A
     D                                     Prefix(N)                                         LLN022A
     D OKBOEFlags    E DS                  EXTNAME(LEEFCIPX0)                                LLN022A
     D                                     PREFIX(OF_)                                       LLN022A
 
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
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     InfData500    InfData                                      CAP086
     C**********         MOVEL     Extdata500    Extdata                                      CAP086
     C                   MOVEL     ExtData500    ExtData                                      CAP086
     C                   MOVEL     FCIPNote500   FCIPNotes                                  BUG10093
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   MOVEL     Trans5007     TranInDsUp                                   CLE106
     C                   MOVEL     Trans5009     TranInPrtn                                   CLE106
      *                                                                                       239211
     C                   IN        ZMUSER                                                     239211
     C                   IF        DDAUCR = ' ' and DDACTN = 'C'                              239211
     C                             or DDAUCR = ' ' and DDACTN = 'R'                           239211
     C                   EVAL      DDAUSR = USRID                                             239211
     C                   EVAL      DDAUCR = 'Y'                                               239211
     C                   ENDIF                                                                239211
      *                                                                                       260940
      ** Default branch from ZMUSER if branch is not defined during insert.                   260940
      *                                                                                       260940
     C                   IF        DDBRCA = *BLANKS                                           260940
     C                             AND DDACTN = 'I'                                           260940
     C                   EVAL      DDBRCA = DBRN                                              260940
     C                   ENDIF                                                                260940
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      *  Set user field depending on action
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
     C                   EVAL         F1IUSR = APMIDUSR
     C                   WHEN         DDACTN = 'X'
     C                   EVAL         F1XUSR = APMIDUSR
     C                   WHEN         DDACTN = 'A'
     C                   EVAL         F1AUSR = APMIDUSR
 
     C                   ENDSL
 
      *
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
 
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   IF        CLE106 = 'Y'                                              BUG9460
     C                             AND DDSYIN = 'Y'                                          BUG9933
     C                   IF        DDPRTR = 'I'                                               CLE106
     C                             OR DDPRTR = 'P'                                            CLE106
     C                             OR DDPRTR = 'S'                                            CLE106
     C                             OR DDPRTR = 'R'                                            CLE106
      *                                                                                       244915
      ** Set payment and receipt settlement method to blanks instead                          244915
      ** of '00' to execute settle instruction defaulting module                              244915
      *                                                                                       244915
     C                   If        DDPSTM = '00'                                              244915
     C                             And DDRSTM = '00'                                          244915
     C                   Eval      DDRSTM = *Blanks                                           244915
     C                   Eval      DDPSTM = *Blanks                                           244915
     C                   EndIf                                                                244915
     C                   EXSR      DftSettmts                                                 CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                               BUG9460
     C*                                                                                       CLE106
     C                   EXSR      ValidateTr
      *                                                                                       CLE106
     C                   IF        Idx <> 0                                                   CLE106
     C                   GOTO      INVALID                                                    CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   IF        CLE106 = 'Y'                                              BUG9460
     C                             AND DDSYIN = 'Y'                                          BUG9933
     C                   IF        DDPRTR = 'I'                                               CLE106
     C                             OR DDPRTR = 'P'                                            CLE106
     C                             OR DDPRTR = 'S'                                            CLE106
     C                             OR DDPRTR = 'R'                                            CLE106
     C                   EXSR      ValidateSt                                                 CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                               BUG9460
 
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      BYCNUM = V_FPCNUM                                         LLN022A
     C                   EVAL      BYFACT = V_FPFACT                                         LLN022A
     C                   EVAL      BYFCNO = V_FPFCNO                                         LLN022A
      *                                                                                      LLN022A
      * Call Validation Module                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LEFCIPVAL1'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    Extdata                                     LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
      ** If error occured, go to INVALID                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx <> 0                                                  LLN022A
     C                   GOTO      INVALID                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EVAL      NLVCNUM = BYCNUM                                          LLN022A
     C                   EVAL      NLVFACT = BYFACT                                          LLN022A
     C                   EVAL      NLVFCNO = BYFCNO                                          LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   WHEN         DDACTN = 'A'
      *  Processing for Amends
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
      *                                                                                       CLE106
     C                   IF        Idx <> 0                                                   CLE106
     C                   GOTO      INVALID                                                    CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   IF        CLE106 = 'Y'                                              BUG9460
     C                             AND DDSYIN = 'Y'                                          BUG9933
     C                   IF        DDPRTR = 'I'                                              BUG9933
     C                             OR DDPRTR = 'P'                                           BUG9933
     C                             OR DDPRTR = 'S'                                           BUG9933
     C                             OR DDPRTR = 'R'                                           BUG9933
     C                   EXSR      ValidateSt                                                 CLE106
     C                   ENDIF                                                               BUG9933
     C                   ENDIF                                                               BUG9460
                                                                                             BUG4482
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      BYCNUM = V_FPCNUM                                         LLN022A
     C                   EVAL      BYFACT = V_FPFACT                                         LLN022A
     C                   EVAL      BYFCNO = V_FPFCNO                                         LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LEFCIPVAL1'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    Extdata                                     LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
      ** If error occured, go to INVALID                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx <> 0                                                  LLN022A
     C                   GOTO      INVALID                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EVAL      NLVCNUM = BYCNUM                                          LLN022A
     C                   EVAL      NLVFACT = BYFACT                                          LLN022A
     C                   EVAL      NLVFCNO = BYFCNO                                          LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      SetupAmd                                                 MD044880
     C                   EVAL      ExtData = CrFCIPExtDta                                   MD044880
                                                                                            MD044880
     C                   WHEN      DDACTN = 'R' OR DDACTN = 'C'                             MD044880
     C                   EXSR      SetupAmd                                                 MD044880
     C                   EVAL      ExtData = CrFCIPExtDta                                   MD044880
 
     C                   ENDSL
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C     Idx           ANDEQ     0                                                          CLE106
     C     DDACTN        IFEQ      'I'                                                        CLE106
     C     DDACTN        OREQ      'A'                                                        CLE106
     C     DDPMFC        ANDNE     *BLANKS                                                    245247
     C     DDPMFT        ANDNE     *BLANKS                                                    245247
     C     DDPMFN        ANDNE     *BLANKS                                                    245247
     C                   EXSR      ProcessPRTN                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *
     C     INVALID       TAG
 
      ** Population of Facility Customer Details                                              CSF011
     C                   EXSR      SrPopCust                                                  CSF011
                                                                                              CSF011
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ELSE
     C     DDACTN        IFEQ      'I'
                                                                                              CSC024
      ***Allow*entry*for*Facility*Seq.*No.*for*Insert*if*CSC024*is                     CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Facility Seq. No. for Insert if CSC054 is                            CSC054
      ** switched on and running on PEA system.                                               CSC054
      ** Also allow entry is system value AllowEnterFctySeqNo ='Y'                            241113
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     ALWFCNO       ANDNE     'Y'                                                        241113
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     ALWFCNO       ANDNE     'Y'                                                        241113
     C                   MOVE      *BLANK        DDFCNO
     C                   ENDIF                                                                CSC024
     C                   ENDIF
     C                   ENDIF
 
 
 
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C                   EVAL               Buffer = TranInPrim + TranInSeco
     C**********                                 + ExtData                                    CAP086
     C                                           + TranInDsUp                                 CLE106
     C                                           + TranInPrtn                                 CLE106
     C*********                                  + InfData + ExtData                  CAP086 BUG9613
     C**********                                 + ExtData + InfData                  BUG9613 CER001
     C**********                                 + InfData + RegData + InfData       CER001 BUG10093
     C**********                                 + FCIPNotes + InfData             BUG10093 BUG13174
     C                                           + FCIPNotes + DDPATH                       BUG13174
     C                                           + TranStamp                                  CER049
     C                                           + CADetails                                  CLE147
     C                                           + InfData                                  BUG13174
     C                                           + InRecSttmt                               BUG13174
     C                                           + InPaySttmt                                 CLE106
     C**********                                 + RegData + ExtData               BUG10093 MD044880
     C                                           + ExtData                                  MD044880
     C                                           + @ACTRV                                   MD039655
     C                                           + RegData                                  MD044880
     C
 
 
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
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LEFCIPRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C**********         PARM                    APRESPMODE        1                         BUG1621
     C                   PARM      'S'           APRESPMODE        1                         BUG1621
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Front Office User
     C                   PARM                    APFOTranUs       16
      *
      * (Midas) Facility Reference Number
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDBRCA
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM                    @ACTRV                                     MD039655
     C/COPY WNCPYSRC,LEH00359
      *
      * OUTPUTS
      *
      * (Current) Facility FM in file format
     C                   PARM                    FacmFilFmt
      *
      * (Current) Facility FN in file format
     C                   PARM                    FacnFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCSSN            1
      *
      * OK - Facility type
     C                   PARM                    OKFACT            1
      *
      * OK - Facility sub type
     C                   PARM                    OKFCNO            1
     C/COPY WNCPYSRC,LEH00321
      *
      * Reactivation indicator
     C                   PARM                    WREAC             1
      *
      * New Expiry date
     C                   PARM                    WNDTEX            5
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   Z-ADD     FM_TNLU       H#TNLU            5 0
 
     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'LEFCIPRTV1'                                             MD044880
     C                   PARM                    ReturnCode                                 MD044880
     C                   PARM                    DDACTN                                     MD044880
     C                   PARM                    APFOTranID                                 MD044880
     C                   PARM                    DDCSSN                                     MD044880
     C                   PARM                    DDFACT                                     MD044880
     C                   PARM                    DDFCNO                                     MD044880
     C                   PARM                    DDBRCA                                     MD044880
     C                   PARM                    FacnExFilFmt                               MD044880
     C                   ENDIF                                                              MD044880

     C                   ENDSR
 
 
      *****************************************************************
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * Default settlements - Apply default settlement instructions   *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
     C     DftSettmts    BEGSR                                                                CLE106
                                                                                              CLE106
      *                                                                                       CLE106
      ** Set up customer                                                                      CLE106
      *                                                                                       CLE106
     C                   MOVEL     DDCSSN        WWCUST           10                          CLE106
      *                                                                                       CLE106
      ** If ANY of the Settlements fields have been entered, bypass this                      CLE106
      **  routine.                                                                            CLE106
      ** Otherwise, use modules which will use Standard Settlement                            CLE106
      **  Instructions to apply defaults.                                                     CLE106
      *                                                                                       CLE106
     C                   IF            (InRecSttmt = *blank)                                  CLE106
     C                             AND (InPaySttmt = *blank)                                  CLE106
      *                                                                                       CLE106
     C                   CALLB     'ZASETINDFT'                                               CLE106
      *                                                                                       CLE106
      ** Output                                                                               CLE106
      ** Calling function type                                                                CLE106
      *                                                                                       CLE106
     C                   PARM      'LEND'        WWCALP            4                          CLE106
      *                                                                                       CLE106
      ** Payment currency                                                                     CLE106
      *                                                                                       CLE106
     C                   PARM      DDFCCY        WWPCCY            3                          CLE106
      *                                                                                       CLE106
      ** Receive currency                                                                     CLE106
      *                                                                                       CLE106
     C                   PARM      DDFCCY        WWRCCY            3                          CLE106
      *                                                                                       CLE106
      ** Customer (shortname or number)                                                       CLE106
      *                                                                                       CLE106
     C                   PARM      WWCUST        WWCSNM           10                          CLE106
      *                                                                                       CLE106
      ** Loan type                                                                            CLE106
      *                                                                                       CLE106
     C                   PARM      *BLANKS       WWTTYP            2                          CLE106
      *                                                                                       CLE106
      ** Federal Funds Ind.                                                                   CLE106
      *                                                                                       CLE106
     C                   PARM      *BLANK        WWFFND            1                          CLE106
      *                                                                                       CLE106
      ** ISDA Rules for FRA/IRS deals only                                                    CLE106
      ** Version of ISDA Rules govern                                                         CLE106
      *                                                                                       CLE106
     C                   PARM                    WBlnk4            4                          CLE106
      *                                                                                       CLE106
      ** Type of ISDA agreement                                                               CLE106
      *                                                                                       CLE106
     C                   PARM                    WBlnk6            6                          CLE106
      *                                                                                       CLE106
      ** Date of ISDA Agreement                                                               CLE106
      *                                                                                       CLE106
     C                   PARM                    WBlnk6X           6                          CLE106
      *                                                                                       CLE106
      ** Version of ISDA Agreement                                                            CLE106
      *                                                                                       CLE106
     C                   PARM                    WBlnk2            2                          CLE106
      *                                                                                       CLE106
      ** Version century of ISDA Agreement                                                    CLE106
      *                                                                                       CLE106
     C                   PARM                    WBlnk2X           2                          CLE106
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *                                                                                       CLE106
      ** Return                                                                               CLE106
      ** Defaulted Payment Settlement Instruction in file format                              CLE106
      *                                                                                       CLE106
     C                   PARM                    DBPaySttmt                                   CLE106
      *                                                                                       CLE106
      ** Defaulted Receipt Settlement Instruction in file format                              CLE106
      *                                                                                       CLE106
     C                   PARM                    DBRecSttmt                                   CLE106
      *                                                                                       CLE106
      ** Defaulted FRA/IRS Settlement Instruction in file format                              CLE106
      *                                                                                       CLE106
     C                   PARM                    DBFRASttmt                                   CLE106
      *                                                                                       CLE106
      ** The defaulted instructions are in file format, but the                               CLE106
      ** Settlements validation requires that they are in the input format.                   CLE106
      ** Therefore run them through a conversion module.                                      CLE106
      *                                                                                       CLE106
     C                   CALLB     'ZASETINCVT'                                               CLE106
      *                                                                                       CLE106
      ** Defaulted Settlement Instructions in file format                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    DBPaySttmt                                   CLE106
     C                   PARM                    DBRecSttmt                                   CLE106
     C                   PARM      *BLANK        DBFRASttmt                                   CLE106
      *                                                                                       CLE106
      ** Defaulted Settlement Instruction in input format                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    InPaySttmt                                   CLE106
     C                   PARM                    InRecSttmt                                   CLE106
     C                   PARM                    InFRASttmt                                   CLE106
     C                   PARM      DDFCCY        InTRCcy           3                         CSF011A
     C                   PARM      DDFCCY        InTPCcy           3                         CSF011A
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * ValidateSt - Routine to validate the settlement instructions  *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
     C     ValidateSt    BEGSR                                                                CLE106
      *                                                                                       CLE106
      ** Set up date of receipt and payment - use Midas rundate                               CLE106
      *                                                                                       CLE106
     C                   Z-ADD     BJRDNB        WWDATP                                       CLE106
     C                   Z-ADD     BJRDNB        WWDATR                                       CLE106
      *                                                                                       CLE106
      ** Set up customer                                                                      CLE106
      *                                                                                       CLE106
     C                   MOVEL     DDCSSN        WWCUST                                       CLE106
      *                                                                                       CLE106
     C                   RESET                   ReturnCode                                   CLE106
      *                                                                                       CLE106
     C                   CALLB     'ZASETINVAL'                                               CLE106
      *                                                                                       CLE106
      ** Return Code                                                                          CLE106
     C                   PARM                    ReturnCode                                   CLE106
      *                                                                                       CLE106
      ** Following parameters are output to called module                                     CLE106
      ** Calling function type                                                                CLE106
      *                                                                                       CLE106
     C                   PARM      'LEND'        WWCALP            4                          CLE106
      *                                                                                       CLE106
      ** Transaction Fields                                                                   CLE106
      ** Payment currency (or Loan currency if only one currency on Loan)                     CLE106
      *                                                                                       CLE106
     C                   PARM      DDFCCY        WWPCCY            3                          CLE106
      *                                                                                       CLE106
      ** Receive currency (or Loan currency if only one currency on Loan)                     CLE106
      *                                                                                       CLE106
     C                   PARM      DDFCCY        WWRCCY            3                          CLE106
      *                                                                                       CLE106
      ** Customer (shortname or number)                                                       CLE106
      *                                                                                       CLE106
     C                   PARM      WWCUST        WWCSNM           10                          CLE106
      *                                                                                       CLE106
      ** Loan type                                                                            CLE106
      *                                                                                       CLE106
     C                   PARM                    WWTTYP            2                          CLE106
      *                                                                                       CLE106
      ** Federal Funds Ind.                                                                   CLE106
      *                                                                                       CLE106
     C                   PARM      *BLANKS       WWFFND            1                          CLE106
      *                                                                                       CLE106
      ** Booking Branch                                                                       CLE106
      *                                                                                       CLE106
     C                   PARM      DDBRCA        WWBRCA            3                          CLE106
      *                                                                                       CLE106
      ** Receipt Date                                                                         CLE106
      *                                                                                       CLE106
     C                   PARM                    WWDATR            5 0                        CLE106
      *                                                                                       CLE106
      ** Payment Date                                                                         CLE106
      *                                                                                       CLE106
     C                   PARM                    WWDATP            5 0                        CLE106
      *                                                                                       CLE106
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction                  CLE106
      *                                                                                       CLE106
     C                   PARM                    InPaySttmt                                   CLE106
     C                   PARM                    InRecSttmt                                   CLE106
     C                   PARM                    InFRASttmt                                   CLE106
      *                                                                                       CLE106
      ** Action Code                                                                          CLE106
      *                                                                                       CLE106
     C                   PARM      DDACTN        WWACTN            1                          CLE106
      *                                                                                       CLE106
      ** Protect Payment Field                                                                CLE106
      *                                                                                       CLE106
     C                   PARM                    WWPPAY            1                          CLE106
      *                                                                                       CLE106
      ** Protect Receipt Field                                                                CLE106
      *                                                                                       CLE106
     C                   PARM                    WWPREC            1                          CLE106
      *                                                                                       CLE106
      ** Following parameters are returned by called module                                   CLE106
      ** Payment Instruction OK flag                                                          CLE106
      *                                                                                       CLE106
     C                   PARM                    OKPayInsDS                                   CLE106
      *                                                                                       CLE106
      ** Receive Instruction OK flag                                                          CLE106
      *                                                                                       CLE106
     C                   PARM                    OKRecInsDS                                   CLE106
      *                                                                                       CLE106
      ** FRA/IRS Instruction OK flag                                                          CLE106
      *                                                                                       CLE106
     C                   PARM                    OKFRAInsDS                                   CLE106
      *                                                                                       CLE106
      ** Error fields/message IDs (arrays) from/to caller                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
      *                                                                                       CLE106
      ** Array index (3P0) from/to caller                                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    Idx                                          CLE106
      *                                                                                       CLE106
      ** Warning Messages                                                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    WFldNamArr                                   CLE106
     C                   PARM                    WMsgIDArr                                    CLE106
     C                   PARM                    WMsgDtaArr                                   CLE106
     C                   PARM                    WIdx                                         CLE106
      *                                                                                       CLE106
      ** Payment instructions - file format                                                   CLE106
      *                                                                                       CLE106
     C                   PARM                    DBPaySttmt                                   CLE106
      *                                                                                       CLE106
      ** Receive instructions - file format                                                   CLE106
      *                                                                                       CLE106
     C                   PARM                    DBRecSttmt                                   CLE106
      *                                                                                       CLE106
      ** FRA/IRS instructions - file format                                                   CLE106
      *                                                                                       CLE106
     C                   PARM                    DBFRASttmt                                   CLE106
      *                                                                                       CLE106
      ** Extra Input                                                                          CLE106
      ** Action Code used                                                                     CLE106
      *                                                                                       CLE106
     C                   PARM      DDACTN        WWACTN            1                          CLE106
      *                                                                                       CLE106
      ** Validation Iteration                                                                 CLE106
      *                                                                                       CLE106
     C                   PARM      '1ST'         WWValIter         3                          CLE106
      *                                                                                       CLE106
     C                   MOVEL     FLPSTM        V_FPPSTM                                     CLE106
     C                   MOVEL     FLPONS        V_FPPONS                                     CLE106
     C                   MOVEL     FLPIBN        V_FPPIBN                                     CLE106
     C                   MOVEL     FLPIBA        V_FPPIBA                                     CLE106
     C                   MOVEL     FLPOBN        V_FPPOBN                                     CLE106
     C                   MOVEL     FLPOCN        V_FPPOCN                                     CLE106
     C                   MOVEL     FLRCRN        V_FPRCRN                                     CLE106
     C                   MOVEL     FLRCRA        V_FPRCRA                                     CLE106
     C                   MOVEL     FLRVNO        V_FPRVNO                                     CLE106
     C                   MOVEL     FLAWBN        V_FPAWBN                                     CLE106
     C                   MOVEL     FLAWBA        V_FPAWBA                                     CLE106
     C                   MOVEL     FLBENN        V_FPBENN                                     CLE106
     C                   MOVEL     FLBENA        V_FPBENA                                     CLE106
     C                   MOVEL     FLDTP1        V_FPDTP1                                     CLE106
     C                   MOVEL     FLDTP2        V_FPDTP2                                     CLE106
     C                   MOVEL     FLDTP3        V_FPDTP3                                     CLE106
     C                   MOVEL     FLDTP4        V_FPDTP4                                     CLE106
     C                   MOVEL     FLDCHG        V_FPDCHG                                     CLE106
     C                   MOVEL     FLBTB1        V_FPBTB1                                     CLE106
     C                   MOVEL     FLBTB2        V_FPBTB2                                     CLE106
     C                   MOVEL     FLBTB3        V_FPBTB3                                     CLE106
     C                   MOVEL     FLBTB4        V_FPBTB4                                     CLE106
     C                   MOVEL     FLBTB5        V_FPBTB5                                     CLE106
     C                   MOVEL     FLBTB6        V_FPBTB6                                     CLE106
     C                   MOVEL     FLPOBR        V_FPOMDB                                     CLE106
     C                   MOVEL     FLCVMR        V_FPCVMR                                     CLE106
     C                   MOVEL     FLPSCY        V_FPPSCY                                     CLE106
     C                   MOVEL     FLIC72        V_FPICCY                                     CLE106
     C                   Z-ADD     FLPEXR        V_FPPEXR                                     CLE031
     C                   MOVEL     FLPEXI        V_FPPEXI                                     CLE031
      *                                                                                       CLE106
     C                   MOVEL     FLRSTM        V_FPRSTM                                     CLE106
     C                   MOVEL     FLRONS        V_FPRONS                                     CLE106
     C                   MOVEL     FLRIBN        V_FPRIBN                                     CLE106
     C                   MOVEL     FLRIBA        V_FPRIBA                                     CLE106
     C                   MOVEL     FLROBN        V_FPROBN                                     CLE106
     C                   MOVEL     FLROCN        V_FPROCN                                     CLE106
     C                   MOVEL     FLROBR        V_FPOSDB                                     CLE106
     C                   MOVEL     FLRSCY        V_FPSCCY                                     CLE106
     C                   Z-ADD     FLREXR        V_FPREXR                                     CLE031
     C                   MOVEL     FLREXI        V_FPREXI                                     CLE031
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
     C                   MOVE      FacmFilFmt    ValidFCIM
     C                   MOVE      FacnFilFmt    ValidFCIN
 
      * For Amends, convert the Facility to screen format
 
     C                   CALLB     'LEFCIPCVT'
      * INPUTS
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      * Facility - file formats
     C                   PARM                    ValidFCIM
     C                   PARM                    ValidFCIN
      * Output parameters
      * Facility Details - screen formats
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
      *                                                                                       CLE106
     C                   MOVEL     FM_PSTM       FLPSTM                                       CLE106
     C                   MOVEL     FM_PONS       FLPONS                                       CLE106
     C                   MOVEL     FM_PIBN       FLPIBN                                       CLE106
     C                   MOVEL     FM_PIBA       FLPIBA                                       CLE106
     C                   MOVEL     FM_POBN       FLPOBN                                       CLE106
     C                   MOVEL     FM_POCN       FLPOCN                                       CLE106
     C                   MOVEL     FM_RCRN       FLRCRN                                       CLE106
     C                   MOVEL     FM_RCRA       FLRCRA                                       CLE106
     C                   MOVEL     FM_RVNO       FLRVNO                                       CLE106
     C                   MOVEL     FM_AWBN       FLAWBN                                       CLE106
     C                   MOVEL     FM_AWBA       FLAWBA                                       CLE106
     C                   MOVEL     FM_BENN       FLBENN                                       CLE106
     C                   MOVEL     FM_BENA       FLBENA                                       CLE106
     C                   MOVEL     FM_DTP1       FLDTP1                                       CLE106
     C                   MOVEL     FM_DTP2       FLDTP2                                       CLE106
     C                   MOVEL     FM_DTP3       FLDTP3                                       CLE106
     C                   MOVEL     FM_DTP4       FLDTP4                                       CLE106
     C                   MOVEL     FM_DCHG       FLDCHG                                       CLE106
     C                   MOVEL     FM_BTB1       FLBTB1                                       CLE106
     C                   MOVEL     FM_BTB2       FLBTB2                                       CLE106
     C                   MOVEL     FM_BTB3       FLBTB3                                       CLE106
     C                   MOVEL     FM_BTB4       FLBTB4                                       CLE106
     C                   MOVEL     FM_BTB5       FLBTB5                                       CLE106
     C                   MOVEL     FM_BTB6       FLBTB6                                       CLE106
     C                   MOVEL     FM_OMDB       FLPOBR                                       CLE106
     C                   MOVEL     FM_CVMR       FLCVMR                                       CLE106
     C                   MOVEL     FM_PSCY       FLPSCY                                       CLE106
     C                   MOVEL     FM_ICCY       FLIC72                                       CLE106
     C                   Z-ADD     FM_PEXR       FLPEXR                                       CLE031
     C                   MOVEL     FM_PEXI       FLPEXI                                       CLE031
      *                                                                                       CLE106
     C                   MOVEL     FM_RSTM       FLRSTM                                       CLE106
     C                   MOVEL     FM_RONS       FLRONS                                       CLE106
     C                   MOVEL     FM_RIBN       FLRIBN                                       CLE106
     C                   MOVEL     FM_RIBA       FLRIBA                                       CLE106
     C                   MOVEL     FM_ROBN       FLROBN                                       CLE106
     C                   MOVEL     FM_ROCN       FLROCN                                       CLE106
     C                   MOVEL     FM_OSDB       FLROBR                                       CLE106
     C                   MOVEL     FM_SCCY       FLRSCY                                       CLE106
     C                   Z-ADD     FM_REXR       FLREXR                                       CLE031
     C                   MOVEL     FM_REXI       FLREXI                                       CLE031
      *                                                                                       CLE106
      ** The defaulted instructions are in file format, but the                               CLE106
      ** Settlements validation requires that they are in the input format.                   CLE106
      ** Therefore run them through a conversion module.                                      CLE106
      *                                                                                       CLE106
     C                   IF        CLE106 = 'Y'                                              BUG9460
     C                             AND DDSYIN = 'Y'                                          BUG9933
     C                   CALLB     'ZASETINCVT'                                               CLE106
      *                                                                                       CLE106
      ** Defaulted Settlement Instructions in file format                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    DBPaySttmt                                   CLE106
     C                   PARM                    DBRecSttmt                                   CLE106
     C                   PARM      *BLANK        DBFRASttmt                                   CLE106
      *                                                                                       CLE106
      ** Current Settlement Instruction in input format                                       CLE106
      *                                                                                       CLE106
     C                   PARM                    CrPaySttmt                                   CLE106
     C                   PARM                    CrRecSttmt                                   CLE106
     C                   PARM                    CrFRASttmt                                   CLE106
     C                   PARM      FM_FCCY       InTRCcy                                     CSF011A
     C                   PARM      FM_FCCY       InTPCcy                                     CSF011A
      *                                                                                       CLE106
      ** If no Payment or Receive instructions have been supplied                             CLE106
      ** Default them to those currently on the deal.                                         CLE106
      *                                                                                       CLE106
     C                   IF            (InPaySttmt = *blank)                                  CLE106
     C                   EVAL      InPaySttmt = CrPaySttmt                                    CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   IF            (InRecSttmt = *blank)                                  CLE106
     C                   EVAL      InRecSttmt = CrRecSttmt                                    CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                               BUG9460
 
     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'LEFCIPCVT1'                                             MD044880
     C                   PARM                    ReturnCode                                 MD044880
     C                   PARM                    DDCSSN                                     MD044880
     C                   PARM                    DDFACT                                     MD044880
     C                   PARM                    DDFCNO                                     MD044880
     C                   PARM                    FacnExFilFmt                               MD044880
     C                   PARM                    CrFCIPExtDta                               MD044880
     C                   ENDIF                                                              MD044880

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      * MORE THAN ONE VALIDATION - SORT IT OUT                         *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Facility Primary details
 
     C                   EXSR      ValdFcPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Facility Secondary details
 
     C                   EXSR      ValdFcSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *                                                                                       CER001
      ** Validate extended details                                                            CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EXSR      ValidateLUX                                                CER001
      *                                                                                       CER001
      ** If error in validation, fail this input                                              CER001
      *                                                                                       CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EValidTr                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFcPrim - Validate Facility Primary details                *
      *                                                               *
      *****************************************************************
     C     ValdFcPrim    BEGSR
 
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      F1TNRF = %SubSt(TranInDsUp:1:15)                           CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   CALLB     'LEFCIP1VL'
 
      * INPUTS
 
      * Response mode
     C**********         PARM                    RespMode          1                         BUG1621
     C                   PARM      'S'           RespMode          1                         BUG1621
      * Mode
     C                   PARM                    ModeOfop
      ** Customer Primary Details
     C                   PARM                    TranInPrim
      ** Customer Secondary Details                                                           CLE106
     C                   PARM                    TranInSeco                                   CLE106
      ** Facility FM File format
     C                   PARM                    FacmFilFmt
      ** Facility FN File format
     C                   PARM                    FacnFilFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * CLE002
     C                   PARM                    CLE002
      * CLE005
     C                   PARM                    CLE005            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
 
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      * Customer Extra Data file data
     C**********         PARM                    ExtData                                    BUG10093
     C                   PARM                    FCIPNotes                                  BUG10093
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM                    @ACTRV                                     MD039655
      * OUTPUTS
 
      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcPrim
 
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
 
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFCIM
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFCIN
 
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
 
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
 
      * Start date used in the other validation module
     C                   PARM                    W#DTAP            5
 
      * Expiry date used in the other validation module
     C                   PARM                    W#DTEX            5
 
      * Facility decimal places used in the other validation module
     C                   PARM                    W#NBDP            1
 
      * CA currency used in the other validation module
     C                   PARM                    WCACCY            3
 
      * Facilty amount
     C                   PARM                    W#FAMT           13 0
 
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails                                    CLE147
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFcSeco - Validate Facility Secondary details              *
      *                                                               *
      *****************************************************************
     C     ValdFcSeco    BEGSR
 
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      WWPRTR = %SubSt(TranInSeco:182:1)                          CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      WWPRTR = FM_PRTR                                           CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   CALLB     'LEFCIP2VL'
 
      * INPUTS
 
      * Response mode
     C**********         PARM                    RespMode          1                         BUG1621
     C                   PARM      'S'           RespMode          1                         BUG1621
      ** Facility Primary Details
     C                   PARM                    TranInPrim
      ** Facility Secondary Details
     C                   PARM                    TranInSeco
      * Facility - file formats
     C                   PARM                    FacmFilFmt
     C                   PARM                    FacnFilFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    W#DTAP
      * Expiry date
     C                   PARM                    W#DTEX
      * Reactivation indicator
     C                   PARM                    WREAC
      * New Expiry date
     C                   PARM                    WNDTEX
      * Facility decimal places
     C                   PARM                    W#NBDP
      * OK indicator - field TRCA
     C                   PARM                    DDTRCAOK
      * OK indicator - field CAFT
     C                   PARM                    DDCAFTOK
      * OK indicator - field CAFN
     C                   PARM                    DDCAFNOK
      * CA currency used in the other validation module
     C                   PARM                    WCACCY
      * Facilty amount
     C                   PARM                    W#FAMT
      * Account officer to default
     C                   PARM                    WBLACF
      * Particiapnt Fclty indicator
     C**********         PARM                    FM_PRTR                                      CLE106
     C                   PARM                    WWPRTR            1                          CLE106
      * Customer Extra Data file data
     C**********         PARM                    ExtData                                    BUG10093
     C                   PARM                    FCIPNotes                                  BUG10093
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
                                                                                            MD039655
      ** Reject Action Code                                                                 MD039655
                                                                                            MD039655
     C                   PARM                    @ACTRV                                     MD039655
 
      * OUTPUTS
      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcSeco
 
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
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFCIM
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFCIN
      * Facility amount has changed                                                           222373
     C                   PARM                    FacAmChg          1                          222373
      * Table OAM to be updated                                                               222373
     C                   PARM                    UpdOam            1                          222373
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
     C     ValidateLUX   BEGSR                                                                CER001
     C                   MOVEL     DDCSSN        #1CNUM                                       CER001
     C                   MOVEL     DDFACT        #1FACT                                       CER001
     C                   MOVEL     DDFCNO        #1FCNO                                       CER001
     C                   EVAL      #1CCY   = DDFCCY                                           CER001
     C                   EVAL      #1AMNT  = V_FPFAMT                                         CER001
     C                   CALLB     'LEFCIP3VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKACTN                                       CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   ENDSR                                                                CER001
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
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFCIPAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    TraninPrim
     C                   PARM                    TraninSeco
      *
      * (Current) Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
      *
      * Facility - file formats
     C                   PARM                    ValidFCIM
     C                   PARM                    ValidFCIN
      *
      * CLE005
     C                   PARM                    CLE005
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007
      * CLE008
     C                   PARM                    CLE008
      * Screen to validate - if blank both screens will be validated
     C                   PARM      ' '           SCREEN            1
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * ProcessPRTN - Convert Participant screen fields into file     *                       CLE106
      *               format. These will ultimately be written to the *                       CLE106
      *               Facility table.                                 *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
     C     ProcessPRTN   BEGSR                                                                CLE106
      *                                                                                       CLE106
     C                   CALLB     'LEFCIPPRT'                                                CLE106
      *                                                                                       CLE106
      ** INPUTS                                                                               CLE106
      *                                                                                       CLE106
      ** Participant Details                                                                  CLE106
      *                                                                                       CLE106
     C                   PARM                    TranInPrtn                                   CLE106
      *                                                                                       CLE106
      ** OUTPUTS                                                                              CLE106
      *                                                                                       CLE106
      ** Error fields/message IDs/message data (arrays) from/to caller                        CLE106
      *                                                                                       CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
     C                   PARM                    MsgDtaArr                                    CLE106
      *                                                                                       CLE106
      ** Array index (3P0) from/to caller                                                     CLE106
      *                                                                                       CLE106
     C                   PARM                    Idx                                          CLE106
      *                                                                                       CLE106
      ** Valid Facility FM layout (DS) from/to caller                                         CLE106
      *                                                                                       CLE106
     C                   PARM                    ValidFCIM                                    CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
      *                                                                                      LLN022A
      ** Call LE Facility BOE database update                                                LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'LEFCIPUPD1'                                              LLN022A
     C                   PARM                    PRTCD                                       LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   CALLB     'LEFCIP2UP'                                                CER001
     C                   PARM                    PRTCD                                        CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   ENDIF                                                                CER001
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
 
 
     C                   RESET                   FldNoArr
     C                   CLEAR                   CurFcPrim
     C                   CLEAR                   CurFcSeco
 
     C                   MOVE      *ALL'Y'       OKFcPrim
     C                   MOVE      *ALL'Y'       OKFcSeco
 
     C                   CLEAR                   ValidFCIM
     C                   CLEAR                   ValidFCIN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * For Reversed or Closure or Authorisation
      * put the complete (pre-existing) Facility
      *  into the Valid file record
     C                   IF           DDACTN = 'R' OR DDACTN = 'C'
     C                                OR DDACTN = 'X'
     C                   MOVE      FacmFilFmt    ValidFCIM
     C                   MOVE      FacnFilFmt    ValidFCIN
     C                   ENDIF
     C                   IF        DDACTN = 'X'                                              BUG8870
     C                   EVAL      V_FPFSTS = 'A'                                            BUG8870
     C                   ENDIF                                                               BUG8870
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_FPCHTP = DDACTN
 
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_FPAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CAP086
      * Include Header fields that need to be o/p to the Valid file
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_FPPCRF      V_FPFRNT
     C                   Else
     C                   EVAL      V_FPFRNT = APFOTranID
     C                   EndIf
     C                   EVAL      V_FPAFRT = APFOAsocID
     C                   EVAL      V_FPREPA = APRprLocn
     C                   EVAL      V_FPSTMP = TimeStamp
     C                   EVAL      LVFOID   = APFOAsocID                                      CER001
     C                   EVAL      LVRPLC   = APRprLocn                                       CER001
     C                   EVAL      LVTMSP   = TimeStamp                                       CER001
     C                   EVAL      V_FNFRNT = V_FPFRNT                                      MD031146
     C                   EVAL      V_FNAFRT = V_FPAFRT                                      MD031146
 
     C                   EXSR      SRSTAT                                                    BUG8870
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      *
      ***  Update valid Fclty: Facility Ref
      *
     C                   MOVEL     DDCSSN        V_FPCNUM
     C                   MOVEL     DDCSSN        V_FNCNUM
     C                   MOVEL     DDCSSN        LVCNUM                                       CER001
     C                   MOVEL     DDFACT        V_FPFACT
     C                   MOVEL     DDFACT        V_FNFACT
     C                   MOVEL     DDFACT        LVFACT                                       CER001
 
     C                   MOVEL     DDFCNO        V_FPFCNO
     C                   MOVEL     DDFCNO        V_FNFCNO
     C                   MOVEL     DDFCNO        LVFCNO                                       CER001
     C                   EVAL      LVEXPO  =  V_FNPEXP                                        CER001
      *
      ***  Update valid Fclty: Last action code
      *
     C                   MOVEL     DDACTN        V_FPCHTP
     C                   MOVEL     DDACTN        V_FNCHTP
      *                                                                                       239211
      ** Populate amending user during closure or reversal.                                   239211
      *                                                                                       239211
     C                   IF        DDACTN = 'C' or DDACTN = 'R'                               239211
     C                   EVAL      V_FPAUSR = DDAUSR                                          239211
     C                   ENDIF                                                                239211
      *
      ***  Fclty updates
      *
     C     @RTCD         IFEQ      *BLANK
 
     C                   CALLB     'LEFCIPUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    P#MODE            1
     C                   PARM                    ValidFCIM
     C                   PARM                    ValidFCIN
     C                   PARM                    CLE008            1
     C                   PARM                    CSC011            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3                       AR937578A
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU            5 0
      *
      * OUTPUTS
      *
     C                   PARM                    OKFcPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
 
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEF0426'     MsgIdArr(1)
 
     C                   END
 
 
     C                   ENDSR
      *****************************************************************                      BUG8870
      * SRSTAT  -  Determine facility status narrative                *                      BUG8870
      *****************************************************************                      BUG8870
     C     SRSTAT        BEGSR                                                               BUG8870
                                                                                             BUG8870
     C                   MOVE      *BLANKS       ZAMSID                                      BUG8870
     C                   MOVE      *BLANKS       DDFSTS                                      BUG8870
                                                                                             BUG8870
     C                   SELECT                                                              BUG8870
     C     V_FPFSTS      WHENEQ    'C'                                                       BUG8870
     C                   MOVEL     'LEF0118'     ZAMSID                                      BUG8870
     C     V_FPRECI      WHENEQ    'D'                                                       BUG8870
     C     V_FPFSTS      ANDEQ     'A'                                                       BUG8870
     C                   MOVEL     'LEF0119'     ZAMSID                                      BUG8870
     C     V_FPRECI      WHENEQ    'D'                                                       BUG8870
     C     V_FPFSTS      ANDEQ     'R'                                                       BUG8870
     C                   MOVEL     'LEF0120'     ZAMSID                                      BUG8870
     C     V_FPRECI      WHENEQ    'R'                                                       BUG8870
     C     V_FPFSTS      ANDEQ     'A'                                                       BUG8870
     C                   MOVEL     'LEF0121'     ZAMSID                                      BUG8870
     C     V_FPRECI      WHENEQ    'C'                                                       BUG8870
     C     V_FPFSTS      ANDEQ     'A'                                                       BUG8870
     C                   MOVEL     'LEF0122'     ZAMSID                                      BUG8870
     C     V_FPRECI      WHENEQ    'E'                                                       BUG8870
     C                   MOVEL     'LEF0124'     ZAMSID                                      BUG8870
     C                   OTHER                                                               BUG8870
     C                   MOVE      *BLANKS       DDFSTS                                      BUG8870
     C                   ENDSL                                                               BUG8870
                                                                                             BUG8870
     C     ZAMSID        IFNE      *BLANKS                                                   BUG8870
     C                   CALL      'Y2RVMGC'                                                 BUG8870
     C                   PARM      *BLANKS       @RTCD                                       BUG8870
     C                   PARM                    ZAMSID                                      BUG8870
     C                   PARM      'LERMSGF '    ZAMSGF                                      BUG8870
     C                   PARM                    ZAMSDA                                      BUG8870
     C                   PARM                    ZAMSTX                                      BUG8870
     C                   EVAL      DDFSTS = ZAMSTX                                           BUG8870
     C                   ENDIF                                                               BUG8870
                                                                                             BUG8870
     C                   ENDSR                                                               BUG8870
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   IF        DDCSSN <> *BLANKS                                          CSF011
     C                   EVAL      PCNum = DDCSSN                                             CSF011
                                                                                              CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        PRtcd = *BLANKS                                            CSF011
     C                   EVAL      DDCRSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCRNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCRTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                             CSF011A
      ** Retrieve Customer Details for Credit Agreement Customer                             CSF011A
                                                                                             CSF011A
     C                   IF        DDCANM <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCANM                                            CSF011A
                                                                                             CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCCTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Details                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       PRtcd                                        CSF011
     C                   PARM      '*KEY   '     POptn                                        CSF011
     C                   PARM                    PCNum                                        CSF011
     C                   PARM      *BLANKS       PKey7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5007                                    CLE106
     C                   PARM                    Trans5009                                    CLE106
     C                   PARM                    FCIPNote500                                BUG10093
     C                   PARM                    TranStamp        51                          CER049
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
     C                   PARM                    InPaySttmt                                   CLE106
     C                   PARM                    InRecSttmt                                   CLE106
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    DDPATH          200                        BUG13174
     C                   PARM                    CADetails        33                          CLE147
     C                   PARM                    @ACTRV            1                        MD039655
 
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
      ** CSC022 is a mandatory feature already, so it's always on                           MD024398
     C**********         Call      'AOSARDR0'                                        CSC022 MD024398
     C**********         Parm      *BLANKS       @RTCD                               CSC022 MD024398
     C**********         Parm      '*VERIFY'     @OPTN                               CSC022 MD024398
     C**********         Parm      'CSC022'      PSARD                               CSC022 MD024398
     C*****SCSARD        Parm      SCSARD        DSFDY                               CSC022 MD024398
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C**********         If        @RTCD = *Blanks                                   CSC022 MD024398
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C**********         Else                                                        CSC022 MD024398
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C**********         If        @RTCD <> '*NRF   '                                CSC022 MD024398
     C******Lock         In        LDA                                               CSC022 MD024398
     C**********         MoveL     'LEFCIPVU'    DBPGM                               CSC022 MD024398
     C**********         MoveL     'SCSARDPD'    DBFILE                              CSC022 MD024398
     C**********         MoveL     'CSC022'      DBKEY                 ************* CSC022 MD024398
     C**********         Z-Add     900           DBASE                 * DBASE 900 * CSC022 MD024398
     C**********         Out       LDA                                 ************* CSC022 MD024398
     C**********         ExSR      *PSSR                                             CSC022 MD024398
     C**********         EndIf                                                       CSC022 MD024398
      *                                                                                       CSC022
     C**********         EndIf                                                       CSC022 MD024398
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LEFCIPM01
 
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Determine if CLE002 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
 
      ** Determine if CLE008 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
      ** CSC011 is a redundant feature. No need to check                                    MD024398
     C**********         CALL      'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD                                      MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      **********                                                                            MD024398
     C*****@RTCD         IFNE      *BLANKS                                                  MD024398
     C                   MOVEL     'N'           CSC011            1
     C**********         ELSE                                                               MD024398
     C**********         MOVEL     'Y'           CSC011                                     MD024398
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
      **********                                                                            MD024398
     C**********         ENDIF                                                              MD024398
      *
      ** Determine if CEU013 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD  <> *BLANK                                           CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '                    CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'LEFCIPVU'    DBPGM                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     'ULX004'      DBKEY                                        CER001
     C                   Z-ADD     901           DBASE                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
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
     C                   EVAL      DBase  = 1                                                 CSC024
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
     C                   ENDIF                                                                241113
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 241113
     C                   PARM      PSysVal2      P@OP02                                       241113
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
     C                   EVAL      DBase = 2                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C**********         ENDIF                                                         CSC024 241113
     C                   MOVEL     P@VL02        ALWFCNO           1                          241113
                                                                                              CAP086
      ** Check if enhancement CAP086 (Open Month End) is on                                   CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 1                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
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
      *
 
     C* Override SKTranFlLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
 
     C                   MOVE      *BLANKS       @RTCD
 
     C                   ENDSR
      *****************************************************************
** ##OX1
OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)
