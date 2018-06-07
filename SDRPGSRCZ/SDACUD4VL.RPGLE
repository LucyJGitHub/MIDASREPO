     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Additional Customer Details 4 Validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACU4DVL - SD Additional Customer Details 4 Validation      *
      *                                                               *
      *  Function:  This module validates the Additional Customer     *
      *             Details screen input function                     *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 MD024991           Date 24Mar14               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field                             *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  MD024991 - Error appears upon deleting customer.             *
      *           - Do not perform defaulting if action code is 'D'.  *
      *           - Do not perform validation if action code is 'D'.  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFXCuVal - Validate FX Customer                             *
      *  SRSMbrVal - Validate Staff Member                            *
      *  SRSeCuVal - Validate Securities Customer                     *
      *  SRLangVal - Validate Language Id                             *
      *  SRCorTypVl - Validate Correspondent Type                     *
      *  SRZConfVal - Validate Zero Confirmation Flag                 *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line include the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Transaction Details in screen format
     D CustDet3      E DS                  EXTNAME(SDACU4DPD)
      *
      ** Valid Transaction Details layout
     D ValidDet      E DS                  EXTNAME(SDVACUDPD)
      *
      ** Transaction Details OK indicators
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DDCUST          S              6A
     D RespMode        S              1A
     D CER034          S              1A
     D CER038          S              1A
     D CER041          S              1A
     D DDACTN          S              1A                                                    MD024991
     D CER045          S              1A                                                      CER045
     D PYNFld          S              1A
     D PValYN          S              1A
     D PFldName        S             10A
     D OKYNFld         S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D WIdx            S              3P 0
     D WI              S              3P 0
     D Idx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
     C                   IF        CER034 = 'Y'
      *
      ** Validate FX Customer
      *
     C                   EXSR      SRFxVal
      *
      ** Validate Staff Member
      *
     C                   EXSR      SRSMVal
      *
      ** Validate Securities Customer
      *
     C                   EXSR      SRSeCuVal
      *
     C                   ENDIF
      *
      ** Validate Zero Confirmation Flag
      *
     C                   IF        CER041 = 'Y'
     C                   EXSR      SRZCFlgVal
     C                   ENDIF
      *
      ** Validate Language ID and Correspondent Type
      *
     C                   IF        CER038 = 'Y'
      *
     C                   EXSR      SRLangVal
     C                   EXSR      SRCorTypVl
      *
     C                   ENDIF
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
      *                                                                                       CER045
     C                   EXSR      SR_BEXTFld                                                 CER045
      *                                                                                       CER045
     C                   IF        OKBEXT = 'Y'                                               CER045
     C                   EXSR      SR_BSCCFld                                                 CER045
     C                   EXSR      SR_BISTFld                                                 CER045
     C                   EXSR      SR_ECACFld                                                 CER045
     C                   EXSR      SR_ABSKFld                                                 CER045
     C                   EXSR      SR_RIGRFld                                                 CER070
     C                   EXSR      SR_RECHFld                                                 CER071
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFxVal - Validate FX Customer                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRFxVal       BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVYN1'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Validate Y/N Field
      *
     C     ACFXCU        PARM                    DDFXCU
      *
      ** Field name to be Validated
      *
     C                   PARM      'DDFXCU'      PFldName
      *
      ** Outputs
      *
      ** Error Fields/Message IDs/Message data (arrays) from/to Caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** FX Customer - OK Flag
      *
     C                   PARM                    OKFXCU
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSMVal - Validate Staff Member                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRSMVal       BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVYN1'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Validate Y/N Field
      *
     C     ACSMBR        PARM                    DDSMBR
      *
      ** Field name to be Validated
      *
     C                   PARM      'DDSMBR'      PFldName
      *
      ** Outputs
      *
      ** Error Fields/Message IDs/Message data (arrays) from/to Caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Staff Member - OK Flag
      *
     C                   PARM                    OKSMBR
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZCFlgVal - Validate Zero Confirmation Flag                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRZCFlgVal    BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVYN1'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Validate Y/N Field
      *
     C     ACZCFG        PARM                    DDZCFG
      *
      ** Field name to be Validated
      *
     C                   PARM      'DDZCFG'      PFldName
      *
      ** Outputs
      *
      ** Error Fields/Message IDs/Message data (arrays) from/to Caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Staff Member - OK Flag
      *
     C                   PARM                    OKZCFG
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSeCuVal - Validate Securities Customer                     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRSeCuVal     BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVSECU'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Securities Customer
      *
     C     ACSECU        PARM                    DDSECU
      *
      ** Customer
      *
     C                   PARM                    DDCUST
      *
      ** Outputs
      *
      ** Error Fields/Message IDs/Message data (arrays) from/to Caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flag for Securities Customer
      *
     C                   PARM                    OKSECU
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLangVal - Validate Language Id                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRLangVal     BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVLANG'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Language Id
      *
     C     ACLNID        PARM                    DDLNID
      *
      ** Outputs
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Flag for Language Id
      *
     C                   PARM                    OKLNID
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCorTypVl - Validate Correspondent Type                     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRCorTypVl    BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVCOTP'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Correspondent Type
      *
     C     ACCTYP        PARM                    DDCTYP
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Correspondent Type
      *
     C                   PARM                    OKCTYP
      *
      ** Update error info with that returned from validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************                       CER045
      /EJECT                                                                                  CER045
      *****************************************************************                       CER045
      *                                                               *                       CER045
      *  SR_BEXTFld - Validate Customer Required for Bundesbank       *                       CER045
      *               Reporting                                       *                       CER045
      *                                                               *                       CER045
      *  Called by: MAIN Processing                                   *                       CER045
      *                                                               *                       CER045
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER045
      *                                                               *                       CER045
      *****************************************************************                       CER045
     C     SR_BEXTFld    BEGSR                                                                CER045
      *                                                                                       CER045
     C                   EXSR      RESETERRS                                                  CER045
      *                                                                                       CER045
     C                   CALLB     'SDVBEXT'                                                  CER045
      *                                                                                       CER045
      ** Inputs                                                                               CER045
      *                                                                                       CER045
      ** Return Code                                                                          CER045
      *                                                                                       CER045
     C                   PARM                    RetCodeIn                                    CER045
                                                                                            MD024991
      * Action Code                                                                         MD024991
     C                   PARM                    DDACTN                                     MD024991
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   PARM                    DDBEXT                                       CER045
      *                                                                                       CER045
      ** Outputs                                                                              CER045
      *                                                                                       CER045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER045
      *                                                                                       CER045
     C                   PARM      *ZEROS        Idx                                          CER045
     C                   PARM                    FldNamXAr                                    CER045
     C                   PARM                    MsgIdXAr                                     CER045
     C                   PARM                    MsgDtaXAr                                    CER045
      *                                                                                       CER045
      ** Ok Flag for Customer Required for Bundesbank Reporting                               CER045
      *                                                                                       CER045
     C                   PARM      *BLANK        OKBEXT                                       CER045
      *                                                                                       CER045
      ** Update error info with that returned from validation module                          CER045
      *                                                                                       CER045
     C                   EXSR      UPDATERRS                                                  CER045
      *                                                                                       CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /EJECT                                                                                  CER045
      *****************************************************************                       CER045
      *                                                               *                       CER045
      *  SR_BSCCFld - Validate Borrower Sector Classification Code    *                       CER045
      *                                                               *                       CER045
      *  Called by: MAIN Processing                                   *                       CER045
      *                                                               *                       CER045
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER045
      *                                                               *                       CER045
      *****************************************************************                       CER045
     C     SR_BSCCFld    BEGSR                                                                CER045
      *                                                                                       CER045
     C                   EXSR      RESETERRS                                                  CER045
      *                                                                                       CER045
     C                   CALLB     'SDVBSCC'                                                  CER045
      *                                                                                       CER045
      ** Inputs                                                                               CER045
      *                                                                                       CER045
      ** Return Code                                                                          CER045
      *                                                                                       CER045
     C                   PARM                    RetCodeIn                                    CER045
      *                                                                                       CER045
      ** Borrower Sector Classification Code                                                  CER045
      *                                                                                       CER045
     C                   PARM                    DDBSCC                                       CER045
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   PARM                    DDBEXT                                       CER045
      *                                                                                       CER045
      ** Outputs                                                                              CER045
      *                                                                                       CER045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER045
      *                                                                                       CER045
     C                   PARM      *ZEROS        Idx                                          CER045
     C                   PARM                    FldNamXAr                                    CER045
     C                   PARM                    MsgIdXAr                                     CER045
     C                   PARM                    MsgDtaXAr                                    CER045
      *                                                                                       CER045
      ** Ok Flag for Borrower Sector Classification Code                                      CER045
      *                                                                                       CER045
     C                   PARM      *BLANK        OKBSCC                                       CER045
      *                                                                                       CER045
      ** Update error info with that returned from validation module                          CER045
      *                                                                                       CER045
     C                   EXSR      UPDATERRS                                                  CER045
      *                                                                                       CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /EJECT                                                                                  CER045
      *****************************************************************                       CER045
      *                                                               *                       CER045
      *  SR_BISTFld - Validate Borrower Sector Classification/BISTA   *                       CER045
      *                                                               *                       CER045
      *  Called by: MAIN Processing                                   *                       CER045
      *                                                               *                       CER045
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER045
      *                                                               *                       CER045
      *****************************************************************                       CER045
     C     SR_BISTFld    BEGSR                                                                CER045
      *                                                                                       CER045
     C                   EXSR      RESETERRS                                                  CER045
      *                                                                                       CER045
     C                   CALLB     'SDVBIST'                                                  CER045
      *                                                                                       CER045
      ** Inputs                                                                               CER045
      *                                                                                       CER045
      ** Return Code                                                                          CER045
      *                                                                                       CER045
     C                   PARM                    RetCodeIn                                    CER045
      *                                                                                       CER045
      ** Borrower Sector Classification/BISTA                                                 CER045
      *                                                                                       CER045
     C                   PARM                    DDBIST                                       CER045
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   PARM                    DDBEXT                                       CER045
      *                                                                                       CER045
      ** Outputs                                                                              CER045
      *                                                                                       CER045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER045
      *                                                                                       CER045
     C                   PARM      *ZEROS        Idx                                          CER045
     C                   PARM                    FldNamXAr                                    CER045
     C                   PARM                    MsgIdXAr                                     CER045
     C                   PARM                    MsgDtaXAr                                    CER045
      *                                                                                       CER045
      ** Ok Flag for Borrower Sector Classification/BISTA                                     CER045
      *                                                                                       CER045
     C                   PARM      *BLANK        OKBIST                                       CER045
      *                                                                                       CER045
      ** Update error info with that returned from validation module                          CER045
      *                                                                                       CER045
     C                   EXSR      UPDATERRS                                                  CER045
      *                                                                                       CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /EJECT                                                                                  CER045
      *****************************************************************                       CER045
      *                                                               *                       CER045
      *  SR_ECACFld - Validate Economic Activity Code                 *                       CER045
      *                                                               *                       CER045
      *  Called by: MAIN Processing                                   *                       CER045
      *                                                               *                       CER045
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER045
      *                                                               *                       CER045
      *****************************************************************                       CER045
     C     SR_ECACFld    BEGSR                                                                CER045
      *                                                                                       CER045
     C                   EXSR      RESETERRS                                                  CER045
      *                                                                                       CER045
     C                   CALLB     'SDVECAC'                                                  CER045
      *                                                                                       CER045
      ** Inputs                                                                               CER045
      *                                                                                       CER045
      ** Return Code                                                                          CER045
      *                                                                                       CER045
     C                   PARM                    RetCodeIn                                    CER045
      *                                                                                       CER045
      ** Economic Activity Code                                                               CER045
      *                                                                                       CER045
     C                   PARM                    DDECAC                                       CER045
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   PARM                    DDBEXT                                       CER045
      *                                                                                       CER045
      ** Outputs                                                                              CER045
      *                                                                                       CER045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER045
      *                                                                                       CER045
     C                   PARM      *ZEROS        Idx                                          CER045
     C                   PARM                    FldNamXAr                                    CER045
     C                   PARM                    MsgIdXAr                                     CER045
     C                   PARM                    MsgDtaXAr                                    CER045
      *                                                                                       CER045
      ** Ok Flag for Economic Activity Code                                                   CER045
      *                                                                                       CER045
     C                   PARM      *BLANK        OKECAC                                       CER045
      *                                                                                       CER045
      ** Update error info with that returned from validation module                          CER045
      *                                                                                       CER045
     C                   EXSR      UPDATERRS                                                  CER045
      *                                                                                       CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /EJECT                                                                                  CER045
      *****************************************************************                       CER045
      *                                                               *                       CER045
      *  SR_ABSKFld - Validate Additional Borrower Sector Key         *                       CER045
      *                                                               *                       CER045
      *  Called by: MAIN Processing                                   *                       CER045
      *                                                               *                       CER045
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER045
      *                                                               *                       CER045
      *****************************************************************                       CER045
     C     SR_ABSKFld    BEGSR                                                                CER045
      *                                                                                       CER045
     C                   EXSR      RESETERRS                                                  CER045
      *                                                                                       CER045
     C                   CALLB     'SDVABSK'                                                  CER045
      *                                                                                       CER045
      ** Inputs                                                                               CER045
      *                                                                                       CER045
      ** Return Code                                                                          CER045
      *                                                                                       CER045
     C                   PARM                    RetCodeIn                                    CER045
      *                                                                                       CER045
      ** Additional Borrower Sector Key                                                       CER045
      *                                                                                       CER045
     C                   PARM                    DDABSK                                       CER045
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   PARM                    DDBEXT                                       CER045
      *                                                                                       CER045
      ** Outputs                                                                              CER045
      *                                                                                       CER045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER045
      *                                                                                       CER045
     C                   PARM      *ZEROS        Idx                                          CER045
     C                   PARM                    FldNamXAr                                    CER045
     C                   PARM                    MsgIdXAr                                     CER045
     C                   PARM                    MsgDtaXAr                                    CER045
      *                                                                                       CER045
      ** Ok Flag for Additional Borrower Sector Key                                           CER045
      *                                                                                       CER045
     C                   PARM      *BLANK        OKABSK                                       CER045
      *                                                                                       CER045
      ** Update error info with that returned from validation module                          CER045
      *                                                                                       CER045
     C                   EXSR      UPDATERRS                                                  CER045
      *                                                                                       CER045
     C                   ENDSR                                                                CER045
      /EJECT                                                                                  CER070
      *****************************************************************                       CER070
      *                                                               *                       CER070
      *  SR_RIGRFld - Validate Risk Classification Code               *                       CER070
      *                                                               *                       CER070
      *  Called by: MAIN Processing                                   *                       CER070
      *                                                               *                       CER070
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER070
      *                                                               *                       CER070
      *****************************************************************                       CER070
     C     SR_RIGRFld    BEGSR                                                                CER070
      *                                                                                       CER070
     C                   EXSR      RESETERRS                                                  CER070
      *                                                                                       CER070
     C                   CALLB     'SDVRIGR'                                                  CER070
      *                                                                                       CER070
      ** Inputs                                                                               CER070
      *                                                                                       CER070
      ** Return Code                                                                          CER070
      *                                                                                       CER070
     C                   PARM                    RetCodeIn                                    CER070
      *                                                                                       CER070
      ** Risk Classification Code                                                             CER070
      *                                                                                       CER070
     C                   PARM                    DDRIGR                                       CER070
      *                                                                                       CER070
      ** Customer Required for Bundesbank Reporting                                           CER070
      *                                                                                       CER070
     C                   PARM                    DDBEXT                                       CER070
      *                                                                                       CER070
      ** Outputs                                                                              CER070
      *                                                                                       CER070
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER070
      *                                                                                       CER070
     C                   PARM      *ZEROS        Idx                                          CER070
     C                   PARM                    FldNamXAr                                    CER070
     C                   PARM                    MsgIdXAr                                     CER070
     C                   PARM                    MsgDtaXAr                                    CER070
      *                                                                                       CER070
      ** Ok Flag for Borrower Sector Classification Code                                      CER070
      *                                                                                       CER070
     C                   PARM      *BLANK        OKRIGR                                       CER070
      *                                                                                       CER070
      ** Update error info with that returned from validation module                          CER070
      *                                                                                       CER070
     C                   EXSR      UPDATERRS                                                  CER070
      *                                                                                       CER070
     C                   ENDSR                                                                CER070
      /EJECT                                                                                  CER071
      *****************************************************************                       CER071
      *                                                               *                       CER071
      *  SR_RECHFld - Validate Legal Form Code                        *                       CER071
      *                                                               *                       CER071
      *  Called by: MAIN Processing                                   *                       CER071
      *                                                               *                       CER071
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER071
      *                                                               *                       CER071
      *****************************************************************                       CER071
     C     SR_RECHFld    BEGSR                                                                CER071
      *                                                                                       CER071
     C                   EXSR      RESETERRS                                                  CER071
      *                                                                                       CER071
     C                   CALLB     'SDVRECH'                                                  CER071
      *                                                                                       CER071
      ** Inputs                                                                               CER071
      *                                                                                       CER071
      ** Return Code                                                                          CER071
      *                                                                                       CER071
     C                   PARM                    RetCodeIn                                    CER071
      *                                                                                       CER071
      ** Legal Form                                                                           CER071
      *                                                                                       CER071
     C                   PARM                    DDRECH                                       CER071
      *                                                                                       CER071
      ** Customer Required for Bundesbank Reporting                                           CER071
      *                                                                                       CER071
     C                   PARM                    DDBEXT                                       CER071
      *                                                                                       CER071
      ** Outputs                                                                              CER071
      *                                                                                       CER071
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER071
      *                                                                                       CER071
     C                   PARM      *ZEROS        Idx                                          CER071
     C                   PARM                    FldNamXAr                                    CER071
     C                   PARM                    MsgIdXAr                                     CER071
     C                   PARM                    MsgDtaXAr                                    CER071
      *                                                                                       CER071
      ** Ok Flag for Legal Form Code                                                          CER071
      *                                                                                       CER071
     C                   PARM      *BLANK        OKRECH                                       CER071
      *                                                                                       CER071
      ** Update error info with that returned from validation module                          CER071
      *                                                                                       CER071
     C                   EXSR      UPDATERRS                                                  CER071
      *                                                                                       CER071
     C                   ENDSR                                                                CER071
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *                                                               *
      *  Called by: SRValYN,SRSeCuVal,SRLangVal,SRCorTypVl            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *                                                               *
      *  Called by: SRValYN,SRSeCuVal,SRLangVal,SRCorTypVl            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ** Update error Fields/Message IDs/Message data (arrays)
      *
     C                   EVAL      WI = 1
     C                   EVAL      WI = %LOOKUP(' ':FldNameArr)
      *
     C                   IF        WI <> *ZEROS
     C                   MOVEA     FldNamXAr     FlDNameArr(WI)
     C                   MOVEA     MsgIDXAr      MsgIdArr(WI)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(WI)
     C                   ENDIF
      *
      ** Set error index
      *
     C                   EVAL      WI = 1
     C                   EVAL      WI = %LOOKUP(' ':FldNameArr)
     C                   EVAL      Idx = WI - 1
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      WI = 1
     C                   EVAL      WI = %LOOKUP(' ':WFldNamArr)
      *
     C                   IF        WI <> *ZEROS
     C                   MOVEA     WFldNmXAr     WFldNamArr(WI)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(WI)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(WI)
     C                   ENDIF
      *
      ** Set warning index
      *
     C                   EVAL      WI = 1
     C                   EVAL      WI = %LOOKUP(' ':WFldNamArr)
     C                   EVAL      WIdx = WI - 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Response mode
      *
     C                   PARM      *BLANKS       RespMode
                                                                                            MD024991
      * Action Code                                                                         MD024991
     C                   PARM                    DDACTN                                     MD024991
      *
      ** Current Transaction Screen 2 Details
      *
     C                   PARM                    CustDet3
      *
      ** Customer
      *
     C                   PARM                    DDCUST
      *
      ** Switchable Features
      *
     C                   PARM                    CER034
     C                   PARM                    CER038
     C                   PARM                    CER041
      *
      ** Outputs
      *
      ** Transaction Details OK inds
      *
     C                   PARM                    OKCustDet3
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (array) from/to caller
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    WIdx
      *
      ** Valid Transaction details layout (DS) from/to caller
      *
     C                   PARM                    ValidDet
      *                                                                                       CER045
      * Pass the value of CER045                                                              CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Finastra International Limited 2008
