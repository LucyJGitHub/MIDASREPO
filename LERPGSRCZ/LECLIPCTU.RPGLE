     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Control')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPCTU - Customer Loans Control Update                    *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             Loan                                              *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD030621           Date 26Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 AR868380           Date 11Jun13               *
      *                 AR910559           Date 10Dec12               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247441             Date 20Jul07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246345             Date 12Mar07               *
      *                 BUG13843           Date 02May07               *
      *                 245227             Date 27Feb07               *
      *                 GBO020             Date 07Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11340           Date 04May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9173            Date 07Nov05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9221            Date 16Nov05               *
      *                 BUG8526            Date 27Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA023             Date 22Mar04               *
      *                 225959             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CDE005             Date 23Sep02
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 26Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD030621 - Pass @DEPI (Decrease Principal indicator) for PDCL*
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR910559 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Add @ACTRV*
      *             parameter in LECLIP5VL. (Child: AR910560)         *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  245273 - Added parameter to LECLIPRTV and LECLIPUPD call.    *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246345 - CER001 Update Must not start when PretCode is not   *
      *           blanks - to avoid erroneous handling of commitment  *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIP1VL, LECLIPUPD*
      *  GBO020 - Debt Classification by Assets.                      *
      *           Added hook LECLIPCT18 (in lieu of LECLIPCT16)       *
      *  BUG11340  - Pameter mismatch in calling LECLIP3VL.           *
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
      *  BUG9173- Could not authorise loan coming from valid file     *
      *           updater.                                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG9221 - Added parameter Infdata on LECLIP2VL.              *
      *  BUG8526- Facility Currency Exchange Rate should be used, if  *
      *           entered, in the calculation of the Facility         *
      *           Repayment amount.                                   *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPCT16,LECLIPCT17              *
      *           Core hooks amended:LECLIPCT02                       *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  225959 - Missing CAS00x changes                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CDE005   Reservation ID                                      *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
 
     FLEVCLLX1PDUF   E             DISK    INFSR(*pssr)                                       CER001
     F                                     RENAME(LEVCLIPF6:VCLIPD6)                          CER001
      *                                                                                       CER001
      ** Midas LE Customer Loans LUX Valid File Layout                                        CER001
      *                                                                                       CER001
     FLEICLLX1PDUF A E             DISK    INFSR(*pssr)                                       CER001
     F                                     RENAME(LEICLIPF6:ICLIPD6)                          CER001
      *                                                                                       CER001
      ** Midas LE Customer Loans LUX Invalid File Layout                                      CER001
      *                                                                                       CER001
     FLEICLIPPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIPCT01
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
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LECLI1PD)
     D TranInSeco    E DS                  EXTNAME(LECLI2PD)
     D TranInThir    E DS                  EXTNAME(LECLI3PD)
     D TranInFour    E DS                  EXTNAME(LECLI4PD)
 
      * Error indicators
     D OKClPrim      E DS                  EXTNAME(LEECLI1PD)
     D OKClSeco      E DS                  EXTNAME(LEECLI2PD)
     D OKClThir      E DS                  EXTNAME(LEECLI3PD)
     D OKClFour      E DS                  EXTNAME(LEECLI4PD)
 
      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
     D***ClipFilREC           459    527                                                      CGL029
     D***ClipFilPAY           528   1086                                                      CGL029
     D  ClipFilREC           473    527                                                       CGL029
     D  ClipFilPAY           542   1086                                                       CGL029
     D  ClipFilRECEx        1597   1614                                                       CGL029
     D  ClipFilPAYEx        1615   1632                                                       CGL029
      * Customer Loans record CK in file Format
     D ClikFilFmt    E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(CK_)
 
      * Valid Customer Loans CL layout
     D ValidClil     E DS                  EXTNAME(LEVCLILPD)
     D                                     PREFIX(VL_)
     D***ValidREC             459    527                                                      CGL029
     D***ValidPAY             528   1086                                                      CGL029
     D  ValidREC             473    527                                                       CGL029
     D  ValidPAY             542   1086                                                       CGL029
     D***ValidRECEx          1579   1596                                               CGL029 TDA023
     D***ValidPAYEx          1597   1614                                               CGL029 TDA023
     D  ValidRECEx          1597   1614                                                       TDA023
     D  ValidPAYEx          1615   1632                                                       TDA023
 
      * Valid Customer Loans CK layout
     D ValidClik     E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(VK_)
 
      * File Receive instructions
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
      * File Payment instructions
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
      * File Fra/irs instructions
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
 
      * Curent Screen Receive instructions
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
 
      * Current Screen Payment instructions
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
 
      * FRA/IRS Settlement Instructions - Current
     D C_FRI         E DS                  EXTNAME(SDESSFPD) PREFIX(C_)
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
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
      **  are valid
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
 
      * (Current) Customer Loans in Screen Format - Primary Details
     D CurClPrim     E DS                  EXTNAME(LECLI1PD)
     D                                     PREFIX(C_)
      * (Current) Customer Loans in Screen Format - Secondary Details
     D CurClSeco     E DS                  EXTNAME(LECLI2PD)
     D                                     PREFIX(C_)
      * (Current) Customer Loans in Screen Format - Third Details
     D CurClThir     E DS                  EXTNAME(LECLI3PD)
     D                                     PREFIX(C_)
      * (Current) Customer Loans in Screen Format - Fourth Details
     D CurClFour     E DS                  EXTNAME(LECLI4PD)
     D                                     PREFIX(C_)
 
     D ExtData       E DS                  EXTNAME(LECLEXPD)
     D RegData       E DS                  EXTNAME(LECLRXPD)                                  CER001
      * LE (CLIP) Extra Data - File (D/B) format
 
     D InfData       E DS                  EXTNAME(LELEIFPD)                                 BUG9221
      * LE Extra Data - Classe 1 Data - File (D/B) format                                    BUG9221
     D                                     PREFIX(IF_)                                       BUG9221
      * Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * IN Message Format
     D P#INMF        E DS                  EXTNAME(LEN1MFPD)
 
      * OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEN2MFPD)
 
     D P#INEX        E DS                  EXTNAME(LENLX1PD)                                  CER001
      *                                                                                       CER001
      ** ER Loans/Part Purch Extra data Msg Format                                            CER001
      *                                                                                       CER001
     D  TransData      DS           500
      * Shared data
 
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
     D**PMFC****             457    462  0                                                    CSD027
     D  ANUM                 445    450A                                                      CSD027
     D  CNUMF                451    456A                                                      CSD027
     D  PMFC                 457    462A                                                      CSD027
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D  WLIND                471    473
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721
                                                                                              CER001
     D  ULX004         S              1A                                                      CER001
     D  PRetCode       S              7A                                                      CER001
     D  PActn          S              1A                                                      CER001
     D  PFrontID       S             20A                                                      CER001
     D**PloanNum       S              6  0                                             CER001 CLE148
     D  PloanNum       S              6                                                       CLE148
 
     D  DataOldRcd     DS           500
      * Fields used in setting confirmation indicators (old record)
 
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
 
     D  DataNewRcd     DS           500
      * Fields used in setting confirmation indicators (new record)
 
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
      *                                                                                       CER001
     D  PDATA          DS          1024                                                       CER001
     D   #1LNRF                1      6                                                       CER001
     D   #1CUST                7     12                                                       CER001
     D   #1PTYP               13     14                                                       CER001
     D   #1CCY                15     17                                                       CER001
     D   #1AMNT               18     32  0                                                    CER001
      *                                                                                       CER001
     D   #PSUBR              139    139                                                       CER001
     D   #PMOBL              140    149                                                       CER001
     D   #PRISC              150    151                                                       CER001
     D   #PIMEX              152    152                                                       CER001
     D   #PPPSC              153    158                                                       CER001
     D   #PCOAM              159    173                                                       CER001
     D   #PDGRI              174    174                                                       CER001
     D   #PIM93              175    175                                                       CER001
     D   #PCLAT              176    176                                                       CER001
     D   #PGUAC              177    177                                                       CER001
     D   #PLUSU              178    179                                                       CER001
      *                                                                                       CER001
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLLX1PD)                                CER001
      *                                                                                       CER001
      ** LE Customer Loans valid file                                                         CER001
      *                                                                                       CER001
     D OKCLEXFlags   E DS                  EXTNAME(LEECLLX1PD)                                CER001
      *                                                                                       CER001
      ** LE Customer Loans error definition                                                   CER001
      *                                                                                       CER001
     D CLIPExFilFmt  E DS                  EXTNAME(LECLX1PD)                                  CER001
      *                                                                                       CER001
      ** ER Customer Loans extension file                                                     CER001
      *                                                                                       CER001
 
      *  Timestamp for the transaction
     D TimeStamp       S             26Z
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
 
      /COPY WNCPYSRC,LECLIPCT02
      /EJECT
      *****************************************************************
     C
      * Start of Main processing
 
      * Initialisation
      /COPY WNCPYSRC,LECLIPCT03
     C                   EXSR      INITPR
      /COPY WNCPYSRC,LECLIPCT04
 
      * Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
      /COPY WNCPYSRC,LECLIPCT05
 
      * Validate action code
 
     C                   EXSR      ValidateAc
 
      * If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateTR
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EXSR      ValidateSt
 
     C                   WHEN         DDACTN = 'A'
      *  Processing for Amends or Changes
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTR
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EXSR      ValidateSt
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      * Do updates for this transaction
      * according to whether it is valid or invalid
 
     C     Idx           IFEQ      0
      /COPY WNCPYSRC,LECLIPCT11
     C                   EXSR      UPDAT_VAL
      /COPY WNCPYSRC,LECLIPCT12
     C                   ENDIF
     C     Idx           IFNE      0
      /COPY WNCPYSRC,LECLIPCT13
     C                   EXSR      UPDAT_INVAL
      /COPY WNCPYSRC,LECLIPCT14
     C                   ENDIF
 
      * Terminate program
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *   Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPFLD        BEGSR
 
     C                   MOVEL     N1MSGT        LoanType
 
     C                   MOVEL     N1RPLC        RPLOC             1
 
     C                   CLEAR                   TranInPrim
     C                   CLEAR                   TranInSeco
     C                   CLEAR                   TranInThir
     C                   CLEAR                   TranInFour
 
     C                   MOVE      N1ACTN        DDACTN
 
     C*****N1LNRF        IFNE      0                                                          CLE148
     C     N1LNRF        IFNE      *BLANKS                                                    CLE148
     C                   MOVE      N1LNRF        DDLNRF
     C                   ELSE
     C                   MOVE      *BLANK        DDLNRF
     C                   ENDIF
 
     C     N1MSGT        IFNE      'PTPU'
     C                   MOVEL     N1CNUM        DDCUST
     C                   MOVEL     N1CNUM        DDPFRM
     C                   ELSE
     C                   MOVEL     N1ORBO        DDCUST
     C                   MOVEL     *BLANKS       DDPFRM
     C                   END
 
     C                   MOVEL     N1BRCA        DDBRCA
     C                   MOVEL     N1ORBR        DDORBR
     C                   MOVEL     N1LTYP        DDLTYP
     C                   MOVEL     N1SUTP        DDSUTP
     C                   MOVEL     N1DDAT        DDDDAT
     C                   MOVEL     N1VDAT        DDVDAT
     C                   MOVEL     N1MDAT        DDMDAT
     C                   MOVEL     N1FCUS        DDFCUS
     C                   MOVEL     N1FTYP        DDFTYP
     C                   MOVEL     N1FSEQ        DDFSEQ
     C                   MOVEL     N1CCY         DDCURR
     C                   MOVEL     N1CPAM        DDCPAM
     C                   MOVEL     N1AUTO        DDAUTO
     C                   MOVEL     N1MDAT        DDMDAT
     C                   MOVEL     N1APMI        DDAPMI
     C                   MOVEL     N1BOKC        DDBOKC
     C                   MOVEL     N1PTFR        DDPTFR
     C                   MOVEL     N1PRFC        DDPRFC
     C                   MOVEL     N1LASQ        DDACSQ
     C                   MOVEL     N1INTC        DDINTC
     C                   MOVEL     N1ADDI        DDADDI
     C                   MOVEL     N1ICBS        DDCALC
     C                   MOVEL     N1BRTT        DDBRTT
     C                   MOVEL     N1RTSP        DDRTSP
     C                   MOVEL     N1PTFR        DDPTFR
     C                   MOVEL     N1SPIN        DDSPIN
     C                   MOVEL     N1CHIN        DDCHIN
     C                   MOVEL     N1MARG        DDMARG
     C                   MOVEL     N1NMI         DDNEGV
     C                   MOVEL     N1RDFC        DDRDFC
     C                   MOVEL     N1CHIN        DDCHIN
     C                   MOVEL     N1WTIN        DDWTIN
     C                   MOVEL     N1WTRT        DDWTRT
     C                   MOVEL     NNIPFR        DDIPFR
     C                   MOVEL     N1IFDY        DDIFDY
     C                   MOVEL     N1NIDT        DDNIDT
     C                   MOVEL     N1REPT        DDREPT
     C                   MOVEL     N1RAMT        DDRAMT
     C                   MOVEL     N1RFRQ        DDRFRQ
     C                   MOVEL     N1RDYN        DDRDYN
     C                   MOVEL     N1NRPD        DDNRPD
     C                   MOVEL     N1LIND        DDLIND
     C                   MOVEL     N1FRBC        DDFRBC
     C                   MOVEL     N1CRSK        DDCRSK
     C                   MOVEL     N1ACOF        DDACOF
     C                   MOVEL     N1NACD        DDNACD
     C                   MOVEL     N1FEEI        DDFEEI
     C                   MOVEL     N1DOCI        DDDOCI
     C                   MOVEL     N1SECI        DDSECI
 
     C                   EVAL      DDNAR1= %SUBST(N1LDSC:1:35)
     C                   EVAL      DDNAR2= %SUBST(N1LDSC:36:35)
     C                   EVAL      DDNAR3= %SUBST(N1LDSC:71:35)
     C                   EVAL      DDNAR4= %SUBST(N1LDSC:106:35)
 
     C                   MOVEL     N1BMDI        DDBMIN
     C                   MOVEL     N1BCXR        DDBCXR
     C                   MOVEL     N1FMDI        DDFMIN
     C                   MOVEL     N1FCXR        DDFCXR
     C                   MOVEL     N1RECE        DDRECE
     C                   MOVEL     N1COCU        DDCOCU
     C                   MOVEL     N1OMDT        DDOMDT
     C                   MOVEL     N1RLFQ        DDRLFQ
     C                   MOVEL     N1RLDY        DDRLDY
     C                   MOVEL     N1RLDT        DDRLDT
     C                   MOVEL     N1BTIN        DDBTIN
     C                   MOVEL     N1BLDY        DDBLDY
     C                   MOVEL     N1RCSI        DDRCSI
     C                   MOVEL     N1RLDY        DDRLDY
     C     N1MSGT        IFEQ      'PTPU'
     C                   MOVEL     N1SLNO        DDMLNR
     C                   ELSE
     C                   MOVEL     *BLANKS       DDMLNR
     C                   END
 
     C     N1MSGT        IFEQ      'PTSO'
     C                   MOVEL     N1SLNO        DDOLNO
     C                   ELSE
     C                   MOVEL     *BLANKS       DDOLNO
     C                   END
 
     C                   MOVEL     N1FSRP        DDFRSP
     C                   MOVEL     N1FSGN        DDFSGN
     C                   MOVEL     N1FPRC        DDFPRC
 
     C                   EVAL      DDSPI1= %SUBST(N1SPI1:1:30)
     C                   EVAL      DDSPI2= %SUBST(N1SPI1:31:30)
     C                   EVAL      DDSPI3= %SUBST(N1SPI1:61:30)
 
     C                   MOVEL     N1LNKS        DDLNKS
     C                   MOVEL     N1GASS        DDASSN
     C                   MOVEL     N1DFTP        DDDFTP
     C                   MOVEL     N1DFST        DDDFST
     C                   MOVEL     N1MCRA        DDMCRA
     C                   MOVEL     N1FCRA        DDFCRA
     C                   MOVEL     N1PDDI        DDPDDI
     C                   MOVEL     N1PTDI        DDPTDI
     C                   MOVEL     N1GDPR        DDGDPR
     C                   MOVEL     N1GDIN        DDGDIN
     C                   MOVEL     N1RFDY        DDRFDY
     C                   MOVEL     N1YLDC        DDYLDC                                       225959
     C                   MOVEL     N1FYLD        DDFYLD                                       225959
 
      * Receive instructions
 
     C                   CLEAR                   ##RECS
     C                   MOVE      N1RSTM        DDRSTM
     C                   MOVE      N1RONS        DDRONX
     C                   MOVE      N1RIBN        DDRIBN
     C                   MOVE      N1RIBA        DDRIBA
     C                   MOVE      N1ROBN        DDROBN
     C                   MOVE      N1ROCN        DDROCN
     C                   MOVE      N1SCCY        DDRSCY
 
      * Payment instructions
 
 
     C                   CLEAR                   ##PAYS
     C                   MOVE      N1PSTM        DDPSTM
     C                   MOVE      N1PONS        DDPONX
     C                   MOVE      N1PIBN        DDPIBN
     C                   MOVE      N1PIBA        DDPIBA
     C                   MOVE      N1POBN        DDPOBN
     C                   MOVE      N1POCN        DDPOCN
     C                   MOVE      N1CVMR        DDCVMR
     C                   MOVE      N1RCRN        DDRCRN
     C                   MOVE      N1RCRA        DDRCRA
     C                   MOVE      N1RVNO        DDRVNO
     C                   MOVE      N1AWBN        DDAWBN
     C                   MOVE      N1AWBA        DDAWBA
     C                   MOVE      N1BENN        DDBENN
     C                   MOVE      N1BENA        DDBENA
     C                   EVAL      DDDTP1= %SUBST(N1DTP1:1:35)
     C                   EVAL      DDDTP2= %SUBST(N1DTP1:36:35)
     C                   EVAL      DDDTP3= %SUBST(N1DTP1:71:35)
     C                   EVAL      DDDTP4= %SUBST(N1DTP1:106:35)
     C                   MOVE      N1DCHG        DDDCHG
     C                   EVAL      DDBTB1= %SUBST(N1BTB1:1:35)
     C                   EVAL      DDBTB2= %SUBST(N1BTB1:36:35)
     C                   EVAL      DDBTB3= %SUBST(N1BTB1:71:35)
     C                   EVAL      DDBTB4= %SUBST(N1BTB1:106:35)
     C                   EVAL      DDBTB5= %SUBST(N1BTB1:140:35)
     C                   EVAL      DDBTB6= %SUBST(N1BTB1:176:35)
     C                   MOVE      N1SCCY        DDPSCY
     C                   MOVE      N1ICCY        DDIC72
      *                                                                                      BUG9173
      ** Set user field depending on action                                                  BUG9173
      *                                                                                      BUG9173
     C                   SELECT                                                              BUG9173
                                                                                             BUG9173
     C                   WHEN         DDACTN = 'I'                                           BUG9173
     C                   EVAL         F1IUSR = N1IUSR                                        BUG9173
     C                   WHEN         DDACTN = 'X'                                           BUG9173
     C                   EVAL         F1XUSR = N1XUSR                                        BUG9173
     C                   WHEN         DDACTN = 'Q'                                           BUG9173
     C                   EVAL         F1XUSR = N1XUSR                                        BUG9173
     C                   WHEN         DDACTN = 'A'                                           BUG9173
     C                   EVAL         F1AUSR = N1IUSR                                        BUG9173
                                                                                             BUG9173
     C                   ENDSL                                                               BUG9173
      *
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      N1SCCY        DDRSCY                                       CLE031
     C                   MOVE      N1REXR        DDREXR                                       CLE031
     C     N1REXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      N1REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDREXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      N1REXI        DDREXI                                       CLE031
     C     N1REXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      N1PSCY        DDPSCY                                       CLE031
     C                   MOVE      N1PEXR        DDPEXR                                       CLE031
     C     N1PEXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      N1PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      N1PEXI        DDPEXI                                       CLE031
     C     N1PEXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the LE database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LECLIPRTV'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      ' '           RespMode          1
      * Action, customer, facility type and facility number
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
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
     C                   PARM                    LoanType          4
 
      * (Current) Customer loan CL in file format
     C                   PARM                    ClilFilFmt
      * (Current) Customer loan CK in file format
     C                   PARM                    ClikFilFmt
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Customer Number
     C                   PARM                    DDLnrfOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr                                   225959
     C                   PARM                    WMsgIdArr                                    225959
     C                   PARM                    WMsgDtaArr                                   225959
     C                   PARM                    WIdx                                         225959
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPCT18
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Retrieve the extra details                                                           CER001
      *                                                                                       CER001
     C                   MOVE      DDACTN        PActn                                        CER001
     C                   EVAL      PFrontID = APFOTranID                                      CER001
     C                   MOVE      DDLNRF        PloanNum                                     CER001
      *                                                                                       CER001
     C                   CALLB     'LECLIP2RV'                                                CER001
     C                   PARM      *Blanks       PRetCode                                     CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PFrontID                                     CER001
     C                   PARM                    PLoanNum                                     CER001
     C                   PARM                    CLIPExFilfmt                                 CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,LECLIPCT16
 
     C                   Z-ADD     CL_TNLU       H#TNLU            5 0
     C                   Z-ADD     CL_CHGA       WCHGA                                       BUG3721
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   MOVE      DDACTN        VL_CLCHTP
     C                   MOVE      DDACTN        VK_CLCHTP
 
      * Validate Customer Loans details 1
 
     C                   EXSR      ValdTrPrim
 
      * If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Customer Loans details 2
 
     C                   EXSR      ValdTrSeco
 
      * If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Customer Loans details 3
 
     C                   EXSR      ValdTrThir
 
      * If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Customer Loans details 4
 
     C                   EXSR      ValdTrFour
 
      * If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      DDLNRF        #1LNRF                                       CER001
     C                   MOVEL     DDCUST        #1CUST                                       CER001
     C                   MOVE      VL_CLPTYP     #1PTYP                                       CER001
      *                                                                                       CER001
     C                   MOVE      DDCURR        #1CCY                                        CER001
     C                   MOVE      VL_CLCPAM     #1AMNT                                       CER001
      *                                                                                       CER001
     C                   MOVE      LKSUBR        #PSUBR                                       CER001
     C                   MOVE      LKMOBL        #PMOBL                                       CER001
     C                   MOVE      LK1UAC        #PGUAC                                       CER001
     C                   MOVE      LKPPSC        #PPPSC                                       CER001
     C                   MOVE      LKCOAM        #PCOAM                                       CER001
     C                   MOVE      LKIMEX        #PIMEX                                       CER001
     C                   MOVE      LKRISC        #PRISC                                       CER001
     C                   MOVE      LKIM93        #PIM93                                       CER001
     C                   MOVE      LKCLAT        #PCLAT                                       CER001
     C                   MOVE      LKLUSU        #PLUSU                                       CER001
     C                   MOVE      LKDGRI        #PDGRI                                       CER001
      *                                                                                       CER001
      ** Validate customer loans extension details                                            CER001
      *                                                                                       CER001
     C                   CALL      'LECLIP5VL'                                                CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKCLEXFlags                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidCLIPEx                                  CER001
     C                   PARM                    @ACTRV                                     AR910559
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
     C     EValidTr      ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * ValdTrPrim - Validate Customer Loans Primary details          *
      *                                                               *
      *****************************************************************
     C     ValdTrPrim    BEGSR
 
     C                   CALLB     'LECLIP1VL'
 
      * INPUTS
 
      * Response mode
     C                   PARM      ' '           RespMode          1
 
      * Primary Details
     C                   PARM                    TranInPrim
     C                   PARM                    InfData                                    AR804863
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType          4
     C                   PARM                    N1TRUS
     C                   PARM                    N1TRSN
     C                   PARM                    N1PCOB
     C                   PARM                    N1GPRT
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Screen Detail 2                                                                     BUG3721
     C                   PARM                    TranInSeco                                  BUG3721
                                                                                              CLE106
      ** Screen Detail 3                                                                      CLE106
     C                   PARM                    TranInThir                                   CLE106
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
 
      * OUTPUTS
 
      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    PRANG             2
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
      ***  (Current) loan in file format CL
     C                   PARM                    ClilFilFmt
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
                                                                                              247441
     C                   PARM                    ModeofOP          6                          247441
      ** Front Office ID                                                                    MD032052
     C                   PARM                    APFOTranID       20                        MD032052
                                                                                              247441
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSeco - Validate Customer Loans Secondary details        *
      *                                                               *
      *****************************************************************
     C     ValdTrSeco    BEGSR
 
     C                   CALLB     'LECLIP2VL'
      * INPUTS
 
      * Response mode
     C                   PARM      ' '           RespMode
 
      * Primary Details
     C                   PARM                    TranInSeco
      ** Loan details screen 3                                                               BUG8526
     C                   PARM                    TranInThir                                  BUG8526
     C                   PARM                    InfData                                     BUG9221
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    N1TRUS
     C                   PARM                    N1TRSN
     C                   PARM                    N1PCOB
     C                   PARM                    N1GPRT
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** (Current) loan in file format CL                                                    BUG3721
      ** Screen Detail 1                                                                     BUG3721
      ** Customer Loans Primary Details OK inds                                              BUG3721
     C                   PARM                    ClilFilFmt                                  BUG3721
     C                   PARM                    TranInPrim                                  BUG3721
     C                   PARM                    OKClPrim                                    BUG3721
 
      * OUTPUTS
 
      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClSeco
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrThir - Validate Customer Loans Third details            *
      *                                                               *
      *****************************************************************
     C     ValdTrThir    BEGSR
 
     C                   CALLB     'LECLIP3VL'
      * INPUTS
 
      * Response mode
     C                   PARM      ' '           RespMode
 
      * Primary Details
     C                   PARM                    TranInThir
      ** Interface Data file                                                                BUG11340
     C                   PARM                    InfData                                    BUG11340
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    N1TRUS
     C                   PARM                    N1TRSN
     C                   PARM                    N1PCOB
     C                   PARM                    N1GPRT
 
      * OUTPUTS
 
      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClThir
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrFour - Validate Customer Loans Fourth details           *
      *                                                               *
      *****************************************************************
     C     ValdTrFour    BEGSR
 
     C                   CALLB     'LECLIP4VL'
      * INPUTS
 
      * Response mode
     C                   PARM      ' '           RespMode
 
      * Primary Details
     C                   PARM                    TranInFour
      * Extra Data file data
     C                   PARM                    ExtData
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    N1TRUS
     C                   PARM                    N1TRSN
     C                   PARM                    N1PCOB
     C                   PARM                    N1GPRT
 
      * OUTPUTS
 
      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClFour
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR
 
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
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency (or Loan currency if only one currency on deal)
     C                   PARM      DDCURR        ##PCCY            3
      ** Receive currency (or Loan currency if only one currency on deal)
     C                   PARM      DDCURR        ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      WWCUST        ##CSNM           10
      ** Deal type
     C                   PARM      DDLTYP        ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      ** Booking Branch
     C                   PARM      DDBRCA        ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
      *
      * If Part Sold, move Rec settl instructions into Our start date settl instr
      *               and  Pay settl instructions into Our maturity date settl instr
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
     C                   PARM      ' '           RespMode
      * Loan details screen 1 and 2
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
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
     C                   PARM                    OKClPrim
     C                   PARM                    OKClSeco
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
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVEL     FLPONS        ValidPAYEx                                   CGL029
     C                   MOVEL     FLPSTM        VL_CLPSTM                                    CGL029
     C                   MOVE      FLCVMR        VL_CLCVMR
     C                   MOVE      FLPSCY        VL_CLSCCY
     C                   MOVE      FLIC72        VL_CLICCY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     FLRONS        ValidRECEx                                   CGL029
     C                   MOVEL     FLRSTM        VL_CLRSTM                                    CGL029
     C                   MOVE      FLRSCY        VL_CLSCCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        VL_CLREXR                                    CLE031
     C                   Z-ADD     FLPEXR        VL_CLPEXR                                    CLE031
     C                   MOVE      FLREXI        VL_CLREXI                                    CLE031
     C                   MOVE      FLPEXI        VL_CLPEXI                                    CLE031
     C                   MOVE      FLRSCY        VL_CLSCCY                                    CLE031
     C                   MOVE      FLPSCY        VL_CLPSCY                                    CLE031
     C                   ENDIF                                                                CLE031
      *
      * UPDATE VALID Loan: OUR START DATE & OUR MATURITY DATE INSTRUCTIONS
      *
     C                   MOVE      WSDST         VL_CLSDST
     C                   MOVEL     WOSDA         VL_CLOSDA
     C                   MOVE      WOSDB         VL_CLOSDB
     C                   MOVEL     WTSTN         VL_CLTSTN
 
     C                   MOVE      WMDST         VL_CLMDST
     C                   MOVEL     WOMDA         VL_CLOMDA
     C                   MOVE      WOMDB         VL_CLOMDB
     C                   MOVEL     WTMAN         VL_CLTMAN
     C                   MOVEL     WFACO         VL_CLFACO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      ** Setup work field                                                                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           WPRCS2            1                         BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     CL_RECI       ANDEQ     'D'                                                       BUG3721
     C     DDACTN        ANDEQ     'A'                                                       BUG3721
     C     CL_PTYP       ANDEQ     80                                                        BUG3721
     C     CL_VDAT       ANDLT     BJRDNB                                                    BUG3721
     C     CL_ORED       ANDNE     BJRDNB                                                    BUG3721
     C                   MOVE      'Y'           WPRCS2                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      * file record - fields in this will be updated during processing
 
     C                   MOVE      ClilFilFmt    ValidClil
     C                   MOVE      ClikFilFmt    ValidClik
 
      * For Amends, convert the customer loan to screen format 1
 
     C                   CALLB     'LECLIP1CT'
      * Inputs
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
 
      * Output parameters
      * Customer loans Details - screen formats 1
     C                   PARM                    CurClPrim
 
      * For Amends, convert the customer loan to screen format 2
 
     C                   CALLB     'LECLIP2CT'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
 
      * Output parameters
 
      * Customer loans Details - screen formats 2
     C                   PARM                    CurClSeco
 
      * For Amends, convert the customer loan to screen format 3
 
     C                   CALLB     'LECLIP3CT'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
 
      * Output parameters
 
      * Customer loans Details - screen formats 3
     C                   PARM                    CurClThir
 
      * For Amends, convert the customer loan to screen format 4
 
     C                   CALLB     'LECLIP4CT'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
 
      * Output parameters
 
      * Customer loans Details - screen formats 4
     C                   PARM                    CurClFour
 
      ***  Set up payment instructions from loan
 
     C                   MOVEL     ClipFilPAY    FLPAY
     C                   MOVEL     ClipFilPAYEx  FLPONS                                       CGL029
     C                   MOVEL     CL_PSTM       FLPSTM                                       CGL029
     C                   MOVE      CL_CVMR       FLCVMR
     C                   MOVE      CL_SCCY       FLPSCY
     C                   MOVE      CL_ICCY       FLIC72
      *
      * If not a Part Sold, pay branch is our start date branch
      * If Part Sold, pay branch is our maturity date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CL_OSDB       FLPOBR
     C                   ELSE
     C                   MOVE      CL_OMDB       FLPOBR
     C                   ENDIF
 
      ***  Set up receive instructions from loan
 
     C                   MOVEL     ClipFilREC    FLREC
     C                   MOVEL     ClipFilRECEx  FLRONS                                       CGL029
     C                   MOVEL     CL_RSTM       FLRSTM                                       CGL029
     C                   MOVE      CL_SCCY       FLRSCY
      *
      * If not a Part Sold, receive branch is our maturity date branch
      * If Part Sold, receive branch is our start date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CL_OMDB       FLROBR
     C                   ELSE
     C                   MOVE      CL_OSDB       FLROBR
     C                   ENDIF
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     CL_REXR       FLREXR                                       CLE031
     C                   Z-ADD     CL_PEXR       FLPEXR                                       CLE031
     C                   MOVE      CL_REXI       FLREXI                                       CLE031
     C                   MOVE      CL_PEXI       FLPEXI                                       CLE031
     C                   MOVE      CL_SCCY       FLRSCY                                       CLE031
     C                   MOVE      CL_PSCY       FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
      *  The sett instructions are in file format (retrieved on ValidateAc, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
 
      ** Current Settlement Instruction in input format
     C                   PARM                    C_Pay
     C                   PARM                    C_Rec
     C                   PARM                    C_FRI
     C                   PARM      C_DDCURR      #TRCCY                                      CSF011A
     C                   PARM      C_DDCURR      #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.
 
     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = C_Pay
     C                   ENDIF
 
     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = C_Rec
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
 
      * This subroutine calls procedures which check whether it
      * was valid to amend any of the fields which have been
      * changed.
 
      * First Screen
     C                   CALLB     'LECLIP1AD'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TranInPrim
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClPrim
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
 
      * OUTPUTS
 
      * Error Indicators
     C                   PARM                    OKClPrim
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      * If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      ENDVALAMD
     C                   ENDIF
 
      * Second Screen
     C                   CALLB     'LECLIP2AD'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TranInSeco
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClSeco
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
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
 
      * OUTPUTS
 
      * Error Indicators
     C                   PARM                    OKClSeco
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      * If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      ENDVALAMD
     C                   ENDIF
 
      * Third Screen
     C                   CALLB     'LECLIP3AD'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TranInThir
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClThir
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
 
      * OUTPUTS
 
      * Error Indicators
     C                   PARM                    OKClThir
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      * If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      ENDVALAMD
     C                   ENDIF
 
      * Fourth Screen
     C                   CALLB     'LECLIP4AD'
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TranInFour
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClFour
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
 
      * OUTPUTS
 
      * Error Indicators
     C                   PARM                    OKClFour
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      * If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C     ENDVALAMD     ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
 
      * For Reversed put the complete (pre-existing) Customer loans
      * into the Valid file record
     C                   IF        DDACTN = 'R' OR DDACTN = 'X'                               CLE030
     C                             OR DDACTN = 'Q'                                            CLE030
     C                   MOVE      ClilFilFmt    ValidClil
     C                   MOVE      ClikFilFmt    ValidClik
     C                   MOVE      DDACTN        VL_CLCHTP
     C                   MOVE      DDACTN        VK_CLCHTP
     C                   ENDIF
      *                                                                                      BUG9173
      ** Set user field depending on action                                                  BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'I'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1IUSR        VL_CLIUSR                                   BUG9173
     C                   MOVE      F1AUSR        VL_CLAUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ELSE                                                                BUG9173
     C                   MOVE      PSUSER        VL_CLIUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'X'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1IUSR        VL_CLIUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'A'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1AUSR        VL_CLAUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ELSE                                                                BUG9173
     C                   MOVE      PSUSER        VL_CLAUSR                                   BUG9173
     C                   MOVE      *BLANKS       VL_CLXUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
 
      * Update the database
 
     C                   EXSR      UPD_DBASE
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                             And PRetCode = *blanks                                     246345
      *                                                                                       CER001
     C                   CALLB     'LECLIP2UP'                                                CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PRetCode          7                          CER001
     C                   PARM                    PFind             1                          CER001
     C                   PARM                    ValidCLIPEx                                  CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
      * If there were errors, rollback any database changes and increment
      * the error index by 1 to drive the 'invalid' record processing
 
     C*****RetCodeOut    IFNE      *BLANK                                                     CER001
     C     PRetCode      IFNE      *BLANK                                                     CER001
 
     C                   ADD       1             Idx
 
     C     PRetCode      IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                 AR868380
     C                   EVAL      MsgIdArr(Idx) =  'LEL0817'                               AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   ROLBK
 
     C                   ELSE
 
      * Commit the database changes
 
     C                   COMMIT
 
      * Set up the returned message format
 
     C                   MOVE      N1MSGT        N2MSGT
     C                   MOVE      N1TRUS        N2TRUS
     C                   MOVE      N1TRWS        N2TRWS
     C                   MOVE      N1TNRF        N2TNRF
     C                   MOVE      N1TRSN        N2TRSN
     C                   MOVE      N1ACTN        N2ACTN
     C                   MOVE      N1TRDS        N2TRDS
     C                   MOVE      N1TRTS        N2TRTS
     C                   MOVE      N1NRBA        N2NRBA
     C                   MOVE      N1LNRF        N2LNRF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
 
      * If repair in back-office
 
     C     RPLOC         IFEQ      'B'
 
      * Write to the invalid (repair) files
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      DDMSGTYPE = 'CLIP'
     C                   EVAL      DDFOTRANID = N1TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'
     C                   EVAL      DDTMESTMP = TimeStamp
 
     C                   WRITE     LEICLIPD0
     C                   WRITE     APIDSETD0
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Write to invalid extension file LEICLLX1PD                                           CER001
      *                                                                                       CER001
     C                   MOVE      N1SUBR        LCSUBR                                       CER001
     C                   MOVE      N1MOBL        LCMOBL                                       CER001
     C                   MOVE      N1GUAC        LCGUAC                                       CER001
     C                   MOVE      N1PPSC        LCPPSC                                       CER001
     C                   MOVE      N1COAM        LCCOAM                                       CER001
     C                   MOVE      N1IMEX        LCIMEX                                       CER001
     C                   MOVE      N1RISC        LCRISC                                       CER001
     C                   MOVE      N1IM93        LCIM93                                       CER001
     C                   MOVE      N1CLAT        LCCLAT                                       CER001
     C                   MOVE      N1LUSU        LCLUSU                                       CER001
     C                   MOVE      N1DGRI        LCDGRI                                       CER001
     C                   MOVE      N1TNRF        LCFOID                                       CER001
     C                   MOVE      'B'           LCRPLC                                       CER001
     C                   MOVE      TimeStamp     LCTMSP                                       CER001
     C                   WRITE     ICLIPD6                                                    CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      W_ZATRNERR
 
      * Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      * Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM                    @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      * Set up the returned message format
 
     C                   MOVE      N1MSGT        N2MSGT
     C                   MOVE      N1TRUS        N2TRUS
     C                   MOVE      N1TRWS        N2TRWS
     C                   MOVE      N1TNRF        N2TNRF
     C                   MOVE      N1TRSN        N2TRSN
     C                   MOVE      N1ACTN        N2ACTN
     C                   MOVE      N1TRDS        N2TRDS
     C                   MOVE      N1TRTS        N2TRTS
     C                   MOVE      N1NRBA        N2NRBA
     C                   MOVEL     'E'           N2MSGS
     C                   MOVEL     ZAMSID        N2MSGI
     C                   MOVEL     ZAMSTX        N2MSTX
     C                   MOVE      N1LNRF        N2LNRF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
 
     C                   CALLB     'LECLIPUPD'
     C**********         PARM      *BLANK        RetCodeOut                                   CER001
     C                   PARM      *BLANKS       PRetCode                                     CER001
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
     C                   PARM                    @PRANG            2
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
     C/COPY WNCPYSRC,LECLIPCT17
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   MOVEL     DDMSGTYPE     ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = DDTMESTMP
 
      * Do while error messages found
      * Write error messages to file
 
     C                   Z-ADD     1             #C                2 0
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     FldNameArr(#C)ABFIELDNAM
     C                   MOVEL     MsgIdArr(#C)  ABMSGID
     C                   WRITE     ZATRNERRD0
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
     C                   PARM                    P#INEX                                       CER001
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621
 
     C                   EVAL      RegData = P#INEX                                           CER001
      *  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access API ICD via access program
      * (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
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
     C                   MOVEL     '903'         DBASE                          * DBERR 903 * CLE030
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
     C                   MOVEL     '907'         DBASE                          * DBERR 907 *BUG3721
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
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CER001
      ** Check if switchable feature ULX004 is installed.                                     CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '904'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
 
     C                   EVAL      @RTCD = *BLANKS
 
      /COPY WNCPYSRC,LECLIPCT15
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'D'           N2MSGS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
