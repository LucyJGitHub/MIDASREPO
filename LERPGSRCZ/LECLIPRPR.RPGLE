     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans input Repair')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPRPR - LE Customer Loans Input Repair                   *
      *                                                               *
      *  Function:  This is the screens input repair function for     *
      *             Customer Loans.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 MD030621           Date 26Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247441             Date 20Jul07               *
      *                 CPK028             Date 12Jun07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246165             Date 05Mar07               *
      *                 246163             Date 05Mar07               *
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
      *                 BUG9173            Date 07Nov05               *
      *                 BUG9076            Date 08Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9221            Date 16Nov05               *
      *                 BUG8526            Date 27Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 08Sep03               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 TDA023             Date 22Mar04               *
      *                 225959             Date 23Mar04               *
      *                 224261             Date 09Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 23Sep02               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 07Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LECLIPDTA,LECLIPRC01,LECLIPRC02    *
      *                            LECLIPRC03,LECLIPRMV1              *
      *  MD030621 - Pass @DEPI (Decrease Principal indicator) for PDCL*
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  CPK028 - Customer Number fields should be alpha.             *
      *  245273 - Added parameter to LECLIPRTV call.                  *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246165 - CAP086 - Missing in the below level                 *
      *           Add InfData on LECLIP1VL and LECLIP4VL parm list    *
      *  246163 - Warning messages are bloking the repair, change     *
      *           process to continue with warning message(s)         *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIP1VL, LECLIPUPD*
      *  BUG11340  - Pameter mismatch in calling LECLIP3VL.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha (Recompile)  *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9173 - Could not authorise loan coming from valid file    *
      *           updater.                                            *
      *  BUG9076 - Action 'N' updates the database files even with    *
      *            errors.                                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
      *           Core hooks added:LECLIPR015,LECLIPR016              *
      *           Core hooks amended:LECLIPR002                       *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
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
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FLEICLIPL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEICLIPD0 : LEICLIPX0)
     FLEICLIPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLEICLLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(LEICLIPF6:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FLECLX1L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(CLOANKF6:RTVIDX)                            CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIPR001
      *
     FLEICLIPY0 UF   E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(LEICLIX0 : ICLIPD0)                        LLN022A
                                                                                             LLN022A
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
     D/COPY QWINDSRC,LECLIPDTA                                                                LLN022
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
     D @EI             S              1    DIM(60)
 
      *
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
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
      *****************************
      ** Settlement instructions **
      *****************************
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** File payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS instructions
 
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen receive instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen payment instructions
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS instructions
 
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
      *
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ***  24X7 Data Structure
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)  DTAARA(SDSTAT)
      ***  SDSTAT Data Structure
 
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      ***  Pay Settlement Instructions - Current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      ***  Receive Settlement Instructions - Current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      ***  FRA/IRS Settlement Instructions - Current
 
 
     D @SETIN          DS
      ***  Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
      ***  Loan number ranges file
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
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
     D RegData       E DS                  EXTNAME(LECLRXPD)                                  CER001
      *                                                                                       CER001
     D CrDlFilFmt    E DS                  EXTNAME(LECLX1L0)                                  CER001
      ** Current Customer in File Format                                                      CER001
     D NwDlFilFmt    E DS                  EXTNAME(LEVCLLX1PD)                                CER001
      ** New Customer in File Format                                                          CER001
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
     D**NBRAM***             117    118  0                                                    CSD103
     D  NBRAM                117    118                                                       CSD103
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
      *                                                                                       CER001
     D  PDATA          DS          1024                                                       CER001
     D   #1LNRF                1      6                                                       CER001
     D   #1CUST                7     12                                                       CER001
     D   #1PTYP               13     14                                                       CER001
     D   #1CCY                15     17                                                       CER001
     D   #1AMNT               18     32  0                                                    CER001
     D   #1FOID               33     52                                                       CER001
     D   #1TMSP               53     78Z                                                      CER001
     D   #1DEXT               79     79                                                       CER001
      *
      ** +--------------------------------------+                                             CSC022
      **   Use of Indicator                                                                   CSC022
      **   ================                                                                   CSC022
      ** ¶                                      ¶                                             CSC022
      ** ¶ 17      Used by LOOKUP               ¶                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D***PLoanNo         S             18A                                                    CGL029
     D***PALoanNo        S             18A                                                    CGL029
     D PLoanNo         S             24A                                                      CGL029
     D PALoanNo        S             24A                                                      CGL029
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
      *                                                                                       CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      *                                                                                       CER020
      ** Field defined for enhancement CER048                                                 CER020
      *                                                                                       CER020
     D WHit            S              1P 0 INZ(0)                                             CER020
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ***  -------------------------------------------------------------------
      ***  Fields for getting the starting field number from file (parameters
      ***  to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LECLIPPD')
      *
     D Field           S             10A   INZ('DDACTN')
      *
     D FieldNo         S              5P 0
      *
     D FldOffset       S              5P 0
     D WWERR           S              1A                                                      CER001
     D WFIND           S              1A                                                      CER001
     D*DLLOAN#**       S              6S 0                                             CER001 CLE148
     D DLLOAN#         S              6A                                                      CLE148
     D MSGID2C         S              2A                                                      CER001
     D PDDACTN         S              1A                                                      CER001
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
      *
      ***  End of fields for getting starting field number
      ***  -------------------------------------------------------------------
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIPR002
      *                                                                                      LLN022A
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLIPX0)                                LLN022A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LECLIPR003
      ***  Do screen: Browse invalid Loans
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      /COPY WNCPYSRC,LECLIPR004
      *
      ***  Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      /COPY WNCPYSRC,LECLIPR005
      *
      ***  Do while screen: Screen details 1
     C     @SCRN         DOWEQ     '1'
     C                   EXSR      SCRN@1
     C                   END
      /COPY WNCPYSRC,LECLIPR006
      *
      ***  Do while screen: Screen details 2
     C     @SCRN         DOWEQ     '2'
     C                   EXSR      SCRN@2
     C                   END
      /COPY WNCPYSRC,LECLIPR007
      *
      ***  Do while screen: Screen details 3
     C     @SCRN         DOWEQ     '3'
     C                   EXSR      SCRN@3
     C                   END
      /COPY WNCPYSRC,LECLIPR008
      *
      ***  Do while screen: Screen details 4
     C     @SCRN         DOWEQ     '4'
     C                   EXSR      SCRN@4
     C                   END
      /COPY WNCPYSRC,LECLIPR009
      *
      ***  Do while screen: Settlement details
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      /COPY WNCPYSRC,LECLIPR010
      *                                                                                       LLN022
     C     @SCRN         IFEQ      'W'                                                        LLN022
      *                                                                                       LLN022
     C                   EXSR      WINDOW                                                     LLN022
     C                   ENDIF                                                                LLN022
      *
      ***  Screen: Confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      /COPY WNCPYSRC,LECLIPR011
      *
      ***  Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      /COPY WNCPYSRC,LECLIPR012
      *                                                                                       CER001
      ** Display extension fields' validation                                                 CER001
      *                                                                                       CER001
     C     @SCRN         IFEQ      'L'                                                        CER001
     C                   EXSR      SREXT                                                      CER001
     C                   ENDIF                                                                CER001
      *
      ***  Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   CLOSE     LEICLLX1L0                                                 CER001
     C                   CLOSE     LECLX1L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   END
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LECLIPR013
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Loans
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LECLIPRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Error in update of previous loan
     C                   PARM                    @ERRUP            1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
     C                   PARM                    @OPSEL            1
      *
      ***  Action selected
     C                   PARM                    @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Successfully Inserted loan Number
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANKS
     C                   MOVE      '1'           *INU6
     C                   END
      *
      ***  If CK/3 or CK/12 taken in browse, or error message
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      ***  Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LECLIPRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      *BLANK        @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Error in update of previous loan
     C                   PARM                    @ERRUP            1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Action selected
     C                   PARM      *BLANK        @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Successfully Inserted loan Number
      *
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType
      *
      ***  If CK/3 taken within invalid transaction deletion function,
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      ***  If invalid loan read from subfile
      *
     C     @OPSEL        IFNE      *BLANK
      *
      ***  Blank all screens
      *
     C                   MOVEL     *BLANK        NwLnScnFmt1
     C                   MOVEL     *BLANK        NwLnScnFmt2
     C                   MOVEL     *BLANK        NwLnScnFmt3
     C                   MOVEL     *BLANK        NwLnScnFmt4
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKLnScn1
     C                   MOVE      *ALL'Y'       OKLnScn2
     C                   MOVE      *ALL'Y'       OKLnScn3
     C                   MOVE      *ALL'Y'       OKLnScn4
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  Retrieve loan details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ***  Make sure Invalid transaction's  details are passed to 'Retreive'
      ***  module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEICLIPX0                          99
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        DDACTN <> 'A'                                              CER001
      *                                                                                       CER001
     C                   MOVE      DDLNRF        DLLOAN#                                      CER001
     C     DLLOAN#       CHAIN(N)  RTVIDX                             85                      CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   MOVE      VKSUBR        LSUBR                                        CER001
     C                   MOVE      VKMOBL        LMOBL                                        CER001
     C                   MOVE      VKRISC        LRISC                                        CER001
     C                   MOVE      VKIMEX        LIMEX                                        CER001
     C                   MOVE      VKPPSC        LPPSC                                        CER001
     C                   MOVE      VKCOAM        LCOAM                                        CER001
     C                   MOVE      VKDGRI        LDGRI                                        CER001
     C                   MOVE      VKIM93        LIM93                                        CER001
     C                   MOVE      VKCLAT        LCLAT                                        CER001
     C                   MOVE      VK1UAC        LGUAC                                        CER001
     C                   MOVE      VKLUSU        LLUSU                                        CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WFIND                                        CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       LSUBR                                        CER001
     C                   MOVE      *BLANKS       LMOBL                                        CER001
     C                   MOVE      *ZEROS        LRISC                                        CER001
     C                   MOVE      *ZEROS        LIMEX                                        CER001
     C                   MOVE      *ZEROS        LPPSC                                        CER001
     C                   MOVE      *ZEROS        LCOAM                                        CER001
     C                   MOVE      *ZEROS        LDGRI                                        CER001
     C                   MOVE      *ZEROS        LIM93                                        CER001
     C                   MOVE      *ZEROS        LCLAT                                        CER001
     C                   MOVE      *ZEROS        LGUAC                                        CER001
     C                   MOVE      *ZEROS        LLUSU                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN(N)  RTVIDX1                            85                      CER001
      *                                                                                       CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   MOVE      LCSUBR        LSUBR                                        CER001
     C                   MOVE      LCMOBL        LMOBL                                        CER001
     C                   MOVE      LCGUAC        LGUAC                                        CER001
     C                   MOVE      LCPPSC        LPPSC                                        CER001
     C                   MOVE      LCCOAM        LCOAM                                        CER001
     C                   MOVE      LCIMEX        LIMEX                                        CER001
     C                   MOVE      LCRISC        LRISC                                        CER001
     C                   MOVE      LCIM93        LIM93                                        CER001
     C                   MOVE      LCCLAT        LCLAT                                        CER001
     C                   MOVE      LCLUSU        LLUSU                                        CER001
     C                   MOVE      LCDGRI        LDGRI                                        CER001
     C                   MOVE      'Y'           #1DEXT                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDLNRF        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVLOAN
      *
      ***  If loan details were retrieved
      ***  Put the loan on the first details screen
      *
     C     DDACTN        IFNE      'I'
     C     Idx           ANDEQ     *ZERO
     C                   EXSR      PUTD@1
      *
      **    Need to retrieve the fields for the other screens as well.
      **    Values will then be overidden by the values in Invalid file
      *
     C                   EXSR      PUTD@2
     C                   EXSR      PUTD@3
     C                   EXSR      PUTD@4
     C                   END
      *
      ***  Now overwite the fields on the main details screen with those
      ***  on the invalid Loans file (except for the Midas loan number
      ***  and Midas associated loan number retrieved above using the
      ***  front office transaction and associated transaction IDs).
      ***  Access invalid loan with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDLNRF        ##DDLNRF          6
     C     ZATRNKX0      CHAIN     LEICLIPX0                          99
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDLNRF      DDLNRF
     C                   END
      *
      ***  Access invalid loan settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
      ***  If loan details were retrieved and this is an amendment
      *
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDEQ     'A'
      *
      ***  Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *blank
     C     GHSUBS        SCAN      NwLnScnFmt1                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C     GHSUBS        SCAN      NwLnScnFmt2                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C     GHSUBS        SCAN      NwLnScnFmt3                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C     GHSUBS        SCAN      NwLnScnFmt4                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C                   END
      *
      ***  Setup settlement instructions on amend
      *
     C                   EXSR      SetupAmend
      *
      ***  Data Substitution - Settlement Details
      *
     C     GHSUBS        ifne      *blank
     C     GHSUBS        SCAN      ##PAYS                                 99
     C  N99GHSUBS        SCAN      ##RECS                                 99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   END
     C                   END
 
     C                   END
      *
      ***  If action code, or loan number were NOT OK
      ***  blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      ***  Send the Loans error messages to the main details screen
      *
     C                   EXSR      SNDM@1
      *
      ***  Go to first details screen
      *
     C                   MOVE      '1'           @SCRN
      *
      ***  else if no invalid loan read from subfile
      *
     C                   ELSE
      *
      ***  Go to browse screen
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@1 - Send a message to first screen
      *****************************************************************
     C     SNDM@1        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ***  If there are fundamental errors in this transaction
      ***  Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ***  Initialize error indicators
      *
     C                   MOVEA     OKLnScn1      @EI
      *
      ***  Read error messages for loan
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ***  Add error message to array passed to detail screen
      ***  and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     ABMSGID       MSGID2C                                      CER001
     C                   IF        ULX004 <> 'Y' OR                                           CER001
     C                             (ULX004 = 'Y' AND MSGID2C <> 'ER')                         CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
      *
      ** Need to subtract 1 to F due to DDLSTS which is an output field only
      ** and have no indicator defined
      *
     C     ABFIELDNAM    IFNE      'DDACTN'
     C                   SUB       1             F
     C                   ENDIF
      *
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                                CER001
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           OKLnScn1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@1 - Process first screen
      *****************************************************************
     C     SCRN@1        BEGSR
      *
      ***  Reset data
      *
     C                   CLEAR                   TransData
     C                   CLEAR                   DataOldRcd
     C                   CLEAR                   DataNewRcd
                                                                                             BUG3721
      ** Setup work field                                                                    BUG3721
                                                                                             BUG3721
     C                   Z-ADD     LCHGA         WCHGA                                       BUG3721
     C                   MOVE      'N'           WPRCS2            1                         BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     LRECI         ANDEQ     'D'                                                       BUG3721
     C     DDACTN        ANDEQ     'A'                                                       BUG3721
     C     LPTYP         ANDEQ     80                                                        BUG3721
     C     LVDAT         ANDLT     BJRDNB                                                    BUG3721
     C     LORED         ANDNE     BJRDNB                                                    BUG3721
     C                   MOVE      'Y'           WPRCS2                                      BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  Enable/disable detail fields on main details screen
      ***  if changes to the data are allowed
      ***  (key fields = action code & loan number; detail fields = rest)
      ***  (Action code can only be 'I', 'A', 'R', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD            1
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      ***  KJ = Command kay 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LECLIP1DP'
      *
      ***  Input parameters
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
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *
      ***  Loan record Id
      *
     C                   PARM                    PLnRcdId
      *
      ***  Output parameters
      *
      ***  Function keys
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
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@1
     C                   END
      *
     C                   ENDSR
      *****************************************************************                       LLN022
      /EJECT                                                                                  LLN022
      *****************************************************************                       LLN022
      * WINDOW - Window Processing                                                            LLN022
      *****************************************************************                       LLN022
     C     WINDOW        BEGSR                                                                LLN022
      *                                                                                       LLN022
     C/COPY WNCPYSRC,LECLIPRMV1                                                               LLN022
      *                                                                                       LLN022
      ** If BOE installed...                                                                 LLN022A
      *                                                                                       LLN022
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVEL     DDLNRF        BYLNRF                                      LLN022A
     C                   Z-ADD     CLMDAT        BYMDTE                                      LLN022A
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
     C                   MOVE      @FOTRANSEL    BYFRNT                                      LLN022A
     C                   MOVE      @TMESTPSEL    BYTIME                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Call Window Manager Program                                                          LLN022
      *                                                                                       LLN022
     C                   IF        @OPSEL     = 'N'                                           LLN022
     C                   EVAL      ACTION     = 'E'                                           LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      ACTION     = DDACTN                                        LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C                   CALL      'WN0010'                                                   LLN022
     C                   PARM      'LECLIPRPR'   #PGM             10                          LLN022
     C                   PARM                    FKEY              2                          LLN022
     C                   PARM                    ACTION            1                          LLN022
     C                   PARM                    DATA                                         LLN022
     C                   PARM      *BLANKS       #RTRN             7                          LLN022
     C                   PARM                    SPAREW          256                          LLN022
      *                                                                                       LLN022
      ** If F3 is pressed                                                                     LLN022
      *                                                                                       LLN022
     C                   SELECT                                                               LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'Y2U9999'                                          LLN022
     C                   EXSR      ENDP                                                       LLN022
      *                                                                                       LLN022
      ** Else if F12 pressed, return to previous screen                                       LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'USR0790'                                          LLN022
      *                                                                                       LLN022
     C                   EVAL      @SCRN = '4'                                                LLN022
      *                                                                                       LLN022
      ** Else if ENTER key was pressed,                                                       LLN022
      *                                                                                       LLN022
     C                   OTHER                                                                LLN022
     C                   IF        ACTION = 'E' AND                                           LLN022
     C                             @RDNB  = 'Y'                                               LLN022
      *                                                                                       LLN022
     C                   EVAL      @SCRN  = 'R'                                               LLN022
      *                                                                                       LLN022
     C                   ELSE                                                                 LLN022
      *                                                                                       LLN022
     C                   EVAL      @SCRN  = 'C'                                               LLN022
      *                                                                                       LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSL                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSR                                                                LLN022
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@2 - Process second screen
      *****************************************************************
     C     SCRN@2        BEGSR
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LECLIP2DP'
      *
      ***  Input parameters
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
      ** Work Fields                                                                         BUG3721
     C                   PARM                    WPRCS2                                      BUG3721
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @PGUP             1
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKLnScn2
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
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@2
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@3 - Process third screen
      *****************************************************************
     C     SCRN@3        BEGSR
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LECLIP3DP'
      *
      ***  Input parameters
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
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKLnScn3
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
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@3
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@4 - Process fourth screen
      *****************************************************************
     C     SCRN@4        BEGSR
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LECLIP4DP'
      *
      ***  Input parameters
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
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @PGUP
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKLnScn4
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
      ***  CK/12 - Cancel on first screen
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  Validate input to first screen
      *
     C                   CAS                     VAL@4
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@1  - Validate input to first screen
      *****************************************************************
     C     VAL@1         BEGSR
      *
      ***  Retrieve loan details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVLOAN
      *
      ***  If action code, or loan number are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
     C     CLE030        ANDNE     'Y'                                                        CLE030
      *
      ***  Update loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Continue to second screen
      *
     C                   MOVEL     '2'           @SCRN
      *
     C                   GOTO      EVAL@1
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      ***  and Authorise.                                                                     CLE030
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKLnScn1
     C                   CLEAR                   NwLnFilFmtCL
     C                   CLEAR                   NwLnFilFmtCK
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LECLIP1AD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
     C                   PARM                    NwLnScnFmt1
      *
      ***  Current Loan in Screen Format
     C                   PARM                    CrLnScnFmt1
      *
      ***  Current Loan in file format
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKLnScn1
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK            1
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP1VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt1
     C                   PARM                    InfData                                     246165
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
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C*****WIdx*         ORNE      0                                                          246163
     C                   GOTO      EVAL@1
     C                   END
      *                                                                                       CER020
      ** To re-output the screen for Warnings                                                 CER020
      *                                                                                       CER020
     C                   IF        WIdx <> *ZEROS AND                                         CER020
     C                             WHit < 1                                                   CER020
     C                   ADD       1             WHit                                         CER020
     C                   GOTO      EVAL@1                                                     CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Reset Errors                                                                         CER020
      *                                                                                       CER020
     C                   MOVEL     *ZEROS        WHit                                         CER020
     C                   MOVE      *ALL'Y'       OKLnScn1                                     CER020
     C                   MOVEL     *BLANK        FldNameArr                                   CER020
     C                   MOVEL     *BLANK        MsgIdArr                                     CER020
     C                   MOVEL     *BLANK        MsgDtaArr                                    CER020
     C                   MOVEL     *BLANK        WFldNamArr                                   CER020
     C                   MOVEL     *BLANK        WMsgIdArr                                    CER020
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CER020
      *
      ***  Continue
      *
     C                   MOVEL     '2'           @SCRN
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@2  - Validate input to second screen
      *****************************************************************
     C     VAL@2         BEGSR
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update loan in File Format
      *
     C*************      MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C*************      MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@2
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Update loan in File Format
      *
     C*************      MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C*************      MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   GOTO      EVAL@2
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKLnScn2
     C***************    CLEAR                   NwLnFilFmtCL
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update loan in File Format
      *
     C*************      MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C*************      MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LECLIP2AD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
     C                   PARM                    NwLnScnFmt2
      *
      ***  Current Loan in Screen Format
     C                   PARM                    CrLnScnFmt2
      *
      ***  Current Loan in file format
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
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
     C                   PARM                    OKLnScn2
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE
     C                   END
      *                                                                                       CER020
      ** Set last change type in valid file with screen action code                           CER020
      *                                                                                       CER020
     C                   EVAL      CLCHTP = DDACTN                                            CER020
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
      ** OK fields on screen 1                                                               BUG3721
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
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C*****WIdx*         ORNE      0                                                          246163
     C                   GOTO      EVAL@2
     C                   END
      *
      ***  Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@3  - Validate input to third screen
      *****************************************************************
     C     VAL@3         BEGSR
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update loan in File Format
      *
     C************       MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C************       MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@3
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Update loan in File Format
      *
     C************       MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C************       MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Continue
      *
     C                   MOVEL     '4'           @SCRN
      *
     C                   GOTO      EVAL@3
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKLnScn3
     C*************      CLEAR                   NwLnFilFmtCL
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update loan in File Format
      *
     C************       MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C************       MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LECLIP3AD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
     C                   PARM                    NwLnScnFmt3
      *
      ***  Current Loan in Screen Format
     C                   PARM                    CrLnScnFmt3
      *
      ***  Current Loan in file format
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKLnScn3
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
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
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C*****WIdx*         ORNE      0                                                          246163
     C                   GOTO      EVAL@3
     C                   END
      *
      ***  Continue
      *
     C                   MOVEL     '4'           @SCRN
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@3        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@4  - Validate input to fourth screen
      *****************************************************************
     C     VAL@4         BEGSR
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update loan in File Format
      *
     C*************      MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C*************      MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@4
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      ***  Update loan in File Format
      *
     C*************      MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C*************      MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
     C                   GOTO      EVAL@4
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKLnScn4
     C**************     CLEAR                   NwLnFilFmtCL
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update loan in File Format
      *
     C************       MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C************       MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LECLIP4AD'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Loan in Screen Format
     C                   PARM                    NwLnScnFmt4
      *
      ***  Current Loan in Screen Format
     C                   PARM                    CrLnScnFmt4
      *
      ***  Current Loan in file format
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Calling type
     C                   PARM                    LoanType
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKLnScn4
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    @@AMOK
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE
     C                   END
      *
      ***  Validate Loan details
      *
     C                   CALLB     'LECLIP4VL'
     C                   PARM                    RespMode
     C                   PARM                    NwLnScnFmt4
     C                   PARM                    InfData                                      246165
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
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C*****WIdx*         ORNE      0                                                          246163
     C                   GOTO      EVAL@4
     C                   END
      *
      ***  Continue with updates
      *
     C**********         MOVEL     'U'           @SCRN                                       BUG9076
     C                   IF        @OPSEL <> 'N'                                             BUG9076
     C                   MOVEL     'C'           @SCRN                                       BUG9076
     C                   ELSE                                                                BUG9076
     C     @RDNB         IFEQ      'Y'                                                       BUG9076
     C                   MOVEL     'R'           @SCRN                                       BUG9076
     C                   ELSE                                                                BUG9076
     C                   MOVEL     'B'           @SCRN                                       BUG9076
     C                   ENDIF                                                               BUG9076
     C                   ENDIF                                                               BUG9076
      *
     C                   END
      *                                                                                       LLN022
      ** Add validation condition                                                             LLN022
      *                                                                                       LLN022
     C                   IF        BGWDPR = 'Y'                                               LLN022
     C                   EVAL      @SCRN = 'W'                                                LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      @SCRN = 'U'                                                LLN022
     C                   ENDIF                                                                LLN022
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ENDIF                                                                CER001
      *----------------------------------------------------------------
     C     EVAL@4        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVLOAN - Retrieve loan
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
     C                   PARM                    LoanType          4
 
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
     C/COPY WNCPYSRC,LECLIPR016
      *
      ***  Save the loan record Id
     C                   MOVEL     LRECI         PLnRcdId          1
     C                   Z-ADD     LCHGA         WCHGA                                       BUG3721
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@1 - Put a loan on the first details screen               *
      *****************************************************************
     C     PUTD@1        BEGSR
      *
      ***  Call program to fill screen fields with data from CLOANCL and CLOANCK
      *
     C                   CALLB     'LECLIP1CT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
      *
      ***  Outputs
      *
      ***  Loan in screen format
     C                   PARM                    NwLnScnFmt1
      *
      ***  Update 'Current' Loan with Loan in Screen Format
     C                   MOVEL     NwLnScnFmt1   CrLnScnFmt1
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
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
      *
      ***  Outputs
      *
      ***  Loan in screen format
     C                   PARM                    NwLnScnFmt2
      *
      ***  Update 'Current' Loan with Loan in Screen Format
     C                   MOVEL     NwLnScnFmt2   CrLnScnFmt2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@3 - Put a loan on the third details screen
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
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Outputs
      *
      ***  Loan in screen format
     C                   PARM                    NwLnScnFmt3
      *
      ***  Update 'Current' Loan with Loan in Screen Format
     C                   MOVEL     NwLnScnFmt3   CrLnScnFmt3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@4 - Put a loan on the fourth details screen
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
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Outputs
      *
      ***  Loan in screen format
     C                   PARM                    NwLnScnFmt4
      *
      ***  Update 'Current' Loan with Loan in Screen Format
     C                   MOVEL     NwLnScnFmt4   CrLnScnFmt4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - Cancel on all screens
      *****************************************************************
     C     CANC@A        BEGSR
      *
      ***  If records are still to be read from the subfile, read them
      *
     C**** @RDNB         IFEQ      'Y'
     C**** @SCRN         ANDEQ     '1'
     C****               MOVEL     'R'           @SCRN
     C****               ELSE
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C     @RDNB         ANDEQ     'Y'
     C                   MOVEL     'R'           @SCRN
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL     '1'           @SCRN
     C     @SCRN         WHENEQ    '3'
     C                   MOVEL     '2'           @SCRN
     C     @SCRN         WHENEQ    '4'
     C                   MOVEL     '3'           @SCRN
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL     'B'           @SCRN
     C                   END
     C****               END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details
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
      ***  If no changes are allowed, protect (but still validate)
      ***  all instructions by passing action code 'X' to ZASETINSIN
      *
     C     @OPSEL        IFEQ      'N'
     C                   MOVEL     'X'           ##ACTN
     C                   ELSE
     C                   MOVEL     DDACTN        ##ACTN
     C                   ENDIF
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      * Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
     C                   PARM                    ##ACTN            1
      *
      ***  Loan number
     C                   PARM      DDLNRF        ##LNRF            6
      *
      ***  Protect Payment
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
     C                   PARM      WWCUST        ##CSNM           10
      *
      ***  Transaction Type
     C                   PARM      DDLTYP        ##TTYP            2
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Booking branch
     C                   PARM      DDBRCA        ##BRCA            3
      *
      ***  Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM                    ##DATP            5 0
      *
      ***  Payment instructions
     C                   PARM                    ##PAYS
      *
      ***  Receive instructions
     C                   PARM                    ##RECS
      *
      ***  FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      ***  Outputs
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      ***  Function keys
     C                   PARM      '0'           @INKC             1
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
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
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
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  Outputs
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
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
     C                   PARM                    ##PAYF
      *
      ***  File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ***  File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Outputs
      ***  Screen Payment Settlement Instruction
     C                   PARM      *BLANKS       ##PAYS
      *
      ***  Screen Receipt Settlement Instruction
     C                   PARM      *BLANKS       ##RECS
      *
      ***  Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANKS       ##FRIS
                                                                                             CSF011A
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C     ##RTCD        IFNE      *BLANKS
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
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      ***  If settlement details invalid
      *
     C     ##RTCD        IFEQ      '*ERRORS'
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
     C                   MOVEL     FLRSCY        CLSCCY
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
     C                   MOVE      WOSDB         CLOSDB
     C                   MOVEL     WTSTN         CLTSTN
 
     C                   MOVE      WMDST         CLMDST
     C                   MOVEL     WOMDA         CLOMDA
     C                   MOVE      WOMDB         CLOMDB
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
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
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
      * CANC@C - Cancel on confirmation screen
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to fourth details screen
      *
     C                   MOVEL     '4'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  Else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ***  Get the next available loan number
      ***  If action is I and DDLNRF still blank
      *
     C                   MOVE      *BLANKS       @RTCD                                        CER020
      *                                                                                       CER020
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
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @PRANG        DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C*****F9NALN        SUB       1             F9NALN                                       CLE148
     C**********         MOVE      F9NALN        DDLNRF                                       CLE148
     C                   MOVE      F9NALA        DDLNRF                                       CLE148
     C                   END
      *
     C                   MOVEL     DDLNRF        @SIDN
      *
      ***  Update valid loan: Loan number
      *
     C                   MOVE      DDLNRF        CLLNRF
     C                   MOVE      DDLNRF        K_CLLNRF
      *
      ***  Update valid loan: Last action code
      *
     C                   MOVEL     DDACTN        CLCHTP
     C                   MOVEL     DDACTN        K_CLCHTP
      *
      ***  Update valid loan: Front office transaction ID
      *
     C                   MOVEL     @FOTRANSEL    CLFRNT
      *
      ***  Loans updates
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   SELECT                                                              BUG9173
     C                   WHEN      DDACTN = 'I'                                              BUG9173
     C                   EVAL      CLIUSR = PSUSER                                           BUG9173
     C                   WHEN      DDACTN = 'A'                                              BUG9173
     C                   EVAL      CLAUSR = PSUSER                                           BUG9173
     C                   WHEN      DDACTN = 'X'                                              BUG9173
     C                   EVAL      CLXUSR = PSUSER                                           BUG9173
     C                   WHEN      DDACTN = 'Q'                                              BUG9173
     C                   EVAL      CLXUSR = PSUSER                                           BUG9173
     C                   ENDSL                                                               BUG9173
      *                                                                                      BUG9173
     C                   CALLB     'LECLIPUPD'
     C                   PARM                    @RTCD
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
     C                   PARM      'RPR'         CallModCode       3                          CDE005
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
     C/COPY WNCPYSRC,LECLIPR015
                                                                                             BUG3721
      *                                                                                       CER001
      ** Update invalid extension file                                                        CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y' AND @RTCD = *BLANKS                           CER001
     C**********         MOVE      F9NALN        LKLNRF                                CER001 CLE148
     C                   MOVE      F9NALA        LKLNRF                                       CLE148
     C                   CALLB     'LECLIP2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      *BLANK        WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   ENDIF                                                              AR868380
      *                                                                                     AR868380
     C                   END
      *                                                                                      LLN022A
      ** If BOE installed...                                                                 LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blank                                            LLN022A
                                                                                             LLN022A
     C                   EVAL      LVLNRF = BYLNRF                                           LLN022A
     C                   EVAL      LVLNTP = BYLNTP                                           LLN022A
     C                   EVAL      LVFMAT = BYFMAT                                           LLN022A
     C                   EVAL      LVAFRT = BYFRNT                                           LLN022A
     C                   EVAL      LVTMST = BYTIME                                           LLN022A
                                                                                             LLN022A
     C                   CALLB     'LECLIPUPD1'                                              LLN022A
     C                   PARM      *Blanks       p_RTCD            7                         LLN022A
     C                   PARM      DDACTN        p_Actn            1                         LLN022A
     C                   PARM                    ValidCLIPEx                                 LLN022A
                                                                                             LLN022A
     C                   EVAL      @RTCD = p_RTCD                                            LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'                                                AR868380
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEICLIPD0                          99
     C  N99              DELETE    LEICLIPD0
      *                                                                                       CER001
      ** Delete from invalid extension file.                                                  CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C     @RTCD         IFNE      '*RECUPD'                                                  CER001
     C     @RTCD         ANDNE     '*RECLCK'                                                  CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                            99                      CER001
     C                   IF        *IN99 = *OFF                                               CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *
      ** If BOE installed...                                                                 LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Delete extra data on the invalid file.                                              LLN022A
      *                                                                                      LLN022A
     C     ZATRNKD0      CHAIN     LEICLIPY0                          99                     LLN022A
     C  N99              DELETE    ICLIPD0                                                   LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      ***  Delete invalid record from the log file
      *
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
      *
     C                   EVAL      KMsgType = 'LECLIP'
     C                   EVAL      KFrntOffID = DDFOTRANID
     C                   EVAL      KTimeStamp = DDTMESTMP
      *
     C     KAPLOG        CHAIN     APILOGL0                           99
      *
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Commit any database changes                                                           CSC022
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
      *
     C                   END
      *
      ***  If error occurred in updating last transaction set on flag to
      ***  display message on 'browse' screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C     @RTCD         OREQ      '*RECLCK'                                                AR868380
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
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
      * ENDP - End program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   IF        BGWDPR = 'Y'                                               LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *****************************************************************
      *
     C     TDtDtaSubs    BEGSR
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL(P)  NwLnScnFmt1   IncDATA
     C                   MOVEL(P)  CrLnScnFmt1   CurDATA
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL(P)  NwLnScnFmt2   IncDATA
     C                   MOVEL(P)  CrLnScnFmt2   CurDATA
     C     @SCRN         WHENEQ    '3'
     C                   MOVEL(P)  NwLnScnFmt3   IncDATA
     C                   MOVEL(P)  CrLnScnFmt3   CurDATA
     C     @SCRN         WHENEQ    '4'
     C                   MOVEL(P)  NwLnScnFmt4   IncDATA
     C                   MOVEL(P)  CrLnScnFmt4   CurDATA
     C                   ENDSL
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode       10
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      *
      ***  Incoming Data
     C                   PARM                    IncDATA        2000
      *
      ***  Current Data
     C                   PARM                    CurDATA        2000
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL(P)  IncDATA       NwLnScnFmt1
     C     @SCRN         WHENEQ    '2'
     C                   MOVEL(P)  IncDATA       NwLnScnFmt2
     C     @SCRN         WHENEQ    '3'
     C                   MOVEL(P)  IncDATA       NwLnScnFmt3
     C     @SCRN         WHENEQ    '4'
     C                   MOVEL(P)  IncDATA       NwLnScnFmt4
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupAmend - Setup Settlement Instructions on Amendment       *
      *****************************************************************
      *
     C     SetupAmend    BEGSR
      *
      ***  Conversion of file fields to screen format
      *
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     CLRSTM        FLRSTM                                       CGL029
     C                   MOVEL     CLOSDB        FLROBR
     C                   MOVEL     CLSCCY        FLRSCY
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     CLPSTM        FLPSTM                                       CGL029
     C                   MOVEL     CLOMDB        FLPOBR
     C                   MOVEL     CLCVMR        FLCVMR
     C                   MOVEL     CLSCCY        FLPSCY
     C                   MOVEL     CLICCY        FLIC72
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
     C                   CALLB     'ZASETINCVT'
      *
      ***  Loan Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Current Settlement Instruction in input format
     C                   PARM      *BLANK        CrPaySttmt
     C                   PARM      *BLANK        CrRecSttmt
     C                   PARM      *BLANK        CrFRASttmt
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
      ***  If no Payment or Receive instructions have been supplied
      ***  Default them to those currently on the loan.
      *
     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = CrPaySttmt
     C                   ENDIF
      *
     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = CrRecSttmt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *****************************************************************
      *
     C     SDtDtaSubs    BEGSR
      *
      ***  Payment instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##PAYS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrPaySttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##PAYS
      *
      ***  Receipt instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##RECS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrRecSttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##RECS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SREXT - Process screen inputs                                 *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SREXT         BEGSR                                                                CER001
      *                                                                                       CER001
     C                   IF        LoanPtyp <> 66 and LoanPtyp <> 67                          CER001
     C                             and LoanPtyp <> 69 and LoanPtyp <> 72                      CER001
      *                                                                                       CER001
     C                   MOVE      CLLNRF        #1LNRF                                       CER001
     C                   MOVE      CLCNUM        #1CUST                                       CER001
     C                   MOVE      CLCCY         #1CCY                                        CER001
     C                   MOVE      CLPTYP        #1PTYP                                       CER001
     C                   MOVE      CLCPAM        #1AMNT                                       CER001
     C                   MOVE      @FOTRANSEL    #1FOID                                       CER001
     C                   MOVE      @TMESTPSEL    #1TMSP                                       CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      PDDACTN = DDACTN                                           CER001
     C                   EVAL      DDACTN = 'E'                                               CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'LECLIP2RP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    W0RTN             7                          CER001
     C                   PARM                    ULX004                                       CER001
     C                   PARM                    ULX612                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      DDACTN = PDDACTN                                           CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      W0RTN = 'USR0790'                                          CER001
     C                   EVAL      @SCRN = '4'                                                CER001
     C                   WHEN      W0RTN = 'Y2U9999'                                          CER001
     C                   EVAL      @SCRN = 'T'                                                CER001
     C                   WHEN      @OPSEL = 'N'                                               CER001
     C     @RDNB         IFEQ      'Y'                                                        CER001
     C                   EVAL      @SCRN = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'B'                                                CER001
     C                   ENDIF                                                                CER001
     C                   OTHER                                                                CER001
     C                   EVAL      @SCRN = 'C'                                                CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Receive entry parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIPRPR'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
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
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
      *
      ***  Message Type
      *
     C                   MOVEL     'LECLIP'      @MSGTYPE
      *
      ***  Get the field number for the action code field; the screen fields
      ***  start from that number.  Subtract one from it to give the value
      ***  to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ***  If there was an error default the offset to 13
      *
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *
      ***  Check if CSC011 is installed
      *
     C                   MOVE      'N'           CSC011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC011'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011
      *
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C                   END
     C                   MOVEL     *BLANKS       @RTCD
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
     C                   Z-ADD     5             DBASE                          * DBERR 005 * CLE030
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
      ***  Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
     C                   EVAL      @RTCD = *BLANKS
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIPR014
                                                                                              CSC022
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
     C                   EVAL      DBPGM = 'LECLIPRPR'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 006                                               CSC022
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
      *                                                                                       CER001
      ** Check if switch ULX004 is installed                                                  CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD             6                          CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004                                       CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '009'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if switch ULX612 is installed                                                  CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX612            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX612'      @SARD             6                          CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX612                                       CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX612                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '010'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   OPEN      LEICLLX1L0                                                 CER001
     C                   OPEN      LECLX1L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
