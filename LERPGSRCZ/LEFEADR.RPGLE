     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADR - LE Fee Adjustments retrieve a record               *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10626           Date 22Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG1304            Date 02Mar04               *
      *                 BUG1218            Date 01Mar04               *
      *                 222373             Date 30Oct03               *
      *                 CAP084  *CREATE    Date 06Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10626 - Confirmation page has details in Filler field     *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. Fee and Fee events UTN.       *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  BUG1304- missing fee fields                                  *
      *  BUG1218- Status not shown                                    *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
     FLEFEEDL0  IF   E           K DISK    PREFIX(F_)                                         CLE106
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
     D FEADScnFmt    E DS                  EXTNAME(LEFEADPD)
      * Fee Adjustment in screen format
 
     D FEA2ScnFmt    E DS                  EXTNAME(LEFEA2PD)                                  CLE106
      *                                                                                       CLE036
      ** Fee Adjustment 2 in screen format                                                    CLE106
      *                                                                                       CLE106
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Fee Adjustment in file format
     D FEADFilFmt    E DS                  EXTNAME(LEVFEADPD)
     D  FEADFilRec           459    527
 
     D InfData       E DS                  EXTNAME(LELEIFPD) PREFIX(IF_)                    BUG10626
      ** LE Lending Interface Data format Definition file                                   BUG10626
                                                                                            BUG01626
      ** First DS for access programs, SHORT data structure                                   CLE148
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE148
      ** SAR details                                                                          CLE148
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE148
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access programs - long data structure                                  CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer Details                                                     CSF011
                                                                                              CSF011
     D PRtcd           S              7A                                                      CSF011
     D POptn           S              7A                                                      CSF011
     D PCNum           S             10A                                                      CSF011
     D PKey7           S              7A                                                      CSF011
      ** Parameters for Calling AOCUSTR0                                                      CSF011
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      *                                                                                       CLE106
      ** Work Variable for Fee Events UTN                                                     CLE106
      *                                                                                       CLE106
     D CLE106          S              1A                                                      CLE106
     D KCNUM           S                   LIKE(ADCNUM)                                       CLE106
     D KFACL           S                   LIKE(ADFACL)                                       CLE106
     D KLOAN           S                   LIKE(ADLOAN)                                       CLE106
     D KFSEQ           S                   LIKE(ADFSEQ)                                       CLE106
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
     C                   PARM                    DDLOAN_IN         6                          CLE073
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C     FEEKEY        KLIST                                                                CLE106
     C                   KFLD                    KCNUM                                        CLE106
     C                   KFLD                    KFACL                                        CLE106
     C                   KFLD                    KLOAN                                        CLE106
     C                   KFLD                    KFSEQ                                        CLE106
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
     C                   IF        %Error OR PRetCode <> *BLANKS                              CLE148
     C                             OR (*INU7 = *ON AND *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 1                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = PsProcPgm                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LEFEADVM01
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   FEADFilFmt
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
     C                   EXSR      LEFEADRED
     C                   Else
     C                   MOVEL     DDCNUM_IN     @CNRED
     C                   MOVEL     DDFACT_IN     @FTRED
     C                   MOVEL     DDFACN_IN     @FNRED
     C                   MOVEL     DDSEQN_IN     @SQRED
     C                   MOVEL     DDLOAN_IN     @LNRED                                       CLE073
     C                   EndIf
      *
      * If Fee Adjustment read and no error message returned
     C                   If        @ERRMS = *BLANK and
     C                             @CNRED <> *Blank
      *
      * Retrieve fee details
     C                   MOVEL     @CNRED        DDCNUM
     C                   MOVEL     @FTRED        DDFACT
     C                   MOVEL     @FNRED        DDFACN
     C                   MOVEL     @SQRED        DDSEQN
     C                   MOVEL     @FTRED        DDFRNT
     C                   MOVEL     @LNRED        DDLOAN                                       CLE073
     C                   EXSR      LEFEADRTV
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      S#EUTN = ADPCRF                                            CLE106
     C                   EVAL      KCNUM = ADCNUM                                             CLE106
     C                   EVAL      KFACL = ADFACL                                             CLE106
     C                   EVAL      KLOAN = ADLOAN                                             CLE106
     C                   EVAL      KFSEQ = ADFSEQ                                             CLE106
     C                   EVAL      S#RECI = ADRECI                                            CLE106
     C     FEEKEY        CHAIN     LEFEEDL0                                                   CLE106
     C                   EVAL      S#FUTN = F_PCRF                                            CLE106
     C                   ENDIF                                                                CLE106
      *
      * Convert to screeen format
     C                   If        Idx = 0
     C                   EXSR      LEFEADCVT
     C                   EndIf
 
     C                   EndIf
 
     C                   If        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCNUM'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   MOVEL     @ERRDTA       MsgDtaArr(1)                                 CLE148
     C                   EndIf
                                                                                              CSF011
      ** Population of Facility Customer Details                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrPopCust                                                  CSF011
 
      * Build buffer with required output
     C*******************EVAL                    Buffer = FEADScnfmt                         BUG1218
     C*******************EVAL                    Buffer = FEADScnfmt + S#STAT        BUG1218 BUG1304
     C**********         EVAL                    Buffer = FEADScnfmt + S#STAT         BUG1304BUG1304
     C**********                                 + S#FTYP + S#FCOD + S#FENV           BUG1304BUG1304
     C**********                                 + S#ACCD                             BUG1304BUG1304
                                                                                              CLE106
     C                   EVAL                   Buffer = FEADScnfmt + FEA2ScnFmt              CLE106
     C                                                    + InfData                         BUG10626
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     LEFEADRED     BEGSR
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'LEFEADRED'
      *
      * Input parameters :
      * Mode = '*FRONT' (Front Office Transaction Interface)
      * Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '      '      ModeofOp          6
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * Fee Adjustment reference:
      * Customer, facility, loan, sequence, value date
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFACN            2
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDSEQN            2
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
 
      * Fee Adjustment read:
      * Customer, facility, loan, sequence, value date
     C                   PARM                    @CNRED            6
     C                   PARM                    @FTRED            3
     C                   PARM                    @FNRED            2
     C                   PARM                    @LNRED            6
     C                   PARM                    @SQRED            2
     C**********         PARM                    @DTRED            5                          222373
      *
      * Front Office Transaction ID read
     C                   PARM                    @FORED           20
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEFEADRTV     BEGSR
 
     C                   RESET                   ReturnCode
     C                   MOVEL     DDCNUM        DDCSSN
      *
     C                   CALLB     'LEFEADRTV'
      *
      * Inputs
      ** Return Code
     C                   PARM                    ReturnCode
 
      * Mode
     C                   PARM      ' '           P#MODE            1
      * Response Code
     C                   PARM      'S'           RESPMODE          1
 
      * Action, customer, facility type, facility number,
      * and fee sequence number
     C                   PARM                    DDACTN
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT
     C                   PARM                    DDFACN
     C                   PARM                    DDSEQN
     C                   PARM                    DDLOAN            6                          CLE073
      *
      * OUTPUTS
      * Fee Adjustment Details in file format
     C                   PARM                    FEADFilFmt
 
      * Action, customer, facility type, facility number,
      * and fee sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, total fee accrued to date
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#ACCD           18
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
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
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEFEADCVT     BEGSR
 
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'LEFEADCVT'
      *
      * Inputs
      ** Return Code
     C                   PARM                    ReturnCode
      *
      * Fee Adjustment details in file format
     C                   PARM                    FEADFilFmt
      *
      * OUTPUTS
      *
      * Fee Adjustment Details in screen format
     C                   PARM                    FEADScnFmt
 
      * Customer details
     C                   PARM                    S#CNUM
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C                   PARM                    FecyNBDP
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
     C                   ENDSR
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   IF        DDCSSN <> *BLANKS                                          CSF011
     C                   EVAL      PCNum = DDCSSN                                             CSF011
                                                                                              CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        PRtcd = *BLANKS                                            CSF011
     C                   EVAL      S#CNSN  = BBCSSN                                          CSF011A
     C                   EVAL      S#CNNM  = BBCRNM                                          CSF011A
     C                   EVAL      S#CNTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Details                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       PRtcd                                        CSF011
     C                   PARM      '*KEY   '     POptn                                        CSF011
     C                   PARM                    PCNum                                        CSF011
     C                   PARM      *BLANKS       PKey7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      **********************************************************************
      /EJECT
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
(c) Misys International Banking Systems Ltd. 2003
