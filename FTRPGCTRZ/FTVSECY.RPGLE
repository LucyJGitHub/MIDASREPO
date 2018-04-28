     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate settle currency and amount')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSECY  - Validate Settle Currency & Amount                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8068            Date 31Aug05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 19Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 08Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8068 - Both settlement and pay amount should be           *
      *            acceptable if not equal to blank                   *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.                                                           CRE008
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CRE008
                                                                                              CRE008
      ** Array of Warning message IDs                                                         CRE008
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CRE008
                                                                                              CRE008
      ** Array of Warning message data.                                                       CRE008
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CRE008
                                                                                              CRE008
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * External DS Midas SD Trading ICD data
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CRE008
      ** Externally described DS for SAR details                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE008
     D SLCD          E                     EXTFLD(LCD)                                        CRE008
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Define full account to be passed for RE101901 parameters                             CRE008
     D***WkORCDS         DS            18                                              CRE008 CGL029
     D WkORCDS         DS                                                                     CGL029
     D*WkCNUM***               1      6  0                                             CRE008 CSD027
     D WkCNUM                  1      6                                                       CSD027
     D WkCCY                   7      9                                                       CRE008
     D***WkACOD*                10     13  0                                           CRE008 CGL029
     D***WkACSQ*                14     15  0                                           CRE008 CGL029
     D***WkBRCA*                16     18                                              CRE008 CGL029
     D WkACOD                 10     19  0                                                    CGL029
     D WkACSQ                 20     21  0                                                    CGL029
     D WkBRCA                 22     24                                                       CGL029
                                                                                              CRE008
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0                                                    CRE008
 
     D C#CURR          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
      ** Parameters used for call to RE101901                                                 CRE008
     D PRetCode        S              7                                                       CRE008
     D PInBranch       S              3                                                       CRE008
     D*PInCust**       S              6  0                                             CRE008 CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3                                                       CRE008
     D***PInACode        S              4  0                                           CRE008 CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0                                                    CRE008
     D PSetAmnt        S             15  0                                                    CRE008
     D POutBranch      S              3                                                       CRE008
     D*POutCust*       S              6  0                                             CRE008 CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3                                                       CRE008
     D***POutACode       S              4  0                                           CRE008 CGL029
     D POutACode       S             14  0                                                    CGL029
     D POutASeqN       S              2  0                                                    CRE008
     D POutRetNo       S             10  0                                                    CRE008
                                                                                              CRE008
     D***WkACodeC        S              4                                              CRE008 CGL029
     D WkACodeC        S             10                                                       CGL029
     D WkASeqNC        S              2                                                       CRE008
     D WkCustC         S              6                                                       CRE008
     D WkRetNoC        S             10                                                       CRE008
                                                                                              CRE008
     D CRE008          S              1                                                       CRE008
                                                                                              CRE008
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      Idx = 0
 
      * Settle currency validation
      *
     C                   Exsr      VSETCUR
 
      * Settle amount validation
      *
     C                   If        OKSmcy = 'Y'
     C                   If        @AmtVal = 'Y'
     C                   Exsr      VSETAMT
     C                   Else
     C                   Move      *Blank        ZFIELD
     C                   Move      SSMAM         ZFIELD
     C                   Exsr      VZALIGN
 
     C                   If        ZalignOK = 'Y'
     C                   Move      ZFIELD        @SMAM
     C                   End
     C                   End
     C                   End
 
      ** If CRE008 is on, ordering customer is valid and settlement amount is valid           CRE008
      ** Check the overdraft limit for the account                                            CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y' AND OKORC1 = 'Y' AND                          CRE008
     C                             OKSMAM = 'Y' AND OKSMCY = 'Y'                              CRE008
     C                   IF        @ORCT = 'R' OR @ORCT = 'P'                                 CRE008
                                                                                              CRE008
     C                   EXSR      SRODLChk                                                   CRE008
                                                                                              CRE008
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
      ** If an error was found, set the return code appropriately
     C                   If        OKSmcy = 'N' or
     C                             OKSmam = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
                                                                                              CRE008
      ** If warning was found, set the return code appropriately                              CRE008
                                                                                              CRE008
     C                   IF        OKORC1 = 'W' or                                            CRE008
     C                             OKSMAM = 'W'                                               CRE008
     C                   EVAL      RetCodeIn = 'WARN'                                         CRE008
     C                   ENDIF                                                                CRE008
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT                                                           *
     C******************************************************************
     C* VSETCUR - VALIDATION OF SETTLE CURRENCY                        *
     C*           MANDATORY - MUST BE OF TABLE TABTG10                 *
     C******************************************************************
     C*
     C     VSETCUR       BEGSR
 
     C                   If        SSMCY = *Blanks and
     C                             @NINEU = 'I'
     C                   Eval      SSMCY = BKEURO
     C                   End
 
      ** access currency file
     C                   CALLB     'AOCURRR0'
     C                   Parm      *BlankS       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      SSMCY         C#CURR
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        C#RTCD <> *BlankS
      * Send error to screen
     C                   Move      'N'           OKSmcy
     C                   Add       1             Idx
     C                   Movel     'SSMCY'       FldNamXAr(Idx)
     C                   Movel     'MMA0921'     MsgIdXAr(Idx)
 
     C* If not on file must set up decimal places etc for
     C* validation of other field
     C                   Eval      @PCDP = 0
     C                   Eval      @PSPOT = 1
     C                   Eval      @PMDIN = 0
     C                   Else
 
     C                   Move      C#CURR        SSMCY
 
     C                   If        A6INCY = 'Y'
     C                   Eval      @NTPSD = A6TPSD
     C                   End
 
     C                   If        @NINEU = 'I' and
     C                             SSMCY <> BKEURO or
     C                             @NINEU = 'E' and
     C                             A6INCY <> 'Y'
      * Send error to screen
     C                   Move      'N'           OKSmcy
     C                   Add       1             Idx
     C                   Movel     'SSMCY'       FldNamXAr(Idx)
     C                   Movel     'MMA0922'     MsgIdXAr(Idx)
 
     C                   End
 
     C*
     C** Move new standing data field into field used in program
     C*
     C                   If        A6MDIN = 'M'
     C                   Eval      @PMDIN= 1
     C                   Else
     C                   Eval      @PMDIN= 0
     C                   End
 
     C* Store decimal places spot rate multiply/divide ind
     C                   Eval      @PCDP = A6NBDP
     C                   Eval      @PSPOT = A6SPRT
 
     C* Change spot rate by buy spread
     C                   If        A6BYSS = '+'
     C                   Eval      @PBRAT = A6SPRT + A6BYSR
     C                   Else
     C                   Eval      @PBRAT = A6SPRT - A6BYSR
     C                   End
 
     C* Change spot rate by sell spread
     C                   If        A6SLSS = '+'
     C                   Eval      @PSRAT = A6SPRT + A6SLSR
     C                   Else
     C                   Eval      @PSRAT = A6SPRT - A6SLSR
     C                   End
 
     C                   End
 
     C* If settlement type is 10 must be sterling
     C                   If        SSTTP = '10' and
     C                             SSMCY <> BLCYCD
      * Send error to screen
     C                   Move      'N'           OKSmcy
     C                   Add       1             Idx
     C                   Movel     'SSMCY'       FldNamXAr(Idx)
     C                   Movel     'MMA0923'     MsgIdXAr(Idx)
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF SETTLE CURRENCY VALIDATION                             *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* VSETAMT - VALIDATION OF SETTLE AMOUNT                         *
     C*****************************************************************
     C*
     C     VSETAMT       BEGSR
     C*
     C                   If        SPYTP = 'RP'
 
      * Mandatory if pay amount not entered otherwise not permitted
 
     C                   If        SSMAM = *Blank  and
     C**********                   SPYAM = *Blank  or                                        BUG8068
     C                             SPYAM = *Blank                                            BUG8068
     C**********                   SSMAM <> *Blank and                                       BUG8068
     C**********                   SPYAM <> *Blank                                           BUG8068
      * Send error to screen
     C                   Move      'N'           OKSmam
     C                   Add       1             Idx
     C                   Movel     'SSMAM '      FldNamXAr(Idx)
     C                   Movel     'MMA0928'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   If        OKSmam = 'Y'
 
     C* If entered validate
     C                   If        SSMAM <> *Blank
     C                   Move      *Blank        ZFIELD
     C                   Move      SSMAM         ZFIELD
     C                   Exsr      VZALIGN
 
     C                   If        ZalignOK = 'Y'
     C                   Move      ZFIELD        @SMAM
     C                   Move      'P'           @FAIN
     C                   End
 
     C                   Else
     C                   Eval      @SMAM = 0
     C                   End
     C*
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF SETTLE AMOUNT VALIDATION                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* VZALIGN - VALIDATION OF NUMERIC FIELD                         *
     C*****************************************************************
     C     VZALIGN       BEGSR
     C*
     C                   Eval      ZADIG = 13 - @PCDP
     C                   Eval      ZADEC = @PCDP
 
      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK          1
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   Parm                    ZADIG             2 0
      *
     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKSmam
     C                   Add       1             Idx
     C                   Movel     'SSMAM'       FldNamXAr(Idx)
     C                   Movel     'MMA0924'     MsgIdXAr(Idx)
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF PAY AMOUNT VALIDATION                                  *
     C*****************************************************************
      /EJECT                                                                                  CRE008
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      *  SRODLChk - Overdraft Limit Check                             *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
                                                                                              CRE008
     C     SRODLChk      BEGSR                                                                CRE008
                                                                                              CRE008
     C                   EVAL      WkORCDS = @ORCDS                                           CRE008
     C                   EVAL      PInBranch = WkBRCA                                         CRE008
     C                   EVAL      PInCust   = WkCNUM                                         CRE008
     C                   EVAL      PInCurr   = WkCCY                                          CRE008
     C                   EVAL      PInACode  = WkACOD                                         CRE008
     C                   EVAL      PInASeqN  = WkACSQ                                         CRE008
     C                   Z-ADD     @SMAM         PSetAmnt                                     CRE008
                                                                                              CRE008
     C                   CALLB     'RE101901'                                                 CRE008
                                                                                              CRE008
      ** Return Code                                                                          CRE008
                                                                                              CRE008
     C                   PARM      *BLANKS       PRetCode                                     CRE008
                                                                                              CRE008
      ** Input parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch Code                                                                          CRE008
      ** Customer                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Settlement Amount (Debit Amount)                                                     CRE008
                                                                                              CRE008
     C                   PARM                    PInBranch                                    CRE008
     C                   PARM                    PInCust                                      CRE008
     C                   PARM                    PInCurr                                      CRE008
     C                   PARM                    PInACode                                     CRE008
     C                   PARM                    PInASeqN                                     CRE008
     C                   PARM                    PSetAmnt                                     CRE008
                                                                                              CRE008
      ** Ouput parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch                                                                               CRE008
      ** Customer                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Retail Account No. of account in error                                               CRE008
                                                                                              CRE008
     C                   PARM                    POutBranch                                   CRE008
     C                   PARM                    POutCust                                     CRE008
     C                   PARM                    POutCurr                                     CRE008
     C                   PARM                    POutACode                                    CRE008
     C                   PARM                    POutASeqN                                    CRE008
     C                   PARM                    POutRetNo                                    CRE008
                                                                                              CRE008
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*ODLMTX'              CRE008
     C                   EVAL      DBPGM = 'RE101901'                                         CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
     C                   EVAL      OKORC1 = 'W'                                               CRE008
     C                   EVAL      OKSMAM = 'W'                                               CRE008
     C                   EVAL      WIdx = WIdx + 1                                            CRE008
     C                   EVAL      WMsgIDXAr(WIdx) = 'FTA0131'                                CRE008
     C                   EVAL      WFldNmXAr(WIdx) = 'SSMAM'                                  CRE008
     C                   MOVE      POutCust      WkCustC                                      CRE008
     C                   MOVE      POutACode     WkACodeC                                     CRE008
     C                   MOVE      POutASeqN     WkASeqNC                                     CRE008
     C                   MOVE      POutRetNo     WkRetNoC                                     CRE008
                                                                                              CRE008
     C                   IF        POutRetNo = 0                                              CRE008
     C                   EVAL      WMsgDtXAr(WIdx) = POutBranch + '-' + WkCustC               CRE008
     C                              + '-' + POutCurr + '-' + WkACodeC                         CRE008
     C                              + '-' + WkASeqNC                                          CRE008
     C                   ELSE                                                                 CRE008
     C                   EVAL      WMsgDtXAr(WIdx) = POutBranch + '-' + WkCustC               CRE008
     C                              + '-' + POutCurr + '-' + WkACodeC                         CRE008
     C                              + '-' + WkASeqNC + '/' + WkRetNoC                         CRE008
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
      *****************************************************************                       CRE008
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   Parm                    WFldNmXAr                                    CRE008
     C                   Parm                    WMsgIDXAr                                    CRE008
     C                   Parm                    WMsgDtXAr                                    CRE008
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Read SDTRADPD for Trading Details
     C                   CALLB     'AOTRADR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDTRAD        Parm      SDTRAD        DSFDY
 
      ** Access SCSARDPD to determint if CRE008 is installed                                  CRE008
                                                                                              CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       @RTCD                                        CRE008
     C                   PARM      '*VERIFY'     @OPTN                                        CRE008
     C                   PARM      'CRE008'      PSARD             6                          CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
      ** An NRF (No Record Found) return code is valid.                                       CRE008
      ** Issue database error only for error return codes.                                    CRE008
                                                                                              CRE008
     C                   IF        @RTCD <> *BLANKS AND                                       CRE008
     C                             @RTCD <> '*NRF   '                                         CRE008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
     C                   EVAL      DBASE = 903                                                CRE008
     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        @RTCD = *BLANKS                                            CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
