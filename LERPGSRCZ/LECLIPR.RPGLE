     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan Details Retrieve a record')              *
      *****************************************************************
      *                                                               *
      *  Midas - Lending ILE Module                                   *
      *                                                               *
      *  LECLIPR   - LE Loan Details retrieve a record                *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD044880           Date 15Jan18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD039248           Date 07Jun16               *
      *                 MD037909           Date 08Mar16               *
      *                 CLE141             Date 08Feb16               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 AR804863           Date 08Feb13               *
      *                 AR1075452          Date 15Jan13               *
      *                 AR1021983          Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246159             Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 03Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 08Sep03               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA094             Date 31Mar04               *
      *                 BUG826             Date 23Mar04               *
      *                 CAP084  *CREATE    Date 20Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039248 - Business Day Convention details missing in BDC    *
      *             tab for authorised loan (Recompile)               *
      *  MD037909 - In the loan mainlist upon enquire, defined BDC of *
      *             an authorised loan blanked out                    *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LECLIPYC03,LECLIPYC04              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Added Interest Rate field.                        *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  AR1075452 - Display Interest Frequency Next interest         *
      *              payment date and day no. in Interest Tab of      *
      *              Loan Enquiry                                     *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Added parameter to LECLIPRTV call.
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246159  - CAP086 Fields are MISSING  - Add INFdata Ds        *
      *          - CER001 Fields are MISSING  - Add ExtData Ds        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Get the correct Loan Class.                       *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE106 - Syndications Manager.                               *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CLE031 - Lending Enhancements. Settlement Currency           *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPYD01,LECLIPYC01,LECLIPYC02   *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA094 - Settlement account details not shown on enquiry.    *
      *  BUG826 - Missing CAS00x changes                              *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
     FFCLTY     IF   E           K DISK                                                       CLE031
     F                                     PREFIX(FC)                                         CLE031
     F                                     IGNORE(FCLTYHHF)                                   CLE031
     F                                     IGNORE(FCLTYFNF)                                   CLE031
     F                                     IGNORE(FCLTYZZF)                                   CLE031
                                                                                              CLE106
      ** Parts Sold keyed on Original Loan Number                                             CLE106
     FCLOAN     IF   E           K DISK    PREFIX(PS)                                         CLE106
     F                                     RENAME(CLOANCLF:PSOLDF)                            CLE106
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)                 CLE106
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
      *
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
     D CrLnScnFmt1   E DS                  EXTNAME(LECLI1PD)
      *
      ***  (Current) Loan in Screen Format - Screen 1
     D                                     PREFIX(@)
      *
     D CrLnScnFmt2   E DS                  EXTNAME(LECLI2PD)
      ***  (Current) Loan in Screen Format - Screen 2
     D                                     PREFIX(@)
      *
     D CrLnScnFmt3   E DS                  EXTNAME(LECLI3PD)
      ***  (Current) Loan in Screen Format - Screen 3
     D                                     PREFIX(@)
 
     D CrLnScnFmt4   E DS                  EXTNAME(LECLI4PD)
      ***  (Current) Loan in Screen Format - Screen 4
     D                                     PREFIX(@)
     D RegData       E DS                  EXTNAME(LECLRXPD)                                  CER001
      *                                                                                       CER001
      ** LE Customer Loans extra data layout                                                  CER001
      *                                                                                       CER001
     D CrLnScnFmt5   E DS                  EXTNAME(LECLI5PD)                                  CLE106
      *                                                                                       CLE106
      ***  (Current) Loan in Screen Format - Extra data                                       CLE106
      *                                                                                       CLE106
     D CrLnScnFExt   E DS                  EXTNAME(LESTMP2PD)                                 CER049
      ** Loan Extension in Screen Format                                                      CER049
      *                                                                                    AR1021983
     D CrLnScnFmt6   E DS                  EXTNAME(LECLI6PD)                               AR1021983
      ** Customer Loans details definition file                                            AR1021983
      *                                                                                       CLE141
     D CrLnScnFmt7   E DS                  EXTNAME(LECLI7PD)                                  CLE141
      ** Customer Loans details definition file                                               CLE141
 
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Current Loan in File Format CL
     D                                     PREFIX(L)
     D**ClipFilREC****       459    527                                                       TCA094
     D**ClipFilPAY****       528   1086                                                       TCA094
     D  ClipFilREC           473    527                                                       TCA094
     D  ClipFilPAY           542   1086                                                       TCA094
      *
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Current Loan in File Format CK
     D                                     PREFIX(K)
      *
     D CLIPExFilFmt  E DS                  EXTNAME(LECLX1PD)                                  CER001
      *                                                                                       CER001
      ** Customer Loans Extension Files                                                       CER001
      *                                                                                       CER001
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC***               1     69                                                       TCA094
     D  FLREC                 21     75                                                       TCA094
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
     D**FLPAY***               1    559                                                       TCA094
     D  FLPAY                 21    565                                                       TCA094
      *
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS Instructions
      *
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive Instructions
      *
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen Payment Instructions
      *
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS Instructions
      *
      ** Additional file information e.g. settlements files
 
      **--------------------------------------------------------------------------------------------
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER001
      *                                                                                       CER001
      ** SC Switchable features descriptions                                                  CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG3721
      ** First DS for Access programs - short data structure                                 BUG3721
                                                                                             BUG3721
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG3721
      ** External DS for bank Details                                                        BUG3721
                                                                                             BUG3721
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access programs - long data structure                                  CSF011
                                                                                              CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc
 
     D WIdx            S              3P 0
      ** Index for arrays of warning message ids etc
 
      * Asset code and health code                                                            CLE120
     D SASCD           S              4                                                       CLE120
     D SHLCD           S              4                                                       CLE120
      * Work Fields                                                                           CLE031
     D KCNUM           S                   LIKE(FCCNUM)                                       CLE031
     D KFACT           S                   LIKE(FCFACT)                                       CLE031
     D KFCNO           S                   LIKE(FCFCNO)                                       CLE031
     D KRCTP           S                   LIKE(FCRCTP)                                       CLE031
     D WFPCRF          S                   LIKE(FCPCRF)                                       CLE031
     D WLPCRF          S                   LIKE(LPCRF)                                        CLE031
     D WKMCCY          S                   LIKE(FCMCCY)                                       CLE031
     D CLE031          S              1A                                                      CLE031
     D CLE106          S              1A                                                      CLE106
     D CLE034          S              1A                                                      CLE034
     D ULX004          S              1A                                                      CER001
     D*PLoanNum*       S              6S 0                                             CER001 CLE148
     D PLoanNum        S              6A                                                      CLE148
     D/COPY WNCPYSRC,LECLIPYD01
      *                                                                                    AR1075452
      ** Work fields for Screen 2 retrieval.                                               AR1075452
      *                                                                                    AR1075452
     D WWLNR2          S              6A                                                   AR1075452
     D WWACT2          S              1A                                                   AR1075452
     D WWLST2          S             15A                                                   AR1075452
     D WWBRTT          S              2A                                                   AR1075452
     D WWCHIN          S              1A                                                   AR1075452
     D WWRTSP          S             12A                                                   AR1075452
     D WWSPIN          S              1A                                                   AR1075452
     D WWNIDT          S              6A                                                   AR1075452
     D WWIPFR          S              1A                                                   AR1075452
     D WWIFDY          S              2A                                                   AR1075452
     D WWINTR          S             12A                                                    MD025521
     D InfData       E DS                  EXTNAME(LELEIFPD)                            CAP086246159
     D                                     PREFIX(IF_)                                  CAP086246159
     D ExtData       E DS                  EXTNAME(LECLEXPD)                                  246159
      ***  LE Loans details Extra Data - User's Enhancement(s) data                           246159
      *                                                                                      LLN022A
      ** NEW Loan Details in File Format                                                     LLN022A
      *                                                                                      LLN022A
     D NwCLIPExtFmt  E DS                  EXTNAME(BYLOANX0) PREFIX(BY)                      LLN022A
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
      **--------------------------------------------------------------------------------------------
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   CrLnFilFmtCL
     C                   CLEAR                   CrLnFilFmtCK
     C                   MOVE      DDACTN_In     DDACTN                                      BUG3721
                                                                                             BUG3721
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
     C                   EXSR      LECLIPRED
     C                   ELSE
     C                   MOVEL     DDLNRF_In     @LNRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     @LNRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details (all key fields required for call to rtv module)
      *
     C                   MOVEL     @LNRED        DDLNRF
     C                   MOVEL     @FTRED        APFOTranID       20
     C                   EXSR      LECLIPRTV
      *                                                                                      LLN022A
      ** If BOE Yellow Book installed, retrieve BOE details.                                 LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'LECLIPRTV1'                                              LLN022A
     C                   PARM                    ReturnCode                                  LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    APFOTranID                                  LLN022A
     C                   PARM                    DDLNRF                                      LLN022A
     C                   PARM                    NwCLIPExtFmt                                LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      LECLIP2RV                                                  CER001
      * Retrieve the Loan and Facility UTN                                                    CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   EXSR      LEFCLTY                                                    CLE031
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C*****LOLNO         CHAIN     CLOAN                                              CLE106 CSD027A
     C**********         EVAL      OLNOAlpha = LOLNO                                  CSD027A CLE148
     C*****OLNONum       CHAIN     CLOAN                                              CSD027A CLE148
     C     LOLNO         CHAIN     CLOAN                                                      CLE148
     C                   EVAL      DDSUTN = PSPCRF                                            CLE106
     C                   EVAL      DDLUTN = LPCRF                                             CLE106
     C                   EVAL      @DDSLTP = LSLTP                                            CLE106
     C                   EVAL      @DDSLST = LSLST                                            CLE106
     C                   EVAL      @DDSLCL = LSLCL                                            CLE042
     C                   IF        LoanType = 'PTSO'                                          CLE106
     C                   EVAL      DDFUTN = *Blanks                                           CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      DDFUTN = FCPCRF                                            CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE031
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      @DDSTAL = LSTAL                                            CLE034
     C                   ENDIF                                                                CLE034
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      PUTD@1
     C                   EXSR      PUTD@2
     C                   EXSR      PUTD@3
     C                   EXSR      PUTD@4
     C                   SELECT                                                             BUG10574
     C                   WHEN      LoanType = 'PTSO'                                        BUG10574
     C                   EVAL      @DDLNCS = 'PS'                                           BUG10574
     C                   WHEN      LoanType = 'PTPU'                                        BUG10574
     C                   EVAL      @DDLNCS = 'PP'                                           BUG10574
     C                   WHEN      LoanType = 'LOAN'                                        BUG10574
     C                   EVAL      @DDLNCS = 'LN'                                           BUG10574
     C                   ENDSL                                                              BUG10574
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   IF        DDACTN_In <> 'I'                                           CER001
     C                   EXSR      LECLIP5CT                                                  CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      *BLANKS       RegData                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Convert BOE fields to screen format                                                 LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'LECLIPCVT1'                                              LLN022A
     C                   PARM                    ReturnCode                                  LLN022A
     C                   PARM                    DDLNRF                                      LLN022A
     C                   PARM                    NwCLIPExtFmt                                LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSF011
      ** Populate Customer Name on Input details                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDLNRF'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   MOVEL     @ERRDTA       MsgDtaArr(1)                                 CLE148
     C                   ENDIF
 
      *                                                                                    AR1075452
      ** Populate affected fields for interest details in screen 2                         AR1075452
      *                                                                                    AR1075452
     C                   EVAL      @DDLNR2 = WWLNR2                                        AR1075452
     C                   EVAL      @DDACT2 = WWACT2                                        AR1075452
     C                   EVAL      @DDLST2 = WWLST2                                        AR1075452
     C                   EVAL      @DDBRTT = WWBRTT                                        AR1075452
     C                   EVAL      @DDCHIN = WWCHIN                                        AR1075452
     C                   EVAL      @DDRTSP = WWRTSP                                        AR1075452
     C                   EVAL      @DDSPIN = WWSPIN                                        AR1075452
     C                   EVAL      @DDNIDT = WWNIDT                                        AR1075452
     C                   EVAL      @DDIPFR = WWIPFR                                        AR1075452
     C                   EVAL      @DDIFDY = WWIFDY                                        AR1075452
     C                   EVAL      @DDINTR = WWINTR                                         MD025521
                                                                                           AR1075452
      * Build buffer with required output
     C                   EVAL                 Buffer = CrLnScnFmt1 + CrLnScnFmt2
     C                                        + CrLnScnFmt3 + CrLnScnFmt4
     C                                        + CrLnScnFmt5                                   CLE106
     C                                               + SASCD + SHLCD                          CLE120
     C                                               + @ACTRV                               AR804863
     C                                        + CrLnScnFExt                                   CER049
     C                                        + CrLnScnFmt6                                AR1021983
     C                                        + CrLnScnFmt7                                   CLE141
     C                                           + ##RECS  + ##PAYS
     C                                           + @DEPI                                    MD044880
     C                                           + Infdata                              CAP086246159
     C**********                                 + RegData                           CER001 MD044880
     C                                           + ExtData                                    246159
     C                                           + RegData                                  MD044880
 
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
      ** Initialise Customer name fields                                                     CSF011A
                                                                                             CSF011A
     C                   EVAL      @DDCRSN = *BLANKS                                         CSF011A
     C                   EVAL      @DDCRNM = *BLANKS                                         CSF011A
     C                   EVAL      @DDCRTN = *BLANKS                                         CSF011A
     C                   EVAL      @DDPRSN = *BLANKS                                         CSF011A
     C                   EVAL      @DDPRNM = *BLANKS                                         CSF011A
     C                   EVAL      @DDPRTN = *BLANKS                                         CSF011A
     C                   EVAL      @DDRESN = *BLANKS                                         CSF011A
     C                   EVAL      @DDRENM = *BLANKS                                         CSF011A
     C                   EVAL      @DDRETN = *BLANKS                                         CSF011A
     C                   EVAL      @DDFRSN = *BLANKS                                         CSF011A
     C                   EVAL      @DDFRNM = *BLANKS                                         CSF011A
     C                   EVAL      @DDFCRT = *BLANKS                                         CSF011A
     C                   EVAL      @DDCOSN = *BLANKS                                         CSF011A
     C                   EVAL      @DDCONM = *BLANKS                                         CSF011A
     C                   EVAL      @DDCOTN = *BLANKS                                         CSF011A
                                                                                             CSF011A
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        @DDCUST <> *BLANKS                                        CSF011A
     C                   EVAL      WCustomer = @DDCUST                                       CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @DDCRSN = BBCSSN                                          CSF011A
     C                   EVAL      @DDCRNM = BBCRNM                                          CSF011A
     C                   EVAL      @DDCRTN = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Purchase From                                                                       CSF011A
                                                                                             CSF011A
     C                   IF        @DDPFRM <> *BLANKS                                        CSF011A
     C                   EVAL      WCustomer = @DDPFRM                                       CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @DDPRSN = BBCSSN                                          CSF011A
     C                   EVAL      @DDPRNM = BBCRNM                                          CSF011A
     C                   EVAL      @DDPRTN = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Receiver of Guarantee                                                               CSF011A
                                                                                             CSF011A
     C                   IF        @DDRECE <> *BLANKS                                        CSF011A
     C                   EVAL      WCustomer = @DDRECE                                       CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @DDRESN = BBCSSN                                          CSF011A
     C                   EVAL      @DDRENM = BBCRNM                                          CSF011A
     C                   EVAL      @DDRETN = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Facility Customer                                                                   CSF011A
                                                                                             CSF011A
     C                   IF        @DDFCUS <> *BLANKS                                        CSF011A
     C                   EVAL      WCustomer = @DDFCUS                                       CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @DDFRSN = BBCSSN                                          CSF011A
     C                   EVAL      @DDFRNM = BBCRNM                                          CSF011A
     C                   EVAL      @DDFCRT = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Customer Confirmation                                                               CSF011A
                                                                                             CSF011A
     C                   IF        @DDCOCU <> *BLANKS                                        CSF011A
     C                   EVAL      WCustomer = @DDCOCU                                       CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @DDCOSN = BBCSSN                                          CSF011A
     C                   EVAL      @DDCONM = BBCRNM                                          CSF011A
     C                   EVAL      @DDCOTN = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                                CSF011
      **********************************************************************
      /EJECT                                                                                 CSF011A
      **********************************************************************                 CSF011A
      *                                                                    *                 CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                                   *                 CSF011A
      *                                                                    *                 CSF011A
      **********************************************************************                 CSF011A
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
      **********************************************************************                 CSF011A
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
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDACTN_In         1                         BUG3721
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD044880
     C/COPY WNCPYSRC,LECLIPYC01
 
      ** Determine if BOE Yellow Book is installed                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
                                                                                             BUG3721
      ** Access Bank details                                                                 BUG3721
                                                                                             BUG3721
     C                   CALLB     'AOBANKR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD             7                         BUG3721
     C                   PARM      '*FIRST '     @OPTN             7                         BUG3721
     C     SDBANK        PARM      SDBANK        DSFDY                                       BUG3721
                                                                                             BUG3721
      ** Database error                                                                      BUG3721
     C     @RTCD         IFNE      *BLANKS                                                   BUG3721
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************ BUG3721
     C                   MOVEL     '901'         DBASE                          * DBERR 901* BUG3721
     C                   MOVEL     @OPTN         DBKEY                          ************ BUG3721
     C                   EXSR      *PSSR                                                     BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Determine if Flat Rate Personal Loans (Rule of 78s) is installed                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           CLE028            1                         BUG3721
     C                   CALLB     'AOSARDR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3721
     C                   PARM      'CLE028'      @SARD             6                         BUG3721
                                                                                             BUG3721
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3721
     C                   MOVE      'Y'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3721
     C                   MOVE      'N'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
      ** Database error                                                                      BUG3721
                                                                                             BUG3721
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3721
     C                   MOVEL     '007'         DBASE                          * DBERR 007 *BUG3721
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3721
     C                   EXSR      *PSSR                                                     BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      ** Determine if CLE031 (Lending Enhancements)                                           CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      ** Determine if CLE034 is on                                                            CLE034
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
     C     @RTCD         IFEQ      '*NRF'                                                     CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
                                                                                              CLE034
      ** Database error                                                                       CLE034
                                                                                              CLE034
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE034
     C                   MOVEL     '010'         DBASE                          * DBERR 010 * CLE034
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE106
      ** Determine if CLE106 (Syndications Manager)                                           CLE106
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
     C     @RTCD         IFEQ      '*NRF'                                                     CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** Database error                                                                       CLE106
      *                                                                                       CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE106
     C                   MOVEL     '009'         DBASE                          * DBERR 009 * CLE106
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Key Fields for Facility File                                                         CLE031
     C     CHKFAC        KLIST                                                                CLE031
     C                   KFLD                    KCNUM                                        CLE031
     C                   KFLD                    KFACT                                        CLE031
     C                   KFLD                    KFCNO                                        CLE031
     C                   KFLD                    KRCTP                                        CLE031
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LECLIPM01
      *                                                                                      LLN022A
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Determine if ULX004 is switched on                                                   CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD   <> *BLANK AND                                      CER001
     C                             @RTCD   <> '*NRF'                                          CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '001'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
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
     C                             OR (*INU7 = *ON And *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 1                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = 'LECLIPR'                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      **********************************************************************
     C     LECLIPRED     BEGSR
      *
     C                   CALLB     'LECLIPRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM      DDLNRF_In     DDLNRF            6
      *
      * Front Office ID
     C                   PARM                    DDFRTN           20
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @LNRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
     C     LECLIPRTV     BEGSR
 
     C                   CALLB     'LECLIPRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Customer Loan Reference
     C                   PARM                    DDLNRF
      *
      ** Loan type/sub type
     C                   PARM                    DDLTYP            2
     C                   PARM                    DDSUTP            2
     C                   PARM                    DDCLAS            4                          CLE042
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
 
      * OUTPUTS
 
      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      * Loan Type
     C                   PARM                    LoanType          4
 
      * (Current) Customer loan CL in file format
     C                   PARM                    CrLnFilFmtCL
      * (Current) Customer loan CK in file format
     C                   PARM                    CrLnFilFmtCK
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Loan Reference
     C                   PARM                    DDLNRFOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr                     BUG826
     C                   PARM                    WMsgIdArr                      BUG826
     C                   PARM                    WMsgDtaArr                     BUG826
     C                   PARM                    WIdx                           BUG826
     C                   PARM                    @DDFPTF                                      245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPYC02
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * LECLIP2RV - LECLIP Retrieve Extension                         *                       CER001
      *****************************************************************                       CER001
     C     LECLIP2RV     BEGSR                                                                CER001
      *                                                                                       CER001
      ** If ULX004 switchable is on and non-parts sold loan                                   CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y' And                                          CER001
     C                             (LPTYP <> 66 And LPTYP <> 67 And                           CER001
     C                              LPTYP <> 69 And LPTYP <> 72)                              CER001
     C                   MOVEL     DDLNRF_In     PLoanNum                                     CER001
     C                   CALLB     'LECLIP2RV'                                                CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    APFOTranID                                   CER001
     C                   PARM                    PLoanNum                                     CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
      * PUTD@1 - Put a loan on the first details screen               *
      *****************************************************************
     C     PUTD@1        BEGSR
                                                                                             BUG3721
      ** Setup work field                                                                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           WPRCS2            1                         BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     LRECI         ANDEQ     'D'                                                       BUG3721
     C     DDACTN        ANDEQ     'A'                                                       BUG3721
     C     LPTYP         ANDEQ     80                                                        BUG3721
     C     LVDAT         ANDLT     BJRDNB                                                    BUG3721
     C     LORED         ANDNE     BJRDNB                                                    BUG3721
     C                   MOVE      'Y'           WPRCS2                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      *
      ***  Call program to fill screen fields with data from CLOANCL and CLOANCK
      *
     C                   CALLB     'LECLIP1CT'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format CL
      *
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Outputs
      *
      ***  Loan in screen format
      *
     C                   PARM                    CrLnScnFmt1
      *
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@2 - Put a loan on the second details screen              *
      *****************************************************************
     C     PUTD@2        BEGSR
      *
      ***  Call program to fill screen fields with data from CLOANCL and CLOANCK
      *
     C                   CALLB     'LECLIP2CT'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    CrLnFilFmtCK
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      ***  Outputs
      *
      ***  Loan in screen format
      *
     C                   PARM                    CrLnScnFmt2
      *
      ** Initialise to work fields to be held.                                             AR1075452
      *                                                                                    AR1075452
     C                   EVAL      WWLNR2 = @DDLNR2                                        AR1075452
     C                   EVAL      WWACT2 = @DDACT2                                        AR1075452
     C                   EVAL      WWLST2 = @DDLST2                                        AR1075452
     C                   EVAL      WWBRTT = @DDBRTT                                        AR1075452
     C                   EVAL      WWCHIN = @DDCHIN                                        AR1075452
     C                   EVAL      WWRTSP = @DDRTSP                                        AR1075452
     C                   EVAL      WWSPIN = @DDSPIN                                        AR1075452
     C                   EVAL      WWNIDT = @DDNIDT                                        AR1075452
     C                   EVAL      WWIPFR = @DDIPFR                                        AR1075452
     C                   EVAL      WWIFDY = @DDIFDY                                        AR1075452
     C                   EVAL      WWINTR = @DDINTR                                         MD025521
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@3 - Put a loan on the third details screen               *
      *****************************************************************
     C     PUTD@3        BEGSR
      *
      ***  Call program to fill screen fields with data from CLOANCL and CLOANCK
      *
     C                   CALLB     'LECLIP3CT'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Outputs
      *
      ***  Loan in screen format
      *
     C                   PARM                    CrLnScnFmt3
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@4 - Put a loan on the fourth details screen              *
      *****************************************************************
     C     PUTD@4        BEGSR
      *
      ***  Call program to fill screen fields with data from CLOANCL and CLOANCK
      *
     C                   CALLB     'LECLIP4CT'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Outputs
      *
      ***  Loan in screen format
      *
     C                   PARM                    CrLnScnFmt4
      *                                                                                     MD037909
     C                   PARM                    CrLnScnFmt6                                MD037909
     C                   PARM                    CrLnScnFmt7                                MD037909
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
     C     ZASETINCVT    BEGSR
      *
      ***  Set up payment instructions from loan
      *
     C                   MOVEL     ClipFilPAY    FLPAY
     C                   MOVEL     LCVMR         FLCVMR
     C                   MOVEL     LSCCY         FLPSCY
     C                   MOVEL     LICCY         FLIC72
     C                   MOVEL     LPSTM         FLPSTM                                       TCA094
     C                   MOVEL     LPONS         FLPONS                                       TCA094
      *
      * If not a Part Sold, pay branch is our start date branch
      * If Part Sold, pay branch is our maturity date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      LOSDB         FLPOBR
     C                   ELSE
     C                   MOVE      LOMDB         FLPOBR
     C                   ENDIF
 
      ***  Set up receive instructions from loan
 
     C                   MOVEL     ClipFilREC    FLREC
     C                   MOVEL     LSCCY         FLRSCY
     C                   MOVEL     LRSTM         FLRSTM                                       TCA094
     C                   MOVEL     LRONS         FLRONS                                       TCA094
      *
      * If not a Part Sold, receive branch is our maturity date branch
      * If Part Sold, receive branch is our start date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      LOMDB         FLROBR
     C                   ELSE
     C                   MOVE      LOSDB         FLROBR
     C                   ENDIF
      *                                                                                       CLE031
     C                   Z-ADD     LREXR         FLREXR                                       CLE031
     C                   Z-ADD     LPEXR         FLPEXR                                       CLE031
     C                   MOVE      LREXI         FLREXI                                       CLE031
     C                   MOVE      LPEXI         FLPEXI                                       CLE031
     C                   MOVE      LSCCY         FLRSCY                                       CLE031
     C                   MOVE      LPSCY         FLPSCY                                       CLE031
 
      *
      ***  Convert settlement details from file to screen format
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      *
      ***  File Payment Settlement Instruction
      *
     C                   PARM                    ##PAYF
      *
      ***  File Receipt Settlement Instruction
      *
     C                   PARM                    ##RECF
      *
      ***  File FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Outputs
      ***  Screen Payment Settlement Instruction
      *
     C                   PARM      *BLANK        ##PAYS
      *
      ***  Screen Receipt Settlement Instruction
      *
     C                   PARM      *BLANK        ##RECS
      *
      ***  Screen FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        ##FRIS
                                                                                             CSF011A
     C                   PARM      @DDCURR       #TRCCY                                      CSF011A
     C                   PARM      @DDCURR       #TPCCY                                      CSF011A
      *
      *
     C                   ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *  LECLIP5CT - LECLIP Convert Module Extension                  *                       CER001
      *****************************************************************                       CER001
     C     LECLIP5CT     BEGSR                                                                CER001
      *                                                                                       CER001
      ** If ULX004 switchable is on and non-parts sold loan                                   CER001
      *                                                                                       CER001
     C                   IF         LPTYP <> 66 And LPTYP <> 67 And                           CER001
     C                              LPTYP <> 69 And LPTYP <> 72                               CER001
     C                   CALLB     'LECLIP5CT'                                                CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
     C                   PARM                    SDBANK                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    @DDCURR                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      *****************************************************************                       CLE031
      * LEFCLTY - Retrieve Facility details                            *                      CLE031
      *****************************************************************                       CLE031
     C     LEFCLTY       BEGSR                                                                CLE031
     C                   EVAL      KRCTP = 'A'                                                CLE031
     C                   EVAL      KCNUM = LFCUS                                              CLE031
     C                   EVAL      KFACT = LFTYP                                              CLE031
     C                   EVAL      KFCNO = LFSEQ                                              CLE031
     C     CHKFAC        CHAIN     FCLTY                                                      CLE031
     C                   EVAL      WKMCCY = FCMCCY                                            CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      ** Program, module and procedure names for database error processing.                  BUG3721
      ** =================================================================                   BUG3721
      ** The following /COPY sets these values, and also defines LDA as                      BUG3721
      ** an external data area                                                               BUG3721
      ********************************************************************                   BUG3721
     C/COPY ZACPYSRC,PSSR_ILENE                                                              BUG3721
     C                   EVAL      APIRETC = '0'                                             BUG3721
     C                   RETURN                                                              BUG3721
     C                   ENDSR                                                               BUG3721
      ********************************************************************                   BUG3721
**  CPY@
(c) Finastra International Limited 2003
