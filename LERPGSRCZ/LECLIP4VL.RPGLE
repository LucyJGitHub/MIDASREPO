     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans screen 4 validations')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP4VL -  Customer Loans screen 4 validations             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD052135           Date 23Nov18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 AR567846           Date 01Aug12               *
      *                 AR317161           Date 01Aug12               *
      *                 263840             Date 01Aug12               *
      *                 264080             Date 01Aug12               *
      *                 263080             Date 01Aug12               *
      *                 262872             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 11Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074  *CREATE    Date 29May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD052135 - LE: Inconsistency in 'Reporting Past Due Initial  *
      *             Date' and 'Basel II Initial Date                  *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  AR567846 - Cann't change repayment date- Basel 2 reporting   *
      *             fields (Child: AR567846)                          *
      *  AR317161 - Inability to amend Loan transaction               *
      *             (Child: AR317162)                                 *
      *  263840 - FAMU not necessary for Loan Types 'Xx'.             *
      *  264080 - Include zero in PDCL RCAT/BCAT check.               *
      *  263080 - P2: CLE134 Loan Input/API Discrepancy with          *
      *           Classification/Initial Date Combination.            *
      *  262872 - P2: CLE134 API LELOAN failed to return error        *
      *           CLE134 / SWIFT                                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager.                               *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028).   *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)  PREFIX(pd_)                          CLE134
     FCLOANL4   IF   E           K DISK    INFSR(*PSSR)  PREFIX(pd_)                          CLE134
     F                                     RENAME(CLOANCLF:CLOANL4F)                          CLE134
      *****************************************************************
      *
      ***  FILES
      *    =====
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIP4V01
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
                                                                                              CLE134
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)                                  CLE134
                                                                                              CLE134
      ** Customer lending ICD                                                                 CLE134
                                                                                              CLE134
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)                                  CLE134
                                                                                              CLE134
      ** External DS for loans details                                                        CLE134
                                                                                              CLE134
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidLnCl     E DS                  EXTNAME(LEVCLILPD)
      ***  Valid Loans CL layout -> CLOANCL
     D                                     PREFIX(C)
      *
     D ValidLnCk     E DS                  EXTNAME(LEVCLIKPD)
      ***  Valid Loans CK layout -> CLOANCK
      *
     D TranInScr4    E DS                  EXTNAME(LECLI4PD)
     D TranInScr6    E DS                  EXTNAME(LECLI6PD)                                  CLE134
      ***  Incoming Transaction
      *
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL) PREFIX(@@)
      * (Current) Loans record CL in file Format
 
      *
     D OKFlagsDS     E DS                  EXTNAME(LEECLI4PD)
     D OKFlagsDS6    E DS                  EXTNAME(LEECLI6PD)                                 CLE134
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
     D  FCUSM                 64     69  0
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
     D  WPTFC                224    229  0
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
     D  ANUM                 445    450A                                                      CSD027
     D**CNUMF***             451    456  0                                                    CSD027
     D  CNUMF                451    456A                                                      CSD027
     D**PMFC*****            457    462  0                                                    CLE106
     D**W#PMFC**             457    462  0                                             CLE106 CSD027
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
     D  D@SPI1                69     98
     D  D@SPI2                99    128
     D  D@SPI3               129    158
     D  D@SPI                 69    158
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
      ***  Index for arrays of of warning message ids etc
      *
      ** Key Fields.                                                                          CLE134
      *                                                                                       CLE134
     D Kpd_LNRF        S                   INZ LIKE(pd_LNRF)                                  CLE134
     D Kpd_RECI        S                   INZ LIKE(pd_RECI)                                  CLE134
     D Kpd_YPORG       S                   INZ LIKE(pd_YPORG)                                 CLE134
      *                                                                                       CLE134
      ** Work Variables.                                                                      CLE134
      *                                                                                       CLE134
     D DSBCN           S              4  0 INZ DIM(9) ASCEND                                  CLE134
     D DSBCD           S             25    INZ DIM(9)                                         CLE134
      *                                                                                       CLE134
     D DSBCAT          S              1S 0 INZ                                                CLE134
     D DSBIDT          S              5S 0 INZ                                                CLE134
     D DSBIDTFm        S              5S 0 INZ                                                CLE134
     D DSBIDTTo        S              5S 0 INZ                                                CLE134
      *                                                                                       CLE134
     D DSRCN           S              4  0 INZ DIM(9) ASCEND                                  CLE134
     D DSRCD           S             25    INZ DIM(9)                                         CLE134
      *                                                                                       CLE134
     D DSRCAT          S              1S 0 INZ                                                CLE134
     D DSRIDT          S              5S 0 INZ                                                CLE134
     D DSRIDTFm        S              5S 0 INZ                                                CLE134
     D DSRIDTTo        S              5S 0 INZ                                                CLE134
      *                                                                                       CLE134
     D DSDYS           S              9S 0 INZ                                                CLE134
     D DSPDSts         S             10A   INZ                                                CLE134
     D DSPDVlD         S              5S 0 INZ                                                CLE134
     D #A              S              9S 0 INZ                                                CLE134
      *                                                                                       CLE134
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
      /COPY WNCPYSRC,LECLIP4V02
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
      /COPY WNCPYSRC,LECLIP4V03
      *
      ***  Validation for screen details 1
      *    ===============================
      *
      ***  Reset variables updated by each module
     C                   EXSR      RESETERRS
      *
      ***  Validate XXXXXXXXXXXXXXXX
      *    Actually there is not validation on the fourth screen
      *    In case of a new test added hereafter, replace the
      *    subroutine name SRFIRST with the new name please
      *
     C                   EXSR      SRFIRST
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   IF        %SUBST(CCLLTYP:1:1) = 'X'   OR                             CLE134
     C                             %SUBST(CCLLTYP:1:1) = 'Y'   OR                             CLE134
     C                             %SUBST(CCLLTYP:1:1) = 'Z'                                  CLE134
     C                   EXSR      SRFAMU                                                     CLE134
                                                                                              CLE134
      ** PDCL fields should be kept empty                                                     CLE134
                                                                                              CLE134
     C                   IF        DDRIDT      <> *BLANKS                                     CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDRIDT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045656'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         IF        DDRCAT      <> *BLANKS                              CLE134 264080
     C                   IF        DDRCAT      <> *BLANKS      AND                            264080
     C                             DDRCAT      <> *ZEROS                                      264080
     C                   EVAL      DDRCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDRCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045657'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDBIDT      <> *BLANKS                                     CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDBIDT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045658'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         IF        DDBCAT      <> *BLANKS                              CLE134 264080
     C                   IF        DDBCAT      <> *BLANKS      AND                            264080
     C                             DDBCAT      <> *ZEROS                                      264080
     C                   EVAL      DDBCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDBCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045659'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
                                                                                              CLE134
      ** FAMU should be kept empty                                                            CLE134
                                                                                              CLE134
     C                   IF        DDFAMU      <> *BLANKS                                     CLE134
     C                             and DDFAMU <> 'N'                                        AR317161
     C                   EVAL      DDFAMUOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDFAMU'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045660'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EXSR      SRPDCL                                                     CLE134
                                                                                              262872
     C                   IF        DSPDSts <> '*LIVE'                                         262872
                                                                                              262872
      ** PDCL fields should be kept empty                                                     262872
                                                                                              262872
     C                   IF        DDRIDT <> *BLANKS                                          262872
     C                   EVAL      DDRIDTOK    = 'N'                                          262872
     C                   EVAL      Idx        += 1                                            262872
     C                   EVAL      FldNamXAr(Idx)   = 'DDRIDT'                                262872
     C                   EVAL      MsgIDXAr(Idx)    = '5045667'                               262872
     C                   ENDIF                                                                262872
                                                                                              262872
     C                   IF        DDRCAT <> *BLANKS AND DDRCAT <> '0'                        262872
     C                   EVAL      DDRCATOK    = 'N'                                          262872
     C                   EVAL      Idx        += 1                                            262872
     C                   EVAL      FldNamXAr(Idx)   = 'DDRCAT'                                262872
     C                   EVAL      MsgIDXAr(Idx)    = '5045668'                               262872
     C                   ENDIF                                                                262872
                                                                                              262872
     C                   IF        DDBIDT <> *BLANKS                                          262872
     C                   EVAL      DDBIDTOK    = 'N'                                          262872
     C                   EVAL      Idx        += 1                                            262872
     C                   EVAL      FldNamXAr(Idx)   = 'DDBIDT'                                262872
     C                   EVAL      MsgIDXAr(Idx)    = '5045669'                               262872
     C                   ENDIF                                                                262872
                                                                                              262872
     C                   IF        DDBCAT <> *BLANKS AND DDBCAT <> '0'                        262872
     C                   EVAL      DDBCATOK    = 'N'                                          262872
     C                   EVAL      Idx        += 1                                            262872
     C                   EVAL      FldNamXAr(Idx)   = 'DDBCAT'                                262872
     C                   EVAL      MsgIDXAr(Idx)    = '5045670'                               262872
     C                   ENDIF                                                                262872
                                                                                              262872
     C                   ENDIF                                                                262872
                                                                                              262872
     C                   EXSR      SRRDFT                                                     CLE134
     C                   EXSR      SRRIDT                                                     CLE134
     C                   EXSR      SRRCAT                                                     CLE134
                                                                                              CLE134
     C                   EXSR      SRBDFT                                                     CLE134
     C                   EXSR      SRBIDT                                                     CLE134
     C                   EXSR      SRBCAT                                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *
      /COPY WNCPYSRC,LECLIP4V04
      *
      ***  Move the screen fields to valid file
      *
     C                   EXSR      SRMVFLD
      *
      /COPY WNCPYSRC,LECLIP4V05
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      /COPY WNCPYSRC,LECLIP4V06
      *
      ***  Save the loan reference for warning
      *
     C                   MOVEL     DDLNR4        SaveDDLNR4        6
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRMVFLD - Move the screen fields to valid file              *
      *****************************************************************
     C     SRMVFLD       BEGSR
      *
     C                   MOVEL     DDSPI1        CLSPI1
     C                   MOVEL     DDSPI2        CLSPI2
     C                   MOVEL     DDSPI3        CLSPI3
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFIRST - XXXXXXXXXXXXXXXXXXXXXXXXX                          *
      *****************************************************************
     C     SRFIRST       BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE134
      *  SRFAMU - Validate Facility Amount Utilisation                *                       CLE134
      *****************************************************************                       CLE134
     C     SRFAMU        BEGSR                                                                CLE134
                                                                                              CLE134
     C                   IF        %SUBST(CCLLTYP:1:1) <> 'X'                                 263840
                                                                                              263840
     C                   IF        DDFAMU      = *BLANKS                                      CLE134
     C                   EVAL      DDFAMU      = AYFAMU                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      cCLFAMU     = DDFAMU                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 263840
     C                   EVAL      DDFAMU      = *BLANKS                                      263840
     C                   EVAL      cCLFAMU     = DDFAMU                                       263840
     C                   ENDIF                                                                263840
                                                                                              263840
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRPDCL - Retrieve PDCL Details.                              *                       CLE134
      *****************************************************************                       CLE134
     C     SRPDCL        BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSPDSts     = *BLANKS                                      CLE134
                                                                                              CLE134
     C                   EVAL      Kpd_YPORG   = CLLNRF                                       CLE134
     C     KLEPDUEL2     SETLL     LEPDUEL2                                                   CLE134
     C     KLEPDUEL2     READE(E)  LEPDUEL2                                                   CLE134
                                                                                              CLE134
     C                   DOW       NOT %EOF(LEPDUEL2)          AND                            CLE134
     C                             DSPDSts    <> '*LIVE'                                      CLE134
                                                                                              CLE134
     C                   IF        pd_YRECI    = 'D'                                          CLE134
     C                   EVAL      Kpd_RECI    = 'D'                                          CLE134
     C                   EVAL      Kpd_LNRF    = pd_YPLON                                     CLE134
     C     KCLOANL4      CHAIN(E)  CLOANL4                                                    CLE134
                                                                                              CLE134
     C                   IF        %FOUND(CLOANL4)             AND                            CLE134
     C                             pd_CPAM    <> 0                                            CLE134
     C                   EVAL      DSPDSts     = '*LIVE'                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DSPDSts    <> '*LIVE'                                      CLE134
     C     KLEPDUEL2     READE(E)  LEPDUEL2                                                   CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
      ** If Live Record Found, Default Initial Dates.                                         CLE134
                                                                                              CLE134
     C                   IF        DSPDSts     = '*LIVE'       AND                            CLE134
     C                             pd_VDAT    <> 0                                            CLE134
     C                   IF        DDRIDT      = *BLANKS                                      CLE134
     C                   MOVE      pd_VDAT       ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVEL     ZDateFmt6     DDRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDBIDT      = *BLANKS                                      CLE134
     C                   MOVEL     ZDateFmt6     DDBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRRDFT - Derive Reporting Default Values                     *                       CLE134
      *****************************************************************                       CLE134
     C     SRRDFT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Initialisation.                                                                      CLE134
                                                                                              CLE134
     C                   EVAL      DSRCAT      = 0                                            CLE134
     C                   EVAL      DSRIDTFm    = 0                                            CLE134
     C                   EVAL      DSRIDTTo    = 0                                            CLE134
                                                                                              CLE134
      ** If Reporting Classification Entered, Derive Valid Initial                            CLE134
      ** Date Range.                                                                          CLE134
                                                                                              CLE134
     C                   IF        DDRCAT      = *BLANKS                                      CLE134
     C                   EVAL      DDRCAT      = '0'                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDRCAT     >= '1'           AND                            CLE134
     C                             DDRCAT     <= '9'                                          CLE134
     C                   EVAL      #A          = %DEC(DDRCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   SELECT                                                               CLE134
     C                   WHEN      #A          = 1                                            CLE134
     C                   EVAL      DSRIDTFm    = BJRDNB - DSRCN(1)                            CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB                                       CLE134
                                                                                              CLE134
     C                   WHEN      DSRCN(#A)   = 999           OR                             CLE134
     C                             DSRCN(#A)   = 0                                            CLE134
     C                   EVAL      DSRIDTFm    = 0                                            CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB - DSRCN(#A-1)                         CLE134
                                                                                              CLE134
     C                   OTHER                                                                CLE134
     C                   EVAL      DSRIDTFm    = BJRDNB - DSRCN(#A)                           CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB - DSRCN(#A-1)                         CLE134
     C                   ENDSL                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Initial Date Entered, Derive Valid                                      CLE134
      ** Classification.                                                                      CLE134
                                                                                              CLE134
     C                   IF        DDRIDT     <> *BLANKS                                      CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DDRIDT                                       CLE134
     C     DSRIDT        PARM                    ZDAYNO                                       CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
     C                   IF        DSRIDT     <= BJRDNB        AND                            CLE134
     C                             ErrorFlag  <> 'Y'                                          CLE134
     C                   EVAL      DSDYS       = BJRDNB - DSRIDT                              CLE134
                                                                                              CLE134
     C                   IF        DSDYS       > 999                                          CLE134
     C                   EVAL      DSDYS       = 999                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         EVAL      DSRCAT      = %LOOKUPGT(DSDYS:DSRCN) - 1            CLE134 263080
     C                   EVAL      DSRCAT      = %LOOKUPGT(DSDYS:DSRCN)                       263080
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Classification Not Entered, Set Default.                                CLE134
                                                                                              CLE134
     C                   IF        DDRCAT      = *BLANKS       AND                            CLE134
     C                             DSRCAT     <> 0                                            CLE134
     C                   EVAL      DDRCAT      = %CHAR(DSRCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Initial Date Not Entered, Set Default.                                  CLE134
                                                                                              CLE134
     C                   IF        DDRIDT      = *BLANKS       AND                            CLE134
     C                             DSRIDTTo   <> 0                                            CLE134
     C                   MOVE      DSRIDTTo      ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRRIDT - Validate Reporting Past Due Initial Date            *                       CLE134
      *****************************************************************                       CLE134
     C     SRRIDT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** If Active PDCL exists;                                                               CLE134
      ** - Initial Date must be entered;                                                      CLE134
                                                                                              CLE134
     C                   IF        DSPDSts      = '*LIVE'                                     CLE134
     C                   IF        DDRIDT      = *BLANKS                                      CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045572'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Else;                                                                                CLE134
      ** - Initial Date must not be entered.                                                  CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDRIDT     <> *BLANKS                                      CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045573'                                 CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Initial Date entered;                                                             CLE134
      ** - Convert Inital Date to Midas Day.                                                  CLE134
                                                                                              CLE134
     C**********         EVAL      CCLRIDT = *ZEROS                                  CLE134 MD052135
     C                   IF        DDRIDT     <> *BLANKS       AND                            CLE134
     C                             DDRIDTOK   <> 'N'                                          CLE134
     C                   MOVE      DDRIDT        DATEA                                        CLE134
     C                   TESTN                   DATEA                9798                    CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DATEA             6                          CLE134
     C                   PARM                    ZDAYNO            5 0                        CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
      ** - Invalid format or not numeric.                                                     CLE134
                                                                                              CLE134
     C                   IF        ErrorFlag   = 'Y'           OR                             CLE134
     C                             *IN97       = '0'           AND                            CLE134
     C                             *IN98       = '0'                                          CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5410'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DSRIDT      = ZDAYNO                                       CLE134
                                                                                              CLE134
      ** - If the date has changed;                                                           CLE134
      **    Ensure date isn't in the future.                                                  CLE134
                                                                                              CLE134
     C                   IF        DSRIDT     <> @@RIDT                                       CLE134
     C                   IF        DSRIDT      > BJRDNB                                       CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045565'                                 CLE134
                                                                                              CLE134
      ** - Ensure date falls within valid range.                                              CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DSRIDTFm   <> 0             AND                            CLE134
     C                             (DSRIDT     < DSRIDTFm      OR                             CLE134
     C                              DSRIDT     > DSRIDTTo)                                    CLE134
     C                   EVAL      DDRIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045566'                                 CLE134
                                                                                              CLE134
      ** - Ensure date on or after PDCL value date.                                           CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DSPDSts     = '*LIVE'       AND                            CLE134
     C                             DSPDVlD     > DSRIDT                                       CLE134
     C                   EVAL      #MsgID      = '5045580'                                    CLE134
     C                   EVAL      ErrorFound  = 'Y'                                          CLE134
     C                   EVAL      RetCodeIn   = 'Error'                                      CLE134
                                                                                              CLE134
      ** - Ensure maximum no of changes not exceeded.                                         CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        BPMXCH      > 0             AND                            CLE134
     C                             BPMXCH     <= @@RIDC                                       CLE134
     C                   EVAL      DDRIDTOK    = 'W'                                          CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = 'DDRIDT'                                  CLE134
     C                   EVAL      WMsgIDXAr(WId) = '5045571'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Initial Date.                                                                    CLE134
                                                                                              CLE134
     C                   IF        DDRIDTOK   <> 'N'                                          CLE134
     C                   EVAL      cCLRIDT     = DSRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRRCAT - Validate Reporting Classification                   *                       CLE134
      *****************************************************************                       CLE134
     C     SRRCAT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Check if Numeric and in Range.                                                       CLE134
                                                                                              CLE134
     C                   IF        DDRCAT      < '0'           OR                             CLE134
     C                             DDRCAT      > '9'                                          CLE134
     C                   EVAL      DDRCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDRCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045569'                               CLE134
                                                                                              CLE134
      ** Check if Active Value.                                                               CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      #A          = %DEC(DDRCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   IF        #A          > 0             AND                            CLE134
     C                             DSRCD(#A)   = *BLANKS                                      CLE134
     C                   EVAL      DDRCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDRCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045569'                               CLE134
                                                                                              CLE134
      ** - Check if Correct Classification level for Initial Date.                            CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDACT4     = 'I'                                         AR567846
     C                   IF        DSRCAT     <> 0             AND                            CLE134
     C                             DSRCAT     <> #A                                           CLE134
     C                   EVAL      DDRCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDRCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045567'                               CLE134
                                                                                              CLE134
      ** - Check if Maximum No of Changes Exceeded.                                           CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        BPMXCH      > 0             AND                            CLE134
     C                             BPMXCH     <= @@RICC                                       CLE134
     C                   EVAL      DDRCATOK    = 'W'                                          CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = 'DDRCAT'                                  CLE134
     C                   EVAL      WMsgIDXAr(WId) = '5045570'                                 CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                              AR567846
                                                                                              CLE134
      ** If valid, set Classification.                                                        CLE134
                                                                                              CLE134
     C                   IF        DDRCATOK   <> 'N'                                          CLE134
     C                   MOVE      DDRCAT        cCLRCAT                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRBDFT - Derive Basel II Default Values                      *                       CLE134
      *****************************************************************                       CLE134
     C     SRBDFT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Initialisation.                                                                      CLE134
                                                                                              CLE134
     C                   EVAL      DSBCAT      = 0                                            CLE134
     C                   EVAL      DSBIDTFm    = 0                                            CLE134
     C                   EVAL      DSBIDTTo    = 0                                            CLE134
                                                                                              CLE134
      ** If Basel II Classification Entered, Derive Valid Initial Date                        CLE134
      ** Range.                                                                               CLE134
                                                                                              CLE134
     C                   IF        DDBCAT      = *BLANKS                                      CLE134
     C                   EVAL      DDBCAT      = '0'                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDBCAT     >= '1'           AND                            CLE134
     C                             DDBCAT     <= '9'                                          CLE134
     C                   EVAL      #A          = %DEC(DDBCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   SELECT                                                               CLE134
     C                   WHEN      #A          = 1                                            CLE134
     C                   EVAL      DSBIDTFm    = BJRDNB - DSBCN(1)                            CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB                                       CLE134
                                                                                              CLE134
     C                   WHEN      DSBCN(#A)   = 999           OR                             CLE134
     C                             DSBCN(#A)   = 0                                            CLE134
     C                   EVAL      DSBIDTFm    = 0                                            CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB - DSBCN(#A-1)                         CLE134
                                                                                              CLE134
     C                   OTHER                                                                CLE134
     C                   EVAL      DSBIDTFm    = BJRDNB - DSBCN(#A)                           CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB - DSBCN(#A-1)                         CLE134
     C                   ENDSL                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Initial Date Entered, Derive Valid Classification.                       CLE134
                                                                                              CLE134
     C                   IF        DDBIDT     <> *BLANKS                                      CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DDBIDT                                       CLE134
     C     DSBIDT        PARM                    ZDAYNO                                       CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
     C                   IF        DSBIDT     <= BJRDNB        AND                            CLE134
     C                             ErrorFlag  <> 'Y'                                          CLE134
     C                   EVAL      DSDYS       = BJRDNB - DSBIDT                              CLE134
                                                                                              CLE134
     C                   IF        DSDYS       > 999                                          CLE134
     C                   EVAL      DSDYS       = 999                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         EVAL      DSBCAT      = %LOOKUPGT(DSDYS:DSBCN) - 1            CLE134 263080
     C                   EVAL      DSBCAT      = %LOOKUPGT(DSDYS:DSBCN)                       263080
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Classification Not Entered, Set Default.                                 CLE134
                                                                                              CLE134
     C                   IF        DDBCAT      = *BLANKS       AND                            CLE134
     C                             DSBCAT     <> 0                                            CLE134
     C                   EVAL      DDBCAT      = %CHAR(DSBCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Initial Date Not Entered, Set Default.                                   CLE134
                                                                                              CLE134
     C                   IF        DDBIDT      = *BLANKS       AND                            CLE134
     C                             DSBIDTTo   <> 0                                            CLE134
     C                   MOVE      DSBIDTTo      ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRBIDT - Validate Basel II Past Due Initial Date             *                       CLE134
      *****************************************************************                       CLE134
     C     SRBIDT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** If Active PDCL exists;                                                               CLE134
      ** - Initial Date must be entered;                                                      CLE134
                                                                                              CLE134
     C                   IF        DSPDSts      = '*LIVE'                                     CLE134
     C                   IF        DDBIDT      = *BLANKS                                      CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045767'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Else;                                                                                CLE134
      ** - Initial Date must not be entered.                                                  CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDBIDT     <> *BLANKS                                      CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045768'                                 CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Initial Date entered;                                                             CLE134
      ** - Convert Inital Date to Midas Day.                                                  CLE134
                                                                                              CLE134
     C**********         EVAL      CCLBIDT = *ZEROS                                  CLE134 MD052135
     C                   IF        DDBIDT     <> *BLANKS       AND                            CLE134
     C                             DDBIDTOK   <> 'N'                                          CLE134
     C                   MOVE      DDBIDT        DATEA                                        CLE134
     C                   TESTN                   DATEA                9798                    CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DATEA             6                          CLE134
     C                   PARM                    ZDAYNO            5 0                        CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
      ** - Invalid format or not numeric.                                                     CLE134
                                                                                              CLE134
     C                   IF        ErrorFlag   = 'Y'           OR                             CLE134
     C                             *IN97       = '0'           AND                            CLE134
     C                             *IN98       = '0'                                          CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045564'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DSBIDT      = ZDAYNO                                       CLE134
                                                                                              CLE134
      ** - If the date has changed;                                                           CLE134
      **    Ensure date isn't in the future.                                                  CLE134
                                                                                              CLE134
     C                   IF        DSBIDT     <> @@BIDT                                       CLE134
     C                   IF        DSBIDT      > BJRDNB                                       CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045761'                                 CLE134
                                                                                              CLE134
      ** - Ensure date falls within valid range.                                              CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DSBIDTFm   <> 0             AND                            CLE134
     C                             (DSBIDT     < DSBIDTFm      OR                             CLE134
     C                              DSBIDT     > DSBIDTTo)                                    CLE134
     C                   EVAL      DDBIDTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045762'                                 CLE134
                                                                                              CLE134
      ** - Ensure date on or after PDCL value date.                                           CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DSPDSts     = '*LIVE'       AND                            CLE134
     C                             DSPDVlD     > DSBIDT                                       CLE134
     C                   EVAL      #MsgID      = '5045769'                                    CLE134
     C                   EVAL      ErrorFound  = 'Y'                                          CLE134
     C                   EVAL      RetCodeIn   = 'Error'                                      CLE134
                                                                                              CLE134
      ** - Ensure maximum no of changes not exceeded.                                         CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        BPMXCH      > 0             AND                            CLE134
     C                             BPMXCH     <= @@BIDC                                       CLE134
     C                   EVAL      DDBIDTOK    = 'W'                                          CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = 'DDBIDT'                                  CLE134
     C                   EVAL      WMsgIDXAr(WId) = '5045766'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Initial Date.                                                                    CLE134
                                                                                              CLE134
     C                   IF        DDBIDTOK   <> 'N'                                          CLE134
     C                   EVAL      cCLBIDT     = DSBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  SRBCAT - Validate Basel II Past Due Status                   *                       CLE134
      *****************************************************************                       CLE134
     C     SRBCAT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Check if Numeric and in Range.                                                       CLE134
                                                                                              CLE134
     C                   IF        DDBCAT      < '0'           OR                             CLE134
     C                             DDBCAT      > '9'                                          CLE134
     C                   EVAL      DDBCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDBCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045764'                               CLE134
                                                                                              CLE134
      ** - Check if Active Value.                                                             CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      #A          = %DEC(DDBCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   IF        #A          > 0             AND                            CLE134
     C                             DSBCD(#A)   = *BLANKS                                      CLE134
     C                   EVAL      DDBCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDBCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045764'                               CLE134
                                                                                              CLE134
      ** - Check if Correct Classification level for Initial Date.                            CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDACT4     = 'I'                                         AR567846
     C                   IF        DSBCAT     <> 0             AND                            CLE134
     C                             DSBCAT     <> #A                                           CLE134
     C                   EVAL      DDBCATOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx)   = 'DDBCAT'                                CLE134
     C                   EVAL      MsgIDXAr(Idx)    = '5045763'                               CLE134
                                                                                              CLE134
      ** - Check if Maximum No of Changes Exceeded.                                           CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        BPMXCH      > 0             AND                            CLE134
     C                             BPMXCH     <= @@BICC                                       CLE134
     C                   EVAL      DDBCATOK    = 'W'                                          CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = 'DDBCAT'                                  CLE134
     C                   EVAL      WMsgIDXAr(WId) = '5045765'                                 CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                              AR567846
                                                                                              CLE134
      ** If valid, set Classification.                                                        CLE134
                                                                                              CLE134
     C                   IF        DDBCATOK   <> 'N'                                          CLE134
     C                   MOVE      DDBCAT        cCLBCAT                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
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
      *
      ***  Reset warning flags
      *
     C     SaveDDLNR4    IFNE      DDLNR4
      *    Add hereafter the warning flag
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
     C     I             SUB       1             WId
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
     C                   PARM                    TranInScr4
     C                   PARM                    TranInScr6                                   CLE134
                                                                                              CLE134
      ** (Current) Customer loan CL in file format                                            CLE134
                                                                                              CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      *
      ***  Extended data
     C                   PARM                    ExtData
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
     C                   PARM                    OKFlagsDS6                                   CLE134
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
     C                   PARM                    WId
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
     C                   MOVEL     'LECLIP4VL'   DBPGM
     C                   OUT       LDA
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
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE134
      ** Determine if Past Due Call Loan Processing is Installed.                             CLE134
                                                                                              CLE134
     C                   MOVE      'N'           CLE134            1                          CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD             6                          CLE134
                                                                                              CLE134
     C                   IF        @RTCD       = *BLANKS                                      CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Retrieve Lending ICD                                                                 CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      @LNTY       = CCLLTYP                                      CLE134
     C                   EVAL      @LNST       = CCLSUTP                                      CLE134
     C                   EVAL      @LNCL       = CCLCLAS                                      CLE134
                                                                                              CLE134
     C                   CALL      'AOLOANR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY   '     @OPTN                                        CLE134
     C                   PARM                    @LNTY             2                          CLE134
     C                   PARM                    @LNST             2                          CLE134
     C                   PARM                    @LNCL             4                          CLE134
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C                   EVAL      DBFILE      = 'SDLOANPD'                                   CLE134
     C                   EVAL      DBASE       = 6                                            CLE134
     C                   EVAL      DBKEY       = @OPTN                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   CALL      'AOCLNDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*FIRST '     @OPTN                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C                   EVAL      DBFILE      = 'SDCLNDPD'                                   CLE134
     C                   EVAL      DBASE       = 7                                            CLE134
     C                   EVAL      DBKEY       = @OPTN                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSBCN(1)    = BPCLN1                                       CLE134
     C                   EVAL      DSBCN(2)    = BPCLN2                                       CLE134
     C                   EVAL      DSBCN(3)    = BPCLN3                                       CLE134
     C                   EVAL      DSBCN(4)    = BPCLN4                                       CLE134
     C                   EVAL      DSBCN(5)    = BPCLN5                                       CLE134
     C                   EVAL      DSBCN(6)    = BPCLN6                                       CLE134
     C                   EVAL      DSBCN(7)    = BPCLN7                                       CLE134
     C                   EVAL      DSBCN(8)    = BPCLN8                                       CLE134
     C                   EVAL      DSBCN(9)    = BPCLN9                                       CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSBCN(#A)   = 0                                            CLE134
     C                   EVAL      DSBCN(#A)   = 9999                                         CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSBCD(1)    = BPCLD1                                       CLE134
     C                   EVAL      DSBCD(2)    = BPCLD2                                       CLE134
     C                   EVAL      DSBCD(3)    = BPCLD3                                       CLE134
     C                   EVAL      DSBCD(4)    = BPCLD4                                       CLE134
     C                   EVAL      DSBCD(5)    = BPCLD5                                       CLE134
     C                   EVAL      DSBCD(6)    = BPCLD6                                       CLE134
     C                   EVAL      DSBCD(7)    = BPCLD7                                       CLE134
     C                   EVAL      DSBCD(8)    = BPCLD8                                       CLE134
     C                   EVAL      DSBCD(9)    = BPCLD9                                       CLE134
                                                                                              CLE134
     C                   EVAL      DSRCN(1)    = BPRCN1                                       CLE134
     C                   EVAL      DSRCN(2)    = BPRCN2                                       CLE134
     C                   EVAL      DSRCN(3)    = BPRCN3                                       CLE134
     C                   EVAL      DSRCN(4)    = BPRCN4                                       CLE134
     C                   EVAL      DSRCN(5)    = BPRCN5                                       CLE134
     C                   EVAL      DSRCN(6)    = BPRCN6                                       CLE134
     C                   EVAL      DSRCN(7)    = BPRCN7                                       CLE134
     C                   EVAL      DSRCN(8)    = BPRCN8                                       CLE134
     C                   EVAL      DSRCN(9)    = BPRCN9                                       CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSRCN(#A)   = 0                                            CLE134
     C                   EVAL      DSRCN(#A)   = 9999                                         CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSRCD(1)    = BPRCD1                                       CLE134
     C                   EVAL      DSRCD(2)    = BPRCD2                                       CLE134
     C                   EVAL      DSRCD(3)    = BPRCD3                                       CLE134
     C                   EVAL      DSRCD(4)    = BPRCD4                                       CLE134
     C                   EVAL      DSRCD(5)    = BPRCD5                                       CLE134
     C                   EVAL      DSRCD(6)    = BPRCD6                                       CLE134
     C                   EVAL      DSRCD(7)    = BPRCD7                                       CLE134
     C                   EVAL      DSRCD(8)    = BPRCD8                                       CLE134
     C                   EVAL      DSRCD(9)    = BPRCD9                                       CLE134
     C                   ENDIF                                                                CLE134
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIP4V07
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE                                                                                  CLE134
     C     @DEFN         BEGSR                                                                CLE134
                                                                                              CLE134
      ** @DEFN: Definition Rountine.                                                          CLE134
                                                                                              CLE134
      ** Key List...                                                                          CLE134
                                                                                              CLE134
     C     KCLOANL4      KLIST                                                                CLE134
     C                   KFLD                    Kpd_RECI                                     CLE134
     C                   KFLD                    Kpd_LNRF                                     CLE134
                                                                                              CLE134
     C     KLEPDUEL2     KLIST                                                                CLE134
     C                   KFLD                    Kpd_YPORG                                    CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
