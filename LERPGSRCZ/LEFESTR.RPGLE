     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFESTR - LE Fee settlements retrieve a record               *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CLE073             Date 13May08               *
      *                 262843             Date 20Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9518            Date 07Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA094             Date 31Mar04               *
      *                 CAP084  *CREATE    Date 06Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  262843 - Apply CORE fix 258669.                              *
      *  258669 - Default fee events settlement instruction first from*
      *           Fees Master if found, otherwise retrieve from       *
      *           Extended Settlement file.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9518- Incorrect position of InfData in BUFFER.            *
      *  CLE106 - Syndications Manager. Fee and Fee Events UTN.       *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it. (Recompile)                             *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA094 - Wrong update on settlement instructions             *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFEEDL0  IF   E           K DISK    PREFIX(F_)                                         CLE106
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D FESTScnFmt    E DS                  EXTNAME(LEFESTPD)
      * Fee settlement in screen format
 
     D FES2ScnFmt    E DS                  EXTNAME(LEFES2PD)                                  CLE106
      * Fee settlement 2 in screen format                                                     CLE106
                                                                                              CLE106
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Fee settlement in file format
     D FESTFilFmt    E DS                  EXTNAME(LEVFESTPD)
     D***FESTFilRec           124    192                                                      TCA094
     D***FESTFilPay           193    751                                                      TCA094
     D  FESTFilRec           138    192                                                       TCA094
     D  FESTFilPay           207    751                                                       TCA094
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D***FLREC                  1     69                                                      TCA094
     D  FLREC                 21     75                                                       TCA094
      * Receive settlement instructions in file format
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D***FLPAY                  1    559                                                      TCA094
     D  FLPAY                 21    565                                                       TCA094
      * Pay settlement instructions in file format
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CLE148
      * External DS for SAR details                                                           CLE148
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE148
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                             BUG9518
      ** Interface Data Format Definition File format                                        BUG9518
     D InfData       E DS                  EXTNAME(LELEIFPD)                                 BUG9518
     D                                     PREFIX(IF_)                                       BUG9518
                                                                                             BUG9518
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer details                                                     CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
                                                                                              CSF011
      ** Work Variable for Fee Events UTN                                                     CLE106
     D CLE106          S              1A                                                      CLE106
     D CLE034          S              1A                                                      CLE034
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D InTrCcy         S              3A                                                     CSF011A
     D InTpCcy         S              3A                                                     CSF011A
     D KCNUM           S                   LIKE(STCNUM)                                       CLE106
     D KFACL           S                   LIKE(STFACL)                                       CLE106
     D KLOAN           S                   LIKE(STLOAN)                                       CLE106
     D KFSEQ           S                   LIKE(STFSEQ)                                       CLE106
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
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
 
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCNUM_In        10
     C                   PARM                    DDFACT_IN         3
     C                   PARM                    DDFACN_IN         2
     C                   PARM                    DDSEQN_IN         2
     C                   PARM                    DDVDAT_IN         6
     C                   PARM                    DDLOAN_IN         6                          CLE073
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
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
      *                                                                                       CLE034
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
     C                   PARM      *BLANKS       PRTCD             7                          CLE031
     C                   PARM      '*VERIFY'     POPTN             7                          CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
     C     FEEKEY        KLIST                                                                CLE106
     C                   KFLD                    KCNUM                                        CLE106
     C                   KFLD                    KFACL                                        CLE106
     C                   KFLD                    KLOAN                                        CLE106
     C                   KFLD                    KFSEQ                                        CLE106
      *                                                                                       CLE148
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PList                                                                CLE148
                                                                                              CLE148
      ** Return Code (Output)                                                                 CLE148
                                                                                              CLE148
     C                   Parm                    PRetCode                                     CLE148
                                                                                              CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
                                                                                              CLE148
     C                   Parm                    PSysValK1                                    CLE148
                                                                                              CLE148
      ** Value returned (Output)                                                              CLE148
                                                                                              CLE148
     C                   Parm                    PSysVal1                                     CLE148
     C                   Parm                    PSysValK2                                    CLE148
     C                   Parm                    PSysVal2                                     CLE148
     C                   Parm                    PSysValK3                                    CLE148
     C                   Parm                    PSysVal3                                     CLE148
     C                   Parm                    PSysValK4                                    CLE148
     C                   Parm                    PSysVal4                                     CLE148
     C                   Parm                    PSysValK5                                    CLE148
     C                   Parm                    PSysVal5                                     CLE148
     C                   Parm                    PSysValK6                                    CLE148
     C                   Parm                    PSysVal6                                     CLE148
     C                   Parm                    PSysValK7                                    CLE148
     C                   Parm                    PSysVal7                                     CLE148
     C                   Parm                    PSysValK8                                    CLE148
     C                   Parm                    PSysVal8                                     CLE148
     C                   Parm                    PSysValK9                                    CLE148
     C                   Parm                    PSysVal9                                     CLE148
     C                   Parm                    PSysValK10                                   CLE148
     C                   Parm                    PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   Eval      PRetCode = *BLANKS                                         CLE148
     C                   Eval      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   Eval      PSysVal1 = *BLANKS                                         CLE148
                                                                                              CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
                                                                                              CLE148
      ** If Error retrieving the System values                                                CLE148
                                                                                              CLE148
     C                   If        %Error Or PRetCode <> *BLANKS                              CLE148
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CLE148
     C     *LOCK         In        LDA                                                        CLE148
     C                   Eval      DBFILE = 'AOSVALR0'                                        CLE148
     C                   Eval      DBASE = 1                                                  CLE148
     C                   Eval      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   Eval      DBPGM = 'LEFESTR'                                          CLE148
     C                   Out       LDA                                                        CLE148
     C                   ExSr      *PSSR                                                      CLE148
     C                   EndIf                                                                CLE148
                                                                                              CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
                                                                                              CLE148
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LEFESTVM01
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   FESTFilFmt
     C                   If        AuthComp = 'Y'
     C                   MOVEL     'X'           DDACTN
     C                   Else
     C                   MOVEL     'E'           DDACTN
     C                   EndIf
 
     C                   If        FwdBck = 'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   Else
     C                   If        FwdBck = 'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   Else
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   EndIf
     C                   EndIf
 
     C                   If        @RDFWD = 'Y' or
     C                             @RDBCK = 'Y'
     C                   EXSR      LEFESTRED
     C                   Else
     C                   MOVEL     DDCNUM_IN     @CNRED
     C                   MOVEL     DDFACT_IN     @FTRED
     C                   MOVEL     DDFACN_IN     @FNRED
     C                   Eval      @LNRED = '0'
     C                   MOVEL     DDLOAN_IN     @LNRED                                       CLE073
     C                   MOVEL     DDSEQN_IN     @SQRED
     C                   MOVEL     DDVDAT_IN     @DTREDA           6
     C                   EndIf
      *
      * If Fee settlement read and no error message returned
     C                   If        @ERRMS = *BLANK and
     C                             @CNRED <> *Blank
      *
      * Retrieve fee details
     C                   MOVEL     @CNRED        DDCNUM
     C                   MOVEL     @FTRED        DDFACT
     C                   MOVEL     @FNRED        DDFACN
     C                   MOVEL     @LNRED        DDLOAN
     C                   MOVEL     @SQRED        DDSEQN
     C                   MOVEL     @DTREDA       S#VDAT
     C                   MOVEL     @FTRED        DDFRNT
     C                   EXSR      LEFESTRTV
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      S#EUTN = STPCRF                                            CLE106
     C                   EVAL      KCNUM = STCNUM                                             CLE106
     C                   EVAL      KFACL = STFACL                                             CLE106
     C                   EVAL      KLOAN = STLOAN                                             CLE106
     C                   EVAL      KFSEQ = STFSEQ                                             CLE106
     C     FEEKEY        CHAIN     LEFEEDL0                                                   CLE106
     C                   EVAL      S#FUTN = F_PCRF                                            CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
      * Loan Events UTN was extracted from file                                               CLE034
     C                   EVAL      S#STAL = STSTAL                                            CLE034
     C                   ENDIF                                                                CLE034
      *
      * Convert to screeen format
     C                   If        Idx = 0
     C                   EXSR      LEFESTCVT
     C                   EXSR      ZASETINCVT
     C                   EndIf
 
     C                   EndIf
 
     C                   If        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCNUM'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   MOVEL     @ERRDTA       MsgDtaArr(1)                                 CLE148
     C                   EndIf
 
     C                   EXSR      SrCustName                                                 CSF011
                                                                                              CSF011
      * Build buffer with required output
     C**********         EVAL                    Buffer = FESTScnfmt + S#STAT                 CLE106
     C**********                                 + S#FTYP + S#FCOD + S#FENV                   CLE106
     C**********                                 + S#DUPD + ##RECS + ##PAYS                   CLE106
     C                   EVAL                   Buffer = FESTScnfmt + FES2ScnFmt              CLE106
     C**********                                 + ##RECS + ##PAYS                    CLE106 BUG9518
     C                                           + ##RECS + ##PAYS + InfData                 BUG9518
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     LEFESTRED     BEGSR
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'LEFESTRED'
      *
      * Input parameters :
      * Mode = '*FRONT' (Front Office Transaction Interface)
      * Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '      '      ModeofOp          6
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * Fee settlement reference:
      * Customer, facility, loan, sequence, value date
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFACN            2
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDSEQN            2
     C                   PARM                    DDVDAT            5
      *
      * Front Office Transaction ID
     C                   PARM                    DDFRNT           20
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
 
      * Fee settlement read:
      * Customer, facility, loan, sequence, value date
     C                   PARM                    @CNRED            6
     C                   PARM                    @FTRED            3
     C                   PARM                    @FNRED            2
     C                   PARM                    @LNRED            6
     C                   PARM                    @SQRED            2
     C                   PARM                    @DTRED            5
      *
      * Front Office Transaction ID read
     C                   PARM                    @FORED           20
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEFESTRTV     BEGSR
 
     C                   RESET                   ReturnCode
     C                   MOVEL     DDCNUM        DDCSSN
      *
     C                   CALLB     'LEFESTRTV'
      *
      * Inputs
      ** Return Code
     C                   PARM                    ReturnCode
 
      * Mode
     C                   PARM      ' '           P#MODE            1
 
      * Response Code
     C                   PARM      'S'           RESPMODE          1
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date
     C                   PARM                    DDACTN
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT
     C                   PARM                    DDFACN
     C                   PARM                    DDSEQN
     C                   PARM                    S#VDAT
     C                   PARM                    DDLOAN                                       CLE073
      *
      * OUTPUTS
      * Fee Settlement Details in file format
     C                   PARM                    FESTFilFmt
     C                   PARM                    ##RECS                                       258669
     C                   PARM                    ##PAYS                                       258669
     C                   PARM                    ##RECF                                       258669
     C                   PARM                    ##PAYF                                       258669
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#VDATok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, fee amount due/past due
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#DUPD           18
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Save Value date
     C                   MOVEL     W#VDAT        @DTRED
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEFESTCVT     BEGSR
 
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'LEFESTCVT'
      *
      * Inputs
      ** Return Code
     C                   PARM                    ReturnCode
      *
      * Fee Settlement details in file format
     C                   PARM                    FESTFilFmt
      *
      * OUTPUTS
      *
      * Fee Settlement Details in screen format
     C                   PARM                    FESTScnFmt
 
      * Customer details
     C                   PARM                    S#CNUM
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C                   PARM                    FecyNBDP
 
      * Value date (alpha)
     C                   PARM                    S#VDTA            7
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up receive instructions from fee settlement
     C                   MOVEL     FESTFilRec    FLREC
     C                   MOVEL     FESTFilPay    FLPAY                                        TCA094
     C                   EVAL      FLPSTM = STPSTM                                            TCA094
     C                   EVAL      FLRSTM = STRSTM                                            TCA094
     C                   EVAL      FLRONS = STRONS                                            TCA094
     C                   EVAL      FLROBR = STOSDB                                            TCA094
     C                   EVAL      FLPONS = STPONS                                            TCA094
     C                   EVAL      FLCVMR = STCVMR                                            TCA094
     C                   EVAL      FLPOBR = STOMDB                                            TCA094
     C                   EVAL      FLIC72 = STICCY                                            TCA094
     C                   IF        FLRSTM <> 0                                                TCA094
     C                   EVAL      FLRSCY = STSCCY                                            TCA094
     C                   ELSE                                                                 TCA094
     C                   EVAL      FLPSCY = STSCCY                                            TCA094
     C                   ENDIF                                                                TCA094
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     STREXR        FLREXR                                       CLE031
     C                   Z-ADD     STPEXR        FLPEXR                                       CLE031
     C                   MOVE      STREXI        FLREXI                                       CLE031
     C                   MOVE      STPEXI        FLPEXI                                       CLE031
     C                   MOVE      STSCCY        FLRSCY                                       CLE031
     C                   MOVE      STPSCY        FLPSCY                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   Z-ADD     *Zeros        FLREXR                                       CLE031
     C                   Z-ADD     *Zeros        FLPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    ##PAYF
      *
      ** File receipt settlement instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS settlement instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      S#FCCY        InTrCcy                                     CSF011A
     C                   PARM      S#FCCY        InTpCcy                                     CSF011A
      *
     C                   ENDSR
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrCustname - Get the Customer details                         *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrCustName    BEGSR                                                               CSF011A
                                                                                             CSF011A
      ** Initialise Customer name fields                                                     CSF011A
                                                                                             CSF011A
     C                   EVAL      S#CNSN = *BLANKS                                          CSF011A
     C                   EVAL      S#CNNM = *BLANKS                                          CSF011A
     C                   EVAL      S#CNTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   IF        S#CSSN <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = S#CSSN                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      S#CNSN = BBCSSN                                           CSF011A
     C                   EVAL      S#CNNM = BBCRNM                                           CSF011A
     C                   EVAL      S#CNTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
                                                                                             CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
