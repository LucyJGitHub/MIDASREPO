     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans screen 3 validations')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP3VL -  Customer Loans screen 3 validations             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. AR882700           Date 07Jun13               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13843           Date 02May07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL058             Date 30Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG8048            Date 15Aug05               *
      *                 BUG7383            Date 12Sep05               *
      *                 CAP086             Date 21Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6258            Date 29Mar05               *
      *                 BUG5863            Date 14Feb04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG4351            Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG153             Date 29Mar04               *
      *                 TDA023             Date 24Mar04               *
      *                 225959             Date 23Mar04               *
      *                 225386             Date 02Mar04               *
      *                 BUG491             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 224261             Date 09Jan04               *
      *                 CAP084             Date 11Oct02               *
      *                 CAP074  *CREATE    Date 29May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  AR882700 - LEC06A on MESSAGEWAIT on A1 TEST SYSTEM. Insert   *
      *             additional validation in Facility Currency        *
      *             Exchange Rate. (Child: AR882701)                  *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CRE026 - Consumer Banking                                    *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CGL058 - Default Branch Code                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager.                               *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  BUG8048- Setup valid file values for yield curve and forward *
      *           yield curve if they have been entered as blank      *
      *  BUG7383- Use very long data structure for AOCUSTR0           *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6258 - Unable to amend a loan with funding information    *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collaterised Lending (Recompile)  *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028).   *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1538- Should only validate Base Ccy Exchange Rate during  *
      *           input of loan                                       *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  225959 - Missing CAS00x changes                             *
      *  225386 - Receiver of the Guarantee wrong on file (Bug1177)   *
      *  BUG491 - Funding rate/spread is not validated                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224261 - Funding spread/rate still being shown in certain    *
      *           conditions                                          *
      *  CAP084 - Midas Plus API development                          *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ***  FILES
      *    =====
      *
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIP3V01
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ExtData       E DS                  EXTNAME(LECLEXPD)
      ***  LE (CLIP) Extra Data - File (D/B) format
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  External DS for customer details
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      ***  External DS for account officer details
      *
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      ***  External DS for local industry codes details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ***  External DS for branch details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for module details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ***  External DS for country codes details
      *
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ***  External DS for book codes details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ***  Portfolio management customer details
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ***  Portfolio ICD
      *
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
      ***  Alternate names and addresses
      *
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      ***  Profit centres
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  Currency details
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  Loan type/subtype details
      *
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      ***  Profit centre accounting ICD
      *                                                                                       225959
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)                                  225959
     D  FYLDC        E                     EXTFLD(FSYLDC)                                     225959
      ***  Yield Curve                                                                        225959
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BUG7383
     D***  Third DS for access programs, very long data structure                            BUG7383
     D*                                                                                      BUG7383
     D ValidLnCl     E DS                  EXTNAME(LEVCLILPD)
      ***  Valid Loans CL layout -> CLOANCL
     D                                     PREFIX(C)
      *
     D ValidLnCk     E DS                  EXTNAME(LEVCLIKPD)
      ***  Valid Loans CK layout -> CLOANCK
     D                                     PREFIX(C)
     D  CK_CLRECI    E                     EXTFLD(CLRECI)
     D  CK_CLLNRF    E                     EXTFLD(CLLNRF)
     D  CK_CLRCDT    E                     EXTFLD(CLRCDT)
     D  CK_CLMRIN    E                     EXTFLD(CLMRIN)
     D  CK_CLORED    E                     EXTFLD(CLORED)
     D  CK_CLLCD     E                     EXTFLD(CLLCD)
     D  CK_CLCHTP    E                     EXTFLD(CLCHTP)
     D  CK_CLTNLU    E                     EXTFLD(CLTNLU)
     D  CK_CLFRNT    E                     EXTFLD(CLFRNT)
     D  CK_CLAFRT    E                     EXTFLD(CLAFRT)
     D  CK_CLREPA    E                     EXTFLD(CLREPA)
     D  CK_CLTMES    E                     EXTFLD(CLTMES)
      *
     D TranInScr3    E DS                  EXTNAME(LECLI3PD)
      ***  Incoming Transaction
      *
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL) PREFIX(@@)
      * (Current) Loans record CL in file Format

      *
     D OKFlagsDS     E DS                  EXTNAME(LEECLI3PD)
      ***  Flags to indicate whether transaction fields are valid
      *
                                                                                              CAP086
      ** Interface Data Format Definition File format                                         CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
     D  TransData      DS           500
      ***  Shared data
      *
     D  WLNPT                  1      2  0
     D  W72TP                  3      4
     D  BASER                  5     15  7
     D  WSVBX                 16     28  8
     D  WBMIN                 29     29
     D  WSVDD                 30     34  0
     D  WSVVD                 35     39  0
     D  WSVAM                 40     52  0
     D  WSVRS                 53     63  7
     D**FCUSM***              64     69  0                                                    CSD027
     D  FCUSM                 64     69A                                                      CSD027
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D  LINDM                 94     96
     D  PRFCM                 97    100
     D  ACOFM                101    102
     D  FCCYM                103    105
     D  FCLBM                106    108
     D  MCRAM                109    109
     D  PTYPM                110    111  0
     D  RLDTM                112    116  0
     D  NBRAM                117    118  0
     D  NCASM                119    119  0
     D  NCHIM                120    120
     D  NCCYM                121    123
     D  NFCEM                124    136  8
     D  NFMDM                137    137
     D  NBCEM                138    150  8
     D  NBMDM                151    151
     D  CNUMM                152    157
     D  BRCAM                158    160
     D  CCYM                 161    163
     D  CPAMM                164    176  0
     D  DDATM                177    181  0
     D  VDATM                182    186  0
     D  MDATM                187    191  0
     D  PSAMM                192    204  0
     D  WSVFX                205    217  8
     D  WFMIN                218    218
     D  FCCYF                219    221
     D  WLPFI                222    222
     D  WPASI                223    223
     D**WPTFC***             224    229  0                                                    CSD027
     D  WPTFC                224    229A                                                      CSD027
     D  WPTFT                230    232  0
     D  WPTFN                233    234  0
     D  WACEI                235    235
     D  WCBLI                236    236
     D  WORMD                237    241  0
     D  WORTI                242    254  0
     D  WSVMG                255    261  5
     D  WSVWT                262    272  7
     D  WOSDB                273    275
     D  WOMDB                276    278
     D  W#OIDT               279    283  0
     D  WTOTI                284    296  0
     D  WPTFR                297    300
     D  WFSRP                301    311  7
     D  WSVFA                312    324  0
     D  NBDPM                325    325  0
     D  WSVCN                326    331
     D  WRISP                332    332
     D  NYET                 333    333
     D  WFLAG                334    334
     D  WCDPL                335    335  0
     D  WCDPF                336    336  0
     D  WSVTX                337    338  0
     D  WTXND                339    340  0
     D  S#ICBS               341    341  0
     D  WSVRAM               342    354  0
     D  WSVRAP               355    367  0
     D  W@FCRA               368    382
     D  W@RAMT               383    397
     D  W#CCY                398    400
     D  W#FCY                401    403
     D  WSVAM2               404    416  0
     D  WSVIN                417    417
     D  WSVRT                418    430  8
     D  W@NRPD               431    435  0
     D  ACOFF                436    437
     D  SYINF                438    438
     D  WAGENT               439    444
     D**ANUM****             445    450  0                                                    CSD027
     D**CNUMF***             451    456  0                                                    CSD027
     D**PMFC****             457    462  0                                                    CLE106
     D**W#PMFC**             457    462  0                                             CLE106 CSD027
     D  ANUM                 445    450A                                                      CSD027
     D  CNUMF                451    456A                                                      CSD027
     D  W#PMFC               457    462A                                                      CSD027
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D  WLIND                471    473
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721
      *
     D  DataOldRcd     DS           500
      ***  Fields used in setting confirmation indicators (old record)
      *
     D  OMDAT                  1      5  0
     D  ONIDT                  6     10  0
     D  ONRPD                 11     15  0
     D  OIFDY                 16     17  0
     D  OIPFR                 18     18
     D  ORDYN                 19     20  0
     D  ORFRQ                 21     21
     D  ORAMT                 22     34  0
     D  OSDST                 35     36  0
     D  STNOSX                37     38
     D***OOSDA**               37     48                                                      CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  OTSTN                 49     58
     D  OFACO                 59     68
     D  OSPI1                 69     98
     D  OSPI2                 99    128
     D  OSPI3                129    158
     D  OSPI                  69    158
     D  OMDST                159    160  0
     D  MTNOSX               161    162
     D***OOMDA**              161    172                                                      CGL029
     D  QQOMD1               161    172                                                       CGL029
     D  OTMAN                173    182
     D  MATYX                159    182
     D  OINTR                183    193  7
     D  ORLDT                194    198  0
     D  ORLFQ                199    199
     D  ORLDY                200    201  0
     D  OOSDA                202    219                                                       CGL029
     D  OOMDA                220    237                                                       CGL029
     D  LINK1                  6     34
     D  CONF2                 35    158
     D  LINK2                183    201
      *
     D  DataNewRcd     DS           500
      ***  Fields used in setting confirmation indicators (new record)
      *
     D  WSVMD                  1      5  0
     D  WSVID                  6     10  0
     D  WSVRP                 11     15  0
     D  WIFDY                 16     17  0
     D  SIPFR                 18     18
     D  WRDYN                 19     20  0
     D  SRFRQ                 21     21
     D  WSVRA                 22     34  0
     D  WSDST                 35     36  0
     D  STNOS                 37     38
     D***WOSDA**               37     48                                                      CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  WTSTN                 49     58
     D  WFACO                 59     68
     D  DDSPI1                69     98
     D  DDSPI2                99    128
     D  DDSPI3               129    158
     D  DDSPI                 69    158
     D  WMDST                159    160  0
     D  MTNOS                161    162
     D***WOMDA**              161    172                                                      CGL029
     D  QQOMD2               161    172                                                       CGL029
     D  WTMAN                173    182
     D  WREC                 159    182
     D  WINTT                183    193  7
     D  WSVRD                194    198  0
     D  SRLFQ                199    199
     D  WRLDY                200    201  0
     D  WOSDA                202    219                                                       CGL029
     D  WOMDA                220    237                                                       CGL029
     D  CONFS1                 1     34
     D  LINKS1                 6     34
     D  CONFS2                35    158
     D  LINKS2               183    201
      *
     D I@PARM          DS           256
      ***  Input parameters on call to AOPLCSR1
      *
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
     D O@PARM          DS           256
      ***  Output parameters on call to AOPLCSR1
      *
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
                                                                                              CLE106
     D CLE106          S              1                                                       CLE106
     D CLE036          S              1                                                    BUG10391R
                                                                                              CLE106
      ***  Index for arrays of of warning message ids etc
      *
      ** +--------------------------------------+
      ** ¦ Rename fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIP3V02
      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LECLIP3V03

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
      *
      ***  Validation for screen details 1
      *    ===============================
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      /COPY WNCPYSRC,LECLIP3V04
      *                                                                                     AR804863
      ** Skip validation process if action is reject.                                       AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   EXSR      SRRSFD                                                   AR804863
     C                   RETURN                                                             AR804863
     C                   ENDIF                                                              AR804863
      *
      ***  Validate account officer
      *
     C                   EXSR      SRACOF
      *
      /COPY WNCPYSRC,LECLIP3V05
      *
      ***  Validate industry (for loans and parts purchased)
      *
     C                   EXSR      SRLIND
      *
      /COPY WNCPYSRC,LECLIP3V06
      *
      ***  Validate fees
      *
     C                   EXSR      SRFEEI
      *
      /COPY WNCPYSRC,LECLIP3V07
      *
      ***  Validate originating branch
      *
     C                   EXSR      SRORBR
      *
      /COPY WNCPYSRC,LECLIP3V08
      *
      ***  Validate country of risk
      *
     C                   EXSR      SRCRSK
      *
      /COPY WNCPYSRC,LECLIP3V09
      *
      ***  Validate documents
      *
     C                   EXSR      SRDOCI
      *
      /COPY WNCPYSRC,LECLIP3V10
      *
      ***  Validate book code
      *
     C                   EXSR      SRBOKC
      *
      /COPY WNCPYSRC,LECLIP3V11
      *
      ***  Validate FRB code
      *
     C                   EXSR      SRFRBC
      *
      /COPY WNCPYSRC,LECLIP3V12
      *
      ***  Validate secured
      *
     C                   EXSR      SRSECI
      *
      /COPY WNCPYSRC,LECLIP3V13
      *
      ***  Validate account sequence number
      *
     C                   EXSR      SRACSQ
      *
      /COPY WNCPYSRC,LECLIP3V14
      *
      ***  Validate portfolio reference
      *
     C                   EXSR      SRPTFR
      *
      /COPY WNCPYSRC,LECLIP3V15
      *
      ***  Validate alternate name and address
      *
     C                   EXSR      SRNACD
      *
      /COPY WNCPYSRC,LECLIP3V16
      *
      ***  Validate profit center
      *
     C                   EXSR      SRPRFC
      *
      /COPY WNCPYSRC,LECLIP3V17
      *
      *
      /COPY WNCPYSRC,LECLIP3V18
      *
      *
      /COPY WNCPYSRC,LECLIP3V19
      *
      ***  Validate facility currency and base currency
      ***  exchange rates and indicators
      *
     C                   EXSR      SREXCH
      *
      /COPY WNCPYSRC,LECLIP3V20
      *
      ***  Validate guarantee receiver
      *
     C                   EXSR      SRRECE
      *
      /COPY WNCPYSRC,LECLIP3V21
      *
      ***  Validate customer confirmation
      *
     C                   EXSR      SRCOCU
      *
      /COPY WNCPYSRC,LECLIP3V22
      *
      ***  Validate funding details
      *
     C                   EXSR      SRFUDT
      *
      /COPY WNCPYSRC,LECLIP3V23
      *                                                                         225959
      ***  Validate yield curve                                                 225959
      *                                                                         225959
     C     CAS001        IFEQ      'Y'                                          225959
     C                   EXSR      SRYLDC                                       225959
     C                   ENDIF                                                  225959
      *
      ***  Move the screen fields to valid file
      *
     C                   EXSR      SRMVFLD
      *
      /COPY WNCPYSRC,LECLIP3V26
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      /COPY WNCPYSRC,LECLIP3V24
      *
      ***  Save the loan reference for warning
      *
     C                   MOVEL     DDLNR3        SaveDDLNR3        6
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRACOF - Validate account officer                            *
      *****************************************************************
     C     SRACOF        BEGSR
      *
      ***  Defaults to account officer of related loan for parts sold
      ***  Defaults to account officer of facility if not parts sold
      *
     C     DDACOF        IFEQ      *BLANKS
     C     *IN83         IFEQ      '0'
     C                   MOVE      ACOFF         DDACOF
     C                   ELSE
     C                   MOVE      ACOFM         DDACOF
     C                   ENDIF
      *
      ***  Loans entered against a syndicated facility
      *
     C     SYINF         IFEQ      'Y'
     C     *IN83         IFEQ      '0'
     C                   MOVE      WAGENT        WANUM             6
     C                   ELSE
     C                   MOVE      ANUM          WANUM
     C                   ENDIF
     C                   MOVE      CCLCNUM       @CUST
     C     WANUM         IFEQ      W#SYCU
     C                   MOVE      *BLANKS       @CUST
     C                   MOVE      WANUM         @CUST
      *
      ***  Default agent customer account officer into primary loan and
      ***  part sold against the primary loan. When loan entered is an
      ***  internal parts purchased or part sold against an IPP, default
      ***  account officer of the facility customer.
      *
     C                   SELECT
     C     *IN82         WHENEQ    '1'
     C***********        MOVE      PMFC          @CUST                                        CLE106
     C                   MOVE      W#PMFC        @CUST                                        CLE106
     C     *IN83         WHENEQ    '1'
     C     WPTYP         ANDEQ     64
     C     *IN83         OREQ      '1'
     C     WPTYP         ANDEQ     65
     C     *IN83         OREQ      '1'
     C     WPTYP         ANDEQ     68
     C     CLE005        ANDEQ     'Y'
     C     *IN83         OREQ      '1'
     C     WPTYP         ANDEQ     71
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      CNUMF         @CUST
     C                   ENDSL
      *
     C**********         CALLB     'AOCUSTR0'                                                BUG7383
     C                   CALLB     'AOCUSTR1'                                                BUG7383
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C*****SDCUST        PARM      SDCUST        DSSDY                                       BUG7383
     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG7383
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @CUST         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      BBACOC        DDACOF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      DDACOF        @ACOC
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @ACOC             2
     C     SDACOF        PARM      SDACOF        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDACOFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACOF'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0171'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDACOF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      AZACOC        DDACOF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACOFOK      IFNE      'N'
     C                   MOVEL     DDACOF        CCLACOF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRLIND - Validate industry (for loans and parts purchased)   *
      *****************************************************************
     C     SRLIND        BEGSR
      *
      ***  Defaults to local industry code of customer
      *
     C     *IN83         IFEQ      '0'
     C     DDLIND        IFEQ      *BLANKS
     C                   MOVE      WLIND         DDLIND
     C                   ELSE
      *
     C                   MOVE      DDLIND        @LICD
     C                   CALL      'AOINDSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LICD             3
     C     SDINDS        PARM      SDINDS        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDLINDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLIND'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0166'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDLIND
     C                   ENDIF
     C                   ELSE
     C                   MOVE      AOLICD        DDLIND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDLINDOK      IFNE      'N'
     C**********         MOVE      DDLIND        CCLLIND                                      CER020
     C                   MOVE      DDLIND        CCLLOIC                                      CER020
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFEEI - Validate fees                                       *
      *****************************************************************
     C     SRFEEI        BEGSR
      *
     C     DDFEEI        IFEQ      *BLANK
     C                   MOVE      'N'           DDFEEI
     C                   ELSE
     C     DDFEEI        IFNE      'Y'
     C     DDFEEI        ANDNE     'N'
     C                   MOVE      'N'           DDFEEIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFEEI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0164'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDFEEI        IFEQ      'Y'
     C                   BITON     '2'           CCLRELI
     C                   ELSE
     C                   BITOFF    '2'           CCLRELI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRORBR - Validate originating branch                         *
      *****************************************************************
     C     SRORBR        BEGSR
      *
      ***  Validated only if multi-branching and originating branch
      ***  are being used (for loans and parts purchased)
      *
     C     *IN83         IFEQ      '0'
     C     BKOBRU        ANDEQ     'Y'
     C     BGMBIN        ANDEQ     'Y'
      *                                                                                       CGL058
      ** When CGL058 is on in Insert mode, the branch has already been                        CGL058
      ** defaulted and stored in the corresponding valid file field by                        CGL058
      ** LECLIP1VL. Decide here if the default is to be used:                                 CGL058
      *                                                                                       CGL058
     C                   IF            CGL058  = 'Y'                                          CGL058
     C                             AND DDORBR  = *Blanks                                      CGL058
     C                             AND CCLCHTP = 'I'                                          CGL058
     C                   EVAL      DDORBR = CCLORBR                                           CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                       CGL058
     C     DDORBR        IFEQ      *BLANKS
     C                   MOVE      CCLBRCA       DDORBR
     C                   ENDIF
     C                   MOVE      DDORBR        @BRCA
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0311'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDORBR
     C                   ENDIF
     C                   ELSE
     C                   MOVE      A8BRCD        DDORBR
     C                   ENDIF
      *
      ***  Validate against user
      *
     C     BKOBUV        IFEQ      'Y'
     C                   MOVE      DDORBR        @ZBR              3
      *
     C     RespMode      IFNE      'S'
     C                   CALL      'ZBOBU'
     C                   PARM                    @ZBR
     C                   PARM                    PSUser
     C                   PARM                    @ERR              1 0
     C                   ELSE
     C                   CALL      'ZVOBU'
     C                   PARM                    @ZBR
     C                   PARM                    @ERR
     C                   ENDIF
      *
     C                   SELECT
     C     @ERR          WHENEQ    1
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0305'     MsgIDXAr(Idx)
     C     @ERR          WHENEQ    2
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0306'     MsgIDXAr(Idx)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C     DDORBROK      IFNE      'N'
     C                   MOVEL     DDORBR        CCLORBR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCRSK - Validate country of risk                            *
      *           (for loans and parts purchased)                     *
      *****************************************************************
     C     SRCRSK        BEGSR
      *
      ***  Defaults to country of facility
      *
     C     *IN83         IFEQ      '0'
     C     DDCRSK        IFEQ      *BLANKS
     C                   MOVE      CRSKF         DDCRSK
      *
     C                   ELSE
     C                   MOVE      DDCRSK        @CNCD
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNCD             2
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCRSKOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRSK'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0167'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDCRSK
     C                   ENDIF
     C                   ELSE
     C                   MOVE      A4CNCD        DDCRSK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDCRSKOK      IFNE      'N'
     C                   MOVEL     DDCRSK        CCLCRSK
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRDOCI - Validate documents                                  *
      *****************************************************************
     C     SRDOCI        BEGSR
      *
     C     DDDOCI        IFEQ      *BLANK
     C                   MOVE      'N'           DDDOCI
     C                   ELSE
     C     DDDOCI        IFNE      'Y'
     C     DDDOCI        ANDNE     'N'
     C                   MOVE      'N'           DDDOCIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDOCI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0163'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDDOCI        IFEQ      'Y'
     C                   BITON     '1'           CCLRELI
     C                   ELSE
     C                   BITOFF    '1'           CCLRELI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRBOKC - Validate book code                                  *
      *****************************************************************
     C     SRBOKC        BEGSR
      *
     C     DDBOKC        IFEQ      *BLANKS
     C                   MOVE      BPDBKC        DDBOKC
     C                   ELSE
     C                   MOVE      DDBOKC        @BKCD             2
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BKCD
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBOKCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBOKC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0292'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDBOKC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      BDBKCD        DDBOKC
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBOKCOK      IFNE      'N'
     C                   MOVEL     DDBOKC        CCLBOKC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFRBC - Validate FRB code                                   *
      *****************************************************************
     C     SRFRBC        BEGSR
      *
     C                   MOVEL     DDFRBC        WNUM6             6 0
     C                   MOVEL     WNUM6         WALF5             5
     C     DDFRBC        IFNE      *BLANKS
     C     DDFRBC        IFNE      WALF5
     C     WNUM6         OREQ      *ZEROS
     C                   MOVE      'N'           DDFRBCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFRBC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0165'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDFRBCOK      IFNE      'N'
     C                   MOVE      DDFRBC        CCLFRBC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSECI - Validate secured                                    *
      *****************************************************************
     C     SRSECI        BEGSR
      *
     C     DDSECI        IFEQ      *BLANK
     C                   MOVE      'N'           DDSECI
     C                   ELSE
     C     DDSECI        IFNE      'Y'
     C     DDSECI        ANDNE     'N'
     C                   MOVE      'N'           DDSECIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSECI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0162'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDSECI        IFEQ      'Y'
     C                   BITON     '0'           CCLRELI
     C                   ELSE
     C                   BITOFF    '0'           CCLRELI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRACSQ - Validate account sequence number                    *
      *****************************************************************
     C     SRACSQ        BEGSR
      *
     C     DDACSQ        IFEQ      *BLANKS
     C     DDACSQ        OREQ      '00'
     C                   MOVE      '01'          DDACSQ
     C                   ELSE
     C                   MOVEL     DDACSQ        WNUM3             3 0
     C                   MOVEL     WNUM3         WALF2             2
     C     DDACSQ        IFNE      WALF2
     C     WNUM3         OREQ      *ZEROS
     C                   MOVE      'N'           DDACSQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACSQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0137'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACSQOK      IFNE      'N'
     C                   MOVEL     DDACSQ        CCLLASQ
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRPTFR - Validate portfolio reference                        *
      *****************************************************************
     C     SRPTFR        BEGSR
      *
     C                   MOVE      'N'           WPTCS             1
     C     BGPFMG        IFEQ      'Y'
     C     *IN82         ANDEQ     '0'
     C     *IN83         ANDEQ     '0'
     C     BGN4ST        ANDNE     'Y'
      *
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     WSVCN         I#CUST
     C                   MOVEL     CCLBRCA       I#BRCA
     C                   MOVEL     DDBOKC        I#BOOK
     C                   MOVEL     DDPTFR        I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ***  No error, and book code/portfolio reference are blank,
      ***  set to default values from the file
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           WPTCS
     C     FCPORS        IFEQ      'B'
     C     DDBOKC        ANDEQ     *BLANKS
     C                   MOVE      O#BOOK        DDBOKC
     C                   ENDIF
     C     DDPTFR        IFEQ      *BLANKS
     C                   MOVE      O#PTFR        DDPTFR
     C                   ENDIF
      *
      ***  Check if reference is a live record, or if not, check
      ***  if it refers to the '9997' reference
      *
     C                   MOVEL     QBCUST        WPCNO
     C                   MOVEL     DDPTFR        WPTFR
     C     WKPOR         CHAIN     PMPORTPD                           89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     PNRECI        ANDNE     'D'
     C     DDPTFR        IFNE      FCR997
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0490'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  if existing, send warning if portfolio is closed
      *
     C                   ELSE
     C     PNDPCL        IFGT      *ZEROS
     C*****WE023         IFEQ      *BLANK                                                    BUG4351
     C*****WE023         OREQ      'Y'                                                       BUG4351
     C*****DDPTFR        ANDNE     W1PR                                                      BUG4351
     C**********         MOVE      DDPTFR        W1PR              4                         BUG4351
     C**********         MOVE      'Y'           WE023                                       BUG4351
     C                   MOVE      'W'           DDPTFROK
     C                   ADD       1             WId
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0083'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF
      *
      ***  Process errors from AOPLCSR1
      *
     C                   ELSE
     C                   SELECT
     C     @RTCD         WHENEQ    'PMA0008'
     C     DDPTFR        ANDNE     *BLANKS
     C     @RTCD         OREQ      'PMA0009'
     C     DDPTFR        ANDNE     *BLANKS
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0489'     MsgIDXAr(Idx)
     C     @RTCD         WHENEQ    'PMA0010'
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0493'     MsgIDXAr(Idx)
     C     @RTCD         WHENEQ    'PMA0010'
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0494'     MsgIDXAr(Idx)
     C                   ENDSL
     C                   ENDIF
      *
      ***  Bank portfolio is supported but book and portfolio
      ***  reference do not match as per PF/SDBOOKPD
      *
     C     FCPORS        IFEQ      'B'
     C     DDBOKC        ANDNE     *BLANKS
     C     DDPTFR        ANDNE     *BLANKS
     C     DDPTFR        ANDNE     O#PTFR
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0495'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDPTFR        IFEQ      FCR997
     C     DDPTFR        OREQ      *BLANKS
     C     WPTCS         ANDEQ     'Y'
     C                   MOVE      '9997'        WPTFR             4
     C                   ELSE
     C                   MOVE      DDPTFR        WPTFR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Check Portfolio Reference if Private Banking Module is Active
      *
     C     BGN4ST        IFEQ      'Y'
     C     *IN82         ANDEQ     '0'
     C     *IN83         ANDEQ     '0'
      *
     C                   MOVE      'N'           WWCSPT            1
     C     BGPFMG        IFEQ      'Y'
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     WSVCN         I#CUST
     C                   MOVEL     CCLBRCA       I#BRCA
     C                   MOVEL     DDBOKC        I#BOOK
     C                   MOVEL     DDPTFR        I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           WWCSPT            1
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL(P)  WSVCN         @CUST
      *
     C**********         CALLB     'AOCUSTR0'                                                BUG7383
     C                   CALLB     'AOCUSTR1'                                                BUG7383
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C*****SDCUST        PARM      SDCUST        DSSDY                                       BUG7383
     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG7383
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
     C                   MOVE      'Y'           WWCSPT            1
     C                   ENDIF
      *
      *** If Portfolio Reference is Blank, this one must be defaulted
      *
     C     DDPTFR        IFEQ      *BLANKS
     C     WWCSPT        ANDEQ     'Y'
     C                   MOVE      WSVCN         WPCNO
     C     WPCNO         SETLL     PMPORTPD
     C     WPCNO         READE     PMPORTPD                               89
     C     *IN89         IFEQ      *OFF
     C     PNRECI        ANDEQ     'D'
     C                   MOVE      PNPTFR        DDPTFR
     C                   ENDIF
     C                   ENDIF
      *
      ***  Check if reference is a live record
      *
     C     DDPTFR        IFNE      *BLANKS
     C     WWCSPT        ANDEQ     'Y'
     C                   MOVEL     WSVCN         WPCNO
     C                   MOVEL     DDPTFR        WPTFR
     C     WKPOR         CHAIN     PMPORTPD                           89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     PNRECI        ANDNE     'D'
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0490'     MsgIDXAr(Idx)
      *
      ***  if existing, send warning if portfolio is closed
      *
     C                   ELSE
     C     PNDPCL        IFGT      *ZEROS
     C*****WE023         IFEQ      *BLANK                                                    BUG4351
     C*****WE023         OREQ      'Y'                                                       BUG4351
     C*****DDPTFR        ANDNE     W1PR                                                      BUG4351
     C**********         MOVE      DDPTFR        W1PR              4                         BUG4351
     C**********         MOVE      'Y'           WE023             1                         BUG4351
     C                   MOVE      'W'           DDPTFROK
     C                   ADD       1             WId
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0083'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Portfolio Entered but not PB or PM customer
      *
     C     DDPTFR        IFNE      *BLANKS
     C     WWCSPT        ANDNE     'Y'
     C                   MOVE      'N'           DDPTFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0490'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDPTFROK      IFNE      'N'
     C                   MOVEL     DDPTFR        CCLPTFR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRNACD - Validate alternate name and address                 *
      *****************************************************************
     C     SRNACD        BEGSR
      *
     C     DDNACD        IFEQ      *BLANK
     C                   MOVE      'B'           DDNACD
     C                   ENDIF
      *
     C     DDNACD        IFNE      'B'
     C                   MOVEL     WSVCN         @CUST
     C                   MOVE      DDNACD        @ADCD
     C                   CALLB     'AOALTNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CUST
     C                   PARM                    @ADCD             1
     C     SDALTN        PARM      SDALTN        DSSDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      BCADCD        DDNACD
     C                   ENDIF
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDNACD
     C                   ENDIF
      *
     C     @RTCD         IFNE      *BLANKS
     C     DDNACD        OREQ      'A'
     C     DDNACDOK      ORNE      'N'
     C     WSVCN         ANDNE     BCCUST
     C                   MOVE      'N'           DDNACDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNACD'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0168'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDNACDOK      IFNE      'N'
     C                   MOVEL     DDNACD        CCLNACD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRPRFC - Validate profit center                              *
      *           (for loans and parts purchased)                     *
      *****************************************************************
     C     SRPRFC        BEGSR
      *
     C     *IN83         IFEQ      '0'
     C     BKPRCU        IFEQ      'Y'
     C     BKPRCA        ANDEQ     'Y'
     C     BKPRCU        OREQ      'Y'
     C     CCLCHTP       ANDEQ     'I'
      *
      ***  Must be existing in profit centre's file, if entered
      *
     C     DDPRFC        IFNE      *BLANKS
     C                   MOVE      DDPRFC        @PCCD             4
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @PCCD
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPRFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0310'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDPRFC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      DSPCCD        DDPRFC
     C                   MOVE      DSLFPC        WLFPC             4
     C                   MOVE      DSFFPC        WFFPC             4
     C                   ENDIF
      *
      ***  Otherwise, extract default profit centre if default flag
      ***  is switched on
      *
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   MOVEL     CCLLTYP       PTRTP
     C                   MOVEL     CCLSUTP       PSUTP
     C                   MOVEL     CCLBRCA       PBRAN
     C                   MOVEL     PSUser        PUSER
     C                   MOVEL     DDACOF        PACOF
     C                   MOVEL     WSVCN         PCNUM
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       PRTNC             1
     C                   PARM      DDBOKC        PBOOK             2
     C                   PARM                    PTRTP             5
     C                   PARM                    PSUTP             2
     C                   PARM                    PBRAN             3
     C                   PARM      *BLANKS       PDEPT             3
     C                   PARM                    PUSER            10
     C                   PARM                    PACOF             2
     C                   PARM                    PCNUM             6
     C                   PARM      *BLANKS       PPRFC             4
     C                   MOVEL     PPRFC         DDPRFC
     C     PRTNC         IFEQ      '2'
     C                   MOVE      'N'           DDPRFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0310'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDPRFCOK      IFNE      'N'
     C                   MOVEL     DDPRFC        CCLPRFC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SREXCH - Validate facility currency and base currency        *
      *           exchange rates and indicators                       *
      *****************************************************************
     C     SREXCH        BEGSR
      *
      ***  Validate facility currency exchange rate/indicator
      ***  (for loans and parts purchased)
      *
     C     *IN83         IFEQ      '0'
      *
      ***  Must be blank of loan and facility currencies are the same
      *
     C     CCLCCY        IFEQ      FCCYM
     C     DDFCXR        ANDNE     *BLANKS
     C                   MOVE      'N'           DDFCXROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCXR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0282'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Facility currency indicator
      ***  Must be blank if loan and facility currencies are the same
      ***  Must be entered if facility currency rate is entered,
      ***  and likewise
      ***  Must be 'M' or 'D' if entered
      *
     C     CCLCCY        IFEQ      FCCYM
     C     DDFMIN        ANDNE     *BLANKS
      *
     C     DDFCXR        ORNE      *BLANKS
     C     DDFMIN        ANDEQ     *BLANKS
     C     DDFCXR        OREQ      *BLANKS
     C     DDFMIN        ANDNE     *BLANKS
      *
     C     DDFMIN        ORNE      *BLANKS
     C     DDFMIN        ANDNE     'M'
     C     DDFMIN        ANDNE     'D'
     C                   MOVE      'N'           DDFMINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFMIN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0291'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Retrieve facility details for default/conversion
      *
     C                   MOVE      FCCYF         @CYCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @CYCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Determine cross rate and mult/div indicator
      *
     C                   Z-ADD     A6NBDP        WCDPF             1 0
     C                   SELECT
     C     FCCYF         WHENNE    BJCYCD
     C     A6MDIN        IFEQ      'M'
     C                   MOVE      'D'           WMINX             1
     C                   ELSE
     C                   MOVE      'M'           WMINX
     C                   ENDIF
     C     A6MDIN        IFEQ      'M'
     C     WSVIN         ANDEQ     'M'
     C     A6MDIN        OREQ      'D'
     C     WSVIN         ANDEQ     'D'
     C     A6SPRT        DIV(H)    WSVRT         WSPOT            13 8
     C                   ELSE
     C     A6SPRT        MULT(H)   WSVRT         WSPOT
     C                   ENDIF
     C                   MOVE      'Y'           WFLAG
      *
     C                   OTHER
     C                   Z-ADD     WSVRT         WSPOT
     C     WSVIN         IFEQ      'M'
     C                   MOVE      'N'           WFLAG
     C                   MOVE      'M'           WMINX
     C                   ELSE
     C                   MOVE      'Y'           WFLAG
     C                   MOVE      'D'           WMINX
     C                   ENDIF
     C                   ENDSL
      *
      ***  Default rate and indicator if rate is blank
      *
     C     DDFMINOK      IFNE      'N'
     C     DDFCXROK      ANDNE     'N'
      *
     C                   MOVE      DDFMIN        WFMIN             1
     C     DDFCXR        IFEQ      *BLANKS
     C                   Z-ADD     WSPOT         WSVFX
     C                   MOVE      WMINX         WFMIN
     C                   MOVE      WMINX         DDFMIN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WSPOT         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDFCXR
      *
      ***  Otherwise, must be a valid rate
      *
     C                   ELSE
     C                   MOVE      *BLANKS       @SCRF
     C                   MOVE      DDFCXR        @SCRF
     C                   Z-ADD     8             @NDEC
     C                   Z-ADD     5             @NDIG
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF            16
     C                   PARM                    @NDEC             1 0
     C                   PARM                    @NDIG             2 0
     C                   PARM      *BLANKS       @RVAL            16
      *
     C                   MOVE      @RVAL         WSVAM
     C                   MOVE      @RVAL         WSVFX
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFCXROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCXR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0283'     MsgIDXAr(Idx)
     C                   ELSE
      *                                                                                     AR882700
      ** Send error message if Facility Currency Exchange Rate                              AR882700
      ** is equal to zero                                                                   AR882700
      *                                                                                     AR882700
     C     WSVFX         IFEQ      *ZERO                                                    AR882700
     C                   MOVE      'N'           DDFCXROK                                   AR882700
     C                   ADD       1             Idx                                        AR882700
     C                   MOVEL     'DDFCXR'      FldNamXAr(Idx)                             AR882700
     C                   MOVEL     'LEL0814'     MsgIDXAr(Idx)                              AR882700
     C                   ELSE                                                               AR882700
      *
      ***  Warning message will be sent if rate is not within 25%
      ***  of the rate calculated by the program
      *
     C     DDFMIN        IFNE      WMINX
     C     1             DIV(H)    WSPOT         WSPOT
     C                   ENDIF
     C     WSPOT         MULT(H)   .75           WRATM            13 8
     C     WSPOT         MULT(H)   1.25          WRATP            13 8
     C     WSVFX         IFLT      WRATM
     C     WSVFX         ORGT      WRATP
      *
     C*****WE015         IFEQ      *BLANK                                                    BUG4351
     C*****WE015         OREQ      'Y'                                                       BUG4351
     C*****WSVFX         ANDNE     W1FX                                                      BUG4351
     C     DDACT3        IFEQ      'I'                                                       BUG1538
     C**********         Z-ADD     WSVFX         W1FX             13 8                       BUG4351
     C**********         MOVE      'Y'           WE015             1                         BUG4351
     C                   MOVE      'W'           DDFCXROK
     C                   ADD       1             WId
     C                   MOVEL     'DDFCXR'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0079'     WMsgIDXAr(WId)
     C                   ENDIF                                                               BUG1538
     C**********         ENDIF                                                               BUG4351
      *
     C                   ENDIF
     C                   ENDIF                                                              AR882700
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate base currency equivalent rate/indicator
      *
      ***  Default rate and indicator if rate is blank
      *
     C                   MOVE      DDBMIN        WBMIN             1
     C     DDBCXR        IFEQ      *blanks
     C                   Z-ADD     WSVRT         WSVBX
     C                   MOVE      WSVIN         WBMIN
     C                   MOVE      WSVIN         DDBMIN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WSVRT         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDBCXR
      *
      ***  Otherwise, must be numeric
      *
     C                   ELSE
     C                   MOVE      *BLANKS       @SCRF
     C                   MOVE      DDBCXR        @SCRF
     C                   Z-ADD     8             @NDEC
     C                   Z-ADD     5             @NDIG
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF            16
     C                   PARM                    @NDEC             1 0
     C                   PARM                    @NDIG             2 0
     C                   PARM      *BLANKS       @RVAL            16
      *
     C                   MOVE      @RVAL         WSVBX            13 8
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBCXROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCXR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0281'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  Warning message will be sent if rate is not within 25%
      ***  of the rate calculated by the program
      *
     C     DDBMIN        IFEQ      WSVIN
     C                   Z-ADD     WSVRT         WSPOT
     C                   ELSE
     C     1             DIV(H)    WSVRT         WSPOT
     C                   ENDIF
     C     WSPOT         MULT(H)   .75           WRATM            13 8
     C     WSPOT         MULT(H)   1.25          WRATP            13 8
      *
     C     WSVBX         IFLT      WRATM
     C     WSVBX         ORGT      WRATP
     C*****WE006         IFEQ      *BLANK                                                    BUG4351
     C*****WE006         OREQ      'Y'                                                       BUG4351
     C*****WSVBX         ANDNE     W1BX                                                      BUG4351
     C     DDACT3        IFEQ      'I'                                                       BUG1538
     C**********         Z-ADD     WSVBX         W1BX             13 8                       BUG4351
     C**********         MOVE      'Y'           WE006                                       BUG4351
     C                   MOVE      'W'           DDBCXROK
     C                   ADD       1             WId
     C                   MOVEL     'DDBCXR'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0072'     WMsgIDXAr(WId)
     C                   ENDIF                                                               BUG1538
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDBCXROK      IFNE      'N'
     C                   MOVE      *BLANKS       @SCRF
     C                   MOVE      DDBCXR        @SCRF
     C                   Z-ADD     8             @NDEC
     C                   Z-ADD     5             @NDIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF
     C                   PARM                    @NDEC
     C                   PARM                    @NDIG
     C                   PARM      *BLANKS       @RVAL
      *
     C                   MOVE      @RVAL         CCLBCXR
     C                   ENDIF
      *
     C     DDBMINOK      IFNE      'N'
     C     @RVAL         ANDNE     *ZERO
     C                   MOVEL     DDBMIN        CCLBMDI
     C                   ENDIF
      *
     C     DDFCXROK      IFNE      'N'
     C                   MOVE      *BLANKS       @SCRF
     C                   MOVE      DDFCXR        @SCRF
     C                   Z-ADD     8             @NDEC
     C                   Z-ADD     5             @NDIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF
     C                   PARM                    @NDEC
     C                   PARM                    @NDIG
     C                   PARM      *BLANKS       @RVAL
      *
     C                   MOVE      @RVAL         CCLFCXR
     C                   ENDIF
      *
     C     DDFMINOK      IFNE      'N'
     C     @RVAL         ANDNE     *ZERO
     C                   MOVEL     DDFMIN        CCLFMDI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRRECE - Validate guarantee receiver                         *
      *****************************************************************
     C     SRRECE        BEGSR
      *
     C     BPGIAV        IFEQ      'Y'
      *
      ***  Must be entered and valid for loan processing type 70
      *
     C     WLNPT         IFEQ      70
     C     WLNPT         OREQ      71
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '70'
     C     DDRECE        IFEQ      *BLANKS
     C                   MOVE      'N'           DDRECEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRECE'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0016'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      *BLANKS       @CUST
     C                   MOVEL     DDRECE        @CUST
     C**********         CALLB     'AOCUSTR0'                                                BUG7383
     C                   CALLB     'AOCUSTR1'                                                BUG7383
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C*****SDCUST        PARM      SDCUST        DSSDY                                       BUG7383
     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG7383
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDRECEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRECE'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0015'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDRECE
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       DDRECE
     C                   MOVEL     BBCUST        DDRECE
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be blank for loan processing types other than 70
      *
     C                   ELSE
     C     DDRECE        IFNE      *BLANKS
     C                   MOVE      'N'           DDRECEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRECE'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0017'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDRECEOK      IFNE      'N'
     C***********        MOVE      DDRECE        CCLRECE                                      225386
     C                   MOVEL     DDRECE        CCLRECE                                      225386
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCOCU - Validate customer confirmation                      *
      *****************************************************************
     C     SRCOCU        BEGSR
      *
     C     S01465        IFEQ      'Y'
      *
      ***  Must be numeric value existing in customer's file
      *
     C     DDCOCU        IFNE      *BLANKS
     C**********         MOVEL     DDCOCU        WNUM7             7 0                        CSD027
     C**********         MOVEL     WNUM7         WALF6             6                          CSD027
     C                   MOVE      *BLANKS       @CUST
     C                   MOVEL     DDCOCU        @CUST
     C**********         CALLB     'AOCUSTR0'                                                BUG7383
     C                   CALLB     'AOCUSTR1'                                                BUG7383
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C*****SDCUST        PARM      SDCUST        DSSDY                                       BUG7383
     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG7383
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCOCUOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCOCU'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0014'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDCOCU
     C                   ENDIF
     C                   ELSE
     C                   MOVE      BBCUST        DDCOCU
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDCOCUOK      IFNE      'N'
     C                   MOVE      DDCOCU        CCLCOCU
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFUDT - Validate funding details                            *
      *****************************************************************
     C     SRFUDT        BEGSR
      *
     C                   MOVE      *BLANKS       WFUNP             1
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'
     C     CCLPTYP       IFEQ      61
     C     CCLPTYP       OREQ      62
     C     CCLPTYP       OREQ      64
     C     CCLPTYP       OREQ      66
     C     CCLPTYP       OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     CCLPTYP       OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     CCLPTYP       OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     CCLPTYP       OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     CCLPTYP       OREQ      67
     C     CDE002        ANDEQ     'Y'
      *
     C     CCLORED       IFNE      BJRDNB
     C     DDACT3        ANDNE     'I'                                                        224261
     C     CCLLSTS       OREQ      'A'                                                       BUG6258
     C                   MOVE      'Y'           WFUNP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Only if analytical accounting is being used
      ***  or revenue analysis is installed
      *
     C     BGN0ST        IFEQ      'Y'
     C     WFUNP         ANDEQ     *BLANK
     C     CDE002        OREQ      'Y'
     C     WFUNP         ANDEQ     *BLANK
      *
      ***  If Funding Spread/Rate field has not been entered, sign
      ***  and profit centre must be left blank
      *
     C                   Z-ADD     0             WFSRP
     C     DDFRSP        IFEQ      *BLANKS
     C     DDFSGN        IFNE      *BLANKS
     C                   MOVE      'N'           DDFSGNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSGN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0012'     MsgIDXAr(Idx)
     C                   ENDIF
     C     DDFPRC        IFNE      *BLANKS
     C     DDFUND        ANDEQ     *BLANKS                                                 BUG10391R
     C                   MOVE      'N'           DDFPRCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPRC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0009'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  Validate Funding Spread/Rate.
      *
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   EVAL      DDFRSPOK = 'Y'                                          BUG10391R
     C                   EVAL      Idx = Idx + 1                                           BUG10391R
     C                   EVAL      FldNamXAr(Idx) = 'DDFRSP'                               BUG10391R
                                                                                           BUG10391R
      ** Entry for both Funding Rate and Funding Spread Rate is                            BUG10391R
      ** not possible.                                                                     BUG10391R
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0804'                               BUG10391R
     C                   ENDIF                                                             BUG10391R
                                                                                           BUG10391R
     C                   MOVE      *BLANKS       @SCRF
     C                   MOVE      DDFRSP        @SCRF
     C                   Z-ADD     4             @NDIG
     C                   Z-ADD     7             @NDEC
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF
     C                   PARM                    @NDEC
     C                   PARM                    @NDIG
     C                   PARM      *BLANKS       @RVAL
     C                   MOVE      @RVAL         WFSRP
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFRSPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFRSP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0010'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Validate Funding Spread/Rate Sign
      *
     C     DDFSGN        IFNE      *BLANK
     C     DDFSGN        ANDNE     '+'
     C     DDFSGN        ANDNE     '-'
     C     CLE036        ANDEQ     'N'                                                     BUG10391R
     C                   MOVE      'N'           DDFSGNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSGN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0011'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
                                                                                           BUG10391R
      ** Format Funding Rate                                                               BUG10391R
                                                                                           BUG10391R
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   MOVE      *BLANKS       @SCRF                                     BUG10391R
     C                   MOVE      DDFUND        @SCRF                                     BUG10391R
     C                   Z-ADD     4             @NDIG                                     BUG10391R
     C                   Z-ADD     7             @NDEC                                     BUG10391R
     C                   CALL      'ZALIGN'                                                BUG10391R
     C                   PARM      *BLANKS       @RTCD                                     BUG10391R
     C                   PARM                    @SCRF                                     BUG10391R
     C                   PARM                    @NDEC                                     BUG10391R
     C                   PARM                    @NDIG                                     BUG10391R
     C                   PARM      *BLANKS       @RVAL                                     BUG10391R
     C                   MOVE      @RVAL         WFSRP                                     BUG10391R
     C     @RTCD         IFNE      *BLANKS                                                 BUG10391R
     C                   MOVE      'N'           DDFUNDOK                                  BUG10391R
     C                   ADD       1             Idx                                       BUG10391R
     C                   MOVEL     'DDFUND'      FldNamXAr(Idx)                            BUG10391R
     C                   MOVEL     'LEL0010'     MsgIDXAr(Idx)                             BUG10391R
     C                   ENDIF                                                             BUG10391R
     C                   ENDIF                                                             BUG10391R
                                                                                           BUG10391R
      ** Validate Funding Spread/Rate Sign                                                 BUG10391R
                                                                                           BUG10391R
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFSGNOK <> 'N' AND                                     BUG10391R
     C                             DDFRSPOK <> 'N' AND                                     BUG10391R
     C                             DDFUNDOK <> 'N'                                         BUG10391R
     C                   IF        DDFUND <> *BLANKS AND                                   BUG10391R
     C                             DDFSGN <> *BLANKS OR                                    BUG10391R
     C                             DDFRSP <> *BLANKS AND                                   BUG10391R
     C                             DDFSGN <> '+'     AND                                   BUG10391R
     C                             DDFSGN <> '-'                                           BUG10391R
     C                   EVAL      DDFSGNOK = 'N'                                          BUG10391R
     C                   EVAL      Idx = Idx + 1                                           BUG10391R
     C                   EVAL      FldNamXAr(Idx) = 'DDFSGN'                               BUG10391R
      ** Funding spread sign must be '+' or '-' if funding spread rate                     BUG10391R
      ** is entered; Funding spread sign must be *BLANK if funding                         BUG10391R
      ** rate is entered                                                                   BUG10391R
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0805'                               BUG10391R
     C                   ENDIF                                                             BUG10391R
     C                   ENDIF                                                             BUG10391R
      *
      ***  If the Funding Spread/Rate and Sign are both valid,
      ***  determine the actual funding rate.
      *
     C     DDFRSPOK      IFNE      'N'
     C     DDFSGNOK      ANDNE     'N'
     C     DDFRSP        ANDNE     *BLANKS
     C     CLE036        ANDEQ     'Y'                                                     BUG10391R
     C     DDFRSPOK      ORNE      'N'                                                     BUG10391R
     C     DDFSGNOK      ANDNE     'N'                                                     BUG10391R
     C     DDFUNDOK      ANDNE     'N'                                                     BUG10391R
     C     DDFRSP        ANDNE     *BLANKS                                                 BUG10391R
     C     CLE036        ANDEQ     'Y'                                                     BUG10391R
     C     DDFRSPOK      ORNE      'N'                                                     BUG10391R
     C     DDFSGNOK      ANDNE     'N'                                                     BUG10391R
     C     DDFUNDOK      ANDNE     'N'                                                     BUG10391R
     C     DDFUND        ANDNE     *BLANKS                                                 BUG10391R
     C     CLE036        ANDEQ     'Y'                                                     BUG10391R
      *
     C                   SELECT
     C     DDFSGN        WHENEQ    '+'
     C     WINTT         ADD       WFSRP         WAFSRP
     C     DDFSGN        WHENEQ    '-'
     C     WINTT         SUB       WFSRP         WAFSRP
     C                   OTHER
     C                   Z-ADD     WFSRP         WAFSRP           11 7
     C                   ENDSL
      *
      ***  Compute the maximum and minimum allowable amount based on
      ***  tolerance for Funding Rate.
      *
     C     BGN0ST        IFEQ      'Y'
     C     FTTFRT        DIV       100           WTRATE            3 2
      *
     C     1             ADD       WTRATE        WMAXTL            4 2
     C     WINTT         MULT(H)   WMAXTL        WMAXRT           11 7
      *
     C     1             SUB       WTRATE        WMINTL            4 2
     C     WINTT         MULT      WMINTL        WMINRT           11 7
      *
      ***  If the Actual Funding Rate is greater the the maximum or
      ***  less than the minimum amount, display warning message
      *
     C     WAFSRP        IFGT      WMAXRT
     C     WAFSRP        ORLT      WMINRT
     C*****WE010         IFEQ      *BLANK                                                    BUG4351
     C*****WE010         OREQ      'Y'                                                       BUG4351
     C*****WAFSRP        ANDNE     W1FR                                                      BUG4351
     C**********         Z-ADD     WAFSRP        W1FR             11 7                       BUG4351
     C**********         MOVE      'Y'           WE010                                       BUG4351
                                                                                           BUG10391R
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   MOVE      'W'           DDFUNDOK                                  BUG10391R
     C                   ADD       1             WId                                       BUG10391R
     C                   MOVEL     'DDFUND'      WFldNmXAr(WId)                            BUG10391R
     C                   ELSE                                                              BUG10391R
     C                   MOVE      'W'           DDFRSPOK
     C                   ADD       1             WId
     C                   MOVEL     'DDFRSP'      WFldNmXAr(WId)
     C                   ENDIF                                                             BUG10391R
                                                                                           BUG10391R
     C                   MOVEL     'LEL0076'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Validate Funding Profit Centre
      *
     C     DDFPRC        IFNE      *BLANKS
     C                   MOVE      DDFPRC        @PCCD
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @PCCD
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           DDFPRCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPRC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0002'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDFPRC
     C                   ENDIF
     C                   ELSE
      *
      ***  Profit centre must allow direct funding
      *
     C                   MOVE      DSPCCD        DDFPRC
     C     DSDFPR        IFEQ      'N'
     C                   MOVE      'N'           DDFPRCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPRC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0008'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  If funding profit centre is blank and spread/rate is
      ***  entered, default to value from booking profit centre
      *
     C     DDFPRC        IFEQ      *BLANKS
     C     DDFRSP        ANDNE     *BLANKS
     C     DDFRSPOK      ANDNE     'N'
     C     BGN0ST        ANDEQ     'Y'
     C     DDFPRC        OREQ      *BLANKS                                                 BUG10391R
     C     DDFUND        ANDNE     *BLANKS                                                 BUG10391R
     C     DDFUNDOK      ANDNE     'N'                                                     BUG10391R
     C     BGN0ST        ANDEQ     'Y'                                                     BUG10391R
     C     CLE036        ANDEQ     'Y'                                                     BUG10391R
      *
     C     DDPRFC        IFEQ      *BLANKS
     C                   MOVE      'N'           DDFPRCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPRC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0007'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C     DDPRFCOK      IFNE      'N'
     C     CCLCCY        IFEQ      BJLCCY
     C                   MOVE      WLFPC         DDFPRC
     C                   ELSE
     C                   MOVE      WFFPC         DDFPRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE                                                   BUG491
      * Funding information cannot be amended if the loan is authorised                      BUG6258
      * or has not been entered today.                                                       BUG6258
                                                                                BUG491
     C*****DDFRSP        IFNE      *BLANKS                                      BUG491       BUG6258
     C**********         MOVE      'N'           DDFRSPOK                       BUG491       BUG6258
     C**********         ADD       1             Idx                            BUG491       BUG6258
     C**********         MOVEL     'DDFRSP'      FldNamXAr(Idx)                 BUG491       BUG6258
     C**********         MOVEL     'LEL0673'     MsgIDXAr(Idx)                  BUG491       BUG6258
     C**********         ENDIF                                                  BUG491       BUG6258
      **********                                                                BUG491       BUG6258
     C*****DDFSGN        IFNE      *BLANKS                                      BUG491       BUG6258
     C**********         MOVE      'N'           DDFSGNOK                       BUG491       BUG6258
     C**********         ADD       1             Idx                            BUG491       BUG6258
     C**********         MOVEL     'DDFSGN'      FldNamXAr(Idx)                 BUG491       BUG6258
     C**********         MOVEL     'LEL0674'     MsgIDXAr(Idx)                  BUG491       BUG6258
     C**********         ENDIF                                                  BUG491       BUG6258
      **********                                                                BUG491       BUG6258
     C*****DDFPRC        IFNE      *BLANKS                                      BUG491       BUG6258
     C**********         MOVE      'N'           DDFPRCOK                       BUG491       BUG6258
     C**********         ADD       1             Idx                            BUG491       BUG6258
     C**********         MOVEL     'DDFPRC'      FldNamXAr(Idx)                 BUG491       BUG6258
     C**********         MOVEL     'LEL0675'     MsgIDXAr(Idx)                  BUG491       BUG6258
     C**********         ENDIF                                                  BUG491       BUG6258
                                                                                BUG491
     C                   MOVE      *BLANKS       @SCRF                                       BUG6258
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   MOVE      DDFUND        @SCRF                                     BUG10391R
     C                   ELSE                                                              BUG10391R
     C                   MOVE      DDFRSP        @SCRF                                       BUG6258
     C                   ENDIF                                                             BUG10391R
     C                   Z-ADD     4             @NDIG                                       BUG6258
     C                   Z-ADD     7             @NDEC                                       BUG6258
     C                   CALL      'ZALIGN'                                                  BUG6258
     C                   PARM      *BLANKS       @RTCD                                       BUG6258
     C                   PARM                    @SCRF                                       BUG6258
     C                   PARM                    @NDEC                                       BUG6258
     C                   PARM                    @NDIG                                       BUG6258
     C                   PARM      *BLANKS       @RVAL                                       BUG6258
     C                   MOVE      @RVAL         WCLFSRP          11 7                       BUG6258
                                                                                             BUG6258
     C/COPY WNCPYSRC,LEH01453
     C     WCLFSRP       IFNE      CCLFSRP                                                   BUG6258
                                                                                           BUG10391R
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   MOVE      'N'           DDFUNDOK                                  BUG10391R
     C                   ADD       1             Idx                                       BUG10391R
     C                   MOVEL     'DDFUND'      FldNamXAr(Idx)                            BUG10391R
     C                   ELSE                                                              BUG10391R
     C                   MOVE      'N'           DDFRSPOK                                    BUG6258
     C                   ADD       1             Idx                                         BUG6258
     C                   MOVEL     'DDFRSP'      FldNamXAr(Idx)                              BUG6258
     C                   ENDIF                                                             BUG10391R
     C                   MOVEL     'LEL0702'     MsgIDXAr(Idx)                               BUG6258
     C                   ENDIF                                                               BUG6258
                                                                                             BUG6258
     C     DDFSGN        IFNE      CCLFSGN                                                   BUG6258
     C                   MOVE      'N'           DDFSGNOK                                    BUG6258
     C                   ADD       1             Idx                                         BUG6258
     C                   MOVEL     'DDFSGN'      FldNamXAr(Idx)                              BUG6258
     C                   MOVEL     'LEL0702'     MsgIDXAr(Idx)                               BUG6258
     C                   ENDIF                                                               BUG6258
                                                                                             BUG6258
     C     DDFPRC        IFNE      CCLFPRC                                                   BUG6258
     C                   MOVE      'N'           DDFPRCOK                                    BUG6258
     C                   ADD       1             Idx                                         BUG6258
     C                   MOVEL     'DDFPRC'      FldNamXAr(Idx)                              BUG6258
     C                   MOVEL     'LEL0702'     MsgIDXAr(Idx)                               BUG6258
     C                   ENDIF                                                               BUG6258
                                                                                             BUG6258
     C/COPY WNCPYSRC,LEH01454
     C                   ENDIF
      *
     C     DDFRSPOK      IFNE      'N'
     C     CLE036        ANDEQ     'N'                                                     BUG10391R
     C     DDFRSPOK      ORNE      'N'                                                     BUG10391R
     C     DDFUNDOK      ANDNE     'N'                                                     BUG10391R
     C     CLE036        ANDEQ     'Y'                                                     BUG10391R
     C                   MOVE      *BLANKS       @SCRF
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             DDFUND <> *BLANKS                                       BUG10391R
     C                   MOVE      DDFUND        @SCRF                                     BUG10391R
     C                   ELSE                                                              BUG10391R
     C                   MOVE      DDFRSP        @SCRF
     C                   ENDIF                                                             BUG10391R
     C                   Z-ADD     4             @NDIG
     C                   Z-ADD     7             @NDEC
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @SCRF
     C                   PARM                    @NDEC
     C                   PARM                    @NDIG
     C                   PARM      *BLANKS       @RVAL
     C                   MOVE      @RVAL         CCLFSRP
     C                   ENDIF
      *
     C     DDFSGNOK      IFNE      'N'
     C                   MOVEL     DDFSGN        CCLFSGN
     C                   ENDIF
      *
     C     DDFPRCOK      IFNE      'N'
     C                   MOVEL     DDFPRC        CCLFPRC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       225959
     C/EJECT                                                                                  225959
      *****************************************************************                       225959
      *  SRYLDC - Validate yield curve                                *                       225959
      *****************************************************************                       225959
     C     SRYLDC        BEGSR                                                                225959
      *                                                                                       225959
     C     CCLPTYP       IFEQ      70                                                         225959
     C     CCLPTYP       OREQ      71                                                         225959
     C     CCLPTYP       OREQ      72                                                         225959
      *                                                                                       225959
     C     DDYLDC        IFNE      *BLANKS                                                    225959
     C                   MOVE      'N'           DDYLDCOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDYLDC'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0680'     MsgIDXAr(Idx)                                225959
     C                   ELSE                                                                BUG8048
     C                   Eval      CCLYLDC = DDYLDC                                          BUG8048
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C     DDFYLD        IFNE      *BLANKS                                                    225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0681'     MsgIDXAr(Idx)                                225959
     C                   ELSE                                                                BUG8048
     C                   Eval      CCLFYLD = DDFYLD                                          BUG8048
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ELSE                                                                 225959
      *                                                                                       225959
      ** Access the loan type/subtype details                                                 225959
      *                                                                                       225959
     C                   MOVE      CCLLTYP       PLNTY                                        225959
     C                   MOVE      CCLSUTP       PLNST                                        225959
     C                   MOVE      CCLCLAS       PLNCL                                        CLE042
      *                                                                                       225959
     C                   CALL      'AOLOANR0'                                                 225959
     C                   PARM      *BLANKS       PRTCD             7                          225959
     C                   PARM      '*KEY   '     POPTN             7                          225959
     C                   PARM                    PLNTY             2                          225959
     C                   PARM                    PLNST             2                          225959
     C                   PARM                    PLNCL             4                          CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        225959
      *                                                                                       225959
      ** Yield Curve Validation                                                               225959
      *                                                                                       225959
      ** If entered, check if valid Yield Curve                                               225959
      *                                                                                       225959
     C     DDYLDC        IFNE      *BLANKS                                                    225959
      *                                                                                       225959
     C                   CALL      'AOYLDCR0'                                                 225959
     C                   PARM      '*BLANKS'     PRTCD                                        225959
     C                   PARM      '*KEY   '     POPTN                                        225959
     C                   PARM      DDYLDC        PPYLDC            5                          225959
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        225959
      *                                                                                       225959
     C     PRTCD         IFEQ      '*NRF   '                                                  225959
     C                   MOVE      'N'           DDYLDCOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDYLDC'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0532'     MsgIDXAr(Idx)                                225959
     C                   ELSE                                                                 225959
     C                   MOVEL     PPYLDC        DDYLDC                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** If no selection was made, default to the value of the Yield                          225959
      ** Curve for the loan type/subtype                                                      225959
      *                                                                                       225959
     C     DDYLDC        IFEQ      *BLANKS                                                    225959
     C     PPYLDC        ANDEQ     *BLANKS                                                    225959
      *                                                                                       225959
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          225959
      ** Generate error if no default value set in loan                                       225959
      ** type/subtype file.                                                                   225959
      *                                                                                       225959
     C     AYYLDM        IFEQ      'Y'                                                        225959
     C     AYYLDC        ANDEQ     *BLANKS                                                    225959
     C                   MOVE      'N'           DDYLDCOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDYLDC'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0536'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   MOVE      AYYLDC        DDYLDC                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** Yield Curve is not entered                                                           225959
      *                                                                                       225959
     C                   ELSE                                                                 225959
      *                                                                                       225959
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          225959
      ** Generate error if no default value set in loan                                       225959
      ** type/subtype file.                                                                   225959
      *                                                                                       225959
     C     AYYLDM        IFEQ      'Y'                                                        225959
     C     AYYLDC        ANDEQ     *BLANKS                                                    225959
     C                   MOVE      'N'           DDYLDCOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDYLDC'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0536'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   MOVE      AYYLDC        DDYLDC                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** Forward Yield Curve Validation                                                       225959
      *                                                                                       225959
      ** If entered, check if valid Yield Curve                                               225959
      *                                                                                       225959
     C     DDFYLD        IFNE      *BLANKS                                                    225959
      *                                                                                       225959
     C                   CALL      'AOYLDCR0'                                                 225959
     C                   PARM      '*BLANKS'     PRTCD                                        225959
     C                   PARM      '*KEY   '     POPTN                                        225959
     C                   PARM      DDFYLD        PPYLDC                                       225959
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        225959
      *                                                                                       225959
      ** No record found                                                                      225959
     C     PRTCD         IFEQ      '*NRF   '                                                  225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0535'     MsgIDXAr(Idx)                                225959
     C                   ELSE                                                                 225959
      *                                                                                       225959
      ** If no selection was made, default to the value of the Forward                        225959
      ** Yield Curve for the loan type/subtype                                                225959
      *                                                                                       225959
     C     PRTCD         IFEQ      '*NOSEL '                                                  225959
      *                                                                                       225959
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          225959
      ** Generate error if no default value set in loan                                       225959
      ** type/subtype file.                                                                   225959
      *                                                                                       225959
     C     AYYLDM        IFEQ      'Y'                                                        225959
     C     AYFYLD        ANDEQ     *BLANKS                                                    225959
     C     CAS005        ANDNE     'Y'                                                        225959
     C     AYFYCM        OREQ      'Y'                                                        225959
     C     AYFYLD        ANDEQ     *BLANKS                                                    225959
     C     CAS005        ANDEQ     'Y'                                                        225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0531'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   MOVE      AYFYLD        DDFYLD                                       225959
      *                                                                                       225959
      ** Access yield curves file to get the details                                          225959
      *                                                                                       225959
     C     DDFYLD        IFNE      *BLANK                                                     225959
     C     CAS005        ANDNE     'Y'                                                        225959
     C                   CALL      'AOYLDCR0'                                                 225959
     C                   PARM      '*BLANKS'     PRTCD                                        225959
     C                   PARM      '*KEY   '     POPTN                                        225959
     C                   PARM      DDFYLD        PPYLDC                                       225959
     C     SDYLDC        PARM      SDYLDC        DSSDY                                        225959
      *                                                                                       225959
      ** No record found                                                                      225959
      *                                                                                       225959
     C     PRTCD         IFEQ      '*NRF   '                                                  225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0535'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
     C                   ENDIF                                                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   MOVEL     PPYLDC        DDFYLD                                       225959
      *                                                                                       225959
      ** If CAS005 is installed,must accept any curve type of any                             225959
      ** interpolation method for forward yield curve.  Hence, these                          225959
      ** validations are no longer needed.                                                    225959
      *                                                                                       225959
     C     CAS005        IFNE      'Y'                                                        225959
      *                                                                                       225959
      ** Error if Non Zero-coupon Yield Curve                                                 225959
      *                                                                                       225959
     C     FSYLDT        IFNE      'Z'                                                        225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0533'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** Error if Interpolation Method is neither 'Y' nor 'R'                                 225959
      *                                                                                       225959
     C     FSINTP        IFNE      'Y'                                                        225959
     C     FSINTP        ANDNE     'R'                                                        225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0534'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** Forward Yield Curve not entered                                                      225959
      *                                                                                       225959
     C                   ELSE                                                                 225959
      *                                                                                       225959
      ** Check if Yield Curve Mandatory flag is 'Y'.                                          225959
      ** Generate error if no default value set in loan                                       225959
      ** type/subtype file.                                                                   225959
      *                                                                                       225959
     C     AYYLDM        IFEQ      'Y'                                                        225959
     C     AYFYLD        ANDEQ     *BLANKS                                                    225959
     C     CAS005        ANDNE     'Y'                                                        225959
     C     AYFYCM        OREQ      'Y'                                                        225959
     C     AYFYLD        ANDEQ     *BLANKS                                                    225959
     C     CAS005        ANDEQ     'Y'                                                        225959
     C                   MOVE      'N'           DDFYLDOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDFYLD'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0531'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   MOVE      AYFYLD        DDFYLD                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
      ** If CAS005 is installed.                                                              225959
      *                                                                                       225959
     C     CAS005        IFEQ      'Y'                                                        225959
      *                                                                                       225959
      ** Reval curve must have a value if the Forward curve is populated.                     225959
      *                                                                                       225959
     C     DDYLDC        IFEQ      *BLANKS                                                    225959
     C     DDFYLD        ANDNE     *BLANKS                                                    225959
     C                   MOVE      'N'           DDYLDCOK                                     225959
     C                   ADD       1             Idx                                          225959
     C                   MOVEL     'DDYLDC'      FldNamXAr(Idx)                               225959
     C                   MOVEL     'LEL0566'     MsgIDXAr(Idx)                                225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C     DDYLDCOK      IFNE      'N'                                                        225959
     C                   MOVEL     DDYLDC        CCLYLDC                                      225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C     DDFYLDOK      IFNE      'N'                                                        225959
     C                   MOVEL     DDFYLD        CCLFYLD                                      225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ENDIF                                                                225959
      *                                                                                       225959
     C                   ENDSR                                                                225959
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRMVFLD - Move the screen fields to valid file              *
      *****************************************************************
     C     SRMVFLD       BEGSR
      *
     C                   MOVEL     DDNAR1        CCLNAR1
     C                   MOVEL     DDNAR2        CCLNAR2
     C                   MOVEL     DDNAR3        CCLNAR3
     C                   MOVEL     DDNAR4        CCLNAR4
      *
     C                   ENDSR
      *****************************************************************                     AR804863
      /EJECT                                                                                AR804863
      *****************************************************************                     AR804863
      *                                                               *                     AR804863
      * SRRSFD  -  Restore original details (for Reject Action)       *                     AR804863
      *                                                               *                     AR804863
      *****************************************************************                     AR804863
     C     SRRSFD        BEGSR                                                              AR804863
      *                                                                                     AR804863
      ** Account Officer                                                                    AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDACOF        CCLACOF                                    AR804863
      *                                                                                     AR804863
      ** Book Code                                                                          AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDBOKC        CCLBOKC                                    AR804863
      *                                                                                     AR804863
      ** Profit Center                                                                      AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDPRFC        CCLPRFC                                    AR804863
      *                                                                                     AR804863
      ** Industry                                                                           AR804863
      *                                                                                     AR804863
     C                   MOVE      DDLIND        CCLLIND                                    AR804863
      *                                                                                     AR804863
      ** Country of Risk                                                                    AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDCRSK        CCLCRSK                                    AR804863
      *                                                                                     AR804863
      ** FRB Code                                                                           AR804863
      *                                                                                     AR804863
     C                   MOVE      DDFRBC        CCLFRBC                                    AR804863
      *                                                                                     AR804863
      ** Yield Curve                                                                        AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDYLDC        CCLYLDC                                    AR804863
     C                   MOVEL     DDFYLD        CCLFYLD                                    AR804863
      *                                                                                     AR804863
      ** Fees                                                                               AR804863
      *                                                                                     AR804863
     C     DDFEEI        IFEQ      'Y'                                                      AR804863
     C                   BITON     '2'           CCLRELI                                    AR804863
     C                   ELSE                                                               AR804863
     C                   BITOFF    '2'           CCLRELI                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Documents                                                                          AR804863
      *                                                                                     AR804863
     C     DDDOCI        IFEQ      'Y'                                                      AR804863
     C                   BITON     '1'           CCLRELI                                    AR804863
     C                   ELSE                                                               AR804863
     C                   BITOFF    '1'           CCLRELI                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Secured                                                                            AR804863
      *                                                                                     AR804863
     C     DDSECI        IFEQ      'Y'                                                      AR804863
     C                   BITON     '0'           CCLRELI                                    AR804863
     C                   ELSE                                                               AR804863
     C                   BITOFF    '0'           CCLRELI                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Portfolio Reference                                                                AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDPTFR        CCLPTFR                                    AR804863
      *                                                                                     AR804863
      ** Narrative                                                                          AR804863
      *                                                                                     AR804863
     C                   EXSR      SRMVFLD                                                  AR804863
      *                                                                                     AR804863
      ** Guarantee Receiver                                                                 AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDRECE        CCLRECE                                    AR804863
      *                                                                                     AR804863
      ** Customer Confirmation                                                              AR804863
      *                                                                                     AR804863
     C                   MOVE      DDCOCU        CCLCOCU                                    AR804863
      *                                                                                     AR804863
     C                   ENDSR                                                              AR804863
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset warning flags
      *
     C     SaveDDLNR3    IFNE      DDLNR3
     C**********         MOVE      *BLANK        WE023             1                         BUG4351
     C**********         MOVE      *BLANK        WE015             1                         BUG4351
     C**********         MOVE      *BLANK        WE006             1                         BUG4351
     C**********         MOVE      *BLANK        WE010             1                         BUG4351
     C                   ENDIF
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ***  Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I*****        SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      *
      ***  Loan details screen 1
     C                   PARM                    TranInScr3
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      *
      ***  Extended data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      ***  User from Loan manager
     C                   PARM                    @USER            16
      *
      ***  Seq  from Loan manager
     C                   PARM                    W#SEQ             4 0
      *
      ***  PC Originating Branch from Loan manager
     C                   PARM                    W#PCOB            3
      *
      ***  Generated by Principal Transfer from PT Midas input
     C                   PARM                    PGNTF             1
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C*************      PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Valid Loan CL layout (DS) from/to caller
     C                   PARM                    ValidLnCl
      *
      ***  Valid Loan CK layout (DS) from/to caller
     C                   PARM                    ValidLnCk
      *
      ***  Next available loan number
     C                   PARM                    PRANG             2
      *
      ***  Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      *
      ***  Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      *
      ***  Shared data
     C                   PARM                    TransData
      *
      ***  PC Processing
     C                   PARM                    PPTIN             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIP3VL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Retrieve Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Retrieve portfolio management ICD for portfolio module
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ***  Retrieve profit centre accounting ICD if analytical
      ***  accounting is installed
      *
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDPCACPD'    DBFILE                         *************
     C                   Z-ADD     8             DBASE                          * DBERR 008 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CDE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE002
     C                   END
      *
     C                   MOVE      'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   END
      *
      ***  Determine if CAS001 is installed
      *
     C                   MOVEL     'N'           CAS001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS001'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001
     C                   END
      *                                                                                       225959
      ***  Determine if CAS005 is installed                                                   225959
      *                                                                                       225959
     C                   MOVEL     'N'           CAS005            1                          225959
     C                   CALLB     'AOSARDR0'                                                 225959
     C                   PARM      *BLANKS       @RTCD                                        225959
     C                   PARM      '*VERIFY'     @OPTN                                        225959
     C                   PARM      'CAS005'      @SARD                                        225959
     C     @RTCD         IFEQ      *BLANKS                                                    225959
     C                   MOVE      'Y'           CAS005                                       225959
     C                   END                                                                  225959
      *                                                                                       CGL058
      ***  Check if CGL058 is on                                                              CGL058
      *                                                                                       CGL058
     C                   MOVE      'N'           CGL058            1                          CGL058
     C                   CALLB     'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*VERIFY'     @OPTN                                        CGL058
     C                   PARM      'CGL058'      @SARD                                        CGL058
      *                                                                                       CGL058
     C                   IF        @RTCD = *BLANKS                                            CGL058
     C                   MOVE      'Y'           CGL058                                       CGL058
     C                   ENDIF                                                                CGL058
                                                                                              CLE106
      ** Determine if CLE106 is installed                                                     CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                           BUG10391R
      ** Determine if CLE036 is installed                                                  BUG10391R
                                                                                           BUG10391R
     C                   EVAL      CLE036 = 'N'                                            BUG10391R
     C                   CALLB     'AOSARDR0'                                              BUG10391R
     C                   PARM      *Blanks       @RTCD                                     BUG10391R
     C                   PARM      '*VERIFY'     @OPTN                                     BUG10391R
     C                   PARM      'CLE036'      @SARD                                     BUG10391R
     C                   IF        @RTCD = *Blanks                                         BUG10391R
     C                   EVAL      CLE036 = 'Y'                                            BUG10391R
     C                   ENDIF                                                             BUG10391R
     C/COPY WNCPYSRC,LEH01455
      *
      ***  Key list for PMPORTPD
      *
     C     WKPOR         KLIST
     C*****              KFLD                    WPCNO             6 0                        CSD027
     C                   KFLD                    WPCNO             6                          CSD027
     C                   KFLD                    WPTFR             4
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIP3V25
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
