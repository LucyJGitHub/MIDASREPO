     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Primary Validation')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHL2VL - Non-A/C Holders Primary Details Validation       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026541           Date 29Apr14               *
      *                 CGL132             Date 01May13               *
      *                 MD022651           Date 10Oct13               *
      *                 AR978528           Date 21May12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26384           Date 13Oct09               *
      *                 BUG25533           Date 19Aug09               *
      *                 BUG25531           Date 14Aug09               *
      *                 BUG24346           Date 16Jun09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22863           Date 12Jan09               *
      *                 BUG22580           Date 02Feb09               *
      *                 BUG22801           Date 11Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16741           Date 18Mar08               *
      *                 250804A            Date 11Oct07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233004             Date 12Apr05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026541 - Field "Title" should be optional and not mandatory*
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD022651 - Impossible to amend additional customer details   *
      *  AR978528 - No defaulting from Customer should be done.       *
      *             (Child:AR978529)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26384 - Input in 'Federal State Code' is missing          *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
/*    *  BUG25531 - Incorrect EU tax calculation                      *
/*    *  BUG24346 - Change validation from tax ID to Identification   *
/*    *             type                                              *
      *  CER054 - German Features - Church Tax                        *
/*    *  BUG22863 - Expiry Date must be equal to or greater than      *
/*    *             system run date  (Recompile)                      *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *  BUG22801 - No validation errors                              *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16741 - Family name and street 2 not defaulting values    *
      *  250804A - Correct defaulting of additional customer details  *
      *           from main customer details.                         *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                              CER054
      ** State Codes Keyed by States                                                          CER054
     FSDGESTL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
                                                                                              CER054
      ** Religious Affiliation Codes Keyed by Religious Affiliation                           CER054
     FSDRLAFL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
 
      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDPV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WBDate          DS
     D  WBX                    1      2
     D  WBY                    3      4
     D  WBYear                 5      8
 
      ** Non-A/C Holder Primary Details in screen format
     D NaPrim        E DS                  Extname(SDNAHLPD)
 
      ** Non-A/C Holder Primary Details OK indicators
     D OKNaPrim      E DS                  Extname(SDENAHLPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
 
      ** External DS for Midas modules                                                        CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
                                                                                              CSW207
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** Valid Non-A/C Holder Details layout
     D ValidNaho     E DS                  Extname(SDVNAHLPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ExtData         S            500A
 
     D*CGL032***       S              1A
 
     D Retcd           S              7A
 
     D Option          S              7A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D I               S              3  0
     D RespMode        S              1
     D PTaxStatus      S              1                                                       232543
     D PJACTdummy      S              1                                                       233004
 
     D PDBTH           S                   LIKE(DDDBTH)
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
     D wPrivBank       S              1A   INZ('N')                                           CSW207
 
     D CER047          S              1A                                                      CER047
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
     D PReturnCd       S              6A                                                      CER047
     D PFldNm          S             10A                                                      CER047
      *                                                                                       CER047
      ** Parameter fields for AOSARDR0                                                        CER047
      *                                                                                       CER047
     D PRtcd           S              7A                                                      CER047
     D POptn           S              7A                                                      CER047
     D PSard           S              6A                                                      CER047
     D Err             S              2  0                                                  BUG22801
     D DDCUST          S              6A                                                    BUG25531
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Pass data not requiring validation to ValidNaho fields
 
      ** Tax Identification Number
      ** Place of Birth - Town
      ** Mailing Address 3
      ** Mailing Address 4
 
      *                                                                                       CER047
      ** Pass data not requiring validation to ValidNaho fields, If                           CER047
      ** CER047 is ON                                                                         CER047
      ** Person Title                                                                         CER047
      ** Maiden Name                                                                          CER047
      ** Issued Place                                                                         CER047
      ** Remark                                                                               CER047
      ** Pass data not requiring validation to ValidNaho fields, if                           CER048
      ** CER048 is ON                                                                         CER048
      ** Maiden Name                                                                          CER048
      *                                                                                       CER047
     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C**********         EVAL      NATITL = DDTITL                                     CER047 CER048
     C                   EVAL      NAMDNM = DDMDNM                                            CER047
     C**********         EVAL      NAISUP = DDISUP                                     CER047 CER048
     C                   EVAL      NARMK1 = DDRMK1                                            CER047
     C                   EVAL      NARMK2 = DDRMK2                                            CER047
     C                   EVAL      NARMK3 = DDRMK3                                            CER047
     C                   EVAL      NASHNM = DDSHNM                                            CER047
     C                   EVAL      NAPHON = DDPHON                                            CER047
      *                                                                                       CER048
     C                   IF        CER048 = 'N'                                               CER048
     C                   EVAL      NATITL = DDTITL                                            CER048
     C                   EVAL      NAISUP = DDISUP                                            CER048
     C                   EVAL      NADOCN = DDDOCN                                            CER047
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    CER048 = 'Y'                                               CER048
     C                   EVAL      NAMDNM = DDMDNM                                            CER048
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   MOVE      DDTINO        NATINO
     C                   MOVE      DDBTHT        NABTHT
     C                   MOVE      DDCNA3        NACNA3
     C                   MOVE      DDCNA4        NACNA4
 
      ** Validate Non-A/C Holder Report Name
 
     C                   EXSR      SRVcNarn
 
      ** Validate Non-A/C Holder Report Town
 
     C                   EXSR      SRVcNatw
 
      ** Validate Private Individual
 
     C                   EXSR      SRVcPInd
 
      ** Validate Identification Type
 
     C                   EXSR      SRVcIdTp
 
      ** Validate Issuing Country
 
     C                   EXSR      SRVcIsCt
 
      ** Validate Issuing Date
 
     C                   EXSR      SRVcIsDt
 
      ** Validate Country of Residence
 
     C                   EXSR      SRVcColC
 
      ** Validate Date of Birth
 
     C                   EXSR      SRVcDate
 
      ** Validate Place of Birth - Country
 
     C                   EXSR      SRVcBthC
 
      ** Perform crosscheck of tax details
 
     C                   EXSR      SRVtXCk
 
      ** Validate Mailing Name and Address (Lines 1-2)
 
     C                   EXSR      SRVccN12
 
      ** Validate Family Name
 
     C                   EXSR      SRVcIde1
 
      ** Validate First Name
 
     C                   EXSR      SRVcIde2
 
      ** Validate Street 1
 
     C                   EXSR      SRVcIde3
 
      ** Validate Street 2                                                                  BUG16741
                                                                                            BUG16741
     C                   EXSR      SRVcIde4                                                 BUG16741
                                                                                            BUG16741
      ** Validate Zip Code
 
     C                   EXSR      SRVcZipC
 
      ** Validate City
 
     C                   EXSR      SRVcCity
                                                                                              CSW207
      ** Validate Issuing Authority                                                           CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' or wPrivBank = 'Y'                            CSW207
     C                   EXSR      SRVcIssAut                                                 CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL132
      ** Validate Country of Citizenship                                                      CGL132
      ** Validate Alternative Country of Citizenship                                          CGL132
      ** Validate TIN                                                                         CGL132
      ** Validate Country of TIN                                                              CGL132
      ** Validate Creation Date                                                               CGL132
     C                   EXSR      SRVcCocz                                                   CGL132
     C                   EXSR      SRVcAccz                                                   CGL132
     C                   EXSR      SRVcTin1                                                   CGL132
     C                   EXSR      SRVcCTIN                                                   CGL132
     C                   EXSR      SRVcCrdt                                                   CGL132
 
     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
      ** Validate Industry Code                                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRIcod                                                     CER047
      *                                                                                       CER047
      ** Validate Expiry Date                                                                 CER047
      *                                                                                       CER047
     C                   EXSR      SRExpDt                                                    CER047
      *                                                                                       CER047
      ** Validate Country of Domicile                                                         CER047
      *                                                                                       CER047
     C                   EXSR      SRCDom                                                     CER047
      *                                                                                       CER047
      ** Validate Country of Citizenship                                                      CER047
      *                                                                                       CER047
     C                   EXSR      SRCitz                                                     CER047
      *                                                                                       CER047
      ** Validate Spouse Reference                                                            CER047
      *                                                                                       CER047
     C                   EXSR      SRSRef                                                     CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Validate  Title                                                                      CER048
      *                                                                                       CER048
     C                   EXSR      SRTitl                                                     CER048
      *                                                                                       CER048
      ** Validate  Document No.                                                               CER048
      *                                                                                       CER048
     C                   EXSR      SRDocn                                                     CER048
      *                                                                                       CER048
      ** Validate  Issued Place                                                               CER048
      *                                                                                       CER048
     C                   EXSR      SRIsup                                                     CER048
      *                                                                                       CER048
     C                   IF        CER047 = 'N'                                               CER048
      *                                                                                       CER048
      ** Validate  Industry Code                                                              CER048
      *                                                                                       CER048
     C                   EXSR      SRIcod                                                     CER048
      *                                                                                     BUG22580
      ** Validate Spouse Reference                                                          BUG22580
      *                                                                                     BUG22580
     C                   EXSR      SRSRef                                                   BUG22580
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
      ***Validate**State*Code                                                        CER054 BUG24714
      ** Validate Religious Affiliation                                                     BUG24714
      *                                                                                       CER054
     C                   EXSR      SrRLAF                                                     CER054
     C                   ENDIF                                                              BUG24714
      *                                                                                       CER054
      ***Validate*Religious*Affiliation                                              CER054 BUG24714
      ** Validate State Code                                                                BUG24714
      *                                                                                       CER054
     C                   IF        CER048 = 'Y'                                             BUG24714
     C                   EXSR      SrSTCD                                                     CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcNarn - Validate Non-A/C Holder Report Name
      *****************************************************************
 
     C     SRVcNarn      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Non-A/C Holder report name
 
     C                   CALLB     'SDVRENM'
 
      ** INPUTS
      ** Return Code
      ** Non-A/C Holder Report Name
 
     C                   PARM                    RetCodeOut
     C     NANARN        PARM                    DDNARN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Non-A/C Holder Report Name - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKNARN
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcNatw - Validate Non-A/C Holder Report Town
      *****************************************************************
     C     SRVcNatW      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Non-A/C Holder Report Town
 
     C                   CALLB     'SDVREDE'
 
      ** INPUTS
      ** Return Code
      ** Non-A/C Holder Report Town
 
     C                   PARM                    RetCodeOut
     C     NANATW        PARM                    DDNATW
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Non-A/C Holder Report Town - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKNATW
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcPInd - Validate Private Individual
      *****************************************************************
     C     SRVcPInd      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Identification Type
 
     C                   CALLB     'SDVPIND01'
 
      ** INPUTS
      ** Return Code
      ** Identification Type
 
     C                   PARM                    RetCodeOut
     C     NAPIND        PARM                    DDPIND
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Identification Type - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKPIND
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIdTp - Validate Identification Type
      *****************************************************************
     C     SRVcIdTp      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Identification Type
 
     C                   CALLB     'SDVIDTP01'
 
      ** INPUTS
      ** Return Code
      ** Identification Type
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDTINO
     C     NAIDTP        PARM                    DDIDTP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Identification Type - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKIDTP
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIsCt - Validate Issuing Country
      *****************************************************************
     C     SRVcIsCt      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Issuing Country
 
     C                   CALLB     'SDVICTR01'
 
      ** INPUTS
      ** Return Code
      ** Tax Identification Number
      ** Issuing Country
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDTINO
     C     NAISCT        PARM                    DDISCT
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Issuing Country - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKISCT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIsDt - Validate Issuing Date
      *****************************************************************
     C     SRVcIsDt      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Issuing Date
 
     C                   CALLB     'SDVIDAT01'
 
      ** INPUTS
      ** Return Code
      ** Issuing Date
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDTINO
     C                   PARM                    DDISDT
 
      ** OUTPUTS
      ** Issuing Date in Midas Day No
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Issuing Date - OK
 
     C                   PARM                    NAISDT
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKISDT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcDate - Validate Date of Birth
      *****************************************************************
     C     SRVcDate      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Reformat Date of Birth.
 
     C                   EVAL      WBDate = DDDBTH
 
     C                   IF        BJDFIN = 'D'
     C                   EVAL      PDBTH = WBYear + WBY + WBX
     C                   ELSE
     C                   EVAL      PDBTH = WBYear + WBX + WBY
     C                   ENDIF
 
      ** Validate Date of Birth
 
     C                   CALLB     'SDVDBTH01'
 
      ** INPUTS
      ** Return Code
      ** Date of Birth
 
     C                   PARM                    RetCodeOut
     C     NADBTH        PARM                    PDBTH
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Date of Birth - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKDBTH
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcBthC - Validate Place of Birth - Country
      *****************************************************************
     C     SRVcbthC      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Place of Birth - Country
 
     C                   CALLB     'SDVCBTH01'
 
      ** INPUTS
      ** Return Code
      ** Place of Birth - Country
 
     C                   PARM                    RetCodeOut
     C     NABTHC        PARM                    DDBTHC
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Place of Birth - Country - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKBTHC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVTxCk - Perform crosscheck of tax details
      *****************************************************************
     C     SRVTxCk       BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Perform crosscheck of tax details
 
     C                   CALLB     'SDVTXCK01'
 
      ** INPUTS
      ** Return Code
      ** Tax Identification Number
      ** Identification Type
      ** Issuing Country
      ** Issuing Date
      ** Date of Birth
      ** Place of Birth - Country
      ** Place of Birth - Town
      ***Error*Field*Name                                                                     232543
      ** Non-a/c Holder Reference                                                             232543
      ** Country of Residence                                                                 232543
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDTINO
     C                   PARM                    DDIDTP
     C                   PARM                    DDISCT
     C                   PARM                    DDISDT
     C                   PARM                    DDDBTH
     C                   PARM                    DDBTHC
     C                   PARM                    DDBTHT
     C                   PARM                    DDNAHO                                       232543
     C                   Parm                    DDCOLC
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Tax details - OK
      ** Tax Status                                                                           232543
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKDBTH
     C                   PARM                    OKBTHC
     C                   PARM                    OKBTHT
     C                   PARM                    OKTINO
     C                   PARM                    PTaxStatus                                   232543
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcColC - Validate Country of Residence
      *****************************************************************
     C     SRVcColC      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Country of Residence
 
     C                   CALLB     'SDVCNDI'
 
      ** INPUTS
      ** Return Code
      ** Country of Residence
 
     C                   PARM                    RetCodeOut
     C     NACOLC        PARM                    DDCOLC
     C                   PARM                    DDCUST                                     BUG25531
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Country of Residence - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCOLC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVccN12 - Mailing Name and Address (Lines 1-2)
      *****************************************************************
     C     SRVccN12      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Mailing Name and Address (Lines 1-2)
 
     C                   CALLB     'SDVCADD01'
 
      ** INPUTS
      ** Return Code
      ** Mailing Name and Address 1
      ** Mailing Name and Address 2
 
     C                   PARM                    RetCodeOut
     C     NACNA1        PARM                    DDCNA1
     C     NACNA2        PARM                    DDCNA2
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Mailing Name and Address 1 - OK
      ** Mailing Name and Address 2 - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCNA1
     C                   PARM                    OKCNA2
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIde1 - Validate Familiy Name
      *****************************************************************
     C     SRVcIde1      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Family Name
 
     C                   CALLB     'SDVFAMI02'
 
      ** INPUTS
      ** Return Code
      ** Familiy Name
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCNA1
     C     NAIDE1        PARM                    DDIDE1
     C                   PARM                    PTaxStatus                                   232543
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Familiy Name - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKIDE1
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIde2 - Validate First Name
      *****************************************************************
     C     SRVcIde2      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate First Name
 
     C                   CALLB     'SDVFIRS01'
 
      ** INPUTS
      ** Return Code
      ** First Name
 
     C                   PARM                    RetCodeOut
     C**********         PARM                    DDCUST            6                250804A AR978528
     C                   PARM      *Blank        DDCUST            6                        AR978528
     C     NAIDE2        PARM                    DDIDE2
     C                   PARM                    PTaxStatus                                   232543
     C                   PARM      *Blank        PJACTdummy                                   233004
                                                                                            MD022651
      ** Action Code                                                                        MD022651
                                                                                            MD022651
     C                   PARM                    DDACTN                                     MD022651
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** First Name - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKIDE2
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcIde3 - Validate Street 1
      *****************************************************************
     C     SRVcide3      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Street 1
 
     C                   CALLB     'SDVSTR102'
 
      ** INPUTS
      ** Return Code
      ** Street 1
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCNA2
     C     NAIDE3        PARM                    DDIDE3
     C                   PARM                    PTaxStatus                                   232543
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Street 1 - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKIDE3
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************                     BUG16741
      /EJECT                                                                                BUG16741
      *****************************************************************                     BUG16741
      ** SRVcIde4 - Validate Street 2                                                       BUG16741
      *****************************************************************                     BUG16741
     C     SRVcide4      BEGSR                                                              BUG16741
                                                                                            BUG16741
      ** Reset variables updated by each module                                             BUG16741
                                                                                            BUG16741
     C                   EXSR      SRResetErrs                                              BUG16741
                                                                                            BUG16741
      ** Validate Street 2                                                                  BUG16741
                                                                                            BUG16741
     C                   CALLB     'SDVSTR202'                                              BUG16741
                                                                                            BUG16741
      ** INPUTS                                                                             BUG16741
      ** Return Code                                                                        BUG16741
      ** Street 2                                                                           BUG16741
                                                                                            BUG16741
     C                   PARM                    RetCodeOut                                 BUG16741
     C     NAIDE4        PARM                    DDIDE4                                     BUG16741
     C                   PARM                    DDCNA3                                     BUG16741
                                                                                            BUG16741
      *                                                                                     BUG16741
      ** OUTPUTS                                                                            BUG16741
      ** Error fields/message IDs/message data (arrays) from/to caller                      BUG16741
      ** Street 2 - OK                                                                      BUG16741
      *                                                                                     BUG16741
     C                   PARM                    FldNamXAr                                  BUG16741
     C                   PARM                    MsgIDXAr                                   BUG16741
     C                   PARM                    MsgDtaXAr                                  BUG16741
     C                   PARM                    OKIDE4                                     BUG16741
                                                                                            BUG16741
      ** Update error info with that returned from the validation module                    BUG16741
                                                                                            BUG16741
     C                   EXSR      SRUpdatErrs                                              BUG16741
                                                                                            BUG16741
     C                   ENDSR                                                              BUG16741
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcZipC - Validate Zip Code
      *****************************************************************
     C     SRVcZipC      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate Zip Code
 
     C                   CALLB     'SDVZIPC01'
 
      ** INPUTS
      ** Return Code
      ** Zip Code
 
     C                   PARM                    RetCodeOut
     C     NAZIPC        PARM                    DDZIPC
     C                   PARM                    PTaxStatus                                   232543
     C                   PARM      *Blank        PJACTdummy                                   233004
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Zip Code - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKZIPC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcCity - Validate City
      *****************************************************************
     C     SRVcCity      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Validate City
 
     C                   CALLB     'SDVCITY02'
 
      ** INPUTS
      ** Return Code
      ** Country of Location (2A)
 
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCNA4
     C     NACITY        PARM                    DDCITY
     C                   PARM                    PTaxStatus                                   232543
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Branch Indicator - OK
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCITY
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      ** SRVcIssAut - Validate Issuing Authority                                              CSW207
      *****************************************************************                       CSW207
     C     SRVcIssAut    BEGSR                                                                CSW207
                                                                                              CSW207
      ** Reset variables updated by each module                                               CSW207
                                                                                              CSW207
     C                   EXSR      SRResetErrs                                                CSW207
                                                                                              CSW207
      ** Validate Issuing Authority                                                           CSW207
                                                                                              CSW207
     C                   CALLB     'SDVISSAUT'                                                CSW207
                                                                                              CSW207
      ** INPUTS                                                                               CSW207
      ** Return Code                                                                          CSW207
      ** Issuing Authority                                                                    CSW207
                                                                                              CSW207
     C                   PARM                    RetCodeOut                                   CSW207
     C     NAISAU        PARM                    DDISAU                                       CSW207
     C                   PARM                    PTaxStatus                                   CSW207
     C                   PARM      *Blank        PJACTdummy                                   CSW207
                                                                                              CSW207
      ** OUTPUTS                                                                              CSW207
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW207
      ** Zip Code - OK                                                                        CSW207
                                                                                              CSW207
     C                   PARM                    FldNamXAr                                    CSW207
     C                   PARM                    MsgIDXAr                                     CSW207
     C                   PARM                    MsgDtaXAr                                    CSW207
     C                   PARM                    OKISAU                                       CSW207
     C                   PARM                    DDIDTP                                       CSW207
                                                                                              CSW207
      ** Update error info with that returned from the validation module                      CSW207
                                                                                              CSW207
     C                   EXSR      SRUpdatErrs                                                CSW207
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
      *****************************************************************
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRVcCocz - Validate Country of Citizenship                                           CGL132
      *****************************************************************                       CGL132
     C     SRVcCocz      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Reset variables updated by each module                                               CGL132
                                                                                              CGL132
     C                   EXSR      SRResetErrs                                                CGL132
                                                                                              CGL132
      ** Validate Country of Citizenship                                                      CGL132
                                                                                              CGL132
     C                   CALLB     'SDVCOCZ'                                                  CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Return Code                                                                          CGL132
      ** Country of Citizenship                                                               CGL132
                                                                                              CGL132
     C                   PARM                    RetCodeOut                                   CGL132
     C     NACOCZ        PARM                    DDCOCZ                                       CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Country of Citizenship - OK                                                          CGL132
                                                                                              CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
     C                   PARM                    OKCOCZ                                       CGL132
                                                                                              CGL132
      ** Update error info with that returned from the validation module                      CGL132
                                                                                              CGL132
     C                   EXSR      SRUpdatErrs                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRVcAccz - Validate Alternative Country of Citizenship                               CGL132
      *****************************************************************                       CGL132
     C     SRVcAccz      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Reset variables updated by each module                                               CGL132
                                                                                              CGL132
     C                   EXSR      SRResetErrs                                                CGL132
                                                                                              CGL132
      ** Validate Alternative Country of Citizenship                                          CGL132
                                                                                              CGL132
     C                   CALLB     'SDVACCZ1'                                                 CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Return Code                                                                          CGL132
      ** Alternative Country of Citizenship                                                   CGL132
      ** Country of Citizenship                                                               CGL132
                                                                                              CGL132
     C                   PARM                    RetCodeOut                                   CGL132
     C     NAACCZ        PARM                    DDACCZ                                       CGL132
     C                   PARM                    DDCOCZ                                       CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Alternative Country of Citizenship - OK                                              CGL132
                                                                                              CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
     C                   PARM                    OKACCZ                                       CGL132
                                                                                              CGL132
      ** Update error info with that returned from the validation module                      CGL132
                                                                                              CGL132
     C                   EXSR      SRUpdatErrs                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRVcTin1 - Validate TIN                                                              CGL132
      *****************************************************************                       CGL132
     C     SRVcTin1      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Reset variables updated by each module                                               CGL132
                                                                                              CGL132
     C                   EXSR      SRResetErrs                                                CGL132
                                                                                              CGL132
      ** Validate TIN                                                                         CGL132
                                                                                              CGL132
     C                   CALLB     'SDVTIN1'                                                  CGL132
      ** INPUTS                                                                               CGL132
      ** Return Code                                                                          CGL132
     C                   PARM                    RetCodeOut                                   CGL132
      ** TIN                                                                                  CGL132
     C                   PARM                    DDTINO                                       CGL132
      ** TIN2                                                                                 CGL132
     C     NATIN2        PARM                    DDTIN2                                       CGL132
      ** TIN3                                                                                 CGL132
     C     NATIN3        PARM                    DDTIN3                                       CGL132
      ** TIN4                                                                                 CGL132
     C     NATIN4        PARM                    DDTIN4                                       CGL132
      ** TIN5                                                                                 CGL132
     C     NATIN5        PARM                    DDTIN5                                       CGL132
      ** Country of TIN 2                                                                     CGL132
     C                   PARM                    DDCTIN2                                      CGL132
      ** Country of TIN 3                                                                     CGL132
     C                   PARM                    DDCTIN3                                      CGL132
      ** Country of TIN 4                                                                     CGL132
     C                   PARM                    DDCTIN4                                      CGL132
      ** Country of TIN 5                                                                     CGL132
     C                   PARM                    DDCTIN5                                      CGL132
      ** OUTPUTS                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
      ** TIN - OK                                                                             CGL132
     C                   PARM                    OKTINO                                       CGL132
      ** TIN 2 - OK                                                                           CGL132
     C                   PARM                    OKTIN2                                       CGL132
      ** TIN 3 - OK                                                                           CGL132
     C                   PARM                    OKTIN3                                       CGL132
      ** TIN 4 - OK                                                                           CGL132
     C                   PARM                    OKTIN4                                       CGL132
      ** TIN 5 - OK                                                                           CGL132
     C                   PARM                    OKTIN5                                       CGL132
                                                                                              CGL132
      ** Update error info with that returned from the validation module                      CGL132
                                                                                              CGL132
     C                   EXSR      SRUpdatErrs                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRVcCTIN - Validate Country of TIN                                                   CGL132
      *****************************************************************                       CGL132
     C     SRVcCTIN      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Reset variables updated by each module                                               CGL132
                                                                                              CGL132
     C                   EXSR      SRResetErrs                                                CGL132
                                                                                              CGL132
      ** Validate Country of TIN                                                              CGL132
                                                                                              CGL132
     C                   CALLB     'SDVCTIN'                                                  CGL132
      ** INPUTS                                                                               CGL132
      ** Return Code                                                                          CGL132
     C                   PARM                    RetCodeOut                                   CGL132
      ** TIN2                                                                                 CGL132
     C                   PARM                    DDTIN2                                       CGL132
      ** TIN3                                                                                 CGL132
     C                   PARM                    DDTIN3                                       CGL132
      ** TIN4                                                                                 CGL132
     C                   PARM                    DDTIN4                                       CGL132
      ** TIN5                                                                                 CGL132
     C                   PARM                    DDTIN5                                       CGL132
      ** Country of Domicile                                                                  CGL132
     C                   PARM                    DDCOLC                                       CGL132
      ** Country of TIN 2                                                                     CGL132
     C     NACTIN2       PARM                    DDCTIN2                                      CGL132
      ** Country of TIN 3                                                                     CGL132
     C     NACTIN3       PARM                    DDCTIN3                                      CGL132
      ** Country of TIN 4                                                                     CGL132
     C     NACTIN4       PARM                    DDCTIN4                                      CGL132
      ** Country of TIN 5                                                                     CGL132
     C     NACTIN5       PARM                    DDCTIN5                                      CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
      ** Country of Domicile - OK                                                             CGL132
     C                   PARM                    OKCOLC                                       CGL132
      ** Country of TIN 2 - OK                                                                CGL132
     C                   PARM                    OKCTIN2                                      CGL132
      ** Country of TIN 3 - OK                                                                CGL132
     C                   PARM                    OKCTIN3                                      CGL132
      ** Country of TIN 4 - OK                                                                CGL132
     C                   PARM                    OKCTIN4                                      CGL132
      ** Country of TIN 5 - OK                                                                CGL132
     C                   PARM                    OKCTIN5                                      CGL132
                                                                                              CGL132
      ** Update error info with that returned from the validation module                      CGL132
                                                                                              CGL132
     C                   EXSR      SRUpdatErrs                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRVcCrdt - Validate Creation Date                                                    CGL132
      *****************************************************************                       CGL132
     C     SRVcCrdt      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Reset variables updated by each module                                               CGL132
                                                                                              CGL132
     C                   EXSR      SRResetErrs                                                CGL132
                                                                                              CGL132
      ** Validate Creation Date                                                               CGL132
                                                                                              CGL132
     C                   CALLB     'SDVCRDT1'                                                 CGL132
      ** INPUTS                                                                               CGL132
      ** Return Code                                                                          CGL132
     C                   PARM                    RetCodeOut                                   CGL132
      ** Creation Date                                                                        CGL132
     C                   PARM                    DDCRDT                                       CGL132
      ** Action Code                                                                          CGL132
     C                   PARM                    DDACTN                                       CGL132
      ** Run Day Number                                                                       CGL132
     C                   PARM                    BJRDNB                                       CGL132
      ** Date Format                                                                          CGL132
     C                   PARM                    BJDFIN                                       CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
     C                   PARM                    FldNamXAr                                    CGL132
     C                   PARM                    MsgIDXAr                                     CGL132
     C                   PARM                    MsgDtaXAr                                    CGL132
      ** Creation Date                                                                        CGL132
     C                   PARM                    NACRDT                                       CGL132
      ** Creation Date - OK                                                                   CGL132
     C                   PARM                    OKCRDT                                       CGL132
                                                                                              CGL132
      ** Update error info with that returned from the validation module                      CGL132
                                                                                              CGL132
     C                   EXSR      SRUpdatErrs                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT
      *****************************************************************                       CER047
      * SRIcod - Validate Industry Code                               *                       CER047
      *                                                               *                       CER047
      * Called By - Main Processing                                   *                       CER047
      *                                                               *                       CER047
      * Calls - None                                                  *                       CER047
      *****************************************************************                       CER047
     C     SRIcod        BEGSR                                                                CER047
      *                                                                                       CER047
      ** Reset variables updated by each module                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRResetErrs                                                CER047
      *                                                                                       CER047
     C                   CALLB     'SDVINDCOD'                                                CER047
     C                   PARM                    RetCodeOut                                   CER047
     C     NAINDC        PARM                    DDINDC                                       CER047
     C                   PARM                    FldNamXAr                                    CER047
     C                   PARM                    MsgIDXAr                                     CER047
     C                   PARM                    MsgDtaXAr                                    CER047
     C                   PARM                    OKINDC                                       CER047
      *                                                                                       CER047
      ** Update error info with that returned from Validation Module                          CER047
      *                                                                                       CER047
     C                   EXSR      SRUpdatErrs                                                CER047
      *                                                                                       CER047
     C                   ENDSR                                                                CER047
      *****************************************************************                       CER047
      /EJECT                                                                                  CER047
      *****************************************************************                       CER047
      * SRExpDt - Validate Expiry Date                                *                       CER047
      *                                                               *                       CER047
      * Called By - Main Processing                                   *                       CER047
      *                                                               *                       CER047
      * Calls - None                                                  *                       CER047
      *****************************************************************                       CER047
     C     SRExpDt       BEGSR                                                                CER047
      *                                                                                       CER047
      ** Reset variables updated by each module                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRResetErrs                                                CER047
      *                                                                                       CER047
     C                   CALLB     'SDVEXPDT'                                                 CER047
     C                   PARM                    RetCodeOut                                   CER047
     C     NAEXDT        PARM                    DDEXDT                                       CER047
     C                   PARM                    BjRDNb                                       CER047
     C                   PARM                    BjDFIn                                       CER047
     C                   PARM                    FldNamXAr                                    CER047
     C                   PARM                    MsgIDXAr                                     CER047
     C                   PARM                    MsgDtaXAr                                    CER047
     C                   PARM                    OKEXDT                                       CER047
      *                                                                                       CER047
      ** Update error info with that returned from Validation Module                          CER047
      *                                                                                       CER047
     C                   EXSR      SRUpdatErrs                                                CER047
      *                                                                                       CER047
     C                   ENDSR                                                                CER047
      *****************************************************************                       CER047
      /EJECT                                                                                  CER047
      *****************************************************************                       CER047
      * SRCDom - Validate Country of Domicile                         *                       CER047
      *                                                               *                       CER047
      * Called By - Main Processing                                   *                       CER047
      *                                                               *                       CER047
      * Calls - None                                                  *                       CER047
      *****************************************************************                       CER047
     C     SRCDom        BEGSR                                                                CER047
      *                                                                                       CER047
      ** Reset variables updated by each module                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRResetErrs                                                CER047
      *                                                                                       CER047
     C                   CALLB     'SDVCNTRY'                                                 CER047
     C                   PARM                    RetCodeOut                                   CER047
     C     NACTYD        PARM                    DDCTYD                                       CER047
     C                   PARM                    FldNamXAr                                    CER047
     C                   PARM                    MsgIDXAr                                     CER047
     C                   PARM                    MsgDtaXAr                                    CER047
     C                   PARM      'DDCTYD'      PFldNm                                       CER047
     C                   PARM                    OKCTYD                                       CER047
      *                                                                                       CER047
      ** Update error info with that returned from Validation Module                          CER047
      *                                                                                       CER047
     C                   EXSR      SRUpdatErrs                                                CER047
      *                                                                                       CER047
     C                   ENDSR                                                                CER047
      *****************************************************************                       CER047
      /EJECT                                                                                  CER047
      *****************************************************************                       CER047
      * SRCitz -  Validate Country of Citizenship                     *                       CER047
      *                                                               *                       CER047
      * Called By - Main Processing                                   *                       CER047
      *                                                               *                       CER047
      * Calls - None                                                  *                       CER047
      *****************************************************************                       CER047
     C     SRCitz        BEGSR                                                                CER047
      *                                                                                       CER047
      ** Reset variables updated by each module                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRResetErrs                                                CER047
      *                                                                                       CER047
     C                   CALLB     'SDVCNTRY'                                                 CER047
     C                   PARM                    RetCodeOut                                   CER047
     C     NACTYC        PARM                    DDCTYC                                       CER047
     C                   PARM                    FldNamXAr                                    CER047
     C                   PARM                    MsgIDXAr                                     CER047
     C                   PARM                    MsgDtaXAr                                    CER047
     C                   PARM      'DDCTYC'      PFldNm                                       CER047
     C                   PARM                    OKCTYC                                       CER047
      *                                                                                       CER047
      ** Update error info with that returned from Validation Module                          CER047
      *                                                                                       CER047
     C                   EXSR      SRUpdatErrs                                                CER047
      *                                                                                       CER047
     C                   ENDSR                                                                CER047
      *****************************************************************                       CER047
      /EJECT                                                                                  CER047
      *****************************************************************                       CER047
      * SRSRef -  Validate Spouse Reference                           *                       CER047
      *                                                               *                       CER047
      * Called By - MAIN Processing                                   *                       CER047
      *                                                               *                       CER047
      * Calls - None                                                  *                       CER047
      *****************************************************************                       CER047
     C     SRSRef        BEGSR                                                                CER047
      *                                                                                       CER047
      ** Reset variables updated by each module                                               CER047
      *                                                                                       CER047
     C                   EXSR      SRResetErrs                                                CER047
      *                                                                                       CER047
     C                   CALLB     'SDVSPREF'                                                 CER047
     C                   PARM                    RetCodeOut                                   CER047
     C     NASREF        PARM                    DDSREF                                       CER047
     C                   PARM                    FldNamXAr                                    CER047
     C                   PARM                    MsgIDXAr                                     CER047
     C                   PARM                    MsgDtaXAr                                    CER047
     C                   PARM                    OKSREF                                       CER047
      *                                                                                       CER047
      ** Update error info with that returned from Validation Module                          CER047
      *                                                                                       CER047
     C                   EXSR      SRUpdatErrs                                                CER047
      *                                                                                       CER047
     C                   ENDSR                                                                CER047
      *****************************************************************                       CER047
      /EJECT                                                                                  CER047
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      * SRTitl - Validate Title                                       *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - None                                                  *                       CER048
      *****************************************************************                       CER048
     C     SRTitl        BEGSR                                                                CER048
      **********                                                                     CER048 MD026541
      ***Reset*variables updated by each Validation                                  CER048 MD026541
      **********                                                                     CER048 MD026541
     C**********         EXSR      SRResetErrs                                       CER048 MD026541
     C**********         EVAL      Err = *Zeros                                    BUG22801 MD026541
      **********                                                                     CER048 MD026541
     C**********         IF        DDTITL =  *BLANKS                                 CER048 MD026541
     C**********         EVAL      OKTITL = 'N'                                      CER048 MD026541
     C**********         EVAL      Idx = Idx +1                                      CER048 BUG22801
     C**********         EVAL      FldNamXAr(Idx) = 'DDTITL'                         CER048 BUG22801
     C**********         EVAL      MsgIdXAr(Idx)  = 'USR8266'                        CER048 BUG22801
     C**********         EVAL      Err = Err + 1                                   BUG22801 MD026541
     C**********         EVAL      FldNamXAr(Err) = 'DDTITL'                       BUG22801 MD026541
     C**********         EVAL      MsgIdXAr(Err)  = 'USR8266'                      BUG22801 MD026541
     C**********         ELSE                                                        CER048 MD026541
     C**********         EVAL      NATITL = DDTITL                                   CER048 MD026541
     C**********         ENDIF                                                       CER048 MD026541
      **********                                                                     CER048 MD026541
      ***Update*error info with that returned from Validation                        CER048 MD026541
      **********                                                                     CER048 MD026541
     C**********         EXSR      SRUpdatErrs                                       CER048 MD026541
      *                                                                                     MD026541
      ** No validation needed as the field is optional based on the CER048-FS               MD026541
      *                                                                                     MD026541
     C                   EVAL      NATITL = DDTITL                                          MD026541
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      * SRDocn - Validate Document No.                                *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - None                                                  *                       CER048
      *****************************************************************                       CER048
     C     SRDocn        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables updated by each Validation                                           CER048
      *                                                                                       CER048
     C                   EXSR      SRResetErrs                                                CER048
     C                   EVAL      Err = *Zeros                                             BUG22801
      *                                                                                       CER048
     C**********         IF        DDTINO = *BLANKS AND                              CER048 BUG24346
     C                   IF        DDIDTP = *BLANKS AND                                     BUG24346
     C                             DDDOCN <> *BLANKS                                          CER048
     C                   EVAL      OKDOCN = 'N'                                               CER048
     C**********         EVAL      Idx = Idx +1                                      CER048 BUG22801
     C**********         EVAL      FldNamXAr(Idx) = 'DDDOCN'                         CER048 BUG22801
     C**********         EVAL      MsgIdXAr(Idx)  = 'USR8267'                        CER048 BUG22801
     C                   EVAL      Err = Err + 1                                            BUG22801
     C                   EVAL      FldNamXAr(Err) = 'DDDOCN'                                BUG22801
     C                   EVAL      MsgIdXAr(Err)  = 'USR8267'                               BUG22801
      *                                                                                       CER048
     C**********         ELSEIF    DDTINO <> *BLANKS AND                             CER048 BUG24346
     C                   ELSEIF    DDIDTP <> *BLANKS AND                                    BUG24346
     C                             DDDOCN = *BLANKS                                           CER048
      *                                                                                       CER048
     C                   EVAL      OKDOCN = 'N'                                               CER048
     C**********         EVAL      Idx = Idx +1                                      CER048 BUG22801
     C**********         EVAL      FldNamXAr(Idx) = 'DDDOCN'                         CER048 BUG22801
     C**********         EVAL      MsgIdXAr(Idx)  = 'USR8268'                        CER048 BUG22801
     C                   EVAL      Err = Err + 1                                            BUG22801
     C                   EVAL      FldNamXAr(Err) = 'DDDOCN'                                BUG22801
     C                   EVAL      MsgIdXAr(Err)  = 'USR8268'                               BUG22801
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      NADOCN = DDDOCN                                            CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Update error info with that returned from Validation                                 CER048
      *                                                                                       CER048
     C                   EXSR      SRUpdatErrs                                                CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      * SRIsup - Validate Issued Place                                *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - None                                                  *                       CER048
      *****************************************************************                       CER048
     C     SRIsup        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables updated by each Validation                                           CER048
      *                                                                                       CER048
     C                   EXSR      SRResetErrs                                                CER048
     C                   EVAL      Err = *Zeros                                             BUG22801
      *                                                                                       CER048
     C**********         IF        DDTINO = *BLANKS AND                              CER048 BUG24346
     C                   IF        DDIDTP = *BLANKS AND                                     BUG24346
     C                             DDISUP <> *BLANKS                                          CER048
     C                   EVAL      OKISUP = 'N'                                               CER048
     C**********         EVAL      Idx = Idx + 1                                     CER048 BUG22801
     C**********         EVAL      FldNamXAr(Idx) = 'DDISUP'                         CER048 BUG22801
     C**********         EVAL      MsgIdXAr(Idx)  = 'USR8269'                        CER048 BUG22801
     C                   EVAL      Err = Err + 1                                            BUG22801
     C                   EVAL      FldNamXAr(Err) = 'DDISUP'                                BUG22801
     C                   EVAL      MsgIdXAr(Err)  = 'USR8269'                               BUG22801
      *                                                                                       CER048
     C**********         ELSEIF    DDTINO <> *BLANKS AND                             CER048 BUG24346
     C                   ELSEIF    DDIDTP <> *BLANKS AND                                    BUG24346
     C                             DDISUP = *BLANKS                                           CER048
      *                                                                                       CER048
     C                   EVAL      OKISUP = 'N'                                               CER048
     C**********         EVAL      Idx = Idx + 1                                     CER048 BUG22801
     C**********         EVAL      FldNamXAr(Idx) = 'DDISUP'                         CER048 BUG22801
     C**********         EVAL      MsgIdXAr(Idx)  = 'USR8270'                        CER048 BUG22801
     C                   EVAL      Err = Err + 1                                            BUG22801
     C                   EVAL      FldNamXAr(Err) = 'DDISUP'                                BUG22801
     C                   EVAL      MsgIdXAr(Err)  = 'USR8270'                               BUG22801
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      NAISUP = DDISUP                                            CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Update error info with that returned from Validation                                 CER048
      *                                                                                       CER048
     C                   EXSR      SRUpdatErrs                                                CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      * SrRLAF - Validate Religious Affiliation                       *                       CER054
      *                                                               *                       CER054
      * Called By - Main Processing                                   *                       CER054
      *                                                               *                       CER054
      * Calls - None                                                  *                       CER054
      *****************************************************************                       CER054
     C     SrRLAF        BEGSR                                                                CER054
      *                                                                                       CER054
      ** Reset variables updated by each Validation                                           CER054
      *                                                                                       CER054
     C                   EXSR      SRResetErrs                                                CER054
     C                   EVAL      Err = *Zeros                                               CER054
      *                                                                                       CER054
     C                   IF        DDRLAF = *BLANKS                                           CER054
     C                   EVAL      DDRLAF = 'NONE'                                            CER054
     C                   EVAL      OKRLAF = 'Y'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C     DDRLAF        CHAIN     SDRLAFL0                                                   CER054
     C                                                                                        CER054
     C                   IF        NOT %FOUND(SDRLAFL0)                                       CER054
     C                   EVAL      Err = Err + 1                                              CER054
     C                   EVAL      FldNamXAr(Err) = 'DDRLAF'                                  CER054
     C                   EVAL      MsgIdXAr(Err)  = 'USR8323'                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKRLAF = 'N'                                               CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKRLAF = 'Y'                                               CER054
     C                   EVAL      NARLAF = DDRLAF                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Update error info with that returned from Validation                                 CER054
      *                                                                                       CER054
     C                   EXSR      SRUpdatErrs                                                CER054
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      * SrSTCD - Validate State Code                                  *                       CER054
      *                                                               *                       CER054
      * Called By - Main Processing                                   *                       CER054
      *                                                               *                       CER054
      * Calls - None                                                  *                       CER054
      *****************************************************************                       CER054
     C     SrSTCD        BEGSR                                                                CER054
      *                                                                                       CER054
      ** Reset variables updated by each Validation                                           CER054
      *                                                                                       CER054
     C                   EXSR      SRResetErrs                                                CER054
     C                   EVAL      Err = *Zeros                                               CER054
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                             BUG24714
     C                   IF        DDRLAF <> *BLANKS AND                                      CER054
     C                             DDRLAF <> 'NONE'                                           CER054
      *                                                                                       CER054
     C                   IF        DDCOLC <> BJCNCD                                           CER054
     C                   EVAL      Err = Err + 1                                              CER054
     C                   EVAL      FldNamXAr(Err) = 'DDSTCD'                                  CER054
     C                   EVAL      MsgIdXAr(Err)  = 'USR8324'                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKSTCD = 'N'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C     DDSTCD        CHAIN     SDGESTL0                                                   CER054
     C                                                                                        CER054
     C                   IF        NOT %FOUND(SDGESTL0)                                       CER054
     C                   EVAL      Err = Err + 1                                              CER054
     C                   EVAL      FldNamXAr(Err) = 'DDSTCD'                                  CER054
     C                   EVAL      MsgIdXAr(Err)  = 'USR8322'                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKSTCD = 'N'                                               CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKSTCD = 'Y'                                               CER054
     C                   EVAL      NASTCD = DDSTCD                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ELSEIF    DDRLAF = 'NONE' AND                                        CER054
     C                             DDSTCD <> *BLANKS                                          CER054
     C                   EVAL      Err = Err + 1                                              CER054
     C                   EVAL      FldNamXAr(Err) = 'DDSTCD'                                  CER054
     C                   EVAL      MsgIdXAr(Err)  = 'USR9909'                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKSTCD = 'N'                                               CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      OKSTCD = 'Y'                                               CER054
     C                   EVAL      NASTCD = DDSTCD                                            CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
     C                   ELSE                                                               BUG24714
     C     DDSTCD        CHAIN     SDGESTL0                                                 BUG24714
      *                                                                                     BUG24714
     C                   IF        NOT %FOUND(SDGESTL0)                                     BUG24714
     C                   EVAL      Err = Err + 1                                            BUG24714
     C                   EVAL      FldNamXAr(Err) = 'DDSTCD'                                BUG24714
     C                   EVAL      MsgIdXAr(Err)  = 'USR8322'                               BUG24714
     C                   EVAL      OKSTCD = 'N'                                             BUG24714
 
     C                   ELSE                                                               BUG26384
                                                                                            BUG26384
     C                   EVAL      OKSTCD = 'Y'                                             BUG26384
     C                   EVAL      NASTCD = DDSTCD                                          BUG26384
      *                                                                                     BUG26384
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                       CER054
      ** Update error info with that returned from Validation                                 CER054
      *                                                                                       CER054
     C                   EXSR      SRUpdatErrs                                                CER054
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT                                                                                  CER048
      *****************************************************************
      ** SRResetErrs - Reset error information that is received back  *
      **    from each validation module.                              *
      *****************************************************************
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdatErrs - Update error information with that received back*
      **    from each validation module.                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Response mode
      ** Non-A/C Holder Details
      ** Non-A/C Holder Extra Data
 
     C                   PARM                    RespMode
     C                   PARM                    NaPrim
     C                   PARM                    ExtData
 
      ** OUTPUTS
      ** Non-A/C Holder Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Non-A/C Holder details layout (DS) from/to caller
 
     C                   PARM                    OKNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidNaho
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if Private Banking Module is available                                         CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM                    Retcd                                        CSW207
     C                   PARM      '*FIRST'      Option                                       CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        Retcd <> *Blanks                                           CSW207
     C                   MOVEL     'SDMMODPD'    Dbfile                                       CSW207
     C                   MOVEL     '902'         Dbase                                        CSW207
     C                   MOVEL     Option        Dbkey                                        CSW207
     C                   EXSR      SRERR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      wPrivBank = 'Y'                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
 
      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRtcd                                        CER047
     C                   PARM      '*VERIFY'     POptn                                        CER047
     C                   PARM      'CER047'      PSard                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
      *                                                                                       CER047
     C                   IF        PRtcd = *BLANKS                                            CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   ELSE                                                                 CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'N'                                               CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        ((PRtcd  <> *BLANKS) AND                                   CER047
     C                             (PRtcd <> '*NRF   '))                                      CER047
      *                                                                                       CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBase =  902                                               CER047
     C                   EVAL      DBkey =  'CER047'                                          CER047
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      *PSSR                                                      CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER048
     C                             (PRtcd <> '*NRF   '))                                      CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBase = 903                                                CER048
     C                   EVAL      DBkey =  'CER048'                                          CER048
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
      ** Call AOSARDR0 to check for CER054                                                    CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER054
     C                             (PRtcd <> '*NRF   '))                                      CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBase = 904                                                CER054
     C                   EVAL      DBkey =  'CER054'                                          CER054
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
 
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
 
      **  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDPV051
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     'SDNAHL2VL'   Dbpgm
     C                   MOVE      *On           *INU7
     C                   MOVE      *On           *INU8
     C                   MOVE      *On           *INLR
 
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
