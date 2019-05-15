     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal interface controller')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  FXFXDLCTL - FX Deals Interface Controller                    *
      *                                                               *
      *  Function: This Program Validates FX Deals for Input into     *
      *            the Midas database.                                *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert)                                  *
      *              - If ALL of the settlement fields are blank, set *
      *                them up from standard settlement instructions  *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD047971           Date 16Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR990243           Date 14Jun12               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      *                 246352             Date 13Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245158             Date 19Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CFX114             Date 15Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 27Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201083             Date 15May02               *
      *                 196952             Date 06May02               *
      *                 196461             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 195763             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190876             Date 08Mar01               *
      *                 CPB002             Date 08Aug00               *
      *                 185751             Date 17Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 06Nov00               *
      *                 CDL008             Date 02May00               *
      *                 166888             Date 08Sep99               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 170909             Date 07Sep99               *
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 148855             Date 26Nov98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 30Jul98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047971 - Do not allow amendment to settlement account if   *
      *             that side is already netted.                      *      
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR990243 - Additional deliveries for CSW212                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  246352 - Applied core fix 224231.                            *
      *  224231 - CLS Deal in RPR default incorrect Nostro Code.      *
      *           Validate Trade details before defaulting settlements*
      *         - Bank to Bank Info. 6' field strangely defaulted to  *
      *           'N'. It should be blank when 'Bank to Bank Info. 1  *
      *           to 5' are blanks.                                   *
      *  245158 - APISERVER generates dumps for module FXVSODLNO.     *
      *           Pointer not set for location referenced.            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXFXDLCC03,FXFXDLC020            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXVFXDLPD*
      *  CAS004 - Hedge Accounting Phase A                            *
      *  201083 - Recompiled due to changes in PF/FXIFXDLPD.          *
      *  196952 - Ensure Rate has 5 digits before decimal separator   *
      *           and 8 digits after.                                 *
      *           Recompiled due to changes in FXFXDLPD and FXIFXDLPD.*
      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  195763 - Recompiled due to recompiled FXFXDLVAL.             *
      *  200400 - Reverse fix 179510                                  *
      *  190876 - Reject Meridian interface deals with warnings.      *
      *           New warning if Counterparty is not a CLS Customer.  *
      *           Fix extended standard settlement instruction        *
      *           defaulting for CLS.                                 *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
      *           to be used in the validation.                       *
      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
      *  CDL008 - Continuous Linked Settlement                        *
      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
      *           to defaulted value all the time. Apply GEMS 163745  *
      *           However, 163745 only fixes the problem for 'A' and  *
      *           'X' processing. Problem still exists for insert.    *
      *           Need to default only the 1st time validation is     *
      *           done. Do not re-default for subsequent validations. *
      *           Due to this 163745 in its original form is no       *
      *           longer required, now default required only for      *
      *           'first time insert'.                                *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Mismatch on parameters for call to ZASETINDFT       *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXDEALPP               *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
      *           it through the ZACHNDQMS module, which is included  *
      *           in the DTAQCHK* /COPYs.                             *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *           Phase 2.  Module recompiled over changed /COPY      *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FFXVFXDLPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FFXIFXDLPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FFXVFXDLL0 IF   E           K DISK    RENAME(FXVFXDLD0:FXVFXDLCHK)
     F                                     INFSR(*pssr)                         CAP013
     FFXVFXDLL1 IF   E           K DISK    RENAME(FXVFXDLD0:FXVFXDLCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              190876
      ** SD Warning messages considered as errors                                             190876
     FSDWARNL1  IF   E           K DISK    INFSR(*PSSR)                                       190876

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FXFXDLC019

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
      ** The following /COPY line includes the definitions for fields           148855
      ** used in checking whether there are messages on the data queue.         148855
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 148855
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

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

     D TranIn        E DS                  EXTNAME(FXFXDLPD)
      * Incoming Transaction

     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout
     D FXDLRecIns            400    468
     D FXDLPayIns            469   1027
     D FXDLPayISDA          1394   2043                                                       CSW212
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)
     D FXDEALDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D FXDEALMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D FXDEALDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D FXDEALMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D FXDEALRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D FXDEALPONS    E                     EXTFLD(QQPONS)                                     CGL029
      * (Current) Deal in File Format
     D*DEALRecIns            400    468                                                       CGL029
     D DEALRecIns1           400    401                                                       CGL029
     D DEALRecIns2           414    468                                                       CGL029
     D*DEALPayIns            469   1027                                                       CGL029
     D DEALPayIns1           469    470                                                       CGL029
     D DEALPayIns2           483   1027                                                       CGL029
     D DEALPayISDA          1394   2043                                                       CSW212
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format

     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input

     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format
     D FLPAY2                 21    565                                                       CGL029

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format
     D FLREC2                 21     75                                                       CGL029

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
     D FLISDA2                 1    650                                                       CSW212
                                                                                CAP051
     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
      * FX Extra Data - Classe 1 Data - File (D/B) format                       CAP051
     D                                     PREFIX(IF_)                          CAP051
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
      * FX Extra Data - File (D/B) format                                       CAP004
                                                                                CAP051
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
      ** External DS for SAR details                                            CAP051

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011

     D*DtqRec**********DS            54                                         148855
     ******DS*for*Data*Queue****************************************************148855
     D**MsgNumber******        8     11B 0                                      148855
     D*DtqMsgSel*******DS             7                                         148855
     D**MsgType********        1      1    INZ('F')                             148855
     D**MsgBytes*******        4      7B 0                                      148855
                                                                                148855
     D FXFXDLUPC       DS             1    DTAARA(FXFXDLUPC)

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Field (500A) to receive the incoming transaction
     D Trans500        S            500A
                                                                                CAP051
      ** Field (500A) to receive the incoming Extra Data                        CAP051
     D InfData500      S            500A                                        CAP051
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A   INZ('Y')
     D  DDDlnoOK                      1A   INZ('Y')
     D  DDDltpOK                      1A   INZ('Y')
     D  DDDlstOK                      1A   INZ('Y')
     D  DDFedfOK                      1A   INZ('Y')
     D  DDDldtOK                      1A   INZ('Y')
     D  DDBrsnOK                      1A   INZ('Y')
     D  DDBrkrOK                      1A   INZ('Y')
     D  DDBkrgOK                      1A   INZ('Y')
     D  DDSdnoOK                      1A   INZ('Y')
     D  DDCustOK                      1A   INZ('Y')
     D  DDVdatOK                      1A   INZ('Y')
     D  DDOdatOK                      1A   INZ('Y')
     D  DDBokcOK                      1A   INZ('Y')
     D  DDLnknOK                      1A   INZ('Y')
     D  DDPtfrOK                      1A   INZ('Y')
     D  DDBccyOK                      1A   INZ('Y')
     D  DDBamtOK                      1A   INZ('Y')
     D  DDNbuyOK                      1A   INZ('Y')
     D  DDRateOK                      1A   INZ('Y')
     D  DDFpntOK                      1A   INZ('Y')
     D  DDSignOK                      1A   INZ('Y')
     D  DDMginOK                      1A   INZ('Y')
     D  DDMbsiOK                      1A   INZ('Y')
     D  DDSccyOK                      1A   INZ('Y')
     D  DDSamtOK                      1A   INZ('Y')
     D  DDPrfcOK                      1A   INZ('Y')
     D  DDNselOK                      1A   INZ('Y')
     D  DDBceOK                       1A   INZ('Y')
     D  DDOrbrOK                      1A   INZ('Y')
     D  DDDbsrOK                      1A   INZ('Y')
     D  DDBbfpOK                      1A   INZ('Y')
     D  DDBbfsOK                      1A   INZ('Y')
     D  DDSbfpOK                      1A   INZ('Y')
     D  DDSbfsOK                      1A   INZ('Y')
     D  DDMtchOK                      1A   INZ('Y')
     D  DDCLSSOK                      1A   INZ('Y')                             CDL008
     D  DDOYLCOK                      1A   INZ('Y')                                           CAS001
     D  DDTYLCOK                      1A   INZ('Y')                                           CAS001
     D  DDCLASOK                      1A   INZ('Y')                                           CDL038
     D/COPY WNCPYSRC,FXH00059

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


      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** A code to indicate the calling function to the lower level modules
     D FXDL            S              4A   INZ('FXDL')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0

      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

     ****Data*queue*parms*******************************************************148855

     D*DtqLenB*********S              9B 0                                      148855
     D*DtqFmt**********S              8A                                        148855
     D*DtqNamLib*******S             20A                                        148855
     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
     D*DtqMsgFmt*******S              8A                                        148855
     D*DtqErr**********S             50A                                        148855

     D Object          S             10A   INZ('FXFXDLUPC')
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

      ** Fields defined for enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PDealNum        S             18A                                               CSC011 CGL029
     D*PADealNum       S             18A                                               CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNum       S             24A                                                      CGL029
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** Whether or not to clear the program message queue                                    222373
     D ClearPgmQ       S              1A                                                      222373
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDLC020

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,FXFXDLC001

      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Infdata500    Infdata                        CAP051
     C                   MOVEL     Extdata500    Extdata                        CAP004

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,FXFXDLC002

      *  Check if valid deal exists for Front Office ID

     C                   EXSR      ChkValDeal
      *
      *  If valid deal does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid deal exists for Midas Deal Number                       CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiDl                                   CAP013
      *                                                                         CAP013
      *  If valid deal does exist (even after delay), fail this input           CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013

      * Reset variables again in case the details have been corrupted
      * by previous chain to valid deals file.

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,FXFXDLC003

      *  Validate Action Code

     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,FXFXDLC004

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,FXFXDLC005
     C**********         EXSR      DftSettmts                                                 224231
      /COPY WNCPYSRC,FXFXDLC006
     C                   EXSR      ValidateTr
     C                   EXSR      DftSettmts                                                 224231
      /COPY WNCPYSRC,FXFXDLC007
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,FXFXDLC008

     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,FXFXDLC009
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,FXFXDLC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,FXFXDLC011
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,FXFXDLC012
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,FXFXDLC013

     C                   ENDSL
      *
     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP

      /COPY WNCPYSRC,FXFXDLC014

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
      /COPY WNCPYSRC,FXFXDLC015
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,FXFXDLC016

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
      *  Check if any messages are already on the data queue
      *  No need to send duplicate prompt messages

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there            148855
      ** are messages on the server/updater data queue, and sends a 'GO'.       148855
      ** message to the data queue if there are not.                            148855
     D/COPY ZACPYSRC,DTAQCHK                                                    148855
      **--------------------------------------------------------------------------------------------

     C*******************EVAL      DtqLenB = 54                                 148855
     C*******************EVAL      DtqNamLib = 'APFXDLDTQ *LIBL'                148855
     C*******************EVAL      MsgBytes = 8                                 148855
     C*******************CALL      'QMHRDQM'                                    148855
     C*******************PARM                    DtqRec                         148855
     C*******************PARM                    DtqLenB                        148855
     C*******************PARM      'RDQM0100'    DtqFmt                         148855
     C*******************PARM                    DtqNamLib                      148855
     C*******************PARM                    DtqMsgSel                      148855
     C*******************PARM                    DtqMsgLen                      148855
     C*******************PARM      'RDQS0100'    DtqMsgFmt                      148855
     C*******************PARM                    DtqErr                         148855
      *******************                                                       148855
     C*****MsgNumber*****IFEQ      DtqComp                                      148855
     C*******************CALL      'QSNDDTAQ'                                   148855
     C*******************PARM      'APFXDLDTQ'   DtqNam           10            148855
     C*******************PARM      '*LIBL'       DtqLib           10            148855
     C*******************PARM                    DtqLen            5 0          148855
     C*******************PARM      'GO'          DtqDta           10            148855
     C*******************END                                                    148855
     C                   END
     C                   END
     C                   END

     C                   RETURN
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXFXDLC021

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValDeal - Routine to check if valid deal exists for        *
      *    Front Office ID and Front Office Associated ID             *
      *                                                               *
      *****************************************************************

     C     ChkValDeal    BEGSR

      * Check for deal on Valid file
     C     APFOTranID    CHAIN     FXVFXDLL0                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     APFOTranID    CHAIN     FXVFXDLL0                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF


      * Check for associated deal on Valid file
     C     APFOAsocID    IFNE      *BLANK

     C     APFOAsocID    CHAIN     FXVFXDLL0                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     APFOAsocID    CHAIN     FXVFXDLL0                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C*******************EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDSDNO'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiDl - Routine to check if valid deal exists for        *         CAP013
      *    Midas Deal Number                                          *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiDl    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas deal number supplied                                 CAP013
                                                                                CAP013
     C                   TESTN                   DDDLNO               9898      CAP013
                                                                                CAP013
     C     DDDLNO        IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for deal on Valid file                                            CAP013
     C                   MOVEL     DDDLNO        F3DN38                         CAP013
     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas associated deal number supplied                      CAP013
                                                                                CAP013
     C                   TESTN                   DDSDNO               9898      CAP013
                                                                                CAP013
     C     DDSDNO        IFNE      *BLANK                                       CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for associated deal on Valid file                                 CAP013
     C                   MOVEL     DDSDNO        F3DN38                         CAP013
     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     F3DN38        CHAIN     FXVFXDLL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDSDNO'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
     C/COPY WNCPYSRC,FXFXDLCC04

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the FX database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE

      * Action Code
     C                   PARM                    DDACTN

      * Front Office Transaction ID
     C                   PARM                    APFOTranID

      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID

      * (Midas) Deal Number
     C                   PARM                    DDDLNO

      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO

      * Booking branch
     C                   PARM                    DDBRSN

      * Originating branch
     C                   PARM                    DDORBR

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK

      * OK - Deal Number
     C                   PARM                    DDDlnoOK

      * OK - Booking branch
     C                   PARM                    DDBrsnOK
      *
      * OK - Originating branch
     C                   PARM                    DDOrbrOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM      *ZEROS        WIdx                                         CAS004
     C/COPY WNCPYSRC,FXFXDLCC02

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

      ** 'Bank to Bank Info. 6' field strangely defaulted to 'N'. It should be                224231
      ** blank when 'Bank to Bank Info. 1 to 5' are blanks.                                   224231
      *                                                                                       224231
     C     DDBTB1        IFEQ      *BLANKS                                                    224231
     C     DDBTB2        ANDEQ     *BLANKS                                                    224231
     C     DDBTB3        ANDEQ     *BLANKS                                                    224231
     C     DDBTB4        ANDEQ     *BLANKS                                                    224231
     C     DDBTB5        ANDEQ     *BLANKS                                                    224231
     C                   MOVE      *BLANKS       DDBTB6                                       224231
     C                   ENDIF                                                                224231
      *                                                                                       224231
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.

     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)

      ** CL Transaction type for CLS                                                          190876
                                                                                              190876
     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                              190876
     C                   EVAL      DealType = 'CL'                                            190876
     C                   ELSE                                                                 190876
     C                   EVAL      DealType = DDDLTP                                          190876
     C                   ENDIF                                                                190876
                                                                                              190876
     C/COPY WNCPYSRC,FXFXDLCC05
     C                   CALLB     'ZASETINDFT'
     C/COPY WNCPYSRC,FXFXDLCC06

      ** Output
      ** Calling function type
     C                   PARM                    FXDL
      ** Payment currency
     C                   PARM                    DDSCCY
      ** Receive currency
     C                   PARM                    DDBCCY
     C/COPY WNCPYSRC,FXFXDLCC11
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C***********        PARM                    DDDLTP                                       190876
     C                   PARM                    DealType          2                          190876
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      ** Version of ISDA Agreement century                                                    176883
     C                   PARM                    Blank2                                       176883
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDDLST                                       CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRSN                                       CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
     C/COPY WNCPYSRC,FXFXDLCC09

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************

     C     SetupAmend    BEGSR

      * For Amends, put the complete (pre-existing) deal into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVE      DealFilFmt    ValidDeal

      ***The*Settlement*Instructions*fields*may*not*be*supplied*for*an*****     CAP011
      ***amendment.*If*none*of*the*pay/receive*instructions*were***********     CAP011
      ***supplied*(i.e.*all*are*blank),*default*the*existing*database******     CAP011
      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
      *********************************************************************     CAP011
     C*******************IF************(InRecSttmt*=**blank)***************     CAP011
     C*****************************AND*(InPaySttmt*=**blank)***************     CAP011

     C**********         EVAL      DBRecSttmt = DEALRecIns + FHROBR                           CGL029
     C                   EVAL      DBRecSttmt = DEALRecIns1 + FHRONS +                        CGL029
     C                                          DEALRecIns2 + FHROBR                          CGL029
     C                   EVAL      FLRSCY     = FHRSCY
     C**********         EVAL      DBPaySttmt = DEALPayIns + FHPOBR + FHCVMR                  CGL029
     C                   EVAL      DBPaySttmt = DEALPayIns1 + FHPONS +                        CGL029
     C                                          DEALPayIns2 + FHPOBR + FHCVMR                 CGL029
     C                   EVAL      FLPSCY     = FHPSCY
     C                   EVAL      FLIC72     = FHIC72
     C     CSW212        IFEQ      'Y'                                                        CSW212
     C**********         MOVE      F3AGVC        FLAGVC                              CSW212 AR990243
     C                   EVAL      DBFRASttmt = DEALPayISDA                                 AR990243
     C                   ENDIF                                                                CSW212

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM                    CrPaySttmt                     CAP011
     C                   PARM                    CrRecSttmt                     CAP011
     C                   PARM                    CrFRASttmt                     CAP011
     C                   PARM      FHCCY1        #TRCCY                                      CSF011A
     C                   PARM      FHCCY2        #TPCCY                                      CSF011A
                                                                                CAP011
      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (InPaySttmt = *blank)                    CAP011
     C                   EVAL      InPaySttmt = CrPaySttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (InRecSttmt = *blank)                    CAP011
     C                   EVAL      InRecSttmt = CrRecSttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (InFRASttmt = *blank)                                AR990243
     C                   EVAL      InFRASttmt = CrFRASttmt                                  AR990243
     C                   ENDIF                                                              AR990243
                                                                                            AR990243
      * Do data substitution for Settlement Instructions                        CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      InPaySttmt                             99    CAP011
     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
     C  N99GHSUBS        scan      InFRASttmt                             99                AR990243
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011

      ***Defaulted*Settlement*Instruction*in*input*format**                     CAP011
     C*******************PARM********************InPaySttmt                     CAP011
     C*******************PARM********************InRecSttmt                     CAP011
     C*******************PARM********************InFRASttmt                     CAP011
      *****************************************************                     CAP011
     C*******************ENDIF*****************************                     CAP011

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

     C                   CALLB     'FXFXDLVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData                        CAP051
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data                                                              CAP004
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM      FHFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,FXFXDLCC01
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C                   PARM                    F3DTYP                                       245158
     C/COPY WNCPYSRC,FXFXDLCC03

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (DDCustOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converetd here.

     C                   IF        DDVDatOK <> 'N'

     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

      * Set the Pay Date and Receive Date = Value Date

     C                   EVAL      PayDat = ValDateMDN
     C                   EVAL      RecDat = ValDateMDN

     C                   ENDIF

      ** CL Transaction type for CLS                                                          190876
                                                                                              190876
     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                              190876
     C                   EVAL      DealType = 'CL'                                            190876
     C                   ELSE                                                                 190876
     C                   EVAL      DealType = DDDLTP                                          190876
     C                   ENDIF                                                                190876
                                                                                              190876
     C                   RESET                   ReturnCode
     C/COPY WNCPYSRC,FXFXDLCC07
     C                   CALLB     'ZASETINVAL'
     C/COPY WNCPYSRC,FXFXDLCC08

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    FXDL
      ** Transaction Fields
      ** Payment currency
     C                   PARM                    DDSCCY
      ** Receive currency
     C                   PARM                    DDBCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C***********        PARM                    DDDLTP                                       190876
     C                   PARM                    DealType                                     190876
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBRSN
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code                                                                           185751
     C                   PARM                    DDACTN                                       185751
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNamArr                                   CRE008
     C                   PARM                    WMsgIDArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
      ** Array index (3P0) from/to caller                                                     CRE008
     C                   PARM                    WIdx                                         CRE008
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input                                                                          166888
      ** Action Code used                                                                     166888
     C                   PARM      DDACTN        ##ACTN            1                          166888
      ** Validation Iteration                                                                 166888
     C                   PARM      '1ST'         ##ValIter         3                          166888
     C/COPY WNCPYSRC,FXFXDLCC10
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/*Pay*Instructions*(for*Settlm*Meth*=*04*)******              179510 200400
     C************       PARM                    @MORPI           24                   179510 200400
      ************                                                                     179510 200400

     C     ValSetExit    TAG

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
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'FXFXDLCVT'                                  CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * (Current) Deal in file format                                           CAP011
     C                   PARM                    DealFilfmt                     CAP011
                                                                                CAP011
      * OUTPUTS                                                                 CAP011
      * (Current) Deal in screen format                                         CAP011
     C                   PARM                    DealScnfmt                     CAP011
      * NET BUY/SELL REFERENCE                                                  CAP011
     C                   PARM                    DDNBRF           19            CAP011
     C                   PARM                    DDNSRF           19            CAP011
      * Deal Status                                                             CAP011
     C                   PARM                    DDSTS            24            CAP011
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranIn        IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      DealScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranIn                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InPaySttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InPaySttmt                     CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InRecSttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InRecSttmt                     CAP011
      ** Extended Settlements                                                               AR990243
     C                   RESET                   ReturnCode                                 AR990243
     C                   CALLB     'APDTASUBS'                                              AR990243
                                                                                            AR990243
      * Return Code                                                                         AR990243
     C                   PARM                    ReturnCode                                 AR990243
      * Substitution character                                                              AR990243
     C                   PARM      GHSUBS        SubsChar                                   AR990243
      * Incoming Data                                                                       AR990243
     C                   PARM      InFRASttmt    IncDATA                                    AR990243
      * Current Data                                                                        AR990243
     C                   PARM      CrFRASttmt    CurDATA                                    AR990243
                                                                                            AR990243
     C                   MOVEL     IncDATA       InFRASttmt                                 AR990243
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
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

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLCVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
      * Deal Status
     C                   PARM                    DDSTS            24

      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLAMD'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *                                                                                     MD047971
      ** Pay/rcv settlement account                                                         MD047971
      *                                                                                     MD047971
     C                   PARM                    DDRONX                                     MD047971
     C                   PARM                    DDPONX                                     MD047971
     C                   PARM                    DDRONXOK                                   MD047971
     C                   PARM                    DDPONXOK                                   MD047971

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1

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
      * Check/Write - Routine to control checking of error status and *
      *    sending of messgaes/writing to the database                *
      *                                                               *
      *****************************************************************

     C     CheckWrite    BEGSR

      *  If no errors were found:
      *  - If Action Code is Insert and Deal Number is not supplied
      *     - set up the deal number
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report deal status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report deal status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
                                                                                              190876
      ** Reject deals with warnings that exist in SDWARNPD (Warning                           190876
      ** messages considered as errors). Send the deal to the repair                          190876
      ** queue, in the same way as erroneous deals are dealt with.                            190876
                                                                                              190876
     C                   DO        WIdx          I                 3 0                        190876
                                                                                              190876
     C                   EVAL      KMsgID = WMsgIDArr(I)                                      190876
     C     *LOVAL        SETLL     SDWARNL1                                                   190876
     C     KeyWarn       CHAIN     SDWARNL1                           01                      190876
     C                   IF        *IN01 = *OFF                                               190876
     C                   ADD       1             Idx                                          190876
     C                   EVAL      MsgIDArr(Idx) = WMsgIDArr(I)                               190876
     C                   EVAL      FldNameArr(Idx) = WFldNamArr(I)                            190876
     C                   EVAL      MsgDtaArr(Idx) = WMsgDtaArr(I)                             190876
     C                   ENDIF                                                                190876
                                                                                              190876
     C                   ENDDO                                                                190876

     C     Idx           IFEQ      0

     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     FXVFXDLD0

      ** Insert DLDLDBQD record for CLE025 processing                                         247888
     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
     C     DDDLNO        CHAIN     DLDLDBD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = DDDLNO                                         247888
     C                   EVAL      DX_F1BRCA = DDBRSN                                         247888
     C                   WRITE     DLDLDBD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
      /COPY WNCPYSRC,FXFXDLC023

     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   ENDIF

     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     FXIFXDLD0
     C                   WRITE     APIDSETD0
     C/COPY WNCPYSRC,FXH00005
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + InRecSttmt                             CSC011
     C                                        + InPaySttmt                                    CSC011
     C                                        + InFRASttmt                                  AR990243
     C                                        + InfData                                       CSC011
     C                                        + ExtData                                       CSC011
     C                   EVAL      APTGTTYPE = 'FXFXDL'                                       CSC011
     C                   EVAL      PDealNum = DDDLNO                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNum                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 2                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022

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

     C                   RESET                   OKFlagsDS

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         F3RSTM
     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         F3PSTM
     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
     C                   EVAL      F3POBN = *BLANKS                                           CSD027
     C                   EVAL      F3POCN = *BLANKS                                           CSD027

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt

      * Reset Net Buy/sell Reference

     C                   CLEAR                   DDNBRF
     C                   CLEAR                   DDNSRF
     C/COPY WNCPYSRC,FXH00112

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************

     C     SETUPINVAL    BEGSR

      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'FXFXDL'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                CAP051
      * Setup the Automatic Autorisation Flag                                   CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      DDAUTH     = IF_AUTH                         CAP051
     C                   ENDIF                                                  CAP051

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,FXFXDLC017

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        F3DN38

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        F3DN38

     C                   ENDIF

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

      **For*Inserts,*put*the*Settlement*Instructions*(input*or*defaulted)***    170909
      ***into*the*Valid*file*record*****************************************    170909
                                                                                170909
      * For Inserts and Amends, put the Settlement Instructions (input or       170909
      *  defaulted) into the Valid file record.                                 170909
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')                            170909
     C                   MOVEL     DBPaySttmt    FXDLPayIns
     C                   MOVEL     FLPONS        F3PONS                                       CGL029
     C                   MOVE      FLPAY2        FXDLPayIns                                   CGL029
     C                   MOVEL     DBRecSttmt    FXDLRecIns
     C                   MOVEL     FLRONS        F3RONS                                       CGL029
     C                   MOVE      FLREC2        FXDLRecIns                                   CGL029
     C                   MOVE      FLPOBR        F3POBR
     C                   MOVE      FLROBR        F3ROBR
     C                   MOVE      FLCVMR        F3CVMR
     C                   MOVE      FLPSCY        F3PSCY
     C                   MOVE      FLRSCY        F3RSCY
     C                   MOVE      FLIC72        F3IC72
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     DBFRASttmt    FXDLPayIsda                                  CSW212
     C**********         MOVEL     FLAGVC        F3AGVC                              CSW212 AR990243
     C                   IF        FLISDA = *BLANKS                                           CSW212
     C                   EVAL      F3ISDA = *ZERO                                             CSW212
     C                   ENDIF                                                                CSW212
     C                   IF        FLAGDT = *BLANKS                                           CSW212
     C                   EVAL      F3AGDT = *ZERO                                             CSW212
     C                   ENDIF                                                                CSW212
     C                   IF        FLAGVV = *BLANKS                                           CSW212
     C                   EVAL      F3AGVV = *ZERO                                             CSW212
     C                   ENDIF                                                                CSW212
     C                   IF        FLAGVC = *BLANKS                                           CSW212
     C                   EVAL      F3AGVC = *ZERO                                             CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF

      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
      ***the*Valid*file*record**********************************************    170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
      ***(physically*separate)*fields*also*need*to*be*done******************    170909
     C*******************IF********DDACTN*=*'A'*************                    170909
     C*******************MOVE******DEALRecIns****FXDLRecIns*                    170909
     C*******************MOVE******DEALPayIns****FXDLPayIns*                    170909
     C*******************MOVE******FHPOBR********F3POBR*****                    170909
     C*******************MOVE******FHROBR********F3ROBR*****                    170909
     C*******************MOVE******FHCVMR********F3CVMR*****                    170909
     C*******************MOVE******FHPSCY********F3PSCY*****                    170909
     C*******************MOVE******FHRSCY********F3RSCY*****                    170909
     C*******************MOVE******FHIC72********F3IC72*****                    170909
     C*******************ENDIF******************************                    170909

      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      F3LACT = DDACTN

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      F3FRNT = APFOTranID
     C                   EVAL      F3AFRT = APFOAsocID
     C                   EVAL      F3REPA = APRprLocn
     C                   EVAL      F3TMESTMP = TimeStamp
                                                                                CAP051
      * Automatic Authorisation flag                                            CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      F3AUTH = IF_AUTH                             CAP051
     C                   ENDIF                                                  CAP051

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,FXFXDLC018

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

     C     FldNameArr(Ix)IFNE      *BLANKS

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   MOVEL     DDDLNO        PTranID          20                          CAP033
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
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
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    DDDLNO                                       CAP033
     C                   PARM                    PTranID                                      CAP033
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
      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
     C                   PARM                    MsgFArray                                    222373
      ** Whether or not to clear the program message queue (1A)                               222373
     C                   PARM                    ClearPgmQ                                    222373

     C                   ENDSR
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
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
     C                   PARM                    InfData500                     CAP051
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    ExtData500                     CAP004
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'DL'

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD             7            CAP011
     C                   PARM      '*FIRST '     @OPTN             7            CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011

     ****Initialise*Data*queue*parms********************************************148855
     C*******************EVAL      DtqLen = 10                                  148855
                                                                                148855
      ** Set up the name of the server/database updater data queue.             148855
     C                   EVAL      DtaQName = 'APFXDLDTQ'                       148855
      *                                                                         CAP051
      ** Access SAR details file to determine if                                CAP051
      ** Automatic Authorisation (FX Part) is installed                         CAP051
      *                                                                         CAP051
     C                   MOVEL     'N'           CAP051            1            CAP051
     C                   CALL      'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD                          CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVEL     'Y'           CAP051                         CAP051
     C                   ENDIF                                                  CAP051
                                                                                              190876
      ** Check if CDL008 is installed                                                         190876
                                                                                              190876
     C                   CALL      'AOSARDR0'                                                 190876
     C                   PARM      *BLANKS       @RTCD                                        190876
     C                   PARM      '*VERIFY'     @OPTN                                        190876
     C                   PARM      'CDL008'      @SARD                                        190876
     C     SCSARD        PARM      SCSARD        DSFDY                                        190876
                                                                                              190876
     C     @RTCD         IFEQ      *BLANK                                                     190876
     C                   MOVEL     'Y'           CDL008            1                          190876
     C                   ELSE                                                                 190876
     C                   MOVEL     'N'           CDL008                                       190876
     C                   ENDIF                                                                190876
                                                                                              190876
      ** Define key list for SDWARNL1                                                         190876
                                                                                              190876
     C     KeyWarn       KList                                                                190876
     C                   KFld                    KPgm             10                          190876
     C                   KFld                    KMsgID            7                          190876
                                                                                              190876
     C                   Eval      KPgm = 'FXFXDLCTL'                                         190876

      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBase = 1                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC012'      PSARD                                        CSC022
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
     C                   Eval      DBASE = 3                                                  CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC011
     C/COPY WNCPYSRC,FXH00032
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      ** Check if CSW212 is installed                                                         CSW212
                                                                                              CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
                                                                                              CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
     C                   ENDIF                                                                CSW212
                                                                                              CSW212
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXFXDLC022

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
