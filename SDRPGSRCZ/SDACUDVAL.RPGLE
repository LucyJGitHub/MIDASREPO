     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDVAL - Transactions  Details Validation                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD044093           Date 18Apr17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD022651           Date 10Oct13               *
      *                 CLE134             Date 01Aug12               *
      *                 263285             Date 15Jan10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22589           Date 04Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250804A            Date 11Oct07               *
      *                 BUG14672           Date 23Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 08Jun07               *
      *                 BUG10069           Date 25Jan06               *
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD044093 - The Country of TIN is already defined for this    *
      *             customer                                          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022651 - Impossible to amend additional customer details   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  263285 - Issuer Code Missing from Screen                     *
      *         - Error message USR9901 encountered on Customer Main- *
      *           tenance. Removed checking of CGL032 for validation  *
      *           of Addtional Customer Details. Fix Patterned from   *
      *           CSW207-FIX03 on R4.                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22589 - Identification Type,Issuing Date,Country of Birth *
      *             were blank                                        *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250804A - Correct defaulting of additional customer details  *
      *           from main customer details.                         *
      *  BUG14672 - Some fields in Addtional Customer details are not *
      *             saved                                             *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  CSD029 - Customer Details Additional Fields.                 *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
                                                                                            BUG10069
      ** Hook to enable non-core files to be included
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDACUDPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)
     D                                     PREFIX(DD)
 
      ** Valid Transaction Details layout
     D ValidCust     E DS                  EXTNAME(SDVACUDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Country Details                                                      232543
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  232543
                                                                                              232543
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for SAR Details                                                          CSD029
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD029
                                                                                              CSD029
      ** Midas SD Midas modules Data Structure                                                CSW207
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSW207
                                                                                              CSW207
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for *Entry
     D RespMode        S              1A
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PKey1           S             10A                                                      232543
     D PKySt           S              7A                                                      232543
     D CGL032          S              1A
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D PDate           S              8A
     D PTaxStat        S              1A                                                      232543
     D PJACType        S              1A                                                      232543
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D CSD029          S              1A                                                      CSD029
     D CSW207          S              1A                                                      CSW207
     D CER047          S              1A                                                    BUG22589
     D CLE134          S              1A                                                      CLE134
     D CER050          S              1A                                                      CER050
 
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
 
      ** Validate Tax Identification NUmber
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCTINO
     C                   EXSR      SRVCTXCC
     C                   ENDIF
 
      ** Validate Joint Account Type
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCJATP
     C                   ENDIF
 
      ** Validate Indentification Type
 
     C**********         IF        CGL032 = 'Y'                                               CER034
     C**********                   OR CSW207 = 'Y'                                   BUG14672 CER034
     C                   IF        CSW207 = 'Y'                                               CER034
     C                             OR CGL032 = 'Y'                                          BUG22589
     C                             OR CER047 = 'Y'                                          BUG22589
     C                   EXSR      SRVCIDTP
     C                   ENDIF
 
      ** Validate Issuing Country
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCISCT
     C                   ENDIF
 
      ** Validate Issuing Date
 
     C**********         IF        CGL032 = 'Y'                                               CER034
     C**********                   OR CSW207 = 'Y'                                   BUG14672 CER034
     C                   IF        CSW207 = 'Y'                                               CER034
     C                             OR CGL032 = 'Y'                                          BUG22589
     C                             OR CER047 = 'Y'                                          BUG22589
     C                   EXSR      SRVCISDT
     C                   ENDIF
 
      ** Validate Alternative Number
 
     C                   EXSR      SRVCALTN
 
      ** Validate Fax Number
 
     C                   EXSR      SRVCFXNB
 
      ** Validate Identity Number
 
     C                   EXSR      SRVCIDNO
 
      ** Validate Telex Number
 
     C                   EXSR      SRVCTXNB
 
      ** Validate Date of Birth
 
     C                   EXSR      SRVCDATE
 
      ** Validate Provisional Opening
 
     C                   EXSR      SRVCPRVO
 
      ** Validate Date of Last Visit
 
     C                   EXSR      SRVCDOLV
 
      ** Validate Mail Details
 
     C                   EXSR      SRVCMDTL
 
      ** Validate Country of Birth
 
     C**********         IF        CGL032 = 'Y'                                               CER034
     C**********                   OR CSW207 = 'Y'                                   BUG14672 CER034
     C                   IF        CSW207 = 'Y'                                               CER034
     C                             OR CGL032 = 'Y'                                          BUG22589
     C                             OR CER047 = 'Y'                                          BUG22589
     C                   EXSR      SRVCBTHC
     C                   ENDIF
 
      ** Validate Town of Birth
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCBTHT
     C                   ENDIF
 
      ** Validate Family Name
 
     C                   EXSR      SRVCCNA1
 
      ** Validate First Name
 
     C                   EXSR      SRVCCNA2
 
      ** Validate Street of Residence 1
 
     C                   EXSR      SRVCCNA3
 
      ** Validate Street of Residence 2
 
     C                   EXSR      SRVCCNA4
 
      ** Validate Zip Code
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCZIPC
     C                   ENDIF
 
      ** Validate City
 
     C**********         IF        CGL032 = 'Y'                                               263285
     C**********                   OR CSW207 = 'Y'                                   BUG14672 263285
     C                   IF        CSW207 = 'Y'                                               263285
     C                   EXSR      SRVCCITY
     C                   ENDIF
 
      ** Validate Issuer Code                                                                 CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EXSR      SRVCISCD                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Validate Basel II Past Due Customer                                                  CLE134
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EXSR      VCPDCU                                                     CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Validate Code Word
 
     C                   EXSR      SRVCCWLD
                                                                                              CER050
      ** Validate APR Flag                                                                    CER050
      *                                                                                       CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   Exsr      SRVAPR                                                     CER050
     C                   Endif                                                                CER050
 
      ** Fill up other fields
 
     C                   EXSR      SROthers
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCTINO - Validate Tax Identification Number                 *
      *****************************************************************
     C     SRVCTINO      BEGSR
 
      ** No validation needed as the field is free format
 
     C                   EVAL      ACTINO = DDTINO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCTXCC - Crosscheck Between Tax Identification No.          *
      *          ID Type, Issuing Country, Issuing Date, Date of Birth*
      *          Country of Birth, Town of Birth                      *
      *****************************************************************
     C     SRVCTXCC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Retrieve Country of Location                                                         232543
     C                   Eval      PKey1 = DDCUST                                             232543
                                                                                              232543
     C                   CALL      'AOCUSTR0'                                                 232543
     C                   PARM      *Blanks       PRtcd                                        232543
     C                   PARM      '*KEY   '     POptn                                        232543
     C                   PARM                    PKey1                                        232543
     C                   PARM                    PKySt                                        232543
     C     SDCUST        PARM      SDCUST        DSSDY                                        232543
                                                                                              232543
      ** Database Error                                                                       232543
                                                                                              232543
     C                   IF        PRtcd <> *BLANKS                                           232543
                                                                                            BUG10069
      ** Check the shadow file.                                                             BUG10069
                                                                                            BUG10069
     C     DDCUST        CHAIN     SDCDSHL1                                                 BUG10069
                                                                                            BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        232543
     C                   EVAL      DBASE  =  901                                              232543
     C                   EVAL      DBKEY  = POptn                                             232543
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      *PSSR                                                      232543
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Validate Crosscheck
 
     C                   CALLB     'SDVTXCC01'
 
      **Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDCUST
     C                   PARM                    DDTINO
     C                   PARM                    DDDBTH
     C                   PARM                    DDBTHC
     C                   PARM                    DDBTHT
     C                   PARM                    BBCOLC                                       232543
     C                   PARM      DDJATP        PJACType                                     232543
 
      ** Outputs
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
      ** Date of Birth - OK
      ** Country of Birth - OK
      ** Town of Birth - OK
      ** Tax Status                                                                           232543
     C                   PARM                    DDOKTINO
     C                   PARM                    DDOKDBTH
     C                   PARM                    DDOKBTHC
     C                   PARM                    DDOKBTHT
     C                   PARM                    PTaxStat                                     232543
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCJATP - Validate Joint Account Type                        *
      *****************************************************************
     C     SRVCJATP      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Joint Account Type
 
     C                   CALLB     'SDVJACT01'
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDCUST
     C     ACJATP        PARM                    DDJATP
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Joint A/C Type - OK
     C                   PARM                    DDOKJATP
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCIDTP - Validate Identification Type                       *
      *****************************************************************
     C     SRVCIDTP      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Identification Type
 
     C                   CALLB     'SDVIDTP01'
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDTINO
     C     ACIDTP        PARM                    DDIDTP
     C                   PARM                    DDIDNO                                     MD044093
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Identification Type - OK
     C                   PARM                    DDOKIDTP
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCISCT - Validate Issuing Country                           *
      *****************************************************************
     C     SRVCISCT      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Issuing Country
 
     C                   CALLB     'SDVICTR01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDTINO
     C     ACISCT        PARM                    DDISCT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Country - OK
     C                   PARM                    DDOKISCT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCISDT - Validate Issuing Date                              *
      *****************************************************************
     C     SRVCISDT      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Issuing Date
 
     C                   CALLB     'SDVIDAT01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDTINO
     C                   PARM                    DDISDT
 
      ** Outputs
      ** Issuing Date in Midas Day Number
 
     C                   PARM                    ACISDT
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Date - OK
     C                   PARM                    DDOKISDT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCALTN - Validate Alternative Number                        *
      *****************************************************************
     C     SRVCALTN      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Alternative Number - OK
 
     C                   EVAL      DDOKALTN = 'Y'
     C                   EVAL      ACALTN = DDALTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCFXNB - Validate Fax Number                                *
      *****************************************************************
     C     SRVCFXNB      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Fax Number - OK
 
     C                   EVAL      DDOKFXNB = 'Y'
     C                   EVAL      ACFXNB = DDFXNB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCIDNO - Validate Identity Number                           *
      *****************************************************************
     C     SRVCIDNO      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Identity Number - OK
 
     C                   EVAL      DDOKIDNO = 'Y'
     C                   EVAL      ACIDNO = DDIDNO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCTXNB - Validate Telex Number                              *
      *****************************************************************
     C     SRVCTXNB      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Telex Number - OK
 
     C                   EVAL      DDOKTXNB = 'Y'
     C                   EVAL      ACTXNB = DDTXNB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCDATE - Validate Date of Birth                             *
      *****************************************************************
     C     SRVCDATE      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Date of Birth
 
     C                   CALLB     'SDVDBTH01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C     ACDBTH        PARM      DDDBTH        PDate
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Birth - OK
     C                   PARM                    DDOKDBTH
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCPRVO - Validate Provisional Opening                       *
      *****************************************************************
     C     SRVCPRVO      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Provisional Opening
 
     C                   CALLB     'SDVPROP01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C     ACPRVO        PARM                    DDPRVO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Provisional Opening - OK
     C                   PARM                    DDOKPRVO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCDOLV - Validate Date of Last Visit                        *
      *****************************************************************
     C     SRVCDOLV      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Date of Last Visit
 
     C                   CALLB     'SDVDALV01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDDOLV
 
      ** Outputs
      ** Issuing Date in Midas Day Number
 
     C                   PARM                    ACDOLV
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Last Visit - OK
     C                   PARM                    DDOKDOLV
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCMDTL - Validate Mail Details                              *
      *****************************************************************
     C     SRVCMDTL      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Mail Details - OK
 
     C                   EVAL      DDOKMDTL = 'Y'
     C                   EVAL      ACMDTL = DDMDTL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCBTHC - Validate Country of Birth                          *
      *****************************************************************
     C     SRVCBTHC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Country of Birth
 
     C                   CALLB     'SDVCBTH01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C     ACBTHC        PARM                    DDBTHC
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Country of Birth - OK
     C                   PARM                    DDOKBTHC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCBTHT - Validate Town of Birth                             *
      *****************************************************************
     C     SRVCBTHT      BEGSR
 
      ** No validation needed as the field is free format
 
     C                   EVAL      ACBTHT = DDBTHT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCCNA1 - Validate Family Name                               *
      *****************************************************************
     C     SRVCCNA1      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Family Name
 
     C                   CALLB     'SDVFAMI01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDCUST
     C     ACCNA1        PARM                    DDCNA1
     C                   PARM                    PTaxStat                                     232543
     C                   PARM      DDJATP        PJACType                                     232543
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Family Name - OK
     C                   PARM                    DDOKCNA1
 
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCCNA2 - Validate First Name                                *
      *****************************************************************
     C     SRVCCNA2      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate First Name
 
     C                   CALLB     'SDVFIRS01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDCUST                                      250804A
     C     ACCNA2        PARM                    DDCNA2
     C                   PARM                    PTaxStat                                     232543
     C                   PARM      DDJATP        PJactype                                     232543
                                                                                            MD022651
      ** Action Code                                                                        MD022651
                                                                                            MD022651
     C                   PARM                    DDACTN                                     MD022651
 
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** First Name - OK
     C                   PARM                    DDOKCNA2
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCCNA3 - Validate Street of Residence 1                     *
      *****************************************************************
     C     SRVCCNA3      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Street of Residence 1
 
     C                   CALLB     'SDVSTR101'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDCUST
     C     ACCNA3        PARM                    DDCNA3
     C                   PARM                    PTaxStat                                     232543
     C                   PARM      DDJATP        PJACType                                     232543
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Street of Residence 1- OK
     C                   PARM                    DDOKCNA3
 
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCCNA4 - Validate Street of Residence 2                     *
      *****************************************************************
     C     SRVCCNA4      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Street of Residence 2
 
     C                   CALLB     'SDVSTR201'
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
     C                   PARM                    DDCUST
     C     ACCNA4        PARM                    DDCNA4
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Street of Residence - OK
     C                   PARM                    DDOKCNA4
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCCITY - Validate City                                      *
      *****************************************************************
     C     SRVCCITY      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate City
 
     C                   CALLB     'SDVCITY01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDCUST
     C     ACCITY        PARM                    DDCITY
     C                   PARM                    PTaxStat                                     232543
     C                   PARM      DDJATP        PJACType                                     232543
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** City - OK
     C                   PARM                    DDOKCITY
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCZIPC - Validate Zip Code                                  *
      *****************************************************************
     C     SRVCZIPC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRRESETERRS
 
      ** Validate Zip Code
 
     C                   CALLB     'SDVZIPC01'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C     ACZIPC        PARM                    DDZIPC
     C                   PARM                    PTaxStat                                     232543
     C                   PARM      DDJATP        PJACType                                     232543
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Zip Code - OK
     C                   PARM                    DDOKZIPC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCISCD - Validate Issuer Code                               *                       CSW207
      *****************************************************************                       CSW207
     C     SRVCISCD      BEGSR                                                                CSW207
                                                                                              CSW207
      ** Reset variables updated by validation                                                CSW207
                                                                                              CSW207
     C                   EXSR      SRRESETERRS                                                CSW207
                                                                                              CSW207
      ** Validate Issuer Code                                                                 CSW207
                                                                                              CSW207
     C                   CALLB     'SDVISCP01'                                                CSW207
                                                                                              CSW207
      ** Inputs                                                                               CSW207
      ** Return Code                                                                          CSW207
     C                   PARM                    RetCodeIn                                    CSW207
                                                                                              CSW207
      ** Other parms                                                                          CSW207
      ** Identification Type                                                                  CSW207
     C                   PARM                    DDIDTP                                       CSW207
      ** Issuer Code                                                                          CSW207
     C     ACISCD        PARM                    DDISCD                                       CSW207
                                                                                              CSW207
      ** Outputs                                                                              CSW207
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW207
     C                   PARM                    FldNamXAr                                    CSW207
     C                   PARM                    MsgIDXAr                                     CSW207
     C                   PARM                    MsgDtaXAr                                    CSW207
                                                                                              CSW207
      ** Issuer Code - OK                                                                     CSW207
     C                   PARM                    DDOKISCD                                     CSW207
                                                                                              CSW207
      ** Update error info with that returned from the validation module                      CSW207
                                                                                              CSW207
     C                   EXSR      SRUPDATERRS                                                CSW207
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      * SRVCCWLD - Validate Code Word                                 *
      *****************************************************************
     C     SRVCCWLD      BEGSR
 
      ** No validation needed as the field is free format
 
      ** Word Code - OK
     C                   EVAL      DDOKCWL1 = 'Y'
     C                   EVAL      DDOKCWL2 = 'Y'
     C                   EVAL      DDOKCWL3 = 'Y'
     C                   EVAL      DDOKCWL4 = 'Y'
     C                   EVAL      DDOKCWL5 = 'Y'
     C                   EVAL      ACCWL1 = DDCWL1
     C                   EVAL      ACCWL2 = DDCWL2
     C                   EVAL      ACCWL3 = DDCWL3
     C                   EVAL      ACCWL4 = DDCWL4
     C                   EVAL      ACCWL5 = DDCWL5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SROthers - Fill up other fields                               *
      *****************************************************************
     C     SROthers      BEGSR
 
     C                   EVAL      ACCUST = DDCUST
     C                   EVAL      ACLCD = BJRDNB
     C                   EVAL      ACTYLC = DDACTN
                                                                                              CSD029
     C                   IF        CSD029 = 'Y'                                               CSD029
     C                   EVAL      ACFL01 = DDF001                                            CSD029
     C                   EVAL      ACFL02 = DDF002                                            CSD029
     C                   EVAL      ACFL03 = DDF003                                            CSD029
     C                   EVAL      ACFL04 = DDF004                                            CSD029
     C                   EVAL      ACFL05 = DDF005                                            CSD029
     C                   EVAL      ACFL06 = DDF006                                            CSD029
     C                   EVAL      ACFL07 = DDF007                                            CSD029
     C                   EVAL      ACFL08 = DDF008                                            CSD029
     C                   EVAL      ACFL09 = DDF009                                            CSD029
     C                   EVAL      ACFL10 = DDF010                                            CSD029
     C                   ENDIF                                                                CSD029
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE134
      ** Validate Basel II Past Due Customer                                                  CLE134
      *****************************************************************                       CLE134
     C     VCPDCU        BEGSR                                                                CLE134
      *                                                                                       CLE134
      ** Reset variables updated by each module                                               CLE134
      *                                                                                       CLE134
     C                   EXSR      SRRESETERRS                                                CLE134
      *                                                                                       CLE134
      ** Validate Basel II Past Due Customer                                                  CLE134
      *                                                                                       CLE134
     C                   CALLB     'SDVPDCU'                                                  CLE134
      *                                                                                       CLE134
      ** INPUTS                                                                               CLE134
      *                                                                                       CLE134
      ** Return Code                                                                          CLE134
      *                                                                                       CLE134
     C                   PARM                    RetCodeOut                                   CLE134
      *                                                                                       CLE134
      ** Basel II Past Due Customer (1A)                                                      CLE134
      *                                                                                       CLE134
     C     ACPDCU        PARM                    DDPDCU                                       CLE134
      *                                                                                       CLE134
      ** OUTPUTS                                                                              CLE134
      *                                                                                       CLE134
      ** Error fields/message IDs/message data (arrays) from/to caller                        CLE134
      *                                                                                       CLE134
     C                   PARM                    FldNamXAr                                    CLE134
     C                   PARM                    MsgIDXAr                                     CLE134
     C                   PARM                    MsgDtaXAr                                    CLE134
      *                                                                                       CLE134
      ** Basel II Past Due Customer - OK                                                      CLE134
      *                                                                                       CLE134
     C                   PARM                    DDOKPDCU                                     CLE134
      *                                                                                       CLE134
      ** Update error info with that returned from the validation module                      CLE134
      *                                                                                       CLE134
     C                   EXSR      SRUPDATERRS                                                CLE134
      *                                                                                       CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CER050
      /EJECT                                                                                  CER050
      *****************************************************************                       CER050
      ** Validate APR flag                                                                    CER050
      *****************************************************************                       CER050
     C     SRVAPR        BEGSR                                                                CER050
      *                                                                                       CER050
      ** Reset variables updated by each module                                               CER050
      *                                                                                       CER050
     C                   EXSR      SRRESETERRS                                                CER050
      *                                                                                       CER050
      ** Validate APR Flag                                                                    CER050
      *                                                                                       CER050
     C                   CALLB     'SDVAPRC'                                                  CER050
      *                                                                                       CER050
      ** INPUTS                                                                               CER050
      ** Return Code                                                                          CER050
     C                   PARM                    RetCodeOut                                   CER050
      ** Customer                                                                             CER050
     C                   PARM                    DDCUST                                       CER050
      ** APR Flag                                                                             CER050
     C     ACAPRC        PARM                    DDAPRC                                       CER050
      ** OUTPUTS                                                                              CER050
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER050
     C                   PARM                    FldNamXAr                                    CER050
     C                   PARM                    MsgIDXAr                                     CER050
     C                   PARM                    MsgDtaXAr                                    CER050
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER050
     C                   PARM                    WFldNmXAr                                    CER050
     C                   PARM                    WMsgIDXAr                                    CER050
     C                   PARM                    WMsgDtXAr                                    CER050
      ** APR flag - OK                                                                        CER050
     C                   PARM                    DDOKAPRC                                     CER050
      *                                                                                       CER050
      ** Update error info with that returned from the validation module                      CER050
      *                                                                                       CER050
     C                   EXSR      SRUPDATERRS                                                CER050
      *                                                                                       CER050
     C                   ENDSR                                                                CER050
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************
      * SRRESETERRS - Reset error information that is received back   *
      *    from each validation module.                               *
      *****************************************************************
     C     SRRESETERRS   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDATERRS - Update error information with that received back*
      *    from each validation module.                               *
      *****************************************************************
     C     SRUPDATERRS   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I                 3 0
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
     C                   PARM                    RespMode
 
      ** Transaction Details
     C                   PARM                    TrnDets
 
      ** Switchable feature CGL032
     C                   PARM                    CGL032
 
      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidCust
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
                                                                                              CSW207
      ** Check if Private Banking is switched on:                                             CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM      '*DBERR'      PRtCd                                        CSW207
     C                   PARM      '*FIRST '     POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBASE = 902                                                CSW207
     C                   EVAL      DBKEY  = POptn                                             CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSD029
      ** Check if CSD029 is enabled                                                           CSD029
                                                                                              CSD029
     C                   CALL      'AOSARDR0'                                                 CSD029
     C                   PARM      *Blanks       PRtcd                                        CSD029
     C                   PARM      '*VERIFY'     POptn                                        CSD029
     C                   PARM      'CSD029'      PSard                                        CSD029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD029
                                                                                              CSD029
     C                   EVAL      CSD029 = 'N'                                               CSD029
     C     PRTCD         IFEQ      *BLANKS                                                    CSD029
     C                   EVAL      CSD029 = 'Y'                                               CSD029
     C                   ELSE                                                                 CSD029
     C     PRTCD         IFNE      *BLANKS                                                    CSD029
     C     PRTCD         ANDNE     '*NRF   '                                                  CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD029
     C                   EVAL      DBKEY = 'CSD029'                                           CSD029
     C                   EVAL      DBASE = 901                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ENDIF                                                                CSD029
     C                   ENDIF                                                                CSD029
 
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if CER047 is enabled                                                         BUG22589
                                                                                            BUG22589
     C                   CALL      'AOSARDR0'                                               BUG22589
     C                   PARM      *Blanks       PRtcd                                      BUG22589
     C                   PARM      '*VERIFY'     POptn                                      BUG22589
     C                   PARM      'CER047'      PSard                                      BUG22589
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22589
                                                                                            BUG22589
     C                   EVAL      CER047 = 'N'                                             BUG22589
     C     PRTCD         IFEQ      *BLANKS                                                  BUG22589
     C                   EVAL      CER047 = 'Y'                                             BUG22589
     C                   ELSE                                                               BUG22589
     C     PRTCD         IFNE      *BLANKS                                                  BUG22589
     C     PRTCD         ANDNE     '*NRF   '                                                BUG22589
     C     *LOCK         IN        LDA                                                      BUG22589
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG22589
     C                   EVAL      DBKEY = 'CER047'                                         BUG22589
     C                   EVAL      DBASE = 901                                              BUG22589
     C                   OUT       LDA                                                      BUG22589
     C                   EXSR      *PSSR                                                    BUG22589
     C                   ENDIF                                                              BUG22589
     C                   ENDIF                                                              BUG22589
                                                                                            BUG22589
      ** Check if CLE134 is enabled                                                           CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *Blanks       PRtcd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSard                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C     PRTCD         IFEQ      *BLANKS                                                    CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ELSE                                                                 CLE134
     C     PRTCD         IFNE      *BLANKS                                                    CLE134
     C     PRTCD         ANDNE     '*NRF   '                                                  CLE134
     C     *LOCK         IN        LDA                                                        CLE134
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE134
     C                   EVAL      DBKEY = 'CLE134'                                           CLE134
     C                   EVAL      DBASE = 903                                                CLE134
     C                   OUT       LDA                                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Check if CER050 is enabled                                                           CER050
                                                                                              CER050
     C                   CALL      'AOSARDR0'                                                 CER050
     C                   Parm      *Blanks       PRtcd                                        CER050
     C                   Parm      '*VERIFY'     POptn                                        CER050
     C                   Parm      'CER050'      PSard                                        CER050
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER050
                                                                                              CER050
     C                   Eval      CER050 = 'N'                                               CER050
     C     PRTCD         Ifeq      *Blanks                                                    CER050
     C                   Eval      CER050 = 'Y'                                               CER050
     C                   Endif                                                                CER050
                                                                                              CER050
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'SDACUDVAL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
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
 
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
