     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Rollover deals validate and update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRODLVU - Rollover Deals Maintenance Validate and Update    *
      *                                                               *
      *  Function: This Program Validates Rollover deals for input    *
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
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23225           Date 06Mar09               *
      *                 BUG22103           Date 14Jan09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17342           Date 31Mar08               *
      *                 249119             Date 13Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 238592             Date 21Mar06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10201           Date 30Jan06               *
      *                 BUG8615            Date 28Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG7154            Date 05Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 BUG2804            Date 20May04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 TCA072             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 07Oct03               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23225 - Default value of the field "Final Maturity Date"  *
      *             is wrong                                          *
      *  BUG22103 - Final maturity date was not changed  to New       *
      *             Maturity Date                                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17342 - A serious MidasPLus error in rollover to euro.    *
      *  249119  - Adjust buffer mapping for DDRACT and DDRAMN        *
      *            due to additional fields in MMLDNIPD (added        *
      *            by CDL049).                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  238592 - Send CEU015 as parameter to MMLDNIROV.              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10201 - (RODL Insert) Misaligned fields / Wrong data      *
      *  BUG8615 - Adjust the buffer mapping for DDRACT and DDRAMN    *
      *            due to additional fields in MMLDNIPD (added by     *
      *            CDL033)                                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG7154 - OCBC Manual Deal Rollover settlement details does  *
      *            not default                                        *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:MMRODLUD01,MMRODLUC01              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *           and other errors in MM loans/deposits rollover      *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *  TCA072 - Position of additional workfields DDRACT (Rollover  *
      *           Action) and DDRAMN (Rollover Amount) not shifted    *
      *           when account code (in DDINSA) was increased to 10   *
      *           digits.                                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FSDBRTDL1  IF   E           K DISK    INFSR(*PSSR)

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

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **-----------------------------------------------------------------------

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

      * Incoming transaction in screen format
     D TranIn        E DS                  EXTNAME(MMLDNIPD)
     D**DDRAMN***************328    341                                                       TCA072
     D**DDRACT***************342    342                                                       TCA072
     D**DDRAMN***************334    347                                               TCA072 BUG2804
     D**DDRACT***************348    348                                               TCA072 BUG2804
     D**DDRAMN***************376    389                                              BUG2804 BUG8615
     D**DDRACT***************390    390                                              BUG2804 BUG8615
     D**DDRAMN**             404    417                                             BUG8615 BUG10201
     D**DDRACT**             418    418                                             BUG8615 BUG10201
     D**DDRAMN**             408    421                                              BUG10201 249119
     D**DDRACT**             422    422                                              BUG10201 249119
     D**DDRAMN**             422    435                                                 249119CER020
     D**DDRACT**             436    436                                                 249119CER020
     D*** Note these are rollover work fields added after last position file format         CER020
     D**DDRAMN**             440    453                                                CER020 CRE073
     D**DDRACT**             454    454                                                CER020 CRE073
     D**DDRAMN**             463    476                                               CRE073 CSF011A
     D**DDRACT**             477    477                                               CRE073 CSF011A
     D  DDRAMN               667    680                                                      CSF011A
     D  DDRACT               681    681                                                      CSF011A

      * Valid file layout
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
     D**LDNIRecIns           456    524                                                      BUG7154
     D**LDNIPayIns           525   1083                                                      BUG7154
     D  LDNIRecIns           470    524                                                      BUG7154
     D  LDNIPayIns           539   1083                                                      BUG7154

      * Current transaction record in file format
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
     D  DLQQDORI     E                     EXTFLD(QQDORI)                                     CGL029
     D  DLQQMORI     E                     EXTFLD(QQMORI)                                     CGL029
     D  DLQQDOPI     E                     EXTFLD(QQDOPI)                                     CGL029
     D  DLQQMOPI     E                     EXTFLD(QQMOPI)                                     CGL029
     D  DLQQRONS     E                     EXTFLD(QQRONS)                                     CGL029
     D  DLQQPONS     E                     EXTFLD(QQPONS)                                     CGL029
     D  DLQQINSA     E                     EXTFLD(QQINSA)                                     CGL029
     D**DELDRecIns           456    524                                                      BUG7154
     D**DELDPayIns           525   1083                                                      BUG7154
     D  DELDRecIns           470    524                                                      BUG7154
     D  DELDPayIns           539   1083                                                      BUG7154

      * Current transaction in screen format
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D                                     PREFIX(@)

      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)

      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)

      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)

      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)

      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      * Pay settlement instructions in file format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D  FLPAY2                21    565                                                      BUG7154

      * Receive settlement instructions in file format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D  FLREC2                21     75                                                      BUG7154

      * FRA/IRS settlement instructions in file format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)

      * Extra data in file format - Class 1 data
     D***InfData       E DS                  EXTNAME(MMLDIFPD)                               CSF011A
     D***********                          PREFIX(IF_)                                       CSF011A

      * Extra data in file format
     D ExtData       E DS                  EXTNAME(MMLDEXPD)

      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  DL_QQACCD    E                     EXTFLD(QQACCD)                                     CGL029

      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)

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
     D***Trans500        S            500A                                                   CSF011A
     D Trans500        S           1000A                                                     CSF011A

      ** Field (500A) to receive the incoming Extra Data
     D***InfData500      S            500A                                                   CSF011A

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indeces for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
      * Error indicators

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

      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')

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
     D RecNostro       S             12A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             12A

     D OLD_MATD        S              5P 0

     D CER020          S              1A                                                    BUG22103
      *                                                                                     BUG23225
     D WDFMDT          S              5P 0                                                  BUG23225
     D WDMDAT          S              5P 0                                                  BUG23225
      *                                                                                     BUG23225
     D PZErr           S              7A                                                    BUG23225
     D PZDate          S              6P 0                                                  BUG23225
     D PZDatFm         S              1A                                                    BUG23225
     D PZDayNo         S              5P 0                                                  BUG23225
      *                                                                                     BUG23225
     D CRE073          S              1A   INZ('N')                                           CRE073
     D ddCNSPOK        S              1A                                                      CRE073
     D ddRDMTOK        S              1A                                                      CRE073
     D ddRDFDOK        S              1A                                                      CRE073
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D/COPY WNCPYSRC,MMRODLUD01

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C**********         MOVEL     Infdata500    Infdata                                     CSF011A
     C                   MOVEL     Extdata500    Extdata

      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      * Retrieve details of deal to be rolled-over

     C                   EXSR      MMLDNIRTV
                                                                                              CSD095
     C                   IF        DDACTN = 'I'                                               CSD095
     C                   EXSR      DftSettmts                                                 CSD095
     C                   ENDIF                                                                CSD095
                                                                                              CSD095
     C                   EXSR      SetupAmend                                                BUG7154

      * Process the transaction.

     C                   IF        (DDRACT = 'C') OR (DDRACT = 'R')

      * Validate transaction details

     C                   EXSR      MMLDNIROV
      *                                                                                     BUG22103
      ***If*CER020*is*on*and*DDMDAT*is*ok,*then*default*DDFMDT*with                BUG22103 BUG23225
      ***new*maturity*date                                                         BUG22103 BUG23225
      *                                                                                     BUG22103
     C**********         IF        ddMDATok = 'Y' AND CER020 = 'Y'                 BUG22103 BUG23225
      *                                                                                     BUG23225
     C                   MOVE      DDFMDT        PZDate                                     BUG23225
      *                                                                                     BUG23225
     C                   CALL      'ZDATE1'                                                 BUG23225
     C                   PARM                    PZErr                                      BUG23225
     C                   PARM                    PZDate                                     BUG23225
     C                   PARM      BJDFIN        PZDatFm                                    BUG23225
     C                   PARM                    PZDayNo                                    BUG23225
      *                                                                                     BUG23225
     C                   EVAL      WDFMDT = PZDayNo                                         BUG23225
      *                                                                                     BUG23225
     C                   MOVE      DDMDAT        PZDate                                     BUG23225
      *                                                                                     BUG23225
     C                   CALL      'ZDATE1'                                                 BUG23225
     C                   PARM                    PZErr                                      BUG23225
     C                   PARM                    PZDate                                     BUG23225
     C                   PARM      BJDFIN        PZDatFm                                    BUG23225
     C                   PARM                    PZDayNo                                    BUG23225
      *                                                                                     BUG23225
     C                   EVAL      WDMDAT = PZDayNo                                         BUG23225
      *                                                                                     BUG23225
      ** If CER020 is on and previous deals final maturity date is less                     BUG23225
      ** than the current deal's maturity date, then the final maturity                     BUG23225
      ** date of the current deal is defaulted from the current deal's                      BUG23225
      ** maturity date                                                                      BUG23225
      *                                                                                     BUG23225
     C                   IF        WDFMDT < WDMDAT AND CER020 = 'Y'                         BUG23225
     C                   EVAL      DDFMDT = DDMDAT                                          BUG22103
     C                   ENDIF                                                              BUG22103

      * If action (DDRACT) is 'R', blank out DDAMNP as this is only
      * applicable if rolling the deal over to Euro (DDRACT='C').

     C                   IF        DDRACT = 'R'
     C                   EVAL      DDAMNP = *BLANK
     C                   ENDIF

     C                   ENDIF

     C     INVALID       TAG

     C                   SETON                                        LR

     C**********         EVAL                    Buffer = TranIN + DDRAMN                    BUG7154
     C**********                                 + DDRACT                                    BUG7154
     C                   EVAL                    Buffer = TranIN                             BUG7154
     C**********                                 + InfData + InRecSttmt                      CSF011A
     C                                           + InRecSttmt                                CSF011A
     C                                           + InPaySttmt + ExtData

     C                   RETURN

      *****************************************************************
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
     C***********        PARM                    InfData500                                  CSF011A
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
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

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'SDUSRMSG'                                  CRE073

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMLDNIM01

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END

      ** Access SAR Details file to determine if BRT SAR is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
      *
      ** If BRT SAR installed, access BRT installation control data
      *
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           BRTKEY            1
     C     BRTKEY        CHAIN     SDBRTDD0                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDBRTDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     BRTKEY        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if CEU015 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU015'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU015            1
     C                   ENDIF
      *
      ** ACCESS EURO CURRENCY DECIMAL PLACES
      *
     C     CEU015        IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BKEURO        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     BKEURO        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6NBDP        EuroNBDP          1 0
     C                   END

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Access SAR details file to determine if
      ** Deposit Breakdown Penalty is installed
      *
     C                   MOVEL     'N'           CDL007            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL007
     C                   ENDIF
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
                                                                                              CDL033
      ** Verify if Floating Rate CDs Issued enhancement is on.                                CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      @RTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CDL033            1                          CDL033
     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 908                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033

      *                                                                                     BUG22103
      ** Access SAR Details file to determine if CER020 is installed                        BUG22103
      *                                                                                     BUG22103
     C                   MOVE      'N'           CER020                                     BUG22103
     C                   CALL      'AOSARDR0'                                               BUG22103
     C                   PARM      *BLANKS       @RTCD                                      BUG22103
     C                   PARM      '*VERIFY'     @OPTN                                      BUG22103
     C                   PARM      'CER020'      @SARD                                      BUG22103
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22103
      *                                                                                     BUG22103
      ** Database Error                                                                     BUG22103
      *                                                                                     BUG22103
     C     @RTCD         IFNE      *BLANKS                                                  BUG22103
     C     @RTCD         ANDNE     '*NRF   '                                                BUG22103
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG22103
     C                   MOVEL     '909'         DBASE                                      BUG22103
     C                   MOVEL     @RTCD         DBKEY                                      BUG22103
     C                   EXSR      *PSSR                                                    BUG22103
     C                   ENDIF                                                              BUG22103
      *                                                                                     BUG22103
     C     @RTCD         IFEQ      *BLANKS                                                  BUG22103
     C                   MOVEL     'Y'           CER020                                     BUG22103
     C                   ENDIF                                                              BUG22103
                                                                                            BUG22103
      *                                                                                       CRE073
      ** Access SAR details file to determine if CRE073 is installed                          CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       @RTCD                                        CRE073
     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
     C                   PARM      'CRE073'      @SARD                                        CRE073
      *                                                                                       CRE073
      * DATABASE ERROR                                                                        CRE073
      *                                                                                       CRE073
     C     @RTCD         IFNE      *BLANKS                                                    CRE073
     C     @RTCD         ANDNE     '*NRF   '                                                  CRE073
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE073
     C                   MOVEL     '910'         DBASE                                        CRE073
     C                   MOVEL     @RTCD         DBKEY                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C     @RTCD         IFEQ      *BLANKS                                                    CRE073
     C                   MOVE      'Y'           CRE073                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MMLDNIRTV  - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     MMLDNIRTV     BEGSR

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the MM database is retrieved as well.

      *
      ** Use deal to be rolled over for retrieving details and only
      ** use Enquire mode. Use work fields to avoid overwriting the
      ** the original values in TranIn for Deal No. and Action Code.
      *
     C                   MOVEL     DDDADN        WDLNO             6
     C                   MOVEL     'E'           WACTN             1

     C                   CALLB     'MMLDNIRTV'

      * INPUTS
      * Return code
     C                   PARM      *BLANK        ReturnCode

      * Mode = '*FRONT' (Front Office transaction interface)
      * Mode = '      ' (Not Front Office transaction interface)
     C                   PARM      '      '      ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE

      * Action Code
     C                   PARM                    WACTN

      * Front Office Transaction ID
     C                   PARM      *BLANK        APFOTranID

      * Front Office Associated Transaction Id
     C                   PARM      *BLANK        APFOAsocID

      * (Midas) Deal Number
     C                   PARM                    WDLNO

      * (Midas) Depot Movement Reference

     C                   PARM                    DDDDMR            6

      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN

      * Booking branch
     C                   PARM                    DDBRCA

      * REPO Flag
     C                   PARM      'N'           RepoFlag          1

      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789

      * OK - Action code
     C                   PARM      *BLANK        OKACTN

      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO

      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
                                                                                             BUG2804
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C/COPY WNCPYSRC,MMRODLUC01

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
     C                             OR  DDRSTM = '00'                                          CSD095
     C                             AND DDPSTM = '00'                                          CSD095

     C                   CALLB     'ZASETINDFT'

      ** INPUT
      ** -----
      ** Calling function type
     C                   PARM                    LDNI
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    DDCcy
      ** Customer (shortname or number)
     C                   PARM                    DDCust
      ** Deal type
     C                   PARM                    DDType
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
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDSTYP                                       CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRCA                                       CSD095
      *
      ** OUTPUT
      ** ------
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

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C                   IF            (InPaySttmt = *blank)
     C                                 OR DDPSTM = '00'                                       CSD095
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C                   IF            (InRecSttmt = *blank)
     C                                 OR DDRSTM = '00'                                       CSD095
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF

      * Do data substitution for Settlement Instructions

     C     GHSUBS        IFNE      *BLANK
     C     GHSUBS        SCAN      InPaySttmt                             99
     C  N99GHSUBS        SCAN      InRecSttmt                             99
     C     *in99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MMLDNIROV  - Routine to validate the main transaction details *
      *                                                               *
      *****************************************************************

     C     MMLDNIROV     BEGSR

      * Call the rollover validation module

     C                   CALLB     'MMLDNIROV'
      * -------+
      * INPUTS ¦
      * -------+
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Rollover action
     C                   PARM                    DDRACT
      * Rollover deal number
     C                   PARM                    DDDADN            6
      * Deal Number
     C                   PARM                    DDDLNO            6
      * Rollover amount
     C                   PARM                    DDRAMN
      * Maturity Date
     C                   PARM                    DDMDAT            6
      * Base Rate Code
     C                   PARM                    DDBSRC            2
      * Spread/Rate
     C                   PARM                    DDSPRT           12
      * Interest Calc. Method
     C                   PARM                    DDICMT            1
      * Booking Branch
     C                   PARM                    DDBRCA            3
      * New Deal Currency
     C                   PARM                    DDCCY             3
      * Principal Amount
     C                   PARM                    DDAMNP           14
      * Contractual Spread                                                                    CRE073
     C                   PARM                    DDCNSP                                       CRE073
      * Rounding Method                                                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
      * Rounding Fraction/Decimal                                                             CRE073
     C                   PARM                    DDRDFD                                       CRE073
      * Old Maturity Date
     C                   PARM                    OldMatDate        5 0
      * Old Deal Currency
     C                   PARM                    HKCCY
      * Old Deal Currency Decimal Places
     C                   PARM                    HKCYDP
      * Date format
     C                   PARM                    BJDFIN            1
      * Euro currency code
     C                   PARM                    BKEURO            3
      * Currency decimal separator
     C                   PARM                    BNDCSP            1
      * Euro currency decimal places
     C                   PARM                    EuroNBDP
      ** Floating Rate CDs Issued                                                             CDL033
     C                   PARM                    CDL033                                       CDL033
      ** EMU Money Market Rollovers                                                           238592
     C                   PARM                    CEU015                                       238592
      ** Interest Rate Rounding                                                               CRE073
     C                   PARM                    CRE073                                       CRE073
      * --------+
      * OUTPUTS ¦
      * --------+
      *
      ** Rollover Action - OK
      ** Rollover Deal Number- OK
      ** Deal number - OK
      ** Principal Amount - OK
      ** Maturity Date - OK
      ** Base Rate Code - OK
      ** Spread/Rate - OK
      ** Int.Calc.Method - OK
      ** Euro Currency Code - OK                                                            BUG17342
     C                   PARM      'Y'           ddRACTok          1            broker
     C                   PARM      'Y'           ddDADNok          1            broker
     C                   PARM      'Y'           ddDLNOok          1            broker
     C                   PARM      'Y'           ddRAMNok          1            brokerage
     C                   PARM      'Y'           ddMDATok          1            brokerage
     C                   PARM      'Y'           ddBSRCok          1            brokerage
     C                   PARM      'Y'           ddSPRTok          1            brokerage
     C                   PARM      'Y'           ddICMTok          1            brokerage
     C                   PARM      'Y'           ddEUROok          1            brokerage   BUG17342
     C                   PARM      'Y'           ddCNSPOK                                     CRE073
     C                   PARM      'Y'           ddRDMTOK                                     CRE073
     C                   PARM      'Y'           ddRDFDOK                                     CRE073
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        WFldNamArr
     C                   PARM      *BLANK        WMsgIDArr
     C                   PARM      *BLANK        WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         WIdx              3 0

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
     C                   CALLB     'MMLDNICVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *                                                                         MD054028
     C                   PARM                    DDAPRC            1            MD054028
     C                   PARM                    DDAPRR            8            MD054028

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10

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
     C                   PARM      DealScnfmt    CurDATA        2000

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

     C                   MOVE      *ALL'Y'       MMELDN

     C                   RESET                   AmendOK

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKOMDT

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
     C                   PARM      *ZEROS        IKDN38

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKDLNO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        IKDN38

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 BUG7154
      *****************************************************************                      BUG7154
      *                                                               *                      BUG7154
      * SETUPAMEND - Set up fields that are needed in the validation  *                      BUG7154
      *    of Amendments.                                             *                      BUG7154
      *                                                               *                      BUG7154
      *****************************************************************                      BUG7154
                                                                                             BUG7154
     C     SetupAmend    BEGSR                                                               BUG7154
                                                                                             BUG7154
      * For Amends, put the complete (pre-existing) deal into the Valid                      BUG7154
      *  file record - fields in this will be updated during  processing                     BUG7154
     C                   MOVEL     DealFilFmt    ValidDeal                                   BUG7154
     C                   Z-ADD     HKMATD        OLD_MATD                                    BUG7154
                                                                                             BUG7154
      *  The Settlement Instructions fields may not be supplied for an                       BUG7154
      *  amendment. If none of the pay/receive instructions were                             BUG7154
      *  supplied (i.e. all are blank), default the existing database                        BUG7154
      *  values into the special DB Settlement Instructions DSs ....                         BUG7154
                                                                                             BUG7154
     C                   IF            (InRecSttmt = *blank)                                 BUG7154
     C                             AND (InPaySttmt = *blank)                                 BUG7154
                                                                                             BUG7154
     C                   EVAL      FLRSTM     = HKRSTM                                       BUG7154
     C                   EVAL      FLRONS     = HKRONS                                       BUG7154
     C                   EVAL      FLREC2     = DELDRecIns                                   BUG7154
     C                   EVAL      FLROBR     = HKROBR                                       BUG7154
     C                   EVAL      FLRSCY     = HKSTCY                                       BUG7154
     C                   EVAL      FLRMAC     = HKRMAC                                       BUG7154
     C                   EVAL      FLPSTM     = HKPSTM                                       BUG7154
     C                   EVAL      FLPONS     = HKPONS                                       BUG7154
     C                   EVAL      FLPAY2     = DELDPayIns                                   BUG7154
     C                   EVAL      FLPOBR     = HKPOBR                                       BUG7154
     C                   EVAL      FLCVMR     = HKCVMR                                       BUG7154
     C                   EVAL      FLPSCY     = HKSTCY                                       BUG7154
     C                   EVAL      FLIC72     = HKIC72                                       BUG7154
     C                   EVAL      FLPMAC     = HKPMAC                                       BUG7154
                                                                                             BUG7154
      *  .... and then convert these to the screen format                                    BUG7154
     C                   CALLB     'ZASETINCVT'                                              BUG7154
                                                                                             BUG7154
      ** Defaulted Settlement Instructions in file format                                    BUG7154
     C                   PARM                    DBPaySttmt                                  BUG7154
     C                   PARM                    DBRecSttmt                                  BUG7154
     C                   PARM                    DBFRASttmt                                  BUG7154
                                                                                             BUG7154
      ** Defaulted Settlement Instruction in input format                                    BUG7154
     C                   PARM                    InPaySttmt                                  BUG7154
     C                   PARM                    InRecSttmt                                  BUG7154
     C                   PARM                    InFRASttmt                                  BUG7154
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A
                                                                                             BUG7154
     C                   ENDIF                                                               BUG7154
                                                                                             BUG7154
      * Do data substitution for Settlement Instructions                                     BUG7154
                                                                                             BUG7154
     C     GHSUBS        IFNE      *BLANK                                                    BUG7154
     C     GHSUBS        SCAN      InPaySttmt                             99                 BUG7154
     C  N99GHSUBS        SCAN      InRecSttmt                             99                 BUG7154
     C     *IN99         IFEQ      *ON                                                       BUG7154
     C                   EXSR      SDtDtaSubs                                                BUG7154
     C                   ENDIF                                                               BUG7154
     C                   ENDIF                                                               BUG7154
                                                                                             BUG7154
     C                   ENDSR                                                               BUG7154
      *****************************************************************                      BUG7154
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
