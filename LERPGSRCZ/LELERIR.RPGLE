     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Retrieve a record')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Lending module                                       *
      *                                                               *
      *  LELERIR   - LE Rollover retrieve a record                    *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702532           Date 13Jan15               *
      *                 MD028338           Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247628             Date 09May07               *
      *                 246574             Date 27Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11315           Date 03May06               *
      *                 BUG9787            Date 22Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 08Sep03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3405 (REOPENED) Date 08Jul04               *
      *                 BUG3405            Date 02Jul04               *
      *                 BUG2579            Date 07Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 BUG827             Date 06May04               *
      *                 CAP084  *CREATE    Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR016: Settlement Allocation                      *
      *  CSF011 - Customer Name on Inputs                             *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247628 - Apply fix 241367.                                   *
      *  241367 - To clear the value of FLPAY when the RPST is blank. *
      *  246574 - CAP086 Fields are MISSING  - Add InfData Ds         *
      *           CAP077 Fields are MISSING  - Add ExtData Ds         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11315 - Ensure that DDATYP is not blank.                  *
      *  BUG9787 - Ensure that Loan Processing Type is not blank.     *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3405 (REOPENED) - Removed DDCCYN from work fields         *
      *  BUG3405 - Added new base rate code currency for LERI.xml     *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - Midas Plus API development                          *
      *           The existing core version was replaced by this new  *
      *           program.  The previous LELERIR is not yet complete. *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
     FLEFCLTL0  IF   E           K DISK
     F                                     PREFIX(F_)
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
 
      *****************************************************************
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** SCREEN FORMATS
      **-----------------------------------------------------------------------
 
     D NwRoScnFmt    E DS                  EXTNAME(LELERIPD)
      ** New Rollover in Screen Format
 
     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
      ** Rollover Instructions Work fields
 
     D NwRoScnFmt3   E DS                  EXTNAME(LELERI3PD)
      ** Rollover Instructions MidasPlus work fields
 
     D CrRoScnFmt    E DS                  EXTNAME(LELERIPD)
     D                                     PREFIX(@)
      ** (Current) Rollover in Screen Format
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen Receive Instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen Payment Instructions
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** Screen FRA/IRS Instructions
 
      **-----------------------------------------------------------------------
      ** FILE FORMATS
      **-----------------------------------------------------------------------
 
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L)
      ** Current Loan in File Format CL
 
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K)
      ** Current Loan in File Format CK
     D  LeriFilREC           415    469
     D  LeriFilPAY           558   1102
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** File Receive Instructions
 
     D  FLREC                 21     75
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ** File Payment Instructions
     D  FLPAY                 21    565
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File FRA/IRS Instructions
 
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  246574
     D                                     PREFIX(IF_)                                        246574
                                                                                              246574
     D ExtData       E DS                  EXTNAME(LELEEXPD)                                  246574
      ** Rollover Extra Data - User's Enhancement(s) data                                     246574
                                                                                              246574
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Module Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
     D ACCYA           S              3    DIM(12)
 
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      *                                                                                       CSD027
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
                                                                                              CLE106
      ** CLE106 feature                                                                       CLE106
     D CLE106          S              1                                                       CLE106
     D CLE034          S              1                                                       CLE034
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
 
      **-----------------------------------------------------------------------
 
     C                   CLEAR                   CrLnFilFmtCL
     C                   CLEAR                   CrLnFilFmtCK
     C                   CLEAR                   NwRoScnFmt
     C                   CLEAR                   NwRoScnFmt2
     C                   CLEAR                   NwRoScnFmt3
     C                   MOVE      DDACTN_In     DDACTN
 
      ** If the action code is blank, enquire unless authorising
 
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      LELERIRED
     C                   ELSE
     C                   MOVEL     DDLNRF_In     @LNRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @ERRDTA                                      CLE148
     C                   ENDIF
 
      ** If loan read
      ** and no error message returned
 
     C     @LNRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
 
      ** Retrieve deal details (all key fields required for call to rtv module)
 
     C                   MOVEL     @LNRED        DDLNRF
     C                   MOVEL     @FTRED        ARFOTRANID
     C                   EXSR      LELERIRTV
 
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      DDLUTN = LPCRF                                             CLE106
     C                   ENDIF                                                                CLE106
     C                   MOVEL     LPTYP         DDPTYP                                      BUG9787
      ** Convert to screeen format
 
     C     Idx           IFEQ      0
     C                   EXSR      LELERICVT
     C                   EXSR      @CHKLOAN
     C                   EXSR      ZASETINCVT
                                                                                              CLE106
      ** If CLE106 available, set Loan UTN to PC Ref retrieved from CLOANCL                   CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      DDLUTN = LPCRF                                             CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Z-ADD     Idx           Ix
     C     @ERRMS        IFNE      *BLANK
     C                   Eval      Ix = Ix + 1
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     @ERRMS        MsgIDArr(Ix)
     C                   MOVEL     @ERRDTA       MsgDtaArr(Ix)                                CLE148
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF
 
     C     ReturnCode    IFNE      *BLANK
     C                   Eval      Ix = Ix + 1
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0035'     MsgIDArr(Ix)
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF
     C                   EVAL      DDATYP = 'RO'                                            BUG11315
 
      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL      Buffer = NwRoScnFmt + NwRoScnFmt2 +
     C**********                       NwRoScnFmt3 + ##RECS + ##PAYS                          246574
     C**********                       NwRoScnFmt3 + ##RECS + ##PAYS +                 246574 CSF011
     C**********                       NwRoScnFmt3 +                                CSF011A AR702532
     C**********                       ##RECS + ##PAYS +                             CSF011 AR702532
     C**********                           InfData + ExtData                         246574 AR702532
     C                                 NwRoScnFmt3 + @ACTRV + ##RECS +                      AR702532
     C                                 ##PAYS + InfData + ExtData                           AR702532
 
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LELERIRED - Read previous or next record in Loans file       *
      *                                                               *
      *****************************************************************
     C     LELERIRED     BEGSR
 
     C                   CALLB     'LELERIRED'
 
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
 
      ** Action code
      ** Loan number pointer
      ** Front Office ID
     C                   PARM                    DDACTN            1
     C                   PARM      DDLNRF_In     DDLNRF            6
     C                   PARM                    DDFRTN           20
 
      ** Read forward
      ** Read backward
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
 
      ** OUTPUT PARAMETERS
      ** Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
 
      ** Loan number read
      ** Front Office ID READ
     C                   PARM      *BLANK        @LNRED            6
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LELERIRTV - Retrieve File details from CLOANCL and CLOANCK   *
      *                                                               *
      *****************************************************************
     C     LELERIRTV     BEGSR
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LELERIRTV'
 
      ** INPUTS
      ** Return code
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE
 
      ** Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Loan Number
     C                   PARM                    DDACTN            1
     C                   PARM                    ARFOTRANID
     C                   PARM                    DDLNRF
 
      ** Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
 
      ** OUTPUTS
      ** (Current) loan in file format CL
      ** (Current) loan in file format CK
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
 
      ** OK - Action code
      ** OK - Loan Number
     C                   PARM                    DDActnOK          1
     C                   PARM                    DDLNRFOK          1
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Set screen OK fields to 'Y' if action code and loan number is valid
 
     C     DDActnOK      IFEQ      'Y'
     C     DDLnrfOK      ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LELERICVT - Convert File format to screen format             *
      *                                                               *
      *****************************************************************
     C     LELERICVT     BEGSR
 
      ** Force Action code to be 'E' to setup all the screen fields
     C                   MOVE      'E'           DDACTN
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LELERICVT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Loan in file format CL
      ** Loan in file format CK
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
 
      ** Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
 
      ** OUTPUTS
      ** Loan in screen format
      ** Rollover Work Fields
     C                   PARM                    NwRoScnFmt
     C                   PARM                    NwRoScnFmt2
 
      ** Update 'Current' Loan with Loan in Screen Format
 
     C                   MOVEL     DDACTN_In     DDACTN
     C                   MOVEL     NwRoScnFmt    CrRoScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASETINCVT- Convert File format to Settlement Screen format  *
      *                                                               *
      *****************************************************************
     C     ZASETINCVT    BEGSR
 
      ** Set up payment instructions from loan
 
     C                   MOVEL     KRPST         FLPSTM
     C                   MOVEL     KRPON         FLPONS
      *                                                                                       241367
     C     DDACTN        IFEQ      'A'                                                        241367
     C     FLPSTM        ANDEQ     0                                                          241367
     C                   MOVE      *BLANK        FLPAY                                        241367
     C                   ELSE                                                                 241367
     C                   MOVEL     LeriFilPAY    FLPAY
     C                   ENDIF                                                                241367
      *                                                                                       241367
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
 
      ** Set up receive instructions from loan
 
     C                   MOVEL     KRRST         FLRSTM
     C                   MOVEL     KRRON         FLRONS
     C                   MOVEL     LeriFilREC    FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
 
      ** Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
 
      ** INPUTS
      ** File Payment Settlement Instruction
      ** File Receipt Settlement Instruction
      ** File FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
 
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
      ** Screen Receipt Settlement Instruction
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
     C                   PARM      *BLANK        ##RECS
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      LCCY          #TRCCY                                      CSF011A
     C                   PARM      LCCY          #TPCCY                                      CSF011A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  @CHKLOAN - Check if Extended Settlements, Funding details    *
      *             and multi ccy Rollovers are required              *
      *                                                               *
      *****************************************************************
     C     @CHKLOAN      BEGSR
 
     C                   MOVE      'N'           @FUNDING          1
     C                   MOVE      'N'           @MULTI
     C                   MOVE      'N'           WSett
     C                   MOVE      'N'           @FCXRATE          1                         BUG2579
 
      **  Enable display of Funding Details if Analytical Accounting
      **  module is switched on and loan is directly funded.
      **  or enable display of Funding Details if Revenue Analysis
      **  is switched on.
 
     C     BGN0ST        IFEQ      'Y'
     C     LFPRC         ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
 
     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C     LPTYP         OREQ      61
     C     LPTYP         OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @FUNDING
     C                   ENDIF
 
     C                   ENDIF
 
      **  Enable Extended Settlement Details for Discount Loan.
      **  and discounted parts purchased or sold
 
     C                   MOVE      *BLANKS       WDisc             1
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WDisc
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WSOLD             1
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
 
      ** Get facility details.
 
     C     WFCLT         CHAIN     LEFCLTL0                           85
 
      **  Enable New currency, New currency amount, Exchange rate,
      **  Exchange rate indicator, Next loan currency repayment
      **  amount will be displayed if Customer Lending Enhancement
      **  Syndications feature is switched on and if it is a
      **  Multi-currency rollover or if EMU Lending Multi currency
      **  rollover feauture is switched on and if loan currency is
      **  an 'In' currency
 
     C     CEU020        IFEQ      'Y'
     C                   MOVE      LCCY          @CURR
     C                   Z-ADD     61            DBASE
     C                   EXSR      SRCurrDet
     C                   ENDIF
 
     C     LMCRA         IFEQ      'Y'
     C     CEU020        IFEQ      'Y'
     C                   MOVE      A6INCY        WINCY             1
     C                   Z-ADD     A6TPSD        WTPSD             5 0
     C                   Z-ADD     A6SPRT        WASPRT           13 8
     C                   ENDIF
     C                   MOVE      'Y'           @MULTI            1
 
      **  Determine if multi-currency rollover
      **  can be processed.
      **  If Multi Ccy Rollovers, enable the Settlements Screen
 
     C                   EXSR      SRMCCY
 
     C     MULTIC        IFEQ      *ON
     C                   MOVEA     F_ALCY        ACCYA
     C     DDACTN        IFEQ      'A'
     C     KNCCY         ORNE      *BLANKS
     C     CEU020        IFEQ      'Y'
     C     KNCCY         ORNE      *BLANKS
     C                   MOVE      'Y'           WSett             1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                              BUG827
      ** Determine if New Forward Yield is required                                           BUG827
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C     LPTYP         ANDNE     70                                                         BUG827
     C     LPTYP         ANDNE     71                                                         BUG827
     C     LPTYP         ANDNE     72                                                         BUG827
     C                   MOVE      'Y'           @FYIELD           1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           @FYIELD                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if New Facility Exchange Rate is required                                 BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     F_MCCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'Y'           @FCXRATE                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           @FCXRATE                                    BUG2579
     C                   ENDIF                                                               BUG2579
 
      ** Determine Loan Category
 
     C                   MOVE      'OTHR'        DDLNCAT
     C     LPTYP         IFEQ      61
     C     LPTYP         OREQ      68
     C     LPTYP         OREQ      69
     C                   MOVE      'CALL'        DDLNCAT
     C                   ENDIF
 
     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C                   MOVE      'TERM'        DDLNCAT
     C                   ENDIF
 
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'DISC'        DDLNCAT
     C                   ENDIF
 
     C     LPTYP         IFEQ      70
     C                   MOVE      'GUAR'        DDLNCAT
     C                   ENDIF
 
     C     LPTYP         IFEQ      71
     C     LPTYP         OREQ      72
     C                   MOVE      'RISK'        DDLNCAT
     C                   ENDIF
 
      ** Move to LELERI3PD work fields
     C                   MOVE      @FUNDING      DDFUNDD
     C                   MOVE      @MULTI        DDMULTI
     C                   MOVE      WSett         DDWPSET
     C                   MOVE      @FYIELD       DDWFYLD           1                          BUG827
     C                   MOVE      @FCXRATE      DDFCXRT                                     BUG2579
 
      ** Set screen OK fields to 'Y' if action code and loan number is valid
     C     DDActnOK      IFEQ      'Y'
     C     DDLnrfOK      ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF
 
      ** Move Payment/Receive Protect fields to LELERI3PD
     C                   MOVE      'Y'           DDPREC
     C                   MOVE      'Y'           DDPPAY
                                                                                             BUG3405
      ** Move currency fields, these are used in LERI.xml API.                               BUG3405
                                                                                             BUG3405
     C                   MOVEL     DDCURR        DDCCYO                                      BUG3405
     C     DDNCCY        IFNE      *BLANKS                                                   BUG3405
     C                   MOVEL     DDNCCY        DDCCYO                                      BUG3405
     C                   ENDIF                                                               BUG3405
                                                                                             BUG3405
     C**********         MOVEL     DDCCYO        DDCCYN                              BUG3405 BUG3405
     C*****DDNCCYB       IFNE      *BLANKS                                           BUG3405 BUG3405
     C**********         MOVEL     DDNCCYB       DDCCYN                              BUG3405 BUG3405
     C**********         ENDIF                                                       BUG3405 BUG3405
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     904           DBASE                          * DBERR 904*
     C                   EXSR      *PSSR                                        ************
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMCCY  -  Check if multi-currency rollover is allowed.       *
      *                                                               *
      *****************************************************************
     C     SRMCCY        BEGSR
 
     C                   MOVE      *OFF          MULTIC            1
     C                   MOVE      'N'           @WERLN
 
      **  Multi-currency rollover processing are allowed
      **  if there are no past due payments outstanding.
      **  and no future-dated loan amendments (except for repay sched)
 
      **  Access loan amendments file.
 
     C**********         Z-ADD     LLNRF         ALNRF                                        CLE148
     C                   MOVEL     LLNRF         ALNRF                                        CLE148
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
 
      **  Check if past due exists.
     C                   MOVE      *ON           WLOGIC            1
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     LLNRF         ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
 
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
 
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     LLNRF
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C     CLE014        ANDEQ     'N'
     C                   MOVE      *OFF          WLOGIC
 
      ** If CEU020 is installed, future dated loan amendments will be
      ** allowed if amendment currency is equal to Euro ccy
 
     C     CEU020        IFEQ      'Y'
     C     A_CCY         ANDEQ     BKEURO
     C                   MOVE      *ON           WLOGIC
     C                   ENDIF
 
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
     C                   ENDIF
 
      ** If parts sold, check if original loan has no past due
      ** payments or future dated loan amendments except for 'RE'.
 
     C**********         Z-ADD     LLNRF         WWLNRF            6 0                        CLE148
     C                   MOVEL     LLNRF         WWLNRF            6                          CLE148
 
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C     LPTYP         OREQ      69
     C     LPTYP         OREQ      72
 
     C                   MOVE      LOLNO         ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
 
     C     *IN85         DOWEQ     '0'
     C*****LOLNO         ANDEQ     A_LNRF                                                     CSD027
     C     ALNRF         ANDEQ     A_LNRF                                                     CSD027
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
 
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
 
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
 
     C     *IN85         DOWEQ     '0'
     C*****A_LNRF        ANDEQ     LOLNO                                                      CSD027
     C     A_LNRF        ANDEQ     ALNRF                                                      CSD027
     C     @WERLN        ANDEQ     'N'
 
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
 
     C                   READ      LELOAML0                               85
     C                   ENDDO
 
     C                   ENDIF
     C                   MOVE      LOLNO         WOLNO
 
      ** Multi-ccy rollover allowed indicator of original loan must
      ** be 'Y'.
 
     C                   MOVE      'A'           WRCDT
     C                   MOVE      LOLNO         WLNRF
     C     WLOAN         CHAIN     CLOAN                              85
     C     *IN85         IFEQ      *OFF
     C     LO_MCRA       ANDEQ     'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      LO_LNRF       @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
 
     C                   ELSE
     C**********         MOVE      LLNRF         WOLNO             6 0                        CLE148
     C                   MOVE      LLNRF         WOLNO             6                          CLE148
     C                   ENDIF
 
      ** Check if all the related parts sold has no past due payments
      ** or future dated loan amendments except for 'RE'.
 
     C*****WOLNO         SETLL     PSOLDFF                                                    CSD027
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C**********         EVAL      OLNONum = WOLNO                                     CSD027 CLE148
     C*****OLNOALpha     SETLL     PSOLDFF                                             CSD027 CLE148
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         SETLL     PSOLDFF                                                    CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
 
     C     *IN85         DOWEQ     '0'
     C     @WERLN        ANDEQ     'N'
 
     C     P_LNRF        IFNE      WWLNRF
     C                   MOVE      P_LNRF        ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
 
     C     *IN85         DOWEQ     '0'
     C     P_LNRF        ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN            1
     C                   MOVE      A_LNRF        @WLNNO            6                          CAP084
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
 
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
 
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
 
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     P_LNRF
     C     @WERLN        ANDEQ     'N'
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Multi-ccy rollover allowed indicator must be 'Y' for all of
      ** the related loan
 
     C     P_MCRA        IFEQ      'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      P_LNRF        @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
     C                   ENDDO
      *
     C                   MOVE      WLOGIC        MULTIC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDACTN_In         1
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C                   PARM                    @ACTRV            1                        AR702532
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
 
      **  Key list for LEFCLTL0
 
     C     WFCLT         KLIST
     C                   KFLD                    LFCUS
     C                   KFLD                    LFTYP
     C                   KFLD                    LFSEQ
 
      **  Key list for LELOAML0
 
     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0
 
      **  Key list for CLOAN
 
     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1
 
      ** Access Bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** Access Module Details
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** DATABASE ERROR
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** Retrieve general ledger details
 
     C                   CALLB     'AOGELRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     903           DBASE                          * DBERR 903*
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if Customer Lending Enhancements - Others
      ** feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   END
 
      ** Check if BLI Lending Enhancements feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01465'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01465            1
     C                   ELSE
     C                   MOVE      'N'           S01465
     C                   END
 
      ** Check if Rollover rate fixing day enhancement - CLE011
      ** feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE011            1
     C                   ELSE
     C                   MOVE      'N'           CLE011
     C                   END
 
      ** Determine if Lending Enhancements for BHF-London is active
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C                   END
 
      ** Check if EMU Lending Multi Currency Rollover - CEU020
      ** feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU020            1
     C                   ELSE
     C                   MOVE      'N'           CEU020
     C                   END
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDE002            1
     C                   ELSE
     C                   MOVE      'N'           CDE002
     C                   END
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if CLE023 is installed                                                    BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       @RTCD                                       BUG2579
     C                   PARM      '*VERIFY '    @OPTN                                       BUG2579
     C                   PARM      'CLE023'      @SARD                                       BUG2579
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2579
                                                                                             BUG2579
     C     @RTCD         IFEQ      *BLANKS                                                   BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ENDIF                                                               BUG2579
      *                                                                                       CLE034
      ** Determine if CLE034 is on                                                            CLE034
      *                                                                                       CLE034
     C                   EVAL      CLE034 = 'N'                                               CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *Blanks       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
                                                                                              CLE034
     C                   IF        @RTCD = *Blanks                                            CLE034
     C                   EVAL      CLE034 = 'Y'                                               CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE106
      ** Determine if CLE106 is installed                                                     CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY '    @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
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
     C                   EVAL      DBASE = 2                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = PsProcPgm                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
 
      ** Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LELERIM01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
 
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
