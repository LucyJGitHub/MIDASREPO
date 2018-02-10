     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments interface controller')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMCTL - Deal Amendments Interface Controller             *
      *                                                               *
      *  Function: This Program Validates MM Deal Amendments for input*
      *            into the Midas database.
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert)                                  *
      *              - If ALL of the settlement fields are blank, set *
      *                them up from standard settlement instructions  *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the deal fields                       *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this deal and bypass remaining validation*
      *              bypass the field validation                      *
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
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260028             Date 29Apr09               *
      *                 250430             Date 13Nov07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSC024             Date 07Feb05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CRE008             Date 19Feb02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204887             Date 10Jul02               *
      *                 196461             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 194994             Date 27Jun01               *
      *                 165903             Date 18Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 30Nov00               *
      *                 185751             Date 17Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      *                 166888             Date 08Sep99               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 170909             Date 07Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 148855             Date 26Nov98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 30Jul98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSC054 - Period End Adjusetments                             *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  260028 - Pass sequence number and value date  on replyQ      *
      *  250430 - Include sequence number and value date on reply.    *
      *           PTranID now contains DEALNO, SEQNO & VALUEDATE prior*
      *           to calling ZAMSGHNDLE.                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC024 - Open Month End                                      *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *                                                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVDEAMPD*
      *  204887 - Module ID and transaction numbers are incorrectly   *
      *           passed to ZAMSGHNDLE.                               *
      *  196461 - Additional parameter ##PREC and ##PPAY to ZASETINVAL*
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510                                  *
      *  194994 - Extra data layout file should be MMDAEXPD not       *
      *           MMLDEXPD.                                           *
      *  165903 -  Receive ccy should also allow default (just like   *
      *            the back office input MMDEAMSIN).                  *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
      *           to be used in the validation.                       *
      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
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
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
      *           it through the ZACHNDQMS module, which is included  *
      *           in the DTAQCHK* /COPYs.                             *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *           Phase 2.                                            *
      *           Replacement by /COPYs of arrays that was not done   *
      *           before original collection.  This has been done     *
      *           without annotation to keep this module concistent   *
      *           with all of the others.                             *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FMMVDEAMPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FMMIDEAMPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FMMVDEAML0 IF   E           K DISK    RENAME(MMVDEAMD0:MMVDEAMCHK)
     F                                     INFSR(*pssr)                         CAP013
     FMMVDEAML1 IF   E           K DISK    RENAME(MMVDEAMD0:MMVDEAMCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                              CSD095
     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
     F                                     INFSR(*PSSR)                                       CSD095
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMDEAMC019
 
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
 
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
     D TranIn        E DS                  EXTNAME(MMDEAMPD)
      * Incoming Transaction
 
     D ValidDeal     E DS                  EXTNAME(MMVDEAMPD)
      * Valid Deals layout
     D*MMVDRecIns            300    368                                                       CGL029
     D*MMVDPayIns            369    927                                                       CGL029
     D MMVDRecIns            314    368                                                       CGL029
     D MMVDPayIns            383    927                                                       CGL029
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
 
     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
      * (Current) Deal in File Format
     D*DEAMRecIns            300    368                                                       CGL029
     D DEAMRecIns1           300    301                                                       CGL029
     D DEAMRecIns2           314    368                                                       CGL029
     D*DEAMPayIns            369    927                                                       CGL029
     D DEAMPayIns1           369    370                                                       CGL029
     D DEAMPayIns2           383    927                                                       CGL029
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
 
     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
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
                                                                                CAP051
     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
      * MM Extra Data - Classe 1 Data - File (D/B) format                       CAP051
     D                                     PREFIX(IF_)                          CAP051
                                                                                CAP004
     D*ExtData****   E DS                  EXTNAME(MMLDEXPD)             CAP004 194994
     D ExtData       E DS                  EXTNAME(MMDAEXPD)                    194994
      * MM Extra Data - File (D/B) format                                       CAP004
                                                                                CAP051
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
      ** External DS for SAR details                                            CAP051
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
 
     D                 DS
     D**  Data Structure to parameter date passed to mm0085
     D  @PDAT                  1      8  0
     D  @PDYY                  1      4  0
     D  @PYEAR                 3      4  0
     D  @PDMM                  5      6  0
     D  @PDDD                  7      8  0
 
     D                 DS
     D**  Data Structure for screen value date
     D  @VDAT                  1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6
 
     D*DtqRec**********DS            54                                         148855
     ******DS*for*Data*Queue****************************************************148855
     D**MsgNumber******        8     11B 0                                      148855
     D*DtqMsgSel*******DS             7                                         148855
     D**MsgType********        1      1    INZ('F')                             148855
     D**MsgBytes*******        4      7B 0                                      148855
 
     D MMDEAMUPC       DS             1    DTAARA(MMDEAMUPC)
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
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
     D  DDVDatOK                      1A   INZ('Y')
     D  DDDS38OK                      1A   INZ('Y')
     D  DDCsnmOK                      1A   INZ('Y')
     D  DDMTypOK                      1A   INZ('Y')
     D  DDIntrOK                      1A   INZ('Y')
     D  DDCcyOK                       1A   INZ('Y')
     D  DDAmnpOK                      1A   INZ('Y')
     D  DDFsrpOK                      1A   INZ('Y')
     D  DDPenPOK                      1A   INZ('Y')                                           CDL017
     D  DDEmdtOK                      1A   INZ('Y')                                           CDL017
     D  DDBsrtOK                      1A   INZ('Y')                                           CDL022
     D  DDAirOK                       1A   INZ('Y')                                           CDL020
 
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
 
      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** A code to indicate the calling function to the lower level modules
     D DEAM            S              4A   INZ('DEAM')
 
      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)
 
      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0
 
      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank1          S              1A   INZ(*BLANKS)
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     ****Data*queue*parms*******************************************************148855
     D*DtqLenB*********S              9B 0                                      148855
     D*DtqFmt**********S              8A                                        148855
     D*DtqNamLib*******S             20A                                        148855
     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
     D*DtqMsgFmt*******S              8A                                        148855
     D*DtqErr**********S             50A                                        148855
 
     D Object          S             10A   INZ('MMDEAMUPC')
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
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PDealNo         S             18A                                               CSC011 CGL029
     D*PADealNo        S             18A                                               CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
 
      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
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
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMDEAMC020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,MMDEAMC001
 
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
 
      /COPY WNCPYSRC,MMDEAMC002
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
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
      * by previous chain to valid deams file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,MMDEAMC003
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,MMDEAMC004
 
      *
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,MMDEAMC005
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,MMDEAMC006
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMDEAMC007
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMDEAMC008
 
     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,MMDEAMC009
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,MMDEAMC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMDEAMC011
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMDEAMC012
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,MMDEAMC013
 
     C                   ENDSL
 
     C     INVALID       TAG
 
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,MMDEAMC014
 
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
      /COPY WNCPYSRC,MMDEAMC015
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,MMDEAMC016
 
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
     C*******************EVAL      DtqNamLib = 'APDEAMDTQ *LIBL'                148855
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
     C*******************PARM      'APDEAMDTQ'   DtqNam           10            148855
     C*******************PARM      '*LIBL'       DtqLib           10            148855
     C*******************PARM                    DtqLen            5 0          148855
     C*******************PARM      'GO'          DtqDta           10            148855
     C*******************ENDIF                                                  148855
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMDEAMC021
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValDeal - Routine to check if valid deal exists for        *
      *    Front Office ID                                            *
      *                                                               *
      *****************************************************************
 
     C     ChkValDeal    BEGSR
 
      * Check for deal on Valid file
     C                   MOVE      APFOASOCID    OrigDealNo       20
     C                   MOVE      APFOTRANID    UniqDeamID       20
 
     C     OrigDealNo    CHAIN     MMVDEAML0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     OrigDealNo    CHAIN     MMVDEAML0                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
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
     C                   MOVEL     DDDLNO        IGDA38                         CAP013
     C     IGDA38        CHAIN     MMVDEAML1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     IGDA38        CHAIN     MMVDEAML1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
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
     C                   MOVEL     APFOTranID    WFrontId          2            CPB002
      *                                                                         CPB002
     C     DDACTN        IFEQ      'I'                                          CAP013
     C     WFrontId      ANDNE     'TO'                                         CPB002
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number of the original deal
      * The deam in file format from the MM database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'MMDEAMRTV'
 
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
 
      * Value Date
     C                   PARM                    DDVDAT
      *
      * Sequence Number
     C                   PARM                    DDDS38
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Deal Number
     C                   PARM                    DDDlnoOK
 
      * OK - Value Date
     C                   PARM                    DDVDatOK
 
      * OK - Sequence Number
     C                   PARM                    DDDS38OK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
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
 
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
 
      * Deal Amendment types 'SC' and 'CI' should have no settlement
      * instructions; initialise pay and receive settlement methods.
 
     C     DDMTYP        IFEQ      'SC'
     C     DDMTYP        OREQ      'CI'
     C                   MOVEL     '00'          DDPSTM
     C                   MOVEL     '00'          DDRSTM
     C                   GOTO      EDFTSETT
     C                   ENDIF
 
      ** Retrieve the subtype and branch associated with the deal                             CSD095
                                                                                              CSD095
     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
                                                                                              CSD095
     C                   MOVEL     DDDLNO        WDLNO             6 0                        CSD095
     C     WDLNO         CHAIN     DLDLDCL1                                                   CSD095
     C                   IF        %FOUND(DLDLDCL1)                                           CSD095
     C                   EVAL      DDSTYP = DC_DLST                                           CSD095
     C                   EVAL      DDBRCA = DC_BRCA                                           CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   CALLB     'ZASETINDFT'
 
      ** Output
      ** Calling function type
     C                   PARM                    DEAM
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C**********         PARM                    Blank3                                       165903
     C                   PARM                    DDCcy                                        165903
     C/COPY WNCPYSRC,MMDEAMCC02
      ** Customer (shortname or number)
     C                   PARM                    DDCsnm
      ** Deal type
     C                   PARM                    DDMTyp
      ** Federal Funds Ind. (not applicable for DEAMS)
     C                   PARM                    Blank1
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
     C                   PARM                    DDSTYP            2                          CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRCA            3                          CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
 
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
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
      *
      * LOAN OR DEPOSIT TYPE DEAL?  (FROM RETRIEVE FUNCTION)
      *
     C     HNOMDT        IFEQ      'IT'
     C     HNOMDT        OREQ      'TD'
     C     HNOMDT        OREQ      'CI'
     C     HNOMDT        OREQ      'CD'
     C                   MOVEL     'D'           W#LOD             1
     C                   ELSE
     C                   MOVEL     'L'           W#LOD
     C                   END
 
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
 
     C     DDMTYP        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     DDMTYP        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     DDMTYP        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
      *
     C                   CLEAR                   InRecSttmt
     C                   MOVEL     '00'          DDRSTM
      *
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
      *
     C     DDMTYP        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     DDMTYP        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     DDMTYP        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
      *
     C                   CLEAR                   InPaySttmt
     C                   MOVEL     '00'          DDPSTM
 
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C     EDFTSETT      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) deam into the
      *  Valid file record - fields in this will be updated during
      *  processing
     C                   MOVE      DealFilFmt    ValidDeal
 
      ***The*Settlement*Instructions*fields*may*not*be*supplied*for*an*****     CAP011
      ***amendment.*If*none*of*the*pay/receive*instructions*were***********     CAP011
      ***supplied*(i.e.*all*are*blank),*default*the*existing*database******     CAP011
      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
      *********************************************************************     CAP011
     C*******************IF************(InRecSttmt*=**blank)***************     CAP011
     C*****************************AND*(InPaySttmt*=**blank)***************     CAP011
 
     C**********         EVAL      DBRecSttmt = DEAMRecIns + HNOSBR                           CGL029
     C                   EVAL      DBRecSttmt = DEAMRecIns1 + HNRONS +                        CGL029
     C                                          DEAMRecIns2 + HNOSBR                          CGL029
     C                   EVAL      FLRSCY     = HNSTCY
     C**********         EVAL      DBPaySttmt = DEAMPayIns + HNOSBR + HNCVMR                  CGL029
     C                   EVAL      DBPaySttmt = DEAMPayIns1 + HNPONS +                        CGL029
     C                                          DEAMPayIns2 + HNOSBR + HNCVMR                 CGL029
     C                   EVAL      FLPSCY     = HNSTCY
     C                   EVAL      FLIC72     = HNIC72
 
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
     C                   PARM      HNCCY         InRCCY                                      CSF011A
     C                   PARM      HNCCY         InPCCY                                      CSF011A
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
      * Do data substitution for Settlement Instructions                        CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      InPaySttmt                             99    CAP011
     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
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
 
     C                   CALLB     'MMDEAMVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData                        CAP051
      * Extra Data                                                              CAP004
     C                   PARM                    ExtData                        CAP004
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
     C                   IF        NOT (DDCsnmOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converted here.
 
     C                   IF        DDVDatOK <> 'N'
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      * For Deal Amendments set the Pay Date and Receive Date = Value Date
     C                   EVAL      PayDat = ValDateMDN
     C                   EVAL      RecDat = ValDateMDN
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    DEAM
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCsnm
      ** Deal type
     C                   PARM                    DDMtyp
      ** Federal Funds Ind.
     C                   PARM                    Blank1
      ** Booking Branch
     C                   PARM                    Blank3
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
 
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
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
     C                   CALLB     'MMDEAMCVT'                                  CAP011
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
      * Deal Status                                                             CAP011
     C                   PARM                    DDSTS                          CAP011
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
     C                   CALLB     'MMDEAMCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'MMDEAMAMD'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
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
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *  - If Action Code is Insert
      *     - set up the deal amendment sequence number
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
 
     C     Idx           IFEQ      0
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     MMVDEAMD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     MMIDEAMD0
     C                   WRITE     APIDSETD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn +                                        CSC011
     C                                        InRecSttmt +                                    CSC011
     C                                        InPaySttmt +                                    CSC011
     C                                        InfData +                                       CSC011
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE  = 'MMDEAM'                                      CSC011
     C                   EVAL      PDealNo  = DDDLNO                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = DDDLNO                                             CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C/COPY WNCPYSRC,MMDEAMCC01
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
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
 
     C                   RESET                   AmendOK
 
     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         IGRSTM
     C**********         Z-ADD     *ZERO         IGROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IGROCN                                       CSD027
     C                   EVAL      IGROBN = *BLANKS                                           CSD027
     C                   EVAL      IGROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IGPSTM
     C**********         Z-ADD     *ZERO         IGPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IGPOCN                                       CSD027
     C                   EVAL      IGPOBN = *BLANKS                                           CSD027
     C                   EVAL      IGPOCN = *BLANKS                                           CSD027
 
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
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'MMDEAM'
     C                   EVAL      DDFOTRANID = APFOTRANID
     C                   EVAL      DDFOASOCID = APFOASOCID
     C                   EVAL      DDRPRLOCN  = APRPRLOCN
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                CAP051
      * Setup the Automatic Autorisation Flag                                   CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      DDAUTH     = IF_AUTH                         CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,MMDEAMC017
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
      *              for Inserts.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPDASEQ    BEGSR
 
      **  Load deal number into numeric field passed to MM0085
 
     C                   MOVE      DDDLNO        DealNo            6 0
 
      ** Format Value Date
 
     C     DDVDAT        IFNE      *BLANKS                                      B1
      *
      ** Load value date to numeric keyfield,in YYYYMMDD format
      *
     C                   MOVE      DDVDAT        @VDAT
 
     C                   Z-ADD     0             @PDAT                          **2
     C                   MOVE      @DSPY         @PYEAR                         **2
     C     BJDFIN        IFEQ      'D'                                                         BHF18
     C                   MOVE      @DSPD         @PDDD                          **2
     C                   ELSE                                                                  BHF18
     C                   MOVE      @DSPD         @PDMM                                         BHF18
     C                   END                                                                   BHF18
     C     BJDFIN        IFEQ      'D'                                                         BHF18
     C                   MOVE      @DSPM         @PDMM                          **2
     C                   ELSE                                                                  BHF18
     C                   MOVE      @DSPM         @PDDD                                         BHF18
     C                   END                                                                   BHF18
      *
      ** Century
     C     @PYEAR        IFGE      72                                           B**3
     C     @PDYY         ADD       1900          @PDYY                          ***3
     C                   ELSE                                                   ***3
     C     @PDYY         ADD       2000          @PDYY                          ***3
     C                   END                                                    E**3
     C                   ELSE                                                   X1
     C                   Z-ADD     0             @PDAT                          *1
     C                   END                                                    E1
 
     C                   Z-ADD     @PDAT         ValueDate         8 0
 
      ***Bypass*generation*of*Seq*number*for*Insert*if*CSC024*is                       CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Bypass generation of Seq number for Insert if CSC054 is                              CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C**********         IF        CSC024 <> 'Y'  OR                                   CSC024 CSC054
     C**********                   WOMEInd <> 'Y' OR                                   CSC024 CSC054
     C                   IF        CSC054 <> 'Y'  OR                                          CSC054
     C                             WPEAInd <> 'Y' OR                                          CSC054
     C                             DDDS38 = *BLANKS                                           CSC024
                                                                                              CSC024
      ** Generate DEAM Sequence Number
     C                   CALLB     'MM0085'
     C                   PARM      *BLANK        Term              1
     C                   PARM                    DealNo
     C                   PARM                    ValueDate
     C                   PARM                    SeqNoPack         3 0
 
     C     Term          IFNE      *BLANK
     C                   MOVE      'N'           DDDlnoOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMM0146'
     C                   ELSE
     C                   Z-ADD     SeqNoPack     IGDS38
     C                   ENDIF
                                                                                              CSC024
     C                   ELSE                                                                 CSC024
     C                   MOVEL     DDDS38        IGDS38                                       CSC024
     C                   ENDIF                                                                CSC024
 
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
     C**********         MOVEL     DBPaySttmt    MMVDPayIns                                   CGL029
     C                   MOVE      FLPSTM        IGPSTM                                       CGL029
     C                   MOVEL     FLPONS        IGPONS                                       CGL029
     C                   MOVE      FLPAY2        MMVDPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    MMVDRecIns                                   CGL029
     C                   MOVE      FLRSTM        IGRSTM                                       CGL029
     C                   MOVEL     FLRONS        IGRONS                                       CGL029
     C                   MOVE      FLREC2        MMVDRecIns                                   CGL029
     C     FLPOBR        IFNE      *BLANKS
     C                   MOVE      FLPOBR        IGOSBR
     C                   ELSE
     C                   MOVE      FLROBR        IGOSBR
     C                   END
     C                   MOVE      FLCVMR        IGCVMR
     C                   MOVE      FLPSCY        IGSTCY
     C                   MOVE      FLIC72        IGIC72
     C                   ENDIF
 
      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into******     170909
      ***the*Valid*file*record*********************************************     170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few**     170909
      ***(physically*separate)*fields*also*need*to*be*done*****************     170909
     C*******************IF********DDACTN*=*'A'*************                    170909
     C*******************MOVE******DEAMRecIns****MMVDRecIns*                    170909
     C*******************MOVE******DEAMPayIns****MMVDPayIns*                    170909
     C*******************MOVE******HNOSBR********IGOSBR*****                    170909
     C*******************MOVE******HNCVMR********IGCVMR*****                    170909
     C*******************MOVE******HNSTCY********IGSTCY*****                    170909
     C*******************MOVE******HNIC72********IGIC72*****                    170909
     C*******************ENDIF******************************                    170909
 
      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IGLACT = DDACTN
 
      * Include Header fields that need to be o/p to the Valid file
 
     C                   MOVE      DDDLNO        IGDA38
 
     C                   EVAL      IGFRNT = APFOTranID
     C                   EVAL      IGAFRT = APFOAsocID
     C                   EVAL      IGREPA = APRprLocn
     C                   EVAL      IGTMESTMP = TimeStamp
                                                                                CAP051
      * Automatic Authorisation flag                                            CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      IGAUTH = IF_AUTH                             CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,MMDEAMC018
 
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
                                                                                              260028
     C                   MOVE      *BLANKS       WDEALSEQ          9                          260028
     C                   MOVE      *BLANKS       PTranID          20                          260028
     C                   MOVEL     DDDLNO        WDEALSEQ                                     260028
     C                   MOVE      IGDS38        WDEALSEQ                                     260028
     C                   EVAL      PTranID = WDEALSEQ + DDVDAT                                260028
 
     C                   MOVE      *BLANKS       WDEALSEQ          9                          250430
     C                   MOVE      *BLANKS       PTranID          20                          250430
     C                   MOVEL     DDDLNO        WDEALSEQ                                     250430
     C                   MOVE      IGDS38        WDEALSEQ                                     250430
     C                   EVAL      PTranID = WDEALSEQ + DDVDAT                                250430
     C**********         MOVEL     DDDLNO        PTranID          20                   CAP033 250430
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
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
     C                   PARM                    APFOTRANID
      ***Midas*module*ID*(2A)**************************************************************** CAP033
     C*******************Parm********************ModuleID************************************ CAP033
      ** Midas Module ID (2A)                                                                 204887
      *                                                                                       204887
     C                   PARM                    ModuleID                                     204887
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    DDDLNO                                       CAP033
     C                   PARM                    PTranID                                      CAP033
      ***Midas*transaction ID (6A, from caller)                                               204887
     C**********         PARM                    DDDLNO                                       204887
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
     C                   PARM                    ClearPgmQ         1                          222373
 
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
 
      ** Key List for MMVDEAML0
 
     C     FrntOfKey     KLIST
     C                   KFLD                    UniqDeamID       20
     C                   KFLD                    OrigDealNo       20
 
     ****Initialise*Data*queue*parms********************************************148855
     C*******************EVAL      DtqLen = 10                                  148855
                                                                                148855
      ** Set up the name of the server/database updater data queue.             148855
     C                   EVAL      DtaQName = 'APDEAMDTQ'                       148855
      *                                                                         CAP051
      ** Access SAR details file to determine if                                CAP051
      ** Automatic Authorisation (MM Part) is installed                         CAP051
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
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMDEAMC022
 
      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'MMDEAMCTL'                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 902                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      ***Check if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C***********        PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C***********        EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
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
                                                                                              CSC024
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
