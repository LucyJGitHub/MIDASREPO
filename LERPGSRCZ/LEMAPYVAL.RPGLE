     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayments - details validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYVAL - LE Manual Repayments Details Validation          *
      *                                                               *
      *  Function: This Program Validates LE Manual Repayment input   *
      *            into Midas Database.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD038714           Date 09May16               *
      *  Prev Amend No. MD037915           Date 24Feb16               *
      *                 249766             Date 03Jul15               *
      *                 CLE164             Date 18Aug14               *
      *                 MD000091           Date 10May13               *
      *                 MD020445           Date 16May13               *
      *                 AR1080805          Date 25Feb13               *
      *                 AR850197           Date 09Jan13               *
      *                 AR1070996          Date 20Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22710           Date 19Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249232             Date 18Jul07               *
      *                 247626             Date 08May07               *
      *                 CPK027             Date 20Apr07               *
      *                 245383             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244955             Date 12Jan07               *
      *                 244552             Date 19Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240408             Date 14Jun06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8124            Date 10Aug05               *
      *                 CLE106             Date 06May05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4326            Date 17Dec04               *
      *                 BUG3114            Date 27Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 225484 (Reopen)    Date 16Apr04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038714 -If negative Amounts entered re-set the Auto Settle *
      *           Indicator to 'Y' and don't show the error           *
      *  MD037915 - Auto Settle Indicator for Manual Repayment        *
      *             not being considered for account balance check    *
      *  249766 - Compare interest repayment to interest expected if  *
      *           linked to past due interest.                        *
      *         - Applied for AR1091555 (Child: AR1091556)            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD000091 - Event Codes Substitution                          *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  AR1080805 - Error in LEMAPYUPD                               *
      *  AR850197 - System incorrectly populated Total amount field in*
      *             MR.  Recompute total repayment amount when        *
      *             interest overpayment is done for a loan. Applied  *
      *             fix 260804. (Child: AR850198)                     *
      *  AR1070996 - Unable to create Manual Repayment_A serious Midas*
      *              error occurred                                   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - Warning Msg for Original Loan Amendments            *
      *         - CC02: Manual Repayment Feature                      *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG22710 - Not able to enter Repayment for Discount Loan on  *
      *             Maturity date                                     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249232 - Reinstate 244552.                                     *
      *  247626 - Allow overpayment of Interest                       *
      *  CPK027 - Compilation Error, CL_OLNO is 6A.                   *
      *  245383 - System should prevent reopening of synd part sold   *
      *  244955 - Reverse 244552.                                     *
      *  244552 - Generated by assignment field should take its value *
      *           from front end.                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG8124- Currency Validation                                 *
      *  CLE106 - Syndication Manager                                 *
      *  CLE034 - Lending Enhancement Phase 1 Priority 1A.            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4326- Highlighting wrong field                            *
      *         - Can't have one message/two fields in error          *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225484 - Reopen of Bugzilla Bug908. Missing message replaced *
      *           by blank message LEM0612.                           *
      *  CAP077 - Lending API enhancements - Manual Repayment         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      ** Loan File                                                                            245383
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       245383
     F                                     IGNORE(CLOANHHF)                                   245383
     F                                     IGNORE(CLOANCKF)                                   245383
     F                                     IGNORE(CLOANZ1F)                                   245383

      ** PDCL Loans link file                                                                 CLE134
                                                                                              CLE134
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
                                                                                              CLE134
      ** PDCL Fees link file                                                                  CLE134
                                                                                              CLE134
     FLEPDUFL2  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
                                                                                              CLE134
     F***LOAMSL3   IF   E           K DISK    INFSR(*PSSR) RENAME(LOAMSDKF:LOAML3)   CLE134 MD020445
     F***LOAMSLA   IF   E           K DISK    INFSR(*PSSR) RENAME(LOAMSDKF:LOAMLA)   CLE134 MD020445
      **********                                                                     CLE134 MD020445
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

     D NwMaPyScnFmt  E DS                  EXTNAME(LEMAPYPD)
      ***  Manual Repayments in screen format

     D*NwMaP2ScnFmt  E DS                  EXTNAME(LEMAP2PD)                           244552 244955
      ***  Manual Repayments in screen format 2                                        244552 244955
                                                                                       244552 244955
     DNwMaP2ScnFmt   E DS                  EXTNAME(LEMAP2PD)                                  249232
      ***  Manual Repayments in screen format 2                                               249232
                                                                                              249232
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  PD/RE in file format
     D                                     PREFIX(PD_)

     D LoanFilFmt    E DS                  EXTNAME(CLOANCL) prefix(CL_)
      ***  Loan Details

     D NwMaPyFilFmt  E DS                  EXTNAME(LEVMAPYPD)
      ***  Manual Repayments in file format

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *** External DS for Bank Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *** External DS for Currency Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *** External DS for Customer Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs

     D ZMUSER          DS            17
     D  USRBCH                11     13



      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
     D*WPARM1***       S             20A   INZ('AutoAdjSchedRepaymnt')              CLE134 AR1070996
     D*WPARM1***       S             20A   INZ('PDCLAutoAdjSchedRep')             AR1070996 MD020445

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
      *
     D ErrorMaPy     E DS                  EXTNAME(LEEMAPYPD)

     D ExtData       E DS                  EXTNAME(LEMAEXPD)
      * LE Manual Repayment extende details

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

     c                   EXSR      ValCustomer
      *
     C     DDCUSTOK      IFEQ      'Y'

      ***  Retrieve currency details

     C                   EXSR      ValCurrency                                               BUG8124
     C                   CALLB     'AOCURRR0'
     c                   parm      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POTPN             7
     C                   PARM                    DDSCCY
     C     SDCURR        PARM      SDCURR        DSSDY

      ***  Validate Past due Flag

     C                   if        CLE007 = 'Y'
     C                   EXSR      ValPastDue
     C                   Endif

      ***  Validate Principal Amount and Sign

     C                   EXSR      ValPrincAmnt

      ***  Validate Interest Amount and Sign

     C                   EXSR      ValIntrAmnt
                                                                                            MD037915
      ***  Validate Principal and Interest Amount and Sign                                  MD037915
      ***  in consideration of CLE164                                                       MD037915
                                                                                            MD037915
     C                   If        CLE134 = 'Y'                                             MD037915
     C                   EXSR      ValPrinInt                                               MD037915
     C                   EndIf                                                              MD037915

      ***  Validate Penality Amount and Sign

     C                   EXSR      ValPenalAmnt

      ***  Validate Total Amount and Sign

     C                   EXSR      ValTotalAmnt

      ***  Validate Write off indicator

     C                   EXSR      ValWriteOff
      *
     C                   If        CLE134 = 'Y'                                               CLE164
     C                   EXSR      ValDDAuto                                                  CLE164
     C                   EndIf                                                                CLE164

      ***  IF all fields Correcly input, do Complex validation

     C                   IF        DDRPRIOK = 'Y' and DDPSIGOK = 'Y' and        Principal Amount
     C                             DDRINTOK = 'Y' and DDISIGOK = 'Y' and        Interest Amount
     C                             DDRPENOK = 'Y' and DDRPIGOK = 'Y' and        Penality Amount
     C                             DDRTOTOK = 'Y' and DDRSIGOK = 'Y' and        Total Amount
     C                             DDWOFFOK = 'Y'                               Write-off
      *
     C                   EXSR      ComplexVal
     c                   Endif
     C                   Endif
      *
     C                   if        idx = 0

      ***  Prepare output Record LOAMSDK Format to PUT in NwMaPyFilFmt

     C                   if        DDACTN = 'I'
     C                   EXSR      CrtValidFilFmt
     C                   Endif
      *
     C                   Endif

     C                   RETURN
      *****************************************************************
     C/EJECT
      *********************************************************************
      **  ValCustomer  Routine to vaildate Customer is = to loan Customer *
      *********************************************************************
     C     ValCustomer   BEGSR
      *
      ***  Check whether Customer number is Loan customer one
      *
     C                   If        DDCUST = *BLANKS
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDCUST'
      *
      ***  'Customer is mandatory.'
      *
     C                   MOVEL     'LEM0178'     MsgIdArr(Idx)
     C                   GOTO      EndValCust
     C                   Endif
      *
      ***  Check Customer
      *
     C                   MOVEL(P)  DDCUST        KeyCust          10
     c                   CALLB     'AOCUSTR0'
     c                   PARM      '*BLANKS'     PRTCD             7
     c                   PARM      '*KEY   '     POPTN             7
     c                   PARM                    KeyCust
     c                   PARM      *BLANKS       Dummy             7
     c     SDCUST        PARM      SDCUST        DSSDY

     C                   if        Prtcd <> *blanks
     C                   if        PRTCD = '*NOSEL '
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDCUST'
      *
      ***  'Customer is mandatory.'
      *
     C                   MOVEL     'LEM0178'     MsgIdArr(Idx)
     C                   GOTO      EndValCust
     C                   Else                                                   other Error
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDCUST'
      *
      ***  'Customer not in database (unknown).'
      *
     C                   MOVEL     'LEM0034'     MsgIdArr(Idx)
     C                   GOTO      EndValCust
     C                   Endif                                                  *nosel
     C                   Endif                                                  PRTCD

     C**********         MOVEL(p)  BBCUST        DDCUST                                       CSD027
     C**********         MOVEL(p)  CL_CNUM       WrkLoanCust       6                          CSD027
     C                   MOVEL     BBCUST        DDCUST                                       CSD027
     C                   MOVEL     CL_CNUM       WrkLoanCust       6                          CSD027
      *
      ***  Customer may not be a parent
      *
     C                   IF        BBPAIN = 'P'
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDCUST'
      *
      ***  'Customer must not be a parent'
      *
     C                   MOVEL     'LEM0036'     MsgIdArr(Idx)
     C                   GOTO      EndValCust
     C                   Endif

     C     CL_PTYP       IFEQ      64                                                         240408
     C     CL_PTYP       OREQ      65                                                         240408
     C     CL_PTYP       OREQ      68                                                         240408
     C     CL_PTYP       OREQ      71                                                         240408
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C                   MOVEL(p)  CL_OLNO       WrkLoanCust                                  240408
     C                   ENDIF                                                                240408
     C                   ENDIF                                                                240408
      *                                                                                       240408
     C                   if        WrkLoanCust <> BBCUST
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDCUST'
      *
      ***  'Customer is not the one of the Referenced Loan.'
      *
     C                   MOVEL     'LEM0040'     MsgIdArr(Idx)
     C                   GOTO      EndValCust
     C                   Endif
      *
     C     EndValCust    ENDSR
      *****************************************************************
     C/EJECT                                                                                 BUG8124
      *********************************************************************                  BUG8124
      **  ValCurrency  Routine to validate Currency is = to loan Currency *                  BUG8124
      *********************************************************************                  BUG8124
     C     ValCurrency   BEGSR                                                               BUG8124
      *                                                                                      BUG8124
      ** Check whether Currency is Loan currency one                                         BUG8124
      *                                                                                      BUG8124
     C                   If        DDSCCY = *BLANKS  Or DDSCCY <> CL_CCY                     BUG8124
     C                   MOVE      'N'           DDSCCYOK                                    BUG8124
     C                   ADD       1             Idx                                         BUG8124
     C                   Eval      FldNameArr(Idx) = 'DDSCCY'                                BUG8124
      *                                                                                      BUG8124
      ** 'Currency should be equal to loan currency'                                         BUG8124
      *                                                                                      BUG8124
     C                   MOVEL     'LEM2001'     MsgIdArr(Idx)                               BUG8124
     C                   GOTO      EndValCcy                                                 BUG8124
     C                   Endif                                                               BUG8124
      *                                                                                      BUG8124
     C     EndValCcy     ENDSR                                                               BUG8124
      *****************************************************************                      BUG8124
     C/EJECT
      *****************************************************************
      **  ValPastDue - Routine to vaildate Past due Flag
      *****************************************************************
     C     ValPastDue    BEGSR
      *
      ***  Must be Y, N or left Blank
      *
     C                   if        DDPASD<>'Y' And DDPASD<>'N' and DDPASD<>' '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPASD'
      *
      ***  invalid entry for Past Due Flag
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0055'
     C                   MOVE      'N'           DDPASDOK
     C                   Endif
      *
     C                   if        DDPASD = 'Y' and WrkReactFacil <> 'Y'
      *
      *** if Past due exist with non-Reactivated Facility
      *** then Sign must be negative
      *
     C                   if        DDPSIG <> '-' and DDISIG <> '-'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPASD'
      *
      ***  Past Due Flag may only be set when Negative Payment are applied
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0054'
     C                   MOVE      'N'           DDPASDOK
     C                   Endif
     C                   Endif
      *
     C                   if        WrkReactFacil = 'Y'
     C                   if        DDPASD = 'Y'
      *
      ***  if Past due exist with Reactivated Facility
      ***  then ensure that Sign is negative
      *
     C                   if        DDRPRI <> *BLANKS
     C                   movel     '-'           DDPSIG
     C                   Endif
      *
     C                   if        DDRINT <> *BLANKS
     C                   movel     '-'           DDISIG
     C                   Endif
      ** Execute Routine                                                                      245383
     C                   IF        CL_PTYP = 64 OR CL_PTYP = 65 OR                            245383
     C                             CL_PTYP = 66 OR CL_PTYP = 67 OR                            245383
     C                             CL_PTYP = 68 OR CL_PTYP = 69 OR                            245383
     C                             CL_PTYP = 71 OR CL_PTYP = 72                               245383
     C                   EXSR      CLOANVAL                                                   245383
     C                   ENDIF                                                                245383
                                                                                              245383
     C                   Else                                                   DDPASD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPASD'
      *
      ***  IF Matured loan Process, in must be for A PAst due Settlement.
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0029'
     C                   MOVE      'N'           DDPASDOK

     C                   Endif                                                  DDPASD
     C                   Endif                                                  WrkReactFacil
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      **  ValPrinCAmnt - Validate Principal Amount and Sign
      *****************************************************************
     C     ValPrincAmnt  BEGSR
      *
     c                   Z-Add     0             PrincAmntNum     13 0          Numeric
     C                   if        DDPSIG<>' ' and DDPSIG<>'+' and DDPSIG<>'-'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPRI'
      *
      ***  'Principal Amount sign is not ' ' or '+' 'or '-'.'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0148'
     C                   MOVE      'N'           DDPSIGOK
     C                   Endif
      *
     c                   MOVEl(P)  DDRPRI        ZFIELD           16            Principal Amount
     c                   Z-ADD     A6NBDP        ZADEC
     C                   Eval      ZADIG = 13 - ZADEC
     C                   CALLB     'ZALIGN'
     C                   parm      *BLANKS       ZRTRN             1
     c                   parm                    ZFIELD
     C                   parm                    ZADEC             1 0
     C                   parm                    ZADIG             2 0
      *
     C                   if        ZRTRN <> 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
      *
      ***  'Principal Amount is not valid'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0191'
     C                   MOVE      'N'           DDRPRIOK
     C                   Endif
      *                                                                                      BUG3114
      ** For flat rate personal loans, the principal that can be paid                        BUG3114
      ** must not exceed the current principal less interest refunded                        BUG3114
      ** less charges refunded less previous repayments                                      BUG3114
      *                                                                                      BUG3114
     C                   if        CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
      *                                                                                      BUG3114
     C                   MOVE      DDRPRI        WAMNT            13 0                       BUG3114
     C                   Z-ADD     WrkOutPrinc   WOPRN            13 0                       BUG3114
     C                   MOVE      DDINRF        WINRF            13 0                       BUG3114
     C                   MOVE      DDCGRF        WCHGF            13 0                       BUG3114
      *                                                                                      BUG3114
     C     WOPRN         ADD       WINRF         WEXPRN           13 0                       BUG3114
     C                   ADD       WCHGF         WEXPRN                                      BUG3114
     C     WAMNT         IFGT      WEXPRN                                                    BUG3114
     C                   ADD       1             Idx                                         BUG3114
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'                                BUG3114
     C                   EVAL      MsgIDArr(Idx) = 'LEM0401'                                 BUG3114
     C                   MOVE      'N'           DDRPRIOK                                    BUG3114
     C                   ENDIF                                                               BUG3114
     C                   endif                                                               BUG3114
      *
     C                   if        DDPSIGOK = 'Y' and DDRPRIOK = 'Y'
      *
      ***  No Error, Save and EDit correctly
      *
     C                   MOVE      ZFIELD        PrincAmntNum
      *
     C                   if        DDPSIG = '-'
     C                   eval      PrincAmntNum = PrincAmntNum * (-1)           Minus
     C                   endif
      *
      *
     C                   CALLB     'ZEDIT'
     C                   parm                    ZFIELD
     C                   parm                    ZADEC
      *
     C                   MOVE      ZFIELD        DDRPRI
     C                   MOVE      ZFIELD        OPRAM            13 0                       BUG3114
      *
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      **  ValIntrAmnt - Validate Interest Amount and Sign
      *****************************************************************
     C     ValIntrAmnt   BEGSR
      *
     c                   Z-Add     0             IntrAmntNum      13 0          Numeric
     C                   if        DDISIG<>' ' and DDISIG<>'+' and DDISIG<>'-'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISIG'
      *
      ***  'Interest Amount sign is not ' ' or '+' 'or '-'.'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0149'
     C                   MOVE      'N'           DDISIGOK
     C                   Endif
      *
     c                   MOVEl(P)  DDRINT        ZFIELD           16            Interest Amount
     C                   CALLB     'ZALIGN'
     C                   parm      *BLANKS       ZRTRN             1
     c                   parm                    ZFIELD
     C                   parm                    ZADEC             1 0
     C                   parm                    ZADIG             2 0
      *
     C                   if        ZRTRN <> 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Interest Amount is not valid'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0192'
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
      *
     C                   if        DDISIGOK = 'Y' and DDRINTOK = 'Y'
      *
      ***  No Error, Save and Edit correctly
      *
     C                   MOVE      ZFIELD        IntrAmntNum
      *
     C                   if        DDISIG = '-'
     C                   eval      IntrAmntNum = IntrAmntNum * (-1)             Minus-
     C                   endif
      *
      *
     C                   CALLB     'ZEDIT'
     C                   parm                    ZFIELD
     C                   parm                    ZADEC
      *
     C                   MOVE      ZFIELD        DDRINT
     C                   MOVE      ZFIELD        OINTA            13 0                       BUG3114
      *
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** ValPenalAmnt - Validate Penality Amount and Sign
      *****************************************************************
     C     ValPenalAmnt  BEGSR
      *
     c                   Z-Add     0             PenalAmntNum     13 0          Numeric
     C                   if        DDRPIG<>' ' and DDRPIG<>'+' and DDRPIG<>'-'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPIG'
      *
      ***  'Penality Amount sign is not valid (not  ' ' , '+' or '-') '
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0150'
     C                   MOVE      'N'           DDRPIGOK
     C                   Endif
      *
     c                   MOVEl(P)  DDRPEN        ZFIELD           16            Penality Amount
     C                   CALLB     'ZALIGN'
     C                   parm      *BLANKS       ZRTRN             1
     c                   parm                    ZFIELD
     C                   parm                    ZADEC             1 0
     C                   parm                    ZADIG             2 0
      *
     C                   if        ZRTRN <> 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPEN'
      *
      ***  'Penality Amount is not valid'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0193'
     C                   MOVE      'N'           DDRPENOK
     C                   Endif
      *
     C                   if        DDRPIGOK = 'Y' and DDRPENOK = 'Y'
      *
      ***  No Error, Save and Edit correctly
      *
     C                   MOVE      ZFIELD        PenalAmntNum
      *
     C                   if        DDRPIG = '-'
     C                   eval      PenalAmntNum = PenalAmntNum * (-1)           Minus
     C                   endif
      *
      *
     C                   CALLB     'ZEDIT'
     C                   parm                    ZFIELD
     C                   parm                    ZADEC
      *
     C                   MOVE      ZFIELD        DDRPEN
      *
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** ValTotalAmnt - Validate Total Amount and Sign
      *****************************************************************
     C     ValTotalAmnt  BEGSR
      *
     c                   Z-Add     0             TotalAmntNum     13 0          Numeric
     C                   if        DDRSIG<>' ' and DDRSIG<>'+' And DDRSIG<>'-'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPIG'
      *
      ***  'Total Amount sign is not valid (not  ' ' , '+' or '-') '
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0151'
     C                   MOVE      'N'           DDRSIGOK
     C                   Endif
      *
     c                   MOVEl(P)  DDRTOT        ZFIELD           16            Total Amount
     C                   CALLB     'ZALIGN'
     C                   parm      *BLANKS       ZRTRN             1
     c                   parm                    ZFIELD
     C                   parm                    ZADEC             1 0
     C                   parm                    ZADIG             2 0
      *
     C                   if        ZRTRN <> 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTOT'
      *
      ***  'Total Amount is not valid'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0194'
     C                   MOVE      'N'           DDRTOTOK
     C                   Endif
      *
     C                   if        DDRSIGOK = 'Y' and DDRTOTOK = 'Y'
      *
      ***  No Error, Save and Edit correctly
      *
     C                   MOVE      ZFIELD        TotalAmntNum
      *
     C                   if        DDRSIG = '-'
     C                   eval      TotalAmntNum = TotalAmntNum * (-1)           Minus
     C                   endif
      *
      *
     C                   CALLB     'ZEDIT'
     C                   parm                    ZFIELD
     C                   parm                    ZADEC
      *
     C                   MOVE      ZFIELD        DDRTOT
      *
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** ValWriteoff - Validate Write-off Flag
      *****************************************************************
     C     ValWriteOff   BEGSR
      *
     C                   IF        DDWOFF <> ' ' and DDWOFF <> 'Y'
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDWOFF'
      *
      ***  'Write-off must be blank or 'Y' '
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0212'
     C                   MOVE      'N'           DDWOFFOK
      *
     c                   endif
      *
      ***  Write off = 'Y' if amounts aren't negative
      *
     C                   IF        DDWOFF = 'Y'
     C                   IF        DDPSIG = '-'  or DDISIG = '-' or DDRPIG= '-'
     C                             OR DDRSIG = '-'
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDWOFF'
      *
      ***  'Write-off cannot be 'Y' with negative Amounts'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0229'
     C                   MOVE      'N'           DDWOFFOK
     c                   endif
     c                   endif                                                  Writeoff = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      ** ValDDAuto - Validate Auto Settle Indicator
      *****************************************************************
     C     ValDDAuto     BEGSR                                                                CLE164
                                                                                              CLE164
     C                   MOVEL     CL_LTYP       NPDCL             1                          CLE164
                                                                                              CLE164
     C                   If        NPDCL = 'X' or NPDCL = 'Y' or NPDCL = 'Z'                  CLE164
                                                                                              CLE164
     C                   If        CL_AUTO = 'C' and DDAuto = 'Y'                             CLE164
     C                   ADD       1             Widx                                         CLE164
     C                   EVAL      WFldNamArr(Widx) = 'DDAUTO'                                CLE164
     C                   EVAL      WMsgIDArr(Widx) = '5047352'                                CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   If        CL_AUTO <> 'C' and DDAuto = 'C'                            CLE164
     C                   ADD       1             Widx                                         CLE164
     C                   EVAL      WFldNamArr(Widx) = 'DDAUTO'                                CLE164
     C                   EVAL      WMsgIDArr(Widx) = '5047353'                                CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   Else                                                                 CLE164
                                                                                              CLE164
     C                   If        CL_AUTO <> 'C' and                                         CLE164
     C                             DDAUTO = 'C'                                               CLE164
     C                   ADD       1             Idx                                          CLE164
     C                   EVAL      FldNameArr(Idx) = 'DDAUTO'                                 CLE164
     C                   EVAL      MsgIdArr(Idx) = '5047386'                                  CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   If        DDAuto = 'Y' and CL_AUTO = 'C'                             CLE164
     C                   If        DDISIG <> '-' and DDPSIG <> '-'                          MD038714
     C                   ADD       1             Widx                                         CLE164
     C                   EVAL      WFldNamArr(Widx) = 'DDAUTO'                                CLE164
     C                   EVAL      WMsgIDArr(Widx) = '5047354'                                CLE164
     C                   Endif                                                              MD038714
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                     MD037915
      ** ValPrinInt - Validate Principal Amount and Interest Amount                         MD037915
      **              Both amounts should be positive if auto settle                        MD037915
      **              is set to C                                                           MD037915
      *****************************************************************                     MD037915
                                                                                            MD037915
     C     ValPrinInt    BEGSR                                                              MD037915
                                                                                            MD037915
     C                   If        DDAUTO = 'C'                                             MD037915
                                                                                            MD037915
     C                   If        DDISIG = '-' or                                          MD037915
     C                             DDPSIG = '-'                                             MD037915
                                                                                            MD037915
     C                   EVAL      DDAUTO = 'Y'                                             MD038714
     C**********         ADD       1             Idx                               MD037915 MD038714
     C**********         If        DDISIG = '-'                                    MD037915 MD038714
     C**********         Eval      FldNameArr(Idx) = 'DDISIG'                      MD037915 MD038714
     C**********         Eval      DDPSIGOK = 'N'                                  MD037915 MD038714
     C**********         Else                                                      MD037915 MD038714
     C**********         Eval      FldNameArr(Idx) = 'DDPSIG'                      MD037915 MD038714
     C**********         Eval      DDISIGOK = 'N'                                  MD037915 MD038714
     C**********         Endif                                                     MD037915 MD038714
     C**********                                                                   MD037915 MD038714
     C**********         Eval      MsgIDArr(Idx) = '5048510'                       MD037915 MD038714
     C                   EndiF                                                              MD037915
                                                                                            MD037915
     C                   Endif                                                              MD037915
     C                   ENDSR                                                              MD037915
      *                                                                                     MD037915
      *****************************************************************                     MD037915
     C/EJECT
      *****************************************************************
      ** ComplexVal - Validate Details based on Key input
      *****************************************************************
     C     ComplexVal    BEGSR
      *
      ***  Manual repayments of CLE005's new risk processing types aren't allowed
      *
     C                   MOVE      *BLANKS       WRINT             1                        AR850197
      *                                                                                     AR850197
     C                   If        CLE005 = 'Y' and PrincAmntNum <> 0 and
     C                             PD_VDAT <> 0
     C                   if        CL_PTYP = 72 and WPTYP72 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
      *
      ***  'Principal Amount is not valid against Guarantees isssued if expected date input'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0219'
     C                   MOVE      'N'           DDRPRIOK
     C                   endif
     C                   endif
      *
      ***  If Principal Amount is Less than Past due Amount Error (Negative Amount)
      *
     c                   if        PrincAmntNum < 0                             Negative Amount
      *
     c                   if        PD_AMTP = 'PD'                               Past due
     C                             and PrincAmntNum < PD_PRAM                   Amnt < PD AMount
      *                                                                         e.g.: -100 < -50
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
      *
      ***  'Principal Amount exceed Past due Expected Amount'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0215'
     C                   MOVE      'N'           DDRPRIOK
     c                   Endif
     c                   Else
      *
      ***  if Past due of Principal Amount (Positive) is Greater than Expected Principal Amount
      *
     c                   if        PD_AMTP = 'PD'                               Past due
     C                             and PrincAmntNum > PD_PRAM                   Amnt > PD AMount
      *                                                                         e.g.: 100  > 50
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
      *
      ***  'Principal Amount exceed Past due Expected Amount'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0215'
     C                   MOVE      'N'           DDRPRIOK
     c                   Endif
     C
     c                   Endif
      *
      ***  if discounted Loans
      *
     C                   If        CL_PTYP = 63 or CL_PTYP = 65 or CL_PTYP = 67
      *
     C                   if        TotalAmntNum >=0 and PD_AMTP <> 'PD'
      *                                                                                     BUG22710
      ***  Check if maturity date of the loan is equal to the value date of the manual      BUG22710
      ***  repayment. If not, exit the validation. If yes, send an error message.           BUG22710
      *                                                                                     BUG22710
     C                   MOVE      *blank        ZDATE                                      BUG22710
     C                   MOVE      *blank        ZDATFM                                     BUG22710
     C                   MOVE      DDVALD        ZDATE                                      BUG22710
     C                   MOVE      BJDFIN        ZDATFM                                     BUG22710
     C                   CALL      'ZDATE1'                                                 BUG22710
     C                   PARM      *BLANKS       ZERR                                       BUG22710
     C                   PARM                    ZDATE                                      BUG22710
     C                   PARM                    ZDATFM                                     BUG22710
     C                   PARM                    ZDAYNO                                     BUG22710
      *                                                                                     BUG22710
     C                   if        ZDAYNO <> CL_MDAT                                        BUG22710
      *
      ***  Error - discounted loan and not Past Due
      *
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDRPRI'                               BUG22710
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'                               BUG22710
      *
      ***  'Discounted loan and not Past due'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0102'
     C**********         MOVE      'N'           DDRPRIOK                                   BUG22710
     C                   MOVE      'N'           DDLNRFOK                                   BUG22710
      *                                                                                     BUG22710
     C                   ADD       1             Idx                                        BUG22710
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'                               BUG22710
     C                   EVAL      MsgIDArr(Idx) = *blanks                                  BUG22710
     C                   MOVE      'N'           DDRPRIOK                                   BUG22710
      *                                                                                     BUG22710
     C                   EVAL      ZDAYNO = 0                                               BUG22710
     C                   Endif                                                              BUG22710
      *                                                                                     BUG22710
     C                   Endif
      *
     C                   if        IntrAmntNum <> 0 and PD_AMTP <> 'PD'
      *
      ***  Error - discounted loan interest different of 0
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Discounted loan and not Past due'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0221'
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
     C                   Endif                                                  Discounted Loans
      *
     C                   IF        IntrAmntNum <> 0 and CL_INTC = 'Y'
      *
      ***  Error - discounted Loans and interest is capitalized
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Interest Capitalized, cannot be input'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0228'
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
      *
      ***  Validate Interest Against O/S interest
      *
     C                   If        WrkRemainInt < 0 and                                Remaining
     C                             IntrAmntNum < WrkRemainInt  or                -100 < -50
     C                             WrkRemainInt >= 0 and                         or
     C                             IntrAmntNum > WrkRemainInt                    100  > 50
     C                   If        DDEVAL <> *Blanks and                                      249766
     C                             DDESEQ <> *Blanks                                          249766
     C                   Else                                                                 249766
      *
     C**********         ADD       1             Idx                                          247626
     C**********         EVAL      FldNameArr(Idx) = 'DDRINT'                                 247626
     C                   ADD       1             Widx                                         247626
     C                   EVAL      WFldNamArr(Widx) = 'DDRINT'                                247626
      *
      *****'Interest*Exceed*remaining*interest*'********************************              247626
      ***  Warning - 'Interest Exceed remaining interest '                                    247626
      *
     C**********         EVAL      MsgIDArr(Idx) = 'LEM0204'                                  247626
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0204'                                247626
     C                   EVAL      WRINT = 'Y'                                              AR850197
     C                   MOVE      'N'           DDRINTOK
     C                   Endif                                                                249766
     C                   Endif
      *
      ***  Validate Interest if Withholding tax indicator is  'G'
      ***  interest cannot greater than Remainig interest less W/hold (Gross)
      *
     C                   if        CL_WTIN = 'G'                                W/hold Gross
      *
      ***  Calulate Maximum for interest Amount :
      *
     C                   Z-ADD     0             WrkMaximum       13 0
      *
     C                   Eval(H)   WrkMaximum = WrkRemainInt -
     C                             ((WrkRemainInt * CL_WTRT) / 100)             Tax %age
      *
     C                   Endif

      *
     C                   If        CL_WTIN = 'G' and WrkMaximum  < 0 and               Maximum
     C                             IntrAmntNum < WrkMaximum    or                 -100 < -50
     C                             CL_WTIN = 'G' and WrkMaximum   >= 0 and             or
     C                             IntrAmntNum > WrkMaximum    or                  100  > 50
      *
      ***  If  W/hold tax aren't Gross calculation
      *
     C                             CL_WTIN <>  'G' and WrkRemainInt < 0 and            Remain Intr
     C                             IntrAmntNum < WrkRemainInt  or                 -100 < -50
     C                             CL_WTIN <> 'G' and WrkRemainInt >= 0 and            or
     C                             IntrAmntNum > WrkRemainInt                      100  > 50
      *
     C                   If        DDEVAL <> *Blanks and                                      249766
     C                             DDESEQ <> *Blanks                                          249766
     C                   Else                                                                 249766
      *                                                                                       249766
     C**********         ADD       1             Idx                                          247626
     C**********         EVAL      FldNameArr(Idx) = 'DDRINT'                                 247626
     C                   ADD       1             Widx                                         247626
     C                   EVAL      WFldNamArr(Widx) = 'DDRINT'                                247626
      *
      *****'Interest*Exceeds*limit*:*Maximum*=*Outstansting*int.*-*Gross*W/hold*Tax'          247626
      *** Warning  'Interest Exceeds limit : Maximum = Outstansting int. - Gross W/hold Tax'  247626
      *
     C**********         EVAL      MsgIDArr(Idx) = 'LEM0209'                                  247626
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0209'                                247626
     C                   EVAL      WRINT = 'Y'                                              AR850197
     C                   MOVE      'N'           DDRINTOK
     C                   Endif                                                                249766
     C                   Endif
      *
      ***  Validate Interest against Writeoff and Maximum/Remaining Interest
      *
     C                   If        DDWOFF = 'Y'
     C                   if        CL_WTIN = 'G'                        and     Gross W/hold Tax
     C                             IntrAmntNum < 0 and WrkMaximum  >= 0 or      intr neg and Max +
     C                             CL_WTIN = 'G'                        and           or
     C                             WrkMaximum  < 0  and IntrAmntNum > 0 or      MAx Neg and Intr +
      *
      ***  If  W/hold tax aren't Gross calculation
      *
     C                             CL_WTIN <> 'G'                       and     or Not Gross W/hold
     C                             IntrAmntNum < 0 and WrkRemainInt >= 0 or     intr - and remain +
     C                             CL_WTIN <> 'G'                       and          or
     C                             WrkRemainInt  < 0  and IntrAmntNum > 0       Remain - and intr +
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Error - Negative Interest cannot be write-off'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0230'
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
     C                   Endif
      *
      ***  Validate interest for Past due Against Past due Expected Interest
      ***  Depending on W/hold tax indicator.
      *
     C                   if        PD_AMTP = 'PD'
      *
     C                   Z-ADD     0             WrkMaximum       13 0
     C                   if        CL_WTIN > 'N'                                Withholding tax
     C                   Eval      WrkMaximum = PD_INTA + PD_WTXA
     C                   Else
     C                   Eval      WrkMaximum = PD_INTA
     C                   Endif
      *                                                                                 Max
     C                   If        IntrAmntNum > 0 and IntrAMntNum > WrkMaximum    100 >  50
     C                             Or                                           or
     C                             IntrAmntNum < 0 and IntrAmntNum < WrkMaximum   -100 < -50
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Interest Exceeds Past Due Interest Amount'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0216'
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
     C                   Endif                                                  PD_AMTP
      *
     C**********         if        DDRINTOK='N' or DDRPRIOK='N' or DDRTOTOK='N'             AR850197
     C                   IF        DDRINTOK='N' AND WRINT = ' '                             AR850197
     C                             OR DDRPRIOK='N' OR DDRTOTOK='N'                          AR850197
     C                   GOTO      EndTag1
     C                   Endif
      *
      ***  Validate Total Amount = Principal + interest
      *
     C                   IF        TotalAmntNum <> 0
     C                   If        TotalAmntNum <> PrincAmntNum + IntrAmntNum
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTOT'
      *
      ***  'Total not equalt to sum of Principal + Interest'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0205'
     C                   MOVE      'N'           DDRTOTOK
     C                   Endif
      ***  Calculate Total Amount if its blanks
     C                   ELSE
     C                   EVAL      TotalAmntNum = PrincAmntNum + IntrAmntNum
     C                   IF        TotalAmntNum < 0
     C                   EVAL      DDRSIG = '-'
     C                   ELSE
     C                   EVAL      DDRSIG = ' '
     C                   ENDIF

     C                   IF        TotalAmntNum <> 0
     C                   Z-ADD     TotalAmntNum  WRKTOTAL         13 0

     C                   IF        WRKTOTAL < 0
     C                   MULT      -1            WRKTOTAL
     C                   ENDIF

     C                   MOVE(P)   WRKTOTAL      ZFIELD

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
     C                   MOVE      ZFIELD        DDRTOT
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTOT
     C                   ENDIF
     C                   ENDIF
      *
      ***  Interest and principal cannot be 0 at same time
      *
     C                   If        PrincAmntNum = 0 and IntrAmntNum = 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
      *
      ***  'Please insert Principal or Interest'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0227'
     C                   MOVE      'N'           DDRPRIOK
      *
      ** Add 1 to IDX again so a second field can be highlighted,                             225484
      ** but output blank message as LEM0227 is not required again.                           225484
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
     C***********        EVAL      MsgIDArr(Idx) = *BLANKS                                    225484
     C                   EVAL      MsgIDArr(Idx) = 'LEM0612'                                  225484
     C                   MOVE      'N'           DDRINTOK
     C                   Endif
      *
      ***  Warning Error Messages
      *
     C                   if        PrincAmntNum <> 0 or IntrAmntNum <> 0
      *
     C                   If        PrincAmntNum > WrkOutPrinc
      *
     C                   ADD       1             Widx
     C                   EVAL      WFldNamArr(Widx) = 'DDRPRI'
      *
      ***  'Warning : Principal Exceeds Outstanding'
      *
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0050'
     C                   MOVE      'N'           DDRPRIOK
      *
     C                   if        PD_AMTP = 'RE'
     C                   ADD       1             Widx
     C                   EVAL      WFldNamArr(Widx) = 'DDRPRI'
      *
      ***  'Warning : Reviewed Scheduled Futur Repayment(s)'
      *
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0051'
     C                   MOVE      'N'           DDRPRIOK
     C                   Endif
      *
      ***  Warning If principal amount is not RE Amount or Loan Amount
      *
     C                   If        PrincAmntNum <>  PD_PRAM
     C                             and PD_AMTP = 'RE' and CL_REPT <> 3 or
     C                             PrincAmntNum <>  CL_RAMT
     C                             and DDESEQ = 'LN ' and CL_REPT <> 3
      *
     C                   ADD       1             Widx
     C                   EVAL      WFldNamArr(Widx) = 'DDRPRI'
      *
      ***  'Warning : Principal Amount is not Expected Amount.'
      *
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0005'
     C                   MOVE      'N'           DDRPRIOK
      *
     C                   Endif
      *                                                                                      BUG3114
      ** For flat rate personal loans:                                                       BUG3114
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
      *                                                                                      BUG3114
      ** For early payoffs, error if the full expected principal is                          BUG3114
      ** not paid, w/c is computed as: current principal less previous                       BUG3114
      ** repayments less interest refunded less charges refunded                             BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and OPRAM <> WEXPRN                          BUG3114
     C                   MOVEL     *BLANKS       ZFIELD                                      BUG3114
     C                   MOVE      WEXPRN        ZFIELD           16                         BUG3114
     C                   Z-ADD     A6NBDP        ZADEC             1 0                       BUG3114
      *                                                                                      BUG3114
     C                   CALL      'ZEDIT'                                                   BUG3114
     C                   PARM                    ZFIELD                                      BUG3114
     C                   PARM                    ZADEC                                       BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             Idx                                         BUG3114
     C                   EVAL      MsgIDArr(Idx) = 'LEM0402'                                 BUG3114
     C                   MOVE      ZFIELD        WWEXPRN          16                         BUG3114
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'                                BUG3114
     C**********         EVAL      MsgDtaArr(Idx) = WWEXPRN                         BUG3114 MD000091
     C                   EVAL      BLen = %Len(%Trim(WWEXPRN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(WWEXPRN)                  MD000091
     C                   MOVE      'N'           DDRPRIOK                                    BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
      ** For early payoffs, error if the full expected interest is                           BUG3114
      ** not paid, w/c is computed as: outstanding interest to date                          BUG3114
      ** less previous repayments                                                            BUG3114
      *                                                                                      BUG3114
     C                   if        CL_ADIF = 'Y' and DDESEQ = ' '                            BUG3114
     C                             and OINTA <> WrkRemainInt                                 BUG3114
     C                   MOVEL     *BLANKS       ZFIELD                                      BUG3114
     C                   MOVE      WrkRemainInt  ZFIELD           16                         BUG3114
     C                   Z-ADD     A6NBDP        ZADEC             1 0                       BUG3114
      *                                                                                      BUG3114
     C                   CALL      'ZEDIT'                                                   BUG3114
     C                   PARM                    ZFIELD                                      BUG3114
     C                   PARM                    ZADEC                                       BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             Idx                                         BUG3114
     C                   EVAL      MsgIDArr(Idx) = 'LEM0403'                                 BUG3114
     C                   MOVE      ZFIELD        WWRemInt         16                         BUG3114
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'                                BUG3114
     C**********         EVAL      MsgDtaArr(Idx) = WWRemInt                        BUG3114 MD000091
     C                   EVAL      BLen = %Len(%Trim(WWRemInt))                             MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(WWRemInt)                 MD000091
     C                   MOVE      'N'           DDRPRIOK                                    BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   Endif                                                               BUG3114
      *
      ***  Warning if Sum of Principal + interest is not = to Expected Total
      *
     C                   If        PrincAmntNum + IntrAmntNum <>  PD_TAMT
     C                             and PD_AMTP = 'RE' and CL_REPT <> 1 or
     C                             PrincAmntNum + IntrAmntNum <>  CL_RAMT
     C                             and DDESEQ = 'LN ' and CL_REPT <> 1
      *
     C                   ADD       1             Widx
     C                   EVAL      WFldNamArr(Widx) = 'DDRTOT'
      *
      ***  'Warning : Principal + interest is not Expected Total'
      *
     C                   EVAL      WMsgIDArr(Widx) = 'LEM0006'
     C                   MOVE      'N'           DDRTOTOK
      *
     C                   Endif
      *
     C                   Endif                                                  Princ <> O/s Princ
      *
     C                   Endif                                                  Princ or Intr not 0
      *
      ***  for Loans with Repayment type 2 (For 'LN '),
      *
     C                   IF        DDESEQ = 'LN ' and CL_REPT = 2
      *
      ***  Expected Date in Midas Format
      *
     C                   MOVE      DDEVAL        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
      ***  validate expected date against the principal repayment date
      *
     C                   If        PrincAmntNum <> 0 and ZDAYNO <> CL_NRPD
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDRPRI'                                BUG4326
     C                   EVAL      FldNameArr(Idx) = 'DDEVAL'                                BUG4326
      *
      ***  'Expected Value date is not Next Repayment Date'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0207'
     C**********         MOVE      'N'           DDRPRIOK                                    BUG4326
      **********                                                                             BUG4326
     C**********         ADD       1             Idx                                         BUG4326
     C**********         EVAL      FldNameArr(Idx) = 'DDEVAL'                                BUG4326
     C**********         EVAL      MsgIDArr(Idx) = *BLANKS                                   BUG4326
     C                   MOVE      'N'           DDEVALOK
     C                   Endif
      *
      ***  validate expected date against the interest repayment date
      *
     C                   If        IntrAmntNum <> 0 and ZDAYNO <> CL_NIDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
      *
      ***  'Expected Value date is not Next interest Date'
      *
     C                   EVAL      MsgIDArr(Idx) = 'LEM0311'
     C                   MOVE      'N'           DDRINTOK
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEVAL'
     C                   EVAL      MsgIDArr(Idx) = *BLANKS
     C                   MOVE      'N'           DDEVALOK
     C                   Endif
      *
     C                   Endif                                                  DDESEQ = 'LN '
      *
      ***  Calculate W/tax for PD Match
      *
     C                   Z-Add     0             WrkWholdTax      13 0
     C                   if        CL_WTIN >= 'G' or DDEVAL <> *BLANK
      *
     c                   if        CL_WTIN <= 'N'                               Net or Gross
     c                   Eval(H)   WrkWHoldTax = IntrAmntNum *
     c                             (CL_WTRT / (100 - CL_WTRT))
     C                   Else                                                   Receivable
     c                   Eval(H)   WrkWHoldTax = IntrAmntNum * (CL_WTRT / 100)
     C                   Eval      IntrAmnTNum = IntrAMntNum - WrkWHoldTax
     C                   Endif

     C                   Endif
      *
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C     CL_AUTO       ANDEQ     'C'                                                        CLE134
                                                                                              CLE134
     C                   MOVE      DDVALD        ZDATE                                        CLE134
     C                   MOVE      BJDFIN        ZDATFM                                       CLE134
     C                   CALL      'ZDATE1'                                                   CLE134
     C                   PARM      *BLANKS       ZERR                                         CLE134
     C                   PARM                    ZDATE                                        CLE134
     C                   PARM                    ZDATFM                                       CLE134
     C                   PARM                    ZDAYNO                                       CLE134
                                                                                              CLE134
      ** Proceed only if MR (backvalued)                                                      CLE134
                                                                                              CLE134
     C     ZDAYNO        IFLT      BJRDNB                                                     CLE134
                                                                                              CLE134
      ** Warning only if we have existing PDCLs on file                                       CLE134
                                                                                              CLE134
     C                   MOVE      DDLNRF        WKLN2                                        CLE134
     C     KLOAN         SETLL     LEPDUED0                                                   CLE134
     C     KLOAN         READE     LEPDUED0                             9999                  CLE134
     C                   IF        *IN99 = *ON                                                CLE134
     C     KLOAN         SETLL     LEPDUFD0                                                   CLE134
     C     KLOAN         READE     LEPDUFD0                             9999                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        *IN99 = *OFF                                               CLE134
     C                   MOVE      'N'           DDLNRFOK                                     CLE134
     C                   ADD       1             WIdx                                         CLE134
     C                   EVAL      WFldNamArr(WIdx) = 'DDLNRF'                                CLE134
     C                   EVAL      WMsgIDArr(WIdx)  = '5045707'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C**********         MOVE      CL_LTYP       NPDLC             1                CLE134 AR1080805
     C**********         MOVEL     CL_LTYP       NPDLC             1              AR1080805 MD020445
     C**********         MOVE      'N'           UpSRFlg                             CLE134 MD020445
     C*****ZDAYNO        IFEQ      BJRDNB                                            CLE134 MD020445
     C*****NPDLC         ANDNE     'Z'                                               CLE134 MD020445
     C*****NPDLC         ANDNE     'X'                                               CLE134 MD020445
     C*****NPDLC         ANDNE     'Y'                                               CLE134 MD020445
     C*****CL_REPT       ANDEQ     2                                                 CLE134 MD020445
     C*****MSRCMP        ANDEQ     'Y'                                               CLE134 MD020445
     C*****IntrAmntNum   ANDEQ     0                                                 CLE134 MD020445
     C**********         MOVEL     DDLNRF        CLNRF                               CLE134 MD020445
     C**********         MOVEL     BJRDNB        CVALD                               CLE134 MD020445
     C*****MRTKEY        CHAIN     LOAMSL3                            99             CLE134 MD020445
     C******IN99         IFEQ      *ON                                               CLE134 MD020445
     C*****MRTKEY        CHAIN     LOAMSLA                            99             CLE134 MD020445
     C******IN99         IFEQ      *OFF                                              CLE134 MD020445
     C**********         MOVE      'N'           DDLNRFOK                            CLE134 MD020445
     C**********         ADD       1             WIdx                                CLE134 MD020445
     C**********         EVAL      WFldNamArr(WIdx) = 'DDLNRF'                       CLE134 MD020445
      **********                                                                  AR1080805 MD020445
     C**********         SELECT                                                   AR1080805 MD020445
     C**********         WHEN      PrincAmntNum < PRAMCK                          AR1080805 MD020445
     C**********         EVAL      WMsgIDArr(WIdx)  = '5045556'                      CLE134 MD020445
     C**********         WHEN      PrincAmntNum = PRAMCK OR                       AR1080805 MD020445
     C**********                   PrincAmntNum > PRAMCK                          AR1080805 MD020445
     C**********         EVAL      WMsgIDArr(WIdx)  = '5045899'                   AR1080805 MD020445
     C**********         ENDSL                                                    AR1080805 MD020445
      **********                                                                  AR1080805 MD020445
     C**********         MOVE      'Y'           UpSRFlg                             CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C     Endtag1       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CrtValidFilFmt - Create file format before Update            *
      *****************************************************************
     C     CrtValidFilFmtBEGSR
      *
      ***  Fill in known Fields
      *
     C                   RESET                   NwMaPyFilFmt
     C                   MOVE      'D'           MRRECI
     C                   MOVE      DDLNRF        MRLNRF                         Loan Ref
                                                                                              CSC024
     C                   IF        DDSEQN <> *BLANKS                                          CSC024
     C                   MOVE      DDSEQN        MRLASN                                       CSC024
     C                   ENDIF                                                                CSC024
      *
     C                   MOVE      DDVALD        ZDATE                          Value Date
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        MRVDAT
      *
      ***  Expected Date in Midas Format
      *
     C                   MOVE      DDEVAL        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        MRXAVD
      *
     c                   if        DDESEQ <> 'LN '
     C                   MOVE      DDESEQ        MRXASQ                         in UPD
     C                   Endif
      *
     C                   Z-ADD     2             MRMRIN
     C                   MOVE      CL_LTYP       MRLTYP
     C                   MOVE      CL_SUTP       MRSUTP
     C                   MOVE      CL_CLAS       MRCLAS                                       CLE042
     C                   MOVE      CL_PTYP       MRPTYP
     C                   MOVE      'MR'          MRAMTP
     c                   MOVE      CL_CCY        MRCCY
     c                   MOVE      CL_BRCA       MRBRCA
     c                   MOVE      CL_CNUM       MRCNUM
     C                   MOVE      CL_FCUS       MRFCUS
     C                   MOVE      CL_FTYP       MRFTYP
     C                   MOVE      CL_FCLB       MRFCLB
     C                   MOVE      CL_FSEQ       MRFSEQ
     c                   MOVE      'N'           MRAUTO
     C                   Z-ADD     PrincAmntNum  MRPRAM
     C                   Z-ADD     IntrAmntNum   MRINTA
     C                   Z-ADD     WrkWholdTax   MRWTXA
     C                   Z-ADD     PenalAmntNum  MRPNAM
     C                   Z-ADD     TotalAmntNum  MRTAMT
     C                   MOVE      'A'           MRLLAG
     C                   MOVE      DDWOFF        MRLWOI
     C                   MOVE      CL_WTIN       MRWTIN
     C                   MOVE      DDEVAL        ZDATE                          Value Date
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        MRXAVD
      *
     C                   MOVE      DDPASD        MRPAST
     C                   Z-ADD     BJRDNB        MRORED
     C                   Z-ADD     BJRDNB        MRLCD
     C                   MOVE      'M'           MRMNSG                         Manual generated
     C**********         MOVE      'N'           MRGASS                                       CLE106
     C**********         MOVE      'P'           MRGASS                                CLE106 244552
     C**********         MOVE      'P'           MRGASS                                244955 249232
     C**********         MOVE      DDGASS        MRGASS                                244552 244955
     C                   MOVE      DDGASS        MRGASS                                       249232
     C                   MOVE      'N'           MRGPRT
     C                   MOVE      'N'           MRNRLI
     C     CLE007        IFEQ      'Y'
     C     DDPASD        ANDEQ     'Y'
     C                   MOVE      'Y'           MRPDGN
     C                   ENDIF
     C                   MOVE      DDSTAL        MRSTAL                                       CLE034

     C                   ENDSR
      *****************************************************************                       245383
      /EJECT                                                                                  245383
      *****************************************************************                       245383
     C     CLOANVAL      BEGSR                                                                245383
                                                                                              245383
     C                   IF        CL_PTYP = 66 OR CL_PTYP = 67 OR                            245383
     C                             CL_PTYP = 69 OR CL_PTYP = 72                               245383
     C*******************EVAL      WLNRF = CL_OLNO                                     245383 CPK027
     C                   MOVE      CL_OLNO       WLNRF                                        CPK027
     C                   EVAL      WRCDT = CL_RCDT                                            245383
     C                   ELSE                                                                 245383
     C                   EVAL      WLNRF = CL_MLNR                                            245383
     C                   EVAL      WRCDT = CL_RCDT                                            245383
     C                   ENDIF                                                                245383
                                                                                              245383
     C     KCLON         Chain     CLOAN                                                      245383
     C                   IF        %found(CLOAN) AND RECI = 'M'                               245383
                                                                                              245383
     C                   ADD       1             Idx                                          245383
     C                   EVAL      FldNameArr(Idx) = 'DDPASD'                                 245383
     C                   MOVEL     'LEM0613'     MsgIDArr(Idx)                                245383
     C                   MOVE      'N'           DDPASDOK                                     245383
                                                                                              245383
     C                   ENDIF                                                                245383
                                                                                              245383
     C                   ENDSR                                                                245383
      *****************************************************************
      /EJECT
      *****************************************************************
      * *inzsr - Program Initialisation routine                       *
      *****************************************************************
     C     *inzsr        BEGSR

     C     *entry        PLIST
      ***  Inputs
     C                   PARM                    RespMode          1            Response mode
     C                   PARM                    NwMaPyScnFmt                   Nw MR in Screen Fmt
     C**********         PARM                    NwMaP2ScnFmt                          244552 244955
     C                   PARM                    NwMaP2ScnFmt                                 249232
     C                   PARM                    DDAuto            1                          CLE164
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    LoanFilFmt                     Loan Details
     C                   PARM                    WrkReactFacil     1            Reactivated facility
     C                   PARM                    WrkOutPrinc      13 0          Outstanding Princ.
     C                   PARM                    WrkRemainInt     13 0          Loan Remaining int.
     C                   PARM                    WPTYP72           1            Expected on type 72
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    ExtData                        Addt Data
      ***  Outputs
     C                   PARM                    ErrorMaPy                      OK flags
     C                   PARM                    FldNameArr                     Error Fields Array
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx                                  Index
     C                   PARM                    WFldNamArr                     Warning Flds Array
     C                   PARM                    WMsgIdArr                              Msg Ids
     C                   PARM                    WMsgDtaArr                             Msg Data
     C                   PARM                    WIdx                                   Index
     C                   PARM                    NwMaPyFilFmt                   Nw MR in File Fmt
     C**********         PARM                    UpSRFlg           1                 CLE134 MD020445
     C                   PARM                    DDAutoOK          1                          CLE164
      *                                                                                       245383
      * Key List for CLOANCL                                                                  245383
     C     KClON         KLIST                                                                245383
     C**********         KFLD                    WLNRF             6 0                 245383 CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1                          245383
      *                                                                                       245383
     C     KLOAN         KLIST                                                                CLE134
     C                   KFLD                    WKLN2             6                          CLE134
                                                                                              CLE134
     C*****MRTKEY        KLIST                                                       CLE134 MD020445
     C**********         KFLD                    CLNRF             6                 CLE134 MD020445
     C**********         KFLD                    CVALD             5 0               CLE134 MD020445
      *
      ***  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEMAPYVAL'   DBPGM
     C                   OUT       LDA
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
                                                                                              CLE134
      ** Check if CLE134 is installed                                                         CLE134
                                                                                              CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RtCd                                        CLE134
     C                   PARM      '*VERIFY'     @Optn                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
                                                                                              CLE134
     C                   IF        @RtCd = *BLANKS                                            CLE134
     C                   MOVEL     'Y'           CLE134            1                          CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVEL     'N'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       240408
      ** Check System Value: Use Original Borrower or Purchased From?                         240408
      ** Set up parameter so access object checks LoanCustOriginPurch                         240408
     C                   MOVEL     WPARM         SVALK1                                       240408
     C**********         MOVEL     WPARM1        SVALK2                              CLE134 MD020445
      * Call Access object:                                                                   240408
     C                   CALL      'AOSVALR0'                                                 240408
     C                   PARM                    RTNCDE            7                          240408
     C                   PARM                    SVALK1           20                          240408
     C                   PARM                    SVAL1           200                          240408
     C                   PARM                    SVALK2           20                          240408
     C                   PARM                    SVAL2           200                          240408
     C                   PARM                    SVALK3           20                          240408
     C                   PARM                    SVAL3           200                          240408
     C                   PARM                    SVALK4           20                          240408
     C                   PARM                    SVAL4           200                          240408
     C                   PARM                    SVALK5           20                          240408
     C                   PARM                    SVAL5           200                          240408
     C                   PARM                    SVALK6           20                          240408
     C                   PARM                    SVAL6           200                          240408
     C                   PARM                    SVALK7           20                          240408
     C                   PARM                    SVAL7           200                          240408
     C                   PARM                    SVALK8           20                          240408
     C                   PARM                    SVAL8           200                          240408
     C                   PARM                    SVALK9           20                          240408
     C                   PARM                    SVAL9           200                          240408
     C                   PARM                    SVALK0           20                          240408
     C                   PARM                    SVAL10          200                          240408
      * If the system value is not found then default value to 'P'                            240408
     C     RTNCDE        IFNE      '        '                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ELSE                                                                 240408
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240408
     C                   MOVEL     SVAL1         WRK01             1                          240408
     C     WRK01         IFEQ      'O'                                                        240408
     C                   MOVE      'O'           PPCUST            1                          240408
     C                   ELSE                                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ENDIF                                                                240408
     C**********         MOVEL(P)  SVAL2         WRK02             1                 CLE134 MD020445
     C*****WRK02         IFEQ      'Y'                                               CLE134 MD020445
     C**********         MOVE      'Y'           MSRCMP            1                 CLE134 MD020445
     C**********         ELSE                                                        CLE134 MD020445
     C**********         MOVE      'N'           MSRCMP                              CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C                   ENDIF                                                                240408
      *

      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      DBPGM = 'LEMAPYVAL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
