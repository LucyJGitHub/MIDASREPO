     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans input')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPSIN - LE Customer Loans Input                          *
      *                                                               *
      *  Function:  This is the screens input function for Customer   *
      *             Loans.                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD036070           Date 19Oct15               *
      *  Prev Amend No. LLN022A            Date 13Aug12               *
      *                 LLN022             Date 13Aug12               *
      *                 MD030621           Date 26Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247441             Date 20Jul07               *
      *                 CPK028             Date 12Jun07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 BUG13843           Date 02May07               *
      *                 245227             Date 27Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11340           Date 04May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9221            Date 16Nov05               *
      *                 BUG8526            Date 27Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 08Sep03               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA096             Date 30Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 TDA023             Date 24Mar04               *
      *                 225959             Date 23Mar04               *
      *                 224261             Date 09Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 23Sep02
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 27Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LECLIPDTA,LECLIPSC01,LECLIPSC02    *
      *                            LECLIPSMV1                         *
      *  MD030621 - Pass @DEPI (Decrease Principal indicator) for PDCL*
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  CPK028 - Customer Number fields should be alpha.             *
      *  245273 - Added parameter to LECLIPRTV and LECLIPUPD call.    *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIP1VL, LECLIPUPD*
      *  BUG11340  - Pameter mismatch in calling LECLIP3VL.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9221 - Added parameter Infdata on LECLIP2VL.              *
      *  BUG8526- Facility Currency Exchange Rate should be used, if  *
      *           entered, in the calculation of the Facility         *
      *           Repayment amount.                                   *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPS010,LECLIPS011              *
      *           Core hooks amended:LECLIPS001                       *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA096 - Initialise screen format.                           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  225959 - Missing CAS00x changes                              *
      *  224261 - Funding spread/rate still being shown in certain    *
      *           conditions                                          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005   Reservation ID                                      *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ***  FILES  ***
     F/COPY WNCPYSRC,LECLIPSF01
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      /COPY QWINDSRC,LECLIPDTA                                                                LLN022
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
      *
      ** NEW Loan Details in File Format                                                      LLN022
      *                                                                                       LLN022
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLIPX0)                                 LLN022
                                                                                              LLN022
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL) PREFIX(L)
      ***  Current Loan in File Format CL
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK) PREFIX(K)
      ***  Current Loan in File Format CK
 
 
     D CrLnScnFmt1   E DS                  EXTNAME(LECLI1PD)  PREFIX(@)
      ***  (Current) Loan in Screen Format - Screen 1
     D CrLnScnFmt2   E DS                  EXTNAME(LECLI2PD)  PREFIX(@)
      ***  (Current) Loan in Screen Format - Screen 2
     D CrLnScnFmt3   E DS                  EXTNAME(LECLI3PD)  PREFIX(@)
      ***  (Current) Loan in Screen Format - Screen 3
     D CrLnScnFmt4   E DS                  EXTNAME(LECLI4PD)  PREFIX(@)
      ***  (Current) Loan in Screen Format - Screen 4
 
 
     D NwLnFilFmtCL  E DS                  EXTNAME(LEVCLILPD)
      ***  New Loan in File Format CL
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                542   1086                                                       CGL029
     D***CLRECEx             1579   1596                                               CGL029 TDA023
     D***CLPAYEX             1597   1614                                               CGL029 TDA023
     D  CLRECEx             1597   1614                                                       TDA023
     D  CLPAYEX             1615   1632                                                       TDA023
 
     D NwLnFilFmtCK  E DS                  EXTNAME(LEVCLIKPD) PREFIX(K_)
      ***  New Loan in File Format CK
 
 
     D NwLnScnFmt1   E DS                  EXTNAME(LECLI1PD)
      ***  New Loan in Screen Format - Screen 1
     D NwLnScnFmt2   E DS                  EXTNAME(LECLI2PD)
      ***  New Loan in Screen Format - Screen 2
     D NwLnScnFmt3   E DS                  EXTNAME(LECLI3PD)
      ***  New Loan in Screen Format - Screen 3
     D NwLnScnFmt4   E DS                  EXTNAME(LECLI4PD)
      ***  New Loan in Screen Format - Screen 4
 
 
     D OKLnScn1      E DS                  EXTNAME(LEECLI1PD)
      ***  Error indicators Screen 1
     D OKLnScn2      E DS                  EXTNAME(LEECLI2PD)
      ***  Error indicators Screen 2
     D OKLnScn3      E DS                  EXTNAME(LEECLI3PD)
      ***  Error indicators Screen 3
     D OKLnScn4      E DS                  EXTNAME(LEECLI4PD)
      ***  Error indicators Screen 4
 
      *****************************
      ** Settlement instructions **
      *****************************
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File Receive Instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS Instructions
 
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive Instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen Payment Instructions
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS Instructions
 
 
     D @CCI@           DS
      ***  Current control indicators for details screens 1, 2, 3, and 4
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKI                 5      5
     D  @EINKJ                 6      6
     D  @EINKN                 7      7
     D  @EINKP                 8      8
      *
     D @PCI@           DS             8
      ***  Previous control indicators for details screens 1, 2, 3, or 4
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * EXTERNAL DS FOR SAR DETAILS                                                           CSC022
      *                                                                                       CSC022
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
      ***  Loan number ranges file
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  Loan type/subtype details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D ExtData       E DS                  EXTNAME(LECLEXPD)
      ***  LE (CLIP) Extra Data - File (D/B) format
      *
     D InfData       E DS                  EXTNAME(LELEIFPD)                                 BUG9221
      * LE Extra Data - Classe 1 Data - File (D/B) format                                    BUG9221
     D                                     PREFIX(IF_)                                       BUG9221
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
     D**FCUSM***              64     69  0                                                    CPK028
     D  FCUSM                 64     69                                                       CPK028
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
     D**WPTFC***             224    229  0                                                    CPK028
     D  WPTFC                224    229A                                                      CPK028
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
     D**ANUM****             445    450  0                                                    CPK028
     D**CNUMF***             451    456  0                                                    CPK028
     D**PMFC****             457    462  0                                                    CPK028
     D  ANUM                 445    450                                                       CPK028
     D  CNUMF                451    456                                                       CPK028
     D  PMFC                 457    462                                                       CPK028
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
     D  CONF1                  1     34
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
     D  @DSPI1                69     98
     D  @DSPI2                99    128
     D  @DSPI3               129    158
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
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      *                                                                                       LLN022
     D #RTRN           S              7A                                                      LLN022
      ** Return Field                                                                         LLN022
      *                                                                                       LLN022
      ** +--------------------------------------+                                             CSC022
      ** Ê Use of Indicator                     Ê                                             CSC022
      ** Ê ================                     Ê                                             CSC022
      ** ¦                                      ¦                                             CSC022
      ** ¦ 17      Used by LOOKUP               ¦                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
      *
      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** Ê Hook for non-core D-specs (all types)  Ê
      ** Ê also any I-specs (if necessary)        Ê
      ** Ê =====================================  Ê
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIPS001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,LECLIPS002
      *
      ***  Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      /COPY WNCPYSRC,LECLIPS003
      *
      ***  Do while screen: Screen details 1
      *
     C     @SCRN         DOWEQ     '1'
     C                   EXSR      SCRN@1
     C     SaveDDACTN    IFEQ      '1'
     C     SaveDDACTN    OREQ      '2'
     C     SaveDDACTN    OREQ      '3'
     C     SaveDDACTN    OREQ      '4'
     C     @SCRN         IFNE      'T'
     C                   MOVEL     SaveDDACTN    @SCRN
     C                   END
     C                   END
     C                   END
      *
      ***  Do while screen: Screen details 2
      *
     C     @SCRN         DOWEQ     '2'
     C                   EXSR      SCRN@2
     C                   END
      *
      ***  Do while screen: Screen details 3
      *
     C     @SCRN         DOWEQ     '3'
     C                   EXSR      SCRN@3
     C                   END
      *
      ***  Do while screen: Screen details 4
      *
     C     @SCRN         DOWEQ     '4'
     C                   EXSR      SCRN@4
     C                   END
      /COPY WNCPYSRC,LECLIPS004
      *                                                                                       LLN022
      **  If window:                                                                          LLN022
      *                                                                                       LLN022
     C     @SCRN         IFEQ      'W'                                                        LLN022
     C                   EXSR      WINDOW                                                     LLN022
     C                   ENDIF                                                                LLN022
      *
      ***  Do while screen: Settlement details
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      /COPY WNCPYSRC,LECLIPS005
      *
      ***  Screen: Confirmation of input
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      /COPY WNCPYSRC,LECLIPS006
      *
      ***  Do file updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      /COPY WNCPYSRC,LECLIPS007
      *
      ***  Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
      *
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LECLIPS008
      *
      /EJECT
      *****************************************************************
      * SCRN@1 - Process screen 1 details                             *
      *****************************************************************
     C     SCRN@1        BEGSR
      *
      ***  Update 'previous' Loan number & screen control indicator
      *
     C     @PLNRF        IFNE      DDLNRF
     C                   CLEAR                   TransData
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
     C                   END
     C                   MOVEL     DDLNRF        @PLNRF            6
     C                   MOVEL     DDACTN        @PACTN            1
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen
      *
     C                   CALLB     'LECLIP1DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Loan (in screen format)
     C                   PARM                    NwLnScnFmt1
      *
      ***  Fields in error
      *
     C                   PARM                    OKLnScn1
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKI
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Loan record Id
      *
     C                   PARM                    PLnRcdId
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKI             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Save the action code entered in case of enquiry directly on
      ***  screen 1, 2, 3 or 4
      *
     C     SaveDDACTN    IFNE      '1'
     C                   MOVEL     DDACTN        SaveDDACTN        1
     C                   END
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OKLnScn1
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@2 - Process screen 2 details                             *
      *****************************************************************
     C     SCRN@2        BEGSR
      *
      ***  Update 'previous' Loan number & screen control indicator
      *
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen 2
      *
     C                   CALLB     'LECLIP2DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Loan (in screen format)
     C                   PARM                    NwLnScnFmt2
      *
      ***  Fields in error
      *
     C                   PARM                    OKLnScn2
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Action code
      *
     C                   PARM      DDACTN        PActionCode       1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Work fields                                                                         BUG3721
     C                   PARM                    WPRCS2                                      BUG3721
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @PGUP             1
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OKLnScn2
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@3 - Process screen 3 details                             *
      *****************************************************************
     C     SCRN@3        BEGSR
      *
      ***  Update 'previous' Loan number & screen control indicator
      *
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen 3
      *
     C                   CALLB     'LECLIP3DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Loan (in screen format)
     C                   PARM                    NwLnScnFmt3
      *
      ***  Fields in error
     C                   PARM                    OKLnScn3
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
      *
      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      *
      * Loan Type
     C                   PARM                    LoanType          4
      *
      ***  Action code
      *
     C                   PARM      DDACTN        PActionCode
      *
      ***  Base rate code
      *
     C                   PARM                    DDBRTT
      *
      ***  Output parameters
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @PGUP
      *
      ***  Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly
     C                   PARM                    CLORED                         224261
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OKLnScn3
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@4 - Process screen 4 details                             *
      *****************************************************************
     C     SCRN@4        BEGSR
      *
      ***  Update 'previous' Loan number & screen control indicator
      *
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen 4
      *
     C                   CALLB     'LECLIP4DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Loan (in screen format)
     C                   PARM                    NwLnScnFmt4
      *
      ***  Fields in error
      *
     C                   PARM                    OKLnScn4
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Action code
      *
     C                   PARM      DDACTN        PActionCode
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @PGUP
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OKLnScn4
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESET  - Reset errors                                         *
      *****************************************************************
     C     RESET         BEGSR
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/7 - Roll Backwards
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      ***  CK/8 - Roll Forwards
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      ***  CK/9 - Amend
      *
     C     @INKI         CASEQ     '1'           AMDL@A
      *
      ***  CK/12 - Cancel
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  CK/15 - Browse
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      ***  Validate input to 1, 2, 3, or 4 details screen
      *
     C                   CAS                     VAL@A
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@A  - Validate input to details screen 1, 2, 3, or 4       *
      *          first part                                           *
      *****************************************************************
     C     VAL@A         BEGSR
      *
      ***  If action code and Loan number are blank
      ***  Re-output screen
      *
     C     DDACTN        IFEQ      *BLANKS
     C     DDLNRF        ANDEQ     *BLANKS
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Retrieve Loan details
      *
     C     @SCRN         IFEQ      '1'
     C                   EXSR      RTVLOAN
      *
      ***  If action code or Loan number are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     PLnRcdId      IFEQ      'R'
     C     PLnRcdId      OREQ      'M'
     C                   MOVEL     *BLANKS       SaveDDACTN
     C                   MOVEL     'E'           @OPSEL
     C                   MOVEL     'E'           DDACTN
     C                   ELSE
     C                   GOTO      EVAL@B
     C                   END
     C                   END
     C                   END
      *
      ***  Set field and function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  If action code is delete, enquire or authorize
      ***  or action code is amend and Loan number has changed
      ***  Convert the loan from file to screen format
      *
     C     @SCRN         IFEQ      '1'
     C     DDACTN        ANDNE     'I'
 
     C     DDACTN        IFNE      @PACTN
     C     DDLNRF        ORNE      @PLNRF
     C                   EXSR      CVTLOAN
     C                   END
 
     C                   END
      *
      ***  If Loan number or screen control indicators have changed
      ***  Re-output screen
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        IFNE      @PACTN
     C     DDLNRF        ORNE      @PLNRF
     C                   GOTO      EVAL@B
     C                   END
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update Loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If enquire
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
      *
      ***  Update Loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/14 taken, continue to settlements screen
      ***  If browse outstanding, read next browse subfile record
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     @SCRN         SaveSCRN          1
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C     @SCRN         ANDEQ     '4'
     C     BGWDPR        IFNE      'Y'                                                        LLN022
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF                                                                LLN022
     C                   END
     C                   END
      *
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
     C     CLE030        ANDEQ     'N'                                                        CLE030
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Update Loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVE      *ALL'Y'       OKLnScn1
     C     @SCRN         WHENEQ    '2'
     C                   MOVE      *ALL'Y'       OKLnScn2
     C     @SCRN         WHENEQ    '3'
     C                   MOVE      *ALL'Y'       OKLnScn3
     C     @SCRN         WHENEQ    '4'
     C                   MOVE      *ALL'Y'       OKLnScn4
     C                   END
      *
      ***  Update Loan in valid file format
      *
      *    should be done only once otherwise the fields in NwLnFilFmt
      *    are lost (settlement instructions)
 
     C     FrstTimLoan   IFEQ      'Y'
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
     C                   MOVE      *blanks       FrstTimLoan
     C                   ENDIF
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   EXSR      VAL@1
     C     @SCRN         WHENEQ    '2'
     C     SaveDDACTN    IFEQ      '2'
     C                   EXSR      VAL@1
     C                   END
     C                   EXSR      VAL@2
     C     @SCRN         WHENEQ    '3'
     C     SaveDDACTN    IFEQ      '3'
     C                   EXSR      VAL@1
     C                   EXSR      VAL@2
     C                   END
     C                   EXSR      VAL@3
     C     @SCRN         WHENEQ    '4'
     C     SaveDDACTN    IFEQ      '4'
     C                   EXSR      VAL@1
     C                   EXSR      VAL@2
     C                   EXSR      VAL@3
     C                   END
     C                   EXSR      VAL@4
     C                   END
      *
      ***  Reset the error and warning fields
      *
      *
     C                   END
      *
     C     EVAL@A        TAG
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Continue
      *
     C     SaveDDACTN    IFNE      '1'
     C     SaveDDACTN    ANDNE     '2'
     C     SaveDDACTN    ANDNE     '3'
     C     SaveDDACTN    ANDNE     '4'
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL     '2'           @SCRN
     C     @SCRN         WHENEQ    '2'
     C     DoneSettl     IFEQ      'Y'
     C     DDACTN        OREQ      'E'
     C                   MOVEL     '3'           @SCRN
     C                   MOVEL     'N'           DoneSettl
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
     C     @SCRN         WHENEQ    '3'
     C                   MOVEL     '4'           @SCRN
     C     @SCRN         WHENEQ    '4'
     C                   SELECT
     C     DDACTN        WHENEQ    'E'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     '1'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'I'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'C'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'A'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'X'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'U'           @SCRN                                        CLE030
     C                   ENDIF                                                                LLN022
     C                   END
     C                   END
     C                   END
      *
     C     SaveDDACTN    IFEQ      '1'
     C     SaveDDACTN    OREQ      '2'
     C     SaveDDACTN    OREQ      '3'
     C     SaveDDACTN    OREQ      '4'
     C                   MOVEL     'U'           @SCRN
     C                   MOVEL     *BLANKS       SaveDDACTN
     C                   END
      *----------------------------------------------------------------
     C     EVAL@B        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@1  - Validate input to details screen 1                   *
      *****************************************************************
     C     VAL@1         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LECLIP1AD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
      *
     C                   PARM                    NwLnScnFmt1
      *
      ***  Current Loan in Screen Format
      *
     C                   PARM                    CrLnScnFmt1
      *
      ***  Current Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
      *
     C                   PARM                    OKLnScn1
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ***  Amendments OK
      *
     C                   PARM                    @@AMOK            1
      *
      ***  Reset of Fields in Error Required (Y/N)
      *
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP1VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt1
     C                   PARM                    InfData                                      CER020
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    LoanType
     C                   PARM                    @USER            16
     C                   PARM                    W#SEQ             4 0
     C                   PARM                    W#PCOB            3
     C                   PARM                    PGNTF             1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Screen detail 2                                                                     BUG3721
     C                   PARM                    NwLnScnFmt2                                 BUG3721
                                                                                             BUG3721
      ** Screen detail 3                                                                      CLE106
     C                   PARM                    NwLnScnFmt3                                  CLE106
                                                                                              CLE106
     C                   PARM                    OKLnScn1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    @PRANG            2
     C                   PARM                    DataOldRcd
     C                   PARM                    DataNewRcd
     C                   PARM                    TransData
     C                   PARM                    PPTIN             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
     C                   PARM                    ModeofOp          6                          247441
      * Front Office Transaction ID                                                         MD032052
     C                   PARM                    FOTRID           20                        MD032052
      *
      *----------------------------------------------------------------
     C     EVAL@1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@2  - Validate input to details screen 2                   *
      *****************************************************************
     C     VAL@2         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LECLIP2AD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
      *
     C                   PARM                    NwLnScnFmt2
      *
      ***  Current Loan in Screen Format
      *
     C                   PARM                    CrLnScnFmt2
      *
      ***  Current Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Work fields                                                                         BUG3721
     C                   PARM                    WPRCS2                                      BUG3721
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
      *
     C                   PARM                    OKLnScn2
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ***  Amendments OK
      *
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
      *
     C                   PARM      'Y'           @@RSTE
     C                   END
      *
      ***  Update valid loan: Last action code
      *
     C                   MOVEL     DDACTN        CLCHTP
     C                   MOVEL     DDACTN        K_CLCHTP
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP2VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt2
     C                   PARM                    NwLnScnFmt3                                 BUG8526
     C                   PARM                    InfData                                     BUG9221
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** (Current) loan in file format CL                                                    BUG3721
      ** Screen Detail 1                                                                     BUG3721
      ** OK fields on 1st Screen                                                             BUG3721
     C                   PARM                    CrLnFilFmtCL                                BUG3721
     C                   PARM                    NwLnScnFmt1                                 BUG3721
     C                   PARM                    OKLnScn1                                    BUG3721
                                                                                             BUG3721
     C                   PARM                    OKLnScn2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    @PRANG
     C                   PARM                    DataOldRcd
     C                   PARM                    DataNewRcd
     C                   PARM                    TransData
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
      *
      *----------------------------------------------------------------
     C     EVAL@2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@3  - Validate input to details screen 3                   *
      *****************************************************************
     C     VAL@3         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LECLIP3AD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
      *
     C                   PARM                    NwLnScnFmt3
      *
      ***  Current Loan in Screen Format
      *
     C                   PARM                    CrLnScnFmt3
      *
      ***  Current Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
      *
     C                   PARM                    OKLnScn3
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ***  Amendments OK
      *
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
      *
     C                   PARM      'Y'           @@RSTE
     C                   END
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP3VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt3
     C                   PARM                    InfData                                    BUG11340
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF
     C                   PARM                    OKLnScn3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    @PRANG
     C                   PARM                    DataOldRcd
     C                   PARM                    DataNewRcd
     C                   PARM                    TransData
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
      *
      ***  Update loan in file format
      *
      *
      *----------------------------------------------------------------
     C     EVAL@3        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@4  - Validate input to details screen 4                   *
      *****************************************************************
     C     VAL@4         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LECLIP4AD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
      *
     C                   PARM                    NwLnScnFmt4
      *
      ***  Current Loan in Screen Format
      *
     C                   PARM                    CrLnScnFmt4
      *
      ***  Current Loan in file format
      *
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
      *
     C                   PARM                    OKLnScn4
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ***  Amendments OK
      *
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
      *
     C                   PARM      'Y'           @@RSTE
     C                   END
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP4VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt4
     C                   PARM                    InfData                                      CER020
     C                   PARM                    ExtData
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF
     C                   PARM                    OKLnScn4
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    @PRANG
     C                   PARM                    DataOldRcd
     C                   PARM                    DataNewRcd
     C                   PARM                    TransData
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
      *
      ***  Update loan in file format
      *
      *
      *----------------------------------------------------------------
     C     EVAL@4        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through loans file
      *****************************************************************
     C     ROLL          BEGSR
      *
      ***  Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      ***  Read next or previous record on loans file
      ***  according to command key taken (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'LECLIPRED'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ***  Action code
     C                   PARM                    DDACTN            1
      *
      ***  Loan number pointer
     C                   PARM                    DDLNRF            6
      *
      ***  Front Office ID
     C                   PARM                    DDFRTN           20
      *
      ***  Calling type
     C                   PARM                    LoanType
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Loan number read
     C                   PARM      *BLANK        @DLRED            6
      *
      ***  Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      ***  If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@A
     C                   GOTO      EROLL
     C                   END
      *
      ***  If deal read
      *
     C     @DLRED        IFNE      *BLANK
      *
      ***  Retrieve deal details
      *
     C                   MOVEL     @DLRED        DDLNRF
     C                   EXSR      RTVLOAN
      *
      ***  Set field and function key status on main details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  Convert the loan from file to screen format
      *
     C                   EXSR      CVTLOAN
      *
      ***  Go to first details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build browse subfile                                 *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Save the action code
      *
     C                   MOVEL     DDACTN        StoreAC           1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LECLIPBRW'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
      *
     C                   PARM                    DDACTN            1
      *
      ***  Loan number
      *
     C                   PARM                    DDLNRF            6
      *
      ***  Build subfile
      *
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
      *
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
      *
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
      *
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Loan number selected
      *
     C                   PARM      *BLANK        @DLSEL            6
      *
      ***  Command keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@A
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If CK/12 not taken in browse
      ***  Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Restore the action code
      *
     C                   MOVEL     StoreAC       DDACTN
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record                      *
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LECLIPBRW'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
      *
     C                   PARM                    DDACTN            1
      *
      ***  Loan number pointer
      *
     C                   PARM                    DDLNRF            6
      *
      ***  Build subfile
      *
     C                   PARM      *BLANK        @BDSFL            1
      *
      ***  Read subfile record
      *
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
      *
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
      *
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Loan number selected
      *
     C                   PARM      *BLANK        @DLSEL            6
      *
      ***  Command keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  If loan read from subfile
      *
     C     @DLSEL        IFNE      *BLANKS
     C     @OPSEL        ANDNE     *BLANKS
      *
      ***  Retrieve Loan details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @DLSEL        DDLNRF
     C                   EXSR      RTVLOAN
      *
      ***  Set field and function key status
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  Check if not error
      *
     C     DDLNRFOK      IFNE      'Y'
     C                   MOVEL     'E'           @OPSEL
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
      *
      ***  Set field and function key status
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  Update Loan in File Format
      *
     C     @OPSEL        IFEQ      '1'
     C     @OPSEL        OREQ      '2'
     C     @OPSEL        OREQ      '3'
     C     @OPSEL        OREQ      '4'
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
     C                   ENDIF
      *
      ***  Convert the loan from file to screen format
      *
     C                   EXSR      CVTLOAN
      *
      ***  Go to the appropriate details screen
      *
     C                   SELECT
     C     @OPSEL        WHENEQ    '2'
     C                   MOVEL     'A'           DDACTN
     C                   EXSR      VAL@1
     C                   MOVEL     @OPSEL        DDACTN
     C     @OPSEL        WHENEQ    '3'
     C                   MOVEL     'A'           DDACTN
     C                   EXSR      VAL@1
     C                   EXSR      VAL@2
     C                   MOVEL     @OPSEL        DDACTN
     C     @OPSEL        WHENEQ    '4'
     C                   MOVEL     'A'           DDACTN
     C                   EXSR      VAL@1
     C                   EXSR      VAL@2
     C                   EXSR      VAL@3
     C                   MOVEL     @OPSEL        DDACTN
     C                   END
      *
      ***  Reset the error and warning fields
      *
     C     @OPSEL        IFEQ      '1'
     C     @OPSEL        OREQ      '2'
     C     @OPSEL        OREQ      '3'
     C     @OPSEL        OREQ      '4'
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
      *
      ***  Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   END
      *
      ***  Go to appropriate details screen
      *
     C                   SELECT
     C     @OPSEL        WHENEQ    '2'
     C                   MOVEL     '2'           @SCRN
     C                   MOVE      *OFF          @INKP
     C     @OPSEL        WHENEQ    '3'
     C                   MOVEL     '3'           @SCRN
     C                   MOVE      *OFF          @INKP
     C     @OPSEL        WHENEQ    '4'
     C                   MOVEL     '4'           @SCRN
     C                   MOVE      *OFF          @INKP
     C                   OTHER
     C     SaveDDACTN    IFEQ      '1'
     C     SaveDDACTN    OREQ      '2'
     C     SaveDDACTN    OREQ      '3'
     C     SaveDDACTN    OREQ      '4'
     C                   MOVEL     *BLANKS       NwLnScnFmt1
     C                   MOVEL     *BLANKS       SaveDDACTN
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVE      *OFF          @INKP
     C                   END
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
      ***  Save the action code entered in case of enquiry directly on
      ***  screen 1, 2, 3 or 4
      *
     C     DDACTN        IFNE      *BLANKS
     C                   MOVEL     DDACTN        SaveDDACTN
     C                   ELSE
     C                   MOVEL     SaveDDACTN    DDACTN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVLOAN- Retrieve loan                                        *
      *****************************************************************
     C     RTVLOAN       BEGSR
      *
      ***  Retrieve loan
      *
     C                   CALLB     'LECLIPRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      * Response mode SECURITY CKECKING
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Customer Loan Reference
     C                   PARM                    DDLNRF
      *
      ** Loan type/sub type
     C                   PARM                    DDLTYP
     C                   PARM                    DDSUTP
     C                   PARM                    DDCLAS                                       CLE042
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
 
      * OUTPUTS
 
      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      * Loan Type
     C                   PARM                    @@LoanType        4
 
      * (Current) Customer loan CL in file format
     C                   PARM                    CrLnFilFmtCL
      * (Current) Customer loan CK in file format
     C                   PARM                    CrLnFilFmtCK
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Loan Reference
     C                   PARM      *BLANK        DDLNRFOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM                    WFldNamArr                                   225959
     C                   PARM                    WMsgIdArr                                    225959
     C                   PARM                    WMsgDtaArr                                   225959
     C                   PARM                    WIdx                                         225959
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPS011
      *
      ***  Save the loan record Id
     C                   MOVEL     LRECI         PLnRcdId          1
     C                   Z-ADD     LCHGA         WCHGA                                       BUG3721
      *
      ***  Set the field 'First time for Loan' equal to 'Y'
      *
     C                   MOVE      'Y'           FrstTimLoan       1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTLOAN - Convert a loan from file to screen format           *
      *****************************************************************
     C     CVTLOAN       BEGSR
      *
      ***  Call programs to fill screen fields
      ***  from CLOANCL and CLOANCK
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
     C                   PARM                    NwLnScnFmt1
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
     C                   PARM                    NwLnScnFmt2
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
     C                   PARM                    NwLnScnFmt3
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
     C                   PARM                    NwLnScnFmt4
      *
      ***  Update 'Current' Loan with Loan in Screen Format
      *
     C                   MOVEL     NwLnScnFmt1   CrLnScnFmt1
     C                   MOVEL     NwLnScnFmt2   CrLnScnFmt2
     C                   MOVEL     NwLnScnFmt3   CrLnScnFmt3
     C                   MOVEL     NwLnScnFmt4   CrLnScnFmt4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@A - Set field status on details screens 1, 2, 3, and 4   *
      *          according to action code                             *
      *****************************************************************
     C     SFDS@A        BEGSR
      *
      ***  Enable/disable key & detail fields on details screen
      ***  (key fields = action code & Loan number; detail fields = rest)
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@A - Set function key status on details screens 1, 2, 3,  *
      *          and 4 according to action code                       *
      *****************************************************************
     C     SFKS@A        BEGSR
      *
      ***  Enable/disable function keys on details screen
      *
      ***  KG = Command key 07 = Previous
      *
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     'Y'           @EINKG
      *
      ***  KH = Command key 08 = Next
      *
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
      ***  KI = Command key 09 = Amend
      *
     C     DDACTN        IFEQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C                   MOVEL     'Y'           @EINKI
     C                   ELSE
     C                   MOVEL     'N'           @EINKI
     C                   END
      *
      ***  KJ = Command Key 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  KN = Command key 14 = Settlement details
      ***  (Action codes I, A, X display settlement details automatically)
      ***  (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      ***  KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@A - Initialize field status on details screens 1, 2, 3   *
      *          and 4                                                *
      *****************************************************************
     C     IFDS@A        BEGSR
      *
      ***  Enable key & details fields
      *
     C                   MOVEL     'Y'           @EKYFD
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'I'
     C     DDACTN        OREQ      *BLANKS
     C                   MOVEL     'Y'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@A - Initialize function key status on details screens    *
      *          1, 2, 3, and 4                                       *
      *****************************************************************
     C     IFKS@A        BEGSR
      *
      ***  Enable/disable function keys on details screens
      *
      * KG = Command key 07 = Read previous
      * KH = Command key 08 = Read next
      * KI = Command key 09 = Amend
      * KJ = Command key 10 = Delete
      * KN = Command key 14 = Settlement details
      * KP = Command key 15 = Browse
      *
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
     C                   END
      *
     C     DDACTN        IFEQ      '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C                   MOVEL     'Y'           @EINKI
     C                   ELSE
     C                   MOVEL     'N'           @EINKI
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AMDL@A - Allow the amend mode in case of action code 1, 2, 3  *
      *          or 4.                                                *
      *****************************************************************
     C     AMDL@A        BEGSR
      *
     C                   MOVEL     'A'           DDACTN
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - Cancel on details screens 1, 2, 3 and 4              *
      *****************************************************************
     C     CANC@A        BEGSR
      *
      ***  Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      ***  If input fields are enabled
      ***  Blank the details screen
      *
     C     SaveDDACTN    IFEQ      '1'
     C     SaveDDACTN    OREQ      '2'
     C     SaveDDACTN    OREQ      '3'
     C     SaveDDACTN    OREQ      '4'
     C                   MOVEL     '1'           @SCRN
     C                   MOVEL     *BLANK        NwLnScnFmt1
     C                   MOVEL     *BLANKS       NwLnScnFmt2                                  TDA096
     C                   MOVEL     *BLANKS       NwLnScnFmt3                                  TDA096
     C                   MOVEL     *BLANKS       NwLnScnFmt4                                  TDA096
     C                   MOVEL     *BLANKS       SaveDDACTN
     C                   END
      *
      ***  If input fields are enabled
      ***  Blank the first details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     *BLANK        NwLnScnFmt1
     C                   MOVEL     *BLANKS       NwLnScnFmt2                                  TDA096
     C                   MOVEL     *BLANKS       NwLnScnFmt3                                  TDA096
     C                   MOVEL     *BLANKS       NwLnScnFmt4                                  TDA096
     C                   END
     C                   END
      *
      ***  Change screen
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL     '1'           @SCRN
     C     @SCRN         WHENEQ    '3'
     C                   MOVEL     '2'           @SCRN
     C     @SCRN         WHENEQ    '4'
     C                   MOVEL     '3'           @SCRN
     C                   END
      *
      ***  Initialize field and function key status on details screen
      *
     C     @SCRN         IFEQ      '1'
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
     C                   END
      *                                                                                       LLN022
      ** Issue rollback to clear any possible updates in the window                           LLN022
      **  function                                                                            LLN022
      *                                                                                       LLN022
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@A - Send a message to details screens 1, 2, 3, and 4     *
      *****************************************************************
     C     SNDM@A        BEGSR
      *
      ***  If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'LEL0602'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ***  Loan number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'LEL0601'
     C                   MOVE      'N'           DDLNRFOK
     C                   END
      *
      ***  Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details evoked for        *
      *          inserts, amends, enquiries & authorizations          *
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ***  If first time for action code, loan number, currency or customer
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDLNRF        ORNE      ##LNRF
     C     DDCURR        ORNE      ##PCCY
     C     DDCUST        ORNE      ##CSNM
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
     C                   END
      *
      ***  Determinate proctect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVEL     'Y'           ##PPAY
     C                   MOVEL     'Y'           ##PREC
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     CLVDAT        IFLT      BJRDNB
     C     CLORED        ANDLT     BJRDNB
     C     *IN83         IFEQ      *ON
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C                   MOVEL     'Y'           ##PPAY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
      *
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Loan number
      *
     C                   PARM      DDLNRF        ##LNRF            6
      *
      ***  Protect Payment
      *
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
      *
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      WWCUST        ##CSNM           10
      *
      ***  Transaction Type
      *
     C                   PARM      DDLTYP        ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Booking branch
      *
     C                   PARM      DDBRCA        ##BRCA            3
      *
      ***  Receipt Date
      *
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
      *
     C                   PARM                    ##DATP            5 0
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYS
      *
      ***  Receive instructions
      *
     C                   PARM                    ##RECS
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIS
      *
      ***  Outputs
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
      *
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIF
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
      *
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
 
      *
      * If Part Sold, move Rec settl insts into Our start date settl insts
      *               and  Pay settl insts into Our maturity date settl insts
      *         else, the contrary
      *
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      FLPSTM        WSDST
     C                   MOVE      FLRSTM        WMDST
     C                   MOVE      FLPONS        WOSDA
     C                   MOVE      FLRONS        WOMDA
     C                   MOVEL     FLAWBN        WTSTN
     C                   MOVEL     FLRIBN        WTMAN
     C                   MOVE      FLPOBR        WOSDB
     C                   MOVE      FLROBR        WOMDB
      *  Part Sold
     C                   ELSE
     C                   MOVE      FLRSTM        WSDST
     C                   MOVE      FLPSTM        WMDST
     C                   MOVE      FLRONS        WOSDA
     C                   MOVE      FLPONS        WOMDA
     C                   MOVEL     FLRIBN        WTSTN
     C                   MOVEL     FLAWBN        WTMAN
     C                   MOVE      FLROBR        WOSDB
     C                   MOVE      FLPOBR        WOMDB
     C                   ENDIF
     C                   MOVEL     FLBENN        WFACO
      *
      ***  Extra validation after the Extended Settlements
      *
     C                   CALLB     'LECLIPEVL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode
      * Loan details screen 1 and 2
     C                   PARM                    NwLnScnFmt1
     C                   PARM                    NwLnScnFmt2
      ***  Generated by Principal Transfer from PT Midas input
     C                   PARM                    PGNTF             1
      ***  Pay Settlement Currency
     C                   PARM                    DDPSCY
      ***  Receive Settlement Currency                                                        CLE031
     C                   PARM                    DDRSCY                                       CLE031
      ***  Loan Type                                                                          CLE031
     C                   PARM                    LoanType                                     CLE031
 
      * OUTPUTS
 
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKLnScn1
     C                   PARM                    OKLnScn2
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ***  Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      ***  Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      ***  Shared data
     C                   PARM                    TransData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      *
      ***  Update loan in file format
      *
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on settlement details
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      ***  Exit from settlement details
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
 
      ** If loan is not a participation sold
 
     C     LoanType      IFNE      'PTSO'
      *
      ** ... set up date of receipt.
      ** It is next interest date or next repayment date.
      ** If date receipt still zero, use maturity date if present,
      ** otherwise, use midas rundate
      *
     C                   Z-ADD     *ZERO         ##DATR
     C     WSVRP         IFGT      WSVID
     C     WSVID         IFGT      *ZERO
     C                   Z-ADD     WSVID         ##DATR
     C                   ENDIF
     C                   ELSE
     C     WSVRP         IFGT      *ZERO
     C                   Z-ADD     WSVRP         ##DATR
     C                   ENDIF
     C                   ENDIF
     C     ##DATR        IFEQ      *ZERO
     C     WSVMD         IFGT      *ZERO
     C                   Z-ADD     WSVMD         ##DATR
     C                   ELSE
     C                   Z-ADD     BJRDNB        ##DATR
     C                   ENDIF
     C                   ENDIF
      *
      ** .. set up date of payment
      *
     C                   Z-ADD     WSVVD         ##DATP
 
     C                   ELSE
      *
      ** ... set up date of payment.
      ** It is next interest date or next repayment date.
      ** If date receipt still zero, use maturity date if present,
      ** otherwise, use midas rundate
      *
     C                   Z-ADD     *ZERO         ##DATP
     C     WSVRP         IFGT      WSVID
     C     WSVID         IFGT      *ZERO
     C                   Z-ADD     WSVID         ##DATP
     C                   ENDIF
     C                   ELSE
     C     WSVRP         IFGT      *ZERO
     C                   Z-ADD     WSVRP         ##DATP
     C                   ENDIF
     C                   ENDIF
     C     ##DATP        IFEQ      *ZERO
     C     WSVMD         IFGT      *ZERO
     C                   Z-ADD     WSVMD         ##DATP
     C                   ELSE
     C                   Z-ADD     BJRDNB        ##DATP
     C                   ENDIF
     C                   ENDIF
      *
      ** .. set up date of receipt
      *
     C                   Z-ADD     WSVVD         ##DATR
 
     C                   ENDIF
      *
      ** .. set up customer
      *
     C     LoanType      IFNE      'PTPU'
     C                   MOVEL     WSVCN         WWCUST           10
     C                   ELSE
     C                   MOVEL     DDCUST        WWCUST
     C                   END
      *
      ***  Set up payment instructions from loan
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     CLPSTM        FLPSTM                                       CGL029
     C                   MOVEL     CLCVMR        FLCVMR
     C                   MOVEL     CLSCCY        FLPSCY
     C                   MOVEL     CLICCY        FLIC72
      *
      * If not a Part Sold, pay branch is our start date branch
      * If Part Sold, pay branch is our maturity date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CLOSDB        FLPOBR
     C                   ELSE
     C                   MOVE      CLOMDB        FLPOBR
     C                   ENDIF
      *
      ***  Set up receive instructions from loan
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     CLRSTM        FLRSTM                                       CGL029
     C                   MOVEL     CLSCCY        FLRSCY
      *
      * If not a Part Sold, receive branch is our maturity date branch
      * If Part Sold, receive branch is our start date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CLOMDB        FLROBR
     C                   ELSE
     C                   MOVE      CLOSDB        FLROBR
     C                   ENDIF
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     CLREXR        FLREXR                                       CLE031
     C                   Z-ADD     CLPEXR        FLPEXR                                       CLE031
     C                   MOVE      CLREXI        FLREXI                                       CLE031
     C                   MOVE      CLPEXI        FLPEXI                                       CLE031
     C                   MOVE      CLSCCY        FLRSCY                                       CLE031
     C                   MOVE      CLPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
      *
      ***  If settlement instructions are not defined,
      ***  and payment/receipt dates are ,no in the past, default them
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan Type
      *
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Version of ISDA Rules govern
      *
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
      *
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
      *
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
      *
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
      *
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
      *
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIF
      *
     C                   END
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
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * 0ANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ***  Continue with the appropriate screen
      *
     C     @SCRN         IFEQ      'S'
     C     SaveSCRN      ANDEQ     '2'
     C                   MOVEL     'Y'           DoneSettl         1
     C                   ELSE
     C                   MOVEL     '3'           @SCRN
     C                   END
     C     SaveSCRN      IFNE      *BLANKS
     C                   MOVEL     SaveSCRN      @SCRN
     C                   MOVEL     *BLANKS       SaveSCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen                  *
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      ***  If settlement details invalid
      ***  or errors found in extra validation
      *
     C     ##RTCD        IFEQ      '*ERRORS'
     C     Idx           ORNE      *ZERO
      *
      ***  Return to second details screen
      *
     C                   MOVEL     '2'           @SCRN
     C                   ELSE
      *
      ***  Display the details screen 3
      *
     C                   MOVEL     '3'           @SCRN
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         CLPAY
     C                   MOVEL     FLPONS        CLPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        CLPSTM                                       CGL029
     C                   MOVEL     FLCVMR        CLCVMR
     C                   MOVEL     FLPSCY        CLSCCY
     C                   MOVEL     FLIC72        CLICCY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         CLREC
     C                   MOVEL     FLRONS        CLRECEx                                      CGL029
     C                   MOVEL     FLRSTM        CLRSTM                                       CGL029
     C                   MOVE      FLRSCY        CLSCCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        CLREXR                                       CLE031
     C                   Z-ADD     FLPEXR        CLPEXR                                       CLE031
     C                   MOVE      FLREXI        CLREXI                                       CLE031
     C                   MOVE      FLPEXI        CLPEXI                                       CLE031
     C                   MOVE      FLRSCY        CLSCCY                                       CLE031
     C                   MOVE      FLPSCY        CLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      * UPDATE VALID Loan: OUR START DATE & OUR MATURITY DATE INSTRUCTIONS
      *
     C                   MOVE      WSDST         CLSDST
     C                   MOVEL     WOSDA         CLOSDA
     C                   MOVE      WOMDB         CLOMDB
     C                   MOVEL     WTSTN         CLTSTN
 
     C                   MOVE      WMDST         CLMDST
     C                   MOVEL     WOMDA         CLOMDA
     C                   MOVE      WOSDB         CLOSDB
     C                   MOVEL     WTMAN         CLTMAN
     C                   MOVEL     WFACO         CLFACO
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEL0665'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LECLIP1DP'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Loan (in screen format)
      *
     C                   PARM                    NwLnScnFmt1
      *
      ***  Fields in error
      *
     C                   PARM                    OKLnScn1
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKI
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIDN
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  Loan record Id
      *
     C                   PARM                    PLnRcdId
      *
      ***  Output parameters
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKLnScn1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen                        *
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to fourth details screen
      *
     C                   MOVEL     '4'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@A
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen                        *
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
     C     WIdx          ANDEQ     *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     '1'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@A
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@A
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates                                              *
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ***  Get the next available loan number
      ***  If action is I and DDLNRF still blank
      *
     C     DDACTN        IFEQ      'I'
     C     DDLNRF        ANDEQ     *BLANKS
     C                   CALL      'AOLENOU0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @PRANG            2
     C     SDLENO        PARM      SDLENO        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDLENOPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @PRANG        DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C     F9NALN        SUB       1             F9NALN
     C                   MOVE      F9NALN        DDLNRF
     C                   END
      *
     C                   MOVEL     DDLNRF        @SIDN
      *
      ***  Update valid loan: loan reference
      *
     C                   MOVE      DDLNRF        CLLNRF
     C                   MOVE      DDLNRF        K_CLLNRF
      *
      ***  Update valid loan: Last action code
      *
     C                   MOVEL     DDACTN        CLCHTP
     C                   MOVEL     DDACTN        K_CLCHTP
      *
     C                   CALLB     'LECLIPUPD'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    @PRang
     C                   PARM                    PPTIN             1
     C                   PARM                    PGNTF             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
     C                   PARM                    W#SEQ             4 0
                                                                                              CDE005
      ** Reservation ID (input from VU only)                                                  CDE005
     C                   PARM                    ResrvId          10                          CDE005
                                                                                              CDE005
      ** Calling module                                                                       CDE005
     C                   PARM                    CallModCode       3                          CDE005
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    @DEPI                                      MD030621
     C/COPY WNCPYSRC,LECLIPS010
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*RECUPD'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                      LLN022A
      ** Prepare data to be updated to the extension file if BOE installed.                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      LVLNRF = BYLNRF                                           LLN022A
     C                   EVAL      LVLNTP = BYLNTP                                           LLN022A
     C                   EVAL      LVFMAT = BYFMAT                                           LLN022A
      *                                                                                      LLN022A
      ** Call LEPCLIPUPD1                                                                    LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPUPD1'                                              LLN022A
     C                   PARM                    @RTCD                                       LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    ValidCLIPEx                                 LLN022A
      *                                                                                      LLN022A
      ** If there were any errors in the update functions, rollback any                      LLN022A
      ** updates and end this pgm, otherwise commit the updates                              LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFNE      *BLANK                                                    LLN022A
     C     @RTCD         ANDNE     '*RECUPD'                                                 LLN022A
     C     @RTCD         ANDNE     '*RECLCK'                                                 LLN022A
     C                   ROLBK                                                               LLN022A
     C                   EXSR      *PSSR                                                     LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** If update not done due to record has been updated by another                        LLN022A
      ** workstation, send message to screen.                                                LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFEQ      '*RECUPD'                                                 LLN022A
     C                   EVAL      Idx              = Idx + 1                                LLN022A
     C                   EVAL      MsgIdArr   (Idx) = 'ER99919'                              LLN022A
     C                   EVAL      FldNameArr (Idx) = '*ANY'                                 LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** If update not done due to record being locked by another                            LLN022A
      ** workstation, send message to screen.                                                LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFEQ      '*RECLCK'                                                 LLN022A
     C                   EVAL      Idx              = Idx + 1                                LLN022A
     C                   EVAL      MsgIdArr   (Idx) = 'ERL0950'                              LLN022A
     C                   EVAL      FldNameArr (Idx) = '*ANY'                                 LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      ***  If update not done due to record being updated by another
      ***  workstation send message to screen.
      *
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEL0666'     MsgIdArr(1)
     C
     C                   END
     C
      *
      ***  Blank all detail screens
      *
     C                   MOVEL     *BLANKS       NwLnScnFmt1
     C                   MOVEL     *BLANKS       NwLnScnFmt2
     C                   MOVEL     *BLANKS       NwLnScnFmt3
     C                   MOVEL     *BLANKS       NwLnScnFmt4
     C                   MOVEL     *BLANKS       SaveDDACTN
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to first details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program                                            *
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       LLN022
      ** Issue rollback to clear any possible updates in the window                           LLN022
      **  function                                                                            LLN022
      *                                                                                       LLN022
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM      *BLANKS       @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIPSIN'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '004'         DBASE                          * DBERR 004 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
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
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
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
      *
      ***  Start with the details screen '1'
      *
     C                   MOVEL     '1'           @SCRN             1
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
      *
      ***  Check type of processing
      *
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
      *
      ***  Hook to enable non-core initial processing to be included
      *
 
     C                   EVAL      @RTCD = *BLANKS
 
      /COPY WNCPYSRC,LECLIPS009
      *
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        @RTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LECLIPSIN'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 005                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
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
                                                                                             LLN022A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       LLN022
      *                                                                                       LLN022
     C     WINDOW        BEGSR                                                                LLN022
      *                                                                                       LLN022
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVEL     DDLNRF        BYLNRF                                      LLN022A
     C                   Z-ADD     CLMDAT        BYMDTE                                      LLN022A
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'                                                   LLN022
     C                   PARM      'LECLIPSIN'   #PGM             10                          LLN022
     C                   PARM                    FKEY              2                          LLN022
     C                   PARM      DDACTN        ACTION            1                          LLN022
     C                   PARM                    DATA                                         LLN022
     C                   PARM      *BLANKS       #RTRN             7                          LLN022
     C                   PARM                    SPAREW          256                          LLN022
      *                                                                                       LLN022
     C     #RTRN         IFEQ      'Y2U9999'                                                  LLN022
     C                   EXSR      ENDP                                                       LLN022
     C                   ELSE                                                                 LLN022
      *                                                                                       LLN022
     C     #RTRN         IFEQ      'USR0790'                                                  LLN022
     C                   MOVEL     '4'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
      *                                                                                       LLN022
     C                   SELECT                                                               LLN022
     C     DDACTN        WHENEQ    'E'                                                        LLN022
     C                   IF        @RDNB = 'Y'                                                LLN022
     C                   MOVEL     'R'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     '1'           @SCRN                                        LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C     @RDNB         IFEQ      'R'                                                        LLN022
     C                   MOVEL     'R'           @SCRN                                        LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C     DDACTN        WHENEQ    'I'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
      *                                                                                       LLN022
     C     DDACTN        WHENEQ    'A'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
      *                                                                                       LLN022
     C     DDACTN        WHENEQ    'X'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
      *                                                                                       LLN022
     C     DDACTN        WHENEQ    'Q'                                                        LLN022
     C     CLE030        ANDEQ     'Y'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
     C                   ENDSL                                                                LLN022
      *                                                                                       LLN022
     C                   ENDIF                                                                LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSR                                                                LLN022
      *****************************************************************                       LLN022
      /EJECT                                                                                  LLN022
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
