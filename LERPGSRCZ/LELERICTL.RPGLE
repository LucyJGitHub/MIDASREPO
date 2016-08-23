     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instr Interface Controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERICTL - LE Rollover Instructions Maintenance             *
      *                                                               *
      *  Function: This Program Validates LE Rollover Instr for       *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For A (=Amend)                                   *
      *              - Validate the Rollover Instr. details fields    *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise)                               *
      *              - Move input fields into valid fields and bypass *
      *                the rest of the validation                     *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR702532           Date 13Jan15               *
      *  Prev Amend No. MD028338           Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10456           Date 10Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2579            Date 08Jun04               *
      *                 BUG2665            Date 13May04               *
      *                 BUG827             Date 06May04               *
      *                 CAP084             Date 09Jan04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA067             Date 22Mar04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 WA0021             Date 02Oct03               *
      *                 WA0027             Date 01Oct03               *
      *                 WA0005             Date 19Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 21May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10456- Validate and update settlement details without     *
      *            limitations.                                       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  BUG2665 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - API wrapper project                                 *
      *           Remove Rollover Status from defn file (recompile)   *
      *  CDL018 - Mulitple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA067 - Misaligned settlement details                       *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  WA0021 - Remove Rollover Status from defn file (recompile)   *
      *  WA0027 - Loan number should be alpha not numeric             *
      *  WA0004 - Recompiled over changed LEVLERLPD                   *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Customer Loans CK file
     FLEVLERKPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Customer Loans CL file
     FLEVLERLPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
 
     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      * Invalid Rollover Instructions
     FLEILERIPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVLERIL0 IF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVCLILCK0)
     F                                     RENAME(LEVCLIKD0:LEVCLIKCK0)
     FLEVLERIL1 IF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVCLILCK1)
     F                                     RENAME(LEVCLIKD0:LEVCLIKCK1)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
     FLEFCLTL0  IF   E           K DISK
     F                                     PREFIX(F_)
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELERIC001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D WArrCmtJob      S             10A   DIM(10)                                           BUG2665
      ** Array for Commitment Job Names                                                      BUG2665
                                                                                             BUG2665
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2665
      ** Data structure for SCCMTJOB data area                                               BUG2665
     D  COMITNO                1      3S 0                                                   BUG2665
     D  COMITJOBS              4    103                                                      BUG2665
                                                                                             BUG2665
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
      *           (New rollover in screen format)
     D TranIn        E DS                  EXTNAME(LELERIPD)
 
      * Valid Customer Loans CL layout
     D ValidLoanL    E DS                  EXTNAME(LEVLERLPD)
     D                                     PREFIX(V_)
     D**CLREC****************459    527                                                       TDA067
     D**CLPAY****************528   1086                                                       TDA067
     D  CLREC                473    527                                                       TDA067
     D  CLPAY                542   1086                                                       TDA067
 
      * Valid Customer Loans CK layout
     D ValidLoanK    E DS                  EXTNAME(LEVLERKPD)
     D                                     PREFIX(V_)
     D  VK_CLRECI    E                     EXTFLD(CLRECI)
     D  VK_CLLNRF    E                     EXTFLD(CLLNRF)
     D  VK_CLRCDT    E                     EXTFLD(CLRCDT)
     D  VK_CLMRIN    E                     EXTFLD(CLMRIN)
     D  VK_CLORED    E                     EXTFLD(CLORED)
     D  VK_CLLCD     E                     EXTFLD(CLLCD)
     D  VK_CLCHTP    E                     EXTFLD(CLCHTP)
     D  VK_CLTNLU    E                     EXTFLD(CLTNLU)
     D  VK_CLFRNT    E                     EXTFLD(CLFRNT)
     D  VK_CLAFRT    E                     EXTFLD(CLAFRT)
     D  VK_CLREPA    E                     EXTFLD(CLREPA)
     D  VK_CLTMES    E                     EXTFLD(CLTMES)
     D**CKREC****************401    469                                                       TDA067
     D**CKPAY****************544   1102                                                       TDA067
     D  CKREC                415    469                                                       TDA067
     D  CKPAY                558   1102                                                       TDA067
 
      * (Current) Customer Loans record CL in file Format
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L)
      * (Current) Customer Loans record CK in file Format
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K)
     D**CUREC****************401    469                                                       TDA067
     D**CUPAY****************544   1102                                                       TDA067
 
      * (Current) Rollover Instructions Screen Format
     D CrRoScnFmt    E DS                  EXTNAME(LELERIPD)
     D                                     PREFIX(@)
 
     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
      *** Rollover Instructions Work fields
 
     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
      * Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SCA_LCD       E                     EXTFLD(LCD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
 
     D ExtData       E DS                  EXTNAME(LELEEXPD)
      * LE Rollover Instructions Extra Data - File (D/B) format
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current
 
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current
 
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current
 
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format
     D**FLPAY******************1    559                                                       TDA067
     D  FLPAY                 21    565                                                       TDA067
 
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format
     D**FLREC******************1     69                                                       TDA067
     D  FLREC                 21     75                                                       TDA067
 
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
 
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
      * LE Extra Data - Classe 1 Data - File (D/B) format                                     CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
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
      **  are valid
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
 
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
 
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
     D Trans500        S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LELERIUPC')
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
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
 
     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D ACCYA           S              3    DIM(12)
 
      * Work field for CLE030 processing                                                      CLE030
     D W_RSTS          S                   LIKE(V_CLRSTS)                                     CLE030
                                                                                              CLE030
     D CSC022          S              1A   Inz                                               BUG2665
     D WSkipCommit     S              1A   Inz                                               BUG2665
     D WPtr            S              2S 0 Inz                                               BUG2665
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      /COPY WNCPYSRC,LELERIC002
 
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
 
      /COPY WNCPYSRC,LELERIC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     InfData500    InfData                                      CAP086
     C**********         MOVEL     Extdata500    Extdata                                      CAP086
     C                   MOVEL     ExtData500    ExtData                                      CAP086
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,LELERIC004
 
      *  Check if valid Customer Loans details exists
 
     C                   EXSR      ChkValLoan
      *
      *  If valid Loan det. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      *  Check if valid Loans exists for Midas Loans Number
 
     C                   EXSR      ChkValMiCl
      *
      *  If valid Loans does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid loans details file.
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,LELERIC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,LELERIC006
      *
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      *  Processing for Amends
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'R'                                            CLE030
     C                             OR DDACTN = 'X' and CLE030 = 'Y'                           CLE030
 
      /COPY WNCPYSRC,LELERIC007
 
      * For action code 'A'
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        GHSUBS <> *blank
     C     GHSUBS        scan      TranIn                                 99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif
     C                   endif
 
      ** If flag set above is true, do the data substituion subroutine.
      ** substution subroutine.
     C                   if        (RepPrim = 'Y' )
     C                   EXSR      TDtDtaSubs
     C                   endif
 
     C                   EXSR      SetupAmend
 
      /COPY WNCPYSRC,LELERIC008
 
     C                   EXSR      ValidateRo
 
      /COPY WNCPYSRC,LELERIC009
 
      *
      ****Validate*settlement*details*if*Discount*Loan*****************                     BUG10456
      ****or*a*multi-currency*rollover*********************************                     BUG10456
      ** Validate settlement details unconditionally                                        BUG10456
      *
     C*****WDisc         IFEQ      'Y'                                                      BUG10456
     C*****DDNCCY        ORNE      *BLANKS                                                  BUG10456
     C*****DDNCCYB       ORNE      *BLANKS                                                  BUG10456
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
     C**********         ENDIF                                                              BUG10456
      *
 
      /COPY WNCPYSRC,LELERIC010
 
     C                   EXSR      ValdateAmd
 
      /COPY WNCPYSRC,LELERIC011
 
      *  Processing for Authorisations
     C                   WHEN         DDACTN = 'X'
 
      *  Processing for Requires Release                                                      CLE030
     C                   WHEN         DDACTN = 'Q'                                            CLE030
                                                                                              CLE030
      /COPY WNCPYSRC,LELERIC012
 
     C                   ENDSL
      *
     C     Invalid       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,LELERIC013
 
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
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
 
      /COPY WNCPYSRC,LELERIC014
 
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,LELERIC015
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELERIC016
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValLoan - Routine to check if valid Loans details exist    *
      *                                                               *
      *****************************************************************
     C     ChkValLoan    BEGSR
 
      * Check for Loans on Valid file
     C     APFOTranID    CHAIN     LEVLERIL0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVLERIL0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx) = 'LEV9010'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiCl - Routine to check if valid Loans exists for       *
      *    Midas Loans reference                                      *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiCl    BEGSR
 
      ** Key list for file LEVLERIL1
     C     KCLIP1        KLIST
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
 
     C     DDLNRF        IFNE      *BLANKS
 
      * Check for Customer loans on Valid file
     C                   MOVE      DDLNRF        KLNRF
     C     KCLIP1        CHAIN     LEVLERIL1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KCLIP1        CHAIN     LEVLERIL1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx) = 'LEV9010'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              loans supplied                                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C     DDLNRF        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Customer loan in file format from the LE database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LELERIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Customer Loans Number
     C                   PARM                    DDLNRF
      *
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      *
      * OUTPUTS
      *
      * (Current) Customer loan CL in file format
     C                   PARM                    CrLnFilFmtCL
      *
      * (Current) Customer loan CK in file format
     C                   PARM                    CrLnFilFmtCK
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDLnrfOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      *
      **  Set up date of receipt for amend.
      **  and date of payment
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     V_CLRLDT      ##DATR                         new RLDT
     C                   Z-ADD     V_CLRLDT      ##DATP                         new RLDT
     C                   ENDIF
      *
      ** Allow rec/pay settlement details for multi-ccy rollover
      *
     C     MULTIC        IFEQ      *ON
     C     DDNCCY        ANDNE     *BLANKS
     C     MULTIC        OREQ      *ON
     C     DDNCCYB       ANDNE     *BLANKS
     C                   MOVE      'Y'           WPSET             1
     C     DDACTN        IFEQ      'A'
     C     WRLDT1        ANDNE     '*'
     C                   Z-ADD     V_CLRLDT      ##DATP                         new RLDT
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
     C                   Z-ADD     V_CLRRST      FLRSTM                                       TDA067
     C                   MOVEL     V_CLRRON      FLRONS                                       TDA067
     C                   MOVEL     CKREC         FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
     C                   ENDIF
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      67
     C                   Z-ADD     V_CLRPST      FLPSTM                                       TDA067
     C                   MOVEL     V_CLRPON      FLPONS                                       TDA067
     C                   MOVEL     CKPAY         FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Get receipt settlement from CLOANCK if not blank
      **  Else, get details from CLOANCL
      **  If all details in first screen has been '*'ed
      **  settlement details would be blanked out.
      *
     C     DDACTN        IFEQ      'A'
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
      *
     C     KRRST         IFNE      *ZERO
      *
      * Set up Receive Instructions from CLOANCK
      *
     C                   Z-ADD     V_CLRRST      FLRSTM                                       TDA067
     C                   MOVEL     V_CLRRON      FLRONS                                       TDA067
     C                   MOVEL     CKREC         FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Receive Instructions from CLOANCL
      *
     C                   Z-ADD     V_CLRSTM      FLRSTM                                       TDA067
     C                   MOVEL     V_CLRONS      FLRONS                                       TDA067
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     LOMDB         FLROBR
     C                   MOVEL     LSCCY         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLREXR                                       CLE031
     C                   MOVE      LREXI         FLREXI                                       CLE031
     C                   MOVE      LSCCY         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For multi-currency rollover, also allow for pay settle input
      ** Default coming from CLOANCK or CLOANCL
      *
     C     DDACTN        IFEQ      'A'
     C     WPSET         ANDEQ     'Y'
     C     DDACTN        OREQ      'A'
     C     LPTYP         ANDEQ     67
      *
     C     KRPST         IFNE      *ZERO
      *
      * Set up Pay Instructions from CLOANCK
      *
     C                   Z-ADD     V_CLRPST      FLPSTM                                       TDA067
     C                   MOVEL     V_CLRPON      FLPONS                                       TDA067
     C                   MOVEL     CKPAY         FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Pay Instructions from CLOANCL
      *
     C                   Z-ADD     V_CLPSTM      FLPSTM                                       TDA067
     C                   MOVEL     V_CLPONS      FLPONS                                       TDA067
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     LOMDB         FLPOBR
     C                   MOVEL     LCVMR         FLCVMR
     C                   MOVEL     LSCCY         FLPSCY
     C                   MOVEL     LICCY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLPEXR                                       CLE031
     C                   MOVE      LREXI         FLPEXI                                       CLE031
     C                   MOVE      LSCCY         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Fill Our Pay branch and Our Receive branch if blank
      *
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLRSTM        IFEQ      05
     C     KRLBR         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ENDIF
     C                   ENDIF
      *
     C     LPTYP         IFEQ      67
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLPSTM        IFEQ      05
     C     KRLSB         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ENDIF
     C                   ENDIF
      *
      **  If Rollover date is to be removed,
      **  or multi-currency details are to be removed
      **  settlement details must be removed also.
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     V_CLRLDT      ##DATR                         new RLDT
     C                   Z-ADD     V_CLRLDT      ##DATP                         new RLDT
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
      *
      * Remove Receive Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     63
     C     LPTYP         ANDNE     65
     C                   Z-ADD     *ZERO         FLRSTM                                       TDA067
     C                   MOVE      *BLANKS       FLRONS                                       TDA067
     C                   MOVE      *BLANKS       FLREC
     C                   MOVEL     *BLANKS       FLROBR
     C                   MOVEL     *BLANKS       FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   MOVE      *BLANKS       FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
      * Remove Pay Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     67
     C                   Z-ADD     *ZERO         FLPSTM                                       TDA067
     C                   MOVE      *BLANKS       FLPONS                                       TDA067
     C                   MOVE      *BLANKS       FLPAY
     C                   MOVEL     *BLANKS       FLPOBR
     C                   MOVEL     *BLANKS       FLCVMR
     C                   MOVEL     *BLANKS       FLPSCY
     C                   MOVEL     *BLANKS       FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   MOVE      *BLANKS       FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up other payment settlement details
      ** For parts sold, pay out in old ccy, receive in new ccy
      ** For the rest, receive in old ccy, pay out in new ccy
      *
     C     WPSET         IFEQ      'Y'
      *
     C     DDNCCYB       IFNE      *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      DDNCCYB       WNCCY             3
     C                   ELSE
     C                   MOVE      DDNCCY        WNCCY
     C                   ENDIF
      *
     C     WSOLD         IFEQ      'Y'
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
      *
     C                   ELSE
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##PCCY
     C                   MOVE      WNCCY         ##RCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up date of receipt and payment
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     V_CLRLDT      ##DATP                         new RLDT
     C     V_CLRLDT      IFEQ      *ZEROS                                       new RLDT
     C                   Z-ADD     LRLDT         ##DATP                         current RLDT
     C                   Z-ADD     LRLDT         ##DATR                         current RLDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
 
      *
      ***  Defaults settlement details for multi-ccy rollover
      *
     C     FLPSTM        IFEQ      *ZERO
     C     FLRSTM        ANDEQ     *ZERO
     C     WPSET         ANDEQ     'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     DDACTN        ANDEQ     'A'
      *
 
     C                   CALLB     'ZASETINDFT'
 
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Payment currency
     C                   PARM                    ##PCCY            3
      * Receive currency
     C                   PARM                    ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      * Transaction Type
     C                   PARM      LLTYP         ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If Payment or Recepit Instructions screen fields are blank
      * or have been removed
      * Then convert file fields to screen fields
      * (defaulted from CLOANCK, CLOANCL or by ZASETINDFT -or- removed)
      *
     C     InRecSttmt    IFEQ      *blank
     C     InPaySttmt    ANDEQ     *blank
     C     WNCCY1        OREQ      '*'
     C     WRLDT1        OREQ      '*'
 
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM      *BLANK        DBFRASttmt
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    ##RCCY                                      CSF011A
     C                   PARM                    ##PCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupAmend - Set up fields that are needed in the validation  *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) customer loan into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      CrLnFilFmtCL  ValidLoanL
     C                   MOVE      CrLnFilFmtCK  ValidLoanK
 
      * Do data substitution for Settlement Instructions
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      InPaySttmt                             99
     C  N99GHSUBS        scan      InRecSttmt                             99
     C     *in99         ifeq      *on
     C                   EXSR      SDtDtaSubs
     C                   endif
     C                   endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateRo - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateRo    BEGSR
 
      * Validate Rollover Instructions Details
 
      *
      *  First retrieve the current rollover fields using module CVT
      *  (needed for validation purpose)
 
     C                   CALLB     'LELERICVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      * Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      * Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE011
     C                   PARM                    S01465
     C                   PARM                    CLE005
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      * OUTPUTS
      *
      * Loan in screen format
     C                   PARM                    CrRoScnFmt
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
      *
      *  Check if Extended Settlements, Funding details and Mutli ccy
      *  Rollovers are required
      *
     C                   EXSR      @CHKLOAN
 
     C                   CALLB     'LELERIVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      * Rollover Instructions Details
     C                   PARM                    TranIn
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    @@FRNT           20
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR702532
      ** Action Code (Reject transaction)                                                   AR702532
      *                                                                                     AR702532
     C                   PARM      *BLANK        @ACTRV            1                        AR702532
      * OUTPUTS
 
      *
      * Rollover Instructions Details OK inds
     C                   PARM                    LERI_OK
 
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
 
      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidLoanL
 
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidLoanK
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
                                                                                             BUG2579
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
                                                                                              BUG827
      * Repayment Exist
     C                   PARM                    @WERLN
     C                   PARM                    @WLNNO
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
     C                   PARM                    WINCY
     C                   PARM                    WPSET
     C                   PARM                    WRLDT1            1
     C                   PARM                    WNCCY1            1
     C                   PARM                    MULTIC
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
     C                   PARM      *blank        @@CTU             1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
      *
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZASETINVAL'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Following parameters are output to called module
      * Calling function type
     C                   PARM                    ##CALP            4
      * Transaction Fields
      * Payment currency (or Loan currency if only one currency on Loan)
     C                   PARM                    ##PCCY            3
      * Receive currency (or Loan currency if only one currency on Loan)
     C                   PARM                    ##RCCY            3
      * Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      * Loan type
     C                   PARM      LLTYP         ##TTYP            2
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      * Booking Branch
     C                   PARM                    ##BRCA            3
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      * Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      * Following parameters are returned by called module
      * Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      * Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      * FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      * File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      * Extra Input
      * Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      * Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     FLPSTM        V_CLRPST                                     TDA067
     C                   MOVEL     FLPONS        V_CLRPON                                     TDA067
     C                   MOVEL     FLPAY         CKPAY
     C                   MOVEL     FLPOBR        V_CLRLSB
     C                   MOVEL     FLCVMR        V_CLRCVM
     C                   MOVEL     FLPSCY        V_CLRPSC
     C                   MOVEL     FLIC72        V_CLRICY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     FLRSTM        V_CLRRST                                     TDA067
     C                   MOVEL     FLRONS        V_CLRRON                                     TDA067
     C                   MOVEL     FLREC         CKREC
     C                   MOVEL     FLROBR        V_CLRLBR
     C                   MOVEL     FLRSCY        V_CLRRSC
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        V_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        V_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        V_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        V_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        V_CLRPSC                                     CLE031
     C                   ENDIF                                                                CLE031
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
     C                   CALLB     'LELERICVT'
      *
      * Inputs
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Customer loans - file formats
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      *
      * Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      *
      * Output parameters
      *
      * Rollover Instructions Details in screen format
     C                   PARM                    CrRoScnFmt
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranIn        IncDATA        2000
      * Current Data
     C                   PARM      CrRoScnFmt    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************
 
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InPaySttmt    IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       InPaySttmt
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       InRecSttmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend.
 
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
     C                   CALLB     'LELERICVT'
      *
      * Inputs
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Customer loans - file formats
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      *
      * Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      *
      * Output parameters
      *
      * Rollover Instructions Details in screen format
     C                   PARM                    CrRoScnFmt
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
      *
      ** AMEND CHECKING
      *
     C                   CALLB     'LELERIAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Rollover Instructions Details :
     C                   PARM                    TranIn
      *
      * (Current) Rollover Instr in Screen Format :
     C                   PARM                    CrRoScnFmt
      *
      * (Current) Loan in file format:
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    LERI_OK
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
     C                   GOTO      EndAmend
     C                   ENDIF
 
     C     EndAmend      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Customer loans status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
†††††
††††† ** +--- Note for a later release -------------------------------+
††††† ** ¶                                                            ¶
††††† ** ¶ At a later date this routine will have to cater for        ¶
††††† ** ¶ warning messages.  The following logic will have to be     ¶
††††† ** ¶ inserted before "If no errors were found", in the          ¶
††††† ** ¶ above comments (and the code):                             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† ** ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ -†††If errors exist                                        ¶
††††† ** ¶†††††-†††††Add the warning array index to the error array   ¶
††††† ** ¶†††††††††††index                                            ¶
††††† ** ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† ** ¶†††††††††††end of the error arrays                          ¶
††††† ** ¶ -†††Else                                                   ¶
††††† ** ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† ** ¶†††††††††††array index                                      ¶
††††† ** ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† ** ¶†††††††††††error arrays                                     ¶
††††† ** ¶ -†††Endif                                                  ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Endif                                                      ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† ** ¶ can probably be implemented unconditionally (ie the same   ¶
††††† ** ¶ logic will apply whether errors exist as well as warnings  ¶
††††† ** ¶ or not).  It is shown in the above form for clarity.       ¶
††††† ** ¶                                                            ¶
††††† ** +------------------------------------------------------------+
 
 
     C                   IF        Idx = 0
 
     C                   EXSR      SetupValid
     C                   WRITE     LEVCLILD0
      ** Setup fields which are common to both files but with a different content
     C                   EVAL      V_CLRCDT = VK_CLRCDT
     C                   EVAL      V_CLMRIN = VK_CLMRIN
     C                   WRITE     LEVCLIKD0
 
     C                   EXSR      CallMsgHdl
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Rollover Instructions support log
 
     C                   CALLB     'LELERILOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    TranIn
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LELERI'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     V_CLFRNT      APFOTRANID
     C                   MOVEL     V_CLLNRF      PDealNo
     C                   MOVEL     *BLANKS       PADealNo
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      @RTCD    = '*ERROR'
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SetupInVal
      *
      * Only write to Invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
     C                   WRITE     LEILERID0
     C                   WRITE     APIDSETD0
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranIn +
     C                                        InRecSttmt +
     C                                        InPaySttmt
 
     C                   EVAL      APTGTTYPE  = 'LELERI'
     C                   MOVEL     DDLNRF        PDealNo
     C                   MOVEL     *BLANKS       PADealNo
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
      ** Database error
 
     C                   IF        RetCodeOut <> *BLanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNo
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
      **  COMMIT data if either of the following is true:                                    BUG2665
      **    1. Commitment Control Changes switch is OFF; or                                  BUG2665
      **    2. Commitment Control Changes switch is ON and                                   BUG2665
      **       this particular job is not included in the                                    BUG2665
      **       commitment jobs in data area SCCMTJOB                                         BUG2665
                                                                                             BUG2665
     C                   If        CSC022  = 'N' or                                          BUG2665
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                      BUG2665
     C                   COMMIT
     C                   EndIf                                                               BUG2665
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetCycle- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     ResetCycle    BEGSR
 
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
 
     C                   RESET                   AmendOK
 
     C                   CLEAR                   CrRoScnFmt
 
     C                   MOVE      *ALL'Y'       LERI_OK
 
     C                   CLEAR                   ValidLoanL
     C                   CLEAR                   ValidLoanK
 
     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS
 
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupInVal - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SetupInVal    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'LELERI'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                              CAP086
      * Setup the Automatic Autorisation Flag                                                 CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH     = IF_AUTH                                       CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LELERIC017
 
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
                                                                                              CLE030
      * If CLE030 and action code is Authorise then set work loan                             CLE030
      * status to be same as valid file.                                                      CLE030
     C                   IF        DDACTN = 'X' AND CLE030 = 'Y'                              CLE030
     C                   EVAL      W_RSTS = V_CLRSTS                                          CLE030
     C                   ENDIF                                                                CLE030
 
 
      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C**********         MOVEL     DBPaySttmt    CKPAY                                        TDA067
     C                   MOVEL     FLPAY         CKPAY                                        TDA067
     C                   Z-ADD     FLPSTM        V_CLRPST                                     TDA067
     C                   MOVEL     FLPONS        V_CLRPON                                     TDA067
     C                   MOVE      FLPOBR        V_CLRLSB
     C                   MOVE      FLCVMR        V_CLRCVM
     C                   MOVE      FLPSCY        V_CLRPSC
     C                   MOVE      FLIC72        V_CLRICY
     C**********         MOVEL     DBRecSttmt    CKREC                                        TDA067
     C                   MOVEL     FLREC         CKREC                                        TDA067
     C                   Z-ADD     FLRSTM        V_CLRRST                                     TDA067
     C                   MOVEL     FLRONS        V_CLRRON                                     TDA067
     C                   MOVE      FLROBR        V_CLRLBR
     C                   MOVE      FLRSCY        V_CLRRSC
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        V_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        V_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        V_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        V_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        V_CLRPSC                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
 
      * For Deletes & Authorises, put the complete (pre-existing) loan
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                             OR DDACTN = 'Q'                                            CLE030
     C                             AND CLE030 = 'Y'                                           CLE030
     C                   MOVE      CrLnFilFmtCL  ValidLoanL
     C                   MOVE      CrLnFilFmtCK  ValidLoanK
     C                   ENDIF
 
      * If CLE030 and action code is Authorise then set Loan status                           CLE030
      * field from valid file back to work field value.                                       CLE030
     C                   IF        DDACTN = 'X' AND CLE030 = 'Y'                              CLE030
     C                   EVAL      V_CLRSTS = W_RSTS                                          CLE030
     C                   ENDIF                                                                CLE030
                                                                                              CLE030
      * Set Valid file field(s) that are needed for all Action Codes
 
      *  CHTP A for amend or authorisation
     C                   EVAL      V_CLCHTP = 'A'
     C                   EVAL      VK_CLCHTP = 'A'
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_CLFRNT = APFOTranID
     C                   EVAL      V_CLREPA = APRprLocn
     C                   EVAL      V_CLTMES = TimeStamp
 
     C                   EVAL      VK_CLRECI = V_CLRECI
     C                   EVAL      VK_CLLNRF = V_CLLNRF
     C                   EVAL      VK_CLORED = V_CLORED
     C                   EVAL      VK_CLLCD  = V_CLLCD
     C                   EVAL      VK_CLTNLU = V_CLTNLU
     C                   EVAL      VK_CLAFRT = V_CLAFRT
     C                   EVAL      VK_CLFRNT = APFOTranID
     C                   EVAL      VK_CLREPA = APRprLocn
     C                   EVAL      VK_CLTMES = TimeStamp
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_CLAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LELERIC018
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
 
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
 
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVEL     DDLNRF        PTranID          20
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Loan repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * @CHKLOAN - Check if Extended Settlements, Funding details and
      *            Mutli ccy Rollovers are required
      *****************************************************************
     C     @CHKLOAN      BEGSR
      *
     C                   MOVE      ' '           @FUNDING
     C                   MOVE      ' '           @MULTI                                       BUG827
     C                   MOVE      ' '           WSett                                        BUG827
     C                   MOVE      ' '           @FCXRATE                                    BUG2579
      *
      **  Enable display of Funding Details if Analytical Accounting
      **  module is switched on and loan is directly funded.
      **  or enable display of Funding Details if Revenue Analysis
      **  is switched on.
      *
     C     BGN0ST        IFEQ      'Y'
     C     LFPRC         ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
      *
     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C     LPTYP         OREQ      61
     C     LPTYP         OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @FUNDING
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      **  Enable Extended Settlement Details for Discount Loan.
      **  and discounted parts purchased or sold
      *
     C                   MOVE      *BLANKS       WDisc             1
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WDisc
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WSOLD             1
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
      *
      **  Get facility details.
      *
     C     WFCLT         CHAIN     LEFCLTL0                           85
      *
      **  Enable New currency, New currency amount, Exchange rate,
      **  Exchange rate indicator, Next loan currency repayment
      **  amount will be displayed if Customer Lending Enhancement
      **  Syndications feature is switched on and if it is a
      **  Multi-currency rollover or if EMU Lending Multi currency
      **  rollover feauture is switched on and if loan currency is
      **  an 'In' currency
      *
     C     CEU020        IFEQ      'Y'
     C                   MOVE      LCCY          @CURR
     C                   Z-ADD     61            DBASE
     C                   EXSR      SRCurrDet
     C                   ENDIF
      *
     C     LMCRA         IFEQ      'Y'
     C     CEU020        IFEQ      'Y'
     C                   MOVE      A6INCY        WINCY             1
     C                   Z-ADD     A6TPSD        WTPSD             5 0
     C                   Z-ADD     A6SPRT        WASPRT           13 8
     C                   ENDIF
     C                   MOVE      'Y'           @MULTI
      *
      **  Determine if multi-currency rollover
      **  can be processed.
      **  If Multi Ccy Rollovers, enable the Settlements Screen
     C                   EXSR      SRMCCY
      *
     C     MULTIC        IFEQ      *ON
     C                   MOVEA     F_ALCY        ACCYA
     C     DDACTN        IFEQ      'A'
     C     KNCCY         ORNE      *BLANKS
     C     CEU020        IFEQ      'Y'
     C     KNCCY         ORNE      *BLANKS
     C                   MOVE      'Y'           WSett
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              BUG827
      ** Determine if New Forward Yield is required                                           BUG827
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C     LPTYP         ANDNE     70                                                         BUG827
     C     LPTYP         ANDNE     71                                                         BUG827
     C     LPTYP         ANDNE     72                                                         BUG827
     C                   MOVE      'Y'           @FYIELD                                      BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           @FYIELD                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if New Facility Exchange Rate is required                                 BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     F_MCCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'Y'           @FCXRATE                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           @FCXRATE                                    BUG2579
     C                   ENDIF                                                               BUG2579
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMCCY  -  Check if Mutli-currency rollover is allowed.       *
      *****************************************************************
     C     SRMCCY        BEGSR
      *
     C                   MOVE      *OFF          MULTIC            1
     C                   MOVE      'N'           @WERLN
      *
      **  Multi-currency rollover processing are allowed
      **  if there are no past due payments outstanding.
      **  and no future-dated loan amendments (except for repay sched)
      *
      **  Access loan amendments file.
      *
     C**********         Z-ADD     LLNRF         ALNRF                                        CLE148
     C                   MOVEL     LLNRF         ALNRF                                        CLE148
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
      *
      **  Check if past due exists.
     C                   MOVE      *ON           WLOGIC            1
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     LLNRF         ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     LLNRF
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C     CLE014        ANDEQ     'N'
     C                   MOVE      *OFF          WLOGIC
      *
      ** If CEU020 is installed, future dated loan amendments will be
      ** allowed if amendment currency is equal to Euro ccy
      *
     C     CEU020        IFEQ      'Y'
     C     A_CCY         ANDEQ     BKEURO
     C                   MOVE      *ON           WLOGIC
     C                   ENDIF
      *
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
     C                   ENDIF
      *
      ** If parts sold, check if original loan has no past due
      ** payments or future dated loan amendments except for 'RE'.
      *
     C**********         Z-ADD     LLNRF         WWLNRF            6 0                        CLE148
     C                   MOVEL     LLNRF         WWLNRF            6                          CLE148
      *
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C     LPTYP         OREQ      69
     C     LPTYP         OREQ      72
      *
     C                   MOVE      LOLNO         ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****LOLNO         ANDEQ     A_LNRF                                                     CSD027
     C     ALNRF         ANDEQ     A_LNRF                                                     CSD027
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****A_LNRF        ANDEQ     LOLNO                                                      CSD027
     C     A_LNRF        ANDEQ     ALNRF                                                      CSD027
     C     @WERLN        ANDEQ     'N'
      *
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
      *
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
     C                   MOVE      LOLNO         WOLNO
      *
      ** Multi-ccy rollover allowed indicator of original loan must
      ** be 'Y'.
      *
     C                   MOVE      'A'           WRCDT
     C                   MOVE      LOLNO         WLNRF
     C     WLOAN         CHAIN     CLOAN                              85
     C     *IN85         IFEQ      *OFF
     C     LO_MCRA       ANDEQ     'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      LO_LNRF       @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
      *
     C                   ELSE
     C**********         MOVE      LLNRF         WOLNO             6 0                        CLE148
     C                   MOVE      LLNRF         WOLNO             6                          CLE148
     C                   ENDIF
      *
      ** Check if all the related parts sold has no past due payments
      ** or future dated loan amendments except for 'RE'.
      *
     C*****WOLNO         SETLL     PSOLDFF                                                    CSD027
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C**********         EVAL      OLNONum = WOLNO                                     CSD027 CLE148
     C*****OLNOALpha     SETLL     PSOLDFF                                             CSD027 CLE148
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         SETLL     PSOLDFF                                                    CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
      *
     C     *IN85         DOWEQ     '0'
     C     @WERLN        ANDEQ     'N'
      *
     C     P_LNRF        IFNE      WWLNRF
     C                   MOVE      P_LNRF        ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     P_LNRF        ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN            1
     C***********        MOVE      A_LNRF        @WLNNO            6 0                        WA0027
     C                   MOVE      A_LNRF        @WLNNO            6                          WA0027
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     P_LNRF
     C     @WERLN        ANDEQ     'N'
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multi-ccy rollover allowed indicator must be 'Y' for all of
      ** the related loan
      *
     C     P_MCRA        IFEQ      'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      P_LNRF        @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
     C                   ENDDO
      *
     C                   MOVE      WLOGIC        MULTIC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
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
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans500
     C                   PARM                    InfData500                                   CAP086
      * Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    ExtData500
      * Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      *
      **  Key list for LEFCLTL0
      *
     C     WFCLT         KLIST
     C                   KFLD                    LFCUS
     C                   KFLD                    LFTYP
     C                   KFLD                    LFSEQ
      *
      **  Key list for LELOAML0
      *
     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0
      *
      **  Key list for CLOAN
      *
     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
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
      **  Retrieve general ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     903           DBASE                          * DBERR 903*
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine if Lending Enhancements for BHF-London is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      PSARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C     @RTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     904           DBASE                          * DBERR 904*
     C                   MOVEL     'CLE014'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if EMU Lending Multi Currency Rollover - CEU020
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU020'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU020            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU020
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Authorisation
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE002
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 906*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Backvaluations
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 907*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Others
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE005
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 908*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if BLI Lending Enhancements feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01465'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01465            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           S01465
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 909*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Rollover rate fixing day enhancement - CLE011
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE011'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE011            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE011
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '910'         DBASE                          * DBERR 910*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                             BUG2579
      ** Check if Lending Facility History Improvements - CLE023                             BUG2579
      ** feature is installed                                                                BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       @RTCD                                       BUG2579
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2579
     C                   PARM      'CLE023'      @SARD                                       BUG2579
     C                   PARM                    DSFDY                                       BUG2579
     C     @RTCD         IFEQ      *BLANK                                                    BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C     @RTCD         IFEQ      '*NRF'                                                    BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ELSE                                                                BUG2579
                                                                                             BUG2579
      ** Database error                                                                      BUG2579
                                                                                             BUG2579
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************ BUG2579
     C                   MOVEL     '914'         DBASE                          * DBERR 914* BUG2579
     C                   MOVEL     @OPTN         DBKEY                          ************ BUG2579
     C                   EXSR      *PSSR                                                     BUG2579
     C                   END                                                                 BUG2579
     C                   END                                                                 BUG2579
 
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
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 911
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
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
     C                   MOVEL     '912'         DBASE                          * DBERR 005 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
      *                                                                                       CLE030
      ** Initialize SAR work flag and Commit flag                                            BUG2665
                                                                                             BUG2665
     C                   Eval      CSC022      = 'N'                                         BUG2665
     C                   Eval      WSkipCommit = ' '                                         BUG2665
                                                                                             BUG2665
      ** Determine if Commitment Control Changes for MidasPlus                               BUG2665
      ** (CSC022) is installed                                                               BUG2665
                                                                                             BUG2665
     C                   Call      'AOSARDR0'                                                BUG2665
     C                   Parm      *BLANKS       @RTCD                                       BUG2665
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2665
     C                   Parm      'CSC022'      PSARD                                       BUG2665
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2665
                                                                                             BUG2665
      ** If feature is on, set up SAR work flag                                              BUG2665
                                                                                             BUG2665
     C                   If        @RTCD = *Blanks                                           BUG2665
     C                   Eval      CSC022      = 'Y'                                         BUG2665
     C                   Eval      WSkipCommit = 'N'                                         BUG2665
     C                   In        SCCMTJOB                                                  BUG2665
                                                                                             BUG2665
     C                   If        COMITNO  <> 0                                             BUG2665
     C                   MoveA     COMITJOBS     WArrCmtJob                                  BUG2665
                                                                                             BUG2665
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                      BUG2665
     C                   If        WPtr > 0                                                  BUG2665
     C                   Eval      WSkipCommit = 'Y'                                         BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
      ** else, database error (return code other than *NRF)                                  BUG2665
                                                                                             BUG2665
     C                   Else                                                                BUG2665
                                                                                             BUG2665
     C                   If        @RTCD <> '*NRF   '                                        BUG2665
     C     *Lock         In        LDA                                                       BUG2665
     C                   MoveL     'LELERICTL'   DBPGM                                       BUG2665
     C                   MoveL     'SCSARDPD'    DBFILE                                      BUG2665
     C                   MoveL     'CSC022'      DBKEY                          *************BUG2665
     C                   Z-Add     913           DBASE                          * DBASE 913 *BUG2665
     C                   Out       LDA                                          *************BUG2665
     C                   ExSR      *PSSR                                                     BUG2665
     C                   EndIf                                                               BUG2665
      *                                                                                      BUG2665
     C                   EndIf                                                               BUG2665
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 915                                                CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      **                                                                                     BUG2665
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APLERIDTQ'
 
     C                   EVAL      @RTCD = *BLANKS
 
 
      /COPY WNCPYSRC,LELERIC019
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
