     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule Retrieve a record')       *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LERPSCR   - LE Repayments Schedules retrieve a record        *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 CDL094             Date 11Jun14               *
      *                 MD021356           Date 24Jul13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863281           Date 16Nov11               *
      *                 CSF011             Date 12Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246771             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10331           Date 08Feb06               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 TCA081             Date 31Mar04               *
      *                 CAP084  *CREATE    Date 30Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD021356 - Impossible to input repayment schedule for parti- *
      *             cipation sold; pattern fix after AR1069948        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - Some codes of AR863281 will be physically deleted  *
      *  AR863281 - Pay Settlement Customer Name on Inputs fields     *
      *             are not displayed                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246771 - Buffer is not in Line with LERPSCVU                 *
      *           CAP006 fields are missing - Add INFdata and ExtData *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG10331 - Recompiled due to changes in LERPS2PD.            *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE106 - Syndications Manager. Loan events UTN.              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates                           *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it (Recompile)                              *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  TCA081 - Settlement account details not shown on enquiry.    *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
                                                                                              CLE148
     D/COPY ZACPYSRC,PSDS                                                                     CLE148
      ** The following /COPY line includes definitions for the above fields                   CLE148
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the                          CLE148
      ** corresponding fields in the PSDS /COPY member, so that member                        CLE148
      ** must be included where this one is used.                                             CLE148
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
     D TranScnFmt    E DS                  EXTNAME(LERPSCPD)
      ** Deal in Screen Format
 
     D TranScnFmt2   E DS                  EXTNAME(LERPS2PD)                                  CLE106
      ** Deal in Screen Format 2                                                              CLE106
                                                                                              CLE106
     D DmyValidRpsc  E DS                  EXTNAME(LEVRPSCPD)                                 CLE106
      ** Dummy Valid File                                                                     CLE106
                                                                                              CLE106
     D DmyOKRpsc     E DS                  EXTNAME(LEERPSCPD)                                 CLE106
      ** Dummy OK Flag                                                                        CLE106
                                                                                              CLE106
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen Receive Instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen Payment Instructions
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** Screen FRA/IRS Instructions
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
     D DealFilFmt    E DS                  EXTNAME(LOAMSDK)
     D**REC*****             321    389                                                       TCA081
     D**PAY*****             390    948                                                       TCA081
     D  REC                  335    389                                                       TCA081
     D  PAY                  404    948                                                       TCA081
      ** Deal in File Format
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC***               1     69                                                       TCA081
     D  FLREC                 21     75                                                       TCA081
      ** File Receive Instructions
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY***               1    559                                                       TCA081
     D  FLPAY                 21    565                                                       TCA081
      ** File Payment Instructions
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSF011
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File FRA/IRS Instructions
 
      **--------------------------------------------------------------------------------------------
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** *ENTRY parameters
     D AuthComp        S              1
     D FwdBck          S              1
     D DDLNRF_In       S              6
     D DDSEQN_In       S              3
     D DDVDAT_In       S              6
     D Buffer          S           6000
     D APIRetc         S              1
 
      ** LERPSCRED parameters
     D @@MODE          S              6
     D @DDACTN         S              1
     D @DDLNRF         S              6
     D @DDSEQN         S              3
     D @DDVDAT         S              6
     D @DDFRTN         S             20
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @LNRED          S              6
     D @SQRED          S              3
     D @VDRED          S              6
     D @FTRED          S             20
 
      ** LERPSCRTV parameters
     D ModeofOp        S              6
     D*DDActnOK********S              1                                                       CLE106
     D*DDLnrfOK********S              1                                                       CLE106
     D*DDSeqnOK********S              1                                                       CLE106
     D*DDVdatOK********S              1                                                       CLE106
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
                                                                                              TDA070
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PPayParm        S           1045                                                      CSF011A
      ** Work Variable for Loan Events UTN                                                    CLE106
     D CLE106          S              1A                                                      CLE106
     D CLE034          S              1A                                                      CLE034
     D CLE036          S              1A                                                      CLE106
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  246771
     D                                     PREFIX(IF_)                                        246771
     D ExtData       E DS                  EXTNAME(LERPEXPD)                                  246771
      *                                                                                       CLE148
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE148
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE148
     D    SARLCD     E                     EXTFLD(LCD)                                        CLE148
      *                                                                                       CLE148
      ** Parameters for calling AOSVALR0 (System Value Access Object)                         CLE148
      *                                                                                       CLE148
     D PRetCode        S              7A                                                      CLE148
     D PSysValK1       S             20A                                                      CLE148
     D PSysVal1        S            200A                                                      CLE148
     D PSysValK2       S             20A                                                      CLE148
     D PSysVal2        S            200A                                                      CLE148
     D PSysValK3       S             20A                                                      CLE148
     D PSysVal3        S            200A                                                      CLE148
     D PSysValK4       S             20A                                                      CLE148
     D PSysVal4        S            200A                                                      CLE148
     D PSysValK5       S             20A                                                      CLE148
     D PSysVal5        S            200A                                                      CLE148
     D PSysValK6       S             20A                                                      CLE148
     D PSysVal6        S            200A                                                      CLE148
     D PSysValK7       S             20A                                                      CLE148
     D PSysVal7        S            200A                                                      CLE148
     D PSysValK8       S             20A                                                      CLE148
     D PSysVal8        S            200A                                                      CLE148
     D PSysValK9       S             20A                                                      CLE148
     D PSysVal9        S            200A                                                      CLE148
     D PSysValK10      S             20A                                                      CLE148
     D PSysVal10       S            200A                                                      CLE148
      *
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(CL_)                     MD021356
      *                                                                                     MD021356
      ** Loan details                                                                       MD021356
      *                                                                                     MD021356
      **--------------------------------------------------------------------------------------------
      ** If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C                   CLEAR                   TranScnFmt
     C                   CLEAR                   TranScnFmt2                                  CLE106
     C                   CLEAR                   ##RECS
     C                   CLEAR                   ##PAYS
     C                   IF        @DDACTN = *BLANK
 
     C                   IF        AuthComp = 'X'
     C                   EVAL      @DDACTN = 'X'
     C                   ELSE
     C                   EVAL      @DDACTN = 'E'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        FwdBck = 'F'
     C                   EVAL      @RDFWD = 'Y'
     C                   EVAL      @RDBCK = 'N'
     C                   ELSE
 
     C                   IF        FwdBck = 'B'
     C                   EVAL      @RDFWD = 'N'
     C                   EVAL      @RDBCK = 'Y'
     C                   ELSE
     C                   EVAL      @RDFWD = 'N'
     C                   EVAL      @RDBCK = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @RDFWD =  'Y' OR @RDBCK = 'Y'
     C                   EXSR      LERPSCRED
     C                   ELSE
     C                   EVAL      @LNRED = DDLNRF_In
     C                   EVAL      @SQRED = DDSEQN_In
     C                   EVAL      @VDRED = DDVDAT_In
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @ERRDTA = *BLANK                                           CLE148
     C                   ENDIF
 
      ** If deal read and no error message returned
     C                   IF        @LNRED <> *BLANK AND @ERRMS = *BLANK
 
      ** Retrieve deal details
     C                   EVAL      @DDLNRF = @LNRED
     C                   EVAL      @DDSEQN = @SQRED
     C                   EVAL      @DDVDAT = @VDRED
     C                   EVAL      ARFOTranID = @FTRED
 
     C                   EXSR      LERPSCRTV
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      DDLUTN = PCRF                                              CLE106
     C                   ENDIF                                                                CLE106
     C     CLE034        IFEQ      'Y'                                                        CLE034
      *                                                                                       CLE034
      ** Loan Events UTN was extracted from file                                              CLE034
      *                                                                                       CLE034
     C                   EVAL      DDSTAL = STAL                                              CLE034
     C                   ENDIF                                                                CLE034
 
      ** Convert to screeen format
     C                   IF        Idx = 0
     C                   EXSR      LERPSCCVT
     C                   EXSR      ZASETINCVT
     C                   EVAL      DDACTN = @DDACTN
     C                   IF        CLE036 = 'Y'                                               CLE106
     C                   EXSR      LERPSCCVA                                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSF011
      ** Populate Customer Name on Input fields                                               CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
 
     C                   IF        @ERRMS <> *BLANK
     C                   EVAL      APIRetc = '0'
     C                   EVAL      FldNameArr(1) = 'DDLNRF'
     C                   EVAL      MsgIDArr(1) = @ERRMS
     C                   EVAL      MsgDtaArr(1) = @ERRDTA                                     CLE148
     C                   ENDIF
 
      ** Build buffer with required output
     C                   EVAL                    Buffer = TranScnfmt
     C                                           + TranScnfmt2                                CLE106
     C                                           + ##RECS  + ##PAYS
     C                                           + Infdata                                    246771
     C                                           + ExtData                                    246771
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************                       CSF011
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
      *****************************************************************                      CSF011A
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
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In
     C                   PARM                    DDSEQN_In
     C                   PARM                    DDVDAT_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSGF'
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
                                                                                              CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE034
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
      *                                                                                       CLE034
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
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
      *                                                                                       CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE106
      ** Determine if CLE036 installed                                                        CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE036                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE036'      @SARD                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE036                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE148
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Return Code (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PRetCode                                     CLE148
      *                                                                                       CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysValK1                                    CLE148
      *                                                                                       CLE148
      ** Value returned (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysVal1                                     CLE148
     C                   PARM                    PSysValK2                                    CLE148
     C                   PARM                    PSysVal2                                     CLE148
     C                   PARM                    PSysValK3                                    CLE148
     C                   PARM                    PSysVal3                                     CLE148
     C                   PARM                    PSysValK4                                    CLE148
     C                   PARM                    PSysVal4                                     CLE148
     C                   PARM                    PSysValK5                                    CLE148
     C                   PARM                    PSysVal5                                     CLE148
     C                   PARM                    PSysValK6                                    CLE148
     C                   PARM                    PSysVal6                                     CLE148
     C                   PARM                    PSysValK7                                    CLE148
     C                   PARM                    PSysVal7                                     CLE148
     C                   PARM                    PSysValK8                                    CLE148
     C                   PARM                    PSysVal8                                     CLE148
     C                   PARM                    PSysValK9                                    CLE148
     C                   PARM                    PSysVal9                                     CLE148
     C                   PARM                    PSysValK10                                   CLE148
     C                   PARM                    PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   EVAL      PRetCode = *BLANKS                                         CLE148
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   EVAL      PSysVal1 = *BLANKS                                         CLE148
      *                                                                                       CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
      *                                                                                       CLE148
      ** If Error retrieving the System values                                                CLE148
      *                                                                                       CLE148
     C                   IF        %ERROR OR PRetCode <> *BLANKS                              CLE148
     C                             OR (*INU7 = *ON AND *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 1                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = 'LERPSCR'                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LERPSCM01
      *
     C                   ENDSR
      **********************************************************************
     C     LERPSCRED     BEGSR
 
     C                   CALLB     'LERPSCRED'
 
      ** INPUT PARAMETERS
      ** RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
 
      ** @@MODE = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** @@MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE
 
      ** ACTION CODE
     C                   PARM                    @DDACTN
 
      ** Deal number pointer
     C                   PARM      DDLNRF_In     @DDLNRF
 
      ** Sequence pointer
     C                   PARM      DDSEQN_In     @DDSEQN
 
      ** Value date pointer
     C                   PARM      DDVDAT_In     @DDVDAT
 
      ** Front Office ID
     C                   PARM                    @DDFRTN
 
      ** READ FORWARDS
     C                   PARM                    @RDFWD
 
      ** READ BACKWARDS
     C                   PARM                    @RDBCK
 
      ** OUTPUT PARAMETERS
      ** ERROR MESSAGE
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
 
      ** Loan number
     C                   PARM                    @LNRED
 
      ** Sequence
     C                   PARM                    @SQRED
 
      ** Value date
     C                   PARM                    @VDRED
 
      ** Front Office ID READ
     C                   PARM      *BLANK        @FTRED
 
     C                   ENDSR
      **********************************************************************
     C     LERPSCRTV     BEGSR
 
     C                   CALLB     'LERPSCRTV'
 
      ** INPUTS
      ** Return code
     C                   PARM      *BLANKS       ReturnCode
 
      ** ModeofOp = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** ModeofOp = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
 
      ** Response mode
     C                   PARM      'S'           ARRESPMODE
 
      ** Action Code
     C                   PARM                    @DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    ARFOTranID
 
      ** (Midas) Transaction Number
     C                   PARM                    @DDLNRF
 
      **(Midas) Sequence no.
     C                   PARM                    @DDSEQN
 
      ** (Midas) Value date
     C                   PARM                    @DDVDAT
 
      ** OUTPUTS
      ** (Current) deal in file format
     C                   PARM                    DealFilFmt
 
      ** OK - Action code
     C                   PARM      *BLANK        DDActnOK
 
      ** OK - Transaction Number
     C                   PARM      *BLANK        DDLnrfOK
 
      ** OK - Sequence no.
     C                   PARM      *BLANK        DDSeqnOK
 
      ** OK - Value Date
     C                   PARM      *BLANK        DDVdatOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
     C                   PARM                    WrkLnDetails                               MD021356
 
     C                   ENDSR
      **********************************************************************
     C     LERPSCCVT     BEGSR
 
     C                   CALLB     'LERPSCCVT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      ** OUTPUTS
      ** (Current) Deal in screen format
     C                   PARM                    TranScnfmt
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************                  CLE106
     C     LERPSCCVA     BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LERPSCCVA'                                                CLE106
     C                   PARM                    TranScnFmt                                   CLE106
     C                   PARM                    TranScnFmt2                                  CLE106
     C                   PARM                    DealFilFmt                                   CLE106
     C                   PARM                    DmyValidRpsc                                 CLE106
     C                   PARM                    DmyOKRPSC                                    CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      **********************************************************************                  CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************
     C     ZASETINCVT    BEGSR
 
 
     C                   EVAL      FLREC = REC
     C                   EVAL      FLPAY = PAY
      *                                                                                       TCA081
     C                   EVAL      FLRSTM= RSTM                                               TCA081
     C                   EVAL      FLRONS= RONS                                               TCA081
     C                   EVAL      FLPSTM= PSTM                                               TCA081
     C                   EVAL      FLPONS= PONS                                               TCA081
     C                   EVAL      FLPOBR= OSBR                                               TCA081
     C                   EVAL      FLROBR= OSBR                                               TCA081
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE                                                                 CLE148
**  CPY@
(c) Finastra International Limited 2003
