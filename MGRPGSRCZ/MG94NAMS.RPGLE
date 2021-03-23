     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG External Extract Program')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG94NAMS - Midas MG MT94X Extract Program                    *
      *                                                               *
      *  Function:  This program Extracts the data into Extract file  *
      *             for Multicash format.                             *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML102C            Date 13Sep20               *
      *  Prev Amend No. MD050727           Date 28Feb20               *
      *                 AR826599           Date 28Feb20               *
      *                 CMG008             Date 28Feb20               *
      *                 EML104  *CREATE    Date 27Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML102C - Replace MGCONVPD with SDCONVPD                     *
      *  MD050727 - Emergency fix to enable alphanumeric batches      *
      *             to be processed. Please see SFDC 01793714         *
      *  AR826599 - Field ?29 is too long in :86: (Detl. Payments)    *
      *             (Child: AR826600)                                 *
      *  CMG008 - Upgrade of EMP005 to BF2.1 SP21                     *
      *           Non-SWIFT Character conversion                      *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Database Error Indicators                                    *
      *                                                               *
      *    U7         Abnormal Completion                             *
      *    U8         File Out of Balance                             *
      *    U7 + U8    Database Error                                  *
      *                                                               *
      *  Other Indicators                                             *
      *                                                               *
      *    99         Multi-purpose                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrRtvDetail  - Retrieve Details                              *
      *  SrLdStatDta  - Load Static Data                              *
      *  SrExtNwTrCd  - Extract Network Transaction code - GVC        *
      *  SrExtBookTxt - Extract field ?00 - Book Text                 *
      *  SrExtPayBen  - Extract fields ?20 & ?21 - Payer/Beneficiary  *
      *  SrExtCCyAmnt - Extract field ?22 - Currency and Amount       *
      *  SrExtChgAmnt - Extract field ?23 - Charge Currency and Amount*
      *  SrExtDtlPaym - Extract fields ?24 to ?29 - Details of Payment*
      *  SrExtAccount - Extract field ?31 - Payer/Beneficiary Account *
      *  SrConcatflds - Concatenate MultiCash fields in SWIFT fields  *
      *  SrConvFld86  - Convert Non-SWIFT chars found in FIELD 86     *                       CMG008
      *  ConvChar     - Convert and remove non-SWIFT characters       *                       CMG008
      *  BldConvFil   - Build conversion table for non-SWIFT chars    *                       CMG008
      *  *INZSR       - Program Initialisation routine                *
      *  *PSSR        - Program exception error routin                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDNTCDL0  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas Network Transaction Code
      *
     FDEALSALL  IF   E           K DISK    INFDS(@INFDS1) INFSR(*PSSR)
      ** Midas DL Deals file including historic
     F                                     INCLUDE(DEALSDCF:DLCHISD0:MMDELDP0)
      *
     F******MGCONVPD  IF   E           K DISK                   INFSR(*PSSR) USROPN   CMG008 EML102C
     FSDCONVPD  IF   E           K DISK                   INFSR(*PSSR) USROPN                EML102C
      ** MG Character Conversion file                                                         CMG008
      *                                                                                       CMG008
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data Structure for Posting detail in General Ledger format
      *
     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(Gl_)
     D  WkAcno                       10A   OVERLAY(GLPosting:23)
     D  WkChgr                        1S 0 OVERLAY(GLPosting:43)
     D  WkDlno                        6S 0 OVERLAY(GLPosting:178)
     D  MGADI2to6                   325A   OVERLAY(GLPosting:429)
      *
      ** Data Structure for Posting detail in Message Generation Format
      *
     D MGposting     E DS                  EXTNAME(MGX940PD) PREFIX(Mg_)
     D  WkAddInfo                   390A          OVERLAY(MGPosting:125)
     D  WkFlds86                    804A          OVERLAY(MGPosting:606)
     D  ArDtlPaym                    35A   DIM(6) OVERLAY(MGPosting:793)
      *
      ** File information data structure
      *
     D @INFDS1       E DS                  EXTNAME(Y2I1DSP)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Access Programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs, very long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Data Structure for Midas SD Network Transaction Identifier
      *
     D SDNTTI        E DS                  EXTNAME(SDNTTIPD)
      *
      ** Data Structure for Midas SD Branch codes
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Data Structure for Midas SD Message network details
      *
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      *                                                                                    BUG23280A
      ** External DS for account details                                                   BUG23280A
      *
     D                 DS
      *
      ** Arrays to retrieve Module Transaction according Deal Type
      *
     D TransType                     40    DIM(41) CTDATA PERRCD(1)
     D    TrDealType                  2    OVERLAY(TransType)
     D      TrFiller1                 1    OVERLAY(TransType:*NEXT)
     D    TrModuleID                  2    OVERLAY(TransType:*NEXT)
     D      TrFiller2                 1    OVERLAY(TransType:*NEXT)
     D    TrDescrip                  34    OVERLAY(TransType:*NEXT)
      *                                                                                    BUG23280A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Key List Parameters
      *
     D KNwrk           S                   LIKE(EDNWRK)
     D KTrCd           S                   LIKE(NTTRCD)
      *
     D CMG008          S              1                                                       CMG008
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PBrca           S                   LIKE(Gl_BRCA)
     D PCusN           S              6A
     D PCcy            S              3A
     D PAcctCde        S             10A
     D PAcctSeq        S              2A
     D PNwrk           S                   LIKE(Gl_MGNWRK)
     D PMsgTyp         S                   LIKE(Gl_MGMTPY)
     D PRtty           S              5A
     D PReturnOut      S             10A
     D PSCcy           S              3A
     D PAmnt           S             13P 0
     D PSAmnt          S             17A
     D PErr            S              1A
     D PSSwDc          S              1A
     D Wx              S              5U 0
     D WkModuleID      S              2A
     D WkDealType      S              2A
     D WkField6        S              6A
     D WkDtlPaym       S            600A
     D WIdx            S              5U 0
     D WPos            S              5U 0
     D WAddInfo        S                   LIKE(WkAddInfo)
     D WContFld        S                   LIKE(Mg_MGADI1)
     D WKContFld       S                   LIKE(Mg_MGADI1)
     D WSubFld         S              2A
     D WkInfoPos       S              5U 0
     D WkMaxLen        S              5U 0
     D WkLength        S              5U 0
      *
      *                                                                                       CMG008
     D ValSwiftChr     C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ+                 CMG008
     D                                            abcdefghijklmnopqrstuvwxyz+                 CMG008
     D                                            0123456789+()?:-/,''. ')                    CMG008
      ** Valid Swift Characters                                                               CMG008
      *                                                                                       CMG008
     D WBlank          C                   CONST(' ')                                         CMG008
      ** Replacement Blank character                                                          CMG008
      *                                                                                       CMG008
     D WConvFld        S             65A                                                      CMG008
      ** String to be converted                                                               CMG008
      *                                                                                       CMG008
     D To_Char         S            100A                                                      CMG008
      ** TO character string                                                                  CMG008
      *                                                                                       CMG008
     D Fr_Char         S            100A                                                      CMG008
      ** FROM character string                                                                CMG008
      *                                                                                       CMG008
     D WChrPos         S              3S 0                                                    CMG008
      ** Work field for %CHECK and %REPLACE operation                                         CMG008
      *                                                                                       CMG008
     D WChrLen         S              3S 0                                                    CMG008
      ** Work field for %SUBST operation                                                      CMG008
      *                                                                                       CMG008
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Clear previous loading in fields :86:
      *
     C                   EVAL      WkAddInfo = *Blanks
     C                   EVAL      WkFlds86  = *Blanks
      *
      ** Retrieve Details
      *
     C                   EXSR      SrRtvDetail
      *
      ** Load Static Data
      *
     C                   EXSR      SrLdStatDta
      *
      ** Extract data for Network Transaction code - GVC
      *
     C                   EXSR      SrExtNwTrCd
      *
      ** Extract data for field ?00 - Book Text
      *
     C                   EXSR      SrExtBookTxt
      *
      ** Extract data for fields ?20 & ?21 - Payer/Beneficiary
      *
     C                   EXSR      SrExtPayBen
      *
      ** Extract data for field ?22 - Original Currency and Amount
      *
     C                   EXSR      SrExtCCyAmnt
      *
      ** Extract data for field ?23 - Charges Currency and Amount
      *
     C                   EXSR      SrExtChgAmnt
      *
      ** Extract data for fields ?24 to ?29 - Details of Payment
      *
     C                   EXSR      SrExtDtlPaym
      *
      ** Extract data for field ?31 - Payer/Beneficiary Account
      *
     C                   EXSR      SrExtAccount
      *
      ** Concatenate MultiCash fields in SWIFT Fields
      *
     C                   IF        EDF86F = 'SWIFT'
     C                   EXSR      SrConcatflds
     C                   ENDIF
      *
      ** Convert Non-SWIFT chars found in FIELD 86 output fields                              CMG008
      *                                                                                       CMG008
     C                   IF        CMG008 = 'Y'                                               CMG008
     C                   EXSR      SrConvFld86                                                CMG008
     C                   ENDIF                                                                CMG008
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvDetail - Retrieve Details                               *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrRtvDetail   BEGSR
      *
     C                   EVAL      WkModuleID = *BLANKS
     C                   EVAL      WkDealType = %SUBST(Gl_OTTP:1:2)
      *
     C                   SELECT
      *
      ** Lending
      *
     C                   WHEN      Gl_SPOS = '  GE-LE'
     C                   EVAL      WkModuleID = 'LE'
      *
      ** Dealing
      *
     C                   WHEN      Gl_SPOS = '  GE-DL'
     C                   EVAL      Wx = 1
     C     WkDealType    LOOKUP    TrDealType(Wx)                         99
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      WkModuleID = TrModuleID(Wx)
     C                   ENDIF
      *
      ** Fund Transfer
      *
     C                   WHEN      Gl_SPOS = '  GE-FT'
     C                   EVAL      WkModuleID = 'FT'
      *
      ** General Ledger
      *
     C                   WHEN      Gl_SPOS = '  GE-XF' OR
     C                             Gl_SPOS = '  GE-XB'
     C                   EVAL      WkModuleID = 'GL'
      *
      ** Securities Trading module
      *
     C                   WHEN      Gl_SPOS = '  GE-ST'
     C                   EVAL      WkModuleID = 'SE'
      *
      ** Customer Exchange transactions
      *
     C                   WHEN      Gl_SPOS = '  GE-CE'
     C                   EVAL      WkModuleID = 'RE'
      *
      ** Standing Order
      *
     C                   WHEN      Gl_SPOS = '  GE-SO'
     C                   EVAL      WkModuleID = 'SO'
      *
     C                   ENDSL
      *
      **  Retail Transaction Type
      *
     C                   IF        %SUBST(Gl_OTRF:1:2) = '91'
     C                   EVAL      WkField6 = %SUBST(Gl_OTRF:1:6)
     C     '0123456789'  CHECK     WkField6      Wx
      *
     C                   IF        Wx = 6
     C                   EVAL      WkModuleID = 'RE'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Batch Transaction
      *
     C*****'0123456789'**CHECK     Gl_SPOS       Wx                                         MD050727
     C     '0123456789'  CHECK     Gl_SPOS:4     Wx                                         MD050727
      *
      ** Source of Posting contains 6 numeric digits (batch number +
      ** batch item)
      ** Source of Posting can also contain an alphanumeric batch                           MD050727
      ** number (First 3 postitions) + batch item                                           MD050727
      *
     C                   IF        Wx = 7
     C                   EVAL      WkModuleID = 'BA'
     C                   ENDIF
      *
      ** Retrieve the network details
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      Gl_MGNWRK     PNwrk
     C     SDNWRK        PARM      SDNWRK        DSLDY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLdStatDta - Load Static Data                               *
      *                                                               *
      *****************************************************************
      *
     C     SrLdStatDta   BEGSR
     C                   EVAL      Mg_MGTRAT = Gl_TRAT
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtNwTrCd - Extract Network Transaction Code - GVC Code    *
      *                                                               *
      *****************************************************************
      *
     C     SrExtNwTrCd   BEGSR
      *
      ** Load default value from Network definition.
      *
     C                   IF        Gl_DRCR = 0
     C                   EVAL      Mg_MG86GV = EDGVCD                           Debit
     C                   ELSE
     C                   EVAL      Mg_MG86GV = EDGVCC                           Credit
     C                   ENDIF
      *
      ** Retrieve Network Transaction Code associated to the Retail Transaction Type
      *
     C                   MOVE      Gl_TRAT       PRtty
      *
     C                   CALL      'AONTTIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PRtty
     C                   PARM      Gl_MGNWRK     PNwrk
     C     SDNTTI        PARM      SDNTTI        DSFDY
      *
     C                   IF        PRtcd = *Blanks
     C                             AND NINTTI <> *Blanks
     C                   EVAL      Mg_MG86GV = %TRIM(NINTTI)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtBookTxt - Extract Book Text                             *
      *                                                               *
      *****************************************************************
      *
     C     SrExtBookTxt  BEGSR
      *
      ** Retrieve the description of the Network Transaction Code.
      *
     C                   IF        Mg_MG86GV <> *Blanks
     C                   EVAL      KNwrk     =  Gl_MGNWRK                       Network
     C                   EVAL      KTrCd     =  Mg_MG86GV                       Network Trans. Code
     C     KNtCd         CHAIN     SDNTCDL0
     C                   IF        %FOUND(SDNTCDL0)
     C                   EVAL      Mg_MG8600 = NTDESC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtPayBen - Detail Extract Payer/Beneficiary               *
      *                                                               *
      *****************************************************************
      *
     C     SrExtPayBen   BEGSR
      *
     C                   SELECT
      *
      ** Journal entry + Transfer + No Charge&Commission + Extended detail.
      *
     C                   WHEN      WkModuleID    =  'BA'
     C                             AND Mg_MG86GV =  '051'
     C                             AND WkChgr    <> 1
     C                             AND Gl_MGADI1 <> *Blanks
      *
     C                   EVAL      Mg_MG8620 = %SUBST(Gl_MGADI1:1:27)
     C                   EVAL      Mg_MG8621 = %SUBST(Gl_MGADI1:28:8)
      *
     C                   OTHER
      *
      ** Load default value: Branch TID Address.
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      Gl_BRCA       PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd = *Blanks
     C                             AND A8BTID <> *Blanks
     C                   EVAL      Mg_MG8620 = %SUBST(A8BTID:1:8)
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Dealing Entry
      *
     C                   IF        Gl_DLREF      <> *BLANKS
     C                             AND Gl_SPOS =  '  GE-DL'
     C                   EVAL      Mg_MG8621 = 'CONTRACT ' +
     C                                          %SUBST(Gl_DLREF:2:6)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtCCyAmnt - Extract Original Currency and Amount          *
      *                                                               *
      *****************************************************************
      *
     C     SrExtCCyAmnt  BEGSR
      *
     C                   IF        WkModuleID    =  'BA'
     C                             AND Mg_MG86GV =  '051'
     C                             AND WkChgr    <> 1
     C                             OR
     C                             Mg_MG86GV     =  '210'
      *
     C                   CALL      'ZM0040'                             99
     C                   PARM      Gl_PSTA       PAmnt                          Amount
     C                   PARM      Gl_CCY        PCcy                           Currency
     C                   PARM      *BLANKS       PSAmnt                         Formatted Amount
     C                   PARM      *Blanks       PSCcy                          SWIFT currency code
     C                   PARM      *Blanks       PErr                           Error
     C                   PARM      *Blanks       PSSwDc
      *
     C                   IF        NOT *IN99
     C                             AND PErr = *Blanks
     C                   EVAL      Mg_MG8622 = 'OCMT/' + PSCcy + PSAmnt
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtChgAmnt - Extract Charges Currency and Amount           *
      *                                                               *
      *****************************************************************
      *
     C     SrExtChgAmnt  BEGSR
      *
     C                   IF        WkModuleID    = 'BA'
     C                             AND Mg_MG86GV = '051'
     C                             AND WkChgr    = 1
      *
     C                   CALL      'ZM0040'                             99
     C                   PARM      Gl_PSTA       PAmnt                          Amount
     C                   PARM      Gl_CCY        PCcy                           Currency
     C                   PARM      *BLANKS       PSAmnt                         Formatted Amount
     C                   PARM      *Blanks       PSCcy                          SWIFT currency code
     C                   PARM      *Blanks       PErr                           Error
     C                   PARM      *Blanks       PSSwDc
      *
     C                   IF        NOT *IN99
     C                             AND PErr = *Blanks
     C                   EVAL      Mg_MG8623 = 'CHGS/SHA/' + PSCcy
     C                                         + PSAmnt
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtDtlPaym - Extract Details of Payment                    *
      *                                                               *
      *****************************************************************
      *
     C     SrExtDtlPaym  BEGSR
      *
     C                   SELECT
     C                   WHEN      WkModuleID    =  'BA'
     C                             AND Gl_MGADI1 <> *Blanks
      *
     C                   IF        WkModuleID    =  'BA'
     C                             AND Mg_MG86GV =  '051'
     C                             AND WkChgr    <> 1
     C                   EVAL      WkDtlPaym = MGADI2to6
     C                   ELSE
     C                   EVAL      WkDtlPaym = %TRIM(Gl_MGADI1)
     C                                       + ' ' + MGADI2to6
     C                   ENDIF
      *
     C                   EVAL      WIdx = 1
     C                   EVAL      WPos = 1
      *
     C**********         DOW       WIdx <= 6                                                AR826599
     C                   DOW       WIdx <= 5                                                AR826599
     C                   EVAL      ArDtlPaym(WIdx) =
     C                             %SUBST(WkDtlPaym:WPos:27)
     C                   ADD       1             WIdx
     C                   ADD       27            Wpos
     C                   ENDDO
      *                                                                                     AR826599
      ** 29 is only 5 char long and not 27                                                  AR826599
      *                                                                                     AR826599
     C                   EVAL      ArDtlPaym(WIdx) =                                        AR826599
     C                             %SUBST(WkDtlPaym:WPos:5)                                 AR826599
     C                   ADD       1             WIdx                                       AR826599
     C                   ADD       5             Wpos                                       AR826599
      *
      *
      ** Deposit Entry
      *
     C                   WHEN      Gl_DLREF      <> *BLANKS
     C                             AND Gl_SPOS =  '  GE-DL'
     C                             AND Mg_MG86GV <> '210'
      *
     C     WkDlno        CHAIN     DEALSALL
     C                   IF        %FOUND(DEALSALL)
      *
      *** Do setup regarding Format read
      *
     C                   If        @1FFM <> 'MMDELDP0'
      *
      ** Value Date
     C                   CALL      'ZM0065'                             99
     C                   PARM      VDAT          ZDAYNO            5 0          Day Number
     C                   PARM      *BLANKS       ZSDATE            6            YYMMDD
     C                   PARM      *BLANKS       ZSDATC            8            CCYYMMDD
      *
     C                   EVAL      Mg_MG8625 = 'FROM ' + ZSDATC
      *
      ** Maturity Date
     C                   IF        MDAT <> *Zeros
     C                   CALL      'ZM0065'                             99
     C                   PARM      MDAT          ZDAYNO            5 0          Day Number
     C                   PARM      *BLANKS       ZSDATE            6            YYMMDD
     C                   PARM      *BLANKS       ZSDATC            8            CCYYMMDD
      *
     C                   EVAL      Mg_MG8625 = %TRIM(Mg_MG8625) +' TO '+ ZSDATC
     C                   ENDIF
      *
      ** Interest Rate
     C                   IF        INTR <> *Zeros
     C                   CALL      'ZM0010'                             99
     C                   PARM      INTR          ZINRT            11 7          Interest Rate
     C                   PARM      *Blanks       ZSINRT           12            SWIFT Int. Rate
     C                   EVAL      Mg_MG8626 = 'RATE ' + ZSINRT
     C                   ENDIF
      *
     C                   ELSE
      *
      **  In case of MMDELDP0, then
      *
      ** Value Date
     C                   MOVE      HKVDYY        WKYY4A            4
     C                   MOVE      HKVDMM        WKMM2A            2
     C                   MOVE      HKVDDD        WKDD2A            2
     C                   EVAL      Mg_MG8625 = 'FROM ' + WKYY4A
     C                                                 + WKMM2A
     C                                                 + WKDD2A
      *
      ** Maturity Date
     C                   IF        HKMDYY <> *Zeros
     C                   MOVE      HKMDYY        WKYY4A
     C                   MOVE      HKMDMM        WKMM2A
     C                   MOVE      HKMDDD        WKDD2A
     C                   EVAL      Mg_MG8625 = %TRIM(Mg_MG8625) +
     C                                         ' TO '  + WKYY4A
     C                                                 + WKMM2A
     C                                                 + WKDD2A
     C                   ENDIF
      *
      ** Interest Rate
     C                   IF        HKINTR <> *Zeros
     C                   CALL      'ZM0010'                             99
     C                   PARM      HKINTR        ZINRT            11 7          Interest Rate
     C                   PARM      *Blanks       ZSINRT           12            SWIFT Int. Rate
     C                   EVAL      Mg_MG8626 = 'RATE ' + ZSINRT
     C                   ENDIF
      *
     C                   ENDIF                                                  @1FFM
      *
     C                   ENDIF                                                  %Found
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtAccount - Extract Payer/Beneficiary Account             *
      *                                                               *
      *****************************************************************
      *
     C     SrExtAccount  BEGSR
      *
     C                   IF        Gl_ACNO <> *Zeros
     C                   EVAL      Mg_MG8631 = WkAcno
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      **************************************************************************
      *                                                                        *
      * SrConcatflds : Concatenate MultiCash fields in SWIFT Fields            *
      *                                                                        *
      **************************************************************************
      *
     C     SrConcatflds  BEGSR
      *
     C                   Eval      WAddInfo  = *Blanks
     C                   Eval      WKInfoPos = 1
     C                   Eval      WKMaxLen  = %LEN(WkAddInfo)
      *
      ** Concate MG86GV
     C                   Eval      WSubFld   = *Blanks
     C                   Eval      WContFld  = Mg_MG86GV
     C                   Exsr      ContFlds
      ** Concate MG8600
     C                   Eval      WSubFld   = '00'
     C                   Eval      WContFld  = Mg_MG8600
     C                   Exsr      ContFlds
      ** Concate MG8610
     C                   Eval      WSubFld   = '10'
     C                   Eval      WContFld  = Mg_MG8610
     C                   Exsr      ContFlds
      ** Concate MG8620
     C                   Eval      WSubFld   = '20'
     C                   Eval      WContFld  = Mg_MG8620
     C                   Exsr      ContFlds
      ** Concate MG8621
     C                   Eval      WSubFld   = '21'
     C                   Eval      WContFld  = Mg_MG8621
     C                   Exsr      ContFlds
      ** Concate MG8622
     C                   Eval      WSubFld   = '22'
     C                   Eval      WContFld  = Mg_MG8622
     C                   Exsr      ContFlds
      ** Concate MG8623
     C                   Eval      WSubFld   = '23'
     C                   Eval      WContFld  = Mg_MG8623
     C                   Exsr      ContFlds
      ** Concate MG8624
     C                   Eval      WSubFld   = '24'
     C                   Eval      WContFld  = Mg_MG8624
     C                   Exsr      ContFlds
      ** Concate MG8625
     C                   Eval      WSubFld   = '25'
     C                   Eval      WContFld  = Mg_MG8625
     C                   Exsr      ContFlds
      ** Concate MG8626
     C                   Eval      WSubFld   = '26'
     C                   Eval      WContFld  = Mg_MG8626
     C                   Exsr      ContFlds
      ** Concate MG8627
     C                   Eval      WSubFld   = '27'
     C                   Eval      WContFld  = Mg_MG8627
     C                   Exsr      ContFlds
      ** Concate MG8628
     C                   Eval      WSubFld   = '28'
     C                   Eval      WContFld  = Mg_MG8628
     C                   Exsr      ContFlds
      ** Concate MG8629
     C                   Eval      WSubFld   = '29'
     C                   Eval      WContFld  = Mg_MG8629
     C                   Exsr      ContFlds
      ** Concate MG8630
     C                   Eval      WSubFld   = '30'
     C                   Eval      WContFld  = Mg_MG8630
     C                   Exsr      ContFlds
      ** Concate MG8631
     C                   Eval      WSubFld   = '31'
     C                   Eval      WContFld  = Mg_MG8631
     C                   Exsr      ContFlds
      ** Concate MG8632
     C                   Eval      WSubFld   = '32'
     C                   Eval      WContFld  = Mg_MG8632
     C                   Exsr      ContFlds
      ** Concate MG8633
     C                   Eval      WSubFld   = '33'
     C                   Eval      WContFld  = Mg_MG8633
     C                   Exsr      ContFlds
      ** Concate MG8634
     C                   Eval      WSubFld   = '34'
     C                   Eval      WContFld  = Mg_MG8634
     C                   Exsr      ContFlds
      ** Concate MG8635
     C                   Eval      WSubFld   = '35'
     C                   Eval      WContFld  = Mg_MG8635
     C                   Exsr      ContFlds
      ** Concate MG8636
     C                   Eval      WSubFld   = '36'
     C                   Eval      WContFld  = Mg_MG8636
     C                   Exsr      ContFlds
      ** Concate MG8638
     C                   Eval      WSubFld   = '38'
     C                   Eval      WContFld  = Mg_MG8638
     C                   Exsr      ContFlds
      ** Concate MG8660
     C                   Eval      WSubFld   = '60'
     C                   Eval      WContFld  = Mg_MG8660
     C                   Exsr      ContFlds
      ** Concate MG8661
     C                   Eval      WSubFld   = '61'
     C                   Eval      WContFld  = Mg_MG8661
     C                   Exsr      ContFlds
      ** Concate MG8662
     C                   Eval      WSubFld   = '62'
     C                   Eval      WContFld  = Mg_MG8662
     C                   Exsr      ContFlds
      ** Concate MG8663
     C                   Eval      WSubFld   = '63'
     C                   Eval      WContFld  = Mg_MG8663
     C                   Exsr      ContFlds
      ** Concate MG8664
     C                   Eval      WSubFld   = '64'
     C                   Eval      WContFld  = Mg_MG8664
     C                   Exsr      ContFlds
      ** Concate MG8665
     C                   Eval      WSubFld   = '65'
     C                   Eval      WContFld  = Mg_MG8665
     C                   Exsr      ContFlds
      ** Clear MG_86xx fields
     C                   EVAL      WkFlds86  = *Blanks
      ** Load MGPosting
     C                   Eval      WkAddInfo = WAddInfo
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ContFlds : Concatenate fields                                 *
      *                                                               *
      *****************************************************************
      *
     C     ContFlds      BEGSR
      *
     C                   IF        WContFld  <>  *Blanks  AND
     C                             WkInfoPos <=  WkMaxLen
      ** Insert subfield tag
     C                   IF        WSubFld <> *Blanks
     C                   EVAL      WkContFld = EDFSEP + WSubFld + WContFld
     C                   ELSE
     C                   EVAL      WkContFld = WContFld
     C                   ENDIF
      ** Concate fields
     C                   EVAL      WkLength  =   %LEN(%TRIM(WkContFld))
     C                   EVAL      %SUBST(WAddInfo:WkInfoPos) = WkContFld
     C                   ADD       WkLength      WkInfoPos
     C                   ENDIF
      *
     C                   Eval      WContFld  = *Blanks
     C                   Eval      WSubFld   = *Blanks
      *
     C                   ENDSR
      *
      **************************************************************************
      /EJECT
      **************************************************************************              CMG008
      *                                                                        *              CMG008
      * SrConvFld86 : Convert Non-SWIFT chars found in FIELD 86 output fields  *              CMG008
      *                                                                        *              CMG008
      **************************************************************************              CMG008
      *                                                                                       CMG008
     C     SrConvFld86   BEGSR                                                                CMG008
      *                                                                                       CMG008
      ** Convert MGADI1                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI1                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI1 = WConvFld                                       CMG008
      ** Convert MGADI2                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI2                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI2 = WConvFld                                       CMG008
      ** Convert MGADI3                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI3                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI3 = WConvFld                                       CMG008
      ** Convert MGADI4                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI4                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI4 = WConvFld                                       CMG008
      ** Convert MGADI5                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI5                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI5 = WConvFld                                       CMG008
      ** Convert MGADI6                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MGADI6                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MGADI6 = WConvFld                                       CMG008
      ** Convert MG86GV                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG86GV                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG86GV = WConvFld                                       CMG008
      ** Convert MG8600                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8600                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8600 = WConvFld                                       CMG008
      ** Convert MG8610                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8610                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8610 = WConvFld                                       CMG008
      ** Convert MG8620                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8620                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8620 = WConvFld                                       CMG008
      ** Convert MG8621                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8621                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8621 = WConvFld                                       CMG008
      ** Convert MG8622                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8622                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8622 = WConvFld                                       CMG008
      ** Convert MG8623                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8623                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8623 = WConvFld                                       CMG008
      ** Convert MG8624                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8624                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8624 = WConvFld                                       CMG008
      ** Convert MG8625                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8625                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8625 = WConvFld                                       CMG008
      ** Convert MG8626                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8626                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8626 = WConvFld                                       CMG008
      ** Convert MG8627                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8627                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8627 = WConvFld                                       CMG008
      ** Convert MG8628                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8628                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8628 = WConvFld                                       CMG008
      ** Convert MG8629                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8629                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8629 = WConvFld                                       CMG008
      ** Convert MG8630                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8630                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8630 = WConvFld                                       CMG008
      ** Convert MG8631                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8631                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8631 = WConvFld                                       CMG008
      ** Convert MG8632                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8632                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8632 = WConvFld                                       CMG008
      ** Convert MG8633                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8633                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8633 = WConvFld                                       CMG008
      ** Convert MG8634                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8634                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8634 = WConvFld                                       CMG008
      ** Convert MG8635                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8635                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8635 = WConvFld                                       CMG008
      ** Convert MG8636                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8636                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8636 = WConvFld                                       CMG008
      ** Convert MG8638                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8638                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8638 = WConvFld                                       CMG008
      ** Convert MG8660                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8660                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8660 = WConvFld                                       CMG008
      ** Convert MG8661                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8661                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8661 = WConvFld                                       CMG008
      ** Convert MG8662                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8662                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8662 = WConvFld                                       CMG008
      ** Convert MG8663                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8663                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8663 = WConvFld                                       CMG008
      ** Convert MG8664                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8664                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8664 = WConvFld                                       CMG008
      ** Convert MG8665                                                                       CMG008
     C                   Eval      WConvFld  = *Blanks                                        CMG008
     C                   Eval      WConvFld  = Mg_MG8665                                      CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      Mg_MG8665 = WConvFld                                       CMG008
      *                                                                                       CMG008
     C                   ENDSR                                                                CMG008
      *                                                                                       CMG008
      **************************************************************************              CMG008
      /EJECT                                                                                  CMG008
      **************************************************************************              CMG008
      *                                                                        *              CMG008
      * ConvChar : Convert Character and remove remove invalid non-SWIFT chars *              CMG008
      *                                                                        *              CMG008
      **************************************************************************              CMG008
      *                                                                                       CMG008
     C     ConvChar      BEGSR                                                                CMG008
      *                                                                                       CMG008
      ** Only process field if not blank                                                      CMG008
      *                                                                                       CMG008
     C                   If        WConvFld <> *BLANKS                                        CMG008
      *                                                                                       CMG008
      ** Convert all non-SWIFT characters based on conversion table                           CMG008
      *                                                                                       CMG008
     C                   Eval      WConvFld = %XLATE(%TRIM(Fr_Char)                           CMG008
     C                                        :%TRIM(To_Char):WConvFld)                       CMG008
      *                                                                                       CMG008
      ** Convert all remaining non-SWIFT chars (not defined in the table)                     CMG008
      ** into blanks. Use pre-defined 'Valid Swift Chars' field for comparison.               CMG008
      *                                                                                       CMG008
     C                   Eval      WChrPos = 0                                                CMG008
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                     CMG008
      *                                                                                       CMG008
      ** Repeat process until all invalid chars are found and converted to blank              CMG008
      *                                                                                       CMG008
     C                   Dow       WChrPos > 0                                                CMG008
     C                   Eval      WConvFld=%REPLACE(WBlank:WConvFld:WChrPos:1)               CMG008
     C                   Eval      WChrPos = 0                                                CMG008
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                     CMG008
     C                   Enddo                                                                CMG008
                                                                                              CMG008
     C                   Endif                                                                CMG008
      *                                                                                       CMG008
     C                   ENDSR                                                                CMG008
      *                                                                                       CMG008
      **************************************************************************              CMG008
      /EJECT                                                                                  CMG008
      **************************************************************************              CMG008
      *                                                                        *              CMG008
      * BldConvFil : Build Conversion Table for removing non-SWIFT characters  *              CMG008
      *                                                                        *              CMG008
      **************************************************************************              CMG008
      *                                                                                       CMG008
     C     BldConvFil    BEGSR                                                                CMG008
      *                                                                                       CMG008
      ** Open Character conversion file                                                       CMG008
      *                                                                                       CMG008
     C**********         Open      MGCONVPD                                           CMG008 EML102C
     C                   Open      SDCONVPD                                                  EML102C
      *                                                                                       CMG008
      ** Initialise work fields                                                               CMG008
      *                                                                                       CMG008
     C                   Eval      Fr_Char = *Blanks                                          CMG008
     C                   Eval      To_Char = *Blanks                                          CMG008
     C                   Eval      WChrLen = 0                                                CMG008
      *                                                                                       CMG008
      ** Read file and collect characters in FROM and TO alpha fields                         CMG008
      *                                                                                       CMG008
     C******Loval        Setll     MGCONVPD                                           CMG008 EML102C
     C**********         Read      MGCONVPD                                           CMG008 EML102C
     C     *Loval        Setll     SDCONVPD                                                  EML102C
     C                   Read      SDCONVPD                                                  EML102C
      *                                                                                       CMG008
     C                   Dow       NOT %EOF                                                   CMG008
     C                   Eval      Fr_Char = %SUBST(Fr_Char:1:WChrLen)+FRCHAR                 CMG008
     C                   Eval      To_Char = %SUBST(To_Char:1:WChrLen)+TOCHAR                 CMG008
     C                   Eval      WChrLen = WChrLen + 1                                      CMG008
      *                                                                                       CMG008
     C**********         Read      MGCONVPD                                           CMG008 EML102C
     C                   Read      SDCONVPD                                                  EML102C
     C                   Enddo                                                                CMG008
      *                                                                                       CMG008
      ** Close file                                                                           CMG008
      *                                                                                       CMG008
     C**********         Close     MGCONVPD                                           CMG008 EML102C
     C                   Close     SDCONVPD                                                  EML102C
      *                                                                                       CMG008
     C                   ENDSR                                                                CMG008
      *                                                                                       CMG008
      *****************************************************************                       CMG008
      /EJECT                                                                                  CMG008
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnOut
     C                   PARM                    PMsgTyp
     C                   PARM                    GLPosting
     C                   PARM                    MGPosting
      *
      ** Check if feature CMG008 is installed                                                 CMG008
      *                                                                                       CMG008
     C                   EVAL      CMG008 = 'N'                                               CMG008
      *                                                                                       CMG008
     C                   CALL      'AOSARDR0'                                                 CMG008
     C                   PARM      *BLANKS       PRtcd                          Return Code   CMG008
     C                   PARM      '*VERIFY'     POptn                          Option        CMG008
     C                   PARM      'CMG008 '     PSard                          Feature Ref   CMG008
      *                                                                                       CMG008
     C                   IF        PRtcd = *BLANKS                                            CMG008
      *                                                                                       CMG008
     C                   EVAL      CMG008 = 'Y'                                               CMG008
      *                                                                                       CMG008
      ** Build the character conversion table                                                 CMG008
      *                                                                                       CMG008
     C                   EXSR      BldConvFil                                                 CMG008
      *                                                                                       CMG008
     C                   ENDIF                                                                CMG008
      *
      ** Key list to access Network Transaction Code description.
      *
     C     KNtCd         KLIST
     C                   KFLD                    KNwrk                          Network
     C                   KFLD                    KTrCd                          Network Trans. Code
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by : (**calling routines**)                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        PReturnOut = *BLANKS
     C                   EVAL      PReturnOut = 'PSSR_ERROR'
     C                   ENDIF
      *
     C                   DUMP
     C                   ROLBK
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
**CTDATA TransType
FP FX Foreign Exch. Purch.
FS FX Foreign Exch. Sold
CX FX Cross Deal
SW FX Swap Deal
OP FX Option
OT FX Option Takedown
PI FX Purch. Cover. Inter.
SI FX Sale Cover. Interest
RF IR Interest Rate Floors
RP IR Interest Rate Caps
RR IR Interest Rate Collar
RS IR Single curr.int.Swap
RX IR Single curr.int.Swap
FR FR Future Rate Agreement
IT MM Interbank taking
IP MM Interbank placing
TD MM Time deposit
TI MM Time loan
CI MM CD issued
CD MM Call/notice deposit
CL MM Call/notice deposit
DL MM Demand loan
C1 NP Primary CD
C2 NP Secondary CD
BP NP Bond
BD NP Bill
TB NP Treasury bill
DA NP Bank acceptance
TA NP Trade acceptance
CS NS Primary or secondary CD sold
BS NS Bond Sold
BR NS Bill Sold
TS NS Treasury bill Sold
RA NS Bank acceptance Sold
TR NS Trade acceptance Sold
FL DF Fixed term Placing (Bank side)
FT DF Fixed term Taking (Customer side)
DT DF Call Taking
LT DF Call Taking (Fiduciary Loan)
DP DF Call Placing
LP DF Call Placing (Fiduciary Loan)
