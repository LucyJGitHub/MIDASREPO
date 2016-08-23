     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Additional Customer Details 3 Validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD3VL - SD Additional Customer Details 3 Validation      *
      *                                                               *
      *  Function:  This module validates the Additional Customer     *
      *             Details screen input function                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR855391           Date 27Oct11               *
      *  Prev Amend No. CSD091             Date 04Jul11               *
      *                 AR740758           Date 04Apr11               *
      *                 AR739532           Date 30Mar11               *
      *                 CER059             Date 19Jul10               *
      *                 263252             Date 06Jan10               *
      *                 BUG26306           Date 06Oct09               *
      *                 BUG25854           Date 08Sep09               *
      *                 BUG25533           Date 19Aug09               *
      *                 BUG25876           Date 02Sep09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24346           Date 16Jun09               *
      *                 BUG22697           Date 25May09               *
      *                 BUG23883           Date 04May09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23657           Date 13Apr09               *
      *                 BUG22535           Date 23Feb09               *
      *                 BUG22533           Date 29Jan09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
      *  AR740758 - System does not validate customer's individual    *
      *             threshold in CUSD against Country of Tax Code     *
      *             definition (Child: AR740759)                      *
      *  AR739532 - CUSD Error issued if State code has value         *
      *             (Child : AR739533)                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  263252 - Document Expiry Date is not updated.                *
      *  BUG26306 - Field Title is unexpected mandatory for all types *
      *             of customers                                      *
      *  BUG25854 - ACUD difficulties with State Code and Religion    *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  BUG25876 - Database error when CER054 is off                 *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24346 - Change validation from tax ID to Identification   *
      *             type                                              *
      *  BUG22697 - "Title" field should not be mandatory for         *
      *             Corporate account                                 *
      *  BUG23883 - Certificate dates do not default until validation *
      *             on last screen                                    *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG22535 - Additional Cusd Problem with Date fields          *
      *  BUG22533 - 'Title' to be Mandatory for German Taxes          *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRExpDat - Validate Expiry Date
      *  SRTitleVal - Validate Title                                  *
      *  SRMNameVal - Validate Maiden Name                            *
      *  SRSHRefVal - Validate Spouse/Husband Reference               *
      *  SRValPAInd - Validate Partner/Associate Indicator Flag       *
      *  SRSub24Val - Validate Subject to 24C Flag                    *
      *  SRValDat47 - Validate Expiry Date and Authorised Until Date  *
      *  SRValDate - Validate Exemption Approval Date,                *
      *              Exemption Value and Expiry Date                  *
      *  SRExmpThVl - Validate Exemption Threshold                    *
      *  SRChDCVal - Validate Characteristic of Demand/Claim          *
      *  SRAuLnVal - Validate Authority Type and Link Type            *
      *  SRPrCVal - Validate Product CoverageType                     *
      *  SRRemkVal - Validate Remarks                                 *
      *  SRDIDPlcVl - Validate Document/Id No and Issuing Place       *
      *  SRAuHVal - Validate Authority Holder                         *
      *  SRIsDtVal - Validate Issuing Date                            *
      *  SRValStaCod - Validate State Code                            *                       CER054
      *  SRValRelAff - Validate Religious Affiliation Code            *                       CER054
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
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
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
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
      ** Customer Details in screen format
     D CustDet2      E DS                  EXTNAME(SDACU3DPD)
      *
      ** Customer Details OK indicators
     D OKCustDet2    E DS                  EXTNAME(SDEACU3PD)
      *
      ** Valid Customer Details layout
     D ValidDet      E DS                  EXTNAME(SDVACUDPD)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                     BUG22697
      ** External DS for Customer Details                                                   BUG22697
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG22697
                                                                                              CER054
      ** Data Structure for SAR Details                                                       CER054
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER054
      ** Current Customer details by Country of tax File Format                             AR740758
     D ValidCCTX     E DS                  EXTNAME(SDVCCTXPD)                               AR740758
     D                                     PREFIX(V_)                                       AR740758
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
      *
      ** Index for arrays of of warning message ids etc
      *
     D WIdx            S              3P 0
      *
      ** Switchable Features
      *
     D CER047          S              1A
     D CER048          S              1A
     D CER054          S              1A                                                      CER054
      *
     D RespMode        S              1A
     D PRtcd           S              7A
     D POptn           S              7A
      *
     D DDCUST          S              6A
     D DDCOLC          S              2A                                                    AR739532
     D DDBRCD          S              3A                                                    AR740758
     D V_CCTXArr       S                   DIM(50) LIKE(ValidCCTX)                          AR740758
     D DDJATP          S              1A
     D*DDTINO***       S             25A                                                    BUG24346
     D DDIDTP          S              2A                                                    BUG24346
     D PFldName        S             10A
     D PSard           S              6A                                                      CER054
      *
      ** Variable used to update errors in UPDATERRS routine
     D WI              S              3P 0
      *
     D DateIn          S              6A                                                    BUG22535
     D DaynoOut        S              5P 0                                                  BUG22535
     D WDaynoOut       S              5P 0                                                  BUG22535
     D ErrorFlag       S              1A                                                    BUG22535
      *                                                                                     BUG22535
     D WDate2          S              6A                                                    BUG22535
      ** Expiry Date - 8 Char Format                                                        BUG22535
     D ExpDte1         DS             8                                                     BUG22535
     D  ExpDM1                 1      4                                                     BUG22535
     D  ExpCC1                 5      6                                                     BUG22535
     D  ExpYY1                 7      8                                                     BUG22535
      ** Expiry Date - 6 Char Format                                                        BUG22535
     D ExpDte2         DS             6                                                     BUG22535
     D  ExpDM2                 1      4                                                     BUG22535
     D  ExpYY2                 5      6                                                     BUG22535
      *                                                                                     BUG23883
     D DfltFlag        S              1A                                                    BUG23883
      *                                                                                     BUG22697
      ** Parameter for Access Objects                                                       BUG22697
     D PKey1           S             10A                                                    BUG22697
     D PKySt           S              7A                                                    BUG22697
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
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Check if CER047 or CER048 is enabled
      *
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'
      *
      ** Validate Title
      *
     C                   EXSR      SRTitleVal
      *
      ** Validate Maiden Name
      *
     C                   EXSR      SRMNameVal
      *
      ** Validate Document Number/Id and Issuing Place
      *
     C                   EXSR      SRDIDPlcVl
      *
      ** Validate Remarks
      *
     C                   EXSR      SRRemkVal
      *
     C                   ENDIF
      *
      ** Check if CER048 is enabled
      *
     C                   IF        CER048 = 'Y'
      *
      ** Validate Spouse Reference
      *
     C                   EXSR      SRSHRefVal
      *
      ** Validate Exemption Threshold
      *
     C                   EXSR      SRExmpThVl
      *
      ** Validate Exemption Approval Date
      *
     C                   EXSR      SRValAppDt
      *
      ** Validate Exemption Threshold Value Date
      *
     C                   EXSR      SRValVlDat
      *
      ** Exemption Threshold Expiry Date
      *
     C                   EXSR      SRValExpDt
      *
      ** Validate Characteristic of Demand/Claim
      *
     C                   EXSR      SRChDCVal
      *
      ** Validate Partner/Associate Indicator
      *
     C                   EXSR      SRValPAInd
      *
     C                   ENDIF
      *
      ** Check if CER047 is enabled
      *
     C                   IF        CER047 = 'Y'
      *
      ** Validate Expiry Date
      *
     C                   EXSR      SRValDat47
      *
      ** Validate Subject to 24c Flag
      *
     C                   EXSR      SRValS24Flg
      *
     C                   ENDIF
      *                                                                                       CER054
      ** Check if CER054 is enabled                                                           CER054
      *                                                                                       CER054
     C**********         IF        CER054 = 'Y'                                      CER054 BUG24714
     C                   IF        CER048 = 'Y'                                             BUG24714
      *                                                                                       CER054
      ** Validate State Codes                                                                 CER054
      *                                                                                       CER054
     C                   EXSR      SRValStaCod                                                CER054
      *                                                                                       CER054
      ** Validate Religious Affiliation                                                       CER054
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                             BUG24714
     C                   EXSR      SRValRelAff                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                              BUG24714
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTitleVal - Validate Title                                  *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRTitleVal    BEGSR
      *                                                                                     BUG26306
      ** No validation needed as the field is free format                                   BUG26306
      *                                                                                     BUG26306
     C                   EVAL      ACTITL = DDTITL                                          BUG26306
      *                                                                                     BUG26306
      ** OK Flag for Title                                                                  BUG26306
      *                                                                                     BUG26306
     C                   EVAL      OKTITL = 'Y'                                             BUG26306
      *                                                                                     BUG26306
      **********                                                                   BUG22533 BUG26306
      ***Reset*variables updated by validation                                     BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
     C**********         EXSR      RESETERRS                                       BUG22533 BUG26306
      *
      ***Access*Customer Details for Corporate customer                            BUG22697 BUG26306
      **********                                                                   BUG22697 BUG26306
     C**********         CALL      'AOCUSTR0'                                      BUG22697 BUG26306
     C**********         PARM      *Blanks       PRtcd                             BUG22697 BUG26306
     C**********         PARM      '*KEY   '     POptn                             BUG22697 BUG26306
     C**********         PARM      DDCUST        PKey1                             BUG22697 BUG26306
     C**********         PARM                    PKySt                             BUG22697 BUG26306
     C*****SDCUST        PARM      SDCUST        DSSDY                             BUG22697 BUG26306
      **********                                                                   BUG22697 BUG26306
      ***No*validation needed as the field is free format                                   BUG26306
      ***when*LF047 is OFF                                                         BUG22533 BUG26306
      *
     C**********         IF        CER048 <> 'Y'                                   BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
     C**********         EVAL      ACTITL = DDTITL                                          BUG26306
     C**********         EVAL      OKTITL = 'Y'                                    BUG22533 BUG26306
     C**********         ELSE                                                      BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
     C**********         IF        DDTITL = *BLANKS                                BUG22533 BUG22697
     C**********         IF        DDTITL = *BLANKS  AND                           BUG22697 BUG26306
     C**********                   BBCRPC <> 'Y'                                   BUG22697 BUG26306
     C**********         EVAL      OKTITL = 'N'                                    BUG22533 BUG26306
     C**********         EVAL      Idx = Idx + 1                                   BUG22533 BUG26306
     C**********         EVAL      FldNamXAr(Idx) = 'DDTITL'                       BUG22533 BUG26306
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8266'                       BUG22533 BUG26306
     C**********         ELSE                                                      BUG22533 BUG26306
      **********                                                                   BUG22697 BUG26306
     C**********         IF        DDTITL <> *BLANKS AND                           BUG22697 BUG26306
     C**********                   BBCRPC = 'Y'                                    BUG22697 BUG26306
     C**********         EVAL      OKTITL = 'N'                                    BUG22697 BUG26306
     C**********         EVAL      Idx = Idx + 1                                   BUG22697 BUG26306
     C**********         EVAL      FldNamXAr(Idx) = 'DDTITL'                       BUG22697 BUG26306
     C**********         EVAL      MsgIdXAr(Idx) = 'USR9940'                       BUG22697 BUG26306
     C**********         ELSE                                                      BUG22697 BUG26306
      **********                                                                   BUG22697 BUG26306
     C**********         EVAL      ACTITL = DDTITL                                 BUG22533 BUG26306
     C**********         ENDIF                                                     BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
     C**********         ENDIF                                                     BUG22533 BUG26306
      **********                                                                   BUG22697 BUG26306
     C**********         ENDIF                                                     BUG22697 BUG26306
      *
      ***OK*Flag*for*Title                                                                  BUG22533
      *
     C**********         EVAL      OKTITL = 'Y'                                    BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
      ***Update*error info with that returned from the                             BUG22533 BUG26306
      ***validation module                                                         BUG22533 BUG26306
      **********                                                                   BUG22533 BUG26306
     C**********         EXSR      UPDATERRS                                       BUG22533 BUG26306
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMNameVal - Validate Maiden Name                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRMNameVal    BEGSR
      *
      ** No validation needed as the field is free format
      *
     C                   EVAL      ACMDNM = DDMDNM
      *
      ** OK Flag for Maiden Name
      *
     C                   EVAL      OKMDNM = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSHRefVal - Validate Spouse/Husband Reference               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRSHRefVal    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVSHREF'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Spouse Reference
      *
     C     ACSHRF        PARM                    DDSHRF
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Customer
      *
     C                   PARM                    DDCUST
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Spouse/Husband Reference
      *
     C                   PARM                    OKSHRF
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValPAInd - Validate Partner/Associate Indicator            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValPAInd    BEGSR
      *
      ** Reset variables updated by validation
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
      ** Partner/Associate Indicator
      *
     C     ACPIND        PARM                    DDPIND
      *
      ** Field name to be Validated
      *
     C                   PARM      'DDPIND'      PFldName
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Partner/Associate Indicator
      *
     C                   PARM                    OKPIND
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValS24Flg - Validate Partner/Associate Indicator           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValS24Flg   BEGSR
      *
      ** Reset variables updated by validation
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
      ** Partner/Associate Indicator
      *
     C     ACS24C        PARM                    DDS24C
      *
      ** Field name to be Validated
      *
     C                   PARM      'DDS24C'      PFldName
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Partner/Associate Indicator
      *
     C                   PARM                    OKS24C
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDat47 - Validate Expiry Date                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValDat47    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C**********         CALLB     'SDVEXDT'                                                BUG22535
      *
      ** Inputs
      *
      ** Return Code
      *
     C**********         PARM                    RetCodeIn                                  BUG22535
      *
      ** Expiry Date
      *
     C**********         PARM                    DDEXDT                                     BUG22535
      *
      ** Outputs
      *
      ** Expiry Date
      *
     C**********         PARM                    ACEXDT                                     BUG22535
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C**********         PARM                    FldNamXAr                                  BUG22535
     C**********         PARM                    MsgIdXAr                                   BUG22535
     C**********         PARM                    MsgDtaXAr                                  BUG22535
      *
      ** Ok Flag for Expiry Date
      *
     C**********         PARM                    OKEXDT                                     BUG22535
      *
     C                   EXSR      SRExpDat                                                 BUG22535
      *                                                                                     BUG22535
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAppDt - Validate Exemption Approval Date                *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValAppDt    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVALDAT2'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Exemption Threshold Approval Date
      *
     C                   PARM                    DDEADT
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Field Name to be Validated
      *
     C                   PARM      'DDEADT'      PFldName
      *                                                                                     BUG23657
      ** Customer Number to get Certificate dates                                           BUG23657
      *                                                                                     BUG23657
     C                   PARM                    DDCUST                                     BUG23657
      *
      ** Outputs
      *
      ** Exemption Threshold Approval Date
      *
     C                   PARM                    ACEADT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Exemption Threshold Approval Date
      *
     C                   PARM                    OKEADT
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM                    DfltFlag                                   BUG23883
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValVlDat - Validate Exemption Value Date                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValVlDat    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVALDAT2'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Exemption Threshold Approval Date
      *
     C                   PARM                    DDEVDT
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Field Name to be Validated
      *
     C                   PARM      'DDEVDT'      PFldName
      *                                                                                     BUG23657
      ** Customer Number to get Certificate dates                                           BUG23657
      *                                                                                     BUG23657
     C                   PARM                    DDCUST                                     BUG23657
      *
      ** Outputs
      *
      ** Exemption Threshold Value Date
      *
     C                   PARM                    ACEVDT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Exemption Threshold Approval Date
      *
     C                   PARM                    OKEVDT
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM                    DfltFlag                                   BUG23883
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValExpDt - Validate Exemption Expiry Date                  *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRValExpDt    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVALDAT2'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Exemption Threshold Approval Date
      *
     C                   PARM                    DDETXT
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Field Name to be Validated
      *
     C                   PARM      'DDETXT'      PFldName
      *                                                                                     BUG23657
      ** Customer Number to get Certificate dates                                           BUG23657
      *                                                                                     BUG23657
     C                   PARM                    DDCUST                                     BUG23657
      *
      ** Outputs
      *
      ** Exemption Threshold Value Date
      *
     C                   PARM                    ACETXT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Exemption Threshold Approval Date
      *
     C                   PARM                    OKETXT
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM                    DfltFlag                                   BUG23883
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG22535
      *                                                               *                     BUG22535
      *  SRExpDat - Validate Expiry Date                              *                     BUG22535
      *                                                               *                     BUG22535
      *  Called by: MAIN Processing                                   *                     BUG22535
      *                                                               *                     BUG22535
      *  Calls: None                                                  *                     BUG22535
      *                                                               *                     BUG22535
      *****************************************************************                     BUG22535
     C     SRExpDat      BEGSR                                                              BUG22535
      *                                                                                     BUG22535
      ** Expiry Date should be numeric                                                      BUG22535
      *                                                                                     BUG22535
     C                   IF        DDEXDT <> *BLANKS                                        BUG22535
     C                   EVAL      WIdx = %Check('0123456789':DDEXDT)                       BUG22535
      *                                                                                     BUG22535
     C                   IF        WIdx <> 0                                                BUG22535
     C                             AND WIdx <> 7                                              CER059
      ** Date is entered in 6char length                                                      CER059
      *                                                                                     BUG22535
     C                   EVAL      OKEXDT = 'N'                                             BUG22535
     C                   EVAL      Idx = Idx + 1                                            BUG22535
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22535
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22535
     C                   LEAVESR                                                            BUG22535
      *                                                                                     BUG22535
     C                   ELSE                                                               BUG22535
      *                                                                                     BUG22535
     C                   MOVE      DDEXDT        ExpDte1                                    BUG22535
     C                   MOVE      ExpDM1        ExpDM2                                     BUG22535
     C                   MOVE      ExpYY1        ExpYY2                                     BUG22535
     C                   IF        WIdx = 7                                                   CER059
     C                   MOVE      ExpCC1        ExpYY2                                       CER059
     C                   ENDIF                                                                CER059
      *                                                                                     BUG22535
     C                   MOVE      ExpDte2       WDate2                                     BUG22535
      *                                                                                     BUG22535
     C                   CALLB     'ZDATE1'                                                 BUG22535
      *                                                                                     BUG22535
     C                   PARM      WDate2        DateIn                                     BUG22535
     C                   PARM                    DaynoOut                                   BUG22535
     C                   PARM                    BJDFIN                                     BUG22535
     C                   PARM                    ErrorFlag                                  BUG22535
      *                                                                                     BUG22535
     C                   IF        ErrorFlag = 'Y'                                          BUG22535
      *                                                                                     BUG22535
     C                   EVAL      OKEXDT = 'N'                                             BUG22535
     C                   EVAL      Idx = Idx + 1                                            BUG22535
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22535
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22535
     C                   LEAVESR                                                            BUG22535
      *                                                                                     BUG22535
     C                   ENDIF                                                              BUG22535
      *                                                                                     BUG22535
     C                   ENDIF                                                              BUG22535
      *                                                                                     BUG22535
     C                   ENDIF                                                              BUG22535
      *                                                                                     BUG22535
      ** Expiry Date must be after the Rundate                                              BUG22535
      *                                                                                     BUG22535
     C                   IF        DDEXDT <> *Blanks  AND                                   BUG22535
     C                             DaynoOut < BJRDNB                                        BUG22535
      *                                                                                     BUG22535
     C**********         EVAL      OKEXDT = 'N'                                      BUG22535 CSD091
     C**********         EVAL      Idx = Idx + 1                                     BUG22535 CSD091
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXDT'                         BUG22535 CSD091
     C**********         EVAL      MsgIDXAr(Idx) = 'USR5919'                         BUG22535 CSD091
                                                                                              CSD091
     C**********         EVAL      OKEXDT = 'W'                                      CSD091 AR855391
     C**********         EVAL      WIdx = WIdx + 1                                   CSD091 AR855391
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDEXDT'                        CSD091 AR855391
     C**********         EVAL      WMsgIDXAr(WIdx) = 'USR5919'                       CSD091 AR855391
                                                                                            AR855391
     C                   EVAL      OKEXDT = 'N'                                             AR855391
     C                   EVAL      Idx = Idx + 1                                            AR855391
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                AR855391
     C                   EVAL      MsgIDXAr(Idx) = 'USR5919'                                AR855391
     C                   LEAVESR                                                            BUG22535
      *                                                                                     BUG22535
     C                   ENDIF                                                              BUG22535
      *                                                                                       263252
     C                   IF        DDEXDT <> *Blanks                                          263252
     C                   EVAL      ACEXDT = DaynoOut                                          263252
     C                   ELSE                                                                 263252
     C                   EVAL      ACEXDT = 0                                                 263252
     C                   ENDIF                                                                263252
      *                                                                                     BUG22535
     C                   ENDSR                                                              BUG22535
      *****************************************************************                     BUG22535
      /EJECT                                                                                BUG22535
      *****************************************************************
      *                                                               *
      *  SRExmpThVl - Validate Exemption Threshold                    *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRExmpThVl    BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVEMPTRH'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Customer Number
      *
     C                   PARM                    DDCUST
      *                                                                                     AR740758
     C                   PARM                    DDCOLC                                     AR740758
     C                   PARM                    DDBRCD                                     AR740758
     C                   PARM                    V_CCTXArr                                  AR740758
      *
      ** Outputs
      *
      ** Exemption Threshold
      *
     C                   PARM                    ACEXTH
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Exemption Threshold
      *
     C                   PARM                    OKEXTH
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChDCVal - Validate Characteristic of Demand/Claim          *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChDCVal     BEGSR
      *
      ** No validation needed as the field is free format
      *
     C                   EVAL      ACCDCL = DDCDCL
      *
      ** Ok Flag for Characteristic of Demand/Claim
      *
     C                   EVAL      OKCDCL = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRemkVal - Validate Remarks                                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRemkVal     BEGSR
      *
      ** No validation needed as the field is free format
      *
     C                   EVAL      ACREM1 = DDREM1
     C                   EVAL      ACREM2 = DDREM2
     C                   EVAL      ACREM3 = DDREM3
      *
      ** Ok Flag for Remarks
      *
     C                   EVAL      OKREM1 = 'Y'
     C                   EVAL      OKREM2 = 'Y'
     C                   EVAL      OKREM3 = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDIDPlcVl - Validate Document/Id No and Issuing Place       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
     C     SRDIDPlcVl    BEGSR
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVDIDIPL'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Identification Document No/Id
      *
     C     ACDCID        PARM                    DDDCNM
      *
      ** Identification Document Issued Place
      *
     C     ACDIPL        PARM                    DDISPL
      *
      ***Tax*Identifier************************************************                     BUG24346
      ** Identification Type                                                                BUG24346
      *
     C**********         PARM                    DDTINO                                     BUG24346
     C                   PARM                    DDIDTP                                     BUG24346
      *
      ** Switchable Feature
      *
     C                   PARM                    CER048
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Validate Document/Id No
      *
     C                   PARM                    OKDCNM
      *
      ** Ok Flag for Issuing Place
      *
     C                   PARM                    OKISPL
      *
      ** Update error info with that returned from the
      ** validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      *                                                               *                       CER054
      *  SRValStaCod - Validate State Code                            *                       CER054
      *                                                               *                       CER054
      *  Called by: MAIN Processing                                   *                       CER054
      *                                                               *                       CER054
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER054
      *                                                               *                       CER054
      *****************************************************************                       CER054
     C     SRValStaCod   BEGSR                                                                CER054
      *                                                                                       CER054
      ** Reset variables updated by validation                                                CER054
      *                                                                                       CER054
     C                   EXSR      RESETERRS                                                  CER054
      *                                                                                       CER054
     C                   CALLB     'SDVGERCOD'                                                CER054
      *                                                                                       CER054
      ** Inputs                                                                               CER054
      *                                                                                       CER054
      ** Return Code                                                                          CER054
      *                                                                                       CER054
     C                   PARM                    RetCodeIn                                    CER054
      *                                                                                       CER054
      ***Customer*Number**********************************************               CER054 AR739532
      *                                                                                       CER054
     C**********         PARM                    DDCUST                              CER054 AR739532
      *                                                                                     AR739532
      ** Country of Domicile                                                                AR739532
      *                                                                                     AR739532
     C                   PARM                    DDCOLC                                     AR739532
      *                                                                                       CER054
      ** State Code                                                                           CER054
      *                                                                                       CER054
     C                   PARM                    DDSTCD                                       CER054
      *                                                                                       CER054
      ** Religious Affiliation Cdode                                                          CER054
      *                                                                                       CER054
     C                   PARM                    DDRLAF                                       CER054
     C                   PARM                    CER048                                     BUG25854
     C                   PARM                    CER054                                     BUG25854
      *                                                                                       CER054
      ** Outputs                                                                              CER054
      *                                                                                       CER054
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER054
      *                                                                                       CER054
     C                   PARM                    FldNamXAr                                    CER054
     C                   PARM                    MsgIdXAr                                     CER054
     C                   PARM                    MsgDtaXAr                                    CER054
      *                                                                                       CER054
      ** Ok Flag for State Code                                                               CER054
      *                                                                                       CER054
     C                   PARM                    OKSTCD                                       CER054
      *                                                                                       CER054
     C                   IF        OKSTCD = 'Y'                                               CER054
     C                   EVAL      ACSTCD = DDSTCD                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Update error info with that returned from the                                        CER054
      ** validation module                                                                    CER054
      *                                                                                       CER054
     C                   EXSR      UPDATERRS                                                  CER054
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      *                                                               *                       CER054
      *  SRValRelAff - Validate Religious Affiliation Code            *                       CER054
      *                                                               *                       CER054
      *  Called by: MAIN Processing                                   *                       CER054
      *                                                               *                       CER054
      *  Calls: SDVRELAFF                                             *                       CER054
      *                                                               *                       CER054
      *****************************************************************                       CER054
     C     SRValRelAff   BEGSR                                                                CER054
      *                                                                                       CER054
      ** Reset variables updated by validation                                                CER054
      *                                                                                       CER054
     C                   EXSR      RESETERRS                                                  CER054
      *                                                                                       CER054
     C                   CALLB     'SDVRELAFF'                                                CER054
      *                                                                                       CER054
      ** Inputs                                                                               CER054
      *                                                                                       CER054
      ** Return Code                                                                          CER054
      *                                                                                       CER054
     C                   PARM                    RetCodeIn                                    CER054
      *                                                                                       CER054
      ** Religious Affiliation Code                                                           CER054
      *                                                                                       CER054
     C                   PARM                    DDRLAF                                       CER054
     C                   PARM                    DDSTCD                                     BUG25854
      *                                                                                       CER054
      ** Outputs                                                                              CER054
      *                                                                                       CER054
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER054
      *                                                                                       CER054
     C                   PARM                    FldNamXAr                                    CER054
     C                   PARM                    MsgIdXAr                                     CER054
     C                   PARM                    MsgDtaXAr                                    CER054
      *                                                                                       CER054
      ** Ok Flag for Religious Affiliation Code                                               CER054
      *                                                                                       CER054
     C                   PARM                    OKRLAF                                       CER054
      *                                                                                       CER054
     C                   IF        OKRLAF = 'Y'                                               CER054
     C                   EVAL      ACRLAF = DDRLAF                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Update error info with that returned from the                                        CER054
      ** validation module                                                                    CER054
      *                                                                                       CER054
     C                   EXSR      UPDATERRS                                                  CER054
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *                                                               *
      *  Called by: SRSHRefVal, SRValPAInd, SRSub24Val, SRValDat47,   *
      *             SRValDate, SRExmpThVl, SRAuLnVal, SRPrCVal,       *
      *             SRDIDPlcVl, SRAuHVal, SRIsDtVal                   *
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
     C                   EVAL      MsgIDXAr = *BLANKS
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
      *  Called by: SRSHRefVal, SRValPAInd, SRSub24Val, SRValDat47,   *
      *             SRValDate, SRExmpThVl, SRAuLnVal, SRPrCVal,       *
      *             SRDIDPlcVl, SRAuHVal, SRIsDtVal                   *
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
     C                   PARM                    RespMode
      *
      ** Customer Details of Screen 2
      *
     C                   PARM                    CustDet2
      *
      ** Customer
      *
     C                   PARM                    DDCUST
      *
      ** Country of Domicile                                                                AR739532
      *                                                                                     AR739532
     C                   PARM                    DDCOLC                                     AR739532
      ** Branch                                                                             AR740758
     C                   PARM                    DDBRCD                                     AR740758
      ** Country of Tax                                                                     AR740758
     C                   PARM                    V_CCTXArr                                  AR740758
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ***Tax*Identification*Number*************************************                     BUG24346
      ** Identification Type                                                                BUG24346
      *
     C**********         PARM                    DDTINO                                     BUG24346
     C                   PARM                    DDIDTP                                     BUG24346
      *
      ** Switchable Features
      *
     C                   PARM                    CER047
     C                   PARM                    CER048
     C                   PARM                    CER054                                     BUG24714
      *
      ** Outputs
      *
      ** Customer Details OK inds
      *
     C                   PARM                    OKCustDet2
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
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    WIdx
      *
      ** Valid Customer Details layout (DS) from/to caller
      *
     C                   PARM                    ValidDet
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM                    DfltFlag                                   BUG23883
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      PRtcd
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
      *                                                                                       CER054
      ** Check if CER054 is enabled                                                           CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS                                           CER054
     C                             AND PRtcd <> '*NRF'                                      BUG25876
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBASE = 902                                                CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
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
