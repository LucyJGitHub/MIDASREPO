     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayment Retrieve a record')          *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LEMAPYR   - LE Manual repayment retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD021202           Date 11Jul13               *
      *                 MD020445           Date 16May13               *
      *                 AR1080805          Date 25Feb13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863279           Date 16Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249232             Date 18Jul07               *
      *                 246766             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      *                 244955             Date 12Jan07               *
      *                 244552             Date 19Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG9754            Date 03Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 08Aug04               *
      *                 BUG2480            Date 26May04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA091  *CREATE    Date 31Mar04               *
      *                 CAP084  *CREATE    Date 30Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD21202 - Cannot reverse/amend MR after authorisation        *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  AR1080805 - Error in LEMAPYUPD                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *           CC02: Manual Repayment Feature                      *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - Some codes of AR863279 will be physically deleted  *
      *  AR863279 - Pay Settlement Customer Name on Input fields      *
      *             are not displayed                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249232   Recompile over changes LEMAP2PD. Reinstate 244552.  *
      *  246766 - CAP086 Fields are MISSING  - Add InfData Ds         *
      *           CAP077 Fields are MISSING  - Add ExtData Ds         *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  244955   Recompile over changes LEMAP2PD. Reverse 244552.    *
      *  244552 - Recompile over changes LEMAP2PD.                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9754 - Recompiled due to changes in LEMAP2PD.             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates                           *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA091 - DS settlement changes.                              *
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
      *
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
     D TranScnFmt    E DS                  EXTNAME(LEMAPYPD)
      ** Deal in Screen Format

     D TranScnFmt2   E DS                  EXTNAME(LEMAP2PD)                                  CLE106
      ** Deal in Screen Format                                                                CLE106
                                                                                              CLE106
     D DmyValidMapy  E DS                  EXTNAME(LEVMAPYPD)                                 CLE106
      ** Dummy Valids File                                                                    CLE106
                                                                                              CLE106
     D DmyOKMapy     E DS                  EXTNAME(LEEMAPYPD)                                 CLE106
      ** Dummy Ok Flags                                                                       CLE106
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
     D**REC*****             321    389                                                       TCA091
     D**PAY*****             390    948                                                       TCA091
     D  REC                  335    389                                                       TCA091
     D  PAY                  404    948                                                       TCA091
      ** Deal in File Format
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(PD_)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
     D**LoanRecInst**********459    527                                                       TCA091
     D**LoanPayInst**********528   1086                                                       TCA091
     D  LoanRecInst          473    527                                                       TCA091
     D  LoanPayInst          542   1086                                                       TCA091
      ***  Loan Payment/receipt instructions
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA091
     D  FLREC                 21     75                                                       TCA091
      ** File Receive Instructions

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA091
     D  FLPAY                 21    565                                                       TCA091
      ** File Payment Instructions

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File FRA/IRS Instructions
                                                                                              246766
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  246766
     D                                     PREFIX(IF_)                                        246766
                                                                                              246766
     D ExtData       E DS                  EXTNAME(LEMAEXPD)                                  246766
      ** Loan Amendments Extra Data - User's Enhancement(s) data                              246766
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      ***  Midas Feature details accessed via access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access programs - long data structure                                  CSF011
                                                                                              CSF011
      **--------------------------------------------------------------------------------------------
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSF011
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Wx              S              3  0

      ** Switchable features
     D CLE002          S              1
     D CLE003          S              1
     D CLE005          S              1
     D CLE007          S              1
     D CLE009          S              1
     D CLE014          S              1
     D CLE023          S              1
     D CLE106          S              1                                                       CLE106
     D CLE036          S              1                                                       CLE106

      ** *ENTRY parameters
     D AuthComp        S              1
     D FwdBck          S              1
     D DDLNRF_In       S              6
     D DDSEQN_In       S              3
     D DDVDAT_In       S              6
     D Buffer          S           6000
     D APIRetc         S              1

      ** LEMAPYRED parameters
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

      ** LEMAPYRTV parameters
     D ModeofOp        S              6
     D*DDActnOK********S              1                                                       CLE106
     D*DDLnrfOK********S              1                                                       CLE106
     D*DDSeqnOK********S              1                                                       CLE106
     D DDVdatOK        S              1
     D @DDEVAL         S              6
     D @DDESEQ         S              3
     D*DDEVALOK********S              1                                                       CLE106
     D*DDESEQOK********S              1                                                       CLE106
     D WrkWHoldTaxRat  S             11  7
     D WrkExpectTyp    S              1
     D WrkPTYP72       S              1
     D WrkExpAmdTp     S              2
     D WrkRepayTp      S              1  0
     D WrkReactFacil   S              1
     D CntrMR          S              1  0
                                                                                              244636
      ** Parameter for LERPSCRTV                                                              244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A

      ** LEMAPYCVT parameters
     D WrkProcTypLoan  S              2  0
     D WrkOutPrinc     S             13  0
     D WrkRemainInt    S             13  0
     D CLE034          S              1A                                                      CLE034

      ** Reservation ID
     D*ReservID********S             10                                         BUG2480
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
      *
      **--------------------------------------------------------------------------------------------
      ** If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C                   CLEAR                   TranScnFmt
     C                   CLEAR                   TranScnFmt2                                  CLE106
     C                   CLEAR                   ##RECS
     C                   CLEAR                   ##PAYS

     C                   EXSR      INIT

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
     C                   EXSR      LEMAPYRED
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

     C                   EXSR      LEMAPYRTV
                                                                                              CLE034
      ** Settlement Allocation                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      DDSTAL = STAL                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE106
      ** Loan Events UTN was extracted from file                                              CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      DDLUTN = PCRF                                              CLE106
     C                   ENDIF                                                                CLE106

      ** Convert to screeen format
     C                   IF        Idx = 0
     C                   EXSR      LEMAPYCVT
     C                   EXSR      ZASETINCVT
     C                   EVAL      DDACTN = @DDACTN
     C                   IF        CLE036 = 'Y'                                               CLE106
     C                   EXSR      LEMAPYCVA                                                  CLE106
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
     C*******************EVAL                    Buffer = TranScnfmt + ReservID BUG2480
     C*******************                        + ##RECS  + ##PAYS             BUG2480
     C                   EVAL                    Buffer = TranScnfmt            BUG2480
     C                                           + TranScnFmt2                                CLE106
     C**********                                 + UpSRFlg                        AR1080805 MD020445
     C                                           + UpSRFlg                                  MD021202
     C                                           + DDAuto                                     CLE164
     C                                           + ##RECS  + ##PAYS             BUG2480
     C                                           + InfData + ExtData                          246766

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
                                                                                              CLE106
      ** Determine if CLE106 (Syndications Manager)                                           CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Determine if CLE036 is available                                                     CLE106
                                                                                              CLE106
     C                   EVAL      CLE036 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE036'      @SARD                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE036 = 'Y'                                               CLE106
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
     C     *LOCK         In        LDA                                                        CLE148
     C                   Eval      DBFILE = 'AOSVALR0'                                        CLE148
     C                   Eval      DBASE = 1                                                  CLE148
     C                   Eval      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   Eval      DBPGM = 'LEMAPYR'                                          CLE148
     C                   Out       LDA                                                        CLE148
     C                   ExSr      *PSSR                                                      CLE148
     C                   EndIf                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148

      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LEMAPYM01
      *
     C                   ENDSR
      **********************************************************************
     C     LEMAPYRED     BEGSR

     C                   CALLB     'LEMAPYRED'

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

      ** Value date pointer
     C                   PARM      DDVDAT_In     @DDVDAT

      ** Sequence pointer
     C                   PARM      DDSEQN_In     @DDSEQN

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
     C                   PARM      *BLANK        @LNRED

      ** Value date
     C                   PARM      *BLANK        @VDRED

      ** Sequence
     C                   PARM      *BLANK        @SQRED

      ** Front Office ID READ
     C                   PARM      *BLANK        @FTRED

     C                   ENDSR
      **********************************************************************
     C     LEMAPYRTV     BEGSR

     C                   CALLB     'LEMAPYRTV'

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

      ** (Midas) Value date
     C                   PARM                    @DDVDAT

      **(Midas) Sequence no.
     C                   PARM                    @DDSEQN
     C                   PARM      *BLANKS       @DDEVAL                        Expected Date
     C                   PARM      *BLANKS       @DDESEQ                        Expected Sequence
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014

      ** OUTPUTS
      ** (Current) deal in file format
     C                   PARM      *BLANKS       DealFilFmt

      ** OK - Action code
     C                   PARM      *BLANK        DDActnOK

      ** OK - Transaction Number
     C                   PARM      *BLANK        DDLnrfOK

      ** OK - Value Date
     C                   PARM      *BLANK        DDVdatOK

      ** OK - Sequence no.
     C                   PARM      *BLANK        DDSeqnOK
     C                   PARM      *BLANK        DDEVALOK                       OK Expected Date
     C                   PARM      *BLANK        DDESEQOK                       OK Expected Sequence

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators/DS for display and Managements
     C                   PARM                    WrkWHoldTaxRat                 W/hold Tax Rate
     C                   PARM      ' '           WrkExpectTyp                   Expect Amend Loan tp
     C                   PARM      ' '           WrkPTYP72                      Expected on type 72
     C                   PARM      '  '          WrkExpAmdTp                    PD/RE Amend Type
     C                   PARM      0             WrkRepayTp                     Loan Repay. Type
     C                   PARM                    WrkReactFacil                  React. Matured
     C                   PARM      0             CntrMR                         Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkLnDetails                   Loan File Fmt

      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         Wx
     C                   PARM                    PRcvParm                                     244636
     C**********         PARM      *BLANKS       UpSRFlg           1                 CLE134 MD020445
     C                   PARM      *BLANKS       UpSRFlg           1                        MD021202
     C                   PARM      *BLANKS       DDAuto            1                          CLE164


     C                   ENDSR
      **********************************************************************
     C     LEMAPYCVT     BEGSR

     C                   CALLB     'LEMAPYCVT'

      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       ReturnCode

      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C                   PARM                    PDLoAmFilFmt
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
     C                   PARM                    CLE023                         Feature
     C                   parm                    WrkReactFacil                  (from RTV)

      ** OUTPUTS
      ** (Current) Deal in screen format
     C                   PARM                    TranScnfmt
     C                   PARM                    WrkProcTypLoan
     C                   PARM      0             WrkOutPrinc
     C                   PARM      0             WrkRemainInt

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************                  CLE106
     C     LEMAPYCVA     BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LEMAPYCVA'                                                CLE106
     C                   PARM                    TranScnFmt                                   CLE106
     C                   PARM                    TranScnFmt2                                  CLE106
     C                   PARM                    DealFilFmt                                   CLE106
     C                   PARM                    WrkLnDetails                                 CLE106
     C                   PARM                    DmyValidMapy                                 CLE106
     C                   PARM                    DmyOKMapy                                    CLE106
                                                                                              CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
     C                   PARM                    MsgDtaArr                                    CLE106
     C                   PARM                    Idx                                          CLE106
                                                                                              CLE106
     C                   PARM                    WFldNamArr                                   CLE106
     C                   PARM                    WMsgIDArr                                    CLE106
     C                   PARM                    WMsgDtaArr                                   CLE106
     C                   PARM                    Wx                                           CLE106
     C                   ENDSR                                                                CLE106
      **********************************************************************                  CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************
     C     ZASETINCVT    BEGSR


     C**********         EVAL      FLREC = REC                                                TCA091
     C**********         EVAL      FLPAY = PAY                                                TCA091
     C                   EVAL      FLRSTM = RSTM                                              TCA091
     C                   EVAL      FLRONS = RONS                                              TCA091
     C                   EVAL      FLREC  = REC                                               TCA091
     C                   EVAL      FLROBR = OSBR                                              TCA091
      *                                                                                       TCA091
     C                   EVAL      FLPSTM = PSTM                                              TCA091
     C                   EVAL      FLPONS = PONS                                              TCA091
     C                   EVAL      FLPAY  = PAY                                               TCA091
     C                   EVAL      FLPOBR = OSBR                                              TCA091
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
     C                   PARM      CCY           #TRCCY                                      CSF011A
     C                   PARM      CCY           #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Determine if Customer Lending Enhancements - Authorization
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE002 = 'Y'
     C                   ELSE
     C                   EVAL      CLE002 = 'N'
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - BackValuation
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE003 = 'Y'
     C                   ELSE
     C                   EVAL      CLE003 = 'N'
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - other features
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE005 = 'Y'
     C                   ELSE
     C                   EVAL      CLE005 = 'N'
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE007 = 'Y'
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE009 = 'Y'
     C                   ELSE
     C                   EVAL      CLE009 = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CLE007 = 'N'
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements -
      ***  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE014 = 'Y'
     C                   ELSE
     C                   EVAL      CLE014 = 'N'
     C                   ENDIF
      *
      ***  Determine if CLE023 is activated - LE enh: History improvement
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE023 = 'Y'
     C                   ELSE
     C                   EVAL      CLE023 = 'N'
     C                   ENDIF
      *                                                                                       CLE031
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
      *
      ***  Clear return code.
      *
     C                   EVAL      @RTCD = *BLANKS

     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE                                                                 CLE148
**  CPY@
(c) Finastra International Limited 2003
