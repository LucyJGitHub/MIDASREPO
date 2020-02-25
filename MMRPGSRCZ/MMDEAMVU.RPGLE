     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments validate and update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMVU - Deal Amendments validate and update               *
      *                                                               *
      *  Function: This Program Validates MM Deal Amendments for input*
      *            into the Midas database and updates if required    *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055318           Date 17Feb20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD039547           Date 20Sep16               *
      *                 CDL051             Date 02May18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044400           Date 20Mar17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 30May14               *
      *                 MD027598           Date 24Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD022624           Date 04Oct13               *
      *                 AR1096000          Date 14Mar13               *
      *                 AR1092035          Date 28Feb13               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 28May12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR736874           Date 06Apr11               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR792037           Date 27Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249910             Date 24Oct07               *
      *                 250357             Date 27Sep07               *
      *                 244537             Date 17Aug05               *
      *                 BUG13071           Date 18Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239400             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10727           Date 28Feb06               *
      *                 BUG8119            Date 20Oct05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6534            Date 08Apr05               *
      *                 BUG4963            Date 25Jan05               *
      *                 BUG4907            Date 21Jan05               *
      *                 BUG4808            Date 16Nov04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG4146            Date 01Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2774            Date 25May04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 NAD002             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 14Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055318 - Customer may not be amended error                 *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD039547 - Referred account is not properly validated.       *
      *  CDL051 - Incomplete Deals to Repair                          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044400 - Error in deal amendment input                     *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  MD027598 - DEAM Input (Type SI): Settlement Receipt Instr.   *
      *             not defaulted from the original deal for Deal     *
      *             Types IP, IT and CL.                              *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD022624 - Data from EXSS were not defaulted to Settlements  *
      *             tab of DEAM                                       *
      *  AR1096000 - The following system error occurred: 45011352:   *
      *              A Serious Midas error has occurred               *
      *  AR1092035 - Customer may not be amended (Field:Customer      *
      *              Shortname or Number)                             *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  CSC054 - Period End Adjustments                              *
      *  AR736874 - Default deal customer number and currency.        *
      *             (Child: AR736875)                                 *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR792037 - Default settlement method for type 'BC' to zero   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249910 - Default both payment and receipt settlement details *
      *           for EM amendment type.                              *
      *  250357 - Check and default deal's settlement details first   *
      *           before using Extended Settlement defaults.          *
      *  244537 - To avoid overriding front office identifier.        *
      *  BUG13071 - Recompile only                                    *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10727 - Fiduciary Taking warning not displayed on Insert  *
      *             and Reverse                                       *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSC024 - Open Month End                                      *
      *  BUG6534 - Condition settlements on loan or deposit.          *
      *  BUG4963 - Cannot enter DEAM with Settlement Mode 04          *
      *  BUG4907 - Error when inserting transactions with Settlement  *
      *             method 04                                         *
      *  BUG4808 - Unable to authorise transaction because WIP do     *
      *            not have correct Timestamp.                        *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4482- Authorise should call Validate to show all the      *
      *           warning errors.                                     *
      *  BUG4146 - Stopping two users to update the same record at the*
      *            same time.                                         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2774 - Error in Settlement Details.                       *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                      BUG6534
     F                                     INFDS(INFDS)                                     AR736874
                                                                                              CSD095
     FDLDLDCL1  IF   E           K DISK    PREFIX(DC_)                                        CSD095
     F                                     INFSR(*PSSR)                                       CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************


     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)


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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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



      *                                                                                       CER043
      ** External DS for Customer Details                                                     CER043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      *                                                                                       CER043
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

      **  Data structure for file status of MM deals file.                                  AR736874
                                                                                            AR736874
     D INFDS           DS                                                                   AR736874
     D  RECORD           *RECORD                                                            AR736874
                                                                                            AR736874
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.                                                           BUG4808
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4808
                                                                                             BUG4808
      ** Array of error message IDs                                                          BUG4808
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgID)                                      BUG4808
                                                                                             BUG4808
      ** Array of error message data.                                                        BUG4808
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgData)                                    BUG4808
                                                                                             BUG4808
      ** Array of message files to check                                                     BUG4808
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4808
                                                                                             BUG4808
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
      **************
     D***MMVDRecIns            300    368                                                     CGL029
     D***MMVDPayIns            369    927                                                     CGL029
     D*MMVDRecIns***         314    368                                               CGL029 BUG2774
     D*MMVDPayIns***         383    927                                               CGL029 BUG2774
     D MMVDRecIns            314    382                                                      BUG2774
     D MMVDPayIns            383    941                                                      BUG2774
     D*MMVDRecInsEx*********1137   1154                                                CGL029 NAD002
     D*MMVDPayInsEx*********1155   1172                                                CGL029 NAD002
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
      * (Current) Deal in File Format
     D***DEAMRecIns            300    368                                                     CGL029
     D***DEAMPayIns            369    927                                                     CGL029
     D DEAMRecIns            314    368                                                       CGL029
     D DEAMPayIns            383    927                                                       CGL029
     D*DEAMRecInsEx*********1137   1154                                                CGL029 NAD002
     D*DEAMPayInsEx*********1155   1172                                                CGL029 NAD002
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

     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current

     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current

     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current

     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format
     D FLPAY2                 21    565                                                       NAD002

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D**FLREC*****************21     75                                                CGL029 NAD002
     D FLREC2                 21     75                                                       NAD002
      * Receive Settlement Instructions - File (D/B) format

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
     D**FLPAY*****************21    565                                                CGL029 NAD002
      * FRA/IRS Settlement Instructions - File (D/B) format

     D InfData       E DS                  EXTNAME(MMDAIFPD)
      * MM Extra Data - Classe 1 Data - File (D/B) format
     D                                     PREFIX(IF_)

     D ExtData       E DS                  EXTNAME(MMDAEXPD)
      * MM Extra Data - File (D/B) format

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
      * Second DS for Access programs - long data structure                                   CER043
                                                                                              CER043
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD

     D                 DS
      **  Data Structure to parameter date passed to mm0085
     D  @PDAT                  1      8  0
     D  @PDYY                  1      4  0
     D  @PYEAR                 3      4  0
     D  @PDMM                  5      6  0
     D  @PDDD                  7      8  0

     D                 DS
      **  Data Structure for screen value date
     D  @VDAT                  1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6


     D MMDEAMUPC       DS             1    DTAARA(MMDEAMUPC)

      *                                                                                       CER043
      ** Customers Extension Screen Format based on SDCUCUPD                                  CER043
     D TranInCust    E DS                  EXTNAME(SDCUCUPD)                                  CER043
      *                                                                                       CER043
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

      ** Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *                                                                                       CER043
      ** Field (500A) to receive the incoming Customer details                                CER043
     D Trans500C       S            500A                                                      CER043

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indices for arrays used to set up corresponding sequence numbers
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
     D  DDCNSPOK                      1A   INZ('Y')                                           CRE073
     D  DDRDMTOK                      1A   INZ('Y')                                           CRE073
     D  DDRDFDOK                      1A   INZ('Y')                                           CRE073

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
     D  DDRmacOK                      1A   INZ('Y')                                           CDL094
     D  DDRexrOK                      1A   INZ('Y')                                           CDL094
     D  DDRexiOK                      1A   INZ('Y')                                           CDL094
     D  DDRbb1OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb2OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb3OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb4OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb5OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb6OK                      1A   INZ('Y')                                           CDL094

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
                                                                                             BUG4963
      ** Booking Branch                                                                      BUG4963
     D PBokBr          S              3A                                                     BUG4963

      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank1          S              1A   INZ(*BLANKS)
     D Blank2          S              2A   INZ(*BLANKS)
     D*Blank3********* S              3A   INZ(*BLANKS)                                      BUG4963
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

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
     D DEALNR          S              6  0                                                   BUG6534

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
                                                                                            BUG10727
     D PDEAL#          S              6  0                                                  BUG10727
     D CDL011          S              1A                                                    MD044400
                                                                                              CSC024
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D CER043          S              1A                                                      CER043
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PRtcd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
     D CRE073          S              1A                                                      CRE073
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
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

      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Trans500C     TranInCust                                   CER043
     C                   MOVEL     Infdata500    Infdata
     C                   MOVEL     Extdata500    Extdata

     C                   IF        APFOTRANID <> *BLANKS                                   AR971184A
     C                   EVAL      DDFOID = APFOTRANID                                     AR971184A
     C                   ENDIF                                                             AR971184A
      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE
      *
      *  If valid deal does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END


      *  Validate Action Code

      *  Additional deal number validation in ValidateAc for initial input screen.           BUG6534
      *                                                                                      BUG6534
     C                   EXSR      ValidateAc
     C*                                                                                      BUG6534
     C**  Validate the deal amendment type here it to be picked up                           BUG6534
     C**  on the new DEAM initial input screen.                                              BUG6534
     C*                                                                                      BUG6534
     C     DDMTYP        IFEQ      *BLANKS                                                   BUG6534
     C                   ADD       1             Idx                                         BUG6534
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'                                BUG6534
     C                   EVAL      MsgIDArr(Idx) = 'MMM0297'                                 BUG6534
     C                   END                                                                 BUG6534

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
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt

     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      TranIn                                 99
     C     *in99         ifeq      *on
     C                   endif
     C                   endif
     C                   EXSR      SetupAmend
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482

     C                   ENDSL

     C     INVALID       TAG
      *                                                                                       CER043
      ** Population of Customer Details                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EXSR      SrPopCust                                                  CER043
     C                   ENDIF                                                                CER043

      *  Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information                         BUG4808
      ** from file                                                                           BUG4808
     C                   IF        UpdateYN = 'Y'                                            BUG4808
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      IGDA38        DDDLNO_In                                   BUG4808
     C                   MOVE      IGDS38        DDDS38_In                                   BUG4808
     C                   MOVE      IGVDYY        @DSPY                                       BUG4808
     C                   IF        BJDFIN = 'D'                                              BUG4808
     C                   MOVE      IGVDMM        @DSPM                                       BUG4808
     C                   MOVE      IGVDDD        @DSPD                                       BUG4808
     C                   ELSE                                                                BUG4808
     C                   MOVE      IGVDMM        @DSPD                                       BUG4808
     C                   MOVE      IGVDDD        @DSPM                                       BUG4808
     C                   ENDIF                                                               BUG4808
     C                   MOVE      @VDAT         DDVDAT_In                                   BUG4808
     C                   CALL      'MMDEAMR'                                                 BUG4808
     C                   PARM                    @AuthComp         1                         BUG4808
     C                   PARM                    @FwdBck           1                         BUG4808
     C                   PARM                    DDDLNO_In         6                         BUG4808
     C                   PARM                    DDVDAT_In         6                         BUG4808
     C                   PARM                    DDDS38_In         3                         BUG4808
     C                   PARM                    Buffer                                      BUG4808
     C                   PARM                    @FldNameArr                                 BUG4808
     C                   PARM                    @MsgIDArr                                   BUG4808
     C                   PARM                    @MsgDtaArr                                  BUG4808
     C                   PARM                    @MsgFArray                                  BUG4808
     C                   PARM                    @APIRetC          1                         BUG4808
     C                   MOVEL     DDACTN        Buffer                                      BUG4808
     C                   ELSE                                                                BUG4808
      *                                                                                      BUG6534
      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
      *                                                                                      BUG6534
     C**********         MOVEL     ' '           LONDEP                             BUG6534 MD044400
     C**********         MOVEL     ' '           DDCSNM                            AR736874 MD044400
     C**********         MOVEL     ' '           DDCCY                             AR736874 MD044400
     C                   MOVEL     *BLANKS       LONDEP                                     MD044400
     C                   MOVEL     *BLANKS       DDCSNM                                     MD044400
     C                   MOVEL     *BLANKS       DDCCY                                      MD044400
     C                   IF        DDDLNO <> *BLANKS                                         BUG6534
     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
      *                                                                                      BUG6534
     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
     C                   MOVEL     'D'           LONDEP                                      BUG6534
     C                   ELSE                                                                BUG6534
     C                   MOVEL     'L'           LONDEP                                      BUG6534
     C                   ENDIF                                                               BUG6534
                                                                                            AR736874
     C                   IF        RECORD = 'MMDELDP0'                                      AR736874
      *                                                                                    AR1092035
     C**********         IF        CDL005 = 'Y'                                   AR1092035 MD055318
     C**********                   OR CDL011 = 'Y'                                 MD044400 MD055318
     C**********         MOVEL     HKCSNM        DDCSNM                            AR736874 MD055318
     C**********         ELSE                                                     AR1092035 MD055318
     C                   MOVEL     HKCNUM        DDCSNM                                    AR1092035
     C**********         ENDIF                                                    AR1092035 MD055318
      *                                                                                    AR1092035
     C                   MOVEL     HKCCY         DDCCY                                      AR736874
     C                   ENDIF                                                              AR736874
     C                   IF        RECORD = 'MMDENBP0'                                      AR736874
     C**********         MOVEL     HLCSNM        DDCSNM                            AR736874 MD055318
     C                   MOVEL     HLCCY         DDCCY                                      AR736874
     C                   ENDIF                                                              AR736874
     C                   IF        RECORD = 'MMDENSP0'                                      AR736874
     C**********         MOVEL     HMCSNM        DDCSNM                            AR736874 MD055318
     C                   MOVEL     HMCCY         DDCCY                                      AR736874
     C                   ENDIF                                                              AR736874
     C                   ENDIF                                                               BUG6534
      *                                                                                      BUG6534
     C                   EVAL                    Buffer = TranIN
     C**********                                          + @TimeStamp               BUG4146 BUG6534
     C**********                                 + @TimeStamp + LONDEP                BUG6534 CER043
     C                                           + @TimeStamp                                 CER043
     C                                           + TranInCust                                 CER043
     C                                           + LONDEP                                     CER043
     C                                           + DDFOID                                     239400
     C                                           + InRecSttmt + InPaySttmt
     C                                           + InfData  + ExtData
     C                   ENDIF                                                               BUG4808

     C                   RETURN


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR
                                                                                            AR971184
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      *
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number of the original deal
      * The deam in file format from the MM database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'MMDEAMRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE

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
                                                                                            BUG10727
      ** Retrieve warning message, if needed.                                               BUG10727
                                                                                            BUG10727
     C                   IF        DDACTN = 'I' OR DDACTN = 'D'                             BUG10727
                                                                                            BUG10727
     C                   MOVE      DDDLNO        PDEAL#                                     BUG10727
                                                                                            BUG10727
     C                   CALLB     'MMDEAMWRN'                                              BUG10727
     C                   PARM                    PDEAL#                                     BUG10727
     C                   PARM                    DDACTN                                     BUG10727
     C                   PARM                    DDMTYP                                     BUG10727
     C                   PARM                    WFldNamArr                                 BUG10727
     C                   PARM                    WMsgIdArr                                  BUG10727
     C                   PARM                    WMsgDtaArr                                 BUG10727
     C                   PARM                    WIdx                                       BUG10727
                                                                                            BUG10727
     C                   ENDIF                                                              BUG10727
                                                                                            BUG10727

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
     C     DDMTYP        OREQ      'BC'                                                     AR792037
     C                   MOVEL     '00'          DDPSTM
     C                   MOVEL     '00'          DDRSTM
     C                   GOTO      EDFTSETT
     C                   ENDIF

     C                   IF        DDDLNO <> *BLANKS                                          250357
     C                   MOVEL     DDDLNO        DEALNR                                       250357
     C     DEALNR        CHAIN     MMDEALLL                           30                      250357
      *                                                                                       250357
     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                             250357
     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                          250357
     C                   MOVEL     'D'           LONDEP                                       250357
     C                   ELSE                                                                 250357
     C                   MOVEL     'L'           LONDEP                                       250357
     C                   ENDIF                                                                250357
     C                   ENDIF                                                                250357
                                                                                              250357
     C                   MOVE      ' '           DFTRST            1                          250357
     C                   MOVEL     ' '           DFTPST            1                          250357
      ** If Principal Decrease of Deposit Taken or Early Maturity of Deposit Taken            250357
      ** or Principal Increase of Deposit Placed or Base Rate or Capitalise Interest          250357
      ** or Spread Change.                                                                    250357
                                                                                              250357
     C     DDMTYP        IFEQ      'PD'                                                       250357
     C     LONDEP        ANDEQ     'D'                                                        250357
     C     DDMTYP        OREQ      'EM'                                                       250357
     C*****LONDEP        ANDEQ     'D'                                                 250357 249910
     C     DDMTYP        OREQ      'PI'                                                       250357
     C     LONDEP        ANDEQ     'L'                                                        250357
     C     DDMTYP        OREQ      'BC'                                                       250357
     C     DDMTYP        OREQ      'CI'                                                       250357
     C     DDMTYP        OREQ      'SC'                                                       250357
     C     DDMTYP        OREQ      'SI'                                                     MD022624
      *                                                                                       250357
     C                   EVAL      FLPSTM = HKPSTM                                            250357
     C                   EVAL      FLPONS = HKPONS                                            250357
     C                   EVAL      FLPIBN = HKPIBN                                            250357
     C                   EVAL      FLPIBA = HKPIBA                                            250357
     C                   EVAL      FLPOBN = HKPOBN                                            250357
     C                   EVAL      FLPOCN = HKPOCN                                            250357
     C                   EVAL      FLRCRN = HKRCRN                                            250357
     C                   EVAL      FLRCRA = HKRCRA                                            250357
     C                   EVAL      FLRVNO = HKRVNO                                            250357
     C                   EVAL      FLAWBN = HKAWBN                                            250357
     C                   EVAL      FLAWBA = HKAWBA                                            250357
     C                   EVAL      FLBENN = HKBENN                                            250357
     C                   EVAL      FLBENA = HKBENA                                            250357
     C                   EVAL      FLDTP1 = HKDTP1                                            250357
     C                   EVAL      FLDTP2 = HKDTP2                                            250357
     C                   EVAL      FLDTP3 = HKDTP3                                            250357
     C                   EVAL      FLDTP4 = HKDTP4                                            250357
     C                   EVAL      FLDCHG = HKDCHG                                            250357
     C                   EVAL      FLBTB1 = HKBTB1                                            250357
     C                   EVAL      FLBTB2 = HKBTB2                                            250357
     C                   EVAL      FLBTB3 = HKBTB3                                            250357
     C                   EVAL      FLBTB4 = HKBTB4                                            250357
     C                   EVAL      FLBTB5 = HKBTB5                                            250357
     C                   EVAL      FLBTB6 = HKBTB6                                            250357
     C                   EVAL      FLPOBR = HKPOBR                                            250357
     C                   EVAL      FLCVMR = HKCVMR                                            250357
     C                   EVAL      FLPSCY = HKSTCY                                            250357
     C                   EVAL      DFTPST = 'Y'                                               250357
     C                   ENDIF                                                                249910
      *                                                                                       250357
      *                                                                                       250357
      ** If Principal Decrease of Deposit Placed or Early Maturity of Deposit Placed          250357
      ** or Principal Increase of Deposit Taken or Base Rate or Capitalise Interest           250357
      ** or Spread Change.                                                                    250357
      **                                                                                      250357
     C*********          ELSE                                                          250357 249910
      *                                                                                       250357
     C     DDMTYP        IFEQ      'PD'                                                       250357
     C     LONDEP        ANDEQ     'L'                                                        250357
     C     DDMTYP        OREQ      'EM'                                                       250357
     C*****LONDEP        ANDEQ     'L'                                                        250357
     C     DDMTYP        OREQ      'PI'                                                       250357
     C     LONDEP        ANDEQ     'D'                                                        250357
     C     DDMTYP        OREQ      'BC'                                                       250357
     C     DDMTYP        OREQ      'CI'                                                       250357
     C     DDMTYP        OREQ      'SC'                                                       250357
     C     DDMTYP        OREQ      'SI'                                                     MD027598
      *                                                                                       250357
     C                   EVAL      FLRSTM = HKRSTM                                            250357
     C                   EVAL      FLRONS = HKRONS                                            250357
     C                   EVAL      FLRIBN = HKRIBN                                            250357
     C                   EVAL      FLRIBA = HKRIBA                                            250357
     C                   EVAL      FLROBN = HKROBN                                            250357
     C                   EVAL      FLROCN = HKROCN                                            250357
     C                   EVAL      FLROBR = HKROBR                                            250357
     C                   EVAL      FLRSCY = HKSTCY                                            250357
     C                   EVAL      FLRBB1 = HKRBB1                                            CDL094
     C                   EVAL      FLRBB2 = HKRBB2                                            CDL094
     C                   EVAL      FLRBB3 = HKRBB3                                            CDL094
     C                   EVAL      FLRBB4 = HKRBB4                                            CDL094
     C                   EVAL      FLRBB5 = HKRBB5                                            CDL094
     C                   EVAL      FLRBB6 = HKRBB6                                            CDL094
     C                   EVAL      DFTRST = 'Y'                                               250357
     C                   ENDIF                                                                250357
     C********           ENDIF                                                         250357 249910
      *                                                                                       250357
     C     DFTPST        IFEQ      'Y'                                                        250357
     C     FLPSTM        ANDEQ     0                                                          250357
     C     DFTRST        OREQ      'Y'                                                        250357
     C     FLRSTM        ANDEQ     0                                                          250357
                                                                                              CSD095
      ** Retrieve the subtype and branch associated with the deal                             CSD095
                                                                                              CSD095
     C                   EVAL      DDSTYP = *BLANKS                                           CSD095
     C                   EVAL      DDBRCA = *BLANKS                                           CSD095
     C                   MOVEL     HKCNUM        DDCSNM                                       CSD095
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
     C**********         PARM                    DDCcy                                        CSD095
     C                   PARM      HKCCY         DDCcy                                        CSD095
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    DDCcy
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
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
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
     C                   ENDIF                                                                250357

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


     C**********         EVAL      DBRecSttmt = DEAMRecIns + HNOSBR                           CGL029
     C*******************EVAL      FLREC      = DEAMRecIns                             CGL029 NAD002
     C*******************EVAL      FLRONS     = DEAMRecInsEx                           CGL029 NAD002
     C*******************EVAL      FLRSTM     = HNRSTM                                 CGL029 NAD002
     C*******************EVAL      FLROBR     = HNOSBR                                 CGL029 NAD002
     C                   EVAL      FLRSTM     = HNRSTM                                        NAD002
     C                   EVAL      FLRONS     = HNRONS                                        NAD002
     C                   EVAL      FLREC2     = DEAMRecIns                                    NAD002
     C                   EVAL      FLROBR     = HNOSBR                                        NAD002
     C                   EVAL      FLRSCY     = HNSTCY
     C**********         EVAL      DBPaySttmt = DEAMPayIns + HNOSBR + HNCVMR                  CGL029
     C*******************EVAL      FLPAY      = DEAMPayIns                             CGL029 NAD002
     C*******************EVAL      FLPONS     = DEAMPayInsEx                           CGL029 NAD002
     C                   EVAL      FLPSTM     = HNPSTM                                        CGL029
     C                   EVAL      FLPONS     = HNPONS                                        NAD002
     C                   EVAL      FLPAY2     = DEAMPayIns                                    NAD002
     C                   EVAL      FLPOBR     = HNOSBR                                        CGL029
     C                   EVAL      FLCVMR     = HNCVMR                                        CGL029
     C                   EVAL      FLPSCY     = HNSTCY
     C                   EVAL      FLIC72     = HNIC72
     C                   EVAL      FLRBB1     = HNRBB1                                        CDL094
     C                   EVAL      FLRBB2     = HNRBB2                                        CDL094
     C                   EVAL      FLRBB3     = HNRBB3                                        CDL094
     C                   EVAL      FLRBB4     = HNRBB4                                        CDL094
     C                   EVAL      FLRBB5     = HNRBB5                                        CDL094
     C                   EVAL      FLRBB6     = HNRBB6                                        CDL094

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      HNCCY         InRCCY                                      CSF011A
     C                   PARM      HNCCY         InPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF


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
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData
      * Extra Data
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
                                                                                             BUG4963
      ** Initialize Booking Branch                                                           BUG4963
                                                                                             BUG4963
     C                   IF        DDPSTM = '04' OR DDRSTM = '04'                            BUG4963
     C                   EVAL      PBokBr = IGBRCA                                           BUG4963
     C                   ELSE                                                                BUG4963
     C                   EVAL      PBokBr = *blanks                                          BUG4963
     C                   ENDIF                                                               BUG4963

      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
      *                                                                                      BUG6534
     C                   MOVEL     ' '           LONDEP                                      BUG6534
     C                   IF        DDDLNO <> *BLANKS                                         BUG6534
     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
      *                                                                                      BUG6534
     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
     C                   MOVEL     'D'           LONDEP                                      BUG6534
     C                   ELSE                                                                BUG6534
     C                   MOVEL     'L'           LONDEP                                      BUG6534
     C                   ENDIF                                                               BUG6534
     C                   ENDIF                                                               BUG6534
                                                                                             BUG6534
      ** If Principal Decrease of Deposit Taken or Early Maturity of Deposit Taken           BUG6534
      ** or Principal Increase of Deposit Placed or Base Rate or Capitalise Interest         BUG6534
      ** or Spread Change.                                                                   BUG6534
                                                                                             BUG6534
     C     DDMTYP        IFEQ      'PD'                                                      BUG6534
     C     LONDEP        ANDEQ     'D'                                                       BUG6534
     C     DDMTYP        OREQ      'EM'                                                      BUG6534
     C*****LONDEP        ANDEQ     'D'                                               BUG6534  249910
     C     DDPENP        ANDEQ     'P'                                                        249910
     C     DDMTYP        OREQ      'PI'                                                      BUG6534
     C     LONDEP        ANDEQ     'L'                                                       BUG6534
     C     DDMTYP        OREQ      'BC'                                                      BUG6534
     C     DDMTYP        OREQ      'CI'                                                      BUG6534
     C     DDMTYP        OREQ      'SC'                                                      BUG6534
      *                                                                                      BUG6534
     C                   CLEAR                   InRecSttmt                                  BUG6534
     C                   MOVEL     '00'          DDRSTM                                      BUG6534
     C     CDL051        IFEQ      'Y'                                                        CDL051
     C                   EVAL      ##PREC = 'Y'                                               CDL051
     C                   ENDIF                                                                CDL051
      *                                                                                      BUG6534
      ** If Principal Decrease of Deposit Placed or Early Maturity of Deposit Placed         BUG6534
      ** or Principal Increase of Deposit Taken or Base Rate or Capitalise Interest          BUG6534
      ** or Spread Change.                                                                   BUG6534
      **                                                                                     BUG6534
     C                   ELSE                                                                BUG6534
      *                                                                                      BUG6534
     C     DDMTYP        IFEQ      'PD'                                                      BUG6534
     C     LONDEP        ANDEQ     'L'                                                       BUG6534
     C     DDMTYP        OREQ      'EM'                                                      BUG6534
     C*****LONDEP        ANDEQ     'L'                                               BUG6534  249910
     C     DDPENP        ANDEQ     'R'                                                        249910
     C     DDMTYP        OREQ      'PI'                                                      BUG6534
     C     LONDEP        ANDEQ     'D'                                                       BUG6534
     C     DDMTYP        OREQ      'BC'                                                      BUG6534
     C     DDMTYP        OREQ      'CI'                                                      BUG6534
     C     DDMTYP        OREQ      'SC'                                                      BUG6534
      *                                                                                      BUG6534
     C                   CLEAR                   InPaySttmt                                  BUG6534
     C                   MOVEL     '00'          DDPSTM                                      BUG6534
     C     CDL051        IFEQ      'Y'                                                        CDL051
     C                   EVAL      ##PPAY = 'Y'                                               CDL051
     C                   ENDIF                                                                CDL051
                                                                                             BUG6534
     C                   ENDIF                                                               BUG6534
     C                   ENDIF                                                               BUG6534
      *                                                                                      BUG6534
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
     C*******************PARM                    Blank3                              BUG4907
     C*******************PARM      IGBRCA        PBRCA             3                 BUG4907 BUG4963
     C                   PARM                    PBokBr                                      BUG4963
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code
     C                   PARM                    DDACTN
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1

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

      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
      *                                                                                     MD039547
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM                    DEAM                                       MD039547
     C                   PARM                    DDCCY                                      MD039547
     C                   PARM                    DDCCY                                      MD039547
     C                   PARM                    DDCsnm                                     MD039547
     C                   PARM                    PBokBr                                     MD039547
     C                   PARM                    InPaySttmt                                 MD039547
     C                   PARM                    InRecSttmt                                 MD039547
     C                   PARM                    DDACTN                                     MD039547
     C                   PARM                    ##PPAY                                     MD039547
     C                   PARM                    ##PREC                                     MD039547
     C                   PARM                    OKPayInsDS                                 MD039547
     C                   PARM                    OKRecInsDS                                 MD039547
     C                   PARM                    FldNameArr                                 MD039547
     C                   PARM                    MsgIDArr                                   MD039547
     C                   PARM                    Idx                                        MD039547
     C                   PARM                    WFldNamArr                                 MD039547
     C                   PARM                    WMsgIdArr                                  MD039547
     C                   PARM                    WMsgDtaArr                                 MD039547
     C                   PARM                    WIdx                                       MD039547

     C     ValSetExit    TAG

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
     C                   PARM      'Y'           ResetErrs         1                          CDL038
     C*******************PARM      'N'           ResetErrs         1                          CDL038

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
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
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
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @PDDD                          **2
     C                   ELSE
     C                   MOVE      @DSPD         @PDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @PDMM                          **2
     C                   ELSE
     C                   MOVE      @DSPM         @PDDD
     C                   END
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
     C                   MOVE      SeqNoPack     DDDS38
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


      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C**********         MOVEL     DBPaySttmt    MMVDPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    MMVDRecIns                                   CGL029
     C*******************MOVEL     FLREC         MMVDRecIns                            CGL029 NAD002
     C*******************MOVEL     FLRONS        MMVDRecInsEx                          CGL029 NAD002
     C                   MOVEL     FLRSTM        IGRSTM                                       CGL029
     C                   MOVEL     FLRONS        IGRONS                                       NAD002
     C                   MOVEL     FLREC2        MMVDRecIns                                   NAD002
     C*******************MOVEL     FLPAY         MMVDPayIns                            CGL029 NAD002
     C*******************MOVEL     FLPONS        MMVDPayInsEx                          CGL029 NAD002
     C                   MOVEL     FLPSTM        IGPSTM                                       CGL029
     C                   MOVEL     FLPONS        IGPONS                                       NAD002
     C                   MOVEL     FLPAY2        MMVDPayIns                                   NAD002
     C                   MOVEL     FLRBB1        IGRBB1                                       CDL094
     C                   MOVEL     FLRBB2        IGRBB2                                       CDL094
     C                   MOVEL     FLRBB3        IGRBB3                                       CDL094
     C                   MOVEL     FLRBB4        IGRBB4                                       CDL094
     C                   MOVEL     FLRBB5        IGRBB5                                       CDL094
     C                   MOVEL     FLRBB6        IGRBB6                                       CDL094
     C     FLPOBR        IFNE      *BLANKS
     C                   MOVE      FLPOBR        IGOSBR
     C                   ELSE
     C                   MOVE      FLROBR        IGOSBR
     C                   END
     C                   MOVE      FLCVMR        IGCVMR
     C                   MOVE      FLPSCY        IGSTCY
     C                   MOVE      FLIC72        IGIC72
     C                   ENDIF


      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IGLACT = DDACTN

      * Include Header fields that need to be o/p to the Valid file

     C                   IF        DDACTN = 'I'
     C                   MOVE      DDDLNO        IGDA38
     C                   ENDIF

      * Do not override header fields from existing transaction.                              244537
     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
                                                                                              244537
     C                   EVAL      IGFRNT = APFOTranID
     C                   EVAL      IGAFRT = APFOAsocID
     C                   EVAL      IGREPA = APRprLocn
     C**********         IF        DDFOID <> *BLANKS                                239400 AR971184A
     C**********         EVAL      IGFRNT = DDFOID                                  239400 AR971184A
     C**********         END                                                        239400 AR971184A
     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
                                                                                              244537
     C                   ENDIF                                                                244537

      * Automatic Authorisation flag
     C                   IF        CAP051 = 'Y'
     C                   EVAL      IGAUTH = IF_AUTH
     C                   ENDIF

     C                   EVAL      TranStatus = 'S'

      * Restore Timestamp from the original record                                           BUG4146
     C                   IF        DDACTN <> 'I'                                             BUG4146
     C**************               AND DDACTN <> 'X'                                 BUG4808 BUG4808
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    IGTMESTMP                                   BUG4146
     C                   ENDIF                                                               BUG4146
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVEL     IGCNSP        HKCNSP                                       CRE073
     C                   MOVEL     IGRDMT        HKRDMT                                       CRE073
     C                   MOVEL     IGRDFD        HKRDFD                                       CRE073
     C                   ENDIF                                                                CRE073

      /COPY WNCPYSRC,MMDEAMC018

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR

      * For inserts generate Deal Amendment Sequence Number
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ENDIF
      *
      * UPDATE VALID DEAM: DEAL NUMBER
      *
      * UPDATE VALID DEAM: LAST ACTION CODE
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMDEAMUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    ValidDeal
      *
      * DEAMS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @RTCD
     C                   PARM                    ValidDeal
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     @RTCD         IFEQ      '*RECUPD'

     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)

     C                   END


     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CER043
      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: MAIN Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: SrRtvCust                                             *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     SrPopCust     BEGSR                                                                CER043
      *                                                                                       CER043
     C                   CLEAR                   TranInCust                                   CER043
      *                                                                                       CER043
      ** Retrieve Customer Details                                                            CER043
     C                   IF        DDCSNM <> *BLANKS AND                                      CER043
     C                             DDCsnmOK = 'Y'                                             CER043
     C                   EVAL      PCNum = DDCSNM                                             CER043
      *                                                                                       CER043
     C                   EXSR      SrRtvCust                                                  CER043
     C                   IF        PRtcd = *BLANKS                                            CER043
     C                   EVAL      DDCSSN = BBCSSN                                            CER043
     C                   EVAL      DDCRNM = BBCRNM                                            CER043
     C                   EVAL      DDCRTN = BBCRTN                                            CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: SrPopCust                                         *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     SrRtvCust     BEGSR                                                                CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCNum                                        CER043
     C                   PARM      *BLANKS       PKey7                                        CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
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
     C                   PARM                    Trans500C                                    CER043
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500
     C                   PARM                    ExtData500
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
     C                   PARM                    @TimeStamp       26                         BUG4146
     C                   PARM                    LONDEP            1                         BUG6534
     C                   PARM                    DDFOID           20                          239400

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'SDUSRMSG'                                  CRE073

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMDEAMM01

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'DL'

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY

     C                   CALLB     'MMFIDINIT'                                              BUG10727
     C                   PARM      *BLANKS       WRTCD             7                        BUG10727

      *
      ** Access SAR details file to determine if
      ** Automatic Authorisation (MM Part) is installed
      *
     C                   MOVEL     'N'           CAP051            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051
     C                   ENDIF

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
     C                   Eval      DBPgm = 'MMDEAMVU'                                         CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 900                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC024
      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C                   PARM      'CSC024'      @SARD                                        CSC024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
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

      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   CALL      'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       @RTCD                                        CER043
     C                   PARM      '*VERIFY'     @OPTN                                        CER043
     C                   PARM      'CER043'      @SARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        @RTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   IF        @RTCD <> '*NRF'                                            CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 902                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
      *                                                                                       CRE073
      ** Check if CRE073 is switched on                                                       CRE073
                                                                                              CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       @RTCD                                        CRE073
     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
     C                   PARM      'CRE073'      @SARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        @RTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
                                                                                              CRE073
     C                   IF        @RTCD <> '*NRF'                                            CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBASE = 903                                                CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      *                                                                                    AR1092035
      ** Check for CDL005 (Show Customer Shortname) is ON                                  AR1092035
      *                                                                                    AR1092035
     C                   CALL      'AOSARDR0'                                              AR1092035
     C                   PARM      *BLANKS       @RTCD                                     AR1092035
     C                   PARM      '*VERIFY'     @OPTN                                     AR1092035
     C                   PARM      'CDL005'      @SARD                                     AR1092035
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1092035
      *                                                                                    AR1092035
     C     @RTCD         IFEQ      *BLANK                                                  AR1092035
     C                   MOVE      'Y'           CDL005            1                       AR1092035
     C                   ELSE                                                              AR1096000
     C                   EVAL      CDL005 = 'N'                                            AR1096000
     C**********         ENDIF                                                   AR1092035 AR1096000
      *                                                                                    AR1092035
     C                   IF        @RTCD <> '*NRF'                                         AR1092035
     C     *LOCK         IN        LDA                                                     AR1092035
     C                   EVAL      DBKEY = 'CDL005'                                        AR1092035
     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1092035
     C                   EVAL      DBASE = 903                                             AR1092035
     C                   OUT       LDA                                                     AR1092035
     C                   EXSR      *PSSR                                                   AR1092035
     C                   ENDIF                                                             AR1092035
                                                                                           AR1096000
     C                   ENDIF                                                             AR1096000
      *                                                                                     MD044400
      ** Check for CDL011 Expansion of Customer Number is ON                                MD044400
      *                                                                                     MD044400
     C                   CALL      'AOSARDR0'                                               MD044400
     C                   PARM      *BLANKS       @RTCD                                      MD044400
     C                   PARM      '*VERIFY'     @OPTN                                      MD044400
     C                   PARM      'CDL011'      @SARD                                      MD044400
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD044400
      *                                                                                     MD044400
     C     @RTCD         IFEQ      *BLANK                                                   MD044400
     C                   MOVE      'Y'           CDL011                                     MD044400
     C                   ELSE                                                               MD044400
     C                   EVAL      CDL011 = 'N'                                             MD044400
      *                                                                                     MD044400
     C                   IF        @RTCD <> '*NRF'                                          MD044400
     C     *LOCK         IN        LDA                                                      MD044400
     C                   EVAL      DBKEY = 'CDL011'                                         MD044400
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD044400
     C                   EVAL      DBASE = 904                                              MD044400
     C                   OUT       LDA                                                      MD044400
     C                   EXSR      *PSSR                                                    MD044400
     C                   ENDIF                                                              MD044400
                                                                                            MD044400
     C                   ENDIF                                                              MD044400
      *                                                                                    AR1092035
      *                                                                                       CDL051
      ** Access SAR details file for CDL051                                                   CDL051
      *                                                                                       CDL051
     C                   CALL      'AOSARDR0'                                                 CDL051
     C                   PARM      *BLANKS       @RTCD                                        CDL051
     C                   PARM      '*VERIFY'     @OPTN                                        CDL051
     C                   PARM      'CDL051'      @SARD                                        CDL051
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL051
                                                                                              CDL051
     C                   IF        @RTCD = *BLANK                                             CDL051
     C                   MOVEL     'Y'           CDL051            1                          CDL051
     C                   ELSE                                                                 CDL051
     C                   MOVEL     'N'           CDL051                                       CDL051
      *                                                                                       CDL051
     C                   IF        @RTCD <> '*NRF'                                            CDL051
     C     *LOCK         IN        LDA                                                        CDL051
     C                   EVAL      DBKEY = 'CDL051'                                           CDL051
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL051
     C                   EVAL      DBASE = 905                                                CDL051
     C                   OUT       LDA                                                        CDL051
     C                   EXSR      *PSSR                                                      CDL051
     C                   ENDIF                                                                CDL051
      *                                                                                       CDL051
     C                   ENDIF                                                                CDL051
      *                                                                                       CDL051
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
