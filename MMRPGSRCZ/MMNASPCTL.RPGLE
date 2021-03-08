     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs purchased interface controller')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPCTL - NA's Purchased Interface Controller              *
      *                                                               *
      *  Function: This Program Validates MM Deals for Input into     *
      *            the Midas database.                                *
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
      *  Last Amend No. MD031031           Date 27Feb15               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA012             Date 23Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196461             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 165903             Date 18Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185751             Date 17Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 08Nov00               *
      *                 166888             Date 08Sep99               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 170909             Date 07Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 148855             Date 26Nov98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 30Jul98               *
      *                 CAP002  *CREATE    Date 16Dec97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031031 - F1DLNO missing in DLDLDnQD file for LDNI, NASP,   *
      *             NASS, FRA, CIRS and SIRS. Write to extension file *
      *             whether CLE025 is *ON or *OFF.                    *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hook added: MMNASPRD02, MMNASPC023, MMNASPCD01 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVNASPPD*
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510                                  *
      *  165903 -  Receive ccy should also allow default (just like   *
      *            the back office input MMNASPSIN).                  *
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
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
      *           it through the ZACHNDQMS module, which is included  *
      *           in the DTAQCHK* /COPYs.                             *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *           Phase 2.  Module recompiled over changed /COPY      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FMMVNASPPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FMMINASPPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FMMVNASPL0 IF   E           K DISK    RENAME(MMVNASPD0:MMVNASPCHK)
     F                                     INFSR(*pssr)                         CAP013
     FMMVNASPL1 IF   E           K DISK    RENAME(MMVNASPD0:MMVNASPCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

     FDLDEALNA  UF A E           K DISK    PREFIX(DX_)                                      MD031031
     F                                     INFSR(*pssr)                                     MD031031
     F                                     COMMIT                                           MD031031
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNASPC019
                                                                                             LLN022A
     FMMVNPEXPD O    E             DISK                                                      LLN022A
      ** API Negotiable Asset Purchased Extra Data  - valid data                             LLN022A
      *                                                                                      LLN022A
     FMMINPEXPD O    E             DISK                                                      LLN022A
      ** API Negotiable Asset Purchased Extra Data  - invalid data                           LLN022A
      *                                                                                      LLN022A
     FMMVNPLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FMMINPLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

     D TranIn        E DS                  EXTNAME(MMNASPPD)
      * Incoming Transaction

     D ValidDeal     E DS                  EXTNAME(MMVNASPPD)
      * Valid Deals layout
     D***NASPRecIns            463    531                                                     CGL029
     D***NASPPayIns            532   1090                                                     CGL029
     D NASPRecIns            477    531                                                       CGL029
     D NASPPayIns            546   1090                                                       CGL029
     D***NASPRecInsEx         1317   1334                                              CGL029 TDA012
     D***NASPPayInsEx         1335   1352                                              CGL029 TDA012
     D NASPRecInsEx         1332   1349                                                       TDA012
     D NASPPayInsEx         1350   1367                                                       TDA012
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealFilFmt    E DS                  EXTNAME(MMDENBPP)
      * (Current) Deal in File Format
     D***DENBRecIns            463    531                                                     CGL029
     D***DENBPayIns            532   1090                                                     CGL029
     D DENBRecIns            477    531                                                       CGL029
     D DENBPayIns            546   1090                                                       CGL029
     D***DENBRecInsEx         1317   1334                                              CGL029 TDA012
     D***DENBPayInsEx         1335   1352                                              CGL029 TDA012
     D DENBRecInsEx         1332   1349                                                       TDA012
     D DENBPayInsEx         1350   1367                                                       TDA012
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealScnFmt    E DS                  EXTNAME(MMNASPPD)
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
     D ESFPayIns              21    569                                                       CGL029
     D ESFPayIns2             21    565                                                       CGL029

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format
     D ESFRecIns              21     78                                                       CGL029
     D ESFRecIns2             21     75                                                       CGL029

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(MMNAIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** MM Info Data - Classe 1 Data - File (D/B) format                                     CAP086
                                                                                              CAP086
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMNPEXPD)                    CAP004
      * MM NASP Extra Data - File (D/B) format                                  CAP004
     D RegData       E DS                  EXTNAME(MMNPRXPD)                                  CER001
     D ValidLux      E DS                  EXTNAME(MMVNPLX1PD)                                CER001

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      ** External DS for Midas Modules                                                        CER001
                                                                                              CER001
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CER001
      ** External DS for dealing details                                                      CER001
                                                                                              CER001
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER001
      * Second DS for access programs - long data structure                                   CER001
                                                                                              CER001
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

     D MMNASPUPC       DS             1    DTAARA(MMNASPUPC)
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for SAR details                                                          CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
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
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
     D RegData500      S            500A                                                      CER001
     D RegDatawk       S            500A                                                      CER001
     D ULX004          S              1A                                                      CER001

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0026D2 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS

     D  DDActnOK                      1A   INZ('Y')
     D  DDDlnoOK                      1A   INZ('Y')
     D  DDMtypOK                      1A   INZ('Y')
     D  DDStypOK                      1A   INZ('Y')
     D  DDFedFOK                      1A   INZ('Y')
     D  DDDlDtOK                      1A   INZ('Y')
     D  DDBrCAOK                      1A   INZ('Y')
     D  DDBkCdOK                      1A   INZ('Y')
     D  DDBrkgOK                      1A   INZ('Y')
     D  DDIsurOK                      1A   INZ('Y')
     D  DDCsnmOK                      1A   INZ('Y')
     D  DDVDatOK                      1A   INZ('Y')
     D  DDMDatOK                      1A   INZ('Y')
     D  DDAcSqOK                      1A   INZ('Y')
     D  DDCcyOK                       1A   INZ('Y')
     D  DDFvalOK                      1A   INZ('Y')
     D  DDAmnpOK                      1A   INZ('Y')
     D  DDBokCOK                      1A   INZ('Y')
     D  DDLnkNOK                      1A   INZ('Y')
     D  DDBdidOK                      1A   INZ('Y')
     D  DDINTROK                      1A   INZ('Y')
     D  DDICMtOK                      1A   INZ('Y')
     D  DDIPFqOK                      1A   INZ('Y')
     D  DDNDatOK                      1A   INZ('Y')
     D  DDSlidOK                      1A   INZ('Y')
     D  DDDCRTOK                      1A   INZ('Y')
     D  DDIPDMOK                      1A   INZ('Y')
     D  DDmttiOK                      1A   INZ('Y')
     D  DDBRatOK                      1A   INZ('Y')
     D  DDCDRfOK                      1A   INZ('Y')
     D  DDRDFCOK                      1A   INZ('Y')
     D  DDPcliOK                      1A   INZ('Y')
     D  DDPSzeOK                      1A   INZ('Y')
     D  DDOrBrOK                      1A   INZ('Y')
     D  DDPrfCOK                      1A   INZ('Y')
     D  DDFsrpOK                      1A   INZ('Y')
     D  DDFprcOK                      1A   INZ('Y')
     D  DDOylcOK                      1A   INZ('Y')                                           CAS001
     D  DDLQPROK                      1A   INZ('Y')                                           CAS005
     D  DDLQPSOK                      1A   INZ('Y')                                           CAS005
     D  DDClasOK                      1A   INZ('Y')                                           CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')

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
     D NASP            S              4A   INZ('NASP')

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
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029

      ** Customer field for passing into ZASETINVAL
     D Customer        S                   LIKE(DDCSNM)

     ****Data*queue*parms*******************************************************148855
     D*DtqLenB*********S              9B 0                                      148855
     D*DtqFmt**********S              8A                                        148855
     D*DtqNamLib*******S             20A                                        148855
     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
     D*DtqMsgFmt*******S              8A                                        148855
     D*DtqErr**********S             50A                                        148855

     D Object          S             10A   INZ('MMNASPUPC')
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
     D CAP086          S              1A   INZ('N')                                           CAP086
     D TRANSDTL        S           5800A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011

      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D LDLNOEX         S              6A                                                     LLN022A
                                                                                             LLN022A
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
      /COPY WNCPYSRC,MMNASPC020

      ** Index for arrays for Extra Data Fields                                              LLN022A
      *                                                                                      LLN022A
     D Ij              S              3P 0                                                   LLN022A
      *                                                                                      LLN022A
     D OkBOEFlags    E DS                  EXTNAME(MMENASPX0)                                LLN022A
      *                                                                                      LLN022A
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD2                 1      6  0                                                    CER001
     D  #1DN38                 1      6                                                       CER001
     D  #1DLTP                 7      8                                                       CER001
     D  #1CNUM                 9     14                                                       CER001
     D  #1CCY                 15     17                                                       CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsLux    E DS                  EXTNAME(MMENPLX1PD)                                CER001
      *                                                                                       CER001
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,MMNASPC001

      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Infdata500    Infdata                                      CAP086
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   EVAL      RegDatawk = RegData500                                     CER001
     C                   EVAL      RegData   = RegDatawk                                      CER001

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,MMNASPC002

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

      /COPY WNCPYSRC,MMNASPC003

      *  Validate Action Code

     C                   EXSR      ValidateAc

      /COPY WNCPYSRC,MMNASPC004

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,MMNASPC005
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,MMNASPC006
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMNASPC007
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMNASPC008

      ** Execute new subroutine to validate the data from the extra data                     LLN022A
      ** file if BOE installed.                                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   EXSR      #LWINVAL                                                  LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,MMNASPC009
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,MMNASPC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMNASPC011
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMNASPC012
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,MMNASPC013

      ** Execute new subroutine to validate the data from the extra data                     LLN022A
      ** file if BOE installed.                                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   EXSR      #LWINVAL                                                  LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDSL

     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP

      /COPY WNCPYSRC,MMNASPC014

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
      /COPY WNCPYSRC,MMNASPC015
      *                                                                                       CER001
      ** ULX004 - NASP extra field validation                                                 CER001
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'                                                        CER001
     C     DDACTN        IFEQ      'I'                                                        CER001
     C     DDACTN        OREQ      'A'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsLux                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   CALLB     'MMNASP2VL'                                                CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ValidDeal                                    CER001
     C                   PARM                    BNDCSP                                       CER001
     C                   PARM                    OKFlagsLux                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLux                                     CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     DDACTN        IFEQ      'I'                                                        CER001
     C                   EXSR      SETUPDEALN                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVMFOTR = APFOTranID                                    CER001
     C                   EVAL      #6LXVMTMES = TimeStamp                                     CER001
     C                   EVAL      #6LXVMDN38 = IHDN38                                        CER001
      *                                                                                       CER001
     C                   WRITE     MMVNPLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXSUBR = L6LXSUBR                                        CER001
     C                   EVAL      #6LXMOBL = L6LXMOBL                                        CER001
     C                   EVAL      #6LXTMES = TimeStamp                                       CER001
      *                                                                                       CER001
     C                   MOVE      L6LXRISC      #6LXRISC                                     CER001
     C                   MOVE      L6LXROFC      #6LXROFC                                     CER001
     C                   MOVE      L6LXRATC      #6LXRATC                                     CER001
     C                   MOVE      L6LXSECQ      #6LXSECQ                                     CER001
     C                   MOVE      L6LXSECT      #6LXSECT                                     CER001
     C                   MOVE      L6LXEVMT      #6LXEVMT                                     CER001
     C                   MOVE      L6LXOPTP      #6LXOPTP                                     CER001
     C                   MOVE      L6LXIM93      #6LXIM93                                     CER001
     C                   MOVE      L6LXCLAT      #6LXCLAT                                     CER001
     C                   MOVE      L6LXGUAC      #6LX1UAC                                     CER001
     C                   MOVE      L6LXLUSU      #6LXLUSU                                     CER001
     C                   MOVE      L6LXCOAM      #6LXCOAM                                     CER001
     C                   WRITE     MMINPLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,MMNASPC016

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
     C*******************EVAL      DtqNamLib = 'APNASPDTQ *LIBL'                148855
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
     C*******************PARM      'APNASPDTQ'   DtqNam           10            148855
     C*******************PARM      '*LIBL'       DtqLib           10            148855
     C*******************PARM                    DtqLen            5 0          148855
     C*******************PARM      'GO'          DtqDta           10            148855
     C*******************ENDIF                                                  148855
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNASPC021

     C/EJECT                                                                                 LLN022A
      *****************************************************************                      LLN022A
      *                                                               *                      LLN022A
      * SR/#LWINVAL - Validate Screen Field                           *                      LLN022A
      *                                                               *                      LLN022A
      * Called by:                                                    *                      LLN022A
      *                                                               *                      LLN022A
      * Calls:  None                                                  *                      LLN022A
      *                                                               *                      LLN022A
      *****************************************************************                      LLN022A
     C     #LWINVAL      BEGSR                                                               LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   CLEAR                   FldNameArr                                  LLN022A
     C                   CLEAR                   MsgIdArr                                    LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'MMLNASPEXV'                                              LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    IHMATD                                      LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIdArr                                    LLN022A
     C                   PARM                    DDDLNO                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
      *                                                                                      LLN022A
      ** If valid, send data queue entry to prompt DB update program                         LLN022A
      *                                                                                      LLN022A
     C     Idx           IFEQ      0                                                         LLN022A
     C                   EXSR      #LUPDVEX                                                  LLN022A
     C                   ELSE                                                                LLN022A
     C                   EXSR      #LUPDINVEX                                                LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDSR                                                               LLN022A
     C/EJECT                                                                                 LLN022A
      *****************************************************************                      LLN022A
      *                                                               *                      LLN022A
      * SR/#LUPDVEX - Update Extra Date VAlid File                    *                      LLN022A
      *                                                               *                      LLN022A
      * Called by: #LWINVAL                                           *                      LLN022A
      *                                                               *                      LLN022A
      * Calls:  None                                                  *                      LLN022A
      *                                                               *                      LLN022A
      *****************************************************************                      LLN022A
     C     #LUPDVEX      BEGSR                                                               LLN022A
      *                                                                                      LLN022A
      ** Move Extra data values into the Extra Data Valid Field Values                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      LDLNOEX       LDLNOEXV                                    LLN022A
     C                   MOVE      LGTEEEX       LGTEEEXV                                    LLN022A
     C                   MOVE      LQUALEX       LQUALEXV                                    LLN022A
     C                   MOVE      LFMATEX       LFMATEXV                                    LLN022A
                                                                                             LLN022A
     C                   WRITE     MMVNPEXD0                                                 LLN022A
                                                                                             LLN022A
     C                   ENDSR                                                               LLN022A
     C/EJECT                                                                                 LLN022A
      *****************************************************************                      LLN022A
      *                                                               *                      LLN022A
      * SR/#LUPDINVEX - Update Extra Date Invalid File                *                      LLN022A
      *                                                               *                      LLN022A
      * Called by: #LWINVAL                                           *                      LLN022A
      *                                                               *                      LLN022A
      * Calls:  None                                                  *                      LLN022A
      *                                                               *                      LLN022A
      *****************************************************************                      LLN022A
     C     #LUPDINVEX    BEGSR                                                               LLN022A
      *                                                                                      LLN022A
      ** Move Extra data values into the Extra Data Invalid Field Values                     LLN022A
      *                                                                                      LLN022A
     C                   MOVE      LDLNOEX       LDLNOEXINV                                  LLN022A
     C                   MOVE      LGTEEEX       LGTEEEXINV                                  LLN022A
     C                   MOVE      LQUALEX       LQUALEXINV                                  LLN022A
     C                   MOVE      LFMATEX       LFMATEXINV                                  LLN022A
     C                   MOVE      APFOTRANID    LAFRTI                                      LLN022A
     C                   MOVE      TimeStamp     LTMSTI                                      LLN022A
                                                                                             LLN022A
     C                   WRITE     MMINPEXD0                                                 LLN022A
                                                                                             LLN022A
     C                   ENDSR                                                               LLN022A
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
     C     APFOTranID    CHAIN     MMVNASPL0                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     APFOTranID    CHAIN     MMVNASPL0                          99

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
     C                   MOVEL     DDDLNO        IHDN38                         CAP013
     C     IHDN38        CHAIN     MMVNASPL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     IHDN38        CHAIN     MMVNASPL1                          99        CAP013
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
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the MM database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'MMNASPRTV'

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

      * (Midas) Deal Number
     C                   PARM                    DDDLNO

      * Booking branch
     C                   PARM                    DDBRCA

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK

      * OK - Deal Number
     C                   PARM                    DDDlnoOK

      * OK - Booking branch
     C                   PARM                    DDBrcaOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004

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

     C/COPY WNCPYSRC,MMNASPCC01
     C                   CALLB     'ZASETINDFT'
     C/COPY WNCPYSRC,MMNASPCC02

      ** Output
      ** Calling function type
     C                   PARM                    NASP
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C**********         PARM                    Blank3                                       165903
     C                   PARM                    DDCcy                                        165903
     C/COPY WNCPYSRC,MMNASPCC07
      ** Customer (shortname or number)
     C                   PARM                    DDCsnm
      ** Deal type
     C                   PARM                    DDMTYP
      ** Federal Funds Ind.
     C                   PARM                    DDFedF
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
     C/COPY WNCPYSRC,MMNASPCC05

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

     C                   EVAL      FLRSTM     = HLRSTM                                        CGL029
     C                   EVAL      FLRONS     = DENBRecInsEx                                  CGL029
     C                   EVAL      ESFRecIns  = DENBRecIns + HLROBR                           CGL029
     C**********         EVAL      DBRecSttmt = DENBRecIns + HLROBR                           CGL029
     C                   EVAL      FLRSCY     = HLSTCY
     C                   EVAL      FLPSTM     = HLPSTM                                        CGL029
     C                   EVAL      FLPONS     = DENBPayInsEx                                  CGL029
     C                   EVAL      ESFPayIns  = DENBPayIns + HLPOBR + HLCVMR                  CGL029
     C**********         EVAL      DBPaySttmt = DENBPayIns + HLPOBR + HLCVMR                  CGL029
     C                   EVAL      FLPSCY     = HLSTCY
     C                   EVAL      FLIC72     = HLIC72

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
     C                   PARM      HLCCY         InRCCY                                      CSF011A
     C                   PARM      HLCCY         InPCCY                                      CSF011A
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
      * ValidateTr - Routine to validate the main transaction details *
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

     C                   CALLB     'MMNASPVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data                                                              CAP004
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
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

      * Set the Pay Date = Value Date

     C                   EVAL      PayDat = ValDateMDN

     C                   ENDIF

      * For deal type C1, use the issuer as the counterparty customer;
      * otherwise use the bought from customer.
     C                   IF        DDMTYP = 'C1'
     C                   EVAL      Customer = DDISUR
     C                   ELSE
     C                   EVAL      Customer = DDCSNM
     C                   END

     C                   RESET                   ReturnCode
     C/COPY WNCPYSRC,MMNASPCC03
     C                   CALLB     'ZASETINVAL'
     C/COPY WNCPYSRC,MMNASPCC04

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    NASP
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    Customer
      ** Deal type
     C                   PARM                    DDMTYP
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBrCA
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
     C/COPY WNCPYSRC,MMNASPCC06

      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI           24                   179510 200400

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
     C                   CALLB     'MMNASPCVT'                                  CAP011
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
     C                   CALLB     'MMNASPCVT'

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
     C                   CALLB     'MMNASPAMD'

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

     C     Idx           IFEQ      0

     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     MMVNASPD0
     C                   EXSR      CallMsgHdl
      ** Insert DLDLDDQD record
     C                   IF        DDACTN = 'I'                                             MD031031
     C     DDDLNO        CHAIN     DLDLDDD0                           12                    MD031031
     C     *IN12         IFEQ      *ON                                                      MD031031
     C                   EVAL      DX_F1DLNO = DDDLNO                                       MD031031
     C                   EVAL      DX_F1BRCA = DDBRCA                                       MD031031
     C                   WRITE     DLDLDDD0                                                 MD031031
     C                   ENDIF                                                              MD031031
     C                   ENDIF                                                              MD031031
     C                   ENDIF

     C                   ENDIF

     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     MMINASPD0
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
     C                                        RegData    +                                    CER001
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE  = 'MMNASP'                                      CSC011
     C                   EVAL      PDealNo = DDDLNO                                           CSC011
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

     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022

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
     C                   Z-ADD     *ZERO         IHRSTM
     C**********         Z-ADD     *ZERO         IHROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IHROCN                                       CSD027
     C                   EVAL      IHROBN = *BLANKS                                           CSD027
     C                   EVAL      IHROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IHPSTM
     C**********         Z-ADD     *ZERO         IHPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IHPOCN                                       CSD027
     C                   EVAL      IHPOBN = *BLANKS                                           CSD027
     C                   EVAL      IHPOCN = *BLANKS                                           CSD027

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
     C                   EVAL      DDMsgType  = 'MMNASP'
     C                   EVAL      DDFOtranID = APFOTranID                      170909
     C                   EVAL      FRONTOFFID = APFOTRANID

     C                   EVAL      REPAIRLOC  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                              CAP086
      ** Setup the Automatic Autorisation Flag                                                CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,MMNASPC017

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
     C                   PARM      *ZEROS        IHDN38

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
     C                   MOVE      DDDLNO        IHDN38

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
     C**********         MOVEL     DBPaySttmt    NASPPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    NASPRecIns                                   CGL029
     C                   MOVEL     ESFPayIns2    NASPPayIns                                   CGL029
     C                   MOVEL     ESFRecIns2    NASPRecIns                                   CGL029
     C                   MOVEL     FLRSTM        IHRSTM                                       CGL029
     C                   MOVEL     FLPSTM        IHPSTM                                       CGL029
     C                   MOVEL     FLRONS        NASPRecInsEx                                 CGL029
     C                   MOVEL     FLPONS        NASPPayInsEx                                 CGL029
     C                   MOVE      FLPOBR        IHPOBR
     C                   MOVE      FLROBR        IHROBR
     C                   MOVE      FLCVMR        IHCVMR
     C                   MOVE      FLPSCY        IHSTCY
     C                   MOVE      FLIC72        IHIC72
     C                   ENDIF

      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
      ***the*Valid*file*record**********************************************    170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
      ***(physically*separate)*fields*also*need*to*be*done******************    170909
     C*******************IF********DDACTN*=*'A'*************                    170909
     C*******************MOVE******DENBRecIns****NASPRecIns*                    170909
     C*******************MOVE******DENBPayIns****NASPPayIns*                    170909
     C*******************MOVE******HLPOBR********IHPOBR*****                    170909
     C*******************MOVE******HLROBR********IHROBR*****                    170909
     C*******************MOVE******HLCVMR********IHCVMR*****                    170909
     C*******************MOVE******HLSTCY********IHSTCY*****                    170909
     C*******************MOVE******HLIC72********IHIC72*****                    170909
     C*******************ENDIF******************************                    170909

      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IHLACT = DDACTN

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      IHFRNT = APFOTranId
     C                   EVAL      IHAFRT = APFOAsocId
     C                   EVAL      IHREPA = APRprLocn
     C                   EVAL      IHTMESTMP = TimeStamp
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      IHAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,MMNASPC018

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
     C                   PARM                    APFOTranid
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
     C***********        PARM                    DDDLNO                                       CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
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
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    RegData500                                   CER001
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
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
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
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
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
     C                   EVAL      DBPGM = 'MMNASPCTL'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 903                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN012                                      LLN022A
      ** FSA Liquidity Report LR extract is installed.                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN012            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN012'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN012 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN012 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A

     ****Initialise*Data*queue*parms********************************************148855
     C*******************EVAL      DtqLen = 10                                  148855
                                                                                148855
      ** Set up the name of the server/database updater data queue.             148855
     C                   EVAL      DtaQName = 'APNASPDTQ'                       148855

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNASPC022
      *                                                                                      LLN022A
      ** If FSA Liquidity Report LR extract is installed allocate                            LLN022A
      ** extra data file fields, field sequence positions and field                          LLN022A
      ** name positions in the associated arrays.                                            LLN022A
      *                                                                                      LLN022A
     C     LLN012        IFEQ      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      *BLANKS       DlnoFLag          1                         LLN022A
     C                   MOVE      *BLANKS       GteeFlag          1                         LLN022A
     C                   MOVE      *BLANKS       QualFlag          1                         LLN022A
     C                   MOVE      *BLANKS       FmatFlag          1                         LLN022A
                                                                                             LLN022A
     C                   Z-ADD     1             Ij                                          LLN022A
     C     Ij            DOWLT     200                                                       LLN022A
                                                                                             LLN022A
     C     FieldArr(Ij)  IFEQ      *BLANKS                                                   LLN022A
     C     DlnoFlag      ANDNE     'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      'LDLNOEX'     FieldArr(Ij)                                LLN022A
     C                   MOVE      '90001'       FldSeqArr(Ij)                               LLN022A
     C                   MOVE      'Y'           DlnoFlag                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C     FieldArr(Ij)  IFEQ      *BLANKS                                                   LLN022A
     C     GteeFlag      ANDNE     'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      'LGTEEEX'     FieldArr(Ij)                                LLN022A
     C                   MOVE      '90002'       FldSeqArr(Ij)                               LLN022A
     C                   MOVE      'Y'           GteeFlag                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C     FieldArr(Ij)  IFEQ      *BLANKS                                                   LLN022A
     C     QualFlag      ANDNE     'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      'LQUALEX'     FieldArr(Ij)                                LLN022A
     C                   MOVE      '90003'       FldSeqArr(Ij)                               LLN022A
     C                   MOVE      'Y'           QualFlag                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C     FieldArr(Ij)  IFEQ      *BLANKS                                                   LLN022A
     C     FmatFlag      ANDNE     'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      'LFMATEX'     FieldArr(Ij)                                LLN022A
     C                   MOVE      '90004'       FldSeqArr(Ij)                               LLN022A
     C                   MOVE      'Y'           FmatFlag                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ADD       1             Ij                                          LLN022A
                                                                                             LLN022A
     C                   ENDDO                                                               LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*FIRST '     POPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
                                                                                              CER001
      ** Database error                                                                       CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANK                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = POPTN                                              CER001
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX004 - MMNASP Luxembourg Extra fields                                              CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX004'      PSARD                                        CER001
                                                                                              CER001
      ** Database error                                                                       CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANK AND PRTCD <> '*NRF'                        CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = PSARD                                              CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   OPEN      MMVNPLX1PD                                                 CER001
     C                   OPEN      MMINPLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access Dealing details via access program                                            CER001
      ** (database error handling done in access program)                                     CER001
      *                                                                                       CER001
     C                   CALLB     'AODEALR1'                                                 CER001
     C                   PARM      *BLANK        PRTCD                                        CER001
     C                   PARM      '*FIRST '     POPTN                                        CER001
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CER001
                                                                                              CER001
      ** Database error                                                                       CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANK                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = POPTN                                              CER001
     C                   EVAL      DBFILE = 'SDDEALPD'                                        CER001
     C                   EVAL      DBASE = 905                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,MMH00036

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
