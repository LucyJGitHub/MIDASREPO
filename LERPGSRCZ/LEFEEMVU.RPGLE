     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Validate and Update wrapper')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMVU - LE Fee Validate/Update Wrapper                    *
      *                                                               *
      *  Function: This Program Validates LE Fees Details for         *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Fees details fields               *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Fee and bypass the rest             *
      *              of the validation                                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD050688           Date 26Aug20               *
      *  Prev Amend No. AR375891B          Date 26Aug20               *
      *                 AR375892           Date 26Aug20               *
      *                 MD052696           Date 04Apr19               *
      *                 MD031692           Date 12Mar20               *
      *                 MD030856           Date 06Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 CLE071             Date 18Jul18               *
      *                 CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 AR1096655          Date 20Mar13               *
      *                 AR1072399A         Date 22Feb13               *
      *                 AR693137           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR859320           Date 18Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 AR674765           Date 17Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21889A          Date 06Feb09               *
      *                 BUG21889           Date 14Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246239             Date 13Mar07               *
      *                 245102             Date 19Jan07               *
      *                 244479             Date 20Dec06               *
      *                 244236             Date 05Dec06               *
      *                 248566             Date 06Jul07               *
      *                 CAS019             Date 20Apr07               *
      *                 244636             Date 30Mar07               *
      *                 245099             Date 30Mar07               *
      *                 242377             Date 30Mar07               *
      *                 BUG13127           Date 23Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243154             Date 23Oct06               *
      *                 240070             Date 26May06               *
      *                 240056             Date 25May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10976           Date 30Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9426            Date 05Dec05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 BUG8086            Date 03Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3760            Date 30Jul04               *
      *                 CAP084             Date 30Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050688 - Align PRcvParm length with PF/SDESSRPD            *
      *           - If the fee is attached to a non-Part Sold loan    *
      *             clear the Payment Settlement details.             *
      *  AR375891B - Amendment to Settlement details do not reflect   *
      *              on file. Ensure protect indicator set correctly. *
      *              (Child: AR375892)                                *
      *  AR375892 - Incorrect projection for fees attached to parts   *
      *             sold loan. Use Payment Settlement instead of      *
      *             Receipt Settlement.                               *
      *  MD052696 - Unauthorised Loans and fees not visible in WIP,   *
      *             after rejecting amendments to their maturity dates*
      *  MD031692 - Incorrect accrual when fee rate is changed on     *
      *             payment date. Add warning message parameters in   *
      *             LEFEEMAMD.                                        *      
      *  MD030856 - Introduced reject processing to FEEM              *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  CLE168 - Allow Debit of Blocked Account                      *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR1096655 - Revalidate settlement details on authorise to    *
      *              ensure they are not overwritten                  *
      *  AR1072399A - Skip settlement instruction validation when     *
      *               receipt and payment dates are not setup.        *
      *  AR693137 - Loan receipt settlement details are defaulted to  *
      *             loan fee when fee settlement is ' '. Move fix     *
      *             244636 before fee settlement details are validated*
      *             (Child: AR693138)                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR016: Settlement Allocation                      *
      *          - AR859320 fix was deleted                           *
      *  AR859320 - Display CN fields even with business error        *
      *             encountered related to the input field.           *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  AR674765 - Remove settlement instruction when settlement tab *
      *             will not be displayed                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG21889A - Fee confirmation page showing details of the pay *
      *             settlement method                                 *
      *  BUG21889 - Fee confirmation page showing details of the pay  *
      *             settlement method.                                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246239 - Minor errors in fee maintenance                     *
      *  245102 - Pass runday with 5,0 length to avoid decimal data   *
      *           error in LEFEEMUPD. Catered by 13127.               *
      *  244479 - Applied MP1.2T core fix 243154A (244236 Duplicate)  *
      *  244236 - Remove part of 243154 causing decimal data error.   *
      *           Catered by 13127.
      *  248566 - Unable to input facility fee (Recompile)            *
      *  CAS019 - Upgrade of CAS016 to Midas Plus (Recompile)         *
      *  244636 - If no settlement details for fees are entered       *
      *           then default settlement details from related loan   *
      *  245099 - Pass CLE006 to LEFEEMAND                            *
      *  242377 - When System Values for LoanCustOriginPurch = 'O',   *
      *           customer for fee that should be displayed should be *
      *           the original borrower for participations purchased. *
      *  BUG13127 - Parameter mismatch. Applied fix for 243154A.      *
      *  243154 - FCOOB in LER140 due to incorrect LCHD               *
      *  240070 - Don't execute ZASETINCVT if there is an error.      *
      *  240056 - Set pay/rec CCY to be the same where only one       *
      *           side of settlement can be entered                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10976 - Add hidden facility fields.(Recompile)            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9426 - A Serious Midas error has occurred upon Authorise  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager. UTN was passed from Java.     *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  BUG8086- LEFEEMAMD should be called before LEFEEMVAL         *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  CAP084 - Midas Plus API development                          *
      *         - Added the 10-digit account code CGL029.             *
      *           Added Commitment Control Changes for MidasPlus.     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       CLE168
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)                 CLE168
     F                                     PREFIX(ZA)                                         CLE168
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE168
     F                                     PREFIX(C_)                                         CLE168
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

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      ** Array for job name
     D ARRJBNAM        S             10A   DIM(10)

     D HeadIn        E DS                  EXTNAME(APHEADPD)
      ** Incoming Header

     D TranInFEEM    E DS                  EXTNAME(LEFEEMPD)
      ** Incoming Transaction

     D TranInFEEM2   E DS                  EXTNAME(LEFEEM2PD)
      ** Incoming Work Transaction

     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@)
      ** (Current) Fee in Screen Format
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** Interface Data Format Definition File format                                         CAP086

     D ExtData       E DS                  EXTNAME(LEFEEXPD)
      ** Extra Data - File (D/B) format

     D ValidFEEM     E DS                  EXTNAME(LEVFEEMPD)
     D QQOURS1       E                     EXTFLD(QQOURS)
      ** Valid Fee layout
     D  VFREC                308    362
     D  VFPAY                377    921
     D  VFRECx              1076   1093
     D  VFPAYx              1094   1111

     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(FE_)
      ** (Current) Fee record in file Format
     D  FeemFilREC           308    362
     D  FeemFilPAY           377    921
     D  FeemFilRECx         1076   1093
     D  FeemFilPAYx         1094   1111

     D LEFCLY        E DS                  EXTNAME(LEFCLYPP) DTAARA                           CLE168
     D                                     PREFIX(A_)                                         CLE168

     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
      ** Customer Loans record CL in file Format

     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
      ** Facility record FM in file Format

     D Trans5001       S            500A
     D Trans5002       S            500A
      ** Fields (500A) to receive the incoming transaction
                                                                                              CAP086
     D InfData500      S            500A                                                      CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086

     D ExtData500      S            500A
      ** Field (500A) to receive the incoming Extra Data

     D StmpTax500      S            500A                                                      CER049
      ** Field (500A) to receive the incoming Stamp Tax                                       CER049
                                                                                              CER049
     D TranInStamp   E DS                  EXTNAME(LESTMPPD)                                  CER049
      ** File Stamp Tax                                                                       CER049
                                                                                              CER049
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** FEEM Reject Flag                                                                   MD030856
     D DRejFlg         S              1A                                                    MD030856
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** File Receive Instructions
     D  FLREC                 21     75

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ** File Payment Instructions
     D  FLPAY                 21    565

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File FRA/IRS Instructions

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen Receive Instructions

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen Payment Instructions

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** Screen FRA/IRS Instructions

     D OkTrFEEM      E DS                  EXTNAME(LEEFEEMPD)
      ** Error indicators

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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for MIDAS modules details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger

     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** External DS for Customer Loans ICD

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
      *

     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)
      ** Midas SC Jobs handling commitment control data area
     D  COMITNOM               1      3S 0
     D  COMITJOB               4    103
      *

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure

     D                 DS                                                                     242377
     D  WPARM                  1     20                                                       242377
     D  WPARM1                 1      5                                                       242377
     D  WPARM2                 6     10                                                       242377
     D  WPARM3                11     15                                                       242377
     D  WPARM4                16     20                                                       242377
      *                                                                                       242377
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

      ** +--------------------------------------+
      **   Use of Indicator                      
      **   ================                      
      ** ¶                                      ¶
      ** ¶ 17      Used by LOOKUP               ¶
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Index for arrays of error message ids etc
     D Ix              S              3P 0

      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D CLE106          S              1A   INZ('N')                                           CLE106
     D CSC011          S              1A   INZ('N')
     D WrkDftSettl     S              1A
     D FeeBranch       S              3A

     D CSC022          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
      ** Counter variable
     D WCMT01          S              1A
      ** Commitment Flag

      ** Parameter for LEFEEMRTV                                                              244636
     D*PRcvParm*       S             92                                               244636 CSF011A
     D*PRcvParm*       S            320                                             CSF011A MD050688
     D PRcvParm        S            545                                                     MD050688
                                                                                              244636
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
     D PPayParm        S           1045                                                     AR375892
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

      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.

     C                   MOVEL     Trans5001     TranInFEEM
     C                   MOVEL     Trans5002     TranInFEEM2
     C                   MOVEL     StmpTax500    TranInStamp                                  CER049
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Extdata500    Extdata

      ** Reset variables gradually updated

     C                   EXSR      RESETCYCLE

     C     CLE106        IFEQ      'Y'                                                        CLE106
     C     DDFACT        IFEQ      '000'                                                      CLE106
     C     DDFCNO        ANDEQ     '  '                                                       CLE106
     C     DDFACT        OREQ      '000'                                                      CLE106
     C     DDFCNO        ANDEQ     '00'                                                       CLE106
     C                   EVAL      DDFACT = *BLANKS                                           CLE106
     C                   EVAL      DDFCNO = *BLANKS                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      ** Validate Action Code (call RTV module)

     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input
      ** Allow further validation when action code is INSERT

     C     Idx           IFNE      0
     C     DDACTN        ANDNE     'I'
     C                   GOTO      INVALID
     C                   END

      ** Processing depends upon Action Code

     C                   SELECT

      ** Processing for Inserts

     C                   WHEN      DDACTN = 'I'
                                                                                            AR693137
      ** Default settlement details from related loan                                       AR693137
      ** Use Pay Settlement if attached to parts sold                                       AR375892
      *                                                                                     AR375892
     C                   IF        CL_PTYP <> 66                                            AR375892
     C                             AND CL_PTYP <> 67                                        AR375892
     C                             AND CL_PTYP <> 69                                        AR375892
     C                             AND CL_PTYP <> 72                                        AR375892
                                                                                            AR693137
     C                   IF        ##RECS = *blank AND                                      AR693137
     C                             PRcvParm <> *blank                                       AR693137
     C                   MOVEL     PRcvParm      ##RECS                                     AR693137
     C                   ENDIF                                                              AR693137
      *                                                                                     AR375892
     C                   ELSE                                                               AR375892
      *                                                                                     AR375892
     C                   IF        ##PAYS = *blank AND                                      AR375892
     C                             PPayParm <> *blank                                       AR375892
     C                   MOVEL     PPayParm      ##PAYS                                     AR375892
     C                   ENDIF                                                              AR375892
     C                   ENDIF                                                              AR375892
      *                                                                                     AR375892
     C                   EXSR      ValidateTr
     C                   EVAL      WrkDftSettl = 'Y'
      *****************************************************************              244636 AR693137
      ***Default*settlement*details*from*related*loan******************              244636 AR693137
      *****************************************************************              244636 AR693137
     C**********         IF        ##RECS = *blank AND                               244636 AR693137
     C**********                   PRcvParm <> *blank                                244636 AR693137
     C**********         MOVEL     PRcvParm      ##RECS                              244636 AR693137
     C**********         ENDIF                                                       244636 AR693137
     C                   EXSR      ChkSettmts
     C                   EXSR      ValidateSt

      ** Processing for Amend

     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd                                                BUG8086
     C                   EXSR      ValidateTr
     C                   EVAL      WrkDftSettl = 'N'
     C                   EXSR      ChkSettmts
     C                   EXSR      ValidateSt
     C**********         EXSR      ValdateAmd                                                BUG8086

      ** Processing for Authorise

     C                   WHEN      DDACTN = 'X'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
     C                   EVAL      WrkDftSettl = 'N'
     C                   EXSR      ChkSettmts
     C*                  EXSR      ValidateSt                                              AR1096655
                                                                                              243154
      ** Processing for deletions                                                             243154
     C                   WHEN      DDACTN = 'D'                                               243154
     C                   Eval      FE_FELCHD = WRNDAY                                         243154
     C                   ENDSL

     C     INVALID       TAG

     C     ReturnCode    IFNE      *BLANK
     C                   Eval      Idx = Idx + 1
     C                   Eval      Ix = Idx
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0035'     MsgIDArr(Ix)
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF
                                                                                              CSF011
     C                   EXSR      SrCustName                                                 CSF011

      **  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SETUPVALID
     C                   EXSR      WriteToDB
     C                   ENDIF

      **  Remerge buffer with all relevant data structures

     C                   EVAL      Buffer = TranInFEEM + TranInFEEM2
     C**********                            + ##RECS + ##PAYS + ExtData                       CAP086
     C                                      + TranInStamp                                     CER049
     C                                      + ##RECS + ##PAYS + InfData                       CAP086
     C                                      + ExtData                                         CAP086
     C                                      + DRejFlg                                       MD030856
     C                   MOVE      '1'           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAc - Routine to validate action code versus the      *
      *               Fee supplied                                    *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

     C                   CALLB     'LEFEEMRTV'

      ** INPUTS
      ** Return code
     C                   PARM                    ReturnCode

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6

      ** Response mode
      ** Action Code
     C                   PARM      'S'           APRespMode        1
     C                   PARM                    DDACTN            1

      ** Front Office Transaction ID
      ** Front Office User
     C                   PARM                    APFOTranID       20
     C                   PARM                    APFOTranUs       16

      ** (Midas) Facility Reference Number
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDLNRF
     C                   PARM                    DDFSEQ

      ** CSC011 processing date
     C                   PARM                    WRNDAY

      ** OUTPUTS
      ** (Current) Fee in file format
      ** Loan CL in file format
      ** Facility FM in file format
     C                   PARM                    CrFeFilFmt
     C                   PARM                    ClilFilFmt
     C                   PARM                    FacmFilFmt

      ** OK - Action code
      ** OK - Customer Number
      ** OK - Facility type
      ** OK - Facility sub type
      ** OK - Loan reference
      ** OK - Fee sequance
     C                   PARM                    OKACTN            1
     C                   PARM                    OKCSSN            1
     C                   PARM                    OKFACT            1
     C                   PARM                    OKFCNO            1
     C                   PARM                    OKLNRF            1
     C                   PARM                    OKFSEQ            1

      ** Fee against a syndicated facility/loan
      ** Expiry date
      ** Facility amount
     C                   PARM                    WSYND             1
     C                   PARM                    WDTEX             5 0
     C                   PARM                    WFAMT            13 0

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     244636
     C                   PARM                    PPayParm                                   AR375892

     C                   Z-ADD     FE_FETNLU     H#TNLU

      ** Check if all key fields are valid

     C     OKACTN        IFEQ      'Y'
     C     OKCSSN        ANDEQ     'Y'
     C     OKFACT        ANDEQ     'Y'
     C     OKFCNO        ANDEQ     'Y'
     C     OKLNRF        ANDEQ     'Y'
     C     OKFSEQ        ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK           1
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr - Routine to validate the main transaction        *
      *               details                                         *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR

     C                   IF        CLE106 = 'Y'                                               CLE106
     C**********                   Or DDEUTN <> *Blanks                               CLE106 CSF011A
     C                   EVAL      F3TNRF = DDEUTN                                            CLE106
     C                   EVAL      VFSYIN = DDSYIN                                            CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LEFEEMVAL'
      ** INPUTS
      ** Response mode
      ** Mode
     C                   PARM      'S'           APRespMode
     C                   PARM                    ModeofOp

      ** Fee Details
     C                   PARM                    TranInFEEM

      ** Fee Details - Settlement instructions
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS

      ** Fee File format
     C                   PARM                    CrFeFilFmt

      ** Front Office Transaction ID
     C                   PARM                    APFOTranID

      ** Loan CL in file format
      ** Facility FM in file format
     C                   PARM                    ClilFilFmt
     C                   PARM                    FacmFilFmt

      ** Fee against a syndicated facility/loan
      ** Participant Fee indicator
      ** Expiry date
      ** Facility amount
     C                   PARM                    WSYND
     C                   PARM                    WPTFI
     C                   PARM                    WDTEX
     C                   PARM                    WFAMT

      ** Features
     C                   PARM                    CLE006
     C                   PARM                    CEU004

      ** Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8

      ** Customer Extra Data file data
     C                   PARM                    ExtData

      ** OUTPUTS
      ** Fee Details OK inds
     C                   PARM                    OkTrFEEM

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
                                                                                            MD052696
     C                   PARM                    DRejFlg                                    MD052696

      ** If Syndications Manager is off, override UTN with PC Ref value                      CSF011A
                                                                                             CSF011A
     C                   IF        CLE106 <> 'Y'                                             CSF011A
     C                   IF        UpdateYN = 'Y'                                            CSF011A
     C                   EVAL      VFPCRF = DDEUTN                                           CSF011A
     C                   ELSE                                                                CSF011A
     C                   EVAL      DDEUTN = VFPCRF                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkSettmts - Routine to check settlement instructions        *
      *               (copied SR/SCRN@S from LEFEEMSIN)               *
      *                                                               *
      *****************************************************************
     C     ChkSettmts    BEGSR

     C                   MOVE      *BLANKS       WWLNRF            6

     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      WWLNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      WWLNRF = DDLNRF
     C                   END

      ** Determine if pay settlement should be protected

     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C                   MOVE      'Y'           ##PPAY            1
     C                   MOVE      'Y'           ##PREC            1
     C                   ENDIF

     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'

     C     WPTFI         IFEQ      'P'
     C     WPTFI         OREQ      'S'                                                        CLE106
     C     WPTFI         OREQ      'R'                                                        CLE106
     C                   MOVE      'N'           ##PPAY
     C                   MOVE      'Y'           ##PREC
     C                   ENDIF

     C     WPTFI         IFEQ      *BLANK
     C                   IF        CL_PTYP = 66 or CL_PTYP = 67                            AR375891B
     C                             or CL_PTYP = 69 or CL_PTYP = 72                         AR375891B
     C                   MOVE      'N'           ##PPAY                                    AR375891B
     C                   MOVE      'Y'           ##PREC                                    AR375891B
     C                   ELSE                                                              AR375891B
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'N'           ##PREC
     C                   ENDIF                                                             AR375891B
     C                   ENDIF

     C                   ENDIF

     C     DDACTN        IFNE      'I'
     C     WrkDftSettl   OREQ      'Y'

      ** Set up payment instructions
      ** (on insertions, these fields will be zero/blank)

     C                   MOVEL     VFPAY         FLPAY
     C                   MOVEL     VFPSTM        FLPSTM
     C                   MOVEL     VFPONS        FLPONS
     C                   MOVEL     VFCVMR        FLCVMR
     C                   MOVEL     VFSCCY        FLPSCY
     C                   MOVEL     VFICCY        FLIC72

      ** Set up receive instructions
      ** (on insertions, these fields will be zero/blank)

     C                   MOVEL     VFREC         FLREC
     C                   MOVEL     VFRSTM        FLRSTM
     C                   MOVEL     VFRONS        FLRONS
     C                   MOVEL     VFSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     VFFEREXR      FLREXR                                       CLE031
     C                   Z-ADD     VFFEPEXR      FLPEXR                                       CLE031
     C                   MOVE      VFFEREXI      FLREXI                                       CLE031
     C                   MOVE      VFFEPEXI      FLPEXI                                       CLE031
     C                   MOVE      VFSCCY        FLRSCY                                       CLE031
     C                   MOVE      VFFEPSCY      FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031

     C                   ENDIF

      ** Determine parameters for settlement details input

     C                   EXSR      DETP@S

      ** Settlement instructions input

     C                   MOVE      *BLANKS       ##LNRF            6
     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      ##LNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      ##LNRF = DDLNRF
     C                   END

     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
     C     ##PAYS        IFEQ      *blank
     C     ##RECS        ANDEQ     *blank
     C     IDX           ANDEQ     0                                                          240070

     C                   CALLB     'ZASETINCVT'

      ** INPUTS                                                                 File Fmt
     C                   PARM                    ##PAYF                         File paym settl inst
     C                   PARM                    ##RECF                         File Recei Sett Inst
     C                   PARM      *BLANK        ##FRIF                         FRA/IRS Settl. Instr

      ** OUTPUTS                                                                Screen Fmt
     C                   PARM      *BLANK        ##PAYS                         Paym settl. inst Scr
     C                   PARM      *BLANK        ##RECS                         Recei settl inst Scr
     C                   PARM      *BLANK        ##FRIS                         FRA/IRS Sett inst
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETP@S - Determine parameters for settlement details screen  *
      *                                                               *
      *****************************************************************
     C     DETP@S        BEGSR

      ** Validate settlement account against Fee payment date:

     C     VFPYON        IFEQ      'S'
     C     VFPYON        OREQ      ' '
     C                   MOVE      VFPSTD        ##DATR
     C                   MOVE      VFPSTD        ##DATP
     C                   ENDIF

     C     VFPYON        IFEQ      'N'
     C                   MOVE      VFNPYD        ##DATR
     C                   MOVE      VFNPYD        ##DATP
     C                   ENDIF

     C     VFPYON        IFEQ      'E'
     C                   MOVE      VFPEND        ##DATR
     C                   MOVE      VFPEND        ##DATP
     C                   ENDIF

      ** If amend, enquire, authorise or delete
      ** move settlement file fields to screen fields
      ** Else clear settlement screen fields

     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'D'

      ** Set up payment instructions
      ** (on insertions, these fields will be zero/blank)

     C                   MOVEL     VFPAY         FLPAY
     C                   MOVEL     VFPSTM        FLPSTM
     C                   MOVEL     VFPONS        FLPONS
     C                   MOVE      VFOSBR        FLPOBR
     C                   If        CEU004 = 'Y'
     C                   MOVEL     VFSCCY        FLPSCY
     C                   MOVEL     VFICCY        FLIC72
     C                   Endif

      ** Set up receive instructions
      ** (on insertions, these fields will be zero/blank)

     C                   MOVEL     VFREC         FLREC
     C                   MOVEL     VFRSTM        FLRSTM
     C                   MOVEL     VFRONS        FLRONS
     C                   MOVE      VFOSBR        FLROBR
     C                   If        CEU004 = 'Y'
     C                   MOVEL     VFSCCY        FLRSCY
     C                   Endif
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     VFFEREXR      FLREXR                                       CLE031
     C                   Z-ADD     VFFEPEXR      FLPEXR                                       CLE031
     C                   MOVE      VFFEREXI      FLREXI                                       CLE031
     C                   MOVE      VFFEPEXI      FLPEXI                                       CLE031
     C                   MOVE      VFSCCY        FLRSCY                                       CLE031
     C                   MOVE      VFFEPSCY      FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031

     C                   ELSE

      ** If Settlement instructions are not defined, default them

     C     WrkDftSettl   IFEQ      'Y'
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        OREQ      *ZERO
     C     ##PREC        ANDNE     'Y'

     C                   CALLB     'ZASETINDFT'

      ** INPUT
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4

      ** Payment currency
      ** Receive currency
     C                   PARM      DDECUR        ##PCCY            3
     C                   PARM      DDECUR        ##RCCY            3

      ** Customer (shortname or number)
      ** Transaction Type
      ** Federal Funds Ind.
     C                   PARM      DDCSSN        ##CSNM           10
     C                   PARM      *BLANKS       ##TTYP            2
     C                   PARM      *BLANK        ##FFND            1

      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4

      ** Type of ISDA agreement
      ** Date of ISDA Agreement
      ** Version of ISDA Agreement
      ** Version of ISDA Agreement century
     C                   PARM                    BQAGTY            6
     C                   PARM                    BQAGDT            6
     C                   PARM                    BQAGVV            2
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095

      ** OUTPUT
      ** Defaulted Payment Settlement Instruction in file format
      ** Defaulted Receipt Settlement Instruction in file format
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF

      ** Clear payment instructions if protected

     C     ##PPAY        IFEQ      'Y'
     C                   CLEAR                   ##PAYF
     C                   Z-ADD     *ZERO         FLPSTM
     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
      * Set Pay CCY to be the same as Rec CCY if only one settlement side displayed           240056
     C                   Eval      DDPSCY = DDRSCY                                            240056
     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
     C                   ENDIF

      ** Clear receipt instructions if protected

     C     ##PREC        IFEQ      'Y'
     C                   CLEAR                   ##RECF
     C                   Z-ADD     *ZERO         FLRSTM
     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
      * Set Rec CCY to be the same as Pay CCY if only one settlement side displayed           240056
     C                   Eval      DDRSCY = DDPSCY                                            240056
     C                   EVAL      FLROBN = *BLANKS                                           CSD027
     C                   EVAL      FLROCN = *BLANKS                                           CSD027
     C                   ENDIF
     C                   ENDIF

     C                   END

     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR

      ** The called module requires that the customer number/name is valid,
      **    if it is not, exit from this subroutine.

     C                   IF        NOT (OKCSSN = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
                                                                                              246239
      ** Initialize fee payment date to start date. If payment on is *BLANKS payment date     246239
      ** would take the value of Fee Start Date which is Mandatory in this program            246239
                                                                                              246239
      ** Convert to Midas date format                                                         246239
                                                                                              246239
      ** No need to validate since this has been validated in previous call to LEFEEMVAL      246239
      ** upon reaching this statement all validations has been done                           246239
                                                                                              246239
     C                   MOVE      DDEPSD        DATEA                                        246239
     C                   TESTN                   DATEA                9798                    246239
     C                   CALLB     'ZDATE1'                                                   246239
     C                   PARM                    DATEA             6                          246239
     C                   PARM                    ZDAYNO            5 0                        246239
     C                   PARM                    BJDFIN                                       246239
     C                   PARM                    ErrorFlag         1                          246239
     C                   Z-ADD     ZDAYNO        ##DATR                                       246239
     C                   Z-ADD     ZDAYNO        ##DATP                                       246239
                                                                                              246239

      ** Validate settlement account against Fee payment date:

     C     VFPYON        IFEQ      'S'
     C                   MOVE      VFPSTD        ##DATR
     C                   MOVE      VFPSTD        ##DATP
     C                   ENDIF

     C     VFPYON        IFEQ      'N'
     C                   MOVE      VFNPYD        ##DATR
     C                   MOVE      VFNPYD        ##DATP
     C                   ENDIF

     C     VFPYON        IFEQ      'E'
     C                   MOVE      VFPEND        ##DATR
     C                   MOVE      VFPEND        ##DATP
     C                   ENDIF


      ** DEFINE FEE BRANCH: IF INSERT MODE IT COMES FROM LOAN FILE OR FACILITY FILE
      ** ELSE FROM FEE FILE
     C                   IF        NOT (DDACTN = 'I')
     C                   EVAL         FeeBranch = FE_FEBRCA
     C                   ELSE

     C                   IF        NOT (DDLNRF = *Blanks)
     C                   EVAL         FeeBranch = CL_BRCA
     C                   ELSE
     C                   EVAL         FeeBranch = FA_BRCA
     C                   ENDIF

     C                   ENDIF

     C     DDPSTM        IFEQ      *BLANK
     C                   MOVE      '00'          DDPSTM
     C                   ENDIF
      **********                                                                  BUG21889 BUG21889A
      ***If*the*Participant*Type*is*'A'*(agent)*or*'I'*(internal)*wherein*SettlemeBUG21889 BUG21889A
      ***Payments*tab*need*not*to*be*shown,*default*the*value*of*Pay*-*Settlement BUG21889 BUG21889A
      ***Method*to*blank*instead*of*'00'.                                         BUG21889 BUG21889A
     C*****DDPRTR        IFEQ      'A'                                            BUG21889 BUG21889A
     C*****DDPRTR        OREQ      'I'                                            BUG21889 BUG21889A
     C**********         EVAL      DDPSTM = *BLANKS                               BUG21889 BUG21889A
     C**********         ENDIF                                                    BUG21889 BUG21889A
      **********                                                                  BUG21889 BUG21889A
     C     DDRSTM        IFEQ      *BLANK
     C                   MOVE      '00'          DDRSTM
     C                   ENDIF
      *                                                                                     MD050688
     C** If the Fee is attached to non-Part Sold loan clear Payment Settlement Details      MD050688
     C*                                                                                     MD050688
     C                   IF        CL_PTYP <> 66                                            MD050688
     C                             AND CL_PTYP <> 67                                        MD050688
     C                             AND CL_PTYP <> 69                                        MD050688
     C                             AND CL_PTYP <> 72                                        MD050688
                                                                                           BUG21889A
      ** If the Participant Type is 'A' (agent) or 'I' (internal) or 'blank' and           BUG21889A
      ** CLE106 = 'Y' where the Settlement Payment Tab need not to be shown (patterned     BUG21889A
      ** on the java design for the tab), remove Pay - Settlement instruction.              AR674765
      ***on*the*java*design*for*the*tab),*default*the*value*of*Pay*-*Settlement   BUG21889A AR674765
      ***Method*to*blank*instead*of*'00'.                                         BUG21889A AR674765
     C     CLE106        IFEQ      'Y'                                                     BUG21889A
     C     DDPRTR        IFEQ      'A'                                                     BUG21889A
     C     DDPRTR        OREQ      'I'                                                     BUG21889A
     C     DDPRTR        OREQ      ' '                                                     BUG21889A
     C**********         EVAL      DDPSTM = *BLANKS                               BUG21889A AR674765
     C                   EVAL      ##PAYS = *BLANKS                                         AR674765
     C                   ENDIF                                                             BUG21889A
     C                   ELSE                                                              BUG21889A
     C**********         EVAL      DDPSTM = *BLANKS                               BUG21889A AR674765
     C                   EVAL      ##PAYS = *BLANKS                                         AR674765
     C                   ENDIF                                                             BUG21889A
     C                   ENDIF                                                              MD050688
                                                                                           BUG21889A
      ** If the Participant Type is not 'A' (agent) or not 'blank' or CLE106 not           BUG21889A
      ** equal to 'N' where the Settlement Receipt Tab need not to be shown (patterned     BUG21889A
      ** on the java design for the tab), remove Receipt - Settlement instruction.          AR674765
      ***on*the*java*design*for*the*tab),*default*the*value*of*Receipt*-*SettlemenBUG21889A AR674765
      ***Method*to*blank*instead*of*'00'.                                         BUG21889A AR674765
     C     CLE106        IFEQ      'Y'                                                     BUG21889A
     C     DDPRTR        IFNE      'A'                                                     BUG21889A
     C     DDPRTR        ANDNE     ' '                                                     BUG21889A
     C**********         EVAL      DDRSTM = *BLANKS                               BUG21889A AR674765
     C                   EVAL      ##RECS = *BLANKS                                         AR674765
     C                   ENDIF                                                             BUG21889A
     C                   ENDIF                                                             BUG21889A

      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      ** Validate Extended Settlement Details

     C                   IF        ##DATR = 0 AND ##DATP = 0                              AR1072399A
     C                             OR DDACTN <> 'X'                                        AR1096655
      *                                                                                       CLE168
      ** Set Facility Customer, Facility Type, Facility Sequence                              CLE168
      *                                                                                       CLE168
     C                   IF        CLE168 = 'Y'                                               CLE168
     C     *LOCK         IN        LEFCLY                                                     CLE168
     C                   IF        DDLNRF <> *BLANKS                                          CLE168
     C     DDLNRF        CHAIN     CLOANCLF                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      KFCUN = ZAFCUS                                             CLE168
     C                   MOVE      ZAFTYP        KFTYP                                        CLE168
     C                   MOVE      ZAFSEQ        KFSEQ                                        CLE168
     C                   ENDIF                                                                CLE168
     C                   ELSE                                                                 CLE168
     C                   EVAL      KFCUN = DDCSSN                                             CLE168
     C                   MOVE      DDFACT        KFTYP                                        CLE168
     C                   MOVE      DDFCNO        KFSEQ                                        CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C     LEFCLT1       CHAIN     LEFCLTD0                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      A_XBKPT = C_FCBKPT                                         CLE168
     C                   ENDIF                                                                CLE168
     C                   EVAL      A_XCNUM = KFCUN                                            CLE168
     C                   EVAL      A_XFACT = KFTYP                                            CLE168
     C                   EVAL      A_XFCNO = KFSEQ                                            CLE168
     C                   OUT       LEFCLY                                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C                   CALLB     'ZASETINVAL'

      ** INPUT
      ** Return Code
      ** Calling function type
     C                   PARM                    ReturnCode
     C                   PARM      'LEND'        ##CALP            4

      ** Payment currency (or deal currency if only one currency on deal)
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      DDECUR        ##PCCY            3
     C                   PARM      DDECUR        ##RCCY            3

      ** Customer (shortname or number)
      ** Deal type
      ** Federal Funds Ind.
      ** Booking Branch
     C                   PARM      DDCSSN        ##CSNM           10
     C                   PARM      *BLANKS       ##TTYP            2
     C                   PARM      *BLANKS       ##FFND            1
     C                   PARM      FeeBranch     ##BRCA            3

      ** Receipt Date
      ** Payment Date
     C                   PARM                    ##DATR            5 0
     C                   PARM                    ##DATP            5 0

      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS

      ** Action Code
     C                   PARM      DDACTN        ##ACTN            1

      ** Protect Payment Field
      ** Protect Receive Field
     C                   PARM                    ##PPAY
     C                   PARM                    ##PREC

      ** OUTPUT
      ** Payment Instruction OK flag
      ** Receive Instruction OK flag
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKPayInsDS
     C                   PARM                    OKRecInsDS
     C                   PARM                    OKFRAInsDS

      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF

      ** EXTRA INPUT
      ** Action Code used
      ** Validation Iteration
     C                   PARM      DDACTN        ##ACTN            1
     C                   PARM      '1ST'         ##ValIter         3
     C                   ENDIF                                                            AR1072399A

      ** Extra validation after the Extended Settlements

     C                   CALLB     'LEFEEMEVL'

      ** INPUTS
      ** Response mode
     C                   PARM      'S'           APRespMode

      ** Fee detail file format
      ** Fee detail screen format
     C                   PARM                    CrFeFilFmt
     C                   PARM                    CrFeScnFmt

      ** Fee Valid file
     C                   PARM                    ValidFeem

      ** CEU004
     C                   PARM                    CEU004

      ** Payment instructions
      ** Receive instructions
      ** FRA/IRS instructions
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF

      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OkTrFEEM

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

     C                   MOVEL     FLREC         VFREC
     C                   MOVEL     FLRSTM        VFRSTM
     C                   MOVEL     FLRONS        VFRONS
     C                   MOVE      FLROBR        VFOSDB

     C                   MOVEL     FLPAY         VFPAY
     C                   MOVEL     FLPSTM        VFPSTM
     C                   MOVEL     FLPONS        VFPONS
     C                   MOVE      FLPOBR        VFOMDB
     C                   MOVE      FLCVMR        VFCVMR
     C                   MOVE      FLPSCY        VFSCCY
     C                   MOVE      FLIC72        VFICCY
      *                                                                                       240070
     C     DDPSTM        IFEQ      '00'                                                       240070
     C     DDRSTM        ANDEQ     '00'                                                       240070
     C     DDACTN        ANDEQ     'I'                                                        240070
     C     IDX           ANDNE     0                                                          240070
     C                   MOVE      *BLANK        DDPSTM                                       240070
     C                   MOVE      *BLANK        DDRSTM                                       240070
     C                   ENDIF                                                                240070
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        VFFEREXR                                     CLE031
     C                   Z-ADD     FLPEXR        VFFEPEXR                                     CLE031
     C                   MOVE      FLREXI        VFFEREXI                                     CLE031
     C                   MOVE      FLPEXI        VFFEPEXI                                     CLE031
     C                   MOVE      FLRSCY        VFSCCY                                       CLE031
     C                   MOVE      FLPSCY        VFFEPSCY                                     CLE031
     C                   ENDIF                                                                CLE031

     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetupAmd - Set up fields that are needed in the validation   *
      *             of amendments and changes.                        *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      ** For Amends, put the complete (pre-existing) Fee into the Valid
      **  file record - fields in this will be updated during processing

     C**********         MOVE      CrFeFilFmt    ValidFeem                                   BUG9426
     C                   MOVEL     CrFeFilFmt    ValidFeem                                   BUG9426

      ** For Amends, convert the Fee to screen format
     C                   MOVE      DDACTN        @DDACTN

     C                   CALLB     'LEFEEMCVT'

      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode

      ** Fee file format
     C                   PARM                    ValidFEEM

      ** Loan (LN) file format
      ** Facility FM in file format
     C                   PARM                    ClilFilFmt
     C                   PARM                    FacmFilFmt

     C                   PARM                    CLE006

      ** Fee against a syndicated facility/loan
     C                   PARM                    WSYND

      ** OUTPUT
      ** Fee Details - screen format
     C                   PARM                    CrFeScnFmt

      ** Participant Fee indicator
     C                   PARM                    WPTFI             1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValdateAmd - Routine to check whether the fields amended     *
      *               are amendable.                                  *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR

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

     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   MOVE      DDRTE1        WTestRate         8 0                        CLE106
     C                   IF        WTestRate = *Zeros                                         CLE106
     C                   EVAL      DDRTE1 = *Blanks                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   MOVE      DDRTE2        WTestRate                                    CLE106
     C                   IF        WTestRate = *Zeros                                         CLE106
     C                   EVAL      DDRTE2 = *Blanks                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   MOVE      DDRTE3        WTestRate                                    CLE106
     C                   IF        WTestRate = *Zeros                                         CLE106
     C                   EVAL      DDRTE3 = *Blanks                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   MOVE      DDRTE4        WTestRate                                    CLE106
     C                   IF        WTestRate = *Zeros                                         CLE106
     C                   EVAL      DDRTE4 = *Blanks                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   MOVE      DDRTE5        WTestRate                                    CLE106
     C                   IF        WTestRate = *Zeros                                         CLE106
     C                   EVAL      DDRTE5 = *Blanks                                           CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LEFEEMAMD'

      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode

      ** Incoming Fee in Screen Format
      ** (Current) Fee in Screen Format
     C                   PARM                    TranInFEEM
     C                   PARM                    CrFeScnFmt

      ** Fee in file format
     C                   PARM                    ValidFeem

      ** OUTPUTS
      ** Error Indicators
     C                   PARM                    OkTrFEEM

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr

      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx

      ** Amendments OK
     C                   PARM                    AmendOk           1

      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

     C                   PARM                    CLE006                                       245099
                                                                                              245099
     C                   PARM                    DRejFlg           1                        MD030856
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD031692
                                                                                            MD031692
     C                   PARM                    WFldNamArr                                 MD031692
     C                   PARM                    WMsgIDArr                                  MD031692
     C                   PARM                    WMsgDtaArr                                 MD031692
                                                                                            MD031692
      ** Array index (3P0) from/to caller                                                   MD031692
                                                                                            MD031692
     C                   PARM                    WIdx                                       MD031692
                                                                                            MD031692     
      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      ** For Delete or Authorisation
      ** put the complete (pre-existing) Fee
      **  into the Valid file record

     C                   IF        DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVEL     CrFeFilFmt    ValidFeem
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

     C                   EVAL      VFLCHT = DDACTN

     C**********         EVAL      VFPCRF = *BLANKS                                           CLE106
     C                   EVAL      VFFRNT = *BLANKS
     C                   EVAL      VFAFRT = APFOAsocID
     C                   EVAL      VFREPA = APRprLocn
     C                   EVAL      VFSTMP = TimeStamp

     C                   EVAL      TranStatus = 'S'
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      VFAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteToDB - Update file                                       *
      *                                                               *
      *****************************************************************
     C     WriteToDB     BEGSR

      ***  Update valid Fee : Fee Ref

     C                   MOVEL     DDCSSN        VFCNUM
     C     DDLNRF        IFNE      *BLANKS                                                    242377
     C     PPCUST        ANDEQ     'O'                                                        242377
     C     CL_PTYP       IFEQ      64                                                         242377
     C     CL_PTYP       OREQ      65                                                         242377
     C     CL_PTYP       OREQ      68                                                         242377
     C     CL_PTYP       OREQ      71                                                         242377
     C                   MOVEL     CL_CNUM       VFCNUM                                       242377
     C                   ENDIF                                                                242377
     C                   ENDIF                                                                242377
     C                   MOVEL     DDFACT        VFFACL
     C                   MOVE      DDFCNO        VFFACL
     C                   MOVEL     DDLNRF        VFLOAN
     C                   MOVEL     DDFSEQ        VFFSEQ

      ** Update valid Fee  : Last action code

     C                   MOVEL     DDACTN        VFLCHT

      ** Fee updates

     C                   CALLB     'LEFEEMUPD'
     C                   PARM                    ReturnCode
     C                   PARM                    P#MODE            1
     C                   PARM                    ValidFeem
     C                   PARM                    CrFeFilFmt                                  BUG3760
     C                   PARM                    TranInStamp                                  CER049
     C                   PARM                    CLE002
     C                   PARM                    CSC011
     C                   PARM                    BPFEAU
     C******             PARM                    BJRDNB                                       243154
     C**********         PARM                    WRNDAY                              243154 BUG13127
     C                   PARM                    PRNDAY                                     BUG13127
     C                   PARM                    H#TNLU            5 0

      ** OUTPUTS
      ** Field OK flags
     C                   PARM                    OkTrFEEM

      ** Fee sequence
     C                   PARM                    WWFSEQ            2 0

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** If there were any errors in the update functions ROLLBACK any
      ** updates and end this program. Otherwise, COMMIT the updates

     C     ReturnCode    IFNE      *BLANKS
     C     ReturnCode    ANDNE     '*RECUPD'
     C     CSC022        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C     WCMT01        IFNE      'Y'
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
     C                   IF        ReturnCode <> '*RECLCK'                                  AR868380
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR868380
     C                   ELSE
     C     CSC022        IFEQ      'N'
     C     WCMT01        OREQ      'N'
     C     CSC022        ANDEQ     'Y'
     C                   COMMIT
     C                   ENDIF
     C                   END

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     ReturnCode    IFEQ      '*RECUPD'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      Ix = Idx
     C                   MOVEL     '*ANY'        FldNameArr(Ix)
     C                   MOVEL     'LER0351'     MsgIdArr(Idx)
     C                   END
      *                                                                                     AR868380
     C     ReturnCode    IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      Idx = Idx + 1                                            AR868380
     C                   EVAL      Ix = Idx                                                 AR868380
     C                   MOVEL     '*ANY'        FldNameArr(Ix)                             AR868380
     C                   MOVEL     'LEL0817'     MsgIdArr(Idx)                              AR868380
     C                   END                                                                AR868380

      ** Set up the sequence number for the confirmation message

     C     DDACTN        IFEQ      'I'
     C                   MOVEL     WWFSEQ        DDFSEQ
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                             CSF011A
     C                   EVAL      WCustomer = DDCSSN                                        CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ELSE                                                                CSF011A
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrRtvCust     BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
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

     C                   RESET                   ReturnCode

     C                   CLEAR                   CrFeScnFmt
     C**********         CLEAR                   TranInFEEM2                                  CLE106

     C                   MOVE      *ALL'Y'       OkTrFEEM

     C                   CLEAR                   ValidFEEM

      ** Fee File format
      ** Loan CL in file format
      ** Facility FM in file format
     C                   CLEAR                   CrFeFilFmt
     C                   CLEAR                   ClilFilFmt
     C                   CLEAR                   FacmFilFmt

     C                   ENDSR
      *****************************************************************
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
     C                   PARM                    Trans5002
     C                   PARM                    StmpTax500                                   CER049

      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS

     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
     C                   PARM                    DRejFlg                                    MD030856
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

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'

      ** Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'

      ** Access Bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access MIDAS Modules details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Access General Ledger details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY

      ** Access Customer Lending Data

     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Determine if EMU LE Settlement Currency Conversion
      ** Upgrade feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CEU004            1
     C                   ELSE
     C                   MOVEL     'N'           CEU004
     C                   ENDIF

      ** Determine if CLE002 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002            1
     C                   ELSE
     C                   MOVEL     'N'           CLE002
     C                   ENDIF

      ** Determine if CLE006 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE006            1
     C                   ELSE
     C                   MOVEL     'N'           CLE006
     C                   ENDIF
                                                                                              CLE106
      ** Determine if CLE106 is installed                                                     CLE106
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

      ** Determine if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSC011            1
     C                   IN        SC24X7
     C                   IN        SDSTAT

      ** Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF

     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
     C                   Z-ADD     WRNDAY        PRNDAY            5 0                      BUG13127

      * Determine if CSC022 is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CSC022 ='Y'
     C                   EVAL      WCMT01 ='N'
      * SCCMTJOB data area
     C                   IN        SCCMTJOB
      * Move data area to commitment array
     C                   IF        COMITNOM > 0
     C                   MOVEA     COMITJOB      ARRJBNAM
      *
      * Check if PSJOBNAME exist.
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17
     C                   IF        *IN17 = *ON
     C                   EVAL      WCMT01= 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      * @rtcd not found
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LEFEEMVU'
     C                   EVAL      DBKEY = 'CSC022'
     C                   EVAL      DBFILE ='SCSARDPD'
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LEFEEMVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 1                                                 CAP086
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
      *                                                                                       CLE168
      ** Access SAR details file                                                              CLE168
      *                                                                                       CLE168
     C                   CALLB     'AOSARDR0'                                                 CLE168
     C                   PARM      *BLANKS       @RTCD                                        CLE168
     C                   PARM      '*VERIFY'     @OPTN                                        CLE168
     C                   PARM      'CLE168'      @SARD                                        CLE168
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE168
                                                                                              CLE168
     C                   IF        @RTCD = *BLANK                                             CLE168
     C                   MOVEL     'Y'           CLE168            1                          CLE168
     C                   ELSE                                                                 CLE168
     C                   MOVEL     'N'           CLE168                                       CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
      *                                                                                       CLE168
     C     LEFCLT1       KLIST                                                                CLE168
     C                   KFLD                    KFCUN             6                          CLE168
     C                   KFLD                    KFTYP             3                          CLE168
     C                   KFLD                    KFSEQ             2                          CLE168
      *                                                                                       242377
      ** Check System Value: Use Original Borrower or Purchased From?                         242377
      ** Set up parameter so access object checks LoanCustOriginPurch                         242377
     C                   MOVE      *BLANKS       WPARM                                        242377
     C                   MOVEL     'LoanC'       WPARM1                                       242377
     C                   MOVEL     'ustOr'       WPARM2                                       242377
     C                   MOVEL     'iginP'       WPARM3                                       242377
     C                   MOVEL     'urch'        WPARM4                                       242377
     C                   MOVEL     WPARM         SVALK1                                       242377
      *                                                                                       242377
      * Call Access object:                                                                   242377
     C                   CALL      'AOSVALR0'                                                 242377
     C                   PARM                    RTNCDE            7                          242377
     C                   PARM                    SVALK1           20                          242377
     C                   PARM                    SVAL1           200                          242377
     C                   PARM                    SVALK2           20                          242377
     C                   PARM                    SVAL2           200                          242377
     C                   PARM                    SVALK3           20                          242377
     C                   PARM                    SVAL3           200                          242377
     C                   PARM                    SVALK4           20                          242377
     C                   PARM                    SVAL4           200                          242377
     C                   PARM                    SVALK5           20                          242377
     C                   PARM                    SVAL5           200                          242377
     C                   PARM                    SVALK6           20                          242377
     C                   PARM                    SVAL6           200                          242377
     C                   PARM                    SVALK7           20                          242377
     C                   PARM                    SVAL7           200                          242377
     C                   PARM                    SVALK8           20                          242377
     C                   PARM                    SVAL8           200                          242377
     C                   PARM                    SVALK9           20                          242377
     C                   PARM                    SVAL9           200                          242377
     C                   PARM                    SVALK0           20                          242377
     C                   PARM                    SVAL10          200                          242377
      *                                                                                       242377
      * If the system value is not found then issue a database error                          242377
     C     RTNCDE        IFNE      '        '                                                 242377
     C                   MOVEL     'SDSVALPD'    DBFILE                         ************* 242377
     C                   MOVEL     '901'         DBASE                          * DBERR 901 * 242377
     C                   MOVEL     '*FIRST  '    DBKEY                          ************* 242377
     C                   EXSR      *PSSR                                                      242377
     C                   ELSE                                                                 242377
      *                                                                                       242377
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              242377
     C                   MOVEL     SVAL1         WRK01             1                          242377
     C     WRK01         IFEQ      'O'                                                        242377
     C                   MOVE      'O'           PPCUST            1                          242377
     C                   ELSE                                                                 242377
     C                   MOVE      'P'           PPCUST                                       242377
     C                   ENDIF                                                                242377
     C                   ENDIF                                                                242377

      ** Hook to enable non-core initial processing to be included
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002