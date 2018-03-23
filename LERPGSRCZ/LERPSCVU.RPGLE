     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule validate and update')     *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LERPSCVU - LE Repayments Schedule validate and update        *
      *                                                               *
      *  Function: This Program Validates Repayments schedule for     *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the repayment sch. details fields     *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CLE168             Date 26Feb18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD049007           Date 15Dec17               *
      *                 MD032213           Date 06Aug15               *
      *                 CLE154             Date 02Aug12               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025105B          Date 16Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD021356           Date 24Jul13               *
      *                 AR868380           Date 11Jun13               *
      *                 AR723989           Date 17Sep12               *
      *                 AR693137           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863281           Date 16Nov11               *
      *                 CSF011             Date 12Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245227A            Date 30Mar07               *
      *                 246768             Date 30Mar07               *
      *                 BUG13710           Date 03Apr07               *
      *                 BUG13350           Date 20Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10331           Date 08Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 BUG8955            Date 11Oct05               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4960            Date 22Dec04               *
      *                 BUG4482            Date 29Sep04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 30Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE168 - Allow Debit of Blocked Account                      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD049007 - Repayment schedules cannot be completed when      *
      *             CLE034 is ON and Settlement C is defined          *
      *  MD032213 - SOAP RPSC UPDATE unexpected error                 *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025105B - API Reverse of RPSC returns error for DDACTN     *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD021356 - Impossible to input repayment schedule for parti- *
      *             cipation sold; pattern fix after AR1069948        *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR723989 - Receipt settlement is set to 00 during insert when*
      *             settlement details were amended after loan details*
      *             has been defaulted (Child: AR723990)              *
      *  AR693137 - Autosettle cannot be 'C' if loan processing type  *
      *             is not equal to 61, 62, 64, 68 and 80. Also, when *
      *             pre-deal check is defined, Receipt/Pay settlement *
      *             should be equal to 01, 05, 08 or 14. Patterned fix*
      *             from AR634878/A and AR314018. (Child: AR693138)   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - Some codes of AR863281 will be physically deleted  *
      *          - CCR016: Settlement Allocation                      *
      *  AR863281 - Pay Settlement Customer Name on Inputs fields     *
      *             are not displayed                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245227A - Recompiled due to changes in LERPSCUPD.            *
      *  246768 - Wrong buffer Extdata, must be based on LERPEXPD     *
      *  BUG13710- Populate DDATYP only during update                 *
      *  BUG13350-Ensure Amendment type screen field is populated     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10331 - Recompiled due to changes in LERPS2PD.            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  BUG8955 - Ensure that correct status will be used upon       *
      *            authorisation.                                     *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates                           *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it                                          *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Î F-specs                              Î
      ** Î =======                              Î
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK                                                       CLE036
     F                                     PREFIX(CL)                                         CLE036
     F                                     IGNORE(CLOANHHF)                                   CLE036
     F                                     IGNORE(CLOANCKF)                                   CLE036
     F                                     IGNORE(CLOANZ1F)                                   CLE036

      *****************************************************************
      ** +--------------------------------------+
      ** Î Automatically included D-specs       Î
      ** Î ==============================       Î
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

      ** +--------------------------------------+
      ** Î End of automatically included D-specsÎ
      ** Î =====================================Î
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** Î Manually included D-specs            Î
      ** Î =========================            Î
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Î Named constants                      Î
      ** Î ===============                      Î
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Î Arrays and Data Structures           Î
      ** Î ==========================           Î
      ** +--------------------------------------+

     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming Transaction
     D TranInRPSC    E DS                  EXTNAME(LERPSCPD)
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** Interface Data Format Definition File format                                         CAP086

      ** Incoming Transaction 2                                                               CLE106
     D TranInRPS2    E DS                  EXTNAME(LERPS2PD)                                  CLE106
                                                                                              CLE106
      ** Repayment schedule Extra Data - File (D/B) format
     D***ExtData*******E DS                  EXTNAME(LECLEXPD)                                246768
     D ExtData       E DS                  EXTNAME(LERPEXPD)                                  246768

      ** Valid repayment schedules layout
     D ValidRPSC     E DS                  EXTNAME(LEVRPSCPD)
     D                                     PREFIX(V_)
     D***ValidREC             321    389                                                      CGL029
     D***ValidPAY             390    948                                                      CGL029
     D  ValidREC             335    389                                                       CGL029
     D  ValidPAY             404    948                                                       CGL029
     D  ValidRECEx          1195   1212                                                       CGL029
     D  ValidPAYEx          1213   1230                                                       CGL029

      ** (Current) repayment schedule in file Format
     D RPSCFilFmt    E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(RP_)

      ** (Current) Transaction in Screen Format - Main Details
     D CurTrRPSC     E DS                  EXTNAME(LERPSCPD)
     D                                     PREFIX(@)

      ** Error indicators
     D OKTrRPSC      E DS                  EXTNAME(LEERPSCPD)

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
      *                                                                                       CLE168
     D LEFCLY        E DS                  EXTNAME(LEFCLYPP) DTAARA                           CLE168
     D                                     PREFIX(A_)                                         CLE168
      *                                                                                       CLE168
      ** Old settlement details
     D  OldStsDS       DS
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029

      ** New settlement details
     D  NewStsDS       DS
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029

      ** New settlement details
     D  PasDtaDS       DS           256
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20

      ** Last change data - LOAMS
     D                 DS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11

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

      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSF011
      ** +--------------------------------------+
      ** Î Declared variables                   Î
      ** Î ==================                   Î
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
     D Trans5002       S            500A                                                      CLE106

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Parameters for LERPSCRTV
     D ModeofOp        S              6

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

      ** Parameters for LERPSC1VL
     D PTypFilCLOAN    S              2
     D BrcaFilCLOAN    S              3                                                      BUG4960

      ** Parameters for ZDATE1
     D DATEA           S              6
     D ZDAYNO          S              5  0
     D ErrorFlag       S              1

      ** Parameters for ZASETINVAL
     D ##BRCA          S              3
     D ##DATR          S              5  0
     D ##DATP          S              5  0
     D ##ACTN          S              1
     D ##VALITER       S              3

      ** Parameters for LERPSCAMD
     D ResetErrs       S              1

      ** Parameters for *ENTRY
     D UpdateYN        S              1
     D Buffer          S           6000
     D APIRetc         S              1

      ** Switchable features
     D CLE106          S              1                                                       CLE106
     D CLE034          S              1A                                                      CLE034
     D CLE036          S              1A                                                      CLE036
     D CLE005          S              1
     D CEU004          S              1
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
     D CAP086          S              1A   INZ('N')                                           CAP086
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
                                                                                              TDA070
      ** Work Variables                                                                       CLE036
     D*KLNRF****       S              6S 0                                             CLE036 CLE148
     D KLNRF           S              6A                                                      CLE148
     D WPCurr          S              3A                                                      CLE036
     D WRCurr          S              3A                                                      CLE036
     D TmpCURR         S              3                                                       CLE106
     D TmpSAMT         S             14                                                       CLE106
     D PTYPE           S              4A                                                    AR723989
                                                                                              CLE036
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) PREFIX(WrkLn)                   MD021356
     D  LoanRecInst          473    527                                                     MD021356
     D  LoanPayInst          542   1086                                                     MD021356
     D  LoanRecInstEx       1597   1614                                                     MD021356
     D  LoanPayInstEx       1615   1632                                                     MD021356
      *                                                                                     MD021356
      ** Loan Details                                                                       MD021356
      *                                                                                     MD021356
      ** +--------------------------------------+
      ** Î End of D-specs                       Î
      ** Î ==============                       Î
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** Î Hook for non-core D-specs (all types)  Î
      ** Î also any I-specs (if necessary)        Î
      ** Î =====================================  Î
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** Î                                                                Î
      ** Î Initial processing is performed automatically: the *INZSR is   Î
      ** Î executed at program activation.                                Î
      ** Î                                                                Î
      ** +----------------------------------------------------------------+


      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   EVAL      TranInRPSC = Trans5001
     C                   EVAL      TranInRPS2 = Trans5002                                     CLE106
     C                   EVAL      InfData = InfData500                                       CAP086
     C                   EVAL      Extdata = Extdata500
                                                                                            BUG13350
      ***Set*up*Amendment*Type*field*to*be*'RE'************************            BUG13350 BUG13710
     C**********         EVAL      DDATYP = 'RE'                                   BUG13350 BUG13710

      ** Reset variables gradually updated
     C                   EXSR      RESETCYCLE

      ** Validate Action Code
     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      ** Processing depends upon Action Code
     C                   SELECT

      ** Processing for Inserts
     C                   WHEN         DDACTN = 'I'
     C                   IF        CLE036 = 'Y'                                               CLE106
     C                   EXSR      SRCnvAmt                                                   CLE106
     C                   ENDIF                                                                CLE106
     C                   EXSR      ValidateTr

      ** If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *****************************************************************            AR723989 MD021356
      ***For*repayment*schedule,*determine*if*loan*is*participation*sold.          AR723989 MD021356
      *****************************************************************            AR723989 MD021356
     C**********         MOVE      '    '        PTYPE                             AR723989 MD021356
     C*****PTypFilCLOAN  IFEQ      '66'                                            AR723989 MD021356
     C*****PTypFilCLOAN  OREQ      '67'                                            AR723989 MD021356
     C*****PTypFilCLOAN  OREQ      '69'                                            AR723989 MD021356
     C*****PTypFilCLOAN  OREQ      '72'                                            AR723989 MD021356
     C**********         MOVE      'PTSO'        PTYPE                             AR723989 MD021356
     C**********         ENDIF                                                     AR723989 MD021356
      *****************************************************************            AR723989 MD021356
      ***Blank*out*invalid*settlement*side.****************************            AR723989 MD021356
      *****************************************************************            AR723989 MD021356
     C*****PTYPE         IFEQ      'PTSO'                                          AR723989 MD021356
     C**********         MOVE      *BLANKS       InRecSttmt                        AR723989 MD021356
     C**********         ELSE                                                      AR723989 MD021356
     C**********         MOVE      *BLANKS       InPaySttmt                        AR723989 MD021356
     C**********         ENDIF                                                     AR723989 MD021356
      *                                                                                      BUG8529
      ** Default settlement details from related loan                                        BUG8529
     C**********         IF        InRecSttmt = *blank AND                          BUG8529 AR723989
     C**********                   InPaySttmt = *blank AND                          BUG8529 AR723989
     C**********                   PRcvParm <> *blank AND                           BUG8529 AR723989
     C**********                   PPayParm <> *blank                               BUG8529 AR723989
     C**********         MOVEL     PRcvParm      InRecSttmt                         BUG8529 AR723989
     C**********         MOVEL     PPayParm      InPaySttmt                         BUG8529 AR723989
     C**********         EndIf                                                      BUG8529 AR723989
     C**********         IF        InRecSttmt = *BLANK AND                         AR723989 MD021356
     C**********                   PTYPE      = '    ' AND                         AR723989 MD021356
     C**********                   PRcvParm <> *BLANK                              AR723989 MD021356
     C**********         MOVEL     PRcvParm      InRecSttmt                        AR723989 MD021356
     C**********         ENDIF                                                     AR723989 MD021356
     C**********         IF        InPaySttmt = *BLANK AND                         AR723989 MD021356
     C**********                   PTYPE      = 'PTSO' AND                         AR723989 MD021356
     C**********                   PPayParm <> *BLANK                              AR723989 MD021356
     C**********         MOVEL     PPayParm      InPaySttmt                        AR723989 MD021356
     C**********         ENDIF                                                     AR723989 MD021356

     C                   EXSR      DftSettmts
      *****************************************************************            AR723989 MD021356
      ***Blank*out*invalid*settlement*side.****************************            AR723989 MD021356
      *                                                                            AR723989 MD021356
     C*****PTYPE         IFEQ      'PTSO'                                          AR723989 MD021356
     C**********         MOVE      *BLANKS       InRecSttmt                        AR723989 MD021356
     C**********         ELSE                                                      AR723989 MD021356
     C**********         MOVE      *BLANKS       InPaySttmt                        AR723989 MD021356
     C**********         ENDIF                                                     AR723989 MD021356
      *****************************************************************            AR723989 MD021356
     C                   EXSR      ValidateSt

      ** Processing for Amends or Changes
     C                   WHEN      DDACTN = 'A' OR DDACTN = 'R'
     C                   EXSR      SetupAmd
     C                   EXSR      SRCnvAmt                                                   CLE106
     C                   EXSR      ValidateTr

      ** If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

     C                   EXSR      ValidateSt
      *                                                                                    MD025105B
      ** No need for validation of amendment for action 'R' since                          MD025105B
      ** record is being reversed.                                                         MD025105B
      *                                                                                    MD025105B
     C                   IF        DDACTN = 'A'                                            MD025105B
     C                   EXSR      ValdateAmd
     C                   ENDIF                                                             MD025105B
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482

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
     C**********         EVAL      Buffer = TranInRPSC + InRecSttmt                           CLE106
     C**********                           + InPaySttmt + ExtData                             CAP086
     C                   EVAL      Buffer = TranInRPSC + TranInRPS2                           CLE106
     C                                     + InRecSttmt                                       CLE106
     C                                     + InPaySttmt + InfData + ExtData                   CAP086

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
     C                   CALLB     'LERPSCRTV'

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

      **(Midas) Sequence no.
     C                   PARM                    DDSEQN

      ** (Midas) Value date
     C                   PARM                    DDVDAT

      ** Outputs

      ** (Current) Repayment sch. in file format
     C                   PARM                    RPSCFilFmt

      ** OK - Action code
     C                   PARM                    DDActnOK

      ** OK - Transaction Number
     C                   PARM                    DDLnrfOK

      ** OK - Sequence no.
     C                   PARM      *BLANK        DDSeqnOK

      ** OK - Value Date
     C                   PARM      *BLANK        DDVdatOK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
     C                   PARM                    WrkLnDetails                               MD021356

      ** Save the settlement details for update if not insert
     C                   IF        DDACTN <> 'I'
     C                   EVAL      OSETP = RP_SETP
     C                   EVAL      OOSAC = RP_OSAC
     C                   EVAL      OTSEN = RP_TSEN
     C                   EVAL      OFACO = RP_FACO
     C                   EVAL      OSPI1 = RP_SPI1
     C                   EVAL      OSPI2 = RP_SPI2
     C                   EVAL      OSPI3 = RP_SPI3

      ** Save the last update for test
     C                   EVAL      WLCD = RP_LCD
     C                   EVAL      WCHTP = RP_CHTP
     C                   EVAL      WTNLU = RP_TNLU
     C                   EVAL      SAVLC = WLSTC
     C                   EVAL      ValidRpSc = RpScFilFmt
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR

      * If ANY of the Settlements fields have been entered, bypass this
      * routine.
      * Otherwise, use modules which will use Standard Settlement
      * Instructions to apply defaults.
     C                   IF        InRecSttmt = *blank AND
     C                             InPaySttmt = *blank
     C                   EVAL      FLPEXR = *ZEROS                                          MD021356
     C                   EVAL      FLREXR = *ZEROS                                          MD021356
      *                                                                                     MD021356
      ** Need to set correct customer number for defaults                                   MD021356
      *                                                                                     MD021356
     C                   IF        PTypFilCLOAN = '64' OR                                   MD021356
     C                             PTypFilCLOAN = '65' OR                                   MD021356
     C                             PTypFilCLOAN = '68' OR                                   MD021356
     C                             PTypFilCLOAN = '71'                                      MD021356
     C                   MOVEL     WrkLnOLNO     ##CSNM                                     MD021356
     C                   ELSE                                                               MD021356
     C                   MOVEL     DDCUST        ##CSNM                                     MD021356
     C                   ENDIF                                                              MD021356

     C                   CALLB     'ZASETINDFT'
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP
      ** Payment currency
     C                   PARM      DDCURR        ##PCCY
      ** Receive currency
     C                   PARM      DDCURR        ##RCCY
      ** Customer (shortname or number)
     C**********         PARM      DDCUST        ##CSNM                                     MD021356
     C                   PARM                    ##CSNM                                     MD021356
      **  Loan Type
     C                   PARM      PTypFilCLOAN  ##TTYP
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
      *                                                                                     MD021356
     C                   IF            FLRSTM     = 00                                      MD021356
     C                             AND FLPSTM     = 00                                      MD021356
                                                                                            MD021356
     C                   EVAL      FLRSTM     = WrkLnRSTM                                   MD021356
     C                   EVAL      FLRONS     = WrkLNRONS                                   MD021356
     C                   EVAL      FLREC      = LoanRecInst                                 MD021356
      *                                                                                     MD021356
      ** If not a Part Sold, receive branch is our maturity date branch                     MD021356
      ** If Part Sold, receive branch is our start date branch                              MD021356
      *                                                                                     MD021356
     C                   IF        WrkLnPTYP <> 66                                          MD021356
     C                             AND WrkLnPTYP <> 67                                      MD021356
     C                             AND WrkLnPTYP <> 69                                      MD021356
     C                             AND WrkLnPTYP <> 72                                      MD021356
     C                   EVAL      FLROBR     = WrKLnOMDB                                   MD021356
     C                   ELSE                                                               MD021356
     C                   EVAL      FLROBR     = WrKLnOSDB                                   MD021356
     C                   ENDIF                                                              MD021356
      *                                                                                     MD021356
     C                   EVAL      FLPSTM     = WrkLnPSTM                                   MD021356
     C                   EVAL      FLPONS     = WrkLnPONS                                   MD021356
     C                   EVAL      FLPAY      = LOANPayInst                                 MD021356
      *                                                                                     MD021356
      ** If not a Part Sold, pay branch is our start date branch                            MD021356
      ** If Part Sold, pay branch is our maturity date branch                               MD021356
      *                                                                                     MD021356
     C                   IF        WrkLnPTYP <> 66                                          MD021356
     C                             AND WrkLnPTYP <> 67                                      MD021356
     C                             AND WrkLnPTYP <> 69                                      MD021356
     C                             AND WrkLnPTYP <> 72                                      MD021356
     C                   EVAL      FLPOBR     = WrkLnOSDB                                   MD021356
     C                   ELSE                                                               MD021356
     C                   EVAL      FLPOBR     = WrkLnOMDB                                   MD021356
     C                   ENDIF                                                              MD021356
      *                                                                                     MD021356
     C                   EVAL      FLCVMR     = WrkLnCVMR                                   MD021356
     C                   EVAL      FLPSCY     = WrkLnPSCY                                   MD021356
     C                   EVAL      FLIC72     = WrkLnICCY                                   MD021356
                                                                                            MD021356
     C                   ENDIF                                                              MD021356

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
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A

     C                   ENDIF

      ** Clear settlement instructions depending on loan processing                           CLE106
      ** type - rules are as follows :-                                                       CLE106
      ** Processing types 61/62/63/64/65/68/70/71 - s/be Receipt only                         CLE106
      ** Processing types 66/67/69/72 - s/be Payment only                                     CLE106
                                                                                              CLE106
     C                   SELECT                                                               CLE106
     C                   WHEN         PTypFilCLOAN = '61'                                     CLE106
     C                             OR PTypFilCLOAN = '62'                                     CLE106
     C                             OR PTypFilCLOAN = '63'                                     CLE106
     C                             OR PTypFilCLOAN = '64'                                     CLE106
     C                             OR PTypFilCLOAN = '65'                                     CLE106
     C                             OR PTypFilCLOAN = '68'                                     CLE106
     C                             OR PTypFilCLOAN = '70'                                     CLE106
     C                             OR PTypFilCLOAN = '71'                                     CLE106
     C                   EVAL      DBPaySttmt = *Blanks                                       CLE106
     C                   EVAL      InPaySttmt = *Blanks                                       CLE106
     C                   EVAL      FLPSTM = 00                                                CLE106
     C**********         EVAL      DDPSTM = '00'                                     CLE106 MD021356
     C                   EVAL      ##PPAY = 'Y'                                             MD021356
     C                   EVAL      ##PREC = ' '                                             MD021356
     C                   IF        InRecSttmt = *Blanks                                       CLE106
     C                   EVAL      DBRecSttmt = *Blanks                                       CLE106
     C                   EVAL      InRecSttmt = *Blanks                                       CLE106
     C                   EVAL      FLRSTM = 00                                                CLE106
     C                   EVAL      DDRSTM = '00'                                              CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   WHEN         PTypFilCLOAN = '66'                                     CLE106
     C                             OR PTypFilCLOAN = '67'                                     CLE106
     C                             OR PTypFilCLOAN = '69'                                     CLE106
     C                             OR PTypFilCLOAN = '72'                                     CLE106
     C                   EVAL      DBRecSttmt = *Blanks                                       CLE106
     C                   EVAL      InRecSttmt = *Blanks                                       CLE106
     C                   EVAL      FLRSTM = 00                                                CLE106
     C**********         EVAL      DDRSTM = '00'                                     CLE106 MD021356
     C                   EVAL      ##PREC = 'Y'                                             MD021356
     C                   EVAL      ##PPAY = ' '                                             MD021356
     C                   IF        InPaySttmt = *Blanks                                       CLE106
     C                   EVAL      DBPaySttmt = *Blanks                                       CLE106
     C                   EVAL      InPaySttmt = *Blanks                                       CLE106
     C                   EVAL      FLPSTM = 00                                                CLE106
     C                   EVAL      DDPSTM = '00'                                              CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDSL                                                                CLE106
                                                                                              CLE106
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      ** For Amends, convert the repayment sch. to screen format
     C                   CALLB     'LERPSCCVT'

      ** Inputs

      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn

      ** Repayment schedule in File Format
     C                   PARM                    RPSCFilFmt

      ** Output Parameters

      ** Repayment schedule Details Screen Format
     C                   PARM                    CurTrRPSC

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      ** Use converted amount (loan ccy) as transaction amount                                CLE106
      ** so that details in valids file are in loan ccy.                                      CLE106
                                                                                              CLE106
     C                   IF        CLE036 = 'Y' And DDLCCY <> *Blanks                         CLE106
     C                   EVAL      TmpCURR = DDCURR                                           CLE106
     C                   EVAL      TmpSAMT = DDSAMT                                           CLE106
     C                   EVAL      DDCURR = DDLCCY                                            CLE106
     C                   EVAL      DDSAMT = DDLCPR                                            CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Validate Repayment Schedule details
     C                   CALLB     'LERPSC1VL'

      ** Inputs

      ** Response mode
     C                   PARM      'S'           APRespMode

      ** Repayment Schedule Transaction Details
     C                   PARM                    TranInRPSC
                                                                                              CAP086
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
                                                                                              CAP086

      ** Extra Data
     C                   PARM                    ExtData

      ** Outputs

      ** Repayment schedule Details OK inds
     C                   PARM                    OKTrRPSC

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
     C                   PARM                    ValidRPSC

      ** Processing type in CLOANCL file
     C                   PARM                    PTypFilCLOAN
                                                                                             BUG4960
      ** Branch from CLOANCL file                                                            BUG4960
     C                   PARM                    BrcaFilCLOAN                                BUG4960

      ** Return actual transaction details to screen fields                                   CLE106
                                                                                              CLE106
     C                   IF        CLE036 = 'Y' And DDLCCY <> *Blanks                         CLE106
     C                   EVAL      DDCURR = TmpCURR                                           CLE106
     C                   EVAL      DDSAMT = TmpSAMT                                           CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
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
     C                   EVAL      DATEA = DDVDAT

     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

      ** Set the Pay Date and Receive Date = Value Date
     C                   EVAL      ##DATP = ZDAYNO
     C                   EVAL      ##DATR = ZDAYNO

     C                   RESET                   ReturnCode
                                                                                             BUG4960
      ** Set loan type and branch correctly during insert                                    BUG4960
     C                   IF        DDACTN = 'I'                                              BUG4960
     C                   EVAL      ##TTYP = PTypFilCLOAN                                     BUG4960
     C                   ELSE                                                                BUG4960
     C                   EVAL      ##TTYP = RP_LTYP                                          BUG4960
     C                   ENDIF                                                               BUG4960
                                                                                             BUG4960
     C                   IF        DDACTN = 'I'                                              BUG4960
     C                   EVAL      ##BRCA = BrcaFilCLOAN                                     BUG4960
     C                   ELSE                                                                BUG4960
     C                   EVAL      ##BRCA = RP_BRCA                                          BUG4960
     C                   ENDIF                                                               BUG4960

      ** Settlement currency must always be in loan currency                                  CLE036
                                                                                              CLE036
     C                   IF        CLE036 = 'Y'                                               CLE036
     C                   MOVE      DDLNRF        KLNRF                                        CLE036
     C     KLNRF         CHAIN     CLOANCLF                                                   CLE036
     C                   EVAL      WPCurr = CLCCY                                             CLE036
     C                   EVAL      WRCurr = CLCCY                                             CLE036
                                                                                              CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      WPCurr = DDCURR                                            CLE036
     C                   EVAL      WRCurr = DDCURR                                            CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C**********         IF        DDPSTM = '  '                                   AR693137 MD021356
     C**********         EVAL      DDPSTM = '00'                                   AR693137 MD021356
     C**********         ENDIF                                                     AR693137 MD021356
      *****************************************************************            AR693137 MD021356
     C**********         IF        DDRSTM = '  '                                   AR693137 MD021356
     C**********         EVAL      DDRSTM = '00'                                   AR693137 MD021356
     C**********         ENDIF                                                     AR693137 MD021356
                                                                                            AR693137
     C                   IF        (DDAUTO = 'C' AND DDACTN='I')  OR                        AR693137
     C                             (DDAUTO = 'C' AND DDACTN='A')                            AR693137
                                                                                            AR693137
      ** Autosettle cannot be 'C' for processing type other than                            AR693137
      ** 61, 62, 64, 68 or 80.                                                              AR693137
                                                                                            AR693137
     C                   IF        PTypFilCLOAN <> '61' AND                                 AR693137
     C                             PTypFilCLOAN <> '62' AND                                 AR693137
     C                             PTypFilCLOAN <> '64' AND                                 AR693137
     C                             PTypFilCLOAN <> '68' AND                                 AR693137
     C                             PTypFilCLOAN <> '80'                                     AR693137
     C                   ADD       1             Idx                                        AR693137
     C                   EVAL      FldNameArr(Idx) = 'DDAUTO'                               AR693137
     C                   MOVEL     '5045815'     MsgIDArr(Idx)                              AR693137
     C                   GOTO      INVALID                                                  AR693137
     C                   ELSE                                                               AR693137
                                                                                            AR693137
      ** If pre-deal check is defined, settlement method should be equal                    AR693137
      ** to 01, 05, 08 or 14.                                                               AR693137
                                                                                            AR693137
     C                   IF        (PTypFilCLOAN = '80' AND DDPSTM <> '01' AND              AR693137
     C                             DDPSTM <> '05' AND DDPSTM <> '08' AND                    AR693137
     C                             DDPSTM <> '14')                                          AR693137
     C                   ADD       1             Idx                                        AR693137
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                               AR693137
     C                   MOVEL     '5045711'     MsgIDArr(Idx)                              AR693137
     C                   GOTO      INVALID                                                  AR693137
                                                                                            AR693137
     C**********         ELSEIF    (PTypFilCLOAN = '61' OR                         AR693137 MD049007
     C**********                   PTypFilCLOAN = '62' OR                          AR693137 MD049007
     C**********                   PTypFilCLOAN = '64' OR                          AR693137 MD049007
     C**********                   PTypFilCLOAN = '68') AND                        AR693137 MD049007
     C**********                   (DDRSTM <> '01' AND DDRSTM <> '05' AND          AR693137 MD049007
     C**********                   DDRSTM <> '08' AND DDRSTM <> '14')              AR693137 MD049007
     C**********         ADD       1             Idx                               AR693137 MD049007
     C**********         EVAL      FldNameArr(Idx) = 'DDRSTM'                      AR693137 MD049007
     C**********         MOVEL     '5045710'     MsgIDArr(Idx)                     AR693137 MD049007
     C**********         GOTO      INVALID                                         AR693137 MD049007
     C                   ENDIF                                                              AR693137
     C                                                                                      AR693137
     C                   ENDIF                                                              AR693137
     C                   ENDIF                                                              AR693137
                                                                                            AR693137
      *                                                                                       CLE168
      ** Get Facility Customer, Facility Type, Facility Sequence                              CLE168
      *                                                                                       CLE168
     C                   IF        DDLNRF <> *BLANKS AND CLE168 = 'Y'                         CLE168
     C     *LOCK         IN        LEFCLY                                                     CLE168
     C     DDLNRF        CHAIN     CLOANCLF                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      A_XCNUM = CLFCUS                                           CLE168
     C                   MOVE      CLFTYP        A_XFACT                                      CLE168
     C                   MOVE      CLFSEQ        A_XFCNO                                      CLE168
     C                   EVAL      A_XBKRPT = *BLANKS                                         CLE168
     C                   ENDIF                                                                CLE168
     C                   OUT       LEFCLY                                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode

      ** Calling function type
     C                   PARM      'LEND'        ##CALP

      ** Payment currency
     C**********         PARM      DDCURR        ##PCCY                                       CLE036
     C                   PARM      WPCurr        ##PCCY                                       CLE036

      ** Receive currency
     C**********         PARM      DDCURR        ##RCCY                                       CLE036
     C                   PARM      WRCurr        ##RCCY                                       CLE036

      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM

      ** Loan type
     C**********         PARM      RP_LTYP       ##TTYP                                      BUG4960
     C                   PARM                    ##TTYP                                      BUG4960

      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND

      ** Booking Branch
     C**********         PARM      RP_BRCA       ##BRCA                                      BUG4960
     C                   PARM                    ##BRCA                                      BUG4960

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
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFraSttmt

      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN

      ** Validation Iteration
     C                   PARM      '1ST'         ##VALITER

     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      ** Save settlement details for update
     C                   IF        PTypFilCLOAN = '66' OR CLE005 = 'Y'
     C                             AND PTypFilCLOAN = '69' OR
     C                             CLE005 = 'Y' AND PTypFilCLOAN = '72'
     C                   MOVE      FLPSTM        WSETP
     C                   EVAL      WOSAC = FLPONS
     C                   EVAL      WOBBR = FLPOBR
     C                   EVAL      WOSBR = FLPOBR
     C                   EVAL      WTSEN = FLPIBN

     C                   IF        CEU004 = 'Y'
     C                   EVAL      WSCCY = FLPSCY
     C                   ENDIF

     C                   ELSE
     C                   MOVE      FLRSTM        WSETP
     C                   EVAL      WOSAC = FLRONS
     C                   EVAL      WOBBR = FLROBR
     C                   EVAL      WOSBR = FLROBR
     C                   EVAL      WTSEN = FLRIBN

     C                   IF        CEU004 = 'Y'
     C                   EVAL      WSCCY = FLRSCY
     C                   ENDIF

     C                   ENDIF

     C                   MOVEL     FLBENN        WFACO

      ** Update Repayment schedule in file format
     C**********         EVAL      ValidPAY = DBPaySttmt                                      CGL029
     C**********         EVAL      ValidREC = DBRecSttmt                                      CGL029
     C                   EVAL      ValidREC = FLREC                                           CGL029
     C                   EVAL      ValidRECEx = FLRONS                                        CGL029
     C                   EVAL      V_RPRSTM = FLRSTM                                          CGL029
     C                   EVAL      ValidPAY = FLPAY                                           CGL029
     C                   EVAL      ValidPAYEx = FLPONS                                        CGL029
     C                   EVAL      V_RPPSTM = FLPSTM                                          CGL029
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_RPREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_RPPEXR                                     CLE031
     C                   MOVE      FLREXI        V_RPREXI                                     CLE031
     C                   MOVE      FLPEXI        V_RPPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_RPSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_RPPSCY                                     CLE031
     C                   ENDIF                                                                CLE031

      ** Perform the additional validations
     C                   CALLB     'LERPSC2VL'

      ** Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode

      ** Valid Repayment schedule
     C                   PARM                    ValidRpSc

      ** Payment instructions
     C                   PARM                    DBPaySttmt

      ** Receive instructions
     C                   PARM                    DBRecSttmt

      ** Field OK flags (DS)
     C                   PARM                    OKTrRPSC

      ** Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index
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
     C                   EVAL      TmpCURR = DDCURR                                           CLE106
     C                   EVAL      TmpSAMT = DDSAMT                                           CLE106
     C                   EVAL      DDCURR = DDLCCY                                            CLE106
     C                   EVAL      DDSAMT = DDLCPR                                            CLE106
     C                   ENDIF                                                                CLE106

     C                   IF        DDLNRF = *Blanks                                         MD032213
     C                   EVAL      DDLNRF = @DDLNRF                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   IF        DDSEQN = *Blanks                                         MD032213
     C                   EVAL      DDSEQN = @DDSEQN                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   IF        DDVDAT = *Blanks                                         MD032213
     C                   EVAL      DDVDAT = @DDVDAT                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   IF        DDCUST = *Blanks                                         MD032213
     C                   EVAL      DDCUST = @DDCUST                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   IF        DDCURR = *Blanks                                         MD032213
     C                   EVAL      DDCURR = @DDCURR                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   IF        DDSAMT = *Blanks                                         MD032213
     C                   EVAL      DDSAMT = @DDSAMT                                         MD032213
     C                   ENDIF                                                              MD032213
                                                                                            MD032213
     C                   RESET                   ReturnCode

     C                   CALLB     'LERPSCAMD'

      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode

      ** New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInRPSC

      ** (Current) Deal in Screen Format
     C                   PARM                    CurTrRPSC

      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKTrRPSC

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
     C                   EVAL      DDCURR = TmpCURR                                           CLE106
     C                   EVAL      DDSAMT = TmpSAMT                                           CLE106
     C                   ENDIF                                                                CLE106

     C                   ENDSR
      *****************************************************************
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
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * SRCnvAmt - Convert amounts based on Currency used for display *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
     C     SRCnvAmt      BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LERPSCCVA'                                                CLE106
     C                   PARM                    TraninRPSC                                   CLE106
     C                   PARM                    TraninRPS2                                   CLE106
     C                   PARM                    RPSCFilFmt                                   CLE106
     C                   PARM                    ValidRPSC                                    CLE106
     C                   PARM                    OKTrRpsc                                     CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT                                                                                  CLE106
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

     C                   CLEAR                   CurTrRPSC

     C                   MOVE      *ALL'Y'       OKTrRPSC

     C                   CLEAR                   ValidRPSC

     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
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
     C                   EVAL      ValidRpSc = RpScFilFmt
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_RPCHTP = DDACTN

      ** Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_RPFRNT = APFOTranID
                                                                                              CLE106
     C**********         IF        CLE106 = 'Y'                                       CLE106 CSF011A
     C**********                   Or DDLUTN <> *Blanks                               CLE106 CSF011A
     C                   EVAL      V_RPPCRF = DDLUTN                                          CLE106
     C**********         ELSE                                                         CLE106 CSF011A
     C                   IF        APFOTranID <> *BLANKS                                     CSF011A
     C                   EVAL      V_RPPCRF = APFOTranID
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      V_RPSTAL = DDSTAL                                          CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        DDACTN = 'X'                                              BUG8955
     C                   EVAL      V_RPASTS = 'A'                                            BUG8955
     C                   ENDIF                                                               BUG8955
     C                   IF        DDACTN = 'I' AND V_RPASTS = *BLANKS                       BUG8955
     C                   EVAL      V_RPASTS = 'C'                                            BUG8955
     C                   ENDIF                                                               BUG8955
     C                   EVAL      V_RPREPA = APRprLocn
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_RPAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                            BUG13710
      ** Set up Amendment Type field to be 'RE'                                             BUG13710
     C                   EVAL      DDATYP = 'RE'                                            BUG13710
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

     C                   CALLB     'LERPSCUPD'
     C                   PARM      *BLANKS       @RTCD

      ** New Repayment schedule in file format
     C                   PARM                    ValidRPSC

      ** Old settlement details
     C                   PARM                    OldStsDS

      ** New settlement details
     C                   PARM                    NewStsDS

      ** Pass data
     C                   PARM                    PasDtaDS

      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKTrRPSC

      ** Error fields/message IDs/message data (arrays) from/to calle  r
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, COMMIT the updates
     C                   IF        @RTCD<>*BLANK AND @RTCD<>'*RECUPD'
     C                   EVAL      APIRetc = '0'
     C                   IF        @RTCD <> '*RECLCK'                                       AR868380
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR868380
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
     C                   ENDIF
      *                                                                                     AR868380
     C                   IF        @RTCD = '*RECLCK'                                        AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) = 'LEL0817'                                  AR868380
     C                   LEAVESR                                                            AR868380
     C                   ENDIF                                                              AR868380

      ** Setup sequence number to pass back to APTRANVU on insert mode

     C     DDACTN        IFEQ      'I'
     C     V_RPLASN      ANDNE     *ZERO
     C*****WIdx**        ANDEQ     *ZERO                                                      CLE106
     C                   MOVE      V_RPLASN      DDSEQN
     C                   ENDIF
      *
      ** Also show the Loan status in correct format on confirmation screen
      *
      ***  Repayments schedule status
      *
     C                   SELECT
     C     V_RPASTS      WHENEQ    'C'
     C                   MOVEL     'LES0210'     ZAMSID
     C     V_RPASTS      WHENEQ    'A'
     C                   MOVEL     'LES0211'     ZAMSID
     C     V_RPASTS      WHENEQ    'R'
     C                   MOVEL     'LES0212'     ZAMSID
     C     V_RPASTS      WHENEQ    'D'
     C                   MOVEL     'LES0213'     ZAMSID
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID

      ** If update not done due to record being updated by another
      ** workstation send message to screen.
     C                   IF        @RTCD = '*RECUPD'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'LEL0666'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      ********************************************************************
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

      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
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

      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
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
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LERPSCVU'    DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSGF'

      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LERPSCM01

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
                                                                                              CLE031
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
     C                   ENDIF                                                                CLE031
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
                                                                                              CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
                                                                                              CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   ENDIF                                                                CLE034

      ** Determine if CLE036 (Lending Enhancements)                                           CLE036
                                                                                              CLE036
     C                   EVAL      CLE036 = 'N'                                               CLE036
     C                   CALLB     'AOSARDR0'                                                 CLE036
     C                   PARM      *Blanks       @RTCD                                        CLE036
     C                   PARM      '*VERIFY'     @OPTN                                        CLE036
     C                   PARM      'CLE036'      @SARD                                        CLE036
                                                                                              CLE036
     C                   IF        @RTCD = *Blanks                                            CLE036
     C                   EVAL      CLE036 = 'Y'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      @RTCD = *BLANKS

      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
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
     C                   EVAL      DBPGM = 'LERPSCVU'                                         CAP086
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

     C                   ENDSR
      *****************************************************************
